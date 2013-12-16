package ui;

import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * ...
 * @author 01101101
 */

class RollButton extends Button {
	
	var highlight:Sprite;
	
	public function new (frames:Array<Rectangle>, bg:UInt=0xFF999999, border:UInt=0xFF666666) {
		super(frames, bg, border);
		
		highlight = new Sprite();
		highlight.visible = false;
		addChild(highlight);
		
		setActive(active);
	}
	
	override public function setActive (a:Bool = true, setAlpha:Bool = false) {
		super.setActive(a, setAlpha);
		if (a) {
			addEventListener(MouseEvent.ROLL_OVER, overHandler, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, outHandler, false, 0, true);
		} else {
			removeEventListener(MouseEvent.ROLL_OVER, overHandler);
			removeEventListener(MouseEvent.ROLL_OUT, outHandler);
		}
	}
	
	override public function setText (txt:String, offsetX:Int = 4, offsetY:Int = 10, format:TextFormat = null) {
		super.setText(txt, offsetX, offsetY, format);
		tf.autoSize = TextFieldAutoSize.CENTER;
		highlight.graphics.clear();
		highlight.graphics.beginFill(Main.FORMAT_SUB.color, 1);
		highlight.graphics.drawRect(0, 3, tf.width, tf.height - 6);
		highlight.graphics.endFill();
		highlight.x = tf.x;
		highlight.y = tf.y;
	}
	
	function overHandler (e:MouseEvent) {
		if (!active)	return;
		highlight.visible = true;
		var f = tf.getTextFormat();
		f.color = 0xFFFFFF;
		tf.setTextFormat(f);
	}
	
	function outHandler (e:MouseEvent) {
		if (!active)	return;
		highlight.visible = false;
		tf.setTextFormat(Main.FORMAT_SUB);
	}
	
}