package code;

import code.CodeGame.Module;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import openfl.Assets;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

class CodeGame extends Sprite {
	
	public static var current:Module;
	
	static var DUMMY_TEXT:String;
	
	static var FORMAT_LEFT:TextFormat;
	static var FORMAT_CURRENT:TextFormat;
	static var FORMAT_DONE:TextFormat;
	static var FORMAT_DUMMY:TextFormat;
	public static var FORMAT_PROGRESS:TextFormat;
	public static var FORMAT_PROGRESS_SUB:TextFormat;
	
	var dummyTF:TextField;
	
	var wordLabel:TextField;
	var locked:Bool;
	
	var words:Array<String>;
	var currentWord:String;
	var currentIndex:Int;
	
	var wordBg:Shape;
	
	var progress:Progress;
	var total:Int;
	var count:Int;
	
	public function new () {
		super();
		
		if (current == null)	current = Module.Basics;
		
		if (FORMAT_DONE == null) {
			FORMAT_DONE = new TextFormat(Main.LUCIDA.fontName, 24, 0x457C9A);
			FORMAT_CURRENT = new TextFormat(Main.LUCIDA.fontName, 24, 0xFFCD22);
			FORMAT_LEFT = new TextFormat(Main.LUCIDA.fontName, 24, 0xC8CACC);
			FORMAT_DUMMY = new TextFormat(Main.LUCIDA.fontName, 12, 0x93C763);
			FORMAT_PROGRESS = new TextFormat("Arial", 16, 0xFFCD22);
			FORMAT_PROGRESS.align = TextFormatAlign.CENTER;
			FORMAT_PROGRESS_SUB = new TextFormat("Arial", 12, 0xFFCD22);
			FORMAT_PROGRESS_SUB.align = TextFormatAlign.CENTER;
			//
			DUMMY_TEXT = Assets.getText("assets/hex.txt");
		}
		
		dummyTF = new TextField();
		dummyTF.defaultTextFormat = FORMAT_DUMMY;
		dummyTF.embedFonts = true;
		dummyTF.selectable = false;
		dummyTF.multiline = dummyTF.wordWrap = true;
		dummyTF.width = Window.WIDTH - 8;
		dummyTF.height = Window.HEIGHT + 20;
		dummyTF.x = 4;
		
		wordBg = new Shape();
		wordBg.graphics.beginFill(0x2C4152);
		wordBg.graphics.drawRect(0, 0, Window.WIDTH, 40);
		wordBg.graphics.endFill();
		wordBg.y = Window.HEIGHT - wordBg.height;
		
		wordLabel = new TextField();
		wordLabel.defaultTextFormat = FORMAT_LEFT;
		wordLabel.embedFonts = true;
		wordLabel.selectable = wordLabel.multiline = false;
		wordLabel.width = Window.WIDTH - 10;
		wordLabel.height = 30;
		wordLabel.x = wordBg.x + 5;
		wordLabel.y = wordBg.y + 5;
		
		progress = new Progress();
		progress.x = (Window.WIDTH - progress.width) / 2;
		progress.y = (Window.HEIGHT - progress.height) / 2;
		
		addChild(dummyTF);
		addChild(wordBg);
		addChild(wordLabel);
		addChild(progress);
		
		start();
	}
	
	public function update () {
		if (locked)	return;
		if (Std.random(8) == 0)	dummyTF.text = DUMMY_TEXT.substr(Std.random(DUMMY_TEXT.length - 2002), 2000);
		progress.refresh(count / total);
		if (count / total >= 1)	moduleComplete();
	}
	
	function start () {
		locked = false;
		total = getLength(current);
		words = getWords(total);
		count = 0;
		
		nextWord();
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
	}
	
	function nextWord () {
		if (words.length == 0) {
			moduleComplete();
		} else {
			currentIndex = 0;
			currentWord = words.shift();
			refreshUI();
		}
	}
	
	function moduleComplete () {
		stop();
		wordBg.visible = false;
		wordLabel.visible = false;
		Main.instance.scene.completeModule(current);
	}
	
	function refreshUI () {
		wordLabel.text = currentWord;
		if (currentIndex > 0) {
			wordLabel.setTextFormat(FORMAT_DONE, 0, currentIndex);
		}
		wordLabel.setTextFormat(FORMAT_CURRENT, currentIndex, currentIndex + 1);
		if (currentIndex < currentWord.length - 1)	wordLabel.setTextFormat(FORMAT_LEFT, currentIndex + 1, currentWord.length);
	}
	
	public function stop () {
		locked = true;
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
	}
	
	function keyDownHandler (e:KeyboardEvent) {
		var input = String.fromCharCode(e.keyCode).toLowerCase();
		var target = currentWord.charAt(currentIndex).toLowerCase();
		if (input == target) {
			currentIndex++;
			count++;
			if (currentIndex == currentWord.length)	nextWord();
			else									refreshUI();
		}
	}
	
	public static function getLength (module:Module) :Int {
		// TODO depending on module and skill
		return 25;
	}
	
	public static function getWords (l:Int) :Array<String> {
		var a = new Array<String>();
		var count = 0;
		var s:String;
		while (count < l) {
			s = getWord();
			count += s.length;
			a.push(s);
		}
		return a;
	}
	
	static function getWord () :String {
		var a:Array<String> = ["function", "class", "public", "private", "static", "inline", "var", "return"];
		a = a.concat(["new", "array", "int", "event", "string", "constructor", "call", "package", "import"]);
		a = a.concat(["if", "else", "while", "for", "do", "value", "bool", "extends", "interface", "random"]);
		return a[Std.random(a.length)];
	}
	
}

enum Module {
	Basics;
	Enemies;
	Jump;
}