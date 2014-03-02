package lib;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import flash.geom.Point;
import openfl.display.FPS;
import openfl.Assets;

class Game extends Sprite 
{
	static private var elapsed(default,null):Float = 0.0;
	static private var lastElapsed:Float = 0.0;
	static public var buffer:BitmapData;
	static public var drawBuffer:Bitmap;
	static public var bgcolor:Int = 0xFFFFFFFF;
	static public var localwidth:Float = 0;
	static public var localheight:Float = 0;
	static public var scale:Float = 0;	
		
	public function new (width:Float, height:Float, scale:Float) 
	{		
		super ();
		
		CreateBuffer(width, height, scale);
		InitListeners();
	}	
	
	private function CreateBuffer(width:Float, height:Float, scale:Float)
	{
		Game.scale = scale;
		Game.localwidth = width;
		Game.localheight = height;			
		
		buffer = new BitmapData(Math.floor(localwidth), Math.floor(localheight), bgcolor);
		drawBuffer = new Bitmap(buffer);
		drawBuffer.scaleX = drawBuffer.scaleY = scale;
		addChild(drawBuffer);
	}
	
	
	private function InitListeners()
	{
		addEventListener(Event.ENTER_FRAME, OnEnterFrame);
	}
	
	public function Destroy()
	{
		removeEventListener(Event.ENTER_FRAME, OnEnterFrame);
	}
	
	private function OnEnterFrame(e)
	{
		Update();
		Draw(true);
	}
	
	public function Update()
	{
		UpdateElapsedTime();
		/*trace(elapsed);
		if (elapsed < 0)
		{
			trace("shit");
		}*/
	}
	private function UpdateElapsedTime()
	{
		var current = Lib.getTimer() / 1000.0;
		elapsed = current - lastElapsed;
		lastElapsed = current;
	}	
	
	public function Draw(clearBuffer : Bool)
	{
		if (clearBuffer == true)
		{
			ClearBuffer();
		}
	}
	
	private function ClearBuffer()
	{
		buffer.lock();
		buffer.fillRect(buffer.rect, bgcolor);
		buffer.unlock();
	}
}