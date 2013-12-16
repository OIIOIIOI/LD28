package ;

import flash.display.Sprite;
import flash.errors.Error;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextFormat;
import ui.Skill;
import ui.Switch;
import ui.UIObject;

/**
 * ...
 * @author 01101101
 */

class Skills extends Sprite {
	
	public static var instance:Skills;
	
	public var codeLevel:Int = 1;
	public var artLevel:Int = 1;
	public var musicLevel:Int = 1;
	//public var orgaLevel:Int = 1;
	
	var total:Int;
	public var left:Int;
	
	public function new () {
		super();
		
		if (instance != null)	throw new Error("Already instanciated");
		instance = this;
		
		setupUI();
		
		total = 6;
		updatePoints();
	}
	
	//{ ---- UI ----
	//var pointsLabel:UIObject;
	var codeSkill:Skill;
	var artSkill:Skill;
	var musicSkill:Skill;
	//var orgaSkill:Skill;
	
	function setupUI () {
		//pointsLabel = new UIObject(UIObject.getEmptyFrames(160, 24), 0, 0);
		
		codeSkill = new Skill("Code mastery: ");
		codeSkill.x = 0;
		codeSkill.y = 0;
		//codeSkill.x = pointsLabel.x;
		//codeSkill.y = pointsLabel.y + pointsLabel.height + 4;
		
		artSkill = new Skill("Artistic vibe: ");
		artSkill.x = codeSkill.x;
		artSkill.y = codeSkill.y + codeSkill.height + 4;
		
		musicSkill = new Skill("Music writing: ");
		musicSkill.x = codeSkill.x;
		musicSkill.y = artSkill.y + artSkill.height + 4;
		
		/*orgaSkill = new Skill("Time management: ");
		orgaSkill.x = codeSkill.x;
		orgaSkill.y = musicSkill.y + musicSkill.height + 4;*/
		
		//addChild(pointsLabel);
		addChild(codeSkill);
		addChild(artSkill);
		addChild(musicSkill);
		//addChild(orgaSkill);
		
		codeSkill.lessButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		codeSkill.moreButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		artSkill.lessButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		artSkill.moreButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		musicSkill.lessButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		musicSkill.moreButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		//orgaSkill.lessButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		//orgaSkill.moreButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
	}
	//}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == codeSkill.lessButton && codeSkill.value > 1) {
			codeSkill.setValue(codeSkill.value - 1);
		} else if (e.currentTarget == codeSkill.moreButton && left > 0) {
			codeSkill.setValue(codeSkill.value + 1);
		}
		if (e.currentTarget == artSkill.lessButton && artSkill.value > 1) {
			artSkill.setValue(artSkill.value - 1);
		} else if (e.currentTarget == artSkill.moreButton && left > 0) {
			artSkill.setValue(artSkill.value + 1);
		}
		if (e.currentTarget == musicSkill.lessButton && musicSkill.value > 1) {
			musicSkill.setValue(musicSkill.value - 1);
		} else if (e.currentTarget == musicSkill.moreButton && left > 0) {
			musicSkill.setValue(musicSkill.value + 1);
		}
		/*if (e.currentTarget == orgaSkill.lessButton && orgaSkill.value > 1) {
			orgaSkill.setValue(orgaSkill.value - 1);
		} else if (e.currentTarget == orgaSkill.moreButton && left > 0) {
			orgaSkill.setValue(orgaSkill.value + 1);
		}*/
		codeLevel = codeSkill.value;
		artLevel = artSkill.value;
		musicLevel = musicSkill.value;
		//orgaLevel = orgaSkill.value;
		updatePoints();
	}
	
	function updatePoints () {
		// Update points
		//left = total - codeSkill.value - artSkill.value - musicSkill.value - orgaSkill.value;
		left = total - codeSkill.value - artSkill.value - musicSkill.value;
		//pointsLabel.setText("Points left: " + left, 0, 4);
		// More buttons
		if (left == 0) {
			codeSkill.moreButton.alpha = 0.5;
			artSkill.moreButton.alpha = 0.5;
			musicSkill.moreButton.alpha = 0.5;
			//orgaSkill.moreButton.alpha = 0.5;
		} else {
			if (codeSkill.value < 3)	codeSkill.moreButton.alpha = 1;
			else						codeSkill.moreButton.alpha = 0.5;
			if (artSkill.value < 3)		artSkill.moreButton.alpha = 1;
			else						artSkill.moreButton.alpha = 0.5;
			if (musicSkill.value < 3)	musicSkill.moreButton.alpha = 1;
			else						musicSkill.moreButton.alpha = 0.5;
			//if (orgaSkill.value < 3)	orgaSkill.moreButton.alpha = 1;
			//else						orgaSkill.moreButton.alpha = 0.5;
		}
		// Less buttons
		if (codeSkill.value > 1)	codeSkill.lessButton.alpha = 1;
		else						codeSkill.lessButton.alpha = 0.5;
		if (artSkill.value > 1)		artSkill.lessButton.alpha = 1;
		else						artSkill.lessButton.alpha = 0.5;
		if (musicSkill.value > 1)	musicSkill.lessButton.alpha = 1;
		else						musicSkill.lessButton.alpha = 0.5;
		//if (orgaSkill.value > 1)	orgaSkill.lessButton.alpha = 1;
		//else						orgaSkill.lessButton.alpha = 0.5;
	}
	
	public function cleanGraph () {
		while (numChildren > 0) {
			removeChild(getChildAt(0));
		}
	}
	
}










