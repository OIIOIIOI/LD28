package screens;

import Clock;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import haxe.Timer;
import openfl.Assets;
import ui.Window;

import flash.display.Bitmap;
import flash.events.MouseEvent;
import flash.text.TextField;
import Main;
import ui.Button;
import ui.UIObject;

/**
 * ...
 * @author 01101101
 */

class SetupScreen extends Screen {
	
	var step:Int;
	
	var count:Int;
	
	var window:Window;
	var winContent:Sprite;
	var b:Bitmap;
	var white:Shape;
	
	var f:TextFormat;
	var f2:TextFormat;
	var f3:TextFormat;
	var f4:TextFormat;
	var tf:TextField;
	var tf2:TextField;
	var tf3:TextField;
	
	var compoButton:Button;
	var jamButton:Button;
	var skills:Skills;
	var nextButton:Button;
	
	public function new () {
		super();
		
		winContent = new Sprite();
		
		b = new Bitmap(Assets.getBitmapData("img/screen_ld.png"));
		winContent.addChild(b);
		
		white = new Shape();
		white.graphics.lineStyle(2, 0xCCCCCC);
		white.graphics.beginFill(0xFFFFFF);
		white.graphics.drawRect(0, 0, 300, 120);
		white.graphics.endFill();
		white.x = 240 - 150;
		white.y = 360 - 110;
		winContent.addChild(white);
		
		f = new TextFormat("Arial", 32, 0x333333, true);
		f.align = TextFormatAlign.CENTER;
		f2 = new TextFormat("Arial", 18, 0x333333, true);
		f2.align = TextFormatAlign.CENTER;
		f3 = new TextFormat(Main.LUCIDA.fontName, 18, 0x333333, true);
		f3.align = TextFormatAlign.CENTER;
		f4 = new TextFormat("Arial", 14, 0x333333, false);
		
		tf = new TextField();
		tf.defaultTextFormat = f;
		tf.selectable = false;
		tf.multiline = true;
		tf.width = b.width;
		tf.visible = false;
		winContent.addChild(tf);
		
		tf2 = new TextField();
		tf2.defaultTextFormat = f2;
		tf2.selectable = false;
		tf2.multiline = true;
		tf2.width = b.width;
		tf2.visible = false;
		winContent.addChild(tf2);
		
		tf3 = new TextField();
		tf3.defaultTextFormat = f4;
		tf3.selectable = false;
		tf3.multiline = tf3.wordWrap = true;
		tf3.width = white.width - 10;
		tf3.x = white.x + 5;
		tf3.y = white.y + 5;
		tf3.visible = false;
		winContent.addChild(tf3);
		
		window = new Window(null, "Ludum Dare - Waterfox");
		window.setContent(winContent);
		addChild(window);
		
		//
		
		step = -1;
		nextStep();
	}
	
	function nextStep () {
		step++;
		
		if (step == 0) {
			tf.y = 100;
			tf.text = "I'm in!";
			tf.visible = true;
			
			tf2.y = 135;
			tf2.text = "I will be participating in the";
			tf2.visible = true;
			
			tf3.text = "Choose the Jam if you think you will need more time to complete your game.";
			tf3.visible = true;
			
			compoButton = new Button(UIObject.getEmptyFrames(140, 40), 0xFF76BBED, 0xFF395B73);
			compoButton.setText("Compo (48h)", 0, 8, f3);
			compoButton.x = (480 - 300) / 2;
			compoButton.y = 185;
			winContent.addChild(compoButton);
			
			jamButton = new Button(UIObject.getEmptyFrames(140, 40), 0xFF76BBED, 0xFF395B73);
			jamButton.setText("Jam (72h)", 0, 8, f3);
			jamButton.x = compoButton.x + compoButton.width + 20;
			jamButton.y = compoButton.y;
			winContent.addChild(jamButton);
			
			compoButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			jamButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		}
		else if (step == 1) {
			compoButton.removeEventListener(MouseEvent.CLICK, clickHandler, false);
			jamButton.removeEventListener(MouseEvent.CLICK, clickHandler, false);
			winContent.removeChild(compoButton);
			winContent.removeChild(jamButton);
			compoButton = jamButton = null;
			//
			tf.text = "Skills:";
			white.y = 360 - 60;
			
			skills = Skills.instance;
			skills.x = 70;
			skills.y = 170;
			winContent.addChild(skills);
			
			tf2.text = skills.left + " points left to distribute";
			
			tf3.y = white.y + 5;
			tf3.text = "The more you are skilled in a field, the easier it will be for you to complete the corresponding tasks.";
			
			nextButton = new Button(UIObject.getEmptyFrames(70, 30), 0xFF76BBED, 0xFF395B73);
			nextButton.setText("OK", 0, 6);
			nextButton.x = 205;
			nextButton.y = 260;
			winContent.addChild(nextButton);
			
			nextButton.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		}
		else if (step == 2) {
			nextButton.removeEventListener(MouseEvent.CLICK, clickHandler, false);
			winContent.removeChild(nextButton);
			nextButton = null;
			winContent.removeChild(skills);
			skills.cleanGraph();
			tf3.visible = false;
			//
			//count = 10;
			count = -1;
			
			white.y = 360 - 95;
			tf3.y = white.y + 5;
			
			tf.y = 120;
			tf.text = "LD starts in " + count + " seconds\nTheme: ???";
			tf2.y = 210;
			tf2.text = "Get ready...";
			
			Timer.delay(countDown, 1000);
		}
	}
	
	function clickHandler (e:MouseEvent) {
		if (e.currentTarget == compoButton) {
			Clock.instance.setMode(LDMode.Compo);
			nextStep();
		} else if (e.currentTarget == jamButton) {
			Clock.instance.setMode(LDMode.Jam);
			nextStep();
		} else if (e.currentTarget == nextButton) {
			nextStep();
		}
	}
	
	override public function update () {
		super.update();
		if (step == 1) {
			if (skills.left > 1)	tf2.text = skills.left + " points left to distribute";
			else					tf2.text = skills.left + " point left to distribute";
		}
	}
	
	function countDown () {
		if (count > 5) {
			count--;
			Timer.delay(countDown, 1000);
			tf.text = "LD starts in " + count + " seconds\nTheme: ???";
		}
		else if (count > 3) {
			count--;
			Timer.delay(countDown, 1000);
		}
		else if (count > -1) {
			count--;
			Timer.delay(countDown, 1000);
			tf.visible = false;
			b.visible = false;
			white.visible = false;
			tf2.y = 80;
			tf2.text = "www.ludumdare.com\nis not responding\n\nTrying again in a few seconds...";
			tf2.visible = true;
		}
		else {
			tf.text = "LD has started!\nTheme: " + randomTheme();
			tf2.y = 220;
			tf2.text = "Get to work!";
			tf.visible = true;
			tf2.visible = true;
			b.visible = true;
			white.visible = true;
			tf3.visible = true;
			tf3.text = "The clock is ticking!\nStart working on your game by clicking on the tasks on your sticky notes!";
			//
			Main.instance.scene.start();
		}
	}
	
	function randomTheme () :String {
		return switch (Std.random(9)) {
			case 0:		"Evolution";
			case 1:		"Islands";
			case 2:		"Random";
			case 3:		"Alone";
			case 4:		"Potato";
			case 5:		"You get lots";
			case 6:		"Infection";
			case 7:		"Whatever";
			case 8:		"Minimalist";
			default:	"Kitten";
		}
	}
	
}










