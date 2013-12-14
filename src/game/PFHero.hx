package game;


/**
 * ...
 * @author 01101101
 */

class PFHero extends PFEntity {
	
	var jumpSpeed:Float;
	var jumpBoost:Float;
	
	public function new (w:Int=1, h:Int=1) {
		super(w, h);
		
		hSpeed = 0.02;
		jumpSpeed = -0.8;
		jumpBoost = 2.2;
	}
	
	public function jump (force:Bool = false) {
		if (isOnGround() || force) {
			dy = jumpSpeed;
			dx *= jumpBoost;
		}
	}
	
	public function collideEntity (e:PFEntity) {
		if (bottom() > e.top() &&
			top() < e.bottom() &&
			right() > e.left() &&
			left() < e.right()) {
			return true;
		}
		return false;
	}
	
}