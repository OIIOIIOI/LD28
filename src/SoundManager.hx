package ;
import flash.media.Sound;
import openfl.Assets;


/**
 * ...
 * @author 01101101
 */

class SoundManager {
	
	static var cache:Map<String, Sound>;
	
	static public function init () {
		cache = new Map<String, Sound>();
	}
	
	static public function play (url:String) {
		if (cache.exists(url)) {
			cache.get(url).play();
		} else {
			cache.set(url, Assets.getSound(url));
			cache.get(url).play();
		}
	}
	
}