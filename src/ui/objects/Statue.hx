package ui.objects;

import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.display.Sprite;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

class Statue extends Object {
	
	var dir:Float;
	
	public function new () {
		super();
		
		x = 737;
		y = 485;
		
		b = new Bitmap(Assets.getBitmapData("img/corps.png"));
		addChild(b);
		
		b = new Bitmap(Assets.getBitmapData("img/tete.png"), PixelSnapping.NEVER, true);
		b.x = 23;
		b.y = -48;
		addChild(b);
		
		dir = -0.1;
	}
	
	override public function changeState () {
		dir = 0;
		b.bitmapData = Assets.getBitmapData("img/teteKO.png");
		b.x = 93;
		b.y = 39;
		addChildAt(b, 0);
	}
	
	override public function update () {
		if (dir != 0) {
			b.y += dir;
			if (dir < 0 && b.y < -49)		dir = -dir;
			else if (dir > 0 && b.y > -46)	dir = -dir;
		}
	}
	
}