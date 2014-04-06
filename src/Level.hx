package ;

import flash.geom.Point;
import lib.gameobjects.CollisionComponent;
import lib.gameobjects.DrawComponent;
import lib.gameobjects.GameObject;
import lib.gameobjects.GameObjectManager;
import lib.map.TmxParser;
import lib.map.TmxObject;
import openfl.Assets;

class Level
{

	public function new() 
	{
		var walls = TmxParser.parseObjects(Assets.getText("assets/test.tmx"));
		/*for (w in walls)
		{
			if (w.type != "wall")
			{
				walls.remove(w);
			}
		}*/
		for (w in 0...walls.length)
		{
			var wall = walls[w];
			var wG : GameObject = new GameObject(w + 20, "wall", new Point(wall.position.x, wall.position.y), new Point(wall.bounds.x, wall.bounds.y)); //the w+20 stops player being affected,
			wG.AddComponent(new DrawComponent(wG.ID, ArtInstance._REDPIXEL));																			//need to add an auto ID option
			wG.AddComponent(new CollisionComponent(wG.ID, true));
			GameObjectManager.AddGameObject(wG);
		}
	}
	
}