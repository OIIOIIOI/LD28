package ;

import flash.errors.Error;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import openfl.Assets;

/**
 * ...
 * @author 01101101
 */

class SoundManager {
	
	public static var GLOBAL_VOL:Float = 0.5;
	
	static var cache:Map<String, Sound>;
	
	public static function init () {
		cache = new Map<String, Sound>();
	}
	
	public static function play (url:String) :SoundChannel {
		if (cache.exists(url)) {
			return cache.get(url).play(0, 0, new SoundTransform(GLOBAL_VOL));
		} else {
			var s = Assets.getSound(url);
			if (s != null) {
				cache.set(url, s);
				return cache.get(url).play(0, 0, new SoundTransform(GLOBAL_VOL));
			}
			return null;
		}
	}
	
}










