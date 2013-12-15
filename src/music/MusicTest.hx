package music;

import flash.display.Sprite;
import flash.events.Event;
import flash.media.Sound;
import haxe.Timer;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

class MusicTest extends Sprite {
	
	var seq:Array<SoundObj>;
	var scale:Int;
	
	var head:Head;
	var index:Int;
	
	public function new () {
		super();
		
		x = y = 0;
		scale = 20;
		
		seq = new Array();
		for (i in 1...77) {
			seq.push(new SoundObj("snd/" + i + ".wav", 0));
			//trace(i + ": " + seq[seq.length - 1].url + "\t\t" + seq[seq.length - 1].sound.length + ",");
		}
		
		draw();
		
		index = 0;
		
		head = new Head();
		addChild(head);
		
		//addEventListener(Event.ENTER_FRAME, update);
		
		//Timer.delay(play, 3000);
	}
	
	function update (e:Event) {
		head.update();
	}
	
	function play () {
		seq[index].sound.play();
		head.x = seq[index].x;
		var l = seq[index].sound.length;
		var w = l / scale;
		head.setTarget(w, l);
		
		if (index < seq.length - 1) {
			Timer.delay(play, Math.ceil(l));
			index++;
		}
	}
	
	function draw () {
		var xx:Float = 0;
		for (snd in seq) {
			var w = snd.sound.length / scale;
			var s = new Sprite();
			var c = switch (snd.instru) {
				case 0:		0xEE0000;
				case 1:		0x00EE00;
				case 2:		0x0000EE;
				default:	0x000000;
			}
			s.graphics.beginFill(c, 0.2);
			s.graphics.drawRect(0, 0, w, 20);
			s.graphics.endFill();
			s.graphics.beginFill(c);
			s.graphics.drawRect(0, 0, 2, 20);
			s.graphics.endFill();
			snd.x = xx;
			s.x = xx;
			s.y = snd.instru * (s.height + 2);
			addChild(s);
			// Inc
			xx += w;
		}
	}
	
}

class SoundObj {
	
	public var url:String;
	public var sound:Sound;
	public var instru:Int;
	public var x:Float;
	
	public function new (src:String, inst:Int) {
		url = src;
		sound = Assets.getSound(src);
		instru = inst;
	}
	
}

class Head extends Sprite {
	
	var dx:Float;
	
	public function new () {
		super();
		
		dx = 0;
		
		graphics.beginFill(0x000000);
		graphics.drawRect(-1, 0, 2, 100);
		graphics.endFill();
	}
	
	public function setTarget (width:Float, time:Float) {
		// go WIDTH px in TIME ms at 60 fps
		var speed = width / (time / 1000);
		//trace(speed);
		dx = speed / 60;
	}
	
	public function update () {
		x += dx;
	}
	
}










