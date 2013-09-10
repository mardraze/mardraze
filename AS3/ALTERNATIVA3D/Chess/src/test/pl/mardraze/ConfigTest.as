package test.pl.mardraze
{
	import flash.utils.setTimeout;
	import pl.mardraze.Config;
	import flexunit.framework.Test;
	import org.flexunit.asserts.assertEquals;
	
	public class ConfigTest
	{
		[Test]
		public function ConfigExists():void {
			var waiting:Boolean = true;
			var config:Config = new Config();
			config.ready(function():void {
				waiting = false;
			} );
			config.reload();
			var counter:int = 0;
			var clock:Function = function():void { 
				if (waiting) {
					if (counter++ > 10) {
						assertEquals(1, 0);
						return;
					}
					setTimeout(clock, 1000);
				}else {
					assertEquals(1, 1);
				}
			};
			clock();
		}
	}

}