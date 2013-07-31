
package tests {

	import com.darkenjin.utils.ExternalObject;
	import com.darkenjin.utils.Serializer;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flexunit.framework.*;
	import org.flexunit.asserts.assertEquals;
	import flash.utils.describeType;

	public class SerializerTest{
		
		private var obj:Object;
		private var result:Object;
		private var _externals:Object;
		private var _onProgressCounter:uint = 0;
		private var _serializer:Serializer;
		
				
		private function initExternals():void {
			_externals = new Object();
			_externals.postac = new ExternalObject('GUID-GUID-GUID-POSTAC-GUID-GUID-GUID');
			_externals.postac2 = new ExternalObject('POSTAC2');
			_externals.postac3 = new ExternalObject('GUID-GUID-GUID-POSTAC3-GUID-GUID-GUID');
		}
		
		private function setupSerializer():void {
			_serializer = new Serializer();
			_serializer.onProgress = function():void {
				//trace('onProgressTest '+(_onProgressCounter++));
			};
			result = _serializer.fromSerializable(_serializer.toSerializable(obj, _externals), _externals);
		}
		
		[Before]
		public function setup():void {
			initExternals();
			var externalNew:ExternalObject = new ExternalObject('NEW');
			
			obj = new Object();
			var tf1:TextField = new TextField();
			tf1.text = 'textfield1';
			obj.typeInt1 = 1 as int;
			obj.typeInt2 = -1 as int;
			obj.typeNumber1 = 2 as Number;
			obj.typeNumber2 = -2 as Number;
			obj.typeString1 = "3" as String;
			obj.typeString2 = "" as String;
			obj.typeString3 = "żććąźćńół \n\n\r\n\t   asd" as String;
			obj.typeBoolean1 = true;
			obj.typeBoolean2 = false;
			obj.typeNull = null;
			obj.typeUndefined = undefined;
			obj.typeDate = new Date();
			obj.typeArray = ['asdasdasd', null, false, -1, 1234565677889990909, "źćńół \\n\\n\\r\\n\\t   asd", externalNew, _externals.postac2] as Array;

			var dict1:Dictionary = new Dictionary();
			dict1['asd'] = 'asdasdWERTgŻŹĆŁÓ\\n\\r\\n';
			obj.typeDictionary1 = dict1;
			
			var dict2:Dictionary = new Dictionary(true);
			dict2['asd'] = 'asdasdWERTgŻŹĆdsfdfgŁÓ\\n\\r\\n';
			
			var tf2:TextField = new TextField();
			tf2.text = 'textfield2';
			var tf3:TextField = new TextField();
			tf2.text = 'textfield3';
			dict2['bar'] = [tf1, tf2] as Array;


			dict2['foo'] = [tf1, tf2, tf3, _externals.postac2, externalNew] as Array;
			
			dict2['foo2'] = externalNew;
			
			obj.typeDictionary2 = dict2;
			obj.typeTextField = tf1;
			
			obj.typeExternalNew = externalNew;
			
			obj.typeExternal = _externals.postac2;
			
			obj.typePoint = new Point(1, 2);
			
			obj.typeTextField = tf1;
			
			setupSerializer();
		}
		
		[Test]
		public function typeInt1():void {
			assertEquals(result.typeInt1, obj.typeInt1);
		}
		
		[Test]
		public function typeInt2():void {
			assertEquals(result.typeInt2, obj.typeInt2);
		}		
		[Test]
		public function typeNumber1():void {
			assertEquals(result.typeNumber1, obj.typeNumber1);
		}		
		[Test]
		public function typeNumber2():void {
			assertEquals(result.typeNumber2, obj.typeNumber2);
		}		
		[Test]
		public function typeString1():void {
			assertEquals(result.typeString1, obj.typeString1);
		}		
		[Test]
		public function typeString2():void {
			assertEquals(result.typeString2, obj.typeString2);
		}		
		[Test]
		public function typeString3():void {
			assertEquals(result.typeString3, obj.typeString3);
		}		
		[Test]
		public function typeBoolean1():void {
			assertEquals(result.typeBoolean1, obj.typeBoolean1);
		}		
		[Test]
		public function typeBoolean2():void {
			assertEquals(result.typeBoolean2, obj.typeBoolean2);
		}		
		[Test]
		public function typeNull():void {
			assertEquals(result.typeNull, obj.typeNull);
		}		
		
		[Test]
		public function typeUndefined():void {
			assertEquals(result.typeUndefined, obj.typeUndefined);
		}		
		[Test]
		public function typeDate():void {
			assertEquals((result.typeDate as Date).getTime(), (obj.typeDate as Date).getTime());
		}
		[Test]
		public function typeArray():void {
			assertEquals(JSON.stringify(result.typeArray), JSON.stringify(obj.typeArray));
		}
		
		[Test]
		public function textfield_Text():void {
			assertEquals((result.typeDictionary2['bar'][0] as TextField).text, (obj.typeDictionary2['bar'][0] as TextField).text);
		}

		[Test]
		public function textfield_Out_Reference():void {
			assertEquals(result.typeDictionary2['foo'][1], result.typeDictionary2['bar'][1]);
		}
		
		[Test]
		public function external_Reference():void {
			assertEquals(obj.typeExternal, result.typeExternal);
			assertEquals(result.typeExternal, result.typeExternal);
			assertEquals(result.typeExternal, obj.typeExternal);
			
			assertEquals(obj.typeExternal, result.typeDictionary2['foo'][3]);
			assertEquals(result.typeExternal, result.typeDictionary2['foo'][3]);
			assertEquals(result.typeExternal, obj.typeDictionary2['foo'][3]);
			
			assertEquals(obj.typeExternal, result.typeArray[7]);
			assertEquals(result.typeExternal, result.typeArray[7]);
			assertEquals(result.typeExternal, obj.typeArray[7]);
			
			assertEquals(obj.typeArray[7], result.typeArray[7]);
			assertEquals(result.typeArray[7], result.typeArray[7]);
			assertEquals(result.typeArray[7], obj.typeArray[7]);
			
			assertEquals(obj.typeArray[7], result.typeDictionary2['foo'][3]);
			assertEquals(result.typeArray[7], result.typeDictionary2['foo'][3]);
			assertEquals(result.typeArray[7], obj.typeDictionary2['foo'][3]);
			
			assertEquals(obj.typeDictionary2['foo'][3], result.typeDictionary2['foo'][3]);
			assertEquals(result.typeDictionary2['foo'][3], result.typeDictionary2['foo'][3]);
			assertEquals(result.typeDictionary2['foo'][3], obj.typeDictionary2['foo'][3]);
		}
		
		[Test]
		public function external_New_Reference():void {

			assertEquals(obj.typeExternalNew, result.typeExternalNew);
			assertEquals(result.typeExternalNew, result.typeExternalNew);
			assertEquals(result.typeExternalNew, obj.typeExternalNew);
			
			assertEquals(obj.typeExternalNew, result.typeDictionary2['foo'][4]);
			assertEquals(result.typeExternalNew, result.typeDictionary2['foo'][4]);
			assertEquals(result.typeExternalNew, obj.typeDictionary2['foo'][4]);
			
			assertEquals(obj.typeExternalNew, result.typeArray[6]);
			assertEquals(result.typeExternalNew, result.typeArray[6]);
			assertEquals(result.typeExternalNew, obj.typeArray[6]);
			
			assertEquals(obj.typeArray[6], result.typeArray[6]);
			assertEquals(result.typeArray[6], result.typeArray[6]);
			assertEquals(result.typeArray[6], obj.typeArray[6]);
			
			assertEquals(obj.typeArray[6], result.typeDictionary2['foo'][4]);
			assertEquals(result.typeArray[6], result.typeDictionary2['foo'][4]);
			assertEquals(result.typeArray[6], obj.typeDictionary2['foo'][4]);
			
			assertEquals(obj.typeDictionary2['foo'][4], result.typeDictionary2['foo'][4]);
			assertEquals(result.typeDictionary2['foo'][4], result.typeDictionary2['foo'][4]);
			assertEquals(result.typeDictionary2['foo'][4], obj.typeDictionary2['foo'][4]);
			
		}
		
		[Test]
		public function point():void {
			assertEquals(obj.typePoint, result.typePoint);
			assertEquals(result.typePoint, result.typePoint);
			assertEquals(result.typePoint, obj.typePoint);
		}
		
	}
}
