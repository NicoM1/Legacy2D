package lib;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.BlendMode;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Point;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldAutoSize;
import haxe.Log;
import lib.gameobjects.GameObjectManager;

using lib.SpriteBatch;

class Game extends Sprite 
{
	static private var elapsed(get, never):Float;
	static private var _elapsed:Float = 0.0;
	static private var lastElapsed:Float = 0.0;
	static private var accumulator:Float = 0.0;
	static private var maxAccumulation:Float;
	static private var frameRate:Float;
	static public var buffer:BitmapData;
	static public var drawBuffer:Bitmap;
	static public var bgcolor:Int = 0xFFFFFFFF;
	static public var localwidth:Float = 0;
	static public var localheight:Float = 0;
	static public var scale:Float = 0;
	static public var fixedUpdate:Bool = false;
	
	static private var ambientLight : Int;
	static private var lightBuffer:BitmapData;
	static private var drawLightBuffer:Bitmap;
	static private var lights:Array<Light>;

	static private var traceBox : TextField;
	static private var traceText : String;
	
	static function get_elapsed()
	{
		return (Game.fixedUpdate)? frameRate : _elapsed;
	}
		
	public function new (width:Float, height:Float, scale:Float, worldBounds : Point, ?fixedUpdate : Bool = false, ?updateFrameRate = 60, ?ambientLight:Int = 0xFFFFFFFF)
	{		
		super ();
		
		Game.fixedUpdate = fixedUpdate;
		Game.frameRate = (1 / updateFrameRate);
		Game.maxAccumulation = Game.frameRate * 4;
		Game.accumulator = Game.frameRate;
		
		CreateBuffer(width, height, scale);
		BuildLights(ambientLight);
		InitListeners();
		
		GameObjectManager.init(worldBounds);
		
		CreateTracer();
		
	}	
	
	private function CreateBuffer(width:Float, height:Float, scale:Float)
	{
		Game.scale = scale;
		Game.localwidth = width;
		Game.localheight = height;			
		
		buffer = new BitmapData(Math.floor(localwidth), Math.floor(localheight), true, bgcolor);
		drawBuffer = new Bitmap(buffer);
		drawBuffer.scaleX = drawBuffer.scaleY = scale;
		addChild(drawBuffer);
	}
	
	public function Trace( v : Dynamic, ?inf : haxe.PosInfos )
	{
		traceText += "\n";
		if (inf != null)
		{
			traceText += Std.string(inf.fileName + ":");
			traceText += Std.string(inf.methodName);
			traceText += Std.string("(" + inf.lineNumber + "):");
		}
		traceText += Std.string(v);
		traceBox.text = traceText;
		if (traceBox.textHeight > Game.localheight * scale)
		{
			var index = traceText.indexOf("\n") + 1;
			traceText = traceText.substring(index);
			traceBox.text = traceText;
		}
	}
	
	private function BuildLights(ambient : Int)
	{
		Game.ambientLight = ambient;
		lightBuffer = new BitmapData(Math.floor(localwidth), Math.floor(localheight), true, ambientLight);
		drawLightBuffer = new Bitmap(lightBuffer);
		drawLightBuffer.scaleX = drawLightBuffer.scaleY = scale;
		
		lights = new Array<Light>();
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
		UpdateElapsedTime();
		if (fixedUpdate)
		{
			accumulator += _elapsed;
			if (accumulator > maxAccumulation)
			{
				accumulator = maxAccumulation;
			}
			
			while (accumulator > frameRate)
			{
				Update();
				accumulator = accumulator - frameRate;
			}
		}
		else
		{
			Update();
		}
		Draw(true);
	}
	
	public function Update()
	{
		
	}
	private function UpdateElapsedTime()
	{
		var current = Lib.getTimer() / 1000.0;
		_elapsed = current - lastElapsed;
		lastElapsed = current;
	}	
	
	public function Draw(clearBuffer : Bool)
	{
		if (clearBuffer == true)
		{
			ClearBuffer();
		}
	}
	
	public function AddLight(pos : Point, size : Float)
	{
		lights.push(new Light(pos, size));
	}
	
	public function DrawLight()
	{
		#if flash
		if (ambientLight != 0xFFFFFFFF)
		{
			for (l in lights)
			{
				//NEEDS CULL CODE
				lightBuffer.DrawToBuffer(ArtInstance.GetArt(ArtInstance._LIGHT), l.GetRect());
			}
			buffer.draw(drawLightBuffer, null, null, BlendMode.DARKEN);
		}
		#end
	}
	
	private function ClearBuffer()
	{
		buffer.lock();
		buffer.fillRect(buffer.rect, bgcolor);
		buffer.unlock();
		lightBuffer.lock();
		lightBuffer.fillRect(lightBuffer.rect, ambientLight);
		lightBuffer.unlock();
	}
	
	function CreateTracer():Void 
	{
		traceBox = new TextField();
		traceBox.defaultTextFormat = new TextFormat ("_sans", 12, 0x00000000);
		traceBox.autoSize = TextFieldAutoSize.LEFT;
		traceBox.multiline = true;
		addChild(traceBox);
		Log.trace = Trace;
	}
}