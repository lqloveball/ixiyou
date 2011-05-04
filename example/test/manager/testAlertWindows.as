package  
{
	import com.ixiyou.managers.AlertManager;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.*
	import com.ixiyou.speUI.controls.AlertWindow
	import com.ixiyou.speUI.containers.Application

	/**
	 * ...
	 * @author ...
	 */
	public class testAlertWindows extends Application
	{
		[Embed(source = '../../../lib/test/pic/ScrollBarTest.png')]
		private var bmp:Class
		public function testAlertWindows() 
		{
			var temp:Bitmap = new  bmp() as Bitmap
			addChild(temp)
			var art:AlertWindow = new AlertWindow()
			AlertManager.getInstance().stage = stage
			AlertManager.getInstance().push(art, true,true,0xffff00,.5)
			//AlertManager.getInstance().push(new AlertWindow(), true, true)
			//AlertManager.getInstance().push(new AlertWindow(), true, true)
			//AlertManager.getInstance().clear()
		}
		
	}

}