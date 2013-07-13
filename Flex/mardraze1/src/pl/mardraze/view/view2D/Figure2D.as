package pl.mardraze.view.view2D
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import pl.mardraze.Resource;
	import pl.mardraze.view.Board;
	import pl.mardraze.view.Chess;
	import pl.mardraze.view.Figure;
	
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Figure2D extends Sprite implements Figure
	{
		
		private var _type:uint;
		private var _color:uint;
		private var _bitmap:Bitmap;
		private var canMoveCallback:Function;
		
		public function Figure2D(type:uint = 0, color:uint = 0):void
		{
			if (Chess.isValidType(type)) {
				_bitmap = Resource.images['figure' + type];
				canMoveCallback = Chess.getCanMoveCallbackByType(type);
			}

			_type = type;
			_color = color;
			buttonMode = false;
		}
		
		public function get type():uint
		{
			return _type;
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		public function isNotSet():Boolean
		{
			return !Chess.isValidType(type);
		}
		
		public function canMove(x1:uint, y1:uint, x2:uint, y2:uint, board:Board):Boolean
		{
			return canMoveCallback(x1, y1, x2, y2, this.color, board);
		}
		
		
	}
}