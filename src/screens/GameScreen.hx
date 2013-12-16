package screens;

import art.ArtEditor;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import game.Level;
import game.PFGame;
import haxe.Timer;
import music.MusicGame.SndObj;
import openfl.Assets;
import ui.Window;

/**
 * ...
 * @author 01101101
 */

class GameScreen extends Screen {
	
	var window:Window;
	var winContent:Sprite;
	
	var playGame:PFGame;
	
	var level:Int;
	
	public function new () {
		super();
		
		winContent = new Sprite();
		
		window = new Window(null, "LD Prototype");
		window.setContent(winContent);
		addChild(window);
		
		level = 0;
		loadNext();
		
		playback();
	}
	
	override public function update () {
		super.update();
		// Game
		if (playGame != null)	playGame.update();
		// Sound
		if (playing) {
			while (trackBSC.position > seq[part].prevTotal + seq[part].length) {
				part++;
				if (Main.instance.data.getPixel32(seq[part].index, 65) == cast(0xFF000000)) {
					trackASC.soundTransform = new SoundTransform(SoundManager.GLOBAL_VOL);
				} else {
					trackASC.soundTransform = new SoundTransform(0);
				}
			}
		}
	}
	
	function endLevel (win:Bool) {
		if (win)	level++;
		Timer.delay(loadNext, 1000);
	}
	
	function loadNext () {
		if (playGame != null)	winContent.removeChild(playGame);
		
		playGame = new PFGame(Main.instance.data, endLevel);
		playGame.scaleX = playGame.scaleY = Level.SCALE * 0.75;
		winContent.addChild(playGame);
		
		playGame.loadLevel(level);
	}
	
	// ---- SOUND PLAYBACK ----
	
	override public function clean () {
		super.clean();
		if (trackBSC != null) {
			trackBSC.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			trackASC.stop();
			trackBSC.stop();
		}
	}
	
	var playing:Bool;
	var part:Int;
	var seq:Array<SndObj>;
	var trackASC:SoundChannel;
	var trackBSC:SoundChannel;
	
	public function playback () {
		var diff = "normal";
		if (Skills.instance.musicLevel == 3)	diff = "easy";
		var a = Assets.getText("snd/" + diff + ".txt").split(";");
		
		seq = new Array();
		part = 0;
		
		var total = 0.0;
		for (i in 0...a.length) {
			var so = new SndObj(i, a[i]);
			so.prevTotal = total;
			seq.push(so);
			total += so.length;
		}
		
		if (trackBSC != null) {
			trackBSC.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			trackASC.stop();
			trackBSC.stop();
		}
		trackASC = SoundManager.play("snd/lead.mp3");
		trackBSC = SoundManager.play("snd/playback.mp3");
		trackBSC.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
		playing = true;
	}
	
	function soundCompleteHandler (e:Event) {
		playing = false;
	}
	
}










