package screens;

import flash.events.MouseEvent;
import game.Level;
import Main;
import ui.Button;
import ui.UIObject;

/**
 * ...
 * @author 01101101
 */

class SkillSetupScreen extends Screen {
	
	var nextButton:Button;
	
	public function new () {
		super();
		
		addChild(new Skills());
		
		nextButton = new Button(UIObject.getEmptyFrames(100, 100));
		nextButton.setText("Start");
		nextButton.x = Skills.instance.x;
		nextButton.y = Skills.instance.y + Skills.instance.height + 8;
		addChild(nextButton);
		
		nextButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == nextButton) {
			// Remove graph
			Skills.instance.cleanGraph();
			// Setup level
			if (Skills.instance.artLevel == 1) {
				Level.GRID_SIZE = 16;
				Level.SCALE = 2;
			}
			// Change mode
			//Main.instance.startMode(Mode.Waiting);
		}
	}
	
}