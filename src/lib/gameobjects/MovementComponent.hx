package lib.gameobjects;

import flash.geom.Point;
import flash.geom.Rectangle;
import lib.ExtraMath;

class MovementComponent extends Component
{	
	public var Acceleration(default, null) : Point;
	public var Velocity(default, null) : Point;
	public var MaxVelocity(default, null) : Point;	
	public var Drag(default, null) : Point;	
	
	public function new(Owner : Int, ?Acceleration : Point, ?Drag : Point, ?MaxVelocity : Point) 
	{	
		super(Owner);
		Drawable = true;
		
		this.Acceleration = Acceleration == null? new Point(200,200) : Acceleration;
		Velocity = new Point();
		this.MaxVelocity = MaxVelocity == null? new Point(300,300) : MaxVelocity;
		MaxVelocity = new Point();
		this.Drag = Drag == null? new Point(70,70) : Drag;
	}
	
	override public function Update(elapsed:Float) 
	{
		super.Update(elapsed);
		
		if (Velocity.x != 0 || Velocity.y != 0)
		{
			GetOwner().Position.x += Velocity.x * elapsed; 
			GetOwner().Position.y += Velocity.y * elapsed;
		}
		
		ApplyDrag(elapsed);

		
		if (ExtraMath.Positive(Velocity.x) > MaxVelocity.x)
		{
			Velocity.x = ExtraMath.Sign(Velocity.x) * MaxVelocity.x;
		}
		if (ExtraMath.Positive(Velocity.y) > MaxVelocity.y)
		{
			Velocity.y = ExtraMath.Sign(Velocity.y) * MaxVelocity.y;
		}
	}
	
	private function ApplyDrag(elapsed : Float)
	{
		if ((Velocity.x != 0 || Velocity.y != 0) && (Drag.x != 0 || Drag.y != 0))
		{
			var drag = new Point(Drag.x * elapsed, Drag.y * elapsed);
			if (Velocity.x < 0)
			{
				Velocity.x = Math.min(Velocity.x + drag.x, 0);
			}
			else if (Velocity.x > 0)
			{
				Velocity.x = Math.max(Velocity.x - drag.x, 0);
			}
			if (Velocity.y < 0)
			{
				Velocity.y = Math.min(Velocity.y + drag.y, 0);
			}
			else if (Velocity.y > 0)
			{
				Velocity.y = Math.max(Velocity.y - drag.y, 0);
			}
		}
	}
	
	public function AddVelocity(movement : Point)
	{
		Velocity.x += (movement.x); 
		Velocity.y += (movement.y);
	}
	
	public function Move(movement : Point, elapsed : Float)
	{
		Velocity.x += (movement.x * Acceleration.x) * elapsed; 
		Velocity.y += (movement.y * Acceleration.y) * elapsed;
	}
	
	public function StopVelocity(axis : String)
	{
		if (axis == "x")
		{
			Velocity.x = 0;
		}
		else
		{
			Velocity.y = 0;
		}
	}
}