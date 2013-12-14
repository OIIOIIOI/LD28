package game;


/**
 * ...
 * @author 01101101
 */

class PFEntity extends Entity {
	
	var gravity:Float;
	
	public function new (w:Int=1, h:Int=1) {
		super(w, h);
		
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
	
	function isOnGround () :Bool {
		if (dy != 0)	return false;
		for (i in -1...w+1) {
			if (isSolid(cx + i, cy + h))	return true;
		}
		return false;
	}
	
}