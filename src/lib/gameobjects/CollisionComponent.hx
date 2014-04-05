package lib.gameobjects;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
import lib.collision.AABB;
import lib.ExtraMath;

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
	
	public var immobile : Bool = false;
	
	public var separatePriority(default, null) : Float = 0;
	
	private var maxAttempts : Int = 5;
	
	private var hasMovement : Bool = false;
	private var checkedMovement : Bool = false;
	
	///autoResolve makes component handle its own collisions
	public function new(Owner : Int, ?immobile : Bool = false, ?autoResolve : Bool = false, ?serparatePriority : Float = 0) 
	{
		super(Owner);
		
		this.autoResolve = autoResolve;
		
		this.immobile = immobile;
		
		this.separatePriority = serparatePriority;
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
		
		if (!checkedMovement)
		{
			if (GetComponentOnOwner(MovementComponent) != null)
			{
				hasMovement = true;
			}
			checkedMovement = true;
		}
		
		if (autoResolve)
		{
			var attempts : Int = 0;
			do{
				for (c in Collides())
				{
					Move(Resolve(c));
				}
				attempts++;
			}while ((Collides().length > 0) && attempts < maxAttempts);
		}
	}
	
	///returns the movement needed to push this object out of another object
	public function Resolve(b : CollisionComponent) : Point
	{
		if (collideAble && !immobile && separatePriority >= b.separatePriority)
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
				if (hasMovement)
				{
					GetComponentOnOwner(MovementComponent).StopVelocity("x");
				}
				return new Point(ExtraMath.Sign(direction.x) * overlap.x, 0);
			}
			else if (moveAxis == 1)
			{
				if (hasMovement)
				{
					GetComponentOnOwner(MovementComponent).StopVelocity("y");
				}
				return new Point(0, ExtraMath.Sign(direction.y) * overlap.y);
			}
		}
		return new Point(0, 0);
	}
	
	public function Collides() : Array<CollisionComponent>
	{
		return GameObjectManager.CheckCollision(this);
	}
}