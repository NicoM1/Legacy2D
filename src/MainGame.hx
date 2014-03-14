package ;

import flash.display.Bitmap;
import flash.display.Stage;
import flash.geom.ColorTransform;
import flash.geom.Point;
import flash.geom.Rectangle;
import lib.Camera;
import lib.gameobjects.CollisionComponent;
import lib.gameobjects.GameObject;
import openfl.Assets;
import openfl.display.FPS;
import lib.Game;
import lib.SpriteBatch;
import lib.Input;
import flash.system.System;
import lib.gameobjects.GameObjectManager;

class MainGame extends Game
{
	private var spriteBatch : SpriteBatch;	
	private var keyboard : Input;	
	private var fps : FPS;	
	private var cam : Camera;
	var a : CollisionComponent;
    var b : CollisionComponent;
	var d : CollisionComponent;
	var c : Rectangle;
	
	public function new(stage:Stage) 
	{
		super(stage.stageWidth, stage.stageHeight, 1); //Input Size And Scale Here, Note This Is Not Window Size, Mearly Buffer Size [super(640/2, 480/2, 2);]
		
		ArtInstance.Init(); //This Does All Your Art Loading, Load Files In Its LoadContent() Function
		spriteBatch = new SpriteBatch(Game.drawBuffer); //Acts Similar To An XNA SpriteBatch, But Art Must Be Supplied As An Integer Identifier Name
		keyboard = new Input(stage); //Handles KeyBoard Input, Must Have Stage Reference To Add Event Listeners
		fps = new FPS();
		addChild(fps);
		cam = new Camera();	
		
		a = new CollisionComponent(0, new Rectangle(40, 32, 100, 100));
		b = new CollisionComponent(0, new Rectangle(150, 150, 100, 100));
		c = new Rectangle(0,0,100,100);	
	}

	///Handle Any Game State Updates Here
	override public function Update() 
	{
		super.Update(); //Must Be Called To Update Elapsed Time, Get Elapsed Time With: Game.elapsed
		
		var mouse = Input.GetMouseState();
		
		if (Input.IsKeyDown("escape"))
		{
			System.exit(0);
		}
		
		//Add Update Code Here:
		GameObjectManager.Update(Game.elapsed);
		a.SetBounds(new Rectangle(mouse.position.x, mouse.position.y, 100, 100));
		c.x = mouse.position.x;
		c.y = mouse.position.y;
		
		if (a.GetBounds().intersects(b.GetBounds()))
		{
			GameObjectManager.collision.ResolveCollision(a, b);
		}
		
		Input.ClearPressedKeys(); //Clears Keypresses and touch locations
	}
	
	///Handle All Draw Code Here
	override public function Draw(clearBuffer : Bool) //Required, Has No Effect, Set By super.Draw(_____) 
	{
		super.Draw(true); //Clears The Buffer, Use super.Draw(false) To Leave Graphics On The Buffer
		
		//Add Draw Code Here:
		GameObjectManager.Draw(spriteBatch);	
		
		spriteBatch.DrawToScreen(ArtInstance.GetArt(ArtInstance._PIXEL), a.GetBounds(), null, new ColorTransform(1,0,0));
		spriteBatch.DrawToScreen(ArtInstance.GetArt(ArtInstance._PIXEL), b.GetBounds(), null, new ColorTransform(0, 0, 0));
		spriteBatch.DrawToScreen(ArtInstance.GetArt(ArtInstance._PIXEL), c, null, new ColorTransform(0,1,0,0.5));
		
		spriteBatch.PushDrawCalls(); //Pushes All Draw Calls To The Buffer, MUST BE CALLED (if using crappy Draw() call)
	}
}