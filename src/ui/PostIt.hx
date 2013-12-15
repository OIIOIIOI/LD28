package ui;

import flash.geom.Rectangle;

/**
 * ...
 * @author 01101101
 */

class PostIt extends UIObject {
	
	public function new (title:String, list:Array<String>) {
		super(UIObject.getEmptyFrames(130, 40 * (list.length + 1) + 10), 0xFFFFFF80, 0);
		// Set text
		setText(title, 0, 0, Main.FORMAT_BOLD);
		// Create buttons
		var b:Button;
		for (i in 0...list.length) {
			b = new Button(UIObject.getEmptyFrames(130, 40), 0, 0);
			b.setText(list[i], 0, 0, Main.FORMAT);
			b.y = (i + 1) * 40;
			addChild(b);
		}
		mouseChildren = true;
	}
	
}