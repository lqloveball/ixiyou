package  
{
	import com.ixiyou.speUI.controls.MVScrollBar;
	import com.ixiyou.speUI.controls.MHScrollBar;
	import flash.display.*;
	import flash.events.*
	/**
	 * 滚动条测试
	 * @author spe
	 */
	public class VHScrollBarDemo extends Sprite
	{
		[Embed(source='../../lib/test/pic/ScrollBarTest.png')]
		private var img:Class
		private var bmp:Bitmap
		private var _mask:Shape
		public function VHScrollBarDemo() 
		{
			_mask = new Shape()
			_mask.graphics.beginFill(0)
			_mask.graphics.drawRect(0, 0, 100, 100)
			_mask.x = 100
			_mask.y = 100
			
			bmp = new img() as Bitmap
			var box:Sprite = new Sprite()
			box.addChild(bmp)
			addChild(box)
			box.mask = _mask
			
			var sl:MVScrollBar
			sl = new MVScrollBar( { x:200, y:100,coordinateBool:false} )
			addChild(sl)
			sl.content = box
			sl.setSize(100, 100)

			var sl1:MHScrollBar
			sl1 = new MHScrollBar({x:100,y:85,width:115,coordinateBool:false})
			addChild(sl1)
			sl1.content = box
			
		}
		
	}

}