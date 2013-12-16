package ui;

import flash.display.Sprite;
import flash.events.MouseEvent;


/**
 * ...
 * @author 01101101
 */

class Palette extends Sprite {
	
	public function new (handler:MouseEvent->Void) {
		super();
		
		var a = getColors();
		var s:Button;
		for (i in 0...a.length) {
			s = new Button(UIObject.getEmptyFrames(30, 30), 0xFF000000 + a[i], 0xFFC5C9CA);
			s.customData = a[i];
			s.x = 30 * (i % 2);
			s.y = Std.int(i / 2) * 30;
			addChild(s);
			s.addEventListener(MouseEvent.CLICK, handler);
		}
	}
	
	public static function getColors () :Array<UInt> {
		var a = new Array<UInt>();
		switch (Skills.instance.artLevel) {
			case 1:
				a.push(0x000000);
				a.push(0xDF0024);
				a.push(0xF9F400);
				a.push(0x00A9EC);
				a.push(0xF59E9C);
				a.push(0x00B034);
			case 2:
				a.push(0x000000);
				a.push(0x595959);
				a.push(0xCC4B45);
				a.push(0xF9E781);
				a.push(0x8EAAD3);
				a.push(0x90C993);
				a.push(0xEDBE86);
				a.push(0xC8A46D);
			default:
				a.push(0xF9E781);
				a.push(0xB7B974);
				a.push(0xEDBE86);
				a.push(0xAE9878);
				a.push(0xCC4B45);
				a.push(0x963C3E);
				a.push(0x8EAAD3);
				a.push(0x6888BD);
				a.push(0x9781B6);
				a.push(0x6F67A3);
				a.push(0x90C993);
				a.push(0x6AA184);
				a.push(0xC8A46D);
				a.push(0x938362);
				a.push(0x595959);
				a.push(0x424750);
				a.push(0x000000);
				a.push(0xFFFFFF);
		}
		return a;
	}
	
}