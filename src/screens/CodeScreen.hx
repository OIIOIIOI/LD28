package screens;
import code.CodeGame;
import flash.display.Shape;
import flash.display.Sprite;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

class CodeScreen extends Screen {
	
	var window:Window;
	var winContent:Sprite;
	
	var codeGame:CodeGame;
	
	var bg:Shape;
	
	public function new () {
		super();
		
		winContent = new Sprite();
		
		bg = new Shape();
		bg.graphics.beginFill(0x1C3142);
		bg.graphics.drawRect(0, 0, Window.WIDTH, Window.HEIGHT);
		bg.graphics.endFill();
		winContent.addChild(bg);
		
		window = new Window(null, "CodePad+++");
		window.setContent(winContent);
		addChild(window);
		
		codeGame = new CodeGame();
		winContent.addChild(codeGame);
	}
	
	override public function update () {
		super.update();
		codeGame.update();
	}
	
	override public function clean () {
		super.clean();
		codeGame.stop();
	}
	
}










