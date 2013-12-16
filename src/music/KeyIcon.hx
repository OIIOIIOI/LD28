package music;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;


/**
 * ...
 * @author 01101101
 */

class KeyIcon extends Sprite {
	
	var tf:TextField;
	
	public function new (inst:Int) {
		super();
		
		var f = new TextFormat("Arial", 48, MusicBlock.getColor(inst), true);
		f.align = TextFormatAlign.CENTER;
		
		tf = new TextField();
		tf.defaultTextFormat = f;
		tf.selectable = tf.multiline = false;
		tf.width = MusicTrack.WIDTH;
		tf.text = switch (inst) {
			case 0:		"J";
			case 1:		"K";
			default:	"L";
		}
		addChild(tf);
	}
	
}