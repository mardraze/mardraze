package pl.mardraze 
{
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class State 
	{
		public static var INIT:uint = 1;
		public static var FIELD_SELECTED:uint = 2;
		public static var LOADING:uint = 3;
		
		
		private var _state:Array;
		
		public function State() 
		{
			if (instance != null) throw new Error('State is Singleton');
			_state = new Array();
			_state.push(LOADING);
		}
		
		private static var instance:State;
		
		public function init():void
		{
			_state.push(INIT);
			this.endState(LOADING);
		}
		
		public static function getInstance():State
		{
			if (instance == null) {
				instance = new State();
			}
			
			return instance;
		}
		
		public function setState(state:uint):void {
			_state.push(state);
		}
		
		public function endState(state:uint):void {
			var index:int;
			while ((index = _state.indexOf(state)) != -1) {
				_state.splice(index, 1);
			}
		}
		
		public function inArray(positiveArr:Array, negativeArr:Array = null):Boolean {
			var item:uint;
			if(negativeArr)
				for each(item in negativeArr) {
					if (_state.indexOf(item) != -1) {
						return false;
					}
				}

			for each(item in positiveArr) {
				if (_state.indexOf(item) != -1) {
					return true;
				}
			}


			return false;
		}
	}
}