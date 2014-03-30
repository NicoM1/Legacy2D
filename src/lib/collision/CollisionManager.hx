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
	
	/*
	public function ResolveCollision(a : CollisionComponent, b : CollisionComponent)
	{
		var aAABB = new AABB(new Point(a.GetBounds().x, a.GetBounds().y), 
							new Point(a.GetBounds().x + a.GetBounds().width, 
							a.GetBounds().y + a.GetBounds().height));
		var bAABB = new AABB(new Point(b.GetBounds().x, b.GetBounds().y), 
							new Point(b.GetBounds().x + b.GetBounds().width, 
							b.GetBounds().y + b.GetBounds().height));
		
		var direction : Point = new Point();
		direction.x = aAABB.topLeft.x - bAABB.topLeft.x;
		direction.y = aAABB.topLeft.y - bAABB.topLeft.y;
		
		var end : AABB = new AABB();	
		end.bottomRight.x = Math.min(aAABB.bottomRight.x, bAABB.bottomRight.x);
		end.bottomRight.y = Math.min(aAABB.bottomRight.y, bAABB.bottomRight.y);
		
		end.topLeft.x = Math.max(aAABB.topLeft.x, bAABB.topLeft.x);
		end.topLeft.y = Math.max(aAABB.topLeft.y, bAABB.topLeft.y);
		
		var overlap : Point = new Point();
		overlap.x = end.bottomRight.x - end.topLeft.x;
		overlap.y = end.bottomRight.y - end.topLeft.y;

		var moveAxis : Int; //0:x, 1:y
		if (overlap.x < overlap.y)
		{
			moveAxis = 0;
		}
		else
		{
			moveAxis = 1;
		}
		
		if (moveAxis == 0)
		{
			a.Move(new Point(sign(direction.x) * overlap.x, 0));
		}
		else if (moveAxis == 1)
		{
			a.Move(new Point(0, sign(direction.y) * overlap.y));
		}
	}*/
	
	private function sign(i : Float) : Int
	{
		if (i < 0)
		{	
			return -1;
		}
		else if ( i > 0)
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
}