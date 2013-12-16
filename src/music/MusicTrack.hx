package music;

import flash.display.Sprite;


/**
 * ...
 * @author 01101101
 */

class MusicTrack extends Sprite {
	
	public static var WIDTH:Int = 80;
	public static var GUTTER:Int = 10;
	
	public function new (h:Int = 360) {
		super();
		
		graphics.beginFill(0xFFFFFF, 1);
		graphics.drawRect(0, 0, GUTTER / 2, -h);
		graphics.endFill();
		
		graphics.beginFill(0xFFFFFF, 0.5);
		graphics.drawRect(GUTTER / 2, 0, WIDTH - GUTTER, -h);
		graphics.endFill();
		
		graphics.beginFill(0xFFFFFF, 1);
		graphics.drawRect(WIDTH - GUTTER / 2, 0, GUTTER / 2, -h);
		graphics.endFill();
	}
	
}