package lib;

import flash.geom.Point;

class VectorMath
{
	static public function Normalize(p : Point) : Point
	{		
		var pnew : Point;
		
		var distance : Float = Math.sqrt(p.x * p.x + p.y * p.y);
		pnew = new Point(p.x / distance, p.y / distance);
		
		return pnew;
	}
	static public function Distance(a : Point, b : Point) : Float
	{
		var c : Point = new Point();
		c.x = a.x - b.x;
		c.y = a.y - b.y;
		return Math.sqrt(c.x*c.x + c.y*c.y);
	}
}