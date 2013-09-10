package pl.mardraze 
{
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Utils 
	{
		public static function coloredStandardMaterial(color:int = 0x7F7F7F):StandardMaterial {
			var material:StandardMaterial;
			material = new StandardMaterial(createColorTexture(color), createColorTexture(0x7F7FFF));
			return material;
		}

		public static function createColorTexture(color:uint, alpha:Boolean = false):BitmapTextureResource {
			return new BitmapTextureResource(new BitmapData(1, 1, alpha, color));
		}

		
	}

}