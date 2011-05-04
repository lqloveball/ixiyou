package 
{
	
	/**
	 * 测试组件基础容器
	 * @author ...
	 */
	import flash.display.Sprite;
	import com.ixiyou.speUI.core.SpeComponent
	import com.ixiyou.speUI.core.Container
	public class Container_test extends Sprite
	{
		
		public function Container_test() 
		{
			var box:Container = new Container( { x:10, y:10 } )
			var a:SpeComponent = new SpeComponent( {id:"a", width:100, height:100,autoSize:true} )
			var b:SpeComponent = new SpeComponent( { id:"b", x:110, y:110, width:100, height:100 } )
			var c:SpeComponent = new SpeComponent( { id:"c", x:101, y:12, width:50, height:40 } )
			//Sprite
			addChild(box)
			box.addChild(a)
			box.addChild(b)
			box.addChild(c)
			//a.autoSize = false
			//a.width=80
		}
		
	}
	
}