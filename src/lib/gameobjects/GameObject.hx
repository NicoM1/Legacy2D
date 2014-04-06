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
	
	public var Parent(default, null) : Int;
	
	public var Position(default, null) : Point;
	private var WorldPosition(default, null) : Point;
	public var Bounds : Point;
	
	///The key is a unique identifer, used to acces individual components
	private var components : Map<String, Component>;
	
	private var children : Array<Int>;
	
	///ID Can't Be 0, 0 will switch to -1
	public function new(ID : Int, ?Tag : String, ?Position : Point, ?Bounds : Point, ?Parent : Int = -1) 
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
		
		this.Parent = Parent;
		
		components = new Map<String, Component>();
		children = new Array<Int>();
		
		if (Position == null)
		{
			this.Position = new Point(0,0);
		}
		else
		{
			this.Position = Position;
		}
		WorldPosition = new Point();
		if (Bounds == null)
		{
			this.Bounds = new Point();
		}
		else
		{
			this.Bounds = Bounds;
		}
	}
	
	///Gets pos, taking into account if object is a child
	public function GetPosition() : Point
	{
		if (Parent == -1)
		{
			return Position;
		}
		else
		{
			return WorldPosition;
		}
	}
	
	public function SetPosition(pos : Point)
	{
		Position = pos;
		var col = GetComponent(CollisionComponent);
		if (col != null)
		{
			GameObjectManager.UpdateObject(col);
		}
	}
	
	public function Move(offset : Point)
	{
		Position.x += offset.x;
		Position.y += offset.y;
		var col = GetComponent(CollisionComponent);
		if (col != null)
		{
			GameObjectManager.UpdateObject(col);
		}
	}
	
	public function AddChild(childID : Int)
	{
		for (c in children)
		{
			if (c == childID)
			{
				return;
			}
		}
		children.push(childID);
	}
	
	public function GetChildren() : Array<GameObject>
	{
		var childG : Array<GameObject> = new Array<GameObject>();
		for (c in children)
		{
			childG.push(GameObjectManager.GetGameObject(c));
		}
		return childG;
	}
	
	public function GetChildrenWithTag(tag : String) : Array<GameObject>
	{
		var childG : Array<GameObject> = new Array<GameObject>();
		var child : GameObject;
		for (c in children)
		{
			child = GameObjectManager.GetGameObject(c);
			if (child.Tag == tag)
			{
				childG.push(child);
			}
		}
		return childG;
	}	
		
	public function GetChildWithTag(tag : String) : GameObject
	{
		var child : GameObject;
		for (c in children)
		{
			child = GameObjectManager.GetGameObject(c);
			if (child.Tag == tag)
			{
				return child;
			}
		}
		
		return null;
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
	
	public function GetParent() : GameObject
	{
		return GameObjectManager.GetGameObject(Parent);
	}
	
	public function Update(elapsed : Float)
	{
		if (Parent != -1)
		{
			WorldPosition.x = GetParent().GetPosition().x + Position.x;
			WorldPosition.y = GetParent().GetPosition().y + Position.y;
		}
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