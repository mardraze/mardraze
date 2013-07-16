package com.darkenjin.utils.serialization 
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	
	/**
	 * ...
	 * @author Marcin Drazek
	 */
	public class Serializer extends AbstractSerializable
	{
		
		private var _allObjects:Array;
		private var _serializedObject:SerializedObject;
		private var _input:*;
		private var _external:*;
		private var _objectToArrayIndex:Dictionary;
		private var _counter:uint;
		
		public function Serializer() 
		{
			_allObjects = new Array();
			_serializedObject = new SerializedObject();
			_objectToArrayIndex = new Dictionary();
			_counter = 0;
		}
		
		public function serialize(input:*, external:* = null):void {
			_input = input;
			_external = external;
			doSerialize();
			_serializedObject.allObjects = _allObjects;
		}
		
		private function doSerialize():void {
			addObjectToArray(_input);
			updateRefs();
		}
		
		private function addObjectToArray(object:*):void {
			var className:String = getNameClass(object);
			if (isPassedByRef(object, className)) {
				var properties:Object = getProperties(object as Object);
				addToArrayIfNotExists(object as Object, properties, className);
				addChildrenToArray(object as Object, properties);
			}
		}

		private function getProperties( o:Object ):Object {
			var classInfo:XML = describeType( o );
			if ( classInfo.@name.toString() == "Object" ) {
				return getObjectProperties(o, classInfo);
			} else {
				return getAdvancedObjectProperties(o, classInfo);
			}
		}
		
		private function getObjectProperties(o:Object, classInfo:XML):Object {
			var properties:Object = new Object();
			for (var key:String in o ){
				var property:* = o[ key ];
				if ( !(property is Function) ) {
					properties[key] = getPropertyValue(property);
				}
			}
			return properties;
		}

		private function getAdvancedObjectProperties(o:Object, classInfo:XML):Object {
			var properties:Object = new Object();
			for each ( var v:XML in classInfo..*.(name() == "variable" || ( name() == "accessor"
					&& attribute( "access" ).charAt( 0 ) == "r" ) ) ) {
				if ( v.metadata && v.metadata.( @name == "Transient" ).length() > 0 )
					continue;
				properties[v.@name.toString()] = getPropertyValue(o[ v.@name ]);
			}
			return properties;
		}
		
		private function getPropertyValue(property:*):* {
			var className:String = getNameClass(property);
			if (isPassedByRef(property, className)) {
				var value:Object = new Object();
				value.__refId = REFID_NEED_UPDATE;
				value.tmpValue = property;
				return value;
			}else {
				return property; //primitive
			}			
		}
		
		private function addToArrayIfNotExists(value:Object, properties:Object, className:String):void {
			if (_objectToArrayIndex[value] === undefined) {
				var obj:Object = new Object();
				obj['className'] = className;
				obj['properties'] = properties;
				_allObjects[_counter] = obj;
				_objectToArrayIndex[value] = _counter;
				_counter++;
			}
		}
		
		private function addChildrenToArray(parent:Object, parentProperties:Object):void {
			if (parent is Array) {
				for (var key:* in parent as Array) {
					addObjectToArray(parent[key]);
				}
			} else {
				for (var property:* in parentProperties) {
					addObjectToArray(parent[property]);
				}
			}
		}
		
		private function updateRefs():void {
			for (var object:Object in _allObjects) {
				updateDefinitionRefs(_allObjects[object]);
			}
		}
		
		private function updateDefinitionRefs(object:Object):void {
			for (var property:* in object.properties) {
				if (object.properties[property] is Object && 'tmpValue' in object.properties[property]) {
					var index:* = _objectToArrayIndex[object.properties[property].tmpValue];
					if (index !== undefined) {
						object.properties[property].tmpValue = null;
						object.properties[property].__refId = uint(index);
					}else {
						debugObjectToArrayIndex(object.properties[property].tmpValue);
					}
					updateDefinitionRefs(object.properties[property]);
				}
			}
		}
		
		private function debugObjectToArrayIndex(value:*):void {
			trace('DOPASOWANIE JSONA: KLASA1 '+getNameClass(value)+' '+JSON.stringify(value));
			for (var objectKey:* in _objectToArrayIndex) {
				if (JSON.stringify(objectKey) == JSON.stringify(value)) {
					trace('- ZNALEZIONO INDEX '+_objectToArrayIndex[objectKey]+' KLASA2 '+getNameClass(objectKey));
				}
			}
		}
		
		public function getObject():Object {
			return _serializedObject as Object;
		}
	}
}