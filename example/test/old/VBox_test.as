package 
{
	
	/**
	 * 测试组件基础容器
	 * @author ...
	 */
	import flash.display.Sprite;
	import com.ixiyou.speUI.core.SpeComponent
	import com.ixiyou.speUI.core.VContainer
	import com.ixiyou.speUI.core.LayoutMode
	import com.ixiyou.speUI.containers.VBox
	public class VBox_test extends Sprite
	{
		
		public function VBox_test() 
		{
			var box:VBox = new VBox( { x:10, y:10, width:80, height:150 } )
			box.verticalGap=20
			var a:SpeComponent = new SpeComponent( {id:"a", width:40, height:50} )
			var b:SpeComponent = new SpeComponent( {id:"b",x:110,y:110,width:100, height:100 } )
			addChild(box)
			//a.autoSize = false
			box.addChild(a)
			box.addChild(b)	
			//a.height =80
			box.setLayout(LayoutMode.LEFT_MIDDLE)
			//a.autoSize=true
		}
		
	}
	
}