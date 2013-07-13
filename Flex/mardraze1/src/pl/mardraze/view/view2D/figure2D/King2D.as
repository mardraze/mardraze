package pl.mardraze.view.view2D.figure2D
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import pl.mardraze.view.view2D.Figure2D;
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class King2D extends Figure2D
	{
		
		
		public function King2D(color:uint):void {
			super(KING, color);
			var circle:Bitmap = new Img();
			addChild(circle);
			
			graphics.beginBitmapFill(circle.bitmapData);
			graphics.endFill();
			
		}
	}

}