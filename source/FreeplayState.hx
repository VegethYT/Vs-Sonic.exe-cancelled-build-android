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
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import flixel.addons.effects.FlxSkewedSprite;
import WeekData;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class FreeplayState extends MusicBeatState
{
	/*var boxArray:Array<String> = [
		'majin',
		'majin',
		'lord x',
		'sunky',
		'tails doll',
		'tails doll',
		'starved',
		'starved'
	];*/
	var charArray:Array<String>;
	var charUnlocled:Array<String>;
	//boxArray.push(songArray);

	var selector:FlxText;
	private static var curSelected:Int = 0;
	public static var curSongSelect:Int = 0;

	private var boxgrp:FlxTypedSpriteGroup<FlxSprite>;
	public var grptxt:FlxTypedGroup<FlxText>;
	private var curPlaying:Bool = false;
	var scoreText:FlxText;
	var charText:FlxText;
	public static var selecting:Bool = true;
	var cdman:Bool = true;

	var bg:FlxSprite;
	var sideBars:FlxBackdrop;
		
	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
		
		CharSongList.init();
		
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
		
		bg = new FlxSprite().loadGraphic(Paths.image('backgroundlool'));
		bg.antialiasing = false;
		bg.setGraphicSize(1280, 720);
		add(bg);
		bg.screenCenter();
		
		sideBars = new FlxBackdrop(Paths.image('sidebars'), 0, 1, false, true);
		add(sideBars);

		var uhhdumbassline:FlxSprite = new FlxSprite(300).makeGraphic(10, 720, FlxColor.BLACK); 
		add(uhhdumbassline); 

		boxgrp = new FlxTypedSpriteGroup<FlxSprite>();
		add(boxgrp);

		textgrp = new FlxTypedGroup<FlxText>();
		add(boxgrp);

		charArray = CharSongList.characters;
		charUnlocked = CharSongList.characters;

		for (i in 0...charArray.length)
		{
			if (charArray.contains(charArray[i])) // Hey so this is uneeded but it's here lol. 
			{
				var box:FlxSprite = new FlxSprite(0, i * 415); 
				box.loadGraphic(Paths.image('FreeBox')); 
				boxgrp.add(box); 
				box.ID = i; 
				box.setGraphicSize(Std.int(box.width / 1.7)); 
  
				FlxG.log.add('searching for ' + 'assets/images/fpstuff/' + charArray[i].toLowerCase() + '.png'); 
  
				if (charUnlocked.contains(charArray[i])) 
				{
					if (FileSystem.exists('assets/images/fpstuff/' + charArray[i].toLowerCase() + '.png')) 
					{
						FlxG.log.add(charArray[i] + ' found'); 
						var char:FlxSprite = new FlxSprite(0, i * 415); 
						char.loadGraphic(Paths.image('fpstuff/' + charArray[i].toLowerCase())); 
						boxgrp.add(char); 
						char.ID = i; 
						char.setGraphicSize(Std.int(box.width / 1.7)); 
					}
					else 
					{
						var char:FlxSprite = new FlxSprite(0, i * 415); 
						char.loadGraphic(Paths.image('fpstuff/placeholder')); 
						boxgrp.add(char); 
						char.ID = i; 
						char.setGraphicSize(Std.int(box.width / 1.7)); 
					}
				}
				else 
				{
					var char:FlxSprite = new FlxSprite(0, i * 415);
					char.loadGraphic(Paths.image('fpstuff/locked'));
					boxgrp.add(char);
					char.ID = i;
					char.setGraphicSize(Std.int(box.width / 1.7)); 
				}
			}
		}

		boxgrp.x = -335; 

		scoreText = new FlxText(30, 105, FlxG.width, ""); 
		scoreText.setFormat("Sonic CD Menu Font Regular", 18, FlxColor.WHITE, CENTER); 
			scoreText.y -= 36; 
			scoreText.x -= 20; 
			add(scoreText); 

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		grptxtsongs = new FlxTypedGroup<FlxText>();
		add(grptxtsongs);

		if (charUnlocked.contains(charArray[0])) charText = new FlxText(30 , 10, FlxG.width, "Majin"); 
		else charText = new FlxText(30 , 10, FlxG.width, "???"); 
		charText.setFormat("Sonic CD Menu Font Regular", 36, FlxColor.WHITE, CENTER); 
		charText.y -= 10; 
		charText.x -= 23; 
		add(charText);

		  ////// LOADING SHIT FOR THE BEGINNING //////// 
			boxgrp.forEach(function(sprite:FlxSprite) 
			{
				if (sprite.ID == curSelected - 1 || sprite.ID == curSelected + 1) 
				{
					var diff = curSelected - sprite.ID; 
					trace(diff, sprite.ID, curSelected); 
					FlxTween.tween(sprite, {alpha: 0.5}, 0.2); 
					FlxTween.tween(sprite, {"scale.x": 1.25, y: 1.25}, 0.2, {ease: FlxEase.expoOut}); 
				}
				else 
				{
					FlxTween.tween(sprite, {alpha: 1}, 0.2); 
					FlxTween.tween(sprite.scale, {x: 0.58, y: 0.58}, 0.2, {ease: FlxEase.expoOut}); 
					FlxTween.tween(sprite.skew, {x: 0, y: 0}, 0.2, {ease: FlxEase.expoOut}); 
				}
			}); 
			for (i in 0...CharSongList.getSongsByChar(charArray[curSelected]).length) 
			{
				var text:FlxText; 
				if (charUnlocked.contains(charArray[curSelected])) text = new FlxText(350, FlxG.height / 2 - 30 * CharSongList.getSongsByChar(charArray[curSelected]).length +  i *  30 * CharSongList.getSongsByChar(charArray[curSelected]).length, FlxG.width, StringTools.replace(CharSongList.getSongsByChar(charArray[curSelected])[i], "-", " ")); 
				else text = new FlxText(350, FlxG.height / 2 - 30 * CharSongList.getSongsByChar(charArray[curSelected]).length +  i *  30 * CharSongList.getSongsByChar(charArray[curSelected]).length, FlxG.width, "???"); 
				text.setFormat("Sonic CD Menu Font Regular", 36, 0xFFFFFFFF, CENTER); 
				text.ID = i; 
				textgrp.add(text); 
			}

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
		//changeSong();

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
		var leftP = controls.UI_LEFT_P;// i dont will use it again lmao
		var rightP = controls.UI_RIGHT_P;// this too
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE #if android || _virtualpad.buttonX.justPressed #end;
		var ctrl = FlxG.keys.justPressed.CONTROL #if android || _virtualpad.buttonC.justPressed #end;
		var accepted = controls.ACCEPT;
		
		var shiftMult:Int = 1;
		if (cdman) {
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
		if (controls.BACK)
		{
			persistentUpdate = false;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.log.add('lmao');
			if (!selecting) MusicBeatState.switchState(new MainMenuState()); 
			else 
			{
				scoreText.text = ""; 
				curSongSelected = 0; 
				selecting = false; 
				textgrp.forEach(function(text:FlxText) 
				{
					FlxTween.cancelTweensOf(text); 
					text.alpha = 1; 
				}); 
			}
		}
			if (accepted && cdman && selecting) 
			{
				if (charUnlocked.contains(charArray[curSelected])) 
				{
					cdman = false; 
  
					var songArray:Array<String> = CharSongList.getSongsByChar(charArray[curSelected]); 
  
					PlayState.SONG = Song.loadFromJson(songArray[curSongSelected].toLowerCase() + '-hard', songArray[curSongSelected].toLowerCase()); 
					PlayState.isStoryMode = false; 
					PlayState.storyDifficulty = 2; 
					PlayState.storyWeek = 1; 
					FlxG.sound.play(Paths.sound('confirmMenu')); 
  
					// PlayStateChangeables.nocheese = false; 
						FlxTween.tween(whiteshit, {alpha: 1}, 0.4); 
						FlxTransitionableState.skipNextTransIn = true; 
						FlxTransitionableState.skipNextTransOut = true; 
						new FlxTimer().start(0.8, function(tmr:FlxTimer) 
						{
							LoadingState.loadAndSwitchState(new PlayState()); 
						}); 
					}
				}
				else 
				{
					cdman = false; 
					FlxG.sound.play(Paths.sound('deniedMOMENT'), 1, false, null, false, function() 
					{
						cdman = true; 
					}); 
				}
			if (accepted && cdman && !selecting) 
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4); 
				selecting = true; 
				if (textgrp.members != null) 
				{
					textgrp.forEach(function(text:FlxText) 
					{
						FlxTween.cancelTweensOf(text); 
						text.alpha = 1; 
						if (text.ID == curSongSelected) 
						{
							scoreText.text = "Score: " + Highscore.getScore(CharSongList.getSongsByChar(charArray[curSelected])[curSongSelected], 2); 
							FlxTween.tween(text, {alpha: 0.5}, 0.5, {ease: FlxEase.expoOut, type: FlxTween.PINGPONG}); 
						}
					}); 
				}
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
		if (!selecting) 
		{
			if (change == 1 && curSelected != charArray.length - 1) 
			{
				cdman = false;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				FlxTween.tween(boxgrp ,{y: boxgrp.y - 415}, 0.2, {ease: FlxEase.expoOut, onComplete: function(sus:FlxTween) 
				{
					cdman = true;
				}});
			}
			else if (change == -1 && curSelected != 0) 
			{
				cdman = false;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				FlxTween.tween(boxgrp ,{y: boxgrp.y + 415}, 0.2, {ease: FlxEase.expoOut, onComplete: function(sus:FlxTween) 
					{
						cdman = true;
					}});
			}
			if ((change == 1 && curSelected != charArray.length - 1) || (change == -1 && curSelected != 0)) // This is a. 
			{
				if (textgrp.members != null) 
				{
					textgrp.forEach(function(text:FlxText) 
					{
						text.destroy();
					});
				}
				curSelected = curSelected + change;
				boxgrp.forEach(function(sprite:FlxSprite) 
				{
					if (sprite.ID == curSelected) 
					{
						FlxTween.tween(sprite, {alpha: 1}, 0.2);
						FlxTween.tween(sprite, {"scale.x": 1.18, "scale.y": 1.18}, 0.2, {ease: FlxEase.expoOut});
					}
					else 
					{
						FlxTween.tween(sprite, {alpha: 0.5}, 0.2);
						FlxTween.tween(sprite, {"scale.x": 1, "scale.y": 1}, 0.2, {ease: FlxEase.expoOut});
					}
				});
				for (i in 0...CharSongList.getSongsByChar(charArray[curSelected]).length)
				{
					var text:FlxText;
					if (charUnlocked.contains(charArray[curSelected])) text = new FlxText(350, FlxG.height / 2 - 30 * CharSongList.getSongsByChar(charArray[curSelected]).length +  i *  30 * CharSongList.getSongsByChar(charArray[curSelected]).length, FlxG.width, StringTools.replace(CharSongList.getSongsByChar(charArray[curSelected])[i], "-", " "));
					else text = new FlxText(350, FlxG.height / 2 - 30 * CharSongList.getSongsByChar(charArray[curSelected]).length +  i *  30 * CharSongList.getSongsByChar(charArray[curSelected]).length, FlxG.width, "???");
					text.setFormat("Sonic CD Menu Font Regular", 36, 0xFFFFFFFF, CENTER);
					text.ID = i;
					textgrp.add(text);
				}
				if (charUnlocked.contains(charArray[curSelected])) charText.text = charArray[curSelected];
				else charText.text = '???';
				boxgrp.forEach(function(thing:FlxSprite) 
				{
					if (thing.ID == curSelected && thing.toString() == "char")  
					{
						switch(charArray[curSelected]) 
						{
							case "hog": 
							if (curSongSelected == 1) thing.loadGraphic(Paths.image('fpstuff/scorched'));
							else thing.loadGraphic(Paths.image('fpstuff/hog'));
							default: thing.loadGraphic(Paths.image('fpstuff/' + charArray[curSelected]));
						}
					}
				});
			}
			else
			{
				var songArray:Array<String> = CharSongList.getSongsByChar(charArray[curSelected]);
				var nextSelected = curSongSelected + change;
				if(nextSelected<0)nextSelected=songArray.length-1;
				if(nextSelected>=songArray.length)nextSelected=0;
				if (curSongSelected!=nextSelected)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4); 
					curSongSelected += change; 
					if (textgrp.members != null) 
					{
						textgrp.forEach(function(text:FlxText) 
						{
							FlxTween.cancelTweensOf(text); 
							text.alpha = 1; 
							if (text.ID == curSongSelected) 
							{
								scoreText.text = "Score: " + Highscore.getScore(songArray[curSongSelected], 2); 
								FlxTween.tween(text, {alpha: 0.5}, 0.5, {ease: FlxEase.expoOut, type: FlxTween.PINGPONG}); 
								}
						}); 
					}
				}
			}
		}

		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0; //stupid shit
	}
}
