package music;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.ui.Keyboard;


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
		tf.text = switch (MusicGame.getCorrectKey(inst)) {
			case Keyboard.J:	"J";
			case Keyboard.K:	"K";
			case Keyboard.L:	"L";
			default:			"?";
		}
		addChild(tf);
	}
	
}