package art;

import art.ArtEditor.Art;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.text.TextFormat;
import game.Level;
import screens.Screen;
import ui.Button;
import ui.UIObject;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

class ArtEditor extends Sprite {
	
	public static var WIDTH:Int = 480;
	public static var HEIGHT:Int = 360;
	
	public static var instance:ArtEditor;
	
	public var assets:Map<Art, Shape>;
	public var coords:Map<Art, Rectangle>;
	public var current:Art;
	
	public function new () {
		super();
		
		if (instance != null)	throw new Error("Already instanciated");
		instance = this;
		
		// Init shapes
		assets = new Map<Art, Shape>();
		assets.set(Art.Block, new Shape());
		assets.set(Art.Hero, new Shape());
		assets.set(Art.Enemy, new Shape());
		assets.set(Art.Goal, new Shape());
		// Init coords
		coords = new Map<Art, Rectangle>();
		coords.set(Art.Block, new Rectangle(0, 0, Level.GRID_SIZE, Level.GRID_SIZE));
		coords.set(Art.Enemy, new Rectangle(0, Level.GRID_SIZE, Level.GRID_SIZE, Level.GRID_SIZE));
		coords.set(Art.Hero, new Rectangle(Level.GRID_SIZE, 0, Level.GRID_SIZE, Level.GRID_SIZE * 2));
		coords.set(Art.Goal, new Rectangle(Level.GRID_SIZE * 2, 0, Level.GRID_SIZE, Level.GRID_SIZE * 2));
		// Init data
		for (k in assets.keys()) {
			resetData(k, true);
		}
		
		current = Art.Hero;
	}
	
	public function save () {
		// Clear previous version
		Main.instance.data.fillRect(coords.get(current), 0x00FF00FF);
		// Matrix
		Main.TAM.identity();
		Main.TAM.translate(coords.get(current).x, coords.get(current).y);
		// Clip
		Main.TAR.x = coords.get(current).x;
		Main.TAR.y = coords.get(current).y;
		Main.TAR.width = coords.get(current).width;
		Main.TAR.height = coords.get(current).height;
		// Draw
		Main.instance.data.draw(assets.get(current), Main.TAM, null, null, Main.TAR);
	}
	
	public function resetData (art:Art, fillShape:Bool = false) {
		assets.get(art).graphics.clear();
		switch (art) {
			case Art.Block:
				Main.instance.data.fillRect(coords.get(art), 0xFF000000);
				if (fillShape)	assets.get(art).graphics.beginFill(0x000000);
			case Art.Enemy:
				Main.instance.data.fillRect(coords.get(art), 0xFFDF0024);
				if (fillShape)	assets.get(art).graphics.beginFill(0xDF0024);
			case Art.Goal:
				Main.instance.data.fillRect(coords.get(art), 0xFF00B034);
				if (fillShape)	assets.get(art).graphics.beginFill(0x00B034);
			case Art.Hero:
				Main.instance.data.fillRect(coords.get(art), 0xFF00A9EC);
				if (fillShape)	assets.get(art).graphics.beginFill(0x00A9EC);
		}
		if (fillShape) {
			assets.get(art).graphics.drawRect(0, 0, coords.get(art).width, coords.get(art).height);
			assets.get(art).graphics.endFill();
		}
	}
	
	public function paint (art:Art, target:BitmapData, dest:Point = null) {
		if (dest == null)	dest = new Point();
		target.copyPixels(Main.instance.data, coords.get(art), dest);
	}
	
}

enum Art {
	Block;
	Hero;
	Enemy;
	Goal;
}










