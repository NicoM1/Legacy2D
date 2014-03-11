package lib;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.display.BlendMode;
import flash.Lib;
import openfl.display.Tilesheet;

using ArrayTools;


class SpriteBatch
{
	var buffer : BitmapData;
	var matrix : Matrix;
	
	var drawCalls : Array<DrawCallInstance>;
	
	var IDBuffer : Array<Int>;
	var dXBuffer : Array<Float>;
	var dYBuffer : Array<Float>;
	var dWBuffer : Array<Float>;
	var dHBuffer : Array<Float>;
	var sXBuffer : Array<Float>;
	var sYBuffer : Array<Float>;
	var sWBuffer : Array<Float>;
	var sHBuffer : Array<Float>;
	var rBuffer : Array<Float>;
	var gBuffer : Array<Float>;
	var bBuffer : Array<Float>;
	var aBuffer : Array<Float>;
	var xFlipBuffer : Array<Int>;
	var yFlipBuffer : Array<Int>;
	var depthBuffer : Array<Float>;
	
	public function new(buffer : Bitmap) 
	{
		this.buffer = buffer.bitmapData;
		matrix = new Matrix();
		drawCalls = new Array<DrawCallInstance>();
		
		IDBuffer = new Array<Int>();
		dXBuffer = new Array<Float>();
		dYBuffer = new Array<Float>();
		dWBuffer = new Array<Float>();
		dHBuffer = new Array<Float>();
		sXBuffer = new Array<Float>();
		sYBuffer = new Array<Float>(); 
		sWBuffer = new Array<Float>();
		sHBuffer = new Array<Float>();
		rBuffer = new Array<Float>();
		gBuffer = new Array<Float>();
		bBuffer = new Array<Float>();
		aBuffer = new Array<Float>();
		xFlipBuffer = new Array<Int>();
		yFlipBuffer = new Array<Int>();
		depthBuffer = new Array<Float>();
	}
	
	public function PushCall(index : Int, imageID : Int, destinationRect : Rectangle, ?sourceRect : Rectangle, ?depth : Float, ?colorTransform : ColorTransform, ?horizontalFlip = false, ?verticalFlip = false )
	{
		IDBuffer.insert(index, imageID);
		dXBuffer.insert(index, destinationRect.x);
		dYBuffer.insert(index, destinationRect.y);
		dWBuffer.insert(index, destinationRect.width);
		dHBuffer.insert(index, destinationRect.height);
		if (sourceRect == null)
		{
			sXBuffer.insert(index, -Game.localwidth);
			sYBuffer.insert(index, -1);
			sWBuffer.insert(index, -1);
			sHBuffer.insert(index, -1);
		}
		else
		{		
			sXBuffer.insert(index, sourceRect.x);
			sYBuffer.insert(index, sourceRect.y);
			sWBuffer.insert(index, sourceRect.width);
			sHBuffer.insert(index, sourceRect.height);
		}
		if (colorTransform == null)
		{
			rBuffer.insert(index, -1);
			gBuffer.insert(index, -1);
			bBuffer.insert(index, -1);
			aBuffer.insert(index, -1);
		}
		else
		{
			rBuffer.insert(index, colorTransform.redMultiplier);
			gBuffer.insert(index, colorTransform.greenMultiplier);
			bBuffer.insert(index, colorTransform.blueMultiplier);
			aBuffer.insert(index, colorTransform.alphaMultiplier);
		}
		if (horizontalFlip == false)
		{
			xFlipBuffer.insert(index, 0);
		}
		else
		{
			xFlipBuffer.insert(index, 1);
		}
		if (verticalFlip == false)
		{
			yFlipBuffer.insert(index, 0);
		}
		else
		{
			yFlipBuffer.insert(index, 1);
		}
		if (depth == null)
		{
			depthBuffer.insert(index, 0);
		}
		else
		{
			depthBuffer.insert(index, depth);
		}
		
	}
	
	///Draw image to screen, due to drawcall arrays needed, only use if depth is absolutly required, max objects for 60fps: around 150
	public function Draw(imageID : Int, destinationRect : Rectangle, ?sourceRect : Rectangle, ?depth : Float, ?colorTransform : ColorTransform, ?horizontalFlip = false, ?verticalFlip = false )
	{
		if (IDBuffer.length == 0)
		{
			PushCall(0, imageID, destinationRect, sourceRect, depth, colorTransform, horizontalFlip, verticalFlip);
			return;
		}
		var index : Int = 0;
		for (i in 0...IDBuffer.length)
		{
			if (depth < depthBuffer[i])
			{
				if (i == 0)
				{
					PushCall(0, imageID, destinationRect, sourceRect, depth, colorTransform, horizontalFlip, verticalFlip);
				}
				else
				{
					PushCall(i - 1, imageID, destinationRect, sourceRect, depth, colorTransform, horizontalFlip, verticalFlip);
				}
				break;
			}
			
			if (i >= IDBuffer.length - 1)
			{
				PushCall(IDBuffer.length, imageID, destinationRect, sourceRect, depth, colorTransform, horizontalFlip, verticalFlip);
				break;
			}
		}
	}
	
	///Draw Images To The Buffer, If Depth Is Supplied, It Must Be Greater Than Zero [CURRENTLY GROSSLY INEFFICIENT]
	public function OldDraw(?image : Bitmap, ?imageID : Int, destinationRect : Rectangle, ?sourceRect : Rectangle, ?depth : Float, ?colorTransform : ColorTransform, horizontalFlip = false, verticalFlip = false )
	{
		//If an image is provided, draw directly to the screen
		if (image != null)
		{
			DrawToScreen(image, destinationRect, sourceRect, colorTransform);
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
	public function OldPushDrawCalls()
	{
		for(i in drawCalls)
		{
			DrawToScreen(ArtInstance.GetArt(i.imageID), i.destinationRect, i.sourceRect, i.color, i.horizontalFlip, i.verticalFlip);
		}
		drawCalls.clear();
	}
	
	public function PushDrawCalls()
	{
		var destRect : Rectangle = new Rectangle();
		var useSource : Bool;
		var sourceRect : Rectangle = new Rectangle();
		var color : ColorTransform = new ColorTransform();
		for(i in 0...IDBuffer.length)
		{
			destRect.x = dXBuffer[i];
			destRect.y = dYBuffer[i];
			destRect.width = dWBuffer[i];
			destRect.height = dHBuffer[i];
			
			useSource = sXBuffer[i] > -Game.localwidth;	
			
			if (rBuffer[i] != -1)
			{
				color.redMultiplier = rBuffer[i];
				color.greenMultiplier = gBuffer[i];
				color.blueMultiplier = bBuffer[i];
				color.alphaMultiplier = aBuffer[i];
			}
			if (!useSource)
			{
				DrawToScreen(ArtInstance.GetArt(IDBuffer[i]), destRect, null, rBuffer[i] != -1? color : null, xFlipBuffer[i] == 1, yFlipBuffer[i] == 1);
			}
			else
			{
				sourceRect.x = sXBuffer[i];
				sourceRect.y = sYBuffer[i];
				sourceRect.width = sWBuffer[i];
				sourceRect.height = sHBuffer[i];
				DrawToScreen(ArtInstance.GetArt(IDBuffer[i]), destRect, sourceRect, rBuffer[i] != -1? color : null, xFlipBuffer[i] == 1, yFlipBuffer[i] == 1);
			}
		}
		IDBuffer.clear();
		dXBuffer.clear();
		dYBuffer.clear();
		dWBuffer.clear();
		dHBuffer.clear();
		sXBuffer.clear();
		sYBuffer.clear();
		sWBuffer.clear();
		sHBuffer.clear();
		rBuffer.clear();
		gBuffer.clear();
		bBuffer.clear();
		aBuffer.clear();
		xFlipBuffer.clear();
		yFlipBuffer.clear();
		depthBuffer.clear();
		
		//hopefully at some point recycle arrays
	}
	
	///Draws directly to buffer, unfortunately does not allow depth
	public function DrawToScreen(?image : Bitmap, destinationRect : Rectangle, ?sourceRect : Rectangle, ?colorTransform : ColorTransform, ?horizontalFlip = false, ?verticalFlip = false)
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
				matrix.translate(image.width, 0);
			}
			if (verticalFlip)
			{
				matrix.scale(1, -1);
				matrix.translate(0, image.height);
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