package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.util.*;
import flixel.ui.*;
import flixel.text.FlxText;
import flixel.addons.display.FlxBackdrop;

class MenuState extends FlxState
{
	var gameTitle:flixel.text.FlxText;
	var btnPlay:flixel.ui.FlxButton;
	var developer:FlxText;

	var background:FlxBackdrop = new FlxBackdrop("assets/images/background.png");

	function clickPlay()
	{
		FlxG.switchState(new PlayState());
	}

	override public function create():Void
	{
		
		FlxG.cameras.flash(FlxColor.BLACK, 3);
		gameTitle = new FlxText(0, FlxG.height / 4, FlxG.width, "Space-Wars");
		gameTitle.setFormat(null, 60, FlxColor.WHITE, "center");
		add(background);
		add(gameTitle);
		
		FlxG.sound.play("assets/sounds/mainMenuMusic.wav", 0.15, true);
		
		btnPlay = new FlxButton(300, 240, null, clickPlay);
		btnPlay.loadGraphic("assets/images/playButton.png", false);
		btnPlay.scale.x = 4;
		btnPlay.scale.y = 4;
		add(btnPlay);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}




