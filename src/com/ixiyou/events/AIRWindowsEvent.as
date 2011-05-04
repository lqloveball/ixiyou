package com.ixiyou.events 
{
	import flash.display.NativeWindow;
	import flash.events.Event;
	
	/**
	 * Air的窗口管理器事件
	 * @author magic
	 */
	public class AIRWindowsEvent extends Event 
	{
		/**
		 * 添加一个窗口对象
		 */
		public static const ADD_WINDOW:String = "add_window";	
		/**
		 * 删除一个窗口对象
		 */
		public static const REMOVE_WINDOW:String = 'remove_window';
		/**
		 * 关闭所有窗口
		 */
		public static const CLOSE_ALL:String = 'Close_All';
		/**
		 * 关闭窗口
		 */
		public static const CLOSE:String = 'close';
		/**
		 * 询问是否需要关闭窗口
		 */
		public static const CLOSEQUERIST:String = 'closeQuerist';
		private var _data:Object;
		private var _window:NativeWindow
		public function AIRWindowsEvent(type:String,
			window:NativeWindow=null,
			data:Object = null,
			bubbles:Boolean = false,cancelable:Boolean = false)
		{ 
			super(type, bubbles, cancelable);
			_data = data;
			_window = window;
		} 
		
		/**
		 * 相关数据信息
		 * id：窗口在管理列表中的id号
		 * window: 窗口
		 */
		public function get data():Object { return _data; }
		
		public function get window():NativeWindow { return _window; }
	}
	
}