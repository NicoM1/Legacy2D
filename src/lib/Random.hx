package lib;

class Random
{	
	static public function RandomFloat(min : Float, max : Float) : Float
	{
		return min + (max - min) * Math.random();
	}
	
	static public function RandomInt(min : Int, max : Int) : Int
	{
		return Math.floor(RandomFloat(min, max));
	}
	
	static public function RandomBool() : Bool
	{
		var i = RandomInt(0, 2);
		if (i == 0)
		{
			return true;
		}
		return false;
	}
}