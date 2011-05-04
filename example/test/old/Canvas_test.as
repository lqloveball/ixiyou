package  
{
	
	/**
	 * 测试组件基础容器
	 * @author ...
	 */
	import flash.display.Sprite;
	import com.ixiyou.speUI.core.*
	import com.ixiyou.speUI.containers.Canvas
	public class Canvas_test extends Sprite
	{
		
		public function Canvas_test() 
		{
			var box:Canvas = new Canvas( { x:10, y:10 , width:400, height:400 } )
			//box.graphics.beginFill(0x0, .2)
			//box.graphics.drawRect(0,0,400,400)
			var a:SpeComponent = new SpeComponent( {id:"a", width:100, height:100,autoSize:true} )
			var b:SpeComponent = new SpeComponent( { id:"b", x:30, y:30, width:100, height:100 } )
			var c:SpeComponent = new SpeComponent( { id:"c", x:101, y:12, width:50, height:40 } )
			b.borderMetrics.setEdgeMetrics(5,100,100,5)
			addChild(box)
			//box.addChild(a)
			box.addChild(b)
			b.pLayout.layout = LayoutMode.MIDDLE
			b.pLayout.layout = LayoutMode.CENTER
			box.setSize(120, 120)
			//b.pLayout.layout = LayoutMode.TOP
			//b.pLayout.layout = LayoutMode.ABSOLUTE
			//b.pLayout.layout = LayoutMode.BOTTOM
			//b.pLayout.layout = LayoutMode.TOP
			//b.pLayout.layout = LayoutMode.RIGHT
			//b.pLayout.layout = LayoutMode.MIDDLE
			//b.pLayout.layout = LayoutMode.CENTER
			//trace(b.pLayout.layout)
			//box.addChild(c)
			//box.width=200
			//a.autoSize = false
			//a.width=80

		}
		
	}
	
}