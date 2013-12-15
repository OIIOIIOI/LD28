package screens;

import flash.events.MouseEvent;
import Main;
import ui.Button;
import ui.UIObject;

/**
 * ...
 * @author 01101101
 */

class DesktopScreen extends Screen {
	
	//var editorButton:Button;
	//var playButton:Button;
	
	public function new () {
		super();
		
		/*editorButton = new Button(UIObject.getEmptyFrames(40, 40));
		editorButton.setText("Art", 0, 0);
		editorButton.x = editorButton.y = 8;
		
		playButton = new Button(UIObject.getEmptyFrames(40, 40));
		playButton.setText("Play", 0, 0);
		playButton.x = editorButton.x;
		playButton.y = editorButton.y + editorButton.height + 8;
		
		addChild(editorButton);
		addChild(playButton);*/
		
		//editorButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		//playButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
	}
	
	function clickHandler (e:MouseEvent) {
		/*if (e.currentTarget == editorButton) {
			Main.instance.startMode(Mode.ArtEdit);
		} else if (e.currentTarget == playButton) {
			Main.instance.startMode(Mode.PlayTest);
		}*/
	}
	
}










