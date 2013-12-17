package ;

import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import flash.errors.Error;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

class Clock {
	
	public static var instance:Clock;
	
	var mode:LDMode;
	
	var totalTime(default, null):Int;
	var timeLeft(default, null):Int;
	var paused(default, null):Bool;
	
	public var sprite:ClockSprite;
	public var skySprite:Sprite;
	
	public function new () {
		if (instance != null)	throw new Error("Already instanciated");
		instance = this;
		
		totalTime = timeLeft = 0;
		paused = true;
		
		sprite = new ClockSprite();
		skySprite = new Sprite();
		var b:Bitmap = new Bitmap(Assets.getBitmapData("img/dailydisc.png"), PixelSnapping.AUTO, true);
		b.x = -b.width / 2;
		b.y = -b.height / 2;
		skySprite.x = 299;
		skySprite.y = 325;
		skySprite.addChild(b);
	}
	
	public function setMode (mode:LDMode) {
		this.mode = mode;
		
		totalTime = timeLeft = switch (mode) {
			case LDMode.Compo:	48 * 360;
			case LDMode.Jam:	72 * 360;
		}
	}
	
	public function pause (p:Bool = true) {
		paused = p;
	}
	
	public function update (tick:Int = 1) {
		//tick = 12;
		if (mode == null)	return;
		if (!paused && timeLeft > 0) {
			timeLeft -= tick;
			if (timeLeft <= 0) {
				timeLeft = 0;
				trace("done");
			}
			sprite.update(tick);
			//
			skySprite.rotation += tick / 24;
		}
	}
	
	public function toTime () :String {
		var f = timeLeft / 360;
		var h = Std.int(f);
		var m = Std.int((f - h) * 60);
		return (h + " hours " + m + " minutes left");
	}
	
}

class ClockSprite extends Sprite {
	
	var hoursHand:Sprite;
	var minutesHand:Sprite;
	
	public function new () {
		super();
		
		var b:Bitmap = new Bitmap(Assets.getBitmapData("img/minutehand.png"), PixelSnapping.AUTO, true);
		b.x = -b.width / 2;
		b.y = -b.height + b.width / 2;
		minutesHand = new Sprite();
		minutesHand.addChild(b);
		addChild(minutesHand);
		
		b = new Bitmap(Assets.getBitmapData("img/hourhand.png"), PixelSnapping.AUTO, true);
		b.x = -b.width / 2;
		b.y = -b.height + b.width / 2;
		hoursHand = new Sprite();
		hoursHand.addChild(b);
		addChild(hoursHand);
	}
	
	public function update (tick:Int) {
		minutesHand.rotation += tick;
		hoursHand.rotation += tick / 12;
	}
	
}

enum LDMode {
	Compo;
	Jam;
}








