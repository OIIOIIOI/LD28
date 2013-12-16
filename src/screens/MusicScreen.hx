package screens;

import flash.display.Sprite;
import music.MusicGame;
import music.MusicTrack;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

class MusicScreen extends Screen {
	
	var window:Window;
	var winContent:Sprite;
	
	var musicGame:MusicGame;
	
	public function new () {
		super();
		
		winContent = new Sprite();
		
		window = new Window(null, "Garage Band Hero");
		window.setContent(winContent);
		addChild(window);
		
		musicGame = new MusicGame();
		musicGame.x = 180;
		musicGame.y = 360 - MusicTrack.WIDTH;
		winContent.addChild(musicGame);
	}
	
	override public function update () {
		super.update();
		musicGame.update();
	}
	
	override public function clean () {
		super.clean();
		musicGame.stop();
	}
	
}