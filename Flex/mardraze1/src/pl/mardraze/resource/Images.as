package pl.mardraze.resource 
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import pl.mardraze.Log;
	
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Images extends Object
	{
		
		[Embed(source="../../../../img/king1.bmp", mimeType="application/octet-stream")]
		public var figure1:Class;
		
		[Embed(source="../../../../img/rook1.bmp", mimeType="application/octet-stream")]
		public var figure2:Class;

		[Embed(source="../../../../img/rook1.bmp", mimeType="application/octet-stream")]
		public var figure3:Class;
		
		[Embed(source="../../../../img/queen1.bmp", mimeType="application/octet-stream")]
		public var figure4:Class;
		
		[Embed(source="../../../../img/knight1.bmp", mimeType="application/octet-stream")]
		public var figure5:Class;

		[Embed(source="../../../../img/pawn1.bmp", mimeType="application/octet-stream")]
		public var figure6:Class;
		
		public var figure:Object;
		
		public function Images() {
			var obj:Object = this;
			var variable:XMLList = describeType(this).elements('variable');
			this.figure = new Object();
			for each(var elem:XML in variable) {
				var name:String = elem.attribute('name').toString();
				var ClassReference:Class = getDefinitionByName(name) as Class;
				
				this.figure[name+'_obj'] = new ClassReference();
				
			}
		}
		
		public static function getProperties(obj:*):String  {
            var p:*;
            var res:String = '';
            var val:String;
            var prop:String;
            for (p in obj) {
                prop = String(p);
                if (prop && prop!=='' && prop!==' ') {
                    val = String(obj[p]);
                    if (val.length>10) val = val.substr(0,10)+'...';
                    res += prop+':'+val+', ';
                }
            }
            res = res.substr(0, res.length-2);
            return res;
        }
	}

}