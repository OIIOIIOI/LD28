package ui;

import flash.display.Bitmap;
import flash.display.PixelSnapping;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

class PostIt extends UIObject {
	
	var version:Int;
	var b:Bitmap;
	
	public function new (title:String, list:Array<String>, version:Int = -1, clickHandler:MouseEvent->Void = null) {
		switch (version) {
			default:
				super(UIObject.getEmptyFrames(130, 30 * (list.length + 1) + 10), 0xFFFFFF80, 0);
			case 0:
				super(UIObject.getEmptyFrames(130, 30 * (list.length + 1) + 10), 0, 0);
				b = new Bitmap(Assets.getBitmapData("img/postitBIG3rd.png"), PixelSnapping.AUTO, true);
				b.x = -10;
				b.y = -20;
				addChildAt(b, 0);
			case 1:
				super(UIObject.getEmptyFrames(130, 30 * (list.length + 1) + 10), 0, 0);
				b = new Bitmap(Assets.getBitmapData("img/postit3rd.png"), PixelSnapping.AUTO, true);
				b.x = -20;
				b.y = -10;
				addChildAt(b, 0);
		}
		// Set text
		setText(title, 0, 0, Main.FORMAT_BOLD);
		// Create buttons
		var bt:Button;
		for (i in 0...list.length) {
			bt = new Button(UIObject.getEmptyFrames(130, 25), 0, 0);
			bt.customData = i;
			bt.setText(list[i], 0, 0, Main.FORMAT_SUB);
			bt.y = (i + 1.5) * 25;
			addChild(bt);
			if (clickHandler != null)	bt.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		mouseChildren = true;
	}
	
	override public function clean () {
		super.clean();
		
		b.bitmapData.dispose();
		b.bitmapData = null;
	}
	
}