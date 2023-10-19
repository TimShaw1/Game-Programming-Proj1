package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Player extends FlxSprite {
	public var pHealth:Int;
	public var bullet:FlxSprite;
	public var shootingEnabled:Bool;

	public function new(x:Float = 0, y:Float = 0, color:FlxColor = FlxColor.BLUE, playerNum:Int = 0) {
		super(x, y);

		// Dynamically load character sprite
		this.loadGraphic('assets/images/character${playerNum}.png');
		this.scale.x = 0.06;
		this.scale.y = 0.06;
		this.updateHitbox();

		// Set player attributes
		pHealth = 100;
		bullet = new FlxSprite(FlxG.width / 2 - 5, FlxG.height - 30);
		bullet.makeGraphic(9, 2, FlxColor.WHITE, true);
		bullet.visible = false;
		shootingEnabled = true;

		this.setFacingFlip(RIGHT, false, false);
		this.setFacingFlip(LEFT, true, false);

		if (playerNum == 2)
		{
			this.facing = LEFT;
		}
		else
		{
			this.facing = RIGHT;
		}
	}
}
