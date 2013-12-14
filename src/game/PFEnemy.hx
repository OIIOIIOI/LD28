package game;
import game.Entity.Dir;


/**
 * ...
 * @author 01101101
 */

class PFEnemy extends PFEntity {
	
	public function new (w:Int = 1, h:Int = 1) {
		super(w, h);
		
		hSpeed = 0.005;
		
		facing = (Std.random(2) == 0) ? Dir.RIGHT : Dir.LEFT;
	}
	
	override public function update () {
		// Move
		if (alive)	move(facing);
		// Update
		super.update();
		// Change direction
		if (fastColl(facing) && dx == 0) {
			if (facing == Dir.RIGHT)	facing = Dir.LEFT;
			else						facing = Dir.RIGHT;
		}
	}
	
}










