package code;

import flash.display.Shape;
import flash.display.Sprite;
import flash.text.AntiAliasType;
import flash.text.TextField;

/**
 * ...
 * @author 01101101
 */

class Progress extends Sprite {
	
	static var WIDTH:Int = 240;
	static var HEIGHT:Int = 120;
	static var BAR_WIDTH:Int = 160;
	static var BAR_HEIGHT:Int = 30;
	
	var bg:Shape;
	var barBg:Shape;
	var barFg:Shape;
	var tf:TextField;
	var tf2:TextField;
	
	public function new () {
		super();
		
		bg = new Shape();
		bg.graphics.beginFill(0xFFCD22);
		bg.graphics.drawRect(0, 0, WIDTH, HEIGHT);
		bg.graphics.endFill();
		bg.graphics.beginFill(0x061B2C);
		bg.graphics.drawRect(2, 2, WIDTH - 4, HEIGHT - 4);
		bg.graphics.endFill();
		
		barBg = new Shape();
		barBg.graphics.beginFill(0xFFCD22);
		barBg.graphics.drawRect(0, 0, BAR_WIDTH, BAR_HEIGHT);
		barBg.graphics.endFill();
		barBg.graphics.beginFill(0x061B2C);
		barBg.graphics.drawRect(2, 2, BAR_WIDTH - 4, BAR_HEIGHT - 4);
		barBg.graphics.endFill();
		barBg.x = (WIDTH - BAR_WIDTH) / 2;
		barBg.y = (HEIGHT - BAR_HEIGHT) / 2;
		
		barFg = new Shape();
		barFg.graphics.beginFill(0xFFCD22);
		barFg.graphics.drawRect(2, 2, BAR_WIDTH - 4, BAR_HEIGHT - 4);
		barFg.graphics.endFill();
		barFg.x = barBg.x;
		barFg.y = barBg.y;
		barFg.scaleX = 0;
		
		tf = new TextField();
		tf.defaultTextFormat = CodeGame.FORMAT_PROGRESS;
		tf.selectable = false;
		tf.multiline = tf.wordWrap = false;
		tf.width = WIDTH;
		tf.height = 30;
		tf.y = 12;
		
		tf2 = new TextField();
		tf2.defaultTextFormat = CodeGame.FORMAT_PROGRESS_SUB;
		tf2.selectable = false;
		tf2.multiline = tf2.wordWrap = true;
		tf2.text = "Type the words as they appear below";
		tf2.width = WIDTH;
		tf2.height = 20;
		tf2.y = HEIGHT - 33;
		
		addChild(bg);
		addChild(barBg);
		addChild(barFg);
		addChild(tf);
		addChild(tf2);
	}
	
	public function refresh (r:Float) {
		r = Math.max(Math.min(r, 1), 0);
		barFg.scaleX = r;
		if (r < 1)	tf.text = "Module progress: " + Std.int(r * 100) + "%";
		else {
			tf.text = "MODULE COMPLETE";
			tf2.text = "Time to work on another task";
		}
	}
	
}










