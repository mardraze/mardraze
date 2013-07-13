package pl.mardraze
{
	import flash.display.Sprite;
	import pl.mardraze.view.components.BoardScreen;
	import pl.mardraze.view.components.MainScreen;
	
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Game extends Sprite
	{
		private var _boardScreen:BoardScreen;
		private var _mainScreen:MainScreen;
		public var session:Object;
		
		public function Game():void 
		{
			init();
		}
		
		private function init():void {

			_boardScreen = new BoardScreen();
			_mainScreen = new MainScreen();
			
			addChild(_boardScreen);
			addChild(_mainScreen);
			
			session = new Object();
			ApplicationFacade.getInstance().startup(this);
			session.selectedIndex = 0;
			
		}
		
		public function get boardScreen():BoardScreen {
			return _boardScreen;
		}
		
		public function get mainScreen():MainScreen {
			return _mainScreen;
		}
	}
	
}
