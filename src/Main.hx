package ;

import art.ArtEditor;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.net.URLLoader;
import flash.net.URLRequest;
import game.Game;
import game.PFGame;
import openfl.Assets;
import ui.Button;

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
	
	var mode:Mode;
	
	var artEditor:ArtEditor;
	var playGame:PFGame;
	
	#if extLoad
	var debug:Array<String>;
	#end
	
	public static function main () {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
	
	#if extLoad
	public function new () {
		super();
		trace("extLoad");
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
		
		setupUI();
		
		var startData:BitmapData = new BitmapData(128, 128, true, 0x00FF00FF);
		startData.setPixel32(0, 0, 0xFFFFFFFF);
		startData.setPixel32(1, 0, 0xFFFFFFFF);
		startData.setPixel32(2, 0, 0xFFFFFFFF);
		
		artEditor = new ArtEditor(startData);
		artEditor.x = artEditor.y = 100;
		artEditor.edit(Art.Hero);
		
		startMode(Mode.Desktop);
	}
	
	//{ ---- UI ----
	var editorButton:Button;
	var playButton:Button;
	
	function setupUI () {
		editorButton = new Button([new Rectangle(-1, -1, 20, 20)], 0xFF999999, 0xFF666666);
		editorButton.setText("Art", 0, 0);
		editorButton.x = editorButton.y = 8;
		
		playButton = new Button([new Rectangle(-1, -1, 20, 20)], 0xFF999999, 0xFF666666);
		playButton.setText("Play", 0, 0);
		playButton.x = 8;
		playButton.y = 64;
		
		addChild(editorButton);
		addChild(playButton);
		
		editorButton.addEventListener(MouseEvent.CLICK, clickHandler);
		playButton.addEventListener(MouseEvent.CLICK, clickHandler);
	}
	//}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == editorButton) {
			startMode(Mode.ArtEdit);
		} else if (e.currentTarget == playButton) {
			startMode(Mode.PlayTest);
		}
	}
	
	function closeMode () {
		switch (mode) {
			case Mode.ArtEdit:
				if (contains(artEditor))	removeChild(artEditor);
			case Mode.PlayTest:
				removeEventListener(Event.ENTER_FRAME, update);
				if (contains(playGame))	removeChild(playGame);
				playGame.clean();
				playGame = null;
			default:
		}
	}
	
	function startMode (m:Mode) {
		// Close previous mode
		if (mode != null)	closeMode();
		// Start new mode
		switch (m) {
			case Mode.ArtEdit:
				addChild(artEditor);
			case Mode.PlayTest:
				#if extLoad
				playGame = new PFGame(artEditor.data, debug);
				#else
				playGame = new PFGame(artEditor.data);
				#end
				playGame.x = 140;
				playGame.y = 120;
				addChild(playGame);
				addEventListener(Event.ENTER_FRAME, update);
			default:
		}
		mode = m;
	}
	
	function update (e:Event) {
		playGame.update();
	}
	
}

enum Mode {
	Desktop;
	CodeEdit;
	ArtEdit;
	MusicEdit;
	PlayTest;
}








