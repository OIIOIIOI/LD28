package ui;

import flash.display.Bitmap;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.media.Sound;
import haxe.Timer;
import openfl.Assets;
import screens.Screen;
import ui.objects.Bed;
import ui.objects.Cat;
import ui.objects.Object;
import ui.objects.Statue;

/**
 * ...
 * @author 01101101
 */

class Scene extends Sprite {
	
	static var SCREEN_X:Int = 92;
	static var SCREEN_Y:Int = 85;
	
	var screen:Screen;
	
	var skyLayer:Sprite;
	var backgroundLayer:Sprite;
	var screenLayer:Sprite;
	var foregroundLayer:Sprite;
	
	var toUpdate:Array<Object>;
	
	var mainPI:PostIt;
	var codePI:PostIt;
	var artPI:PostIt;
	var musicPI:PostIt;
	
	public function new () {
		super();
		
		skyLayer = new Sprite();
		backgroundLayer = new Sprite();
		screenLayer = new Sprite();
		foregroundLayer = new Sprite();
		
		toUpdate = new Array<Object>();
		
		addChild(skyLayer);
		addChild(backgroundLayer);
		addChild(screenLayer);
		addChild(foregroundLayer);
		
		var b:Bitmap;
		var o:Object;
		// Window
		b = new Bitmap(Assets.getBitmapData("img/skyfall-when-it-crumbles.png"));
		b.blendMode = BlendMode.OVERLAY;
		backgroundLayer.addChild(b);
		// Background
		backgroundLayer.addChild(new Bitmap(Assets.getBitmapData("img/background.png")));
		// Bed
		o = new Bed();
		//o.changeState();
		toUpdate.push(o);
		backgroundLayer.addChild(o);
		// Cat
		o = new Cat();
		//o.changeState();
		toUpdate.push(o);
		backgroundLayer.addChild(o);
		// Screen base
		backgroundLayer.addChild(new Bitmap(Assets.getBitmapData("img/foreground.png")));
		// Statue
		o = new Statue();
		toUpdate.push(o);
		backgroundLayer.addChild(o);
		// Screen
		b = new Bitmap(Assets.getBitmapData("img/screen.png"));
		b.x = 44;
		b.y = 56;
		backgroundLayer.addChild(b);
		// Clock
		new Clock();
		Clock.instance.sprite.x = 840;
		Clock.instance.sprite.y = 112;
		foregroundLayer.addChild(Clock.instance.sprite);
		skyLayer.addChild(Clock.instance.skySprite);
		// Post-its
		mainPI = new PostIt("TODO", ["-MAKE a game ", "-TEST it ", "-SUBMIT it "], 0, mainPIClickHandler);
		mainPI.x = 20;
		mainPI.y = 80;
		mainPI.rotation = 4;
		//foregroundLayer.addChild(mainPI);
		codePI = new PostIt("CODE", ["-basics ", "-enemies ", "-jump "], 0, codePIClickHandler);
		codePI.x = mainPI.x + 10;
		codePI.y = mainPI.y + 150;
		//foregroundLayer.addChild(codePI);
		artPI = new PostIt("ART", ["-hero ", "-enemy ", "-block ", "-treasure "], 0, artPIClickHandler);
		artPI.x = mainPI.x - 5;
		artPI.y = codePI.y + 150;
		artPI.rotation = -4;
		//foregroundLayer.addChild(artPI);
		musicPI = new PostIt("MUSIC", ["-record some "], 1, musicPIClickHandler);
		musicPI.x = 80;
		musicPI.y = 550;
		//foregroundLayer.addChild(musicPI);
	}
	
	public function start () {
		showPI(mainPI);
		Timer.delay(showPI.bind(codePI), 500);
		Timer.delay(showPI.bind(artPI), 900);
		Timer.delay(showPI.bind(musicPI), 1200);
		//
		Clock.instance.pause(false);
	}
	
	function showPI (pi:PostIt) {
		foregroundLayer.addChild(pi);
		SoundManager.play("snd/sfx/postit.mp3");
	}
	
	function mainPIClickHandler (e:MouseEvent) {
		var i:Int = cast(e.currentTarget, Button).customData;
		switch (i) {
			case 0:	Main.instance.executeAction("makeGame");
			case 1:	Main.instance.executeAction("testGame");
			case 2:	Main.instance.executeAction("submitGame");
		}
	}
	
	function codePIClickHandler (e:MouseEvent) {
		var i:Int = cast(e.currentTarget, Button).customData;
		switch (i) {
			case 0:	Main.instance.executeAction("codeBasics");
			case 1:	Main.instance.executeAction("codeEnemies");
			case 2:	Main.instance.executeAction("codeJump");
		}
	}
	
	function artPIClickHandler (e:MouseEvent) {
		var i:Int = cast(e.currentTarget, Button).customData;
		switch (i) {
			case 0:	Main.instance.executeAction("artHero");
			case 1:	Main.instance.executeAction("artEnemy");
			case 2:	Main.instance.executeAction("artBlock");
			case 3:	Main.instance.executeAction("artTreasure");
		}
	}
	
	function musicPIClickHandler (e:MouseEvent) {
		var i:Int = cast(e.currentTarget, Button).customData;
		switch (i) {
			case 0:	Main.instance.executeAction("musicRecord");
		}
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
		// Objects
		for (o in toUpdate) {
			o.update();
		}
	}
	
}










