package pl.mardraze 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import pl.mardraze.controller.*;

	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Controller 
	{
		
		private static var instance:Controller;
		
		private var map:Dictionary;
		
		private var field:FieldAction;
		
		private var _stage:Stage;
		private var _main:Main;
		
		public function Controller() 
		{
			if (instance != null) throw new Error('Controller is Singleton');
		}
		
		public static function getInstance():Controller
		{
			if (instance == null) {
				instance = new Controller();
			}
			
			return instance;
		}
		
		public function init(main:Main):void 
		{
			_stage = main.stage;
			Model.getInstance().init();
			View.getInstance().init(main);
			State.getInstance().init();

			_main = main;
		}
		
		public function get stage():Stage {
			return _stage;
		}

		public function action(key:String, ...args):Function
		{
			
			try {
				if (!map[key]) throw new Error('KEY ' + key + ' IS UNKNOWN');
					return map[key];
				
			}catch (err:Error) {
				trace(err.message);
			}
			return function():void { };
		}

	}
}