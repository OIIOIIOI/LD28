package ui.objects;

import flash.display.Bitmap;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

class Cat extends Object {
	
	public function new () {
		super();
		
		x = 848;
		y = 442;
		
		b = new Bitmap();
		addChild(b);
	}
	
	override public function changeState () {
		b.bitmapData = Assets.getBitmapData("img/cat.png");
	}
	
}