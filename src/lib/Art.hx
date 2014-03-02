package lib;

import flash.display.Bitmap;
import openfl.Assets;

class Art
{
	static public var content : Map<Int,Bitmap>;
	static public function Init() 
	{
		content = new Map<Int,Bitmap>();
	}
	
	///Adds An Image To The Content Array, A Name Must Be Specified For Later Reference
	static public function AddImage(path : String, imageID : Int)
	{
		content.set(imageID, new Bitmap(Assets.getBitmapData(path)));
	}
	
	static public function AddBitmap(bitMap : Bitmap, imageID : Int)
	{
		content.set(imageID, bitMap);
	}
	
	static public function GetArt(imageID : Int)
	{
		return content[imageID];
	}
}