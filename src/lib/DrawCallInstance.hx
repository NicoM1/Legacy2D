package lib;

import flash.geom.Rectangle;
import flash.geom.ColorTransform;

class DrawCallInstance
{
	public var imageID : Int;
	public var destinationRect : Rectangle;
	public var sourceRect : Rectangle;
	public var depth : Float;
	public var color : ColorTransform;
	public var horizontalFlip : Bool;
	public var verticalFlip : Bool;
	
	public function new(imageID : Int, destinationRect : Rectangle, ?sourceRect : Rectangle, ?depth : Float, ?color : ColorTransform, horizontalFlip = false, verticalFlip = false ) 
	{
		this.imageID = imageID;
		this.destinationRect = destinationRect;
		this.depth = depth;
		this.color = color;
		this.sourceRect = sourceRect;
		this.horizontalFlip = horizontalFlip;
		this.verticalFlip = verticalFlip;
	}		
}