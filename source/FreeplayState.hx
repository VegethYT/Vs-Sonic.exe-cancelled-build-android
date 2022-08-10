package;

#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class FreeplayState extends MusicBeatState
{
	var boxArray:Array<String> = [
		'majin',
		'majin',
		'lord x',
		'sunky',
		'tails doll',
		'tails doll',
		'starved',
		'starved'
	];
	// im fucking genious :ocaramaisinteligentedomundo:
	/*var songArray:Array<Array<Array<String>>> = [ // o nome da caixa, (entre colchetes) as musica
		['endless', ['endless', 'endless-og']],
		['lord x', ['cycles']],
		['sunky', ['milk']],
		['tails doll', ['sunshine', 'soulless']],
		['starved', ['prey', 'fight-or-flight']]
	];*/ // i dont ill use this for now
	//boxArray.push(songArray);

	var selector:FlxText;
	private static var curSelected:Int = 0;
	public static var curSong:Int = 0;

	private var grpSongs:FlxTypedGroup<FreeplayItem>;
	public var grptxtsongs:FlxTypedGroup<FlxText>;
	private var curPlaying:Bool = false;
	public static var boxslct:Bool = true;
	public static var songslct:Bool = false;
	var cdman:Bool = true;
		
	var bg:FlxSprite;
	var sideBars:FlxBackdrop;
		
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		
		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//
		
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/
		
		bg = new FlxSprite().loadGraphic(Paths.image('menuBGBlue'));
		bg.antialiasing = false;
		add(bg);
		bg.screenCenter();
		
		sideBars = new FlxBackdrop(Paths.image('sidebars'), 0.5, 0.5);
		sideBars.antialiasing = false;
		sideBars.velocity.set(0, 110);
		add(sideBars);
		sideBars.screenCenter();
		
		grpSongs = new FlxTypedGroup<FreeplayItem>();
		add(grpSongs);
		
		grptxtsongs = new FlxTypedGroup<FlxText>();
		add(grptxtsongs);
		
		for (i in 0...boxArray.length)
		{
				var box:FreeplayItem = new FreeplayItem(-100, 200, 'FreeBox');
				//box.ID = i;
				box.y += (box.width - 450) + 40;
				box.setGraphicSize(Std.int(box.width * 0.89));
				grpSongs.add(box);
		
				var char:FreeplayItem = new FreeplayItem(-100, 200, 'fpstuff/' + boxArray[i]);
				//char.ID = i;
				char.y += (char.width - 450) + 40;
				char.setGraphicSize(Std.int(char.width * 0.89));
				grpSongs.add(char);
		}
			//changeSelection();
		
		var swag:Alphabet = new Alphabet(1, 0, "swag");
		
			var songsText:FlxText = new FlxText(0, 0, 0, "", 32);
			songsText.setFormat(Paths.font('sonic-cd-menu-font.ttf'), 32);
			songsText.text = songArray[curSelected];
			songsText.setPosition(900, 500);
			add(songsText);
		
		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));
		
			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;
		
			FlxG.stage.addChild(texFel);
		
			// scoreText.textField.htmlText = md;
		
			trace(md);
		 */
		changeSelection();
		
		#if android
		addVirtualPad(UP_DOWN, A_B);
		#end
		
		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	var songslol:String = "";
	var instPlaying:Int = -1;
	private static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE #if android || _virtualpad.buttonX.justPressed #end;
		var ctrl = FlxG.keys.justPressed.CONTROL #if android || _virtualpad.buttonC.justPressed #end;
		
		var shiftMult:Int = 1;
		
		if(songArray.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}
		
			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
		
				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					//changeDiff();
				}
			}
		}
		
		if (controls.BACK)
		{
			persistentUpdate = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
			else if (accepted)
			{
				persistentUpdate = false;
				var songSlct:String = songArray[curSelected];
				FlxG.sound.play(Paths.sound('confirmMenu'));
				PlayState.SONG = Song.loadFromJson(songSlct, songSlct + '-hard');
				
					
					/*#if MODS_ALLOWED
					if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
					#else
					if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
					#end
						poop = songLowercase;
						curDifficulty = 1;
						trace('Couldnt find file');
					}*/
					//trace(poop);
		
					
					if (FlxG.keys.pressed.SHIFT #if android || _virtualpad.buttonZ.pressed #end){
						LoadingState.loadAndSwitchState(new ChartingState());
					}else{
						LoadingState.loadAndSwitchState(new PlayState());
					}
		
					FlxG.sound.music.volume = 0;
				}
			else if(space)
			{
				if(instPlaying != curSelected)
				{
					#if PRELOAD_ALL
					destroyFreeplayVocals();
					FlxG.sound.music.volume = 0;
					if (PlayState.SONG.needsVoices)
						vocals = new FlxSound().loadEmbedded(Paths.sound('bruh'));
					else
						vocals = new FlxSound();
		
					FlxG.sound.list.add(vocals);
					vocals.play();
					vocals.persist = true;
					vocals.looped = true;
					vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}
		super.update(elapsed);
	}
	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}
	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
			if(playSound) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			curSelected += change;
	
			if (curSelected < 0)
				curSelected = songArray.length - 1;
			if (curSelected >= songArray.length)
				curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpSongs.members)
		{
			FlxTween.tween(item, {"scale.x": 0.75,"scale.y": 0.75}, 0.35);
			item.alpha = 0.45;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				//songslol = songs;
				FlxTween.tween(item, {"scale.x": 1,"scale.y": 1}, 0.35);
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
