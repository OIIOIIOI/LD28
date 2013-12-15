package ui;

import flash.display.Sprite;
import flash.geom.Rectangle;


/**
 * ...
 * @author 01101101
 */

class Skill extends Sprite {
	
	var label:UIObject;
	public var lessButton:Button;
	var starA:UIObject;
	var starB:UIObject;
	var starC:UIObject;
	public var moreButton:Button;
	
	public var value(default, null):Int;
	
	public function new (text:String) {
		super();
		
		label = new UIObject(UIObject.getEmptyFrames(160, 24));
		label.setText(text, 0, 4);
		
		lessButton = new Button(UIObject.getEmptyFrames(24, 24));
		lessButton.setText("-", 0, 4);
		lessButton.x = label.x + label.width + 4;
		lessButton.y = label.y;
		
		starA = new UIObject([new Rectangle(0, 0, 16, 16), new Rectangle(16, 0, 16, 16)]);
		starA.x = lessButton.x + lessButton.width + 4;
		starA.y = label.y + 4;
		
		starB = new UIObject([new Rectangle(0, 0, 16, 16), new Rectangle(16, 0, 16, 16)]);
		starB.x = starA.x + starA.width + 4;
		starB.y = starA.y;
		
		starC = new UIObject([new Rectangle(0, 0, 16, 16), new Rectangle(16, 0, 16, 16)]);
		starC.x = starB.x + starB.width + 4;
		starC.y = starA.y;
		
		moreButton = new Button(UIObject.getEmptyFrames(24, 24));
		moreButton.setText("+", 0, 4);
		moreButton.x = starC.x + starC.width + 4;
		moreButton.y = label.y;
		
		addChild(label);
		addChild(lessButton);
		addChild(starA);
		addChild(starB);
		addChild(starC);
		addChild(moreButton);
		
		setValue(1);
	}
	
	public function setValue (v:Int) {
		value = Std.int(Math.min(Math.max(v, 1), 3));
		starA.current = starB.current = starC.current = 0;
		if (value >= 1)	starA.current = 1;
		if (value >= 2)	starB.current = 1;
		if (value == 3)	starC.current = 1;
		starA.render();
		starB.render();
		starC.render();
	}
	
}