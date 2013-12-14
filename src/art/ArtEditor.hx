package art;

import art.ArtEditor.Art;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import game.Level;

/**
 * ...
 * @author 01101101
 */

class ArtEditor extends Sprite {
	
	public var data:BitmapData;
	
	var assets:Map<Art, Shape>;
	var current:Art;
	
	var canvas:Sprite;
	
	public function new () {
		super();
		
		data = new BitmapData(128, 128, true, 0x00FF00FF);
		
		assets = new Map<Art, Shape>();
		assets.set(Art.Block, new Shape());
		assets.set(Art.Hero, new Shape());
		assets.set(Art.Enemy, new Shape());
		assets.set(Art.Treasure, new Shape());
		
		canvas = new Sprite();
		addChild(canvas);
	}
	
	function setCanvasSize (art:Art) {
		canvas.graphics.clear();
		canvas.graphics.beginFill(0xFF00FF, 0.2);
		switch (art) {
			case Art.Block:		canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE);
			case Art.Hero:		canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE * 2);
			case Art.Enemy:		canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE);
			case Art.Treasure:	canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE * 2);
		}
		canvas.graphics.endFill();
	}
	
	public function edit (art:Art) {
		current = art;
		setCanvasSize(current);
		addChild(assets.get(art));
	}
	
	
	
}

enum Art {
	Block;
	Hero;
	Enemy;
	Treasure;
}










