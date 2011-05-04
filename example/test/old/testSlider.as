package  
{
	
	/**
	 * ...
	 * @author ...
	 */
	import com.ixiyou.speUI.controls.MVSlider;
	import com.ixiyou.speUI.controls.skins.HSliderSkin;
	import flash.display.*
	import flash.events.*
	import com.ixiyou.speUI.controls.MHSlider
	//import lib.PlaySlider;
	public class testSlider extends Sprite
	{
		
		public function testSlider() 
		{
			var sl:MHSlider=new MHSlider({x:100,y:100,value:100})
			addChild(sl)
			sl.allowTrackClick=false
			sl.liveDragging = true
			//sl.skin=new PlaySlider()
			//trace(sl.value)
			sl.maximum = 300
			//trace(sl.value)
			sl.minimum = 50
			//trace(sl.value)
			var sl1:MVSlider = new MVSlider( { x:50, y:50, value:50 } )
			addChild(sl1)
			//trace(sl.middleNum)
			//sl.skin=new HSliderSkin()
			//sl.width=200
			
		}
		
	}
	
}