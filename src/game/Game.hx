package game;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;
import game.Entity.Dir;

/**
 * ...
 * @author 01101101
 */

class Game extends Sprite {
	
	var level:Level;
	var hero:Entity;
	
	var keys:Map<Int, Bool>;
	
	public function new () {
		super();
		
		registerKeys();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		
		setupLevel();
		setupHero();
	}
	
	function setupLevel () {
		level = new Level();
		var b:Bitmap = new Bitmap(level.data);
		b.scaleX = b.scaleY = Level.GRID_SIZE;
		addChild(b);
	}
	
	function setupHero () {
		hero = new Entity(1, 2);
		hero.isSolid = level.isSolid;
		hero.setCoords(20, 30);
		addChild(hero.sprite);
	}
	
	public function update () {
		// Inputs
		if (keys.get(Keyboard.UP))		hero.move(Dir.UP);
		if (keys.get(Keyboard.RIGHT))	hero.move(Dir.RIGHT);
		if (keys.get(Keyboard.DOWN))	hero.move(Dir.DOWN);
		if (keys.get(Keyboard.LEFT))	hero.move(Dir.LEFT);
		// Updates
		hero.update();
	}
	
	function registerKeys () {
		if (keys != null)	return;
		keys = new Map<Int, Bool>();
		keys.set(Keyboard.UP, false);
		keys.set(Keyboard.RIGHT, false);
		keys.set(Keyboard.DOWN, false);
		keys.set(Keyboard.LEFT, false);
		keys.set(Keyboard.SPACE, false);
	}
	
	function keyDownHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode))	keys.set(e.keyCode, true);
	}
	
	function keyUpHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode))	keys.set(e.keyCode, false);
	}
	
}