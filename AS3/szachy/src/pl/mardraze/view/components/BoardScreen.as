package pl.mardraze.view.components 
{

	
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	
	 import flash.display.*;
	 import flash.text.TextField;
	 import pl.mardraze.view.components.BoardScreen.*;
	 
	public class BoardScreen extends Sprite
	{
		
		public static const EFFECT_END:String = 'BoardScreenEffectEnd';
		
		private var fields:Array;
		
		public const FIELD_WIDTH:uint = 50;
		public const FIELD_BLACK_COLOR:uint = 0x000000;
		public const FIELD_WHITE_COLOR:uint = 0xFFFFFF;
		
		public function BoardScreen() 
		{
			//this.visible = false;
			addFields();
			addFigure();
		}
		
		private function addFields():void {
			
			fields = [];
			for (var i:Number = 0; i < 8; i++ ) {
				fields[i] = new Array();
				for (var j:Number = 0; j < 8; j++ ) {
					var field:Sprite = new Sprite();
					addChild(field);
					fields[i][j] = field;
					drawField(i, j, getColor(i, j));
				}
			}
		}

		private function addFigures():void {
			
/*			figures = [];
			figures[0] = new Array();
			figures[1] = new Array();
*/
			
		}

		private function drawField(i:uint, j:uint, color:uint):void {
			(fields[i][j] as Sprite).graphics.beginFill(color);
			(fields[i][j] as Sprite).graphics.drawRect(i*FIELD_WIDTH, j*FIELD_WIDTH, FIELD_WIDTH, FIELD_WIDTH);
			(fields[i][j] as Sprite).graphics.endFill();
		}

		private function setFigure(i:uint, j:uint, figure:Figure):void {
			if ((fields[i][j] as Sprite).numChildren > 1) {
				trace(typeof(this)+" WARNING setFigure "+i+" "+j);
			}
			
			(fields[i][j] as Sprite).removeChildAt(0);
			(fields[i][j] as Sprite).addChildAt(figure, 0);
		}

		
		private function getColor(i:uint, j:uint):uint {
			
			var min:uint  = i;
			var max:uint  = j;
			
			if ( i > j) {
				min = j;
				max = i;
			}
			
			if ((max - min) % 2 == 0) {
				return FIELD_BLACK_COLOR;
			}else {
				return FIELD_WHITE_COLOR;
			}
			
		}
		
		
	}

}