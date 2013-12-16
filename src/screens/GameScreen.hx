package screens;

import art.ArtEditor;
import flash.display.Bitmap;
import flash.display.Sprite;
import game.Level;
import game.PFGame;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

class GameScreen extends Screen {
	
	var window:Window;
	var winContent:Sprite;
	
	var playGame:PFGame;
	
	public function new () {
		super();
		
		winContent = new Sprite();
		
		window = new Window(null, "LD Prototype");
		window.setContent(winContent);
		addChild(window);
		
		#if extLoad
		playGame = new PFGame(ArtEditor.instance.data, debug);
		#else
		playGame = new PFGame(Main.instance.data);
		#end
		playGame.scaleX = playGame.scaleY = Level.SCALE * 0.75;
		winContent.addChild(playGame);
	}
	
	override public function update () {
		super.update();
		playGame.update();
	}
	
}










