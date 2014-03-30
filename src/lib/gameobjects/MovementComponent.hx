package lib.gameobjects;

import flash.geom.Point;
import flash.geom.Rectangle;

class MovementComponent extends Component
{	
	public var Speed(default, null) : Point;
	public var Velocity(default, null) : Point;
	public var MaxSpeed(default, null) : Point;	
	
	public function new(Owner : Int) 
	{	
		super(Owner);
		Drawable = true;
		
		Speed = new Point();
		Velocity = new Point();
		MaxSpeed = new Point();
	}
	
	override public function Update(elapsed:Float) 
	{
		super.Update(elapsed);
		
		GetOwner().Position.x += Velocity.x * elapsed; GetOwner().Position.y += Velocity.y * elapsed;
	}
	
	public function Move(movement : Point)
	{
		Velocity.x += (movement.x); 
		Velocity.y += (movement.y);
	}
}