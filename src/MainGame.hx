package ;

import flash.display.Bitmap;
import flash.display.Stage;
import flash.geom.Point;
import flash.geom.Rectangle;
import lib.Camera;
import openfl.Assets;
import openfl.display.FPS;
import lib.Game;
import lib.SpriteBatch;
import lib.Input;
import flash.system.System;
import lib.GameObjectManager;

class MainGame extends Game
{
	private var spriteBatch : SpriteBatch;	
	private var keyboard : Input;	
	private var fps : FPS;	
	private var cam : Camera;
	
	public function new(stage:Stage) 
	{
		super(stage.stageWidth, stage.stageHeight, 1); //Input Size And Scale Here, Note This Is Not Window Size, Mearly Buffer Size [super(640/2, 480/2, 2);]
		
		ArtInstance.Init(); //This Does All Your Art Loading, Load Files In Its LoadContent() Function
		spriteBatch = new SpriteBatch(Game.drawBuffer); //Acts Similar To An XNA SpriteBatch, But Art Must Be Supplied As An Integer Identifier Name
		keyboard = new Input(stage); //Handles KeyBoard Input, Must Have Stage Reference To Add Event Listeners
		fps = new FPS();
		addChild(fps);
		cam = new Camera();	
		
	}

	///Handle Any Game State Updates Here
	override public function Update() 
	{
		super.Update(); //Must Be Called To Update Elapsed Time, Get Elapsed Time With: Game.elapsed
		
		if (Input.IsKeyDown("escape"))
		{
			System.exit(0);
		}
		
		//Add Update Code Here:
		GameObjectManager.Update(Game.elapsed);
		
		Input.ClearPressedKeys(); //Clears Keypresses and touch locations
	}
	
	///Handle All Draw Code Here
	override public function Draw(clearBuffer : Bool) //Required, Has No Effect, Set By super.Draw(_____) 
	{
		super.Draw(true); //Clears The Buffer, Use super.Draw(false) To Leave Graphics On The Buffer
		
		//Add Draw Code Here:
		GameObjectManager.Draw(spriteBatch);	
		
		spriteBatch.PushDrawCalls(); //Pushes All Draw Calls To The Buffer, MUST BE CALLED (if using crappy Draw() call)
	}
}