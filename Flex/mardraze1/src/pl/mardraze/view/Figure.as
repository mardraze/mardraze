package pl.mardraze.view
{
	import pl.mardraze.view.Board;
	
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public interface Figure
	{
		function Figure(type:uint, color:uint);
		function get type():uint;
		function get color():uint;
		function isNotSet():Boolean;
		function canMove(x1:uint, y1:uint, x2:uint, y2:uint, board:Board):Boolean;
	}

}