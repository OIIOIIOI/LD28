package screens;

import art.ArtEditor;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.Lib;
import game.Level;
import ui.Button;
import ui.UIObject;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

// TODO Brush size
// TODO brush color (palettes)

class ArtScreen extends Screen {
	
	var AE:ArtEditor;
	
	var first:IntPoint;
	var last:IntPoint;
	var canvas:Sprite;
	
	var brushRadius:Int;
	var brushColor:UInt;
	var zoomLevel:Int;
	
	var window:Window;
	var winContent:Sprite;
	
	var zoomInButton:Button;
	var zoomOutButton:Button;
	var zoomMax:Int = 5;
	var zoomMin:Int = 1;
	var clearButton:Button;
	
	public function new () {
		super();
		
		AE = ArtEditor.instance;
		
		first = new IntPoint();
		last = new IntPoint();
		
		brushRadius = 2;
		brushColor = 0x666699;
		zoomLevel = zoomMin;
		
		// UI
		
		winContent = new Sprite();
		
		canvas = new Sprite();
		
		zoomOutButton = new Button(UIObject.getEmptyFrames(32, 32));
		zoomOutButton.setText("-", 0, 7);
		zoomOutButton.x = zoomOutButton.y = 8;
		
		zoomInButton = new Button(UIObject.getEmptyFrames(32, 32));
		zoomInButton.setText("+", 0, 7);
		zoomInButton.x = zoomOutButton.x + zoomOutButton.width + 2;
		zoomInButton.y = zoomOutButton.y;
		
		clearButton = new Button(UIObject.getEmptyFrames(66, 32));
		clearButton.setText("clear", 0, 7);
		clearButton.x = zoomOutButton.x;
		clearButton.y = zoomOutButton.y + zoomOutButton.height + 2;
		
		winContent.addChild(canvas);
		winContent.addChild(zoomInButton);
		winContent.addChild(zoomOutButton);
		winContent.addChild(clearButton);
		
		// Display
		setCanvasSize(AE.current);
		applyZoom();
		winContent.addChild(AE.assets.get(AE.current));
		
		window = new Window(null, AE.current + ".png - MS Pain");
		window.setContent(winContent);
		addChild(window);
		
		// Handlers
		canvas.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
		zoomInButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		zoomOutButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		clearButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == zoomInButton && zoomLevel < zoomMax) {
			zoomLevel++;
			applyZoom();
		} else if (e.currentTarget == zoomOutButton && zoomLevel > zoomMin) {
			zoomLevel--;
			applyZoom();
		} else if (e.currentTarget == clearButton) {
			AE.assets.get(AE.current).graphics.clear();
			AE.resetData(AE.current);
		}
	}
	
	// Reset the canvas to the correct size
	function setCanvasSize (art:Art) {
		canvas.scaleX = canvas.scaleY = 1;
		canvas.graphics.clear();
		canvas.graphics.beginFill(0xFFFFFF, 1);
		switch (art) {
			case Art.Block:	canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE);
			case Art.Hero:	canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE * 2);
			case Art.Enemy:	canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE);
			case Art.Goal:	canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE * 2);
		}
		canvas.graphics.endFill();
	}
	
	function applyZoom () {
		// Canvas
		canvas.scaleX = canvas.scaleY = zoomLevel;
		canvas.x = Std.int((Window.WIDTH - canvas.width) / 2);
		canvas.y = Std.int((Window.HEIGHT - canvas.height) / 2);
		// Asset
		AE.assets.get(AE.current).scaleX = AE.assets.get(AE.current).scaleY = zoomLevel;
		AE.assets.get(AE.current).x = canvas.x;
		AE.assets.get(AE.current).y = canvas.y;
		// Update UI
		if (zoomLevel == zoomMax)	zoomInButton.alpha = 0.5;
		else						zoomInButton.alpha = 1;
		if (zoomLevel == zoomMin)	zoomOutButton.alpha = 0.5;
		else						zoomOutButton.alpha = 1;
	}
	
	//{ ---- MOUSE EVENT HANDLERS ----
	function downHandler (e:MouseEvent) {
		canvas.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		//
		first.x = last.x = Std.int(e.localX);
		first.y = last.y = Std.int(e.localY);
		AE.assets.get(AE.current).graphics.lineStyle(brushRadius, brushColor);
		AE.assets.get(AE.current).graphics.moveTo(last.x, last.y);
		//
		canvas.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		canvas.addEventListener(MouseEvent.MOUSE_OUT, upHandler);
		canvas.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
	}
	
	function upHandler (e:MouseEvent) {
		canvas.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		canvas.removeEventListener(MouseEvent.MOUSE_OUT, upHandler);
		canvas.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		//
		if (Math.abs(first.x - e.localX) < 2 && Math.abs(first.y - e.localY) < 2) {
			AE.assets.get(AE.current).graphics.lineStyle(0, brushColor);
			AE.assets.get(AE.current).graphics.beginFill(brushColor);
			AE.assets.get(AE.current).graphics.drawCircle(first.x, first.y, brushRadius / 2);
			AE.assets.get(AE.current).graphics.endFill();
		}
		//
		AE.save();
		canvas.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
	}
	
	function moveHandler (e:MouseEvent) {
		last.x = Std.int(e.localX);
		last.y = Std.int(e.localY);
		AE.assets.get(AE.current).graphics.lineTo(last.x, last.y);
	}
	//}
	
}










