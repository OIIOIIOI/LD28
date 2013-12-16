package screens;

import flash.display.Bitmap;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import haxe.Timer;
import openfl.Assets;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

class WaitingScreen extends Screen {
	
	var count:Int;
	var b:Bitmap;
	var tf:TextField;
	var tf2:TextField;
	
	public function new () {
		super();
		
		count = 10;
		
		var s:Sprite = new Sprite();
		
		b = new Bitmap(Assets.getBitmapData("img/screen_ld.png"));
		s.addChild(b);
		
		var f = new TextFormat("Arial", 32, 0x333333, true);
		f.align = TextFormatAlign.CENTER;
		var f2 = new TextFormat("Arial", 18, 0x333333, true);
		f2.align = TextFormatAlign.CENTER;
		
		tf = new TextField();
		tf.defaultTextFormat = f;
		tf.selectable = false;
		tf.multiline = true;
		tf.width = b.width;
		tf.y = 120;
		tf.text = "LD starts in " + count + " seconds\nTheme: ???";
		s.addChild(tf);
		
		tf2 = new TextField();
		tf2.defaultTextFormat = f2;
		tf2.selectable = false;
		tf2.multiline = true;
		tf2.width = b.width;
		tf2.y = 240;
		tf2.text = "Get to work!";
		tf2.visible = false;
		s.addChild(tf2);
		
		var w = new Window(null, "Ludum Dare - Waterfox");
		w.setContent(s);
		w.x = Std.int((Screen.WIDTH - w.width) / 2) + 30 + Std.random(20);
		w.y = Std.int((Screen.HEIGHT - w.height) / 2) + Std.random(30) - 15;
		addChild(w);
		
		Timer.delay(countDown, 1000);
	}
	
	function countDown () {
		if (count > 5) {
			count--;
			Timer.delay(countDown, 1000);
			tf.text = "LD starts in " + count + " seconds\nTheme: ???";
		}
		else if (count > 2) {
			count--;
			Timer.delay(countDown, 1000);
		}
		else if (count > -1) {
			count--;
			Timer.delay(countDown, 1000);
			tf.visible = false;
			b.visible = false;
			tf2.y = 80;
			tf2.text = "www.ludumdare.com\nis not responding\n\nTrying again in a few seconds...";
			tf2.visible = true;
		}
		else {
			tf.text = "LD has started!\nTheme: " + randomTheme();
			tf2.y = 240;
			tf2.text = "Get to work!";
			tf.visible = true;
			tf2.visible = true;
			b.visible = true;
			//
			Clock.instance.pause(false);
		}
	}
	
	function randomTheme () :String {
		return switch (Std.random(9)) {
			case 0:		"Evolution";
			case 1:		"Islands";
			case 2:		"Random";
			case 3:		"Alone";
			case 4:		"Potato";
			case 5:		"You get lots";
			case 6:		"Infection";
			case 7:		"Corruption";
			case 8:		"Minimalist";
			default:	"Kitten";
		}
	}
	
}