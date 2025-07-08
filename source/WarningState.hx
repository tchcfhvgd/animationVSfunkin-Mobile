package;

import CutsceneState.CutsceneState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import openfl.utils.Assets as OpenFlAssets;

class WarningState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	var isCutscene:Bool = false;
	var thesongnamename = '';

    public function new(songname:String)
	{
		thesongnamename = songname;
		super();
	}

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var text = 'Press Space to dodge Tdl slices.';
		if(thesongnamename != 'vengeance') {
			text = "Hey there person man/woman   \n
			This song contains an animated background and it may cause a headache,\n
			Press B if you want to disable it or press A if you don't wanna disable it,\n
			\n
			Hope you enjoy this song";
		}
		warnText = new FlxText(0, 0, FlxG.width, text, 32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText);
		
		if(thesongnamename == 'vengeance') {
		addTouchPad("NONE", "A");
		}else{
		addTouchPad("NONE", "A_B");
		}
	}

	override function update(elapsed:Float)
	{
		if(thesongnamename == 'vengeance') {
			if (controls.ACCEPT) {
				PlayState.animatedbgdisable = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				PlayState.SONG = Song.loadFromJson(thesongnamename, thesongnamename);
				//FlxG.switchState(new VideoState('assets/videos/chosen/fight_cutscene.webm', new PlayState()));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
				});
				PlayState.storyDifficulty = 2;
				PlayState.secret = true;
				LoadingState.loadAndSwitchState(new PlayState());
			}
		} else {
			if (controls.ACCEPT) {
				PlayState.animatedbgdisable = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				PlayState.SONG = Song.loadFromJson(thesongnamename, thesongnamename);
				//FlxG.switchState(new VideoState('assets/videos/chosen/fight_cutscene.webm', new PlayState()));
				FlxTween.tween(warnText, {alpha: 0}, 1, {
				});
				
				if (PlayState.isStoryMode)
				{
					if(thesongnamename == 'chosen') {
						new FlxTimer().start(1, function(tmr:FlxTimer)
						{
							startVideo('fight_cutscene');
						});
					} else {
						PlayState.storyDifficulty = 2;
						PlayState.secret = true;
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
				else
				{
					PlayState.storyDifficulty = 2;
					PlayState.secret = true;
					LoadingState.loadAndSwitchState(new PlayState());
				}
			}
			else if (controls.BACK) 
			{
				{
					PlayState.animatedbgdisable = true;
					FlxG.sound.play(Paths.sound('cancelMenu'));
					PlayState.SONG = Song.loadFromJson(thesongnamename, thesongnamename);
					//FlxG.switchState(new VideoState('assets/videos/chosen/fight_cutscene.webm', new PlayState()));
					FlxTween.tween(warnText, {alpha: 0}, 1, {
					});
					
					if (PlayState.isStoryMode)
					{
						if(thesongnamename == 'chosen') {
							new FlxTimer().start(1, function(tmr:FlxTimer)
							{
								startVideo('fight_cutscene');
							});
						} else {
							PlayState.storyDifficulty = 2;
							PlayState.secret = true;
							LoadingState.loadAndSwitchState(new PlayState());
						}
					}
					else
					{
						PlayState.storyDifficulty = 2;
						PlayState.secret = true;
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
		}
		super.update(elapsed);
   }
   
   public function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		isCutscene = true;
		
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}

		var filepath:String = Paths.video(name);
		#if sys
		if(!FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
		    PlayState.storyDifficulty = 2;
			PlayState.secret = true;
		   	LoadingState.loadAndSwitchState(new PlayState());
			return;
		}

		var video:FlxVideo = new FlxVideo();
		video.load(filepath);
		video.play();
		video.onEndReached.add(function()
		{
			video.dispose();
			PlayState.storyDifficulty = 2;
			PlayState.secret = true;
		   	LoadingState.loadAndSwitchState(new PlayState());
			return;
		}, true);

		#else
		FlxG.log.warn('Platform not supported!');
		PlayState.storyDifficulty = 2;
			PlayState.secret = true;
		   	LoadingState.loadAndSwitchState(new PlayState());
		return;
		#end
	}
}