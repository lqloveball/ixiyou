package  
{
	import flash.display.Sprite;
	import com.ixiyou.speUI.controls.*
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import com.ixiyou.managers.html.HtmlManager
	/**
	 * 测试与浏览器的交互
	 * @author spe
	 */
	public class HtmlManagerTest extends Sprite
	{
		private var output:TextField=new TextField()
		public function HtmlManagerTest() 
		{
			//创建调试文本输出框
			output.width = 600
			output.height=200
			addChild(output)
			var textSl:MTextVScrollBar = new MTextVScrollBar({height:200,x:600})
			addChild(textSl)
			textSl.content = output
			//调试按钮
			var btn:MButton
			//获取网页地址
			btn = new MButton( { y:10, x:650, width:80, label:'获取页面地址' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK, function():void {
				output.appendText(HtmlManager.instance.url)
				}
			)
		}
		
	}

}