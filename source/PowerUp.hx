
import flixel.FlxSprite;

class PowerUp extends FlxSprite {
    public function new(x:Float, y:Float) {
        super(x, y);
        this.loadGraphic("assets/images/heart.png");
        this.scale.set(0.06,0.06);
        this.updateHitbox();
    }

}
