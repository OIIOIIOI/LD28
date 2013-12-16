package ui;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.Font;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

class UIObject extends Sprite {
	
	var frames:Array<Rectangle>;
	public var current:Int;
	
	var data:BitmapData;
	var dataB:Bitmap;
	
	public var customData:Dynamic;
	
	public var tf:TextField;
	static public var FONT:Font;
	static public var FORMAT:TextFormat;
	static public var FORMAT_WHITE:TextFormat;
	static public var FORMAT_LEFT:TextFormat;
	static public var FORMAT_RIGHT:TextFormat;
	
	public var active(default, null):Bool;
	
	public function new (frames:Array<Rectangle>, bg:UInt = 0xFF999999, border:UInt = 0xFF666666) {
		super();
		
		if (FONT == null)	FONT = Assets.getFont("fonts/lucon.ttf");
		if (FORMAT == null) {
			FORMAT = new TextFormat(FONT.fontName, 14, 0xFF333333);
			FORMAT.align = TextFormatAlign.CENTER;
			
			FORMAT_WHITE = new TextFormat(FONT.fontName, 14, 0xFFFFFFFF);
			FORMAT_WHITE.align = TextFormatAlign.CENTER;
			
			FORMAT_LEFT = new TextFormat(FONT.fontName, 14, 0xFF333333);
			
			FORMAT_RIGHT = new TextFormat(FONT.fontName, 14, 0xFF333333);
			FORMAT_RIGHT.align = TextFormatAlign.RIGHT;
		}
		
		this.frames = frames;
		current = 0;
		
		data = new BitmapData(Std.int(frames[0].width), Std.int(frames[0].height), true, 0x00FF00FF);
		if (frames[0].x == -1 && frames[0].y == -1) {
			data.fillRect(data.rect, border);
			data.fillRect(new Rectangle(1, 1, data.width - 2, data.height - 2), bg);
		}
		else render();
		
		dataB = new Bitmap(data);
		//dataB.scaleX = dataB.scaleY = 2;
		addChild(dataB);
		
		active = true;
		
		mouseChildren = false;
		addEventListener(MouseEvent.RIGHT_CLICK, rightClickHandler);
	}
	
	public function setActive (a:Bool = true, setAlpha:Bool = false) {
		active = a;
		if (setAlpha)	alpha = (active) ? 1 : 0.5;
	}
	
	public function render () {
		Main.TAP.x = Main.TAP.y = 0;
		data.copyPixels(Main.UI_ATLAS, frames[current], Main.TAP);
	}
	
	public function setText (txt:String, offsetX:Int = 4, offsetY:Int = 10, format:TextFormat = null) {
		if (format == null)	format = FORMAT;
		if (tf == null) {
			tf = new TextField();
			tf.embedFonts = true;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.defaultTextFormat = format;
			tf.selectable = tf.multiline = tf.wordWrap = false;
			tf.x = offsetX;
			tf.y = offsetY;
			tf.width = dataB.width - offsetX * 2;
			tf.height = dataB.height - offsetY;
			addChild(tf);
		}
		tf.text = txt;
	}
	
	function rightClickHandler (e:MouseEvent) {
		e.preventDefault();
	}
	
	public function clean () {
		data.dispose();
		data = null;
	}
	
	public static function getEmptyFrames (w:Int, h:Int, n:Int = 1) :Array<Rectangle> {
		var f = new Array<Rectangle>();
		for (i in 0...n) {
			f.push(new Rectangle(-1, -1, w, h));
		}
		return f;
	}
	
}










