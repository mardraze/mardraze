package com.darkenjin.utils.serialization 
{
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class SerializableItem extends Object
	{
		
		public var className:String;
		public var properties:Object;
		
		public function SerializableItem(className:String, properties:Object) 
		{
			this.className = className;
			this.properties = properties;
		}
		
	}

}