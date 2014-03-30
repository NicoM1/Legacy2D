package lib;

import flash.geom.Point;
import flash.geom.Rectangle;

class Light
{
	public var pos : Point;
	public var size : Float;
	
	public function new(pos : Point, size : Float) 
	{
		this.pos = pos;
		this.size = size;
	}
	
	public function GetRect()
	{
		return new Rectangle(pos.x - size / 2, pos.y - size / 2, size, size);
	}
}