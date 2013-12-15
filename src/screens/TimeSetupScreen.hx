package screens;

import Clock;
import flash.events.MouseEvent;
import Main;
import ui.Button;
import ui.UIObject;

/**
 * ...
 * @author 01101101
 */

class TimeSetupScreen extends Screen {
	
	var compoButton:Button;
	var jamButton:Button;

	public function new () {
		super();
		
		compoButton = new Button(UIObject.getEmptyFrames(100, 100));
		compoButton.setText("Compo");
		addChild(compoButton);
		
		jamButton = new Button(UIObject.getEmptyFrames(100, 100));
		jamButton.setText("Jam");
		jamButton.x = compoButton.x + compoButton.width + 8;
		jamButton.y = compoButton.y;
		addChild(jamButton);
		
		compoButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		jamButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == compoButton) {
			Clock.instance.setMode(LDMode.Compo);
			Main.instance.startMode(Mode.SkillSetup);
		} else if (e.currentTarget == jamButton) {
			Clock.instance.setMode(LDMode.Jam);
			Main.instance.startMode(Mode.SkillSetup);
		}
	}
	
}