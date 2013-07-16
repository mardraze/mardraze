package pl.mardraze 
{
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Log 
	{
		private static var count:int = 0;
		
		public static function d(msg:*):void {
			trace('------'+count+'-------');
			trace(msg);
			trace('------' + count + '-------');
			count++;
		}
	}

}