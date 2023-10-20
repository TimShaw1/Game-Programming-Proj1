

package;

//import neko.Random;
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
		
		// Create player 1
		player1 = new Player(20,20, FlxColor.PINK, 1);
 		add(player1);
		add(player1.bullet);

		// Create player 2
 		player2 = new Player(580,50, FlxColor.BLUE, 2);
 		add(player2);
		add(player2.bullet);
		
		// add health displays
		healthdisplay1 = new FlxText(0, 0, FlxG.width, "Electroswift: " + player1.pHealth);
		healthdisplay1.setFormat(null,15, FlxColor.WHITE,"left");
		
		
		healthdisplay2 = new FlxText(0, 0, FlxG.width, "Thunderblaze: " + player2.pHealth);
		healthdisplay2.setFormat(null,15, FlxColor.WHITE,"right");

		// Load map - this can be slow
		map = new FlxOgmoLoader('assets/ogmo/Level${Math.round((Math.random() + 1))}.oel');
 		mappingWalls = map.loadTilemap("assets/images/walls.png", 32, 32, "wall");
 		mappingWalls.follow();
 		mappingWalls.setTileProperties(1, NONE);
 		mappingWalls.setTileProperties(2, ANY);
 		add(mappingWalls);
		

 		map.loadEntities(placeEntities, "entities");

		// Create walls
		leftWall=new Wall(0,0,32,480);
		topWall=new Wall(0,0,640,32);
		add(leftWall);
		add(topWall);
		rightWall=new Wall(608,0,32,480);
		bottomWall=new Wall(0,448,640,32);
		add(rightWall);
		add(bottomWall); 

		// add health displays after walls
		add(healthdisplay2);
		add(healthdisplay1);

		// Spawn 2 asteroids and add them
		add(spawn_asteroid(asteroid1));
		add(spawn_asteroid(asteroid2));
 	
		super.create();

		// Start bg music
		FlxG.sound.play("assets/sounds/backgroundMusic.wav", 0.05, true);

		// PowerUp
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

		// player1 wall collisions
		FlxG.collide(player1,mappingWalls);
		FlxG.collide(player1,leftWall);
		FlxG.collide(player1,rightWall);
		FlxG.collide(player1,topWall);
		FlxG.collide(player1,bottomWall);

		// player1 bullet collisions
		FlxG.collide(player1.bullet,mappingWalls, BWall);
		FlxG.collide(player1.bullet,leftWall, BWall);
		FlxG.collide(player1.bullet,rightWall, BWall);
		FlxG.collide(player1.bullet,topWall, BWall);
		FlxG.collide(player1.bullet,bottomWall, BWall);

		// player2 wall collisions
		FlxG.collide(player2,mappingWalls);
		FlxG.collide(player2,leftWall);
		FlxG.collide(player2,rightWall);
		FlxG.collide(player2,topWall);
		FlxG.collide(player2,bottomWall);

		// player2 bullet collisions
		FlxG.collide(player2.bullet,mappingWalls, BWall2);
		FlxG.collide(player2.bullet,leftWall, BWall2);
		FlxG.collide(player2.bullet,rightWall, BWall2);
		FlxG.collide(player2.bullet,topWall, BWall2);
		FlxG.collide(player2.bullet,bottomWall, BWall2);

		// damage collisions
		FlxG.collide(player1.bullet, player2, Hit);
		FlxG.collide(player2.bullet, player1, Hit2);

		// asteriod collisions
		FlxG.collide(asteroid1, player1, Asteroid_Collsion);
		FlxG.collide(asteroid2, player1, Asteroid_Collsion);

		FlxG.collide(asteroid1, player2, Asteroid_Collsion);
		FlxG.collide(asteroid2, player2, Asteroid_Collsion);

		// powerup collisions
		FlxG.collide(player1, powerUp, onPowerUpCollision);
        FlxG.collide(player2, powerUp, onPowerUpCollision);
		FlxG.collide(player1, powerUps, onPowerUpCollision);
        FlxG.collide(player2, powerUps, onPowerUpCollision);

		// reset velocities
		player1.velocity.x=0;
		player1.velocity.y=0;
		player2.velocity.x=0;
		player2.velocity.y=0;

		// Catch out-of-bounds players
		if (player1.x < 0 || player1.x > FlxG.width)
			player1.pHealth = -10;

		if (player2.x < 0 || player2.x > FlxG.width)
			player2.pHealth = -10;

		// End game if a player has died
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


		// Shooting
		if(FlxG.keys.justReleased.ENTER && player2.shootingEnabled){
			player2.shoot();
		}

		if(FlxG.keys.justReleased.SPACE && player1.shootingEnabled){
			player1.shoot();
		}

		// player1 movement
		if(FlxG.keys.anyPressed(["D"])){
			player1.apply_velocity(100, 0);
			player1.facing = RIGHT;
		}
		if(FlxG.keys.anyPressed(["A"])){
			player1.apply_velocity(-100, 0);
			player1.facing = LEFT;
		}
		if(FlxG.keys.anyPressed(["W"])){
			player1.apply_velocity(0, -100);

		}
		if(FlxG.keys.anyPressed(["S"])){
			player1.apply_velocity(0, 100);
		}

		// player2 movement
		if(FlxG.keys.anyPressed(["RIGHT"])){
			player2.apply_velocity(100, 0);
			player2.facing = RIGHT;
		}
		if(FlxG.keys.anyPressed(["LEFT"])){
			player2.apply_velocity(-100, 0);
			player2.facing = LEFT;
		}
		if(FlxG.keys.anyPressed(["UP"])){
			player2.apply_velocity(0, -100);

		}
		if(FlxG.keys.anyPressed(["DOWN"])){
			player2.apply_velocity(0, 100);
		}

		// Reset asteroids if they go too far off screen
		if (Math.abs(asteroid1.x) > 1200 || Math.abs(asteroid1.y) > 1200)
			asteroid1.set_up();
		if (Math.abs(asteroid2.x) > 1200 || Math.abs(asteroid2.y) > 1200)
			asteroid2.set_up();

		
	}

	/**
	 * Utility function to update the displayed health on the top of the screen
	 */
	function update_health_displays()
	{
		healthdisplay1.text="Electroswift: " + player1.pHealth;
		healthdisplay2.text="Thunderblaze: " + player2.pHealth;
	}

	/**
	 * Player1's bullet hit a wall
	 * @param Bullet 
	 * @param Wall 
	 */
	function BWall(Bullet:FlxObject, Wall:FlxObject):Void{
		FlxG.sound.play("assets/sounds/collision.wav", 0.10, false);
		Bullet.visible=false;
		player1.shootingEnabled=true;
	}

	/**
	 * Player2's bullet hit a wall
	 * @param Bullet 
	 * @param Wall 
	 */
	function BWall2(Bullet:FlxObject, Wall:FlxObject):Void{
		FlxG.sound.play("assets/sounds/collision.wav", 0.10, false);
		Bullet.visible=false;
		player2.shootingEnabled=true;
		
	}

	/**
	 * Called when player2 is hit with player1's bullet. Damages player2 and plays a sound.
	 * @param Bullet 
	 * @param Player 
	 */
	function Hit(Bullet:FlxObject, Player:FlxObject):Void {
		if (!Bullet.visible)
			return;
		FlxG.sound.play("assets/sounds/hit.wav", 0.10, false);
		Bullet.visible=false;
		Bullet.x = -1000;
		Bullet.y = -1000;
		player1.shootingEnabled=true;
		player2.pHealth-=10;
		update_health_displays();

	}

	/**
	 * Called when player1 is hit with player2's bullet. Damages player1 and plays a sound.
	 * @param Bullet 
	 * @param Player 
	 */
	function Hit2(Bullet:FlxObject, Player:FlxObject):Void {
		if (!Bullet.visible)
			return;
		FlxG.sound.play("assets/sounds/hit.wav", 0.10, false);
		Bullet.visible=false;
		Bullet.x = -1000;
		Bullet.y = -1000;
		player2.shootingEnabled=true;
		player1.pHealth-=10;
		update_health_displays();


	}

	/**
	 * Defines behaviour when a player collides with an asteroid
	 * @param asteroid 
	 * @param player 
	 */
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

	/**
	 * Called to end the game. Shows the end screen.
	 * @param winnerNum Which player won the game
	 */
	function endGame(winnerNum:Int)
	{

		blankscreen = new FlxSprite(0, 0);

		blankscreen.loadGraphic("assets/images/background.png");

		player1Winner = new FlxText(0, "Electroswift Wins!");
		player1Winner.setFormat(null, 50, FlxColor.WHITE, "center");

		player2Winner = new FlxText(0, "Thunderblaze Wins!");
		player2Winner.setFormat(null, 50, FlxColor.WHITE, "center");

		add(blankscreen);
		player1Winner.screenCenter();
		player2Winner.screenCenter();
		winnerNum == 1 ? add(player1Winner) : add(player2Winner);

		player1.pHealth = 1;
		player2.pHealth = 1;

		// Show end screen for 5 seconds, then go back to menu
		new FlxTimer().start(5, function (timer)
			{
				FlxG.switchState(new MenuState());
			});
	}

	/**
	 * Spawns an asteroid
	 * @param asteroid which asteroid to spawn
	 * @return Asteroid
	 */
	public function spawn_asteroid(asteroid:Asteroid):Asteroid
	{
		asteroid.set_up();

		return asteroid;
	}

	/**
	 * Called when a player collides with a powerup. Applies the powerup's effect.
	 * @param player the player who collided with the powerup
	 * @param powerUp the powerup that was collided with
	 */
	function onPowerUpCollision(player:Player, powerUp:PowerUp):Void {
		FlxG.sound.play("assets/sounds/powerUp.wav", 0.10, false);
		powerUp.onCollide(player);
		powerUp.kill(); // remove powerup
		update_health_displays();
		
		spawnNewPowerUp();
	}

	// Hacky way to check if game is over
	function is_game_over():Bool {
		return (player1.pHealth == 1 || player1.pHealth <= 0 || player2.pHealth <= 0);
	}

	function spawnNewPowerUp():Void {
		var maxTries:Int = 50;
		var tries:Int = 0;
	
		new FlxTimer().start(10, function (timer)
		{
			// Ensure sprite doesn't spawn on end screen
			if (is_game_over())
				return;
			
			while (tries < maxTries) {
				//random location
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
		});

	}
}


