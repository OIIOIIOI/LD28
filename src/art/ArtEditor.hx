package art;

import art.ArtEditor.Art;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.errors.Error;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import flash.text.TextFormat;
import game.Level;
import screens.Screen;
import ui.Button;
import ui.UIObject;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

class ArtEditor extends Sprite {
	
	public static var WIDTH:Int = 480;
	public static var HEIGHT:Int = 360;
	
	public static var instance:ArtEditor;
	
	public var data:BitmapData;
	
	var assets:Map<Art, Shape>;
	var coords:Map<Art, Rectangle>;
	var current:Art;
	
	var first:IntPoint;
	var last:IntPoint;
	var canvas:Sprite;
	
	var brushRadius:Int;
	var brushColor:UInt;
	var zoomLevel:Int;
	
	public function new (data:BitmapData) {
		super();
		
		if (instance != null)	throw new Error("Already instanciated");
		instance = this;
		
		this.data = data;
		
		// Init shapes
		assets = new Map<Art, Shape>();
		assets.set(Art.Block, new Shape());
		assets.set(Art.Hero, new Shape());
		assets.set(Art.Enemy, new Shape());
		assets.set(Art.Goal, new Shape());
		// Init coords
		coords = new Map<Art, Rectangle>();
		coords.set(Art.Block, new Rectangle(0, 1, Level.GRID_SIZE, Level.GRID_SIZE));
		coords.set(Art.Hero, new Rectangle(Level.GRID_SIZE, 1, Level.GRID_SIZE, Level.GRID_SIZE * 2));
		coords.set(Art.Enemy, new Rectangle(0, Level.GRID_SIZE + 1, Level.GRID_SIZE, Level.GRID_SIZE));
		coords.set(Art.Goal, new Rectangle(Level.GRID_SIZE * 2, 1, Level.GRID_SIZE, Level.GRID_SIZE * 2));
		// Init data
		for (k in assets.keys()) {
			resetData(k);
		}
		
		first = new IntPoint();
		last = new IntPoint();
		
		brushRadius = 2;
		brushColor = 0x666699;
		zoomLevel = 1;
		
		setupUI();
		
		canvas = new Sprite();
		windowContent.addChild(canvas);
		
		canvas.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
	}
	
	// TODO Brush size, brush color (palettes)
	
	// Select the asset to edit
	public function edit (art:Art) {
		if (current != null && windowContent.contains(assets.get(current)))	windowContent.removeChild(assets.get(current));
		current = art;
		setCanvasSize(current);
		applyZoom();
		windowContent.addChild(assets.get(current));
		//
		window.titleLabel.setText(current + ".png - MS Pain");
	}
	
	// Reset the canvas to the correct size
	function setCanvasSize (art:Art) {
		canvas.scaleX = canvas.scaleY = 1;
		canvas.graphics.clear();
		canvas.graphics.beginFill(0xFFFFFF, 1);
		switch (art) {
			case Art.Block:		canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE);
			case Art.Hero:		canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE * 2);
			case Art.Enemy:		canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE);
			case Art.Goal:	canvas.graphics.drawRect(0, 0, Level.GRID_SIZE, Level.GRID_SIZE * 2);
		}
		canvas.graphics.endFill();
	}
	
	function applyZoom () {
		// Canvas
		canvas.scaleX = canvas.scaleY = zoomLevel;
		canvas.x = Std.int((WIDTH - canvas.width) / 2);
		canvas.y = Std.int((HEIGHT - canvas.height) / 2);
		// Asset
		assets.get(current).scaleX = assets.get(current).scaleY = zoomLevel;
		assets.get(current).x = canvas.x;
		assets.get(current).y = canvas.y;
		// Update UI
		if (zoomLevel == 5)	zoomInButton.alpha = 0.5;
		else				zoomInButton.alpha = 1;
		if (zoomLevel == 1)	zoomOutButton.alpha = 0.5;
		else				zoomOutButton.alpha = 1;
	}
	
	//{ ---- UI ----
	var window:Window;
	var windowContent:Sprite;
	var zoomInButton:Button;
	var zoomOutButton:Button;
	var clearButton:Button;
	var saveButton:Button;
	
	function setupUI () {
		windowContent = new Sprite();
		windowContent.graphics.beginFill(0x808080);
		windowContent.graphics.drawRect(0, 0, WIDTH, HEIGHT);
		windowContent.graphics.endFill();
		
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
		
		saveButton = new Button(UIObject.getEmptyFrames(66, 32));
		saveButton.setText("save", 0, 7);
		saveButton.x = clearButton.x;
		saveButton.y = clearButton.y + clearButton.height + 2;
		
		windowContent.addChild(zoomInButton);
		windowContent.addChild(zoomOutButton);
		windowContent.addChild(clearButton);
		windowContent.addChild(saveButton);
		
		zoomInButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		zoomOutButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		clearButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		saveButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		
		window = new Window(close, "MS Pain");
		window.setContent(windowContent);
		window.x = Std.int((Screen.WIDTH - window.width) / 2);
		window.y = Std.int((Screen.HEIGHT - window.height) / 2);
		addChild(window);
	}
	//}
	
	function close () {
		trace("close");
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == zoomInButton && zoomLevel < 5) {
			// Zoom in
			zoomLevel++;
			applyZoom();
		} else if (e.currentTarget == zoomOutButton && zoomLevel > 1) {
			// Zoom out
			zoomLevel--;
			applyZoom();
		} else if (e.currentTarget == clearButton) {
			// Clear shape
			assets.get(current).graphics.clear();
			// Reset data
			resetData(current);
		} else if (e.currentTarget == saveButton) {
			// Clear previous version
			data.fillRect(coords.get(current), 0x00FF00FF);
			// Matrix
			Main.TAM.identity();
			Main.TAM.translate(coords.get(current).x, coords.get(current).y);
			// Clip
			Main.TAR.x = coords.get(current).x;
			Main.TAR.y = coords.get(current).y;
			Main.TAR.width = coords.get(current).width;
			Main.TAR.height = coords.get(current).height;
			// Draw
			data.draw(assets.get(current), Main.TAM, null, null, Main.TAR);
		}
	}
	
	function resetData (art:Art) {
		data.fillRect(coords.get(art), 0xFF000000 + Std.random(0xFFFFFF));
	}
	
	public function paint (art:Art, target:BitmapData, dest:Point = null) {
		if (dest == null)	dest = new Point();
		target.copyPixels(data, coords.get(art), dest);
	}
	
	//{ ---- MOUSE EVENT HANDLERS ----
	function downHandler (e:MouseEvent) {
		canvas.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		//
		first.x = last.x = Std.int(e.localX);
		first.y = last.y = Std.int(e.localY);
		assets.get(current).graphics.lineStyle(brushRadius, brushColor);
		assets.get(current).graphics.moveTo(last.x, last.y);
		//
		canvas.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
	}
	
	function upHandler (e:MouseEvent) {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		canvas.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		//
		if (Math.abs(first.x - e.localX) < 2 && Math.abs(first.y - e.localY) < 2) {
			assets.get(current).graphics.lineStyle(0, brushColor);
			assets.get(current).graphics.beginFill(brushColor);
			assets.get(current).graphics.drawCircle(first.x, first.y, brushRadius / 2);
			assets.get(current).graphics.endFill();
		}
		//
		canvas.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
	}
	
	function moveHandler (e:MouseEvent) {
		if (Std.int(e.localX) > canvas.width || Std.int(e.localY) > canvas.height) {
			upHandler(e);
			return;
		}
		last.x = Std.int(e.localX);
		last.y = Std.int(e.localY);
		assets.get(current).graphics.lineTo(last.x, last.y);
	}
	//}
	
}

enum Art {
	Block;
	Hero;
	Enemy;
	Goal;
}










