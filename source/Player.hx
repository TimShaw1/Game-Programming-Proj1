package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Player extends FlxSprite
{
    var pHealth:Int;
    var bullet:FlxSprite;

    public function new(x:Float = 0, y:Float = 0, color:FlxColor = FlxColor.BLUE, playerNum:Int = 0)
    {
        super(x,y);

        // Dynamically load character sprite
        this.loadGraphic('assets/images/character${playerNum}.png');

        // Set player attributes
        pHealth = 100;
        bullet = new FlxSprite(FlxG.width/2-5, FlxG.height-30);
        bullet.makeGraphic(9, 2, color);
        bullet.visible = false;
    }
}