package game;
import game.Entity.Dir;


/**
 * ...
 * @author 01101101
 */

class PFEntity extends Entity {
	
	var gravity:Float;
	public var alive:Bool;
	
	public function new (w:Int=1, h:Int=1) {
		super(w, h);
		
		alive = true;
		gravity = 0.04;
	}
	
	override public function update () {
		// Apply movement X
		xr += dx;
		updateX();
		// Apply movement Y
		dy += gravity;
		yr += dy;
		updateY();
		// Update facing
		updateFacing();
		// Update graphics
		updateFinal();
	}
	
	override function updateFacing () {
		if (dx > 0)			facing = Dir.RIGHT;
		else if (dx < 0)	facing = Dir.LEFT;
	}
	
	public function die () {
		alive = false;
		draw(0x333333);
	}
	
	function isOnGround () :Bool {
		if (dy != 0)	return false;
		for (i in -1...w+1) {
			if (isSolid(cx + i, cy + h))	return true;
		}
		return false;
	}
	
}