package ui;

import flash.display.Bitmap;
import flash.display.Sprite;
import openfl.Assets;
import screens.Screen;

/**
 * ...
 * @author 01101101
 */

class Scene extends Sprite {
	
	static var SCREEN_X:Int = 102;
	static var SCREEN_Y:Int = 34;
	
	var screen:Screen;
	
	var backgroundLayer:Sprite;
	var screenLayer:Sprite;
	var foregroundLayer:Sprite;
	
	public function new () {
		super();
		
		backgroundLayer = new Sprite();
		screenLayer = new Sprite();
		foregroundLayer = new Sprite();
		
		addChild(backgroundLayer);
		addChild(screenLayer);
		addChild(foregroundLayer);
		
		backgroundLayer.addChild(new Bitmap(Assets.getBitmapData("img/scene.jpg")));
		
		new Clock();
		Clock.instance.sprite.x = 900;
		Clock.instance.sprite.y = 115;
		foregroundLayer.addChild(Clock.instance.sprite);
		
		var p = new PostIt("TODO", ["MAKE a game", "TEST it", "SUBMIT it"]);
		p.x = p.y = 20;
		foregroundLayer.addChild(p);
	}
	
	public function clearScreen () {
		screen.clean();
		screenLayer.removeChild(screen);
		screen = null;
	}
	
	public function changeScreen (s:Screen) {
		if (screen != null)	clearScreen();
		screen = s;
		screen.x = SCREEN_X;
		screen.y = SCREEN_Y;
		screenLayer.addChild(screen);
	}
	
	public function update () {
		// Screen
		if (screen != null)	screen.update();
		// Clock
		Clock.instance.update();
	}
	
}










