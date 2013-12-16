package game;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.ui.Keyboard;
import game.Entity.Dir;
import haxe.Timer;
import music.MusicGame.SndObj;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

typedef Params = {
	var basics:Bool;
	var enemies:Bool;
	var jump:Bool;
}

class PFGame extends Game {
	
	var sprites:BitmapData;
	var params:Params;
	
	var level:PFLevel;
	var hero:PFHero;
	var enemies:Array<PFEnemy>;
	
	var endLevel:Bool->Void;
	
	var running:Bool;
	
	public function new (data:BitmapData, endLevel:Bool->Void) {
		super();
		
		this.endLevel = endLevel;
		running = false;
		
		// Parse game data
		sprites = data;
		params = { basics:false, jump:false, enemies:false };
		params.basics =		(data.getPixel32(0, 64) == cast(0xFF000000));
		params.enemies =	(data.getPixel32(1, 64) == cast(0xFF000000));
		params.jump =		(data.getPixel32(2, 64) == cast(0xFF000000));
		
		level = new PFLevel();
		addChild(level.sprite);
		
		hero = new PFHero(1, 2);
		enemies = new Array<PFEnemy>();
	}
	
	public function loadLevel (num:Int) {
		// Load level
		level.load(0, num);
		parseLevel();
		running = true;
	}
	
	function parseLevel () {
		// Spawn enemies
		if (params.enemies) {
			for (e in level.enemies) {
				enemies.push(getNewEnemy(e));
			}
		}
		// Posision hero
		hero.alive = true;
		hero.collide = level.collide;
		hero.setCoords(cast(level).start.x * Level.GRID_SIZE, cast(level).start.y * Level.GRID_SIZE);
		addChild(hero.sprite);
	}
	
	override public function update () {
		if (!running)	return;
		
		super.update();
		
		// Inputs
		if (hero.alive) {
			if (params.basics && keys.get(Keyboard.RIGHT))	hero.move(Dir.RIGHT);
			if (params.basics && keys.get(Keyboard.LEFT))	hero.move(Dir.LEFT);
			if (params.jump && keys.get(Keyboard.SPACE))	hero.jump();
		}
		// Updates
		for (e in enemies)	e.update();
		hero.update();
		// Stop the loop here if hero is dead
		if (!hero.alive)	return;
		// Check collisions with enemies
		var bounce:Bool = false;
		for (e in enemies) {
			if (!e.alive)	continue;
			if (hero.collideEntity(e)) {
				if (hero.dy > 0) {
					// Hero bounces off
					bounce = true;
					// Enemy dies
					e.die();
				} else {
					// Hero dies
					if (hero.alive) {
						hero.die();
						endLevel(false);
					}
				}
			}
		}
		if (bounce)	hero.jump(true);
		// Hero reached exit
		if (hero.cx == cast(level).end.x && hero.cy == cast(level).end.y && running) {
			for (e in enemies)	if (e.alive)	e.die();
			running = false;
			endLevel(true);
		}
	}
	
	function getNewEnemy (p:IntPoint) :PFEnemy {
		if (p == null)	p = new IntPoint(Std.random(Level.WIDTH), Std.random(Level.HEIGHT));
		var e:PFEnemy = new PFEnemy();
		e.collide = level.collide;
		e.setCoords(p.x * Level.GRID_SIZE, p.y * Level.GRID_SIZE);
		addChild(e.sprite);
		return e;
	}
	
	override function registerKeys () {
		if (keys != null)	return;
		keys = new Map<Int, Bool>();
		keys.set(Keyboard.RIGHT, false);
		keys.set(Keyboard.LEFT, false);
		keys.set(Keyboard.SPACE, false);
		keys.set(Keyboard.ENTER, false);
	}
	
}










