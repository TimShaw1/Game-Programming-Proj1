package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Player extends FlxSprite {
	public var pHealth:Int;
	public var bullet:FlxSprite;
	public var shootingEnabled:Bool;
	public var speed = 1;

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

		this.allowCollisions = ANY;

		// Flip player sprite when switching directions
		this.setFacingFlip(RIGHT, false, false);
		this.setFacingFlip(LEFT, true, false);

		// Set facing direction
		if (playerNum == 2)
		{
			this.facing = LEFT;
		}
		else
		{
			this.facing = RIGHT;
		}
	}

	/**
	 * Handles player velocity assignment
	 * @param xVel x velocity
	 * @param yVel y velocity
	 */
	public function apply_velocity(xVel:Float, yVel:Float)
	{
		if (xVel != 0)
			this.velocity.x = xVel * speed;
		if (yVel != 0)
			this.velocity.y = yVel * speed;
	}

	/**
	 * Fires a bullet from the player's position in the direction it is facing
	 */
	public function shoot()
	{
		this.shootingEnabled=false;
		
		this.bullet.visible=true;
		this.bullet.x = this.x+this.width/2;
		this.bullet.y = this.y+this.height/2;
		if(this.facing == RIGHT) {
				this.bullet.velocity.x= 1000;	
			FlxG.sound.play("assets/sounds/shoot.wav", 0.15, false);
		}
		else {
			this.bullet.velocity.x= -1000;
			FlxG.sound.play("assets/sounds/shoot.wav", 0.15, false);
		}
	}
}
