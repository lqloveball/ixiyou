package  
{
	
	/**
	 * 测试Label组件
	 * @author dd
	 */
	import flash.display.Sprite;
	import com.ixiyou.speUI.controls.MLabel
	import flash.display.Shape
	public class Label_test extends Sprite
	{
		
		public function Label_test() 
		{	var str:String = '11111s s23dfsd3dfdfsdf,3242我的方式我的方式67890123456789'
			var label:MLabel = new MLabel( {truncateToFit:true,toolTip:'哈哈哈wo de de',width:100,label:str, x:30, y:30,background:true} )
			addChild(label)
			label.truncateToFit=false
			//label.text = "移动到我身上看看d3dddddddd2ddddddd1dddddddddddd0我身上看看"
			label.textColor = 0xff0000
			label.textSize = 12
			var d:Shape = new Shape()
			d.graphics.beginFill(0x0)
			d.graphics.drawCircle(5, 5, 5)
			label.ico = d
			//trace('text:'+label.text)
			//trace('label:'+label.label)
			//label.ico = null
		
		}
	}
	
}