package mouseeventsexample 
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Config extends Object
	{
		private var _ready:Function;
		public var values:Object;
		
		public function reload():void {
			var loaderA3D:URLLoader = new URLLoader();
			loaderA3D.dataFormat = URLLoaderDataFormat.BINARY;
			loaderA3D.load(new URLRequest("parsersexample/data.txt"));
			loaderA3D.addEventListener(Event.COMPLETE, function(e:Event):void {
				values = JSON.parse(String((e.target as URLLoader).data));
				_ready();
			});
		}
		
		public function ready(ready:Function):void {
			_ready = ready;
		}
		
	}

}