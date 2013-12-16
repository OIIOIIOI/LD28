package screens;

import art.ArtEditor;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.Lib;
import game.Level;
import ui.Button;
import ui.Palette;
import ui.UIObject;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

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
	
	var brushAButton:Button;
	var brushBButton:Button;
	var brushCButton:Button;
	
	var palette:Palette;
	
	var clearButton:Button;
	
	public function new () {
		super();
		
		AE = ArtEditor.instance;
		
		first = new IntPoint();
		last = new IntPoint();
		
		// UI
		
		winContent = new Sprite();
		
		canvas = new Sprite();
		
		zoomOutButton = new Button([new Rectangle(30, 16, 30, 30)]);
		zoomOutButton.x = zoomOutButton.y = 16;
		
		zoomInButton = new Button([new Rectangle(60, 16, 30, 30)]);
		zoomInButton.x = zoomOutButton.x;
		zoomInButton.y = zoomOutButton.y + zoomOutButton.height + 2;
		
		brushAButton = getBrushButton(3);
		brushAButton.x = zoomInButton.x;
		brushAButton.y = zoomInButton.y + zoomInButton.height + 6;
		
		brushBButton = getBrushButton(6);
		brushBButton.x = brushAButton.x;
		brushBButton.y = brushAButton.y + brushAButton.height + 2;
		
		brushCButton = getBrushButton(9);
		brushCButton.x = brushBButton.x;
		brushCButton.y = brushBButton.y + brushBButton.height + 2;
		
		palette = new Palette(paletteClickHandler);
		palette.x = zoomOutButton.x + zoomOutButton.width + 6;
		palette.y = zoomOutButton.y;
		
		clearButton = new Button([new Rectangle(0, 16, 30, 30)]);
		clearButton.x = Window.WIDTH - clearButton.width - 16;
		clearButton.y = Window.HEIGHT - clearButton.height - 16;
		
		winContent.addChild(canvas);
		winContent.addChild(zoomInButton);
		winContent.addChild(zoomOutButton);
		winContent.addChild(brushAButton);
		winContent.addChild(brushBButton);
		winContent.addChild(brushCButton);
		winContent.addChild(palette);
		winContent.addChild(clearButton);
		
		brushRadius = 3;
		brushColor = Palette.getColors()[0];
		zoomLevel = zoomMin;
		
		// Display
		refreshUI();
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
		brushAButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		brushBButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		brushCButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		clearButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
	}
	
	function refreshUI () {
		brushAButton.setActive(!(brushRadius == brushAButton.customData), true);
		brushBButton.setActive(!(brushRadius == brushBButton.customData), true);
		brushCButton.setActive(!(brushRadius == brushCButton.customData), true);
	}
	
	function getBrushButton (radius:Int) :Button {
		var b = new Button(UIObject.getEmptyFrames(30, 30), 0xFF586467, 0xFFC5C9CA);
		b.customData = radius;
		var s = new Shape();
		s.graphics.beginFill(0x1D2224);
		s.graphics.drawCircle(0, 0, radius);
		s.graphics.endFill();
		s.x = s.y = 15;
		b.addChild(s);
		return b;
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == zoomInButton && zoomLevel < zoomMax) {
			zoomLevel++;
			applyZoom();
		} else if (e.currentTarget == zoomOutButton && zoomLevel > zoomMin) {
			zoomLevel--;
			applyZoom();
		} else if (e.currentTarget == brushAButton || e.currentTarget == brushBButton || e.currentTarget == brushCButton) {
			brushRadius = cast(e.currentTarget).customData;
			refreshUI();
		} else if (e.currentTarget == clearButton) {
			AE.resetData(AE.current);
		}
	}
	
	function paletteClickHandler (e:MouseEvent) {
		var b:Button = cast(e.currentTarget);
		brushColor = b.customData;
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
		if (zoomLevel == zoomMax)	zoomInButton.setActive(false, true);
		else						zoomInButton.setActive(true, true);
		if (zoomLevel == zoomMin)	zoomOutButton.setActive(false, true);
		else						zoomOutButton.setActive(true, true);
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










