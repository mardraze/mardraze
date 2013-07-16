package com.darkenjin.utils.serialization 
{
	import com.adobe.serialization.json.JSON;
	import com.adobe.serialization.json.JSONEncoder;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Serializable extends Object
	{
		
		public static function serialize(value:*, external:*):SerializableObject {
			var serializer:Serializer = new Serializer();
			serializer.findDefinitions(value);
			serializer.serialize(value);
			serializer.setExternal(external);
			return serializer.getObject();
		}
		
		
		public static function deserialize(obj:Object):Object {
			return obj;
		}
		
		
	}

}