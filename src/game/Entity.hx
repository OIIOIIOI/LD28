package game;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;

/**
 * ...
 * @author 01101101
 */

class Entity {
	
	// Cell coords
	public var cx:Int;
	public var cy:Int;
	// Cell ratio
	public var xr:Float;
	public var yr:Float;
	// Resulting coords
	public var xx:Int;
	public var yy:Int;
	// Movements
	public var dx:Float;
	public var dy:Float;
	// Friction
	var friction:Float;
	// Min/max cell ratio
	var min:Float = 0.45;
	var max:Float = 0.55;
	// Entity size
	public var w:Int;
	public var h:Int;
	// Facing
	var facing:Dir;
	// Entity speed
	var hSpeed:Float;
	var vSpeed:Float;
	
	// Collision function
	public var collide:Int->Int->Bool;
	var isSolid:Bool;
	
	// Graphic asset
	public var spriteData:BitmapData;
	public var sprite:Sprite;
	
	public function new (w:Int = 1, h:Int = 1) {
		this.w = w;
		this.h = h;
		
		dx = dy = 0;
		
		hSpeed = 0.01;
		vSpeed = 0.01;
		friction = 0.9;
		
		isSolid = true;
		
		spriteData = new BitmapData(Level.GRID_SIZE * w, Level.GRID_SIZE * h, true, 0x00FF00FF);
		
		var b = new Bitmap(spriteData);
		b.x = b.y = -Level.GRID_SIZE / 2;
		
		sprite = new Sprite();
		sprite.addChild(b);
		
		draw();
	}
	
	public function move (dir:Dir) {
		switch (dir) {
			case Dir.RIGHT:	dx += hSpeed;
			case Dir.LEFT:	dx -= hSpeed;
			case Dir.DOWN:	dy += vSpeed;
			case Dir.UP:	dy -= vSpeed;
			default:
		}
	}
	
	public function update () {
		// Apply movement X
		xr += dx;
		updateX();
		// Apply movement Y
		yr += dy;
		updateY();
		// Update facing
		updateFacing();
		// Update graphics
		updateFinal();
	}
	
	function updateX () {
		// Adjust positions if out of the current cell
		while (xr > 1) {
			if (isSolid && dx > 0 && fastColl(Dir.RIGHT)) {
				xr = max;
				dx = 0;
			} else {
				xr -= 1;
				cx++;
			}
		}
		while (xr < 0) {
			if (isSolid && dx < 0 && fastColl(Dir.LEFT)) {
				xr = max;
				dx = 0;
			} else {
				xr += 1;
				cx--;
			}
		}
		// Friction
		dx *= friction;
		// Collisions
		if (isSolid)	collX();
	}
	
	function updateY () {
		// Adjust positions if out of the current cell
		while (yr > 1) {
			if (isSolid && dy > 0 && fastColl(Dir.DOWN)) {
				yr = max;
				dy = 0;
				break;
			} else {
				yr -= 1;
				cy++;
			}
		}
		while (yr < 0) {
			if (isSolid && dy < 0 && fastColl(Dir.UP)) {
				yr = min;
				dy = 0;
				dx *= 0.25;
				break;
			} else {
				yr += 1;
				cy--;
			}
		}
		// Friction
		dy *= friction;
		// Collisions
		if (isSolid)	collY();
	}
	
	function fastColl (dir:Dir) :Bool {
		switch (dir) {
			case Dir.UP:
				for (i in 0...w) {
					if (collide(cx + i, cy - 1))	return true;
				}
				if (xr < min && collide(cx - 1, cy - 1))	return true;
				if (xr > max && collide(cx + w, cy - 1))	return true;
			case Dir.DOWN:
				for (i in 0...w) {
					if (collide(cx + i, cy + h))	return true;
				}
				if (xr < min && collide(cx - 1, cy + h))	return true;
				if (xr > max && collide(cx + w, cy + h))	return true;
			case Dir.LEFT:
				for (i in 0...h) {
					if (collide(cx - 1, cy + i))	return true;
				}
				if (yr < min && collide(cx - 1, cy - 1))	return true;
				if (yr > max && collide(cx - 1, cy + h))	return true;
			case Dir.RIGHT:
				for (i in 0...h) {
					if (collide(cx + w, cy + i))	return true;
				}
				if (yr < min && collide(cx + w, cy - 1))	return true;
				if (yr > max && collide(cx + w, cy + h))	return true;
			default:
		}
		return false;
	}
	
	function collX () :Bool {
		// Sides
		for (i in 0...h) {
			if (xr > max && collide(cx + w, cy + i)) {
				xr = max;
				dx = 0;
				return true;
			}
			if (xr < min && collide(cx - 1, cy + i)) {
				xr = min;
				dx = 0;
				return true;
			}
		}
		// Corners
		if (yr > max && xr > max && collide(cx + w, cy + h)) {
			xr = max;
			dx = 0;
			return true;
		} else if (yr < min && xr > max && collide(cx + w, cy - 1)) {
			xr = max;
			dx = 0;
			return true;
		}
		if (yr > max && xr < min && collide(cx - 1, cy + h)) {
			xr = min;
			dx = 0;
			return true;
		} else if (yr < min && xr < min && collide(cx - 1, cy - 1)) {
			xr = min;
			dx = 0;
			return true;
		}
		return false;
	}
	
	function collY () :Bool {
		// Sides
		for (i in 0...w) {
			if (yr > max && collide(cx + i, cy + h)) {
				yr = max;
				dy = 0;
				return true;
			}
			if (yr < min && collide(cx + i, cy - 1)) {
				yr = min;
				dy = 0;
				return true;
			}
		}
		// Corners
		if (xr > max && yr > max && collide(cx + w, cy + h)) {
			yr = max;
			dy = 0;
			return true;
		} else if (xr < min && yr > max && collide(cx - 1, cy + h)) {
			yr = max;
			dy = 0;
			return true;
		}
		if (xr > max && yr < min && collide(cx + w, cy - 1)) {
			yr = min;
			dy = 0;
			return true;
		} else if (xr < min && yr < min && collide(cx - 1, cy - 1)) {
			yr = min;
			dy = 0;
			return true;
		}
		return false;
	}
	
	function updateFacing () {
		if (Math.abs(dx) > Math.abs(dy)) {
			if (dx > 0)	facing = Dir.RIGHT;
			else		facing = Dir.LEFT;
		} else if (Math.abs(dx) < Math.abs(dy)) {
			if (dy > 0)	facing = Dir.DOWN;
			else		facing = Dir.UP;
		}
	}
	
	function updateFinal () {
		// Update final coords
		xx = Std.int((cx + xr) * Level.GRID_SIZE);
		yy = Std.int((cy + yr) * Level.GRID_SIZE);
		// Update graphics
		sprite.x = xx;
		sprite.y = yy;
	}
	
	public function setCoords (x:Int, y:Int) {
		xx = x;
		yy = y;
		cx = Std.int(xx / Level.GRID_SIZE);
		cy = Std.int(yy / Level.GRID_SIZE);
		xr = (xx - cx * Level.GRID_SIZE) / Level.GRID_SIZE;
		yr = (yy - cy * Level.GRID_SIZE) / Level.GRID_SIZE;
	}
	
	function draw () {
		spriteData.fillRect(spriteData.rect, 0xFFFF00FF);
	}
	
	public function top () :Float {		return (cy + yr); }
	public function bottom () :Float {	return (cy + h + yr); }
	public function left () :Float {	return (cx + xr); }
	public function right () :Float {	return (cx + w + xr); }
	
}

enum Dir {
	NONE;
	UP;
	LEFT;
	DOWN;
	RIGHT;
}










