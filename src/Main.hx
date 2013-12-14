package ;

import art.ArtEditor;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.net.URLLoader;
import flash.net.URLRequest;
import game.Game;
import game.PFGame;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

class Main extends Sprite {
	
	public static var TAM:Matrix = new Matrix();
	public static var TAP:Point = new Point();
	public static var TAR:Rectangle = new Rectangle();
	public static var UI_ATLAS:BitmapData;
	public static var LEVELS:BitmapData;
	
	var uGame:Game;
	#if extLoad
	var debug:Array<String>;
	#end
	
	public static function main () {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		
		#if extLoad
		trace("extLoad");
		#end
	}
	
	#if extLoad
	public function new () {
		super();
		var l:URLLoader = new URLLoader();
		l.addEventListener(Event.COMPLETE, txtCompleteHandler);
		l.load(new URLRequest("C:/debug.txt"));
	}
	
	function txtCompleteHandler (e:Event) {
		debug = cast(e.currentTarget, URLLoader).data.split(",");
		var l = new Loader();
		l.contentLoaderInfo.addEventListener(Event.COMPLETE, imgCompleteHandler);
		l.load(new URLRequest("C:/levels.png"));
	}
	
	function imgCompleteHandler (e:Event) {
		LEVELS = e.currentTarget.loader.content.bitmapData;
		init();
	}
	#else
	public function new () {
		super();
		init();
	}
	#end
	
	function init () {
		// Init UI textures and levels
		UI_ATLAS = Assets.getBitmapData("img/UI.png");
		#if !extLoad
		LEVELS = Assets.getBitmapData("img/levels.png");
		#end
		
		var fakeData:BitmapData = new BitmapData(128, 128, true, 0x00FF00FF);
		fakeData.setPixel32(0, 0, 0xFFFFFFFF);
		fakeData.setPixel32(1, 0, 0xFFFFFFFF);
		fakeData.setPixel32(2, 0, 0xFFFFFFFF);
		
		var e = new ArtEditor(fakeData);
		e.edit(Art.Hero);
		addChild(e);
		
		/*#if extLoad
		uGame = new PFGame(fakeData, debug);
		#else
		uGame = new PFGame(fakeData);
		#end
		addChild(uGame);
		addEventListener(Event.ENTER_FRAME, update);*/
	}
	
	/*function update (e:Event) {
		uGame.update();
	}*/
	
}
