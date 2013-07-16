package com.darkenjin.utils.serialization 
{
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class AbstractSerializable {
		
		protected var PRIMITIVE_TYPES:Array = ['Number','int','uint','Boolean','String']; //passed by value
		protected var REFID_NEED_UPDATE:int = -1;

		
		
		public function getClassByName(className : String) : Class {
			var c : Class;
			c = getDefinitionByName(clearClassName(className))as Class;
			return c;
		}

		public function getNameClass(o:*):String{
			return clearClassName(getQualifiedClassName(o));
		}

		public function clearClassName(name:String):String{
			if(name)
				return name..split("::").join(".").replace("__AS3__.vec.","")
			else{
				return "Object"
			}
		}
		public function getClassByObject(o:*):Class{
			return  getClassByName(getQualifiedClassName(o));
		}

		
		public function isPassedByRef(object:*, className:String = null):Boolean {
			if (!className) className = getNameClass(object);
			return object is Object && PRIMITIVE_TYPES.indexOf(className) == -1;
		}
		
	}
	
}