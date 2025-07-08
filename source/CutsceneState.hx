import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

class CutsceneState extends MusicBeatState
{
	public var path:String = "";

	public function new(bruh)
	{
		path = bruh;
		super();
	}

	public override function create()
	{
		startVideo(path);
		super.create();
	}
	
	public function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED

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
			MusicBeatState.switchState(new PlayState());
			return;
		}

		var video:FlxVideo = new FlxVideo();
		video.load(filepath);
		video.play();
		video.onEndReached.add(function()
		{
			video.dispose();
			MusicBeatState.switchState(new PlayState());
			return;
		}, true);

		#else
		FlxG.log.warn('Platform not supported!');
		MusicBeatState.switchState(new PlayState());
		return;
		#end
	}
}
