package  
{
	
	/**
	 * 测试组件基础容器
	 * @author ...
	 */
	import com.ixiyou.utils.display.DrawUtil;
	import flash.display.Sprite;
	import com.ixiyou.speUI.core.SpeComponent
	import com.ixiyou.speUI.core.HContainer
	import com.ixiyou.speUI.core.LayoutMode
	public class HContainer_test extends Sprite
	{
		
		public function HContainer_test() 
		{
			var box:HContainer = new HContainer( { x:10, y:10 } )
			var a:SpeComponent = new SpeComponent( {id:"a", width:50, height:20,autoSize:true} )
			var b:SpeComponent = new SpeComponent( {id:"b",x:110,y:110,width:100, height:100 } )
			//var a:Sprite = new Sprite()
			//DrawUtil.drawRect_beginFill(a.graphics)
			//var b:Sprite = new Sprite()
			//DrawUtil.drawRect_beginFill(b.graphics,0x00ff00,1,0,0,100,20)
			addChild(box)
			box.addChild(b)
			box.addChild(a)
			
			//a.height =80
			box.setLayout(LayoutMode.TOP_LEFT)
			//a.autoSize=true
		}
		
	}
	
}