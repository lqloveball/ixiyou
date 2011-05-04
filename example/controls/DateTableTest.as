package  
{
	import com.ixiyou.events.SelectEvent;
	import com.ixiyou.speUI.controls.MDateChooser;
	import com.ixiyou.speUI.controls.MDateTable;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	
	/**
	 * ...
	 * @author magic
	 */
	public class DateTableTest extends Sprite
	{
		private var mdc:MDateChooser
		
		public function DateTableTest() 
		{
			Echo.setStage(stage);
			mdc = new MDateChooser( { x:100, y:100 } );
			mdc.setSize(250, 150);
			addChild(mdc);
		}
		private function onSelect(se:SelectEvent):void {
			trace(se.data);
		}
	}
}