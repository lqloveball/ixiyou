package com.ixiyou.events 
{
	import flash.events.Event;
	
	/**
	 * 带数据的事件
	 * @author spe
	 */
	public class DataSpeEvent extends Event
	{
		public static const ADD:String = 'add';
		public static const REMOVE:String = 'remove';
		public static const ADDALL:String = 'add_All';
		public static const REMOVEALL:String = 'remove_All';
		
		public var data:Object;
		public function DataSpeEvent(type:String,data:Object=null, bubbles:Boolean = false,cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
	}

}