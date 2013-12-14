package game;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.ui.Keyboard;
import game.Entity.Dir;

/**
 * ...
 * @author 01101101
 */

typedef Params = {
	var move:Bool;
	var enemies:Bool;
	var jump:Bool;
}

class PFGame extends Game {
	
	var sprites:BitmapData;
	var params:Params;
	
	var level:PFLevel;
	var hero:PFHero;
	var enemies:Array<PFEnemy>;
	
	#if extLoad
	public function new (data:BitmapData, debug:Array<String>)
	#else
	public function new (data:BitmapData)
	#end
	{
		super();
		// Parse game data
		sprites = data;
		parseData(data);
		// Level
		#if extLoad
		setupLevel(debug);
		#else
		setupLevel();
		#end
		// Init
		enemies = new Array();
		restartLevel();
	}
	
	function parseData (data:BitmapData) {
		params = { move:false, jump:false, enemies:false };
		params.move =		(data.getPixel32(0, 0) == cast(0xFFFFFFFF));
		params.enemies =	(data.getPixel32(1, 0) == cast(0xFFFFFFFF));
		params.jump =		(data.getPixel32(2, 0) == cast(0xFFFFFFFF));
	}
	
	#if extLoad
	function setupLevel (debug:Array<String>)
	#else
	function setupLevel ()
	#end
	{
		level = new PFLevel();
		//level.generateCrap();
		#if extLoad
		level.load(Std.parseInt(debug[0]), Std.parseInt(debug[1]));
		#else
		level.load(0, 0);
		#end
		addChild(level.sprite);
		//var b:Bitmap = new Bitmap(level.data);
		//b.scaleX = b.scaleY = Level.GRID_SIZE;
		//addChild(b);
	}
	
	public function clean () {
		if (contains(hero.sprite))	removeChild(hero.sprite);
		hero = null;
		while (enemies.length > 0) {
			var e = enemies.shift();
			if (contains(e.sprite))	removeChild(e.sprite);
			e = null;
		}
	}
	
	function restartLevel () {
		// Create hero
		hero = new PFHero(1, 2);
		hero.collide = level.collide;
		hero.setCoords(cast(level).start.x * Level.GRID_SIZE, cast(level).start.y * Level.GRID_SIZE);
		addChild(hero.sprite);
		// Add enemies
		if (params.enemies) {
			for (e in level.enemies) {
				enemies.push(getNewEnemy(e));
			}
		}
	}
	
	override public function update () {
		// Restart
		if (keys.get(Keyboard.ENTER)) {
			clean();
			restartLevel();
		}
		// Inputs
		if (hero.alive) {
			if (params.move && keys.get(Keyboard.RIGHT))	hero.move(Dir.RIGHT);
			if (params.move && keys.get(Keyboard.LEFT))	hero.move(Dir.LEFT);
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
					hero.die();
					trace("YOU'RE DEAD");
				}
			}
		}
		if (bounce)	hero.jump(true);
		// Check end conditions
		if (hero.cx == cast(level).end.x && hero.cy == cast(level).end.y) {
			for (e in enemies)	if (e.alive)	e.die();
			trace("YOU WIN");
		}
	}
	
	// TODO remove dead entities from the loop
	// TODO restart level button
	
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










