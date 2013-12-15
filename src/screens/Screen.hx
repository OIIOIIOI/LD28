package screens;

import flash.display.Sprite;

/**
 * ...
 * @author 01101101
 */

class Screen extends Sprite {
	
	public static var WIDTH:Int = 640;
	public static var HEIGHT:Int = 480;
	
	public function new () {
		super();
	}
	
	public function update () { }
	
	public function clean () {
		while (numChildren > 0) {
			removeChild(getChildAt(0));
		}
	}
	
}