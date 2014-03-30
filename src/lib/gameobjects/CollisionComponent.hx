package lib.gameobjects;
import flash.geom.Point;
import flash.geom.Rectangle;
import lib.collision.AABB;

/**
 * ...
 * @author 
 */
class CollisionComponent extends Component
{	
	///Determines if object handles its own collisions
	var autoResolve : Bool;
	
	///used to temporarily allow object to not collide
	public var collideAble : Bool = true;
	
	///autoResolve makes component handle its own collisions
	public function new(Owner : Int, ?autoResolve : Bool = true) 
	{
		super(Owner);
		
		this.autoResolve = autoResolve;
	}

	public function GetBounds() : Rectangle
	{
		var owner = GetOwner();
		return new Rectangle(owner.GetPosition().x, owner.GetPosition().y, owner.Bounds.x, owner.Bounds.y);
	}
	
	public function Move(offset : Point)
	{
		GetOwner().Move(offset);
	}
	
	override public function Update(elapsed:Float) 
	{
		super.Update(elapsed);
		
		if (autoResolve)
		{
			for (c in Collides())
			{
				Resolve(c);
			}
		}
	}
	
	public function Resolve(b : CollisionComponent)
	{
		if (collideAble)
		{
			var owner = GetOwner();
			
			var aAABB = new AABB(new Point(owner.GetPosition().x, owner.GetPosition().y), 
								new Point(owner.GetPosition().x + owner.Bounds.x, 
								owner.GetPosition().y + owner.Bounds.y));
			owner = b.GetOwner();
			var bAABB = new AABB(new Point(owner.GetPosition().x, owner.GetPosition().y), 
								new Point(owner.GetPosition().x + owner.Bounds.x, 
								owner.GetPosition().y + owner.Bounds.y));
			
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
				Move(new Point(sign(direction.x) * overlap.x, 0));
			}
			else if (moveAxis == 1)
			{
				Move(new Point(0, sign(direction.y) * overlap.y));
			}
			
			GameObjectManager.UpdateObject(this); //UNTESTED
		}
	}
	
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
	
	public function Collides() : Array<CollisionComponent>
	{
		return GameObjectManager.CheckCollision(this);
	}
}