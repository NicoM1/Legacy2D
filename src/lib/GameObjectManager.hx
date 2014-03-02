package lib;

class GameObjectManager
{
	///Int corresponds to ID of gameobject, for faster access
	static private var gameObjects : Map<Int, GameObject>;
	
	private function new(){} 

	static function __init__()
	{
		gameObjects = new Map<Int, GameObject>();
	}
	
	static public function AddGameObject(gameObject : GameObject)
	{
		gameObjects.set(gameObject.ID, gameObject);
	}
	
	static public function RemoveGameObject(ID : Int)
	{
		gameObjects.remove(ID);
	}
	
	static public function GetGameObject(ID : Int) : GameObject
	{
		return gameObjects.get(ID);
	}
	
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
	
	static public function Update(elapsed : Float)
	{
		for (g in gameObjects)
		{
			g.Update(elapsed);
		}
	}
	
	static public function Draw(spritebatch : SpriteBatch)
	{
		for (g in gameObjects)
		{
			if (g.Drawable)
			{
				if (g.Position.x + g.DrawBounds.x >= 0 && g.Position.x < Game.localwidth)
				{
					if (g.Position.y + g.DrawBounds.y >= 0 && g.Position.y < Game.localheight)
					{
						g.Draw(spritebatch);
					}
				}
			}
		}
	}
}