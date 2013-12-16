package ui;
import flash.display.Shape;
import flash.geom.Rectangle;
import flash.text.TextFormat;


/**
 * ...
 * @author 01101101
 */

class PIItem extends RollButton {
	
	public var done(default, null):Bool;
	public var line:Shape;
	
	public function new (frames:Array<Rectangle>, bg:UInt=0xFF999999, border:UInt=0xFF666666) {
		super(frames, bg, border);
		
		done = false;
		
		line = new Shape();
		line.visible = false;
		addChild(line);
	}
	
	override public function setText(txt:String, offsetX:Int = 4, offsetY:Int = 10, format:TextFormat = null) {
		super.setText(txt, offsetX, offsetY, format);
		
		line.graphics.clear();
		line.graphics.beginFill(Main.FORMAT_SUB.color, 1);
		line.graphics.drawRect(-tf.width / 2, -1, tf.width, 2);
		line.graphics.endFill();
		line.x = tf.x + Std.int(tf.width / 2);
		line.y = tf.y + Std.int(tf.height / 2);
		line.rotation = Std.random(3) - 1;
	}
	
	public function setDone (d:Bool) {
		done = d;
		line.visible = done;
		setActive(!done, true);
	}
	
}