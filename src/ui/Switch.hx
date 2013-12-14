package ui;

import flash.events.MouseEvent;
import flash.geom.Rectangle;

/**
 * ...
 * @author 01101101
 */

class Switch extends Button {
	
	public function new (frames:Array<Rectangle>) {
		super(frames);
		addEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	function clickHandler (e:MouseEvent) {
		toggle();
	}
	
	// Manual toggle
	public function toggle () {
		if (current == 0)	current = 1;
		else				current = 0;
		render();
	}
	
}