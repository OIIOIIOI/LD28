package game;

import flash.display.Bitmap;
import flash.ui.Keyboard;
import game.Entity.Dir;

/**
 * ...
 * @author 01101101
 */

class PFGame extends Game {
	
	var hero:PFHero;
	var enemies:Array<PFEnemy>;
	
	public function new () {
		super();
		
		hero = new PFHero(1, 2);
		hero.collide = level.isSolid;
		hero.setCoords(cast(level).start.x * Level.GRID_SIZE, cast(level).start.y * Level.GRID_SIZE);
		addChild(hero.sprite);
		
		enemies = new Array();
		enemies.push(getNewEnemy());
		enemies.push(getNewEnemy());
		enemies.push(getNewEnemy());
	}
	
	override function setupLevel () {
		level = new PFLevel();
		var b:Bitmap = new Bitmap(level.data);
		b.scaleX = b.scaleY = Level.GRID_SIZE;
		addChild(b);
	}
	
	override public function update () {
		// Inputs
		if (hero.alive) {
			if (keys.get(Keyboard.RIGHT))	hero.move(Dir.RIGHT);
			if (keys.get(Keyboard.LEFT))	hero.move(Dir.LEFT);
			if (keys.get(Keyboard.SPACE))	hero.jump();
		}
		// Updates
		for (e in enemies)	e.update();
		hero.update();
		// Stop the loop here if hero is dead
		if (!hero.alive)	return;
		// Check collisions with enemies
		for (e in enemies) {
			if (!e.alive)	continue;
			if (hero.collideEntity(e)) {
				if (hero.dy > 0) {
					// Hero bounces off
					hero.jump(true);
					// Enemy dies
					e.die();
				} else {
					// Hero dies
					hero.die();
					trace("YOU'RE DEAD");
				}
			}
		}
		// Check end conditions
		if (hero.cx == cast(level).end.x && hero.cy == cast(level).end.y) {
			for (e in enemies)	if (e.alive)	e.die();
			trace("YOU WIN");
		}
	}
	
	// TODO remove dead entities from the loop
	
	function getNewEnemy () :PFEnemy {
		var e:PFEnemy = new PFEnemy();
		e.collide = level.isSolid;
		e.setCoords(Std.random(Level.WIDTH) * Level.GRID_SIZE, 0);
		addChild(e.sprite);
		return e;
	}
	
	override function registerKeys () {
		if (keys != null)	return;
		keys = new Map<Int, Bool>();
		keys.set(Keyboard.RIGHT, false);
		keys.set(Keyboard.LEFT, false);
		keys.set(Keyboard.SPACE, false);
	}
	
}