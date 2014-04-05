package lib.map;
import flash.geom.Point;

/**
 * ...
 * @author 
 */
class TmxObject
{
	public var name : String;
	public var type : String;
	public var position : Point;
	public var bounds : Point;
	public var properties : Map<String, String>;
	
	public function new()
	{
		properties = new Map<String, String>();
		position = new Point();
		bounds = new Point();
	}
}