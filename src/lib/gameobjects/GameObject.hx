package lib.gameobjects;

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
	
	///ID Can't Be 0, 0 will switch to -1
	public function new(ID : Int, ?Tag : String) 
	{
		if (ID != 0)
		{
			this.ID = ID;
		}
		else
		{
			this.ID = -1;
		}
		this.Tag = Tag;
		
		components = new Map<String, Component>();
		AddComponent(new TransformComponent(ID, 10, 10));
	}
	
	public function GetComponentByID<T:Component>(ID : String, type : Class<T>) : T
	{
		var c = components.get(ID);
		if (c != null)
		{
			if (Std.is(c, type))
			{
				return cast c;
			}
		}
		return null;
	}
	
	public function GetComponent<T:Component>(type:Class<T>):T
	{
		var name = Type.getClassName(type);
		return cast components.get(name);
	}
	
	public function AddComponent<T:Component>(component:T)
	{
		var type = Type.getClass(component);
		var name = Type.getClassName(type);
		components.set(name, component);
	}
	
	///Adds a component at a specified ID, note: can be overwritted by a call to AddComponent if the ID is also the type
	public function AddComponentWithID(component : Component, ID : String)
	{
		components.set(ID, component);
	}
	
	/*
	public function GetComponent(ID : String) : Component
	{
		return components.get(ID);
	}*/
	
	/*
	public function GetTransformComponent() : TransformComponent
	{
		return cast(components.get("transform"), TransformComponent); 
	}*/
	
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