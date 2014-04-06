package lib.gameobjects;

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
	
	public function GetComponentOnOwnerByID<T:Component>(ID : String, type:Class<T>):T
	{
		return GetOwner().GetComponentByID(ID,type);
	}
	
	public function GetComponentOnOwner<T:Component>(type:Class<T>):T
	{
		return GetOwner().GetComponent(type);
	}
	
	public function Update(elapsed : Float)
	{
		
	}	
	
	public function Draw(spritebatch : SpriteBatch)
	{
		
	}
}