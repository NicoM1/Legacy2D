package ;

import flash.display.Stage;
import flash.geom.Point;
import flash.system.System;
import lib.Camera;
import lib.Game;
import lib.gameobjects.CollisionComponent;
import lib.gameobjects.DrawComponent;
import lib.gameobjects.GameObject;
import lib.gameobjects.GameObjectManager;
import lib.gameobjects.InputComponent;
import lib.gameobjects.MovementComponent;
import lib.UserInput;
import lib.SpriteBatch;
import lib.map.TmxParser;
import openfl.display.FPS;
import openfl.Assets;
import haxe.io.StringInput;

class MainGame extends Game
{
	private var spriteBatch : SpriteBatch;	
	private var keyboard : UserInput;	
	private var fps : FPS;	
	private var cam : Camera;
	
	private var level : Level;
	
	public function new(stage:Stage) 
	{
		super(stage.stageWidth, stage.stageHeight, 1, new Point(1024, 1024), true, 61, 0xFFFFFFFF); //UserInput Size And Scale Here, Note This Is Not Window Size, Mearly Buffer Size [super(640/2, 480/2, 2);]
		
		ArtInstance.Init(); //This Does All Your Art Loading, Load Files In Its LoadContent() Function
		spriteBatch = new SpriteBatch(Game.drawBuffer); //Acts Similar To An XNA SpriteBatch, But Art Must Be Supplied As An Integer Identifier Name
		keyboard = new UserInput(stage); //Handles KeyBoard UserInput, Must Have Stage Reference To Add Event Listeners
		fps = new FPS();
		addChild(fps);
		cam = new Camera();	
		
		BuildTestScene();
	}
	
	private function BuildTestScene()
	{
		var player : GameObject = new GameObject(1, "player", new Point(10, 10), new Point(16, 33));
		player.AddComponent(new CollisionComponent(player.ID, false, true, 10));
		player.AddComponent(new MovementComponent(player.ID));
		player.AddComponent(new InputComponent(player.ID));
		player.AddComponent(new DrawComponent(player.ID, ArtInstance._PLAYER));
		
		GameObjectManager.AddGameObject(player);
		
		level = new Level();
	}

	///Handle Any Game State Updates Here
	override public function Update() 
	{
		super.Update(); //Must Be Called To Update Elapsed Time, Get Elapsed Time With: Game.elapsed
		
		var mouse = UserInput.GetMouseState();
		
		#if !html5
		if (UserInput.IsKeyDown("escape"))
		{
			System.exit(0);
		}
		#end
		
		//Add Update Code Here:
		GameObjectManager.Update(Game.elapsed);
		
		UserInput.ClearPressedKeys(); //Clears Keypresses and touch locations
	}
	
	///Handle All Draw Code Here
	override public function Draw(clearBuffer : Bool) //Required, Has No Effect, Set By super.Draw(_____) 
	{
		super.Draw(true); //Clears The Buffer, Use super.Draw(false) To Leave Graphics On The Buffer
		
		//Add Draw Code Here:
		GameObjectManager.Draw(spriteBatch);	

		spriteBatch.PushDrawCalls(); //Pushes All Draw Calls To The Buffer, MUST BE CALLED (if using crappy Draw() call)
		
		#if flash
		super.DrawLight();
		#end
	}
}