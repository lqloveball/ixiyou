package com.ixiyou.managers.html 
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 用于处理和JS的交互
	 * @author flashyiyi
	 * @author http://code.google.com/p/ghostcat/
	 * @author spe
	 */
	public class JSBridge
	{
		
		private static var eventDispatcher:EventDispatcher;
		
		/**
		 * 设置一个对象来接受JS发送给FLASH的事件，JS端可以用如下函数创建一个FLASH的事件并发送。
		 * dispatchEvent("jscall","flash.events.Event","{data:123}")
		 * 
		 * @param client	接受事件的监听器
		 * 
		 */
		public static function setDispatcher(client:EventDispatcher):void
		{
			if (!ExternalInterface.available)
				return;
			eventDispatcher = client;
			ExternalInterface.addCallback("dispatchEvent",jsHandler)
		}
		
		private static function jsHandler(eventName:String,eventType:String,parms:String):void
		{
			if (!eventType || eventType == "")
				eventType = "flash.events.Event";
			else if (eventType.indexOf(".") == -1)
				eventType = "flash.events." + eventType;
			
			var cls:Class = getDefinitionByName(eventType) as Class;
			var event:Event = new cls(eventName);
			if (parms)
			{
				var a1:Array;
				a1 = parms.match(/\{.*\}/);
				if (a1)
					parms = (a1[0] as String).substring(1,a1[0].length - 1);
				
				a1 = parms.split(",");
				var o:Object = new Object();
				for (var i:int = 0; i < a1.length;i++)
				{
					var s:String = a1[i] as String;
					var a2:Array = s.split(":");
					if (a2.length == 2)
						event[(a2[0] as String).replace(/\s/g,"")] = a2[1];
				}
			}
			eventDispatcher.dispatchEvent(event);
		}
		
	}

}