package;
import flixel.FlxG;
import flixel.FlxSprite;

class Asteroid extends FlxSprite
{
    public function new(x:Float = -100, y:Float = -100, xVel:Float = 0, yVel:Float = 0)
    {
        super(x, y);
        this.velocity.x = xVel;
        this.velocity.y = yVel;

        this.angularVelocity = xVel;

        this.loadGraphic("assets/images/asteroid.png");
    }

    /**
     * Places the asteroid in a random spot off-screen. Applies speed and scaling as well.
     */
    public function set_up()
    {
        // Spawn in random spot off screen
        var x = Math.random() * FlxG.width;
		var y = Math.random() < 0.5 ? -100 : FlxG.height + 100;

        // Apply random velocity
		var xVel = Math.random() * 50 + 1;
		var yVel = Math.random() * 50 + 1;
		if (y > 0)
			yVel *= -1;
        if (x > FlxG.width / 2)
			xVel *= -1;

		this.x = x;
		this.y = y;

        // Randomly scale asteroid - Trends larger as game progresses
        this.setGraphicSize(Math.round(this.width * (Math.random() + 1)), 0);

		this.velocity.x = xVel;
		this.velocity.y = yVel;
    }
}
