package;

import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;
import Song.SwagSong;
import openfl.utils.Assets;
#if MODS_ALLOWED
import sys.io.File;
import sys.FileSystem;
#end

typedef CoolCreditsBox =
{
	var creditsText:String;
	var TIME:Float;
	var SIZE:Float;
}

class CreditsBox
{
	public static var SONG:SwagSong = null;
	var text:String = '';

	public static function loadCredits(SONG:SwagSong)
	{
		var creditsFile:CoolCreditsBox = getCreditsFile(credits);
	}
	public static function getCreditsFile(credits:String):CoolCreditsBox
	{
		var rawJson:String = null;
		var songName:String = Paths.formatToSongPath(SONG.song);
		var path:String = SUtil.getPath() + Paths.getPreloadPath(songName + '/credits.json');

		#if MODS_ALLOWED
		var modPath:String = Paths.modFolders('stages/' + stage + '.json');
		if(FileSystem.exists(path)) {
			rawJson = File.getContent(path);
		}
		#else
		if(Assets.exists(path)) {
			rawJson = Assets.getText(path);
		}
		#end
		else
		{
			return null;
		}
		return cast Json.parse(rawJson);
	}
}