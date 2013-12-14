package game;


/**
 * ...
 * @author 01101101
 */

class PFLevel extends Level {
	
	static public var C_START:UInt = 0xFFFF66;
	static public var C_END:UInt = 0x66FF66;
	
	public var start:IntPoint;
	public var end:IntPoint;
	
	public function new () {
		super();
		
		start = new IntPoint(Std.random(data.width), Std.random(data.height - 2));
		data.setPixel(start.x, start.y, C_START);
		data.setPixel(start.x, start.y + 1, C_START);
		data.setPixel(start.x, start.y + 2, Level.C_SOLID);
		
		end = new IntPoint(Std.random(data.width), Std.random(data.height - 2));
		data.setPixel(end.x, end.y, C_END);
		data.setPixel(end.x, end.y + 1, C_END);
		data.setPixel(end.x, end.y + 2, Level.C_SOLID);
	}
	
}