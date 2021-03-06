package lib.collision;

import flash.geom.Rectangle;
import lib.gameobjects.GameObject;
import lib.gameobjects.CollisionComponent;

using ArrayTools;

class QuadTree
{
	private var maxObjects = 50;
	private var maxLevels = 10;
	
	private var level = 0;
	private var objects : Array<CollisionComponent>;
	private var bounds : Rectangle;
	private var nodes : Array<QuadTree>; //COUNTER-CLOCKWISE
	
	public function new(level : Int, bounds : Rectangle, ?maxObjects = 50, ?maxLevels = 10) 
	{
		this.level = level;
		this.bounds = bounds;
		this.maxObjects = maxObjects;
		this.maxLevels = maxLevels;
		
		objects = new Array<CollisionComponent>();
		nodes = new Array<QuadTree>();
	}
	
	public function Clear()
	{
		objects.clear();
		
		for (n in nodes)
		{
			n.Clear();
			n = null;
		}
	}
	
	private function Split()
	{
		trace("split");
		var subWidth = (bounds.width / 2);
		var subHeight = (bounds.height / 2);
		var x = bounds.x;
		var y = bounds.y;
		
		nodes[0] = new QuadTree(level + 1, new Rectangle(x + subWidth, y, subWidth, subHeight));	
		nodes[1] = new QuadTree(level + 1, new Rectangle(x, y, subWidth, subHeight));	
		nodes[2] = new QuadTree(level + 1, new Rectangle(x, y + subHeight, subWidth, subHeight));	
		nodes[3] = new QuadTree(level + 1, new Rectangle(x + subWidth, y + subHeight, subWidth, subHeight));	
	}
	
	///Updates an individual object in the quadtree
	public function UpdateObject(object : CollisionComponent)
	{
		for (o in objects)
		{
			if (o.Owner == object.Owner)
			{
				o = object;
				return;
			}
		}
		for (n in nodes)
		{
			n.UpdateObject(object);
		}
	}
	
	private function GetIndex(Rect : CollisionComponent) : Int
	{
		var index = -1;
		var verticalMidpoint = bounds.x + (bounds.width / 2);
		var horizontalMidpoint = bounds.y + (bounds.height / 2);
		
		var topQuad : Bool = (Rect.GetBounds().y < horizontalMidpoint && Rect.GetBounds().y + Rect.GetBounds().height < horizontalMidpoint);
		var bottomQuad : Bool = (Rect.GetBounds().y > horizontalMidpoint);
		
		if (Rect.GetBounds().x < verticalMidpoint && Rect.GetBounds().x + Rect.GetBounds().width < verticalMidpoint)
		{
			if (topQuad)
			{
				index = 1;
			}
			else if (bottomQuad)
			{
				index = 2;
			}
		}
		else if (Rect.GetBounds().x > verticalMidpoint)
		{
			if (topQuad)
			{
				index = 0;
			}
			else if (bottomQuad)
			{
				index = 3;
			}
		}
		
		return index;
	}
	
	public function Insert(Rect : CollisionComponent)
	{
		if (nodes[0] != null)
		{
			var index = GetIndex(Rect);
			
			if (index != -1)
			{
				nodes[index].Insert(Rect);
				return;
			}
		}
		
		objects.push(Rect);
		
		if (objects.length > maxObjects && level < maxLevels)
		{
			if (nodes[0] == null)
			{
				Split();
			}
			
			var i = 0;
			while (i < objects.length)
			{
				var index = GetIndex(objects[i]);
				if (index != -1)
				{
					nodes[index].Insert(objects[i]);
					objects.remove(objects[i]);
				}
				else
				{
					i++;
				}
			}
		}
	}
	
	public function Retrieve(Rect : CollisionComponent) : Array<CollisionComponent>
	{
		var returnObjects : Array<CollisionComponent> = new Array<CollisionComponent>();
		
		var index = GetIndex(Rect);
		if (index != -1)
		{
			if (nodes[0] != null)
			{
				return nodes[index].Retrieve(Rect);
			}
		}
		
		for (o in objects)
		{
			returnObjects.push(o);
		}
		
		for (n in nodes)
		{
			var childObjects = n.Retrieve(Rect);
			
			for (c in childObjects)
			{
				returnObjects.push(c);
			}
		}
		
		return returnObjects;		
	}
	
}