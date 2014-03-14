package lib.collision;
import flash.geom.Point;

/**
 * ...
 * @author 
 */
class AABB
{
	public var topLeft : Point;
	public var bottomRight : Point;
	
	public function new(?topLeft : Point, ?bottomRight : Point) 
	{
		if (topLeft != null)
		{
			this.topLeft = topLeft;
		}
		else
		{
			this.topLeft = new Point();
		}
		if (bottomRight != null)
		{
			this.bottomRight = bottomRight;
		}
		else
		{
			this.bottomRight = new Point();
		}
	}
	
	public function Center() : Point
	{
		return new Point(topLeft.x + (bottomRight.x - topLeft.x) / 2,
						topLeft.y + (bottomRight.y - topLeft.y) / 2);
	}
	
}