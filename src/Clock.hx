package ;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.errors.Error;

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
	
	public function new () {
		if (instance != null)	throw new Error("Already instanciated");
		instance = this;
		
		totalTime = timeLeft = 0;
		paused = true;
		
		sprite = new ClockSprite();
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
		if (mode == null)	return;
		if (!paused && timeLeft > 0) {
			timeLeft -= tick;
			if (timeLeft <= 0)	timeLeft = 0;
			sprite.display(totalTime - timeLeft);
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
	
	var body:Sprite;
	var hoursHand:Sprite;
	var minutesHand:Sprite;
	
	public function new () {
		super();
		
		body = new Sprite();
		body.graphics.lineStyle(2);
		body.graphics.beginFill(0xFFFFFF);
		body.graphics.drawCircle(0, 0, 50);
		body.graphics.endFill();
		addChild(body);
		
		hoursHand = new Sprite();
		hoursHand.graphics.beginFill(0x000000);
		hoursHand.graphics.drawRect(-2, 2, 4, -25);
		hoursHand.graphics.endFill();
		addChild(hoursHand);
		
		minutesHand = new Sprite();
		minutesHand.graphics.beginFill(0x000000);
		minutesHand.graphics.drawRect(-1, 1, 2, -40);
		minutesHand.graphics.endFill();
		addChild(minutesHand);
	}
	
	public function display (t:Int) {
		var f = t / 360;
		var h = Std.int(f);
		var m = Std.int((f - h) * 60);
		
		while (h > 24)	h -= 24;
		
		var hRatio = h / 24;
		var mRatio = m / 60;
		// TODO Smooth rotation
		hoursHand.rotation = 360 * hRatio + (360 / 24 * mRatio);
		minutesHand.rotation = 360 * mRatio;
	}
	
}

enum LDMode {
	Compo;
	Jam;
}








