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
	
	///Do note, position and drawbounds affect clipping of drawing, although they don't affect drawing on their own
	public function new(ID : Int, ?Tag : String) 
	{
		this.ID = ID;
		this.Tag = Tag;
		
		components = new Map<String, Component>();
		AddComponent(new TransformComponent(ID), "transform");
	}
	
	public function AddComponent(component : Component, ID : String)
	{
		components.set(ID, component);
	}
	
	public function GetComponent(ID : String) : Component
	{
		return components.get(ID);
	}
	
	public function GetTransformComponent() : TransformComponent
	{
		return cast(components.get("transform"), TransformComponent);
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