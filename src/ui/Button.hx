package ui;

import flash.geom.Rectangle;

/**
 * ...
 * @author 01101101
 */

class Button extends UIObject {
	
	public function new (frames:Array<Rectangle>) {
		super(frames);
		buttonMode = true;
	}
	
}