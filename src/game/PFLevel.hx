package game;


/**
 * ...
 * @author 01101101
 */

class PFLevel extends Level {
	
	static public var C_START:UInt = 0xFFFF00;
	static public var C_END:UInt = 0xFF8000;
	static public var C_ENEMY:UInt = 0xFF0000;
	
	public var start:IntPoint;
	public var end:IntPoint;
	public var enemies:Array<IntPoint>;
	
	public function new () {
		super();
	}
	
	override public function generateCrap () {
		super.generateCrap();
		
		start = new IntPoint(Std.random(data.width), Std.random(data.height - 2));
		
		end = new IntPoint(Std.random(data.width), Std.random(data.height - 2));
		data.setPixel(end.x, end.y, C_END);
		data.setPixel(end.x, end.y + 1, C_END);
		data.setPixel(end.x, end.y + 2, Level.C_SOLID);
		
		enemies = new Array();
		enemies.push(new IntPoint(Std.random(Level.WIDTH), 0));
		enemies.push(new IntPoint(Std.random(Level.WIDTH), 0));
		enemies.push(new IntPoint(Std.random(Level.WIDTH), 0));
		enemies.push(new IntPoint(Std.random(Level.WIDTH), 0));
	}
	
	override public function load (lvl:Int = 0, n:Int = -1) {
		super.load(lvl, n);
		// Init enemies
		enemies = new Array();
		// Parse data
		for (y in 0...data.height) {
			for (x in 0...data.width) {
				var px = data.getPixel(x, y);
				if (px == C_START && start == null) {
					start = new IntPoint(x, y);
				}
				else if (px == C_END && end == null) {
					end = new IntPoint(x, y);
					data.setPixel(end.x, end.y, C_END);
					data.setPixel(end.x, end.y + 1, C_END);
				}
				else if (px == C_ENEMY) {
					enemies.push(new IntPoint(x, y));
				}
			}
		}
	}
	
}