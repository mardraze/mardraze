package pl.mardraze 
{
	import flash.display.Sprite;
	import pl.mardraze.view.view2D.*;
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class View extends Sprite
	{
		private static var instance:View;

		private var main:Sprite;
		private var menu:Sprite;
		private var board:Sprite;
		
		public function View() 
		{
			if (instance != null) throw new Error('View is Singleton');
		}
		
		
		public function init(main:Sprite):void
		{
			this.main = main;
			board = new Board2D();
			menu = new Menu2D();
			main.addChildAt(menu, 0);
			main.addChildAt(board, 1);
		}
		
		public static function getInstance():View
		{
			if (instance == null) {
				instance = new View();
			}
			
			return instance;
		}

		
	}

}