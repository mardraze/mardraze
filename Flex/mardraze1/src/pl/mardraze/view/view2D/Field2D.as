package pl.mardraze.view.view2D 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import pl.mardraze.Controller;
	import pl.mardraze.controller.FieldAction;
	import pl.mardraze.view.Board;
	import pl.mardraze.view.Chess;
	import pl.mardraze.view.Figure;
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Field2D extends Sprite
	{
		
		public static var COLOR_BLACK:uint = 0x000000;
		public static var COLOR_WHITE:uint = 0xffffff;
		
		private var defaultColor:uint;
		private var color:uint;
		private var posX:uint;
		private var posY:uint;
		public var _figure:Figure2D = new Figure2D();
		
		private var selectedColor:uint = 0xf10000;
		
		public static var WIDTH:uint = 50;
		
		public function Field2D() 
		{
			buttonMode = true;
			addEventListener(MouseEvent.CLICK, function(e:Event):void { select(); } );
		}

		public function setDefaultColor(color:uint):void
		{
			defaultColor = color;
			setColor(color);
		}
		
		public function get figure():Figure {
			return _figure;
		}
		
		private function setColor(color:uint):void
		{
			this.color = color;
		}
		
		public function init(posX:uint, posY:uint):void {
			
			this.posX = posX;
			this.posY = posY;
			
			x = posX * WIDTH;
			y = posY * WIDTH;
			
			_figure = Chess.getFigureByInitialPosition(posX, posY, Figure2D);
			redraw();
		}
		
		public function redraw():void {
			graphics.beginFill(color, 1);
			graphics.drawRect(0, 0, WIDTH, WIDTH);
			while(numChildren > 0) {
				removeChildAt(0);
			}
			graphics.endFill();
			addChildAt(_figure, 0);
			
		}
		
		public function select():void {
			var src:Field2D = (parent as Board2D).selected as Field2D;

			if (!move(src)) {
				((parent as Board2D).selected as Field2D).reset();
				(parent as Board2D).selected = null;
			}
		}
		
		
		private function move(src:Field2D):Boolean {
			if (canMove(src)) {
				if (src != null) {
					_figure = src.figure as Figure2D;
					src.reset();
					(parent as Board2D).selected = null;
				} else {
					(parent as Board2D).selected = this;
				}
				setColor(selectedColor);
				redraw();
				return true;
			}
			return false;
		}
		
		private function canMove(src:Field2D):Boolean {
			if (src == null || (src.figure != null && src !== this 
			&& src.figure.canMove(src.posX, src.posY, posX, posY, parent as Board))) {
				return true;
			}
			return false;
		}
		
		private function reset():void {
			color = defaultColor;
			redraw();
		}
	}

}