package; 

class CharSongList
{
	/*public static var chars:Array<String> = 
	["majin", "lordx", "sunky", "tailsdoll", "fleetway", "coldsteel", "sanic", "fatalerror", "chaotix", "curse" ,"starved", "sl4sh", "xterion", "needlemouse"]; 

	public static var songs:Array<Array<String>> = 
	[ 
		['endless'], 
		['cycles'], 
		['milk'], 
		['sunshine', 'soulless'], 
		['chaos'], 
		['personel'], 
		['too-fest'], 
		['fatality'], 
		['my-horizon', 'our-horizon'], 
		['malediction'], 
		['fight-or-flight', 'vessel'], 
		['b4cksl4sh'], 
		['substantial','digitalized'], 
		['round-a-bout'] 
	];*/ 

	public static var data:Map<String,Array<String>> = [ 
		"majin" => ["endless"],
		"lord x" => ["cycles"],
		"tails doll" => ["sunshine", "soulless"],
		"fleetway" => ["chaos"],
		"fatalerror" => ["fatality"],
		"starved" => ["prey", "fight-or-flight"],
		"needlemouse" => ["round-a-bout"], 
		"sunky" => ["milk"], 
		"sanic" => ["too-fest"], 
		"coldsteel" => ["personel"] 
	]; // btw i found this code in psych engine server real

	public static var characters:Array<String> = [ // just for ordering 
		"majin", 
		"lord x", 
		"tails doll", 
		"fleetway", 
		"fatalerror", 
		"starved", 
		"needlemouse", 
		"sunky", 
		"sanic", 
		"coldsteel" 
	]; 

	// TODO: maybe a character display names map? for the top left in FreeplayState 

	public static var songToChar:Map<String,String>=[]; 

	public static function init(){ // can PROBABLY use a macro for this? but i have no clue how they work so lmao 
		// trust me I tried 
		// if shubs or smth wants to give it a shot then go ahead 
		// - neb 
		songToChar.clear(); 
		for(character in data.keys()){ 
			var songs = data.get(character); 
			for(song in songs)songToChar.set(song,character); 
		} 
	} 

	public static function getSongsByChar(char:String) 
	{ 
		if(data.exists(char))return data.get(char); 
		return []; 
	} 
  
	public static function isLastSong(song:String) 
	{ 
		/*for (i in songs) 
		{ 
			if (i[i.length - 1] == song) return true; 
		} 
		return false;*/ 
		if(!songToChar.exists(song))return true; 
		var songList = getSongsByChar(songToChar.get(song)); 
		return songList[songList.length-1]==song; 
	} 
}
