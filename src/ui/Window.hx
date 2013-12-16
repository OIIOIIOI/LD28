package ui;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import openfl.Assets;
import screens.Screen;

/**
 * ...
 * @author 01101101
 */

class Window extends Sprite {
	
	public static var WIDTH:Int = 480;
	public static var HEIGHT:Int = 360;
	
	var background:Bitmap;
	public var titleLabel:UIObject;
	var closeButton:Button;
	var closeCallback:Void->Void;
	
	public function new (closeCB:Void->Void = null, title:String = "") {
		super();
		
		closeCallback = closeCB;
		
		background = new Bitmap(Assets.getBitmapData("img/window.png"));
		addChild(background);
		
		titleLabel = new UIObject(UIObject.getEmptyFrames(200, 20), 0, 0);
		titleLabel.setText(title, 0, 0, Main.FORMAT_WINDOW);
		titleLabel.x = 255;
		titleLabel.y = 8;
		addChild(titleLabel);
		
		if (closeCallback != null) {
			closeButton = new Button([new Rectangle(0, 32, 14, 14)]);
			closeButton.x = background.width - closeButton.width + 2;
			closeButton.y = -4;
			addChild(closeButton);
			closeButton.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		x = Std.int((Screen.WIDTH - width) / 2) + 60 + Std.random(10);
		y = Std.int((Screen.HEIGHT - height) / 2) + Std.random(30) - 15;
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == closeButton && closeCallback != null) {
			closeCallback();
		}
	}
	
	public function setContent (c:DisplayObject) {
		c.x = 9;
		c.y = 25;
		addChild(c);
		//
		var m = new Sprite();
		m.graphics.beginFill(0x00FF00);
		m.graphics.drawRect(0, 0, WIDTH, HEIGHT);
		m.graphics.endFill();
		addChild(m);
		m.x = c.x;
		m.y = c.y;
		c.mask = m;
		// Put close on top
		if (closeButton != null)	addChild(closeButton);
	}
	
}