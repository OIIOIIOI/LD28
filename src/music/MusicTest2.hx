package music;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.ui.Keyboard;
import haxe.Timer;
import openfl.Assets;


/**
 * ...
 * @author 01101101
 */

class MusicTest2 extends Sprite {
	
	public static var TOLERANCE_BEFORE:Int = 60;//ms
	public static var TOLERANCE_AFTER:Int = 90;//ms
	
	var trackA:Sound;
	var trackASC:SoundChannel;
	var trackB:Sound;
	
	var seq:Array<SndObj>;
	var scale:Int;
	
	var head:Sprite;
	var track:Sprite;
	
	var part:Int;
	
	var keys:Map<Int, Key>;
	
	public function new () {
		super();
		
		x = 400;
		y = 100;
		scale = 10;
		
		trackA = Assets.getSound("snd/lead.wav");
		trackB = Assets.getSound("snd/playback.wav");
		
		var a = Assets.getText("snd/track.txt").split(",");
		a.splice(55, 1);// TODO remove this
		
		seq = new Array();
		
		var total = 0.0;
		for (i in 0...a.length) {
			var so = new SndObj(i, Std.parseFloat(a[i]));
			so.prevTotal = total;
			seq.push(so);
			total += so.length;
		}
		
		track = new Sprite();
		addChild(track);
		draw();
		
		part = 0;
		
		head = new Sprite();
		head.graphics.beginFill(0x000000);
		head.graphics.drawRect(-1, 0, 2, 120);
		head.graphics.endFill();
		addChild(head);
		
		registerKeys();
		
		Timer.delay(play, 1500);
	}
	
	function registerKeys () {
		if (keys != null)	return;
		keys = new Map<Int, Key>();
		keys.set(Keyboard.NUMPAD_0, { down:false, justChanged:false, lastDown:0, lastUp:0 });
	}
	
	function play () {
		trackASC = trackA.play(0, 0, new SoundTransform(0));
		trackB.play(0, 0, new SoundTransform(0.1));
		//
		addEventListener(Event.ENTER_FRAME, update);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}
	
	function update (e:Event) {
		while (trackASC.position > seq[part].prevTotal && part < seq.length - 1) {
			part++;
			Timer.delay(checkAction, TOLERANCE_AFTER);
		}
		var ratio = (trackASC.position - seq[part].prevTotal) / seq[part].length;
		var newX = ratio * (seq[part].length / scale) + seq[part].prevTotal / scale;
		track.x = -newX;
		//
		for (k in keys) {
			k.justChanged = false;
		}
	}
	
	function checkAction () {
		var ld = keys.get(Keyboard.NUMPAD_0).lastDown;
		var max = Timer.stamp() * 1000;
		var min = max - TOLERANCE_AFTER - TOLERANCE_BEFORE;
		//trace(min < ld && ld < max);
		if (min < ld && ld < max) {
			trackASC.soundTransform = new SoundTransform(0.1);
			feedback();
		} else {
			trackASC.soundTransform = new SoundTransform(0);
			feedback(false);
		}
	}
	
	function feedback (good:Bool = true) {
		head.graphics.clear();
		head.graphics.beginFill(0x000000);
		head.graphics.drawRect(-1, 0, 2, 120);
		head.graphics.endFill();
		if (good)	head.graphics.beginFill(0x00FF00);
		else		head.graphics.beginFill(0xFF0000);
		head.graphics.drawCircle(0, -10, 10);
		head.graphics.drawCircle(0, 130, 10);
		head.graphics.endFill();
	}
	
	function keyDownHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode)) {
			if (!keys.get(e.keyCode).down) {
				keys.get(e.keyCode).down = true;
				keys.get(e.keyCode).justChanged = true;
				keys.get(e.keyCode).lastDown = Timer.stamp() * 1000;
			}
		}
	}
	
	function keyUpHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode)) {
			keys.get(e.keyCode).down = false;
			keys.get(e.keyCode).justChanged = false;
			keys.get(e.keyCode).lastUp = Timer.stamp() * 1000;
		}
	}
	
	function draw () {
		var xx:Float = 0;
		for (snd in seq) {
			var w = snd.length / scale;
			var s = new Sprite();
			var c = switch (snd.inst) {
				case 0:		0xCC9900;
				case 1:		0x00CC00;
				default:	0x0099CC;
			}
			s.graphics.beginFill(c, 0.2);
			s.graphics.drawRect(0, 0, w, 40);
			s.graphics.endFill();
			s.graphics.beginFill(c);
			s.graphics.drawRect(0, 0, 4, 40);
			s.graphics.endFill();
			s.x = xx;
			s.y = snd.inst * s.height;
			track.addChild(s);
			//
			snd.posX = xx;
			// Inc
			xx += w;
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
	
	public var index:Int;
	public var length:Float;
	public var prevTotal:Float;
	public var posX:Float;
	public var inst:Int;
	
	public function new (i:Int, l:Float) {
		index = i;
		length = l;
		//
		inst = Std.random(3);
	}
	
}










