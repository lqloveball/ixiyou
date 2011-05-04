package  
{
	
	/**
	 * ...
	 * @author ...
	 */
	import com.ixiyou.speUI.controls.MVSlider;
	import com.ixiyou.speUI.controls.MHSlider
	import flash.display.*
	import flash.events.*
	public class SliderDemo extends Sprite
	{
		
		public function SliderDemo() 
		{
			var sl:MHSlider=new MHSlider({x:100,y:100,value:100})
			addChild(sl)
			sl.allowTrackClick=false
			sl.liveDragging = true
			sl.setSize(300,30)
			sl.maximum = 300
			sl.minimum = 50
		
			var sl1:MVSlider = new MVSlider( { x:50, y:50, value:50 } )
			addChild(sl1)
			sl1.setSize(100,300)
		
		}
		
	}
	
}