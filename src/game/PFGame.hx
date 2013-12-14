package game;

import flash.display.Bitmap;
import flash.ui.Keyboard;
import game.Entity.Dir;

/**
 * ...
 * @author 01101101
 */

class PFGame extends Game {
	
	public function new () {
		super();
	}
	
	override function setupLevel () {
		level = new PFLevel();
		var b:Bitmap = new Bitmap(level.data);
		b.scaleX = b.scaleY = Level.GRID_SIZE;
		addChild(b);
	}
	
	override function setupHero () {
		hero = new PFHero(1, 2);
		hero.isSolid = level.isSolid;
		hero.setCoords(cast(level).start.x * Level.GRID_SIZE, cast(level).start.y * Level.GRID_SIZE);
		addChild(hero.sprite);
	}
	
	override public function update () {
		// Inputs
		if (keys.get(Keyboard.RIGHT))	hero.move(Dir.RIGHT);
		if (keys.get(Keyboard.LEFT))	hero.move(Dir.LEFT);
		if (keys.get(Keyboard.SPACE))	cast(hero).jump();
		// Updates
		hero.update();
		// Check end conditions
		if (hero.cx == cast(level).end.x && hero.cy == cast(level).end.y) {
			// WIN
		}
	}
	
	override function registerKeys () {
		if (keys != null)	return;
		keys = new Map<Int, Bool>();
		keys.set(Keyboard.RIGHT, false);
		keys.set(Keyboard.LEFT, false);
		keys.set(Keyboard.SPACE, false);
	}
	
}