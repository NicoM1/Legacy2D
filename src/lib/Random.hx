package lib;

class Random
{	
	static public function RandomFloat(min : Float, max : Float)
	{
		return min + (max - min) * Math.random();
	}	
}