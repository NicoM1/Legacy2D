package ;

import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.display.StageQuality;
import flash.ui.Mouse;

class Main extends Sprite
{
	public function new() 
	{
		super();	
		
		stage.scaleMode = StageScaleMode.NO_SCALE;
		//stage.quality = StageQuality.LOW;
		//Mouse.hide();
		var game1 = new MainGame(stage);
		addChild(game1);
	}
}