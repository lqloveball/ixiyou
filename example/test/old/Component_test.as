package demo 
{
	
	/**
	 * 测试组件基类
	 * @author ...
	 */
	import flash.display.Sprite;
	import com.ixiyou.speUI.core.SpeComponent
	public class Component_test extends Sprite
	{
		
		public function Component_test() 
		{
			var a:SpeComponent = new SpeComponent( { width:100, height:100 ,autoSize:true} )
			var b:SpeComponent = new SpeComponent( { width:100, height:100 } )
			var c:SpeComponent = new SpeComponent( { width:100, height:100 } )
			a.setSize(20, 20)
			c.setLocation(300,300)
			addChild(c)
			addChild(a)
			addChild(b)
			c.addChild(a)
			b.addChild(a)
			//b.setSize(50, 50)
			b.setSize(60, 50)
			c.setSize(60,50)
			b.setSize(30, 50)
			c.setSize(70,50)
			
		}
		
	}
	
}