package lib.gameobjects;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;

/**
 * ...
 * @author 
 */
class DrawComponent extends Component
{
	var Image : Int;
	
	public function new(Owner : Int, ?Image : Int) 
	{
		super(Owner);
		Drawable = true;
		this.Image = (Image == null)? ArtInstance._PIXEL : Image;
	}
	
	override public function Draw(spritebatch:SpriteBatch) 
	{
		spritebatch.DrawToScreen(ArtInstance.GetArt(Image), new Rectangle(GetOwner().GetPosition().x, GetOwner().GetPosition().y, GetOwner().Bounds.x, GetOwner().Bounds.y), null);
	}
	
}