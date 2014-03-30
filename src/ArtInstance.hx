package ;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import openfl.Assets;
import lib.Art;

class ArtInstance
{
	static public var _PIXEL = 0;
	static public var _LIGHT = 1;
	/*static public var _FISH = 0;
	static public var _BUBBLE = 1;
	static public var _SWORD_SOULSTEALER = 3;
	[Sample Identifiers]*/
	
	static public function Init() 
	{
		Art.Init();
		
		LoadContent();
	}
	
	///Load Your Content Here
	static private function LoadContent()
	{
		///Use Art.AddImage() or Art.AddBitmap() To Add Content
		Art.AddBitmap(new Bitmap(new BitmapData(1, 1, true, 0xFFFFFFFF)), _PIXEL);
		Art.AddImage("assets/BasicLight.png", _LIGHT);
	}
	
	static public function GetArt(imageID : Int) : Bitmap
	{
		return Art.GetArt(imageID);
	}
	
	static public function GetArtRect(imageID : Int) : Rectangle
	{
		var a = Art.GetArt(imageID);
		var r = new Rectangle(0, 0, a.width, a.height);
		return r;
	}
}