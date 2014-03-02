package lib;

import flash.geom.Point;

class TransformComponent extends Component
{
	public var Position(default, null) : Point;
	public var DrawBounds(default, null) : Point;
	
	public function new(Owner : Int) 
	{	
		super(Owner);
		Position = new Point();
		DrawBounds = new Point();
	}
}