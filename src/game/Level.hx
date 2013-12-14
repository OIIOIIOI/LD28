package game;

import flash.display.BitmapData;

/**
 * ...
 * @author 01101101
 */

class Level {
	
	static public var WIDTH:Int = 20;
	static public var HEIGHT:Int = 15;
	static public var GRID_SIZE:Int = 32;
	
	static public var C_VOID:UInt = 0xFFFFFF;
	static public var C_SOLID:UInt = 0x000000;
	
	public var data(default, null):BitmapData;
	
	public function new () {
		data = new BitmapData(WIDTH, HEIGHT, false, C_VOID);
	}
	
	public function generateCrap () {
		// Ground
		Main.TAR.x = 0;
		Main.TAR.y = data.height - 1;
		Main.TAR.width = data.width;
		Main.TAR.height = 1;
		data.fillRect(Main.TAR, C_SOLID);
		// Random crap generation
		for (i in 0...10) {
			data.setPixel(Std.random(WIDTH), Std.random(HEIGHT - 1), C_SOLID);
		}
	}
	
	public function load (lvl:Int = 0, n:Int = -1) {
		if (n == -1)	n = 0;
		Main.TAR.x = n * WIDTH;
		Main.TAR.y = lvl * HEIGHT;
		Main.TAR.width = WIDTH;
		Main.TAR.height = HEIGHT;
		Main.TAP.x = Main.TAP.y = 0;
		data.copyPixels(Main.LEVELS, Main.TAR, Main.TAP);
	}
	
	public function collide (x:Int, y:Int) :Bool {
		return (data.getPixel(x, y) == C_SOLID);
	}
	
}










