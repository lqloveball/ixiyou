package  
{
	import com.ixiyou.speUI.containers.TabNavigatorBox;
	import flash.display.Sprite;
	
	
	/**
	 * 滑门
	 * @author spe
	 */
	public class TabNavigatorBoxDemo extends Sprite
	{
		private var tabNav:TabNavigatorBox
		public function TabNavigatorBoxDemo() 
		{
			
			tabNav = new TabNavigatorBox()
			addChild(tabNav)
			for (var i:int = 0; i < 5; i++) 
			{
				var child:Sprite = new Sprite()
				child.graphics.beginFill(Math.random()*0xffffff)
				child.graphics.drawRect(0,0,1000,1000)
				tabNav.addTab('label_' + i,child)
			}
			tabNav.setTabByIndex(2)
		}
		
	}

}