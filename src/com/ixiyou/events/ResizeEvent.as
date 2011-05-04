package com.ixiyou.events
{
	
	/**
	* 组件大小发生变化时候抛出事件
	* @author spe
	*/
	import flash.events.Event;
	public class ResizeEvent extends Event
	{
		//宽高改变
		public static const RESIZE:String = "Resize";
		//宽的改变
		public static const WRESIZE:String = "WResize";
		//高的改变
		public static const HRESIZE:String = "HResize";
		/*
		 * 改变前的UI的宽高
		 */
		public var oldHeight:Number;
		public var oldWidth:Number;
		/**
		 * 构造函
		 * @param type 事件类型
		 * @param bubbles
		 * @param cancelable
		 * @param oldWidth 改变之前的宽
		 * @param oldHeight 改变之前的高
		 * @return 
		 */	
		public function ResizeEvent(type:String, bubbles:Boolean = false,cancelable:Boolean = false,
								    oldWidth:Number = NaN, oldHeight:Number = NaN)
		{
			super(type, bubbles, cancelable);

			this.oldWidth = oldWidth;
			this.oldHeight = oldHeight;
		}
	}
	
}