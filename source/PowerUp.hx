
import flixel.FlxSprite;

class PowerUp extends FlxSprite {
    public function new(x:Float, y:Float) {
        super(x, y);
        this.loadGraphic("assets/images/heart.png");
        this.scale.x = 1.25;
	    this.scale.y = 1.25;
        this.updateHitbox();
    }

}
