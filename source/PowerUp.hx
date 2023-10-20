
import flixel.util.FlxTimer;
import flixel.FlxSprite;

class PowerUp extends FlxSprite {
    public var powerType = 0;

    public function new(x:Float, y:Float) {
        super(x, y);
        this.powerType = Math.round((Math.random() + 1));

        if (powerType == 1)
        {
            this.loadGraphic("assets/images/heart.png");
            this.scale.x = 1.25;
            this.scale.y = 1.25;
            this.updateHitbox();
        }
        else
        {
            this.loadGraphic("assets/images/speedboost.png");
			this.scale.x = 1.25;
			this.scale.y = 1.25;
			this.updateHitbox();
        }
    }

    public function onCollide(player:Player) {

        if (powerType == 1)
        {
            // add health
            if(player.pHealth<100)
                player.pHealth += 10;  
        }
        else 
        {
            player.speed = 2;
            new FlxTimer().start(5, function (timer)
            {
                player.speed = 1;
            });
        }
    }

}
