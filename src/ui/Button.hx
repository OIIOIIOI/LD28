package ui;

import flash.geom.Rectangle;

/**
 * ...
 * @author 01101101
 */

class Button extends UIObject {
	
	public function new (frames:Array<Rectangle>, bg:UInt = 0xFF999999, border:UInt = 0xFF666666) {
		super(frames, bg, border);
		buttonMode = true;
	}
	
}