package  
{
	/**
	 * 自加载模版
	 * @author spe
	 */
	
	import com.ixiyou.speUI.mcontrols.MProgressBar;
	import flash.display.*
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.getDefinitionByName;
	[Frame(factoryClass="Main",'start')] 
	public class RootLoader extends MovieClip
	{
		//protected var loader:MProgressBar=new MProgressBar()
		public function RootLoader() 
		{
			//loader.target = loaderInfo
			//stage.addChild(loader)
			//addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
		}
		private function checkFrame(e:Event):void 
		{
			
			if (currentFrame == totalFrames) 
			{
				removeEventListener(Event.ENTER_FRAME, checkFrame);
				startup();
			}
		}
		private function progress(e:ProgressEvent):void 
		{
			trace(e)
			// update loader
		}
		
		/**
		 * 完成载入，实例化主场景时执行的方法。可以重写这个方法以显示一段进入主场景的动画。
		 * 
		 */		
		private function startup():void 
		{
			trace('over')
			// hide loader
			stop();
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			var mainClass:Class = getDefinitionByName("Main") as Class;
			stage.addChild(new mainClass() as DisplayObject);
			stage.removeChild(this)
		}
	}
}