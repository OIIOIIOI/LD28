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
	var codeSkill:Skill;
	var artSkill:Skill;
	var musicSkill:Skill;
	
	function setupUI () {
		codeSkill = new Skill("Code mastery: ");
		codeSkill.x = 0;
		codeSkill.y = 0;
		
		artSkill = new Skill("Artistic vibe: ");
		artSkill.x = codeSkill.x;
		artSkill.y = codeSkill.y + codeSkill.height + 4;
		
		musicSkill = new Skill("Music writing: ");
		musicSkill.x = codeSkill.x;
		musicSkill.y = artSkill.y + artSkill.height + 4;
		
		addChild(codeSkill);
		addChild(artSkill);
		addChild(musicSkill);
		
		codeSkill.lessButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		codeSkill.moreButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		artSkill.lessButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		artSkill.moreButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		musicSkill.lessButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		musicSkill.moreButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
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
		codeLevel = codeSkill.value;
		artLevel = artSkill.value;
		musicLevel = musicSkill.value;
		updatePoints();
	}
	
	function updatePoints () {
		// Update points
		left = total - codeSkill.value - artSkill.value - musicSkill.value;
		// More buttons
		if (left == 0) {
			codeSkill.moreButton.setActive(false, true);
			artSkill.moreButton.setActive(false, true);
			musicSkill.moreButton.setActive(false, true);
		} else {
			if (codeSkill.value < 3)	codeSkill.moreButton.setActive(true, true);
			else						codeSkill.moreButton.setActive(false, true);
			if (artSkill.value < 3)		artSkill.moreButton.setActive(true, true);
			else						artSkill.moreButton.setActive(false, true);
			if (musicSkill.value < 3)	musicSkill.moreButton.setActive(true, true);
			else						musicSkill.moreButton.setActive(false, true);
		}
		// Less buttons
		if (codeSkill.value > 1)	codeSkill.lessButton.setActive(true, true);
		else						codeSkill.lessButton.setActive(false, true);
		if (artSkill.value > 1)		artSkill.lessButton.setActive(true, true);
		else						artSkill.lessButton.setActive(false, true);
		if (musicSkill.value > 1)	musicSkill.lessButton.setActive(true, true);
		else						musicSkill.lessButton.setActive(false, true);
	}
	
	public function cleanGraph () {
		while (numChildren > 0) {
			removeChild(getChildAt(0));
		}
	}
	
}










