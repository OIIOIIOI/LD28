package screens;

import flash.events.MouseEvent;
import Main;
import ui.Button;
import ui.UIObject;

/**
 * ...
 * @author 01101101
 */

class TitleScreen extends Screen {
	
	var startButton:Button;
	
	public function new () {
		super();
		
		startButton = new Button(UIObject.getEmptyFrames(100, 100));
		startButton.setText("START");
		addChild(startButton);
		
		startButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == startButton) {
			Main.instance.startMode(Mode.TimeSetup);
		}
	}
	
}