package com.ixiyou.events 
{
	
	/**
	 * 组件位置发生改变时候事件
	* ...
	* @author spe
	*/
	import flash.events.Event;
	public class LocationEvent extends Event
	{
		//坐标改变
		public static const LOCATION:String = "location";
		//x坐标改变
		public static const LOCATION_X:String = "Location_x";
		//y坐标改变
		public static const LOCATION_Y:String = "Location_y";
		
		/*
		 * 改变前的UI的宽高
		 */
		public var oldx:Number;
		public var oldy:Number;
		/**
		 * 构造函
		 * @param type 事件类型
		 * @param bubbles
		 * @param cancelable
		 * @param oldx 改变之前的x
		 * @param oldy 改变之前的y
		 * @return 
		 */	
		public function LocationEvent(type:String, bubbles:Boolean = false,cancelable:Boolean = false,
								    oldx:Number = NaN, oldy:Number = NaN) 
		{
			super(type, bubbles, cancelable);

			this.oldx = oldx;
			this.oldy = oldy;
		}
		
	}
	
}