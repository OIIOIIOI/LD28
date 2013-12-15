package ui;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

class Window extends Sprite {
	
	var background:Bitmap;
	var closeButton:Button;
	var closeCallback:Void->Void;
	//var top:Sprite;
	
	public function new (closeCB:Void->Void = null) {
		super();
		
		closeCallback = closeCB;
		
		background = new Bitmap(Assets.getBitmapData("img/window.png"));
		addChild(background);
		
		if (closeCallback != null) {
			closeButton = new Button([new Rectangle(0, 16, 22, 22)]);
			closeButton.x = background.width - closeButton.width + 2;
			closeButton.y = -4;
			addChild(closeButton);
			closeButton.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		// TODO drag & drop
		/*top = new Sprite();
		top.graphics.beginFill(0xFF00FF, 0.5);
		top.graphics.drawRect(0, 0, 490, 25);
		top.graphics.endFill();
		addChild(top);*/
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == closeButton && closeCallback != null) {
			closeCallback();
		}
	}
	
	public function setContent (c:DisplayObject) {
		c.x = 6;
		c.y = 19;
		addChild(c);
		// Put close on top
		if (closeButton != null)	addChild(closeButton);
	}
	
}