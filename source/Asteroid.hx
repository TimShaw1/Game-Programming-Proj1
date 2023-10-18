package;
import flixel.FlxSprite;

class Asteroid extends FlxSprite
{
    public function new(x:Float, y:Float, xVel:Float, yVel:Float)
    {
        super(x, y);
        this.velocity.x = xVel;
        this.velocity.y = yVel;

        this.angularVelocity = Math.atan(yVel/xVel);

        // this.loadGraphic("assets/images/asteroid.png");
    }
}