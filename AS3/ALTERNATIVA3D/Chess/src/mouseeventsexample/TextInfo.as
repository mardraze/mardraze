package mouseeventsexample{

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	class TextInfo extends Sprite {
		private var textField:TextField;
		private var bg:Sprite;

		public function TextInfo() {
			bg = new Sprite();
			with (bg.graphics) {
				beginFill(0x000000, .75);
				drawRect(0, 0, 10, 10);
				endFill();
			}
			textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.selectable = false;
			textField.defaultTextFormat = new TextFormat("Tahoma", 10, 0xFFFFFF);
			textField.x = 5;
			textField.y = 5;
			addChild(bg);
			addChild(textField);
		}

		public function write(value:String):void {
			textField.appendText(value + "\n");
			bg.width = textField.width + 10;
			bg.height = textField.height + 10;
		}
	}
}