package com.darkenjin.utils.serialization 
{
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class SerializableObject extends Object
	{
		public var refs:Object;
		public var definitions:Array;
/*
		public SerializableObject(refs:Object, definitions:Array) {
			this.refs = refs;
			this.definitions = definitions;
		}
	*/	
		public function deserialize():Object {
			return parseValue(refs);
		}

		private function parseValue(value:*):*{
			if (value is Array) {
				return deserializeArray(value);
			}else if (value is Object) {
				return deserializeObject(value as Object);
			}else {
				return value;
			}
		}
		
		private function deserializeObject(obj:Object):Object{
			var result:Object = new Object();
			
			for each(var key:String in obj) {
				result[key] = parseValue(obj[key]);
			}
			
			return result;
		}
		
		private function deserializeArray(array:Array):Array {
			var result:Array = new Array();
			for each(var key:uint in array) {
				result[key] = parseValue(array[key]);
			}
			return result;
		}
		
	}

}