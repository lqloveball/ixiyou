package  
{
	import com.ixiyou.speUI.containers.Application;
	import com.ixiyou.speUI.core.SpeComponent;
	import flash.events.Event;
	
	/**
	 * 测试
	 * @author spe
	 */
	public class ApplicationTest extends Application
	{
		private var test:SpeComponent
		public function ApplicationTest() 
		{
			test = new SpeComponent()
			test.autoSize=true
			addChild(test)
			//test.addEventListener(Event.RESIZE, function():void { trace('----------') } )
		}
		override public function upSize():void {
			if (test) {
				trace('this',width,height)
			}
			//this.graphics.beginFill(0)
			//this.graphics.drawRect(0,0,this.width,this.height)
		}
	}

}