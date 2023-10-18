package;
import flixel.FlxSprite;

class Asteroid extends FlxSprite
{
    public function new(x:Float = -100, y:Float = -100, xVel:Float = 0, yVel:Float = 0)
    {
        super(x, y);
        this.velocity.x = xVel;
        this.velocity.y = yVel;

        this.angularVelocity = xVel;

        // this.loadGraphic("assets/images/asteroid.png");
    }
}