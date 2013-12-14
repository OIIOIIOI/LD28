package game;

import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.Lib;
import flash.ui.Keyboard;

/**
 * ...
 * @author 01101101
 */

class Game extends Sprite {
	
	var keys:Map<Int, Bool>;
	
	public function new () {
		super();
		
		registerKeys();
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
	}
	
	public function update () { }
	
	function registerKeys () {
		if (keys != null)	return;
		keys = new Map<Int, Bool>();
		keys.set(Keyboard.UP, false);
		keys.set(Keyboard.RIGHT, false);
		keys.set(Keyboard.DOWN, false);
		keys.set(Keyboard.LEFT, false);
		keys.set(Keyboard.SPACE, false);
	}
	
	function keyDownHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode))	keys.set(e.keyCode, true);
	}
	
	function keyUpHandler (e:KeyboardEvent) {
		if (keys.exists(e.keyCode))	keys.set(e.keyCode, false);
	}
	
}