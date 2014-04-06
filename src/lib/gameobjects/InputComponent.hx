package lib.gameobjects;

import flash.geom.Point;
import lib.UserInput;

import lib.VectorMath;

/**
 * ...
 * @author 
 */
class InputComponent extends Component
{
	var passedCheck : Bool = false;
	
	public function new(Owner : Int) 
	{
		super(Owner);
	}
	
	override public function Update(elapsed:Float) 
	{
		super.Update(elapsed);
		
		if (!passedCheck)
		{
			if (GetComponentOnOwner(MovementComponent) == null)
			{
				throw "no movement controller on owner";
			}
			passedCheck = true;
		}
		
		var movement : Point = new Point();
		if (UserInput.IsKeyDown("w"))
		{
			movement.y += -1;
		}
		if (UserInput.IsKeyDown("s"))
		{
			movement.y += 1;
		}
		if (UserInput.IsKeyDown("a"))
		{
			movement.x += -1;
		}
		if (UserInput.IsKeyDown("d"))
		{
			movement.x += 1;
		}
		
		if (movement.x != 0 || movement.y != 0)
		{
			movement = VectorMath.Normalize(movement);
			
			GetComponentOnOwner(MovementComponent).Move(movement, elapsed);
		}
	}
	
}