package music;

import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.Lib;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.ui.Keyboard;
import openfl.Assets;
import ui.Button;
import ui.UIObject;

/**
 * ...
 * @author 01101101
 */

class MusicGame extends Sprite {
	
	public static var TOLERANCE_BEFORE:Int = 85;
	public static var TOLERANCE_AFTER:Int = 100;
	public static var SCALE:Int = 10;
	
	var trackA:Sound;
	var trackB:Sound;
	var trackSC:SoundChannel;
	
	var seq:Array<SndObj>;
	var part:Int;
	
	var head:Sprite;
	var track:Sprite;
	var recordButton:Button;
	var recording:Bool;
	var fading:Bool;
	
	var keys:Map<Int, Key>;
	
	public function new () {
		super();
		
		trackA = Assets.getSound("snd/lead.mp3");
		trackB = Assets.getSound("snd/playback.mp3");
		
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
			recordButton.setActive(false, true);
			recording = true;
			play();
		}
	}
	
	function play () {
		trackA.play(0, 0, new SoundTransform(0.1));
		trackSC = trackB.play(0, 0, new SoundTransform(0.1));
		trackSC.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		//
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}
	
	public function update () {
		if (recording) {
			// Update current part
			while (trackSC.position > seq[part].prevTotal && part < seq.length - 1) {
				//seq[part].block.done();
				part++;
			}
			// Scroll track
			var ratio = (trackSC.position - seq[part].prevTotal) / seq[part].length;
			var newY = ratio * (seq[part].length / MusicGame.SCALE) + seq[part].prevTotal / MusicGame.SCALE;
			track.y = newY;
		} else if (fading) {
			track.alpha *= 0.9;
			if (track.alpha < 0.05) {
				endRecording();
			}
		}
		// Update keys
		for (k in keys) {
			k.justChanged = false;
		}
	}
	
	function soundCompleteHandler (e:Event) {
		fading = true;
		recording = false;
	}
	
	function endRecording () {
		fading = false;
		track.alpha = 1;
		track.y = 0;
		recordButton.setActive(true, true);
	}
	
	// Draw blocks
	function draw () {
		var yy:Float = 0;
		for (snd in seq) {
			var h = snd.length / SCALE;
			var block = new MusicBlock(snd);
			block.x = snd.inst * (MusicTrack.WIDTH + MusicTrack.GUTTER);
			block.y = -yy;
			track.addChild(block);
			//
			snd.block = block;
			snd.pos = yy;
			// Inc
			yy += h;
		}
	}
	
	function registerKeys () {
		if (keys != null)	return;
		keys = new Map<Int, Key>();
		keys.set(Keyboard.J, { down:false, justChanged:false, lastDown:0, lastUp:0 });
		keys.set(Keyboard.K, { down:false, justChanged:false, lastDown:0, lastUp:0 });
		keys.set(Keyboard.L, { down:false, justChanged:false, lastDown:0, lastUp:0 });
	}
	
	function keyDownHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode)) {
			if (!keys.get(e.keyCode).down) {
				keys.get(e.keyCode).down = true;
				keys.get(e.keyCode).justChanged = true;
				//keys.get(e.keyCode).lastDown = Timer.stamp() * 1000;
				keys.get(e.keyCode).lastDown = trackSC.position;
			}
		}
	}
	
	function keyUpHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode)) {
			keys.get(e.keyCode).down = false;
			keys.get(e.keyCode).justChanged = false;
			//keys.get(e.keyCode).lastUp = Timer.stamp() * 1000;
			keys.get(e.keyCode).lastUp = trackSC.position;
		}
	}
	
}

typedef Key = {
	var down:Bool;
	var justChanged:Bool;
	var lastDown:Float;
	var lastUp:Float;
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










