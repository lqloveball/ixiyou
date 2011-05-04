package  
{
	
	/**
	 * app核心
	 * @author ...
	 */
	import flash.events.EventDispatcher
	import flash.events.Event
	import com.ixiyou.speUI.containers.Application
	//import prevent.controller.*;
	//import prevent.view.*
	//import prevent.model.*
	public class AppBase extends EventDispatcher
	{
		private static var instance:AppBase 
		public static function getInstance():AppBase {
			if (instance == null)instance= new AppBase();
			return instance;
		}
		public var root:Application
		public function AppBase() 
		{
			/**
			 * 这里添加视觉,模型,控制代码
			 */
			trace("[App]")
			
		}
	}
	
}