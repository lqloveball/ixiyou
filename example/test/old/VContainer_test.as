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
	public class VContainer_test extends Sprite
	{
		
		public function VContainer_test() 
		{
			var box:VContainer = new VContainer( { x:10, y:10 } )
			var a:SpeComponent = new SpeComponent( {id:"a", width:40, height:50,autoSize:true} )
			var b:SpeComponent = new SpeComponent( {id:"b",x:110,y:110,width:100, height:100 } )
			addChild(box)
			//a.autoSize = false
			box.addChild(a)
			box.addChild(b)	
			for (var i:int = 0; i < 15; i++) 
			{
				var item:SpeComponent = new SpeComponent( {id:"b",x:110,y:110,width:100, height:Math.random()*100+50 } )
				box.addChild(item)	
			}
			//a.height =80
			//box.setLayout(LayoutMode.TOP_LEFT)
			//a.autoSize=true
		}
		
	}
	
}