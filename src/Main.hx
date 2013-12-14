package ;

import art.ArtEditor;
import flash.display.BitmapData;
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
		var fakeData:BitmapData = new BitmapData(8, 8, true, 0x00FF00FF);
		fakeData.setPixel32(0, 0, 0xFFFFFFFF);
		fakeData.setPixel32(1, 0, 0xFFFFFFFF);
		fakeData.setPixel32(2, 0, 0xFFFFFFFF);
		
		var e = new ArtEditor();
		e.edit(Art.Hero);
		addChild(e);
		
		//uGame = new PFGame(fakeData);
		//addChild(uGame);
		
		//addEventListener(Event.ENTER_FRAME, update);
	}
	
	function update (e:Event) {
		uGame.update();
	}
	
}
