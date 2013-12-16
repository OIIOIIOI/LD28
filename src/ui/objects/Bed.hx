package ui.objects;

import flash.display.Bitmap;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

class Bed extends Object {
	
	public function new () {
		super();
		
		x = 722;
		y = 448;
		
		b = new Bitmap(Assets.getBitmapData("img/couette.png"));
		addChild(b);
	}
	
	override public function changeState () {
		b.bitmapData = Assets.getBitmapData("img/couette01.png");
		b.x = 28;
		b.y = -11;
	}
	
}