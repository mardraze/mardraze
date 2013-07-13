package pl.mardraze.view 
{
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Chess
	{

		public static var NOCOLOR:uint = 0;
		public static var NOFIGURE:uint = 0;
		
		public static var COLOR_FIGURE_BLACK:uint = 1;
		public static var COLOR_FIGURE_WHITE:uint = 2;
		
		public static var KING:uint = 1;
		public static var ROOK:uint = 2;
		public static var BISHOP:uint = 3;
		public static var QUEEN:uint = 4;
		public static var KNIGHT:uint = 5;
		public static var PAWN:uint = 6;

		public static function getFigureByInitialPosition(x:uint, y:uint, FigureClass:Class):*
		{
			var color:int = -1;
			if (x == 0 || x == 1)
			{
				color = Chess.COLOR_FIGURE_BLACK;
			}
			else if (x == 7 || x == 6)
			{
				color = Chess.COLOR_FIGURE_WHITE;
			}
			
			
			if (color != -1)
			{
				switch (y)
				{
					case 0: 
					case 7: 
						return new FigureClass(Chess.ROOK, color);
					case 1: 
					case 6: 
						return new FigureClass(Chess.KNIGHT, color);
					case 2: 
					case 5: 
						return new FigureClass(Chess.BISHOP, color);
					case 3: 
						return new FigureClass(Chess.KING, color);
					case 4: 
						return new FigureClass(Chess.QUEEN, color);
				}
			}
			
			if (x == 1)
			{
				return new FigureClass(Chess.PAWN, COLOR_FIGURE_BLACK);
			}
			
			if (x == 6)
			{
				return new FigureClass(Chess.PAWN, COLOR_FIGURE_WHITE);
			}
			
			return new FigureClass();
		}
		
		public static function isValidType(type:uint):Boolean {
			return (type >= 1 && type <= 6);
		}
		
		
		private static function canMoveKing(x1:uint, y1:uint, x2:uint, y2:uint, color:uint, board:Board):Boolean
		{
			if (Math.abs(x1 - x2) == 1 || Math.abs(y1 - y2) == 1) {
				return true;
			}
			return false;
		}

		private static function canMoveQueen(x1:uint, y1:uint, x2:uint, y2:uint, color:uint, board:Board):Boolean
		{
			return false;
		}
		
		private static function canMoveBishop(x1:uint, y1:uint, x2:uint, y2:uint, color:uint, board:Board):Boolean
		{
			return false;
		}

		private static function canMoveKnight(x1:uint, y1:uint, x2:uint, y2:uint, color:uint, board:Board):Boolean
		{			
			return false;
		}

		private static function canMoveRook(x1:uint, y1:uint, x2:uint, y2:uint, color:uint, board:Board):Boolean
		{
			return false;
		}

		private static function canMovePawn(x1:uint, y1:uint, x2:uint, y2:uint, color:uint, board:Board):Boolean
		{
			return false;
		}
		
		public static function getCanMoveCallbackByType(type:uint):Function {
			switch(type) {
				case KING: return canMoveKing;
				case QUEEN: return canMoveQueen;
				case ROOK: return canMoveRook;
				case BISHOP: return canMoveBishop;
				case KNIGHT: return canMoveKnight;
				case PAWN: return canMovePawn;
				default: return function():Boolean { return false; };
			}
		}
		
	}
}