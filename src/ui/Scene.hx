package ui;

import art.ArtEditor.Art;
import code.CodeGame.Module;
import flash.display.Bitmap;
import flash.display.BitmapData;
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
		b.x = 35;
		b.y = 52;
		backgroundLayer.addChild(b);
		// Clock
		new Clock();
		Clock.instance.sprite.x = 840;
		Clock.instance.sprite.y = 112;
		foregroundLayer.addChild(Clock.instance.sprite);
		skyLayer.addChild(Clock.instance.skySprite);
		// Post-its
		mainPI = new PostIt("TODO", ["-FIND an idea ", "-TEST the game ", "-SUBMIT it "], 0, mainPIClickHandler);
		mainPI.buttons[1].setActive(false, true);
		mainPI.buttons[2].setActive(false, true);
		mainPI.x = 10;
		mainPI.y = 80;
		mainPI.rotation = 4;
		codePI = new PostIt("CODE", ["1. basics ", "2. enemies ", "3. jump "], 0, codePIClickHandler);
		codePI.buttons[1].setActive(false, true);
		codePI.buttons[2].setActive(false, true);
		codePI.x = mainPI.x + 10;
		codePI.y = mainPI.y + 150;
		artPI = new PostIt("ART", ["-block ", "-hero ", "-goal ", "-enemy "], 0, artPIClickHandler);
		artPI.buttons[3].setActive(false, true);
		artPI.x = mainPI.x - 5;
		artPI.y = codePI.y + 150;
		artPI.rotation = -4;
		musicPI = new PostIt("MUSIC", ["-record some "], 1, musicPIClickHandler);
		musicPI.x = 80;
		musicPI.y = 550;
		
		var tmp = new Bitmap(Main.instance.data);
		tmp.scaleX = tmp.scaleY = 2;
		addChild(tmp);
	}
	
	public function start () {
		showPI(mainPI);
		Timer.delay(mainPI.buttons[0].setDone.bind(true), 500);
		Timer.delay(showPI.bind(codePI), 750);
		//
		Clock.instance.pause(false);
	}
	
	function showPI (pi:PostIt) {
		foregroundLayer.addChild(pi);
		SoundManager.play("snd/sfx/postit0" + Std.random(3) + ".mp3");
	}
	
	function mainPIClickHandler (e:MouseEvent) {
		if (!cast(e.currentTarget, PIItem).active)	return;
		var i:Int = cast(e.currentTarget, PIItem).customData;
		switch (i) {
			case 1:	Main.instance.executeAction("testGame");
			case 2:	Main.instance.executeAction("submitGame");
		}
	}
	
	function codePIClickHandler (e:MouseEvent) {
		if (!cast(e.currentTarget, PIItem).active)	return;
		var i:Int = cast(e.currentTarget, Button).customData;
		switch (i) {
			case 0:	Main.instance.executeAction("codeBasics");
			case 1:	Main.instance.executeAction("codeEnemies");
			case 2:	Main.instance.executeAction("codeJump");
		}
	}
	
	function artPIClickHandler (e:MouseEvent) {
		if (!cast(e.currentTarget, PIItem).active)	return;
		var i:Int = cast(e.currentTarget, Button).customData;
		switch (i) {
			case 0:	Main.instance.executeAction("artBlock");
			case 1:	Main.instance.executeAction("artHero");
			case 2:	Main.instance.executeAction("artTreasure");
			case 3:	Main.instance.executeAction("artEnemy");
		}
	}
	
	function musicPIClickHandler (e:MouseEvent) {
		var i:Int = cast(e.currentTarget, Button).customData;
		switch (i) {
			case 0:	Main.instance.executeAction("recordMusic");
		}
	}
	
	public function completeModule (m:Module) {
		var p:IntPoint;
		switch (m) {
			case Module.Basics:
				p = new IntPoint(0, 64);
				codePI.buttons[0].setDone(true);
				Timer.delay(codePI.buttons[0].setActive.bind(false, true), 250 + Std.random(100));
				Timer.delay(codePI.buttons[1].setActive.bind(true, true), 500 + Std.random(100));
				Timer.delay(mainPI.buttons[1].setActive.bind(true, true), 750 + Std.random(100));
				Timer.delay(mainPI.buttons[2].setActive.bind(true, true), 1000 + Std.random(100));
				Timer.delay(showPI.bind(artPI), 1250 + Std.random(100));
				Timer.delay(showPI.bind(musicPI), 1500 + Std.random(100));
			case Module.Enemies:
				p = new IntPoint(1, 64);
				codePI.buttons[1].setDone(true);
				codePI.buttons[1].setActive(false, true);
				codePI.buttons[2].setActive(true, true);
				artPI.buttons[3].setActive(true, true);
			case Module.Jump:
				p = new IntPoint(2, 64);
				codePI.buttons[2].setDone(true);
				codePI.buttons[2].setActive(false, true);
		}
		Main.instance.data.setPixel32(p.x, p.y, 0xFFFFFFFF);
	}
	
	public function editedArt (art:Art) {
		/*switch (art) {
			case Art.Block:	artPI.buttons[0].setDone(true);
			case Art.Hero:	artPI.buttons[1].setDone(true);
			case Art.Goal:	artPI.buttons[2].setDone(true);
			case Art.Enemy:	artPI.buttons[3].setDone(true);
		}*/
	}
	
	public function clearScreen () {
		if (screen == null)	return;
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










