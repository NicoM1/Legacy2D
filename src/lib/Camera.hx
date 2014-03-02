package lib;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;

class Camera
{
	static var position : Point;
	static var scale : Float = 1;
	
	static var initialized : Bool = false;
	
	public function new() 
	{
		position = new Point();
		initialized = true;
	}
	
	static public function GetPositon(point : Point) : Point
	{
		if (!initialized)
		{
			throw "Camera has not been created";
		}
		else
		{
			return new Point(point.x- position.x, point.y - position.y);
		}
	}
	
	static public function GetCameraPosition() : Point
	{
		return position;
	}
	
	static public function GetScale() : Float
	{
		return scale;
	}
	
	static public function Move(movement : Point)
	{
		if (!initialized)
		{
			throw "Camera has not been created";
		}
		else
		{
			position.x += movement.x; position.y += movement.y;
		}
	}
	
	static public function Zoom(zoom : Float)
	{
		scale += zoom;
	}
	
	static public function SetZoom(zoom : Float)
	{
		scale = zoom;
	}
	
	static public function GetZoom() : Float
	{
		return scale;
	}
	
	static public function GetDrawRect(baseRect : Rectangle, center : Point, topCorner : Bool = true) : Rectangle
	{
		var point = Camera.GetPositon(new Point(baseRect.x, baseRect.y));
		
		if (topCorner)
		{
			center.x += baseRect.width / 2;
			center.y += baseRect.height / 2;
		}
		
		baseRect.width *= Camera.GetScale();
		baseRect.height *= Camera.GetScale();
		baseRect.x = (point.x * Camera.GetScale() - (center.x * (Camera.GetScale()-1)));
		baseRect.y = (point.y * Camera.GetScale() - (center.y * (Camera.GetScale()-1)));
		
		return baseRect;
	}
	
}