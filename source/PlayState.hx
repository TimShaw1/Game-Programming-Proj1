

package;

import flixel.FlxState;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxObject;
import flixel.addons.*;
import flixel.addons.editors.tiled.TiledMap;
import flixel.input.keyboard.FlxKeyList;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.util.FlxTimer;



class PlayState extends FlxState
{
		var player:Player;
		var player2:Player;
		var player1Winner:FlxText;
		var player2Winner:FlxText;
		var map: FlxOgmoLoader;
		var mappingWalls: FlxTilemap;
		var healthdisplay1:FlxText;
		var healthdisplay2:FlxText;
		var gameOver:FlxText;
		var leftWall:FlxSprite;
		var rightWall:FlxSprite;
		var topWall:FlxSprite;
		var bottomWall:FlxSprite;
		var blankscreen:FlxSprite;



	override public function create():Void
	{
		player = new Player(20,20, FlxColor.BLUE, 1);
 		add(player);
		add(player.bullet);

 		player2= new Player(580,50, FlxColor.PINK);
 		add(player2);
		add(player2.bullet);
		
		//FlxG.sound.play("assets/sounds/sound1.wav",0.15,true); need to add sound1
		healthdisplay1=new FlxText(0,0, FlxG.width, "CHARACTER1: "+ player.pHealth);
		healthdisplay1.setFormat(null,15, FlxColor.PINK,"left");
		
		
		healthdisplay2=new FlxText(0,0, FlxG.width, "CHARACTER2: "+ player2.pHealth);
		healthdisplay2.setFormat(null,15, FlxColor.BLUE,"right");

		// Slow!
		map = new FlxOgmoLoader("assets/ogmo/Level1.oel");
 		mappingWalls = map.loadTilemap("assets/images/walls1.png", 32, 32, "wall");//just a placeholder need to add a nice wall
 		mappingWalls.follow();
 		mappingWalls.setTileProperties(1, NONE);
 		mappingWalls.setTileProperties(2, ANY);
 		add(mappingWalls);
		

 		//FlxG.camera.follow(player, TOPDOWN, 1);
 		map.loadEntities(placeEntities, "entities");


		leftWall=new Wall(0,0,32,480);
		topWall=new Wall(0,0,640,32);
		add(leftWall);
		add(topWall);
		rightWall=new Wall(608,0,32,480);
		bottomWall=new Wall(0,448,640,32);
		add(rightWall);
		add(bottomWall); 
		add(healthdisplay2);
		add(healthdisplay1);
 	
		super.create();
	}

	function placeEntities(entityName:String, entityData:Xml):Void
 	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			player.x = x;
			player.y = y;
		}
 	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(player,mappingWalls);
		FlxG.collide(player,leftWall);
		FlxG.collide(player,rightWall);
		FlxG.collide(player,topWall);
		FlxG.collide(player,bottomWall);

		FlxG.collide(player.bullet,mappingWalls, BWall);
		FlxG.collide(player.bullet,leftWall, BWall);
		FlxG.collide(player.bullet,rightWall, BWall);
		FlxG.collide(player.bullet,topWall, BWall);
		FlxG.collide(player.bullet,bottomWall, BWall);

		FlxG.collide(player2,mappingWalls);
		FlxG.collide(player2,leftWall);
		FlxG.collide(player2,rightWall);
		FlxG.collide(player2,topWall);
		FlxG.collide(player2,bottomWall);

		FlxG.collide(player2.bullet,mappingWalls, BWall2);
		FlxG.collide(player2.bullet,leftWall, BWall2);
		FlxG.collide(player2.bullet,rightWall, BWall2);
		FlxG.collide(player2.bullet,topWall, BWall2);
		FlxG.collide(player2.bullet,bottomWall, BWall2);

		FlxG.collide(player.bullet, player2, Hit);
		FlxG.collide(player2.bullet, player, Hit2);

		player.velocity.x=0;
		player.velocity.y=0;
		player2.velocity.x=0;
		player2.velocity.y=0;

		if (player2.pHealth<=0 )
		{
			endGame(1);
			
			
		}


		if (player.pHealth<=0 )
		{
			endGame(2);	
			
		}

		if(FlxG.keys.justReleased.ENTER && player2.shootingEnabled){
			player2.shootingEnabled=false;
			player2.bullet.visible=true;
			player2.bullet.x = player2.x+player2.width/2;
			player2.bullet.y = player2.y+player2.height/2;
			var x = player2.x-player.x;
			if (x < 0)
			{
				player2.bullet.velocity.x= 1000;	
				//FlxG.sound.play("assets/sounds/sound1.wav",0.15,false); need to add sound2
				x=1;
			}
			else {
				player2.bullet.velocity.x= -1000;
				//FlxG.sound.play("assets/sounds/sound1.wav",0.15,false); need to add sound2
				x=-1;
			}
		}

		if(FlxG.keys.justReleased.SPACE && player.shootingEnabled){
			player.shootingEnabled=false;
			
			player.bullet.visible=true;
			player.bullet.x = player.x+player.width/2;
			player.bullet.y = player.y+player.height/2;
			var x = player2.x-player.x;
			if(x>0){

				player.bullet.velocity.x= 1000;	
				//FlxG.sound.play("assets/sounds/sound2.wav",0.15,false); need to add a sound
				x=-1;
			}
			else {
				player.bullet.velocity.x= -1000;
				//FlxG.sound.play("assets/sounds/sound2.wav",0.15,false); need to add a sound
				x=1;
			}
		}

		if(FlxG.keys.anyPressed(["D"])){
			player.velocity.x=100;
		}
		if(FlxG.keys.anyPressed(["A"])){
			player.velocity.x=-100;
		}
		if(FlxG.keys.anyPressed(["W"])){
			player.velocity.y= -100;

		}
		if(FlxG.keys.anyPressed(["S"])){
			player.velocity.y= 100;
		}
		if(FlxG.keys.anyPressed(["RIGHT"])){
			player2.velocity.x=100;
		}
		if(FlxG.keys.anyPressed(["LEFT"])){
			player2.velocity.x=-100;
		}
		if(FlxG.keys.anyPressed(["UP"])){
			player2.velocity.y= -100;

		}
		if(FlxG.keys.anyPressed(["DOWN"])){
			player2.velocity.y= 100;
		}
		
	}

	function BWall(Bullet:FlxObject, Wall:FlxObject):Void{
		Bullet.visible=false;
		player.shootingEnabled=true;
	}

	function BWall2(Bullet:FlxObject, Wall:FlxObject):Void{
		Bullet.visible=false;
		player2.shootingEnabled=true;
		
	}

	function Hit(Bullet:FlxObject, Player:FlxObject):Void {
		if (!Bullet.visible)
			return;
		Bullet.visible=false;
		player.shootingEnabled=true;
		player2.pHealth-=10;
		healthdisplay2.text="CHARACTER1: " + player2.pHealth;

	}
	function Hit2(Bullet:FlxObject, Player:FlxObject):Void {
		if (!Bullet.visible)
			return;
		Bullet.visible=false;
		player2.shootingEnabled=true;
		player.pHealth-=10;
		healthdisplay1.text="CHARACTER2: " + player.pHealth;


	}

	function endGame(winnerNum:Int)
	{
		trace("Ended game");
		gameOver=new FlxText(0,FlxG.height/2-50, FlxG.width, "LETS \n DO \n IT \n AGAIN");
		gameOver.setFormat(null,50, FlxColor.RED,"center");
		
		blankscreen = new FlxSprite(0,0);
		blankscreen.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);

		player1Winner=new FlxText(0,FlxG.height/50, FlxG.width, "CHARACTER1 is the WINNER ");
		player1Winner.setFormat(null,50, FlxColor.GREEN,"center");
		
	
		player2Winner=new FlxText(0,FlxG.height/50, FlxG.width, "CHARACTER2 is the WINNER ");
		player2Winner.setFormat(null,50, FlxColor.YELLOW,"center");

		add(blankscreen);
		add(gameOver);
		add(player1Winner);
		add(player2Winner);

		winnerNum == 1 ? add(player1Winner) : add(player2Winner);

		// Hack to fix lag
		player.pHealth = 1;
		player2.pHealth = 1;

		new FlxTimer().start(2, function (timer)
			{
				FlxG.switchState(new MenuState());
			});
	}
}


