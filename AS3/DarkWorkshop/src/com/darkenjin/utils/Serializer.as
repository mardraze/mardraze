/**
 * Created with IntelliJ IDEA.
 * User: filiperp
 * Date: 30/11/12
 * Time: 10:30
 * To change this template use File | Settings | File Templates.
 */

package com.darkenjin.utils {
import flash.utils.describeType;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;
import flash.utils.getQualifiedClassName;
import flash.xml.XMLNode;

public class Serializer {

	public var onProgress:Function = function():void { };
	
	private var _instances:Dictionary;
	private var _indexCounter:int;
	private var _log:Array;
	private var _externals:Object;
	private var _generatedExternals:Object;
	private var _guid2ExternalKey:Dictionary;
	private var _guid2GeneratedExternalKey:Dictionary;
	private var _classPath:Dictionary;
	
	public function Serializer() {
		_log = new Array();
		_log.push('class Serializer log');
		_classPath = new Dictionary();
		_classPath['ExternalObject'] = 'com.darkenjin.utils.ExternalObject';
		_generatedExternals = new Object();
	}
	
	public function toSerializable(obj:*, externals:Object = null):*{
        try {
			init(externals);
			return serialize(obj);
		}catch (e:Error) {
			handle(e, 'UNHANDLED EXCEPTION');
		}
		return obj;
    }

    public function fromSerializable(obj:*, externals:Object = null):*{
		init(externals);
		try {
			return deserialize(obj);
		}catch (e:Error) {
			handle(e, 'UNHANDLED EXCEPTION');
		}
		return obj;
    }

	private function init(externals:Object = null):void {
		_instances = new Dictionary();
        _indexCounter = 0;
		
		_guid2ExternalKey = new Dictionary();

		if (externals) {
			_externals = externals;
			for (var key:String in externals) {
				if (externals[key] is ExternalObject) {
					if (_guid2ExternalKey[externals[key].guid]) {
						handle(new Error('DUPLICATED GUID IN EXTERNAL'));
					}
					_guid2ExternalKey[externals[key].guid] = key;
				}
			}
		}else {
			_externals = new Object();
		}
			
	}
	
	private function setExternals(externals:Object):void {
		if (externals) {
			for (var key:String in externals) {
				if (externals[key] is ExternalObject) {
					_externals[externals[key].guid] = externals[key];
				}
			}
		}
	}

	private function generateUniqueFieldName():String {
		var unique:String = 'generatedBySerializer';
		
		while (unique in _generatedExternals) {
			unique += Number(Math.abs(int(Math.random() * 1000)) % 10).toString();
		}
		
		while (unique in _externals) {
			unique += Number(Math.abs(int(Math.random() * 1000)) % 10).toString();
		}

		return unique;
	}
	
    private function deserialize(obj:*, parent:* = null):Object {
		onProgress();
        var theNameclass:String = getNameClass(obj);
        var result:Object= {};
		
        switch (theNameclass) {
            case ("int"):
            case ("Number"):
                result = Number(obj);
                break;
            case ("String"):
                result= String(obj);
                break;
            case ("Boolean"):
                result= Boolean(obj);
                break;
            case ("null"):
            case ("void"):
            case ("undefined"):
                result= null;
                break;
            case ("Date"):
                result = new Date();
                result.setTime(obj["___value"]);
                break;
            case ("Object"):
	            if ('__externalObjectGuid' in obj) {
					var guid:String = obj.__externalObjectGuid;
					if(isUnknownGuid(guid)){
						addExternalObject(new ExternalObject(guid));
						handle(new Error('deserialize: ExternalObject with guid '+guid+' not found, created new instance'))
					}
					
					result = findExternalObject(guid);
				}else {
					var propertiesOrder:Array= new Array();
					var id:String = "";
					var className:String = "";
					var value:Object = {};
					if(obj["___idRef"]){
						result = _instances[obj["___idRef"]];
					}else{
						id =  obj["___id"];
						className=  obj["___className"];
						switch(className){
							case("Array"):
								value= obj["___value"];
								result = new Array();
								for each (var oArray:Object in value as Array) {
									result.push(deserialize(oArray));
								}
								_instances[id]= result;
								break;
							case ("flash.utils.Dictionary"):
								value= obj["___value"];
								result = new Dictionary();
								for each (var itemDic:*  in value as Array) {
									var indexDic:Object = deserialize(itemDic[0]);
									result[indexDic]=deserialize(itemDic[1])
								}
								_instances[id]= result;
								break;
							case ( "Object"):
								propertiesOrder = obj["___propertiesOrder"] as Array;
								result =  new Object();
								for (var i:int = 0; i < propertiesOrder.length; i++) {
									var propertyArray:String = propertiesOrder[i];
									result[propertyArray]=deserialize( obj[propertyArray]);
								}
								_instances[id]= result;
								break;
							case ("null"):
							case ("void"):
							case ("undefined"):
								result= null;
								break;
							case "XMLList":
								result = new XMLList(obj['___value']);
								break;
							case "XML":
								result = new XML(obj['___value']);
								break;
							case "XMLNode":
								result = new XMLNode(1,obj['___value']);
								break;
							case "XMLAttribute":
								result = new XML(obj['___value']);
								break;
							case ("Date"):
								result = new Date();
								result.setTime(obj["___value"]);
								break;
							default:
								var clssOrg:Class = getDefinitionByName(className) as Class;
								
								try {
									result =  new clssOrg();
								}catch (e:Error) {
									handle(e);
									return undefined;
								}
								
								var child:*;
								var typedObjProperty:String;
								if(className.substr(0,8)=="Vector.<") {
									value= obj["___value"];
									for each  (var dicObj:Object in value) {
										result.push(deserialize(dicObj));
									}
									_instances[id]= result;
								} else{
									propertiesOrder = obj["___propertiesOrder"] as Array;
									for each (typedObjProperty in propertiesOrder) {
										child = deserialize(obj[typedObjProperty]);
										if (child != undefined) {
											result[typedObjProperty] = child;
										}
									}
									
									_instances[id]= result;
								}
								break;
							}
						}
				}
            break;
        }

        return result;
    }

	
	
    private function serialize(obj:*):Object {
		onProgress();
        var theNameclass:String = getNameClass(obj);
        var result:Object= {};

		
        switch (theNameclass) {
            case ("int"):
            case ("Number"):
                result = Number(obj);
                break;
            case ("String"):
                result= String(obj);
                break;
            case ("Boolean"):
                result= Boolean(obj);
                break;
            case ("null"):
            case ("void"):
            case ("undefined"):
                result= null;
                break;
            case (_classPath['ExternalObject']):
				var guid:String = obj.guid;
                result.__externalObjectGuid = guid;
				if(isUnknownGuid(guid)) {
					addExternalObject(obj);
				}
				
                break;
            case ("Date"):
                result.___className=theNameclass;
                result.___value = obj.valueOf();
                break;
            case ("Array"):
                result.___className=theNameclass;
                if(_instances[obj]){
                    result.___idRef =_instances[obj];
                }else{
                    result.___id = generateIndex();
                    _instances[obj]= result.___id;
                    result.___value = [];
                    for each (var itemArray : * in obj as Array) {
                        result.___value.push(serialize(itemArray));
                    }
                }
                break;
            case ("flash.utils.Dictionary"):
                result.___className=theNameclass;
                if(_instances[obj]){
                    result.___idRef =_instances[obj];
                }else{
                    result.___id = generateIndex();
                    _instances[obj]= result.___id;
                    result.___value = [];
                    for  (var itemDic:*  in obj as Dictionary) {
                        var elementCreated:Array = [serialize(itemDic),serialize(obj[itemDic])];
                        result.___value.push(elementCreated);
                    }
                }
                break;
            case "Object":
                result.___className=theNameclass;
                result.___propertiesOrder = [];
                if(_instances[obj]){
                    result.___idRef =_instances[obj];
                }else{
                    result.___id = generateIndex();
                    _instances[obj]= result.___id;
                    for (var objKey:String in obj){
                        result.___propertiesOrder.push(objKey);
                        result[objKey]= serialize(obj[objKey]);
                    }
                }
                break;
            case "XMLList":
            case "XML":
            case "XMLNode":
            case "XMLAttribute":
                result.___className=theNameclass;
                result.___value = (obj).toString();
                break;
            default:
                if(theNameclass.substr(0,8)=="Vector.<") {
                    result.___className=theNameclass;
                    if(_instances[obj]){
                        result.___idRef =_instances[obj];
                    }else{
                        result.___id = generateIndex();
                        _instances[obj]= result.___id;
                        result.___value = [];
                        for each (var itemVec : * in obj ) {
                            result.___value.push(serialize(itemVec));
                        }
                    }
                }else{
                    result.___propertiesOrder = new Array(0);
                    result.___className=theNameclass;
                    if(_instances[obj]){
                        result.___idRef =_instances[obj];
                    }else{
                        result.___id = generateIndex();
                        _instances[obj]= result.___id;
                        var clss : Class = getClassByObject(obj);
                        var name:String = "";
                        var type:String = "";

                        var propertiesList : XMLList = describeType(clss)..factory..variable;
                        for(var i : int;i < propertiesList.length();i++) {
                            name= String(propertiesList[i].@name);
                            type= clearClassName(String(propertiesList[i].@type));
                            var child:Object = serialize(obj[name]);
                            result[name] = child;
							result.___propertiesOrder.push(name);
                        }
						
						propertiesList = describeType(clss)..accessor;
						
                        for(var j : int;j < propertiesList.length();j++) {
                            var access:String = String(propertiesList[j].@access);
							if (access == 'readwrite') {
								name = String(propertiesList[j].@name);
								type = clearClassName(String(propertiesList[j].@type));
								var accessorValue:* = obj[name]; //some accessors returns new instance => then we can't find key in dictionary
								result[name] = serialize(accessorValue);
								result.___propertiesOrder.push(name);
							}
                        }
                    }
                }
                break;
        }
		
        return result;
    }
	
	private function isUnknownGuid(guid:String):Boolean {
		return !(_guid2ExternalKey[guid] || _guid2GeneratedExternalKey[guid]);
	}
	
	private function findExternalObject(guid:String):ExternalObject {
		if (isUnknownGuid(guid)) {
			addExternalObject(new ExternalObject(guid));
		}
		
		if(_externals[_guid2ExternalKey[guid]])
			return _externals[_guid2ExternalKey[guid]];

		return _generatedExternals[_guid2GeneratedExternalKey[guid]];
		
	}
	
	private function addExternalObject(eo:ExternalObject):String {
		var uniqueName:String = generateUniqueFieldName();
		_generatedExternals[uniqueName] = eo;
		_guid2GeneratedExternalKey[eo.guid] = _generatedExternals[uniqueName];
		return uniqueName;
	}
	
    private function getClassByObject(obj:*):Class{
        return Class(getDefinitionByName(getQualifiedClassName(obj)));
    }

    private function getNameClass(o:*):String{
        return clearClassName(getQualifiedClassName(o));
    }

    private function clearClassName(name:String):String{
        if(name)
            return name..split("::").join(".").replace("__AS3__.vec.","")
        else{
            return "Object"
        }
    }

    private function generateIndex():String{
        _indexCounter++;
        return _indexCounter.toString();
    }
	
	

	private function handle(e:Error, message:String = ''):void {
		var date:Date = new Date();
		_log.push(date.toString()+' '+message+' '+e.message);
	}
	
	public function get log():String {
		return _log.join("\n");
	}

	public function get externals():Object {
		return _externals;
	}

}


}
