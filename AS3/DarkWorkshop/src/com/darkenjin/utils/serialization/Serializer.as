package com.darkenjin.utils.serialization 
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Serializer 
	{
		
		private var _serializableObject:SerializableObject;
		private var _definitions:Array;
		private var _objectToRef:Dictionary;
		private var _refs:Object;

		private static var PRIMITIVE_TYPES:Array = ['Number','int','uint','Boolean','String']; //passed by value
		
		private var _counter:uint;
		
		public function Serializer() 
		{
			_definitions = new Array();
			_objectToRef = new Dictionary();
			_refs = new Object();
			_serializableObject = new SerializableObject();
			_counter = 1;
		}
		
		public function findDefinitions(value:*):void {
			try {
				var className:String = getNameClass(value);
				if (value is Array) {
					trace('value: ', className, JSON.stringify(value as Array));
				}
				
				if (value != null && isPassedByRef(className)) {
					if (!_objectToRef[value]) {
						_definitions[_counter] = new SerializableItem(className, properties);
						_objectToRef[value] = _counter;
						_counter++;
					}

					if (value is Array) {
						for (var key:* in value as Array) {
							try {
								findDefinitions(value[key]);
							}catch (e1:Error) {
								trace(e1.message);
							}
						}
					}else {
						var properties:Object = getObjectProperties(value as Object);
						var once:int = 0;
						for (var property:* in properties) {
							findDefinitions(value[property]);
						}
					}
				}else {
				}
			}catch (e:Error) {
				trace(e.message);
			}
		}
		
		public function serialize(value:*):void {
			trace(JSON.stringify(_definitions));
			var byValResult:* = serializeValue(_refs, value);
			if (byValResult != null) {
				_refs = byValResult;
			}
			
			trace(JSON.stringify(_refs));
		}
		
		private function serializeValue(output:*, value:*):* {
			
			if (_objectToRef[value]) {
				var refId:uint = _objectToRef[value];
				
				try {
					output.__refId = refId;
					output.__className = _definitions[refId][className];
				}catch (e4:Error) {
					trace('e4'+e4.message);
				}
			}
			
			try {
				var className:String = getNameClass(value);
				var ClassDefinition:Class = getClassByName(className);
				if (isPassedByRef(className)) {
					if (value && value is Object) {
						var byValResult:* = null;
						if (value is Array) {
							
							for (var i:uint = 0; i < (value as Array).length; i++ ) {
								try {
									output[i] = new Object();
									byValResult = serializeValue(output[i], value[i]);
									if (byValResult != null) {
										output[i] = byValResult;
									}
								}catch (e3:Error) {
									trace('e3'+e3.message);
								}
							}
							
						}else {
							var properties:Object = getObjectProperties(value as Object);
							for(var property:String in properties) {
								try {
									output[property] = new Object();
									byValResult = serializeValue(output[property], value[property]);
									if (byValResult != undefined) {
										output[property] = byValResult;
									}
									
								}catch (e3:Error) {
									trace('e3'+e3.message+' '+JSON.stringify(value));
								}
							}
						}
					}
				}else {
					return value as ClassDefinition;
				}
			}catch (e:Error) {
				trace('e' + e.message);
			}
			return null;
		}

		private function isPassedByRef(value:*):Boolean {
			return PRIMITIVE_TYPES.indexOf(value) == -1;
		}
		private function getObjectProperties( o:Object ):Object {
			var properties:Object = new Object();
			var classInfo:XML = describeType( o );
			if ( classInfo.@name.toString() == "Object" ) {
				var value:Object;
				for ( var key:String in o ){
					value = o[ key ];
					if ( !(value is Function) ) {
						try {
							properties[key] = null;
						}catch (e3:Error) {
							trace('e3'+e3.message);
						}
					}
				}
			} else {
				for each ( var v:XML in classInfo..*.(name() == "variable" || ( name() == "accessor"
						&& attribute( "access" ).charAt( 0 ) == "r" ) ) )
				{
					if ( v.metadata && v.metadata.( @name == "Transient" ).length() > 0 )
						continue;
					try {
						properties[v.@name.toString()] = null;
					}catch (e2:Error) {
						trace('e2'+e2.message);
					}

					
				}
			}
			return properties;
		}
		
		
		public function setExternal(external:*):void {
			
		}
		
		public function getObject():SerializableObject {
			return _serializableObject;
		}
		
    private static function getClassByName(className : String) : Class {
        var c : Class;
        c = getDefinitionByName(clearClassName(className))as Class;
        return c;
    }

    private static function getNameClass(o:*):String{
        return clearClassName(getQualifiedClassName(o));
    }

    private static function clearClassName(name:String):String{
        if(name)
            return name..split("::").join(".").replace("__AS3__.vec.","")
        else{
            return "Object"
        }
    }
    private static function getClassByObject(o:*):Class{
        return  getClassByName(getQualifiedClassName(o));
    }

		
	}

}