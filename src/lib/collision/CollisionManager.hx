package lib.collision;
import flash.geom.Point;
import flash.geom.Rectangle;
import lib.gameobjects.GameObject;
import lib.gameobjects.CollisionComponent;

/**
 * ...
 * @author 
 */
class CollisionManager
{
	private var quadTree : QuadTree;
	
	public function new(worldBounds : Point) 
	{
		quadTree = new QuadTree(0, new Rectangle(0, 0, worldBounds.x, worldBounds.y));
	}
	
	public function Update(gameObjects : Array<GameObject>)
	{
		quadTree.Clear();
		for (g in gameObjects)
		{
			var c = g.GetComponent(CollisionComponent);
			if (c != null)
			{
				quadTree.Insert(c);
			}
		}
	}
	
	public function UpdateObject(object : CollisionComponent)
	{
		quadTree.UpdateObject(object);
	}
	
	///Returns an array of the IDs of all objects that have collided
	public function CheckCollision(collision : CollisionComponent) : Array<CollisionComponent>
	{
		var possibleCollisions = quadTree.Retrieve(collision);
		var collsionIDs = new Array<CollisionComponent>();
		
		for (p in possibleCollisions)
		{
			if (p.Owner != collision.Owner)
			{
				if (p.collideAble)
				{
					if (p.GetBounds().intersects(collision.GetBounds()))
					{
						collsionIDs.push(p);
					}
				}
			}
		}
		
		return collsionIDs;
	}
}