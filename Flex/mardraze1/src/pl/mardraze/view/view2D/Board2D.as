package pl.mardraze.view.view2D
{
	import flash.display.Sprite;
	import pl.mardraze.view.Board;
	import pl.mardraze.view.Figure;
	import pl.mardraze.view.view2D.figure2D.King2D;
	
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Board2D extends Sprite implements Board
	{
		
		public var selected:Field2D = null;
		
		public function Board2D()
		{
			init();
		}
		

		public function isFieldEmpty(x:uint, y:uint):Boolean
		{
			return (getChildAt(pos2Index(x, y)) as Field2D).figure.isNotSet();
		}
		
		private function init():void
		{
			for (var i:int = 0; i < 8; i++)
			{
				for (var j:int = 0; j < 8; j++)
				{
					var f:Field2D = new Field2D();
					if (j % 2 == i % 2)
					{
						f.setDefaultColor(Field2D.COLOR_BLACK);
					}
					else
					{
						f.setDefaultColor(Field2D.COLOR_WHITE);
					}
					f.init(i, j);
					addChildAt(f, pos2Index(i, j));
				}
			}
		}
		
		private function pos2Index(x:uint, y:uint):uint
		{
			return x * 8 + y;
		}
		
	}

}