package ;

import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import game.Game;
import game.PFGame;

/**
 * ...
 * @author 01101101
 */

class Main extends Sprite {
	
	public static var TAR:Rectangle = new Rectangle();
	public static var TAP:Point = new Point();
	
	var uGame:Game;
	
	public static function main () {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
	
	public function new () {
		super();
		
		//uGame = new Game();
		uGame = new PFGame();
		addChild(uGame);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event) {
		uGame.update();
	}
	
}
