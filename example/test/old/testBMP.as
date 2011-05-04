package  
{
	
	
	/**
	 * ...
	 * @author ...
	 */
	import flash.display.*;
	import com.ixiyou.utils.display.BitmapDataUtils
	import flash.geom.Rectangle;
	public class testBMP extends Sprite
	{
		
		public function testBMP() 
		{
			[Embed(source = '../../lib/skins/Button_downState.png')]
			var temp:Class
			var d:Bitmap =new temp() as Bitmap
			addChild(d)
			trace(BitmapDataUtils.getBitmapDataBySize(d,new Rectangle(0,0,10,10)))
		}
		
	}

}