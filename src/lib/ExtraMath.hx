package lib;

/**
 * ...
 * @author 
 */
class ExtraMath
{

	public function new() {	}
	
	static public function Sign(?int : Int, ?float : Float) : Int
	{
		return (int != null)? (int > 0? 1 : -1) : (float > 0? 1 : -1);
		
		throw "both inputs were null";
	}
	
	///returns the value as a positive number eg. [-1 would be 1], and [1 would still be 1]
	static public function Positive(float : Float) : Float
	{
		if (float < 0)
		{
			return float * -1;
		}
		else
		{
			return float;
		}
	}
	
}