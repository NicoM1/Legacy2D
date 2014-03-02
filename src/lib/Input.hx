package lib;

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.KeyboardEvent;
import flash.events.Event;
import flash.geom.Point;
import flash.display.Stage;
import flash.events.TouchEvent;

class Input extends Sprite
{
	static private var keysDown : Array<String>;
	static private var keysPressed : Array<String>;
	static private var touchPositions : Map<Int, Point>;
	
	public function new(stage:Stage) 
	{
		super();
		keysDown = new Array();
		keysPressed = new Array();
		touchPositions = new Map();
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouch);
		stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouch);
		stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		#if flash
		//addEventListener(Event.EXIT_FRAME, frameExit);
		#end
	}	
	
	static private function onKeyDown(e)
	{
		var key = keyCodeToString(e.keyCode);
		if (!IsKeyDown(key))
		{
			keysDown.push(key);
			keysPressed.push(key);
		}
	}
	
	static private function onKeyUp(e)
	{
		var key = keyCodeToString(e.keyCode);
		if (IsKeyDown(key))
		{
			keysDown.remove(key);
		}
	}
	
	static private function onTouch(e:TouchEvent)
	{
		var pos = new Point(e.stageX / Game.scale, e.stageY / Game.scale);
		touchPositions.set(e.touchPointID, pos);
	}
	
	static private function onTouchEnd(e:TouchEvent)
	{
		touchPositions.remove(e.touchPointID);
	}
	
	static private function frameExit(e)
	{
		ClearPressedKeys();
	}
	
	static public function ClearPressedKeys()
	{
		keysPressed = new Array<String>();
	}
	
	static public function LastKeyPressed() : String
	{
		return keysPressed[keysPressed.length - 1];
	}
	
	static public function WasKeyPressed(key : String) : Bool
	{
		for (i in keysPressed)
		{
			if (i == key.toLowerCase())
			{
				return true;
			}
		}
		return false;
	}
	
	static public function IsKeyDown(key : String) : Bool
	{
		for (i in keysDown)
		{
			if (i == key.toLowerCase())
			{
				return true;
			}
		}
		return false;
	}
	
	static public function IsKeyUp(key : String) : Bool
	{
		return !IsKeyDown(key);
	}
	
	static public function IsAnyKeyDown() : Bool
	{
		if (keysDown.length > 0)
		{
			return true;
		}
		return false;
	}
	
	static public function WasAnyKeyPressed() : Bool
	{
		if (keysPressed.length > 0)
		{
			return true;
		}
		return false;
	}
	
	static private function keyCodeToString(code) 
	{
		return switch (code) 
		{
		   case 27  : "escape";
		   case 189 : "minus";
		   case 187 : "plus";
		   case 46  : "delete";
		   case 8   : "backspace";
		   case 219 : "lbracket";
		   case 221 : "rbracket";
		   case 220 : "backslash";
		   case 20  : "capslock";
		   case 186 : "semicolon";
		   case 222 : "quote";
		   case 13  : "enter";
		   case 16  : "shift";
		   case 188 : "comma";
		   case 190 : "period";
		   case 191 : "slash";
		   case 17  : "control";
		   case 18  : "alt";
		   case 32  : "space";
		   case 38  : "up";
		   case 40  : "down";
		   case 37  : "left";
		   case 39  : "right";
		   case  9  : "tab";
		   default  : String.fromCharCode(code).toLowerCase();
		}
	}
	
	static public function GetTouchPositions() : Array<Point>
	{
		var positions : Array<Point> = new Array();
		for (p in touchPositions)
		{
			positions.push(p);
		}
		return positions;
	}
}