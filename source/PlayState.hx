

package;

import neko.Random;
import flixel.FlxState;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.display.FlxBackdrop;
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

import PowerUp;
import flixel.group.FlxGroup;


class PlayState extends FlxState
{
		var player1:Player;
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

		var asteroid1:Asteroid = new Asteroid();
		var asteroid2:Asteroid = new Asteroid();

		var background:FlxBackdrop = new FlxBackdrop("assets/images/background.png");

	        var powerUp:PowerUp;
		var powerUps:FlxGroup = new FlxGroup();

	override public function create():Void
	{

		add(background);
		
		player1 = new Player(20,20, FlxColor.BLUE, 1);
 		add(player1);
		add(player1.bullet);

 		player2= new Player(580,50, FlxColor.PINK, 2);
 		add(player2);
		add(player2.bullet);
		
		healthdisplay1 = new FlxText(0, 0, FlxG.width, "Player 1: " + player1.pHealth);
		healthdisplay1.setFormat(null,15, FlxColor.WHITE,"left");
		
		
		healthdisplay2 = new FlxText(0, 0, FlxG.width, "Player 2: " + player2.pHealth);
		healthdisplay2.setFormat(null,15, FlxColor.WHITE,"right");

		// Slow!
		map = new FlxOgmoLoader("assets/ogmo/Level2.oel");
 		mappingWalls = map.loadTilemap("assets/images/walls.png", 32, 32, "wall");
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

		add(spawn_asteroid(asteroid1));
		add(spawn_asteroid(asteroid2));
 	
		super.create();

		FlxG.sound.play("assets/sounds/backgroundMusic.wav", 0.05, true);

		// PowerUp
		var randomX:Float = Math.random() * FlxG.width;
		var randomY:Float = Math.random() * FlxG.height;
		powerUp = new PowerUp(50, 50);
		add(powerUp);
	}

	function placeEntities(entityName:String, entityData:Xml):Void
 	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			player1.x = x;
			player1.y = y;
		}
 	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(player1,mappingWalls);
		FlxG.collide(player1,leftWall);
		FlxG.collide(player1,rightWall);
		FlxG.collide(player1,topWall);
		FlxG.collide(player1,bottomWall);

		FlxG.collide(player1.bullet,mappingWalls, BWall);
		FlxG.collide(player1.bullet,leftWall, BWall);
		FlxG.collide(player1.bullet,rightWall, BWall);
		FlxG.collide(player1.bullet,topWall, BWall);
		FlxG.collide(player1.bullet,bottomWall, BWall);

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

		FlxG.collide(player1.bullet, player2, Hit);
		FlxG.collide(player2.bullet, player1, Hit2);

		FlxG.collide(asteroid1, player1, Asteroid_Collsion);
		FlxG.collide(asteroid2, player1, Asteroid_Collsion);

		FlxG.collide(asteroid1, player2, Asteroid_Collsion);
		FlxG.collide(asteroid2, player2, Asteroid_Collsion);

		FlxG.collide(player1, powerUp, onPowerUpCollision);
                FlxG.collide(player2, powerUp, onPowerUpCollision);
		FlxG.collide(player1, powerUps, onPowerUpCollision);
                FlxG.collide(player2, powerUps, onPowerUpCollision);

		player1.velocity.x=0;
		player1.velocity.y=0;
		player2.velocity.x=0;
		player2.velocity.y=0;

		if (player2.pHealth<=0 )
		{
			FlxG.sound.play("assets/sounds/explosion.wav", 0.15, false);
			endGame(1);
		}


		if (player1.pHealth<=0 )
		{
			FlxG.sound.play("assets/sounds/explosion.wav", 0.15, false);
			endGame(2);	
		}

		if(FlxG.keys.justReleased.ENTER && player2.shootingEnabled){
			player2.shoot();
		}

		if(FlxG.keys.justReleased.SPACE && player1.shootingEnabled){
			player1.shoot();
		}

		if(FlxG.keys.anyPressed(["D"])){
			player1.velocity.x=100;
			player1.facing = RIGHT;
		}
		if(FlxG.keys.anyPressed(["A"])){
			player1.velocity.x=-100;
			player1.facing = LEFT;
		}
		if(FlxG.keys.anyPressed(["W"])){
			player1.velocity.y= -100;

		}
		if(FlxG.keys.anyPressed(["S"])){
			player1.velocity.y= 100;
		}
		if(FlxG.keys.anyPressed(["RIGHT"])){
			player2.velocity.x=100;
			player2.facing = RIGHT;
		}
		if(FlxG.keys.anyPressed(["LEFT"])){
			player2.velocity.x=-100;
			player2.facing = LEFT;
		}
		if(FlxG.keys.anyPressed(["UP"])){
			player2.velocity.y= -100;

		}
		if(FlxG.keys.anyPressed(["DOWN"])){
			player2.velocity.y= 100;
		}

		if (Math.abs(asteroid1.x) > 1200 || Math.abs(asteroid1.y) > 1200)
			asteroid1.set_up();
		if (Math.abs(asteroid2.x) > 1200 || Math.abs(asteroid2.y) > 1200)
			asteroid2.set_up();

		
	}

	function update_health_displays()
	{
		healthdisplay1.text="Player 1: " + player1.pHealth;
		healthdisplay2.text="Player 2: " + player2.pHealth;
	}

	function BWall(Bullet:FlxObject, Wall:FlxObject):Void{
		FlxG.sound.play("assets/sounds/collision.wav", 0.10, false);
		Bullet.visible=false;
		player1.shootingEnabled=true;
	}

	function BWall2(Bullet:FlxObject, Wall:FlxObject):Void{
		FlxG.sound.play("assets/sounds/collision.wav", 0.10, false);
		Bullet.visible=false;
		player2.shootingEnabled=true;
		
	}

	function Hit(Bullet:FlxObject, Player:FlxObject):Void {
		if (!Bullet.visible)
			return;
		FlxG.sound.play("assets/sounds/hit.wav", 0.10, false);
		Bullet.visible=false;
		player1.shootingEnabled=true;
		player2.pHealth-=10;
		update_health_displays();

	}
	function Hit2(Bullet:FlxObject, Player:FlxObject):Void {
		if (!Bullet.visible)
			return;
		FlxG.sound.play("assets/sounds/hit.wav", 0.10, false);
		Bullet.visible=false;
		player2.shootingEnabled=true;
		player1.pHealth-=10;
		update_health_displays();


	}

	function Asteroid_Collsion(asteroid:Asteroid, player:Player)
		{
			if (FlxG.overlap(asteroid, player))
			{
				asteroid.set_up();
				FlxG.sound.play("assets/sounds/hit.wav", 0.10, false);
				player.pHealth -= 20;
				update_health_displays();
			}
		}

	function endGame(winnerNum:Int)
	{
		trace("Ended game");

		blankscreen = new FlxSprite(0, 0);

		blankscreen.loadGraphic("assets/images/background.png");

		player1Winner = new FlxText(0, "Player 1 Wins!");
		player1Winner.screenCenter();
		player1Winner.setFormat(null, 50, FlxColor.WHITE, "center");

		player2Winner = new FlxText(0, "Player 2 Wins!");
		// player2Winner.screenCenter(); issue here
		player2Winner.setFormat(null, 50, FlxColor.WHITE, "center");

		add(blankscreen);

		winnerNum == 1 ? add(player1Winner) : add(player2Winner);

		player1.pHealth = 1;
		player2.pHealth = 1;

		new FlxTimer().start(5, function (timer)
			{
				FlxG.switchState(new MenuState());
			});
	}

	// TODO: Collision
	public function spawn_asteroid(asteroid:Asteroid):Asteroid
	{
		asteroid.set_up();

		return asteroid;
	}

	function onPowerUpCollision(player:FlxSprite, powerUp:PowerUp):Void {
		powerUp.kill(); // removw powerup
		// add health
		var playerObj:Player = cast(player, Player);
		if(playerObj.pHealth<100)
		playerObj.pHealth += 10;  
	
		// upadte health
		if(playerObj == this.player1) {
			healthdisplay1.text = "Player 1: " + playerObj.pHealth;
		} else {
			healthdisplay2.text = "Player 2: " + playerObj.pHealth;
		}
		
		spawnNewPowerUp();
	}

	function spawnNewPowerUp():Void {
		var maxTries:Int = 50;
		var tries:Int = 0;
	
		while (tries < maxTries) {
			//redom location
			var tileX:Int = Math.floor(Math.random() * mappingWalls.widthInTiles);
			var tileY:Int = Math.floor(Math.random() * mappingWalls.heightInTiles);
	
			// check if the loaction has the wall
			if (mappingWalls.getTile(tileX, tileY) == 0) {
			
				var pixelX:Float = tileX * mappingWalls.tileWidth;
				var pixelY:Float = tileY * mappingWalls.tileHeight;
				var newPowerUp:PowerUp = new PowerUp(pixelX, pixelY);
				add(newPowerUp);
				powerUps.add(newPowerUp);
				return; 
			}
	
			tries++;
		}

	}
}


