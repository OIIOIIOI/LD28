package screens;

import art.ArtEditor;
import flash.display.Bitmap;
import flash.display.Sprite;
import game.Level;
import game.PFGame;
import haxe.Timer;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

class GameScreen extends Screen {
	
	var window:Window;
	var winContent:Sprite;
	
	var playGame:PFGame;
	
	var level:Int;
	
	public function new () {
		super();
		
		winContent = new Sprite();
		
		window = new Window(null, "LD Prototype");
		window.setContent(winContent);
		addChild(window);
		
		level = 0;
		loadNext();
	}
	
	override public function update () {
		super.update();
		if (playGame != null)	playGame.update();
	}
	
	function endLevel (win:Bool) {
		if (win)	level++;
		Timer.delay(loadNext, 1000);
	}
	
	function loadNext () {
		if (playGame != null)	winContent.removeChild(playGame);
		
		playGame = new PFGame(Main.instance.data, endLevel);
		playGame.scaleX = playGame.scaleY = Level.SCALE * 0.75;
		winContent.addChild(playGame);
		
		playGame.loadLevel(level);
	}
	
}










