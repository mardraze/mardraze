package com.darkenjin.utils 
{
	import com.darkenjin.utils.serialization.*;

	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Serialization
	{
		
		public static function serialize(obj:*, external:* = null):Object {
			if (isSerialized(obj)) throw new Error('Object can\'t be serialized but is serialized now');
			var serializer:Serializer = new Serializer();
			serializer.serialize(obj, external);
			return serializer.getObject();
		}
		
		public static function deserialize(obj:Object):Object {
			if (!isSerialized(obj)) throw new Error('Object can\'t be deserialized but is not serialized');
			var deserializer:Deserializer = new Deserializer();
			deserializer.deserialize(obj as SerializedObject);
			return deserializer.getObject();
		}
		
		public static function isSerialized(obj:Object):Boolean {
			return obj is SerializedObject;
		}
	}

}