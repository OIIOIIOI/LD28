package music;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.Lib;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.ui.Keyboard;
import haxe.Timer;
import openfl.Assets;
import ui.Button;
import ui.UIObject;

/**
 * ...
 * @author 01101101
 */

// TODO save to bitmap
// TODO help
// TODO spam mode

class MusicGame extends Sprite {
	
	public static var TOLERANCE_BEFORE:Int = 60;
	public static var TOLERANCE_AFTER:Int = 100;
	public static var SCALE:Int = 10;
	
	var trackASC:SoundChannel;
	var trackBSC:SoundChannel;
	
	var seq:Array<SndObj>;
	var part:Int;
	
	var head:Sprite;
	var track:Sprite;
	var recordButton:Button;
	var recording:Bool;
	var fading:Bool;
	
	var keys:Map<Int, Bool>;
	
	public function new () {
		super();
		
		var diff = "normal";
		if (Skills.instance.musicLevel == 3)	diff = "easy";
		var a = Assets.getText("snd/" + diff + ".txt").split(";");
		
		seq = new Array();
		part = 0;
		
		var total = 0.0;
		for (i in 0...a.length) {
			var so = new SndObj(i, a[i]);
			so.prevTotal = total;
			seq.push(so);
			total += so.length;
		}
		
		// Rails
		for (i in 0...3) {
			var t:MusicTrack = new MusicTrack();
			t.x = (MusicTrack.WIDTH + 10) * i;
			t.y = MusicTrack.WIDTH;
			addChild(t);
		}
		
		// Blocks
		track = new Sprite();
		addChild(track);
		draw();
		
		// Icons
		for (i in 0...3) {
			var s:Shape = new Shape();
			s.graphics.beginFill(0xFFFFFF, 0.5);
			s.graphics.drawRect(0, 0, MusicTrack.WIDTH, MusicTrack.WIDTH);
			s.graphics.endFill();
			s.x = (MusicTrack.WIDTH + 10) * i;
			addChild(s);
			var icon = new KeyIcon(i);
			icon.x = (MusicTrack.WIDTH + 10) * i;
			icon.y = 10;
			addChild(icon);
		}
		
		// Head
		head = new Sprite();
		head.graphics.beginFill(0x000000, 0.5);
		head.graphics.drawRect(0, -2, MusicTrack.WIDTH * 3 + MusicTrack.GUTTER * 2, 4);
		head.graphics.endFill();
		addChild(head);
		
		// Record
		recordButton = new Button(UIObject.getEmptyFrames(100, 40), 0xFFCC3333, 0xFF660000);
		recordButton.setText("Record");
		recordButton.x = -140;
		recordButton.y = -20;
		addChild(recordButton);
		
		registerKeys();
		
		fading = false;
		recording = false;
		recordButton.addEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == recordButton) {
			if (!recording)	play();
			else			stop();
		}
	}
	
	function play () {
		recording = true;
		
		for (snd in seq) {
			if (snd.index > 0)	snd.block.reset(true);
		}
		trackASC = SoundManager.play("snd/lead.mp3");
		trackBSC = SoundManager.play("snd/playback.mp3");
		trackBSC.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		//
		recordButton.setText("Stop");
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}
	
	public function stop () {
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		
		if (trackBSC != null) {
			trackBSC.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			trackBSC.stop();
			trackASC.stop();
		}
		
		recording = false;
		fading = false;
		
		for (snd in seq) {
			snd.block.reset();
		}
		track.alpha = 1;
		track.y = 0;
		
		part = 0;
		
		recordButton.setText("Record");
	}
	
	public function update () {
		if (recording) {
			// Update current part
			while (trackBSC.position > seq[part].prevTotal + seq[part].length + TOLERANCE_AFTER) {
				part++;
				// If part is not done yet, it is failed
				if (seq[part].result == 0) {
					trackASC.soundTransform = new SoundTransform(0);
					seq[part].block.done(false);
				}
			}
			// Scroll track
			var ratio = (trackBSC.position - seq[part].prevTotal) / seq[part].length;
			var newY = ratio * (seq[part].length / MusicGame.SCALE) + seq[part].prevTotal / MusicGame.SCALE;
			track.y = newY;
		} else if (fading) {
			track.alpha *= 0.95;
			if (track.alpha < 0.02) {
				endRecording();
			}
		}
	}
	
	function soundCompleteHandler (e:Event) {
		fading = true;
		recording = false;
	}
	
	function endRecording () {
		stop();
	}
	
	// Draw blocks
	function draw () {
		var yy:Float = 0;
		for (snd in seq) {
			var h = snd.length / SCALE;
			var block = new MusicBlock(snd, (snd.index == seq.length - 1));
			block.x = snd.inst * (MusicTrack.WIDTH + MusicTrack.GUTTER);
			block.y = -yy;
			// Hide and auto-win first block
			if (snd.index > 0)	track.addChild(block);
			else				snd.result = 1;
			snd.block = block;
			snd.pos = yy;
			// Inc
			yy += h;
		}
	}
	
	function registerKeys () {
		if (keys != null)	return;
		keys = new Map<Int, Bool>();
		keys.set(Keyboard.J, false);
		keys.set(Keyboard.K, false);
		keys.set(Keyboard.L, false);
	}
	
	function keyDownHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode)) {
			if (!keys.get(e.keyCode)) {
				keys.set(e.keyCode, true);
				checkAction(e.keyCode);
			}
		}
	}
	
	function keyUpHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode))	keys.set(e.keyCode, false);
	}
	
	function checkAction (key:UInt) {
		// If no more parts
		if (part == seq.length - 1) {
			trackASC.soundTransform = new SoundTransform(0);
			seq[part].block.done(false);
			return;
		}
		// If correct key AND in the BEFORE margin for next block, good
		var inst:Int = seq[part + 1].inst;
		if (key == getCorrectKey(inst) && trackBSC.position > seq[part].prevTotal + seq[part].length - TOLERANCE_BEFORE) {
			trackASC.soundTransform = new SoundTransform(SoundManager.GLOBAL_VOL);
			seq[part + 1].block.done();
		}
		// Else it is a fail of the current part
		else {
			trackASC.soundTransform = new SoundTransform(0);
			seq[part].block.done(false);
		}
	}
	
	public static function getCorrectKey (inst:Int) {
		// Get correct key
		var correctKey:UInt;
		if (Skills.instance.musicLevel > 1) {
			correctKey = switch (inst) {
				case 0:		Keyboard.J;
				case 1:		Keyboard.K;
				default:	Keyboard.L;
			}
		} else {
			correctKey = switch (inst) {
				case 0:		Keyboard.L;
				case 1:		Keyboard.J;
				default:	Keyboard.K;
			}
		}
		return correctKey;
	}
	
}

class SndObj {
	//static public var mini:Float = 999999;
	
	public var index:Int;
	public var length:Float;
	public var prevTotal:Float;
	public var pos:Float;
	public var inst:Int;
	public var type:Int;
	public var result:Int;
	public var block:MusicBlock;
	
	public function new (i:Int, s:String) {
		index = i;
		//
		var a = s.split(',');
		length = Std.parseFloat(a[0]);
		inst = Std.parseInt(a[1]);
		type = Std.parseInt(a[2]);
		result = 0;
		//if (length < mini)	mini = length;
	}
	
	public function toString () :String {
		return "index:" + index + ", length:" + length + ", prevTotal:" + prevTotal + ", inst:" + inst + ", type:" + type + ", result:" + result;
	}
	
}










