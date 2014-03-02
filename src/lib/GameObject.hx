package lib;

import flash.geom.Point;

class GameObject
{
	///Determines if components draw() function should be called
	public var Drawable : Bool = true;
	
	///A specific identifier, unique to this object, Ex: "Enemy01"
	public var ID(default, null) : Int;
	
	///A general identifier, for grouping objects, Ex: "Enemy"
	public var Tag : String;
	
	///The key is a unique identifer, used to acces individual components
	private var components : Map<String, Component>;
	
	public var Position(default, null) : Point;
	public var DrawBounds(default, null) : Point;
	
	public function new(ID : Int, ?Tag : String) 
	{
		this.ID = ID;
		this.Tag = Tag;
		
		Position = new Point();
		DrawBounds = new Point();
		
		components = new Map<String, Component>();
	}
	
	public function Update(elapsed : Float)
	{
		for (c in components)
		{
			c.Update(elapsed);
		}
	}
	
	public function Draw(spritebatch : SpriteBatch)
	{
		if (Drawable)
		{
			for (c in components)
			{
				if (c.Drawable)
				{
					c.Draw(spritebatch);
				}
			}
		}
	}
}