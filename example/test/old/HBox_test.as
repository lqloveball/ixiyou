package 
{
	
	/**
	 * 测试组件基础容器
	 * @author ...
	 */
	import flash.display.Sprite;
	import com.ixiyou.speUI.core.SpeComponent
	import com.ixiyou.speUI.core.HContainer
	import com.ixiyou.speUI.core.LayoutMode
	import com.ixiyou.speUI.containers.HBox
	public class HBox_test extends Sprite
	{
		
		public function HBox_test() 
		{
			var box:HBox = new HBox( { x:10, y:10, width:100, height:150 } )
			var a:SpeComponent = new SpeComponent( {id:"a", width:50, height:20,autoSize:true} )
			var b:SpeComponent = new SpeComponent( { id:"b", x:110, y:110, width:100, height:100 } )
			var c:SpeComponent = new SpeComponent( { id:"b", x:110, y:110, width:100, height:100 } )
			var d:Sprite = new Sprite()
			d.graphics.beginFill(0x0)
			d.graphics.drawRect(0,0,100,100)
			addChild(box)
			box.addChild(a)
			box.addChild(b)	
			box.addChild(c)	
			box.addChild(d)
			a.height =80
			//box.setLayout(LayoutMode.MIDDLE_CENTER)
			//a.autoSize=true
		}
		
	}
	
}