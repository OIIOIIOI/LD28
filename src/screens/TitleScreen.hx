package screens;

import flash.display.Sprite;
import flash.events.MouseEvent;
import Main;
import ui.Button;
import ui.UIObject;

/**
 * ...
 * @author 01101101
 */

class TitleScreen extends Screen {
	
	var bg:Sprite;
	var startButton:Button;
	var started:Bool;
	
	public function new () {
		super();
		
		started = false;
		
		bg = new Sprite();
		bg.graphics.beginFill(0x000000);
		bg.graphics.drawRect(0, 0, 640, 480);
		bg.graphics.endFill();
		addChild(bg);
		
		startButton = new Button(UIObject.getEmptyFrames(100, 20), 0, 0);
		startButton.setText("START", 0, 0);
		startButton.x = (Screen.WIDTH - startButton.width) / 2;
		startButton.y = (Screen.HEIGHT - startButton.height) / 2;
		addChild(startButton);
		
		startButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == startButton) {
			removeChild(startButton);
			started = true;
		}
	}
	
	override public function update () {
		super.update();
		if (started) {
			//bg.alpha *= 0.9;
			bg.alpha = 0;
			if (bg.alpha < 0.05) {
				Main.instance.startMode(Mode.Setup);
			}
		}
	}
	
}