package music;

import flash.display.Sprite;
import music.MusicGame.SndObj;

/**
 * ...
 * @author 01101101
 */

class MusicBlock extends Sprite {
	
	public var snd(default, null):SndObj;
	
	var h:Float;
	var isLast:Bool;
	
	public function new (snd:SndObj, isLast:Bool) {
		super();
		
		this.snd = snd;
		this.isLast = isLast;
		
		if (!isLast)	h = snd.length / MusicGame.SCALE;
		else			h = 1000;
		
		draw(MusicBlock.getColor(snd.inst));
	}
	
	function draw (c:UInt) {
		graphics.clear();
		graphics.beginFill(c);
		graphics.drawRect(MusicTrack.GUTTER / 2, 0, MusicTrack.WIDTH - MusicTrack.GUTTER, -4);
		graphics.endFill();
		graphics.beginFill(c, 0.7);
		graphics.drawRect(MusicTrack.GUTTER / 2, -4, MusicTrack.WIDTH - MusicTrack.GUTTER, -h);
		graphics.endFill();
	}
	
	public function done (win:Bool = true) {
		snd.result = (win) ? 1 : 0;
		if (win)	draw(MusicBlock.getColor(4));
		else		draw(MusicBlock.getColor(3));
	}
	
	public function reset (complete:Bool = false) {
		draw(MusicBlock.getColor(snd.inst));
		if (complete)	snd.result = 0;
	}
	
	public static function getColor (inst:Int) :UInt {
		return switch (inst) {
			case 0:		0x8BA4A9;
			case 1:		0x706B7F;
			case 2:		0x5A3556;
			case 3:		0xCC333F;//fail
			default:	0xCBE86B;//win
		}
	}
	
}










