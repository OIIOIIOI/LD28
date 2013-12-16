package ;

import art.ArtEditor;
import Clock;
import code.CodeGame;
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
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.text.Font;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import game.Game;
import game.Level;
import game.PFGame;
import music.MusicGame.SndObj;
import openfl.Assets;
import screens.ArtScreen;
import screens.CodeScreen;
import screens.GameScreen;
import screens.MusicScreen;
import screens.Screen;
import screens.SetupScreen;
import screens.TitleScreen;
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
	
	public var data:BitmapData;
	
	public var scene:Scene;
	var mode:Mode;
	var screen:Screen;
	
	//var playGame:PFGame;
	
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
		
		data = new BitmapData(96, 72, true, 0x00000000);
		
		SoundManager.init();
		
		setupTextStuff();
		
		scene = new Scene();
		addChild(scene);
		
		new ArtEditor();
		new Skills();
		//Skills.instance.codeLevel = 3;
		//Skills.instance.artLevel = 3;
		//Skills.instance.musicLevel = 3;
		
		//SoundManager.play("snd/ambient.mp3");
		
		startMode(Mode.Title);
		
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function setupTextStuff () {
		LUCIDA = Assets.getFont("fonts/lucon.ttf");
		AMATIC = Assets.getFont("fonts/amatic.ttf");
		AMATIC_BOLD = Assets.getFont("fonts/amaticbold.ttf");
		
		FORMAT = new TextFormat(AMATIC.fontName, 32, 0xFF55555F);
		FORMAT.align = TextFormatAlign.CENTER;
		FORMAT_SUB = new TextFormat(AMATIC.fontName, 26, 0xFF55555F);
		FORMAT_SUB.align = TextFormatAlign.CENTER;
		FORMAT_BOLD = new TextFormat(AMATIC_BOLD.fontName, 36, 0xFF55555F);
		FORMAT_BOLD.align = TextFormatAlign.CENTER;
		
		FORMAT_WINDOW = new TextFormat(LUCIDA.fontName, 11, 0xFF666666);
		FORMAT_WINDOW.align = TextFormatAlign.LEFT;
	}
	
	function closeMode () {
		// Clear screen
		scene.clearScreen();
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
			case Mode.ArtEdit:
				screen = new ArtScreen();
			case Mode.PlayTest:
				screen = new GameScreen();
			case Mode.MusicEdit:
				screen = new MusicScreen();
			case Mode.CodeEdit:
				screen = new CodeScreen();
			default:
		}
		mode = m;
		if (screen != null)	scene.changeScreen(screen);
	}
	
	public function executeAction (a:String) {
		switch (a) {
			case "codeBasics":
				CodeGame.current = Module.Basics;
				startMode(Mode.CodeEdit);
			case "codeEnemies":
				CodeGame.current = Module.Enemies;
				startMode(Mode.CodeEdit);
			case "codeJump":
				CodeGame.current = Module.Jump;
				startMode(Mode.CodeEdit);
			case "artHero":
				ArtEditor.instance.current = Art.Hero;
				startMode(Mode.ArtEdit);
			case "artBlock":
				ArtEditor.instance.current = Art.Block;
				startMode(Mode.ArtEdit);
			case "artEnemy":
				ArtEditor.instance.current = Art.Enemy;
				startMode(Mode.ArtEdit);
			case "artTreasure":
				ArtEditor.instance.current = Art.Goal;
				startMode(Mode.ArtEdit);
			case "recordMusic":
				startMode(Mode.MusicEdit);
			case "testGame":
				startMode(Mode.PlayTest);
		}
	}
	
	/*public function saveMusic (seq:Array<SndObj>) {
		for (i in 0...seq.length) {
			if (seq[i].result == 1)	data.setPixel32(i, 65, 0xFF000000);
			else					data.setPixel32(i, 65, 0x00000000);
		}
	}*/
	
	public function saveNote (snd:SndObj) {
		//trace("saveNote");
		if (snd.result == 1)	data.setPixel32(snd.index, 65, 0xFF000000);
		else					data.setPixel32(snd.index, 65, 0x00000000);
	}
	
	function update (e:Event) {
		// Scene update
		scene.update();
	}
	
}

enum Mode {
	Title;
	Setup;
	CodeEdit;
	ArtEdit;
	MusicEdit;
	PlayTest;
	Submit;
	End;
}








