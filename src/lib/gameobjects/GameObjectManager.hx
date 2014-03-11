package lib.gameobjects;
import lib.collision.CollisionManager;

class GameObjectManager
{
	///Int corresponds to ID of gameobject, for faster access
	static private var gameObjects : Map<Int, GameObject>;
	
	static private var collision : CollisionManager;
	
	private function new(){} 

	static function __init__()
	{
		gameObjects = new Map<Int, GameObject>();
		collision = new CollisionManager();
	}
	
	static public function AddGameObject(gameObject : GameObject)
	{
		gameObjects.set(gameObject.ID, gameObject);
	}
	
	static public function RemoveGameObject(ID : Int)
	{
		gameObjects.remove(ID);
	}
	
	///Returns the gameobject with the specified ID
	static public function GetGameObject(ID : Int) : GameObject
	{
		return gameObjects.get(ID);
	}
	
	///Returns all gameobjects with a specific tag
	static public function GetGameObjectsWithTag(tag : String) : Array<GameObject>
	{
		var gObjects = new Array<GameObject>();
		
		for (g in gameObjects)
		{
			if (g.Tag == tag)
			{
				gObjects.push(g);
			}
		}
		
		return gObjects;
	}
	
	///Returns the first gameobject found with a specific tag
	static public function GetGameObjectByTag(tag : String) : GameObject
	{		
		for (g in gameObjects)
		{
			if (g.Tag == tag)
			{
				return g;
			}
		}
		
		return null;
	}
	
	static public function CheckCollision(object : CollisionComponent) : Array<CollisionComponent>
	{
		return collision.CheckCollision(object);
	}
	
	static public function Update(elapsed : Float)
	{
		for (g in gameObjects)
		{
			g.Update(elapsed);
		}
		
		var gObjects = new Array<GameObject>();
		
		for (g in gameObjects)
		{
			gObjects.push(g);
		}
		
		collision.Update(elapsed, gObjects);
	}
	
	static public function Draw(spritebatch : SpriteBatch)
	{
		for (g in gameObjects)
		{
			if (g.Drawable)
			{
				g.Draw(spritebatch);
			}
		}
	}
}