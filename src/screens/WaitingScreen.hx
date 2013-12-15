package screens;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import openfl.Assets;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

class WaitingScreen extends Screen {
	
	public function new () {
		super();
		
		var s:Sprite = new Sprite();
		
		var b = new Bitmap(Assets.getBitmapData("img/screen_ld.png"));
		s.addChild(b);
		
		var f = new TextFormat("Arial", 32, 0x000000, true);
		f.align = TextFormatAlign.CENTER;
		
		var tf:TextField = new TextField();
		tf.defaultTextFormat = f;
		tf.selectable = false;
		tf.width = b.width;
		tf.y = 120;
		tf.text = "starts in 10s";
		s.addChild(tf);
		
		var w = new Window();
		w.setContent(s);
		w.x = Std.int((Screen.WIDTH - w.width) / 2);
		w.y = Std.int((Screen.HEIGHT - w.height) / 2);
		addChild(w);
	}
	
}