package lib.gameobjects;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author 
 */
class CollisionComponent extends Component
{
	var bounds : Rectangle;
	var oldBounds : Rectangle;
	
	public function new(Owner : Int, Bounds : Rectangle) 
	{
		super(Owner);
		bounds = Bounds;
		oldBounds = bounds;
		Drawable = true;
	}
	
	public function SetBounds(Bounds : Rectangle)
	{
		bounds = Bounds;
	}
	
	public function GetBounds() : Rectangle
	{
		return bounds;
	}
	
	public function Collides() : Array<CollisionComponent>
	{
		return GameObjectManager.CheckCollision(this);
	}
	
	public function CollidesWithOffset(offset : Point) : Array<CollisionComponent>
	{
		oldBounds = bounds;
		bounds.x += offset.x;
		bounds.y += offset.y;
		
		var results = GameObjectManager.CheckCollision(this);
		
		bounds = oldBounds;
		return results;
	}
	
	
	
}