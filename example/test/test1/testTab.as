package  
{
	/**
	 * ...
	 * @author spe
	 */
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite
	import flash.events.*
	import com.ixiyou.speUI.collections.TabBox;
	import com.ixiyou.speUI.containers.MTabBox
	public class testTab extends Sprite
	{
		[Embed(source = '../../lib/skins/VScrollBarSkin/test.png')]
		private var cs:Class
		private var tab:MTabBox
		public function testTab() 
		{
			var bmp:Bitmap = new cs() as Bitmap
			var sp:Shape = new Shape()
			sp.graphics.beginFill(0x0)
			sp.graphics.drawCircle(100,100,100)
			//addChild(bmp)
			tab = new MTabBox( { x:10, y:10 ,width:100,height:100} )
			addChild(tab)
			tab.push('name1', bmp)
			tab.push('name2',sp)
			tab.showTab('name1')
			tab.showTab('name2')
			tab.showTab('name1')
			trace(tab.tabList)
		}
		
	}

}