package 
{
	
	import flash.display.Sprite;
	import org.flexunit.internals.TraceListener;
	import org.flexunit.runner.FlexUnitCore;
	import tests.*;

	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Main extends Sprite
	{

		private var testCore: FlexUnitCore;
		
		public function Main() {
			testCore = new FlexUnitCore();
			testCore.addListener(new TraceListener());
			testCore.run(SerializerTest);
		}
		
	}
	
}