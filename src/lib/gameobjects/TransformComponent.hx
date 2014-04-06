package lib.gameobjects;

import flash.geom.Point;
import flash.geom.Rectangle;

class TransformComponent extends Component
{
	public var Position(default, null) : Point;
	public var Bounds(default, null) : Point;
	
	public var Speed(default, null) : Point;
	public var Velocity(default, null) : Point;
	public var MaxSpeed(default, null) : Point;
	
	private var elapsed : Float = 1/60; //BADDDDDDDD
	
	
	public function new(Owner : Int, Width : Int, Height : Int) 
	{	
		super(Owner);
		Drawable = true;
		
		Position = new Point();
		Bounds = new Point(Width, Height);
		Speed = new Point();
		Velocity = new Point();
		MaxSpeed = new Point();
	}
	
	override public function Update(elapsed:Float) 
	{
		super.Update(elapsed);
		this.elapsed = elapsed;
		
		var col = GameObjectManager.GetGameObject(Owner).GetComponent(CollisionComponent);
		if (col != null)
		{			
			col.SetBounds(new Rectangle(Position.x, Position.y, Bounds.x, Bounds.y)); //STUBBED
			
			var cols = col.CollidesWithOffset(new Point(Velocity.x * elapsed, 0));
			if (cols.length > 0)
			{					
				Velocity.x = 0;		
			}
			cols = col.CollidesWithOffset(new Point(Velocity.x * elapsed, Velocity.y * elapsed));
			if (cols.length > 0)
			{
				Velocity.x = 0;		
			}
		}
		Position.x += Velocity.x * elapsed; Position.y+= Velocity.y * elapsed;
	}
	
	override public function Draw(spritebatch:SpriteBatch) 
	{
		super.Draw(spritebatch);
		
		spritebatch.DrawToScreen(ArtInstance.GetArt(ArtInstance._PIXEL), new Rectangle(Position.x, Position.y, 10, 10));
	}
	
	public function Move(movement : Point)
	{
		Velocity.x += (movement.x); 
		Velocity.y += (movement.y);
	}
	
	public function SetPosition(pos : Point)
	{
		Position = pos;
	}
}