package lib.gameobjects;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;

/**
 * ...
 * @author 
 */
class DrawComponent extends Component
{

	public function new(Owner : Int) 
	{
		super(Owner);
		Drawable = true;
	}
	
	override public function Draw(spritebatch:SpriteBatch) 
	{
		if (GetOwner().GetPosition() == null)
		{
			throw "OH SHIT";
		}
		spritebatch.DrawToScreen(ArtInstance.GetArt(ArtInstance._PIXEL), new Rectangle(GetOwner().GetPosition().x, GetOwner().GetPosition().y, GetOwner().Bounds.x, GetOwner().Bounds.y), null, new ColorTransform(0, 0, 0));
	}
	
}