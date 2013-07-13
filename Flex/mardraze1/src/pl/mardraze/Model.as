package pl.mardraze 
{
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Model 
	{
		private static var instance:Model;
		
		public function Model() 
		{
			if (instance != null) throw new Error('Model is Singleton');
		}
		
		public function init():void {
			
		}

		public static function getInstance():Model
		{
			if (instance == null) {
				instance = new Model();
			}
			
			return instance;
		}
		
	}

}