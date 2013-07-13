package pl.mardraze.view.components 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
    import pl.mardraze.ApplicationFacade;

	
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class MainScreen extends Sprite
	{
		public static var CREATION_COMPLETE:String = 'MainScreenComplete';
		public static var START:String = 'MainScreenStart';
		
		private var start:Sprite;
		
		public function MainScreen() 
		{
			init();
		}
		
		private function init():void {
			start = new Sprite();
			addChild(start);
			start.graphics.beginFill(0xf10000, 1);
			start.graphics.drawRect(100, 100, 100, 30);
			start.graphics.endFill();
			start.buttonMode = true;
			start.addEventListener(MouseEvent.MOUSE_UP, function():void{ dispatchEvent(new Event(START)) });
		}
		
		
	}

}