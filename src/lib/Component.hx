package lib;

class Component
{
	public var Drawable : Bool = false; //Determines if components draw() function should be called
	public var Owner : Int;
	
	public function new(Owner : Int) 
	{
		this.Owner = Owner;
	}
	
	public function GetOwner() : GameObject
	{
		return GameObjectManager.GetGameObject(Owner);
	}
	
	public function GetComponentOnOwner(ID : String) : Component
	{
		return GetOwner().GetComponent(ID);
	}
	
	public function Update(elapsed : Float)
	{
		
	}	
	
	public function Draw(spritebatch : SpriteBatch)
	{
		
	}
}