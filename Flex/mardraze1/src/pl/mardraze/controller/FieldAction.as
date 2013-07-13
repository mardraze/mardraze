package pl.mardraze.controller 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import pl.mardraze.State;
	
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class FieldAction extends EventDispatcher
	{
		public static function click(e:Event, ...args):void {
			if (State.getInstance().inArray([State.INIT] as Array)) {
				var onSuccess:Function = args[0];
				onSuccess();
				State.getInstance().setState(State.FIELD_SELECTED);
			}
		}
	}

}