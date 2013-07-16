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
	public class Deserializer extends AbstractSerializable
	{
		private var _classes:Array;
		private var _output:Object;
		private var _allSerializedObjects:Array;
		private var _allObjects:Array;
		
		public function deserialize(serializedObject:SerializedObject):void {
			_allSerializedObjects = serializedObject.allObjects;
			_output = new Object();
			_classes = new Array();
			_allObjects = new Array();
			for (var i:uint = 0; i < _allSerializedObjects.length; i++) {
				deserializeObject(i);
			}
			makeOutputObject();
		}
		
		private function deserializeObject(index:uint):* {
			var serializedObject:Object = _allSerializedObjects[index];
			_classes[index] = getClassByName(serializedObject.className);
			var result:* = new Object();
			for (var key:String in serializedObject.properties) {
				if (!isPassedByRef(serializedObject.properties[key])) {
					result[key] = serializedObject.properties[key];
				}
			}
			_allObjects[index] = result;
		}
		
		private function makeOutputObject():void {
			makeObjectRefs(0);
			_output = _allObjects[0];
		}
		
		private function makeObjectRefs(index:uint):void {
			var object:* = _allObjects[index];
		}
		
		public function getObject():Object {
			return _output;
		}
	}

}