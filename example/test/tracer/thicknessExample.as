package
{
    import flash.display.Sprite;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.AntiAliasType;
    import flash.text.GridFitType;
    import flash.text.TextFormat;

    public class thicknessExample extends Sprite
    {
        public function thicknessExample()
        {
			var format1:TextFormat = new TextFormat();
			format1.font="宋体";
			format1.size=24;
			var lTxt:String = "The quick brown fox中文";

			var tf1:TextField=createCustomTextField(0,lTxt,format1,-200);
			var tf2:TextField=createCustomTextField(30,lTxt,format1,0);
			var tf3:TextField = createCustomTextField(60, lTxt, format1, 200);
        }

        private function createCustomTextField(y:Number,fldTxt:String,format:TextFormat,fldThickness:Number):TextField 
		   {
				var result:TextField = new TextField();
				result.y=y;
				result.text=fldTxt;
				//result.embedFonts=true;
				result.autoSize=TextFieldAutoSize.LEFT;
				result.antiAliasType=AntiAliasType.NORMAL;
				result.gridFitType=GridFitType.SUBPIXEL;
				result.thickness=fldThickness;
				result.setTextFormat(format);
				addChild(result);
				return result;
			}
    }
}