package ;

import flash.display.Stage;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.system.System;
import lib.Camera;
import lib.Game;
import lib.gameobjects.CollisionComponent;
import lib.gameobjects.DrawComponent;
import lib.gameobjects.GameObject;
import lib.gameobjects.GameObjectManager;
import lib.gameobjects.MovementComponent;
import lib.Input;
import lib.SpriteBatch;
import openfl.display.FPS;

class MainGame extends Game
{
	private var spriteBatch : SpriteBatch;	
	private var keyboard : Input;	
	private var fps : FPS;	
	private var cam : Camera;
	
	public function new(stage:Stage) 
	{
		super(stage.stageWidth, stage.stageHeight, 1, new Point(1024, 1024), true, 61, 0xFFFFFFFF); //Input Size And Scale Here, Note This Is Not Window Size, Mearly Buffer Size [super(640/2, 480/2, 2);]
		
		ArtInstance.Init(); //This Does All Your Art Loading, Load Files In Its LoadContent() Function
		spriteBatch = new SpriteBatch(Game.drawBuffer); //Acts Similar To An XNA SpriteBatch, But Art Must Be Supplied As An Integer Identifier Name
		keyboard = new Input(stage); //Handles KeyBoard Input, Must Have Stage Reference To Add Event Listeners
		fps = new FPS();
		addChild(fps);
		cam = new Camera();	
		
		var g = new GameObject(1, "a", new Point(150, 100) , new Point(30, 30));
		g.AddComponent(new CollisionComponent(g.ID));
		g.AddComponent(new DrawComponent(g.ID));
		GameObjectManager.AddGameObject(g);
		
		var g2 = new GameObject(2, "b", new Point(120,150), new Point(30, 30));
		g2.AddComponent(new CollisionComponent(g2.ID));
		g2.AddComponent(new DrawComponent(g2.ID));
		GameObjectManager.AddGameObject(g2);
		var g3 = new GameObject(3, "b", new Point(180,150), new Point(30, 30));
		g3.AddComponent(new CollisionComponent(g3.ID));
		g3.AddComponent(new DrawComponent(g3.ID));
		GameObjectManager.AddGameObject(g3);
		var g4 = new GameObject(4, "b", new Point(210,150), new Point(30, 30));
		g4.AddComponent(new CollisionComponent(g4.ID));
		g4.AddComponent(new DrawComponent(g4.ID));
		GameObjectManager.AddGameObject(g4);
	}

	///Handle Any Game State Updates Here
	override public function Update() 
	{
		super.Update(); //Must Be Called To Update Elapsed Time, Get Elapsed Time With: Game.elapsed
		
		var mouse = Input.GetMouseState();
		
		#if !html5
		if (Input.IsKeyDown("escape"))
		{
			System.exit(0);
		}
		#end
		
		//Add Update Code Here:
		GameObjectManager.Update(Game.elapsed);
		
		var a = GameObjectManager.GetGameObjectByTag("a");
		var move = new Point();
		move.x = 0.5;
		a.Move(move);
		
		var b = GameObjectManager.GetGameObjectByTag("b");
		b.Move(move);
		
		Input.ClearPressedKeys(); //Clears Keypresses and touch locations
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