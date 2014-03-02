package lib;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.display.BlendMode;
import flash.Lib;
import openfl.display.Tilesheet;


class SpriteBatch
{
	var buffer : BitmapData;
	var matrix : Matrix;
	
	var drawCalls : Array<DrawCallInstance>;
	
	public function new(buffer : Bitmap) 
	{
		this.buffer = buffer.bitmapData;
		matrix = new Matrix();
		drawCalls = new Array<DrawCallInstance>();
	}
	
	///Draw Images To The Buffer, If Depth Is Supplied, It Must Be Greater Than Zero [CURRENTLY GROSSLY INEFFICIENT]
	public function Draw(?image : Bitmap, ?imageID : Int, destinationRect : Rectangle, ?sourceRect : Rectangle, ?depth : Float, ?colorTransform : ColorTransform, horizontalFlip = false, verticalFlip = false )
	{
		//If an image is provided, draw directly to the screen
		if (image != null)
		{
			drawToScreen(image, destinationRect, sourceRect, colorTransform);
		}
		else
		{
			if (drawCalls.length == 0)
			{
				drawCalls.push(new DrawCallInstance(imageID, destinationRect, sourceRect, depth, colorTransform, horizontalFlip, verticalFlip));
			}
			for (i in 0...drawCalls.length)
			{
				if (drawCalls[i].depth != 0)
				{
					if (drawCalls[i].depth > depth)
					{
						var index = i;
						index --;
						if (index < 0)
						{	
							index = 0;
						}
						drawCalls.insert(index, new DrawCallInstance(imageID, destinationRect, sourceRect, depth, colorTransform, horizontalFlip, verticalFlip));
					}
					else
					{
						if (i == drawCalls.length - 1)
						{
							drawCalls.push(new DrawCallInstance(imageID, destinationRect, sourceRect, depth, colorTransform, horizontalFlip, verticalFlip));
						}
					}
				}
				else
				{
					var index = i;
					index --;
					if (index < 0)
					{	
						index = 0;
					}
					drawCalls.insert(index, new DrawCallInstance(imageID, destinationRect, sourceRect, depth, colorTransform, horizontalFlip, verticalFlip));
				}
			}
		}
	}
	
	///Call At The End Of Draw Method, Draws All Images In Buffer To Screen
	public function PushDrawCalls()
	{
		for(i in drawCalls)
		{
			drawToScreen(ArtInstance.GetArt(i.imageID), i.destinationRect, i.sourceRect, i.color, i.horizontalFlip, i.verticalFlip);
		}
		clear(drawCalls);
	}
	
	  public static function clear(arr:Array<Dynamic>)
	  {
        #if (cpp||php)
           arr.splice(0,arr.length);           
        #else
           untyped arr.length = 0;
        #end
    }
	
	///Draws directly to buffer, unfortunately does not allow depth
	public function drawToScreen(?image : Bitmap, destinationRect : Rectangle, ?sourceRect : Rectangle, ?colorTransform : ColorTransform, horizontalFlip = false, horizontalFlipCenter = 0, verticalFlip = false, verticalFlipCenter = 0)
	{
		var widthScale : Float;
		var heightScale : Float;
		
		if (sourceRect == null)
		{
			matrix.identity();
			widthScale= (destinationRect.width / image.width);
			heightScale = (destinationRect.height / image.height);
			if (horizontalFlip)
			{
				matrix.scale( -1, 1);
				matrix.translate(horizontalFlipCenter != 0? horizontalFlipCenter * 2 : image.width, 0);
			}
			if (verticalFlip)
			{
				matrix.scale(1, -1);
				matrix.translate(0, verticalFlipCenter != 0?verticalFlipCenter * 2 : image.height);
			}
			matrix.translate(destinationRect.x / widthScale, destinationRect.y / heightScale);
			matrix.scale(widthScale, heightScale);
			buffer.lock();
			buffer.draw(image, matrix, colorTransform);
			buffer.unlock();
		}
		else
		{
			var bmd = new BitmapData(Math.floor(sourceRect.width), Math.floor(sourceRect.height), true, 0x00FFFFFF);
			matrix.identity();
			matrix.translate( -sourceRect.x, -sourceRect.y);
			if (horizontalFlip)
			{
				matrix.scale( -1, 1);
				matrix.translate(sourceRect.width, 0);
			}
			if (verticalFlip)
			{
				matrix.scale(1, -1);
				matrix.translate(0, sourceRect.height);
			}
			bmd.lock();
			bmd.draw(image, matrix);
			bmd.unlock();
			
			matrix.identity();
			
			widthScale = (destinationRect.width / bmd.width);
			heightScale = (destinationRect.height / bmd.height);
			matrix.translate(destinationRect.x / widthScale, destinationRect.y / heightScale);
			matrix.scale(widthScale, heightScale);

			buffer.lock();
			buffer.draw(bmd, matrix, colorTransform);
			buffer.unlock();
		}
	}
}