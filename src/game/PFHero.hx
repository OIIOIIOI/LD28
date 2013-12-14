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
		
		jumpSpeed = -0.8;
		jumpBoost = 2;
	}
	
	public function jump () {
		if (isOnGround()) {
			dy = jumpSpeed;
			dx *= jumpBoost;
		}
	}
	
}