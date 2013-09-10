package test.pl.mardraze
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.View;
	import flash.display.DisplayObject;
	import flash.utils.setTimeout;
	import pl.mardraze.Config;
	import flexunit.framework.Test;
	import org.flexunit.asserts.assertEquals;
	import pl.mardraze.Game;
	
	public class GameTest
	{
		private var game:Game;
		
		[Before]
		public function SetUp():void {
			game = new Game();
		}
		
		[Test]
		public function ChildrenTypesTest():void {
			assertEquals(true, game.getChildByName('view') is View);
			assertEquals(true, game.getChildByName('diagram') is DisplayObject);
			
		}
	}

}