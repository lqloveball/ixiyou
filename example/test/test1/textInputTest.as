package  
{
	import flash.display.*;
	import com.ixiyou.speUI.controls.MTextInput
	import com.ixiyou.speUI.controls.MLabel
	/**
	 * ...
	 * @author spe
	 */
	public class textInputTest extends Sprite
	{
		private var text:MTextInput
		private var lb:MLabel
		public function textInputTest() 
		{
			text=new MTextInput({x:100,y:100})
			addChild(text)
			//text.setSize(500,300)
			var str:String = '移动到我身上看看d3dddddddd2ddddddd1dddddddddddd0我身上看看'
			var label:MLabel = new MLabel( {truncateToFit:true,toolTip:'哈哈哈wo de de',height:100,width:100,label:str, x:30, y:30,background:true,backgroundColor:0x00ff00} )
			addChild(label)
			//label.truncateToFit=false
			//label.text = "移动到我身上看看d3dddddddd2ddddddd1dddddddddddd0我身上看看"
			label.textColor = 0xff0000
			label.textSize = 12
			var d:Shape = new Shape()
			d.graphics.beginFill(0x0)
			d.graphics.drawCircle(5, 5, 5)
			label.ico = d
			trace('text:'+label.text)
			//trace('label:'+label.label)
		}
		
	}

}