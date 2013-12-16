package ;

import art.ArtEditor;
import Clock;
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
import flash.text.Font;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import game.Game;
import game.Level;
import game.PFGame;
import music.MusicTest;
import music.MusicTest2;
import openfl.Assets;
import screens.DesktopScreen;
import screens.Screen;
import screens.SetupScreen;
import screens.SkillSetupScreen;
import screens.TitleScreen;
import screens.WaitingScreen;
import ui.Button;
import ui.Scene;

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
	
	public static var LUCIDA:Font;
	public static var AMATIC:Font;
	public static var AMATIC_BOLD:Font;
	public static var FORMAT:TextFormat;
	public static var FORMAT_WINDOW:TextFormat;
	public static var FORMAT_SUB:TextFormat;
	public static var FORMAT_BOLD:TextFormat;
	
	public static var instance:Main;
	
	public var scene:Scene;
	var mode:Mode;
	var screen:Screen;
	
	var playGame:PFGame;
	
	#if extLoad
	var debug:Array<String>;
	#end
	
	public static function main () {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
		//Lib.current.addChild(new MusicTest2());
		//Lib.current.addChild(new MusicTest());
	}
	
	#if extLoad
	public function new () {
		super();
		
		instance = this:
		
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
		
		instance = this;
		
		init();
	}
	#end
	
	function init () {
		// Init UI textures and levels
		UI_ATLAS = Assets.getBitmapData("img/UI.png");
		#if !extLoad
		LEVELS = Assets.getBitmapData("img/levels.png");
		#end
		
		SoundManager.init();
		
		setupTextStuff();
		
		scene = new Scene();
		addChild(scene);
		
		var startData:BitmapData = new BitmapData(128, 128, true, 0x00FF00FF);
		startData.setPixel32(0, 0, 0xFFFFFFFF);
		startData.setPixel32(1, 0, 0xFFFFFFFF);
		startData.setPixel32(2, 0, 0xFFFFFFFF);
		startData.setPixel32(3, 0, 0xFFFFFFFF);
		
		new ArtEditor(startData);
		ArtEditor.instance.x = ArtEditor.instance.y = 100;
		ArtEditor.instance.edit(Art.Hero);
		
		startMode(Mode.Title);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function setupTextStuff () {
		LUCIDA = Assets.getFont("fonts/lucon.ttf");
		AMATIC = Assets.getFont("fonts/amatic.ttf");
		AMATIC_BOLD = Assets.getFont("fonts/amaticbold.ttf");
		
		FORMAT = new TextFormat(AMATIC.fontName, 32, 0xFF55555F);
		FORMAT.align = TextFormatAlign.CENTER;
		FORMAT_SUB = new TextFormat(AMATIC.fontName, 24, 0xFF55555F);
		FORMAT_SUB.align = TextFormatAlign.CENTER;
		FORMAT_BOLD = new TextFormat(AMATIC_BOLD.fontName, 36, 0xFF55555F);
		FORMAT_BOLD.align = TextFormatAlign.CENTER;
		
		FORMAT_WINDOW = new TextFormat(LUCIDA.fontName, 11, 0xFF666666);
		FORMAT_WINDOW.align = TextFormatAlign.LEFT;
	}
	
	function closeMode () {
		// Clear screen
		scene.clearScreen();
		// Mode specific
		switch (mode) {
			case Mode.ArtEdit:
				if (contains(ArtEditor.instance))	removeChild(ArtEditor.instance);
			case Mode.PlayTest:
				if (contains(playGame))	removeChild(playGame);
				playGame.clean();
				playGame = null;
			default:
		}
	}
	
	public function startMode (m:Mode) {
		// Close previous mode
		if (mode != null)	closeMode();
		// Start new mode
		switch (m) {
			case Mode.Title:
				screen = new TitleScreen();
			case Mode.Setup:
				screen = new SetupScreen();
			/*case Mode.SkillSetup:
				screen = new SkillSetupScreen();
			case Mode.Waiting:
				screen = new WaitingScreen();*/
			//case Mode.Desktop:
				//screen = new DesktopScreen();
			case Mode.ArtEdit:
				addChild(ArtEditor.instance);
			/*case Mode.PlayTest:
				#if extLoad
				playGame = new PFGame(ArtEditor.instance.data, debug);
				#else
				playGame = new PFGame(ArtEditor.instance.data);
				#end
				playGame.scaleX = playGame.scaleY = Level.SCALE;
				playGame.x = 140;
				playGame.y = 120;
				addChild(playGame);*/
			default:
		}
		mode = m;
		if (screen != null)	scene.changeScreen(screen);
	}
	
	public function executeAction (a:String) {
		switch (a) {
			case "artHero":
				ArtEditor.instance.edit(Art.Hero);
				startMode(Mode.ArtEdit);
			case "artBlock":
				ArtEditor.instance.edit(Art.Block);
				startMode(Mode.ArtEdit);
			case "artEnemy":
				ArtEditor.instance.edit(Art.Enemy);
				startMode(Mode.ArtEdit);
			case "artTreasure":
				ArtEditor.instance.edit(Art.Treasure);
				startMode(Mode.ArtEdit);
		}
	}
	
	function update (e:Event) {
		// Scene update
		scene.update();
		// Time
		if (Clock.instance != null)	Clock.instance.update();
		// Mode specific
		/*switch (mode) {
			case Mode.PlayTest:
				playGame.update();
			default:
		}*/
	}
	
}

enum Mode {
	Title;
	Setup;
	//SkillSetup;
	//Waiting;
	//Desktop;
	CodeEdit;
	ArtEdit;
	MusicEdit;
	PlayTest;
	Submit;
	End;
}








