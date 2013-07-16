
package com.tmp {

	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flexunit.framework.*;
	import org.flexunit.asserts.assertEquals;
	import com.adobe.serialization.json.*;

	
	public class SrlzrControllerTest{
	
		
		private var obj:Object;
		private var result:Object;

		
		
		[Before]
		public function setup():void {
			obj = new Object();
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
			obj.typeArray = ['asdasdasd', null, false, -1, 1234565677889990909, "źćńół \\n\\n\\r\\n\\t   asd"] as Array;

			var dict1:Dictionary = new Dictionary();
			dict1['asd'] = 'asdasdWERTgŻŹĆŁÓ\\n\\r\\n';
			obj.typeDictionary1 = dict1;
			
			var dict2:Dictionary = new Dictionary(true);
			dict2['asd'] = 'asdasdWERTgŻŹĆdsfdfgŁÓ\\n\\r\\n';
			var tf1:TextField = new TextField();
			tf1.text = 'textfield1';
			var tf2:TextField = new TextField();
			tf2.text = 'textfield2';
			var tf3:TextField = new TextField();
			tf2.text = 'textfield3';
			dict2['twoTextfields'] = [tf1, tf2] as Array;
			dict2['threeTextfields'] = [tf1, tf2, tf3] as Array;
			obj.typeDictionary2 = dict2;
			obj.typeTextField = tf1;
			result = SrlzrController.convertToOriginalObject(SrlzrController.convertToSerializableObject(obj));
		}
		
		//[Test]
		public function typeInt1():void {
			assertEquals(result.typeInt1, obj.typeInt1);
		}
		
		//[Test]
		public function typeInt2():void {
			assertEquals(result.typeInt2, obj.typeInt2);
		}		
		//[Test]
		public function typeNumber1():void {
			assertEquals(result.typeNumber1, obj.typeNumber1);
		}		
		//[Test]
		public function typeNumber2():void {
			assertEquals(result.typeNumber2, obj.typeNumber2);
		}		
		//[Test]
		public function typeString1():void {
			assertEquals(result.typeString1, obj.typeString1);
		}		
		//[Test]
		public function typeString2():void {
			assertEquals(result.typeString2, obj.typeString2);
		}		
		//[Test]
		public function typeString3():void {
			assertEquals(result.typeString3, obj.typeString3);
		}		
		//[Test]
		public function typeBoolean1():void {
			assertEquals(result.typeBoolean1, obj.typeBoolean1);
		}		
		//[Test]
		public function typeBoolean2():void {
			assertEquals(result.typeBoolean2, obj.typeBoolean2);
		}		
		//[Test]
		public function typeNull():void {
			assertEquals(result.typeNull, obj.typeNull);
		}		
		
		//[Test]
		public function typeUndefined():void {
			assertEquals(result.typeUndefined, obj.typeUndefined);
		}		
		[Test]
		public function typeDate():void {
			//assertEquals((result.typeDate as Date).getTime(), (obj.typeDate as Date).getTime());
		}
		//[Test]
		public function typeArray():void {
			assertEquals(result.typeArray, obj.typeArray);
		}
		
		//[Test]
		public function textfieldText():void {
			assertEquals(result.typeDictionary2['twoTextfields'], obj.typeDictionary2['twoTextfields']);
		}

		//[Test]
		public function textfieldText2():void {
			assertEquals(result.typeDictionary2['threeTextfields'], obj.typeDictionary2['threeTextfields']);
		}
		
		
		
	}
}
