package com.ixiyou.events 
{
	import flash.events.Event;
	
	/**
	 * Mtree实例对象
	 * @author magic
	 */
	public class TreeEvent extends Event 
	{
		/**开始拖动*/
		public static const STARTDRAG:String = "startDrag";
		
		/**结束拖动*/
		public static const ENDDRAG:String = "endDrag";
		
		public static const DRAGMOVE:String = "dragMove";
		
		private var _container:*;
		private var _handler:*;
		public function TreeEvent(type:String,handler:*=null,container:*=null) 
		{ 
			super(type);
			_container = container;
			_handler = handler;
		} 
		
		/**
		 * 容器
		 */
		public function get container():* { return _container; }
		
		/**
		 * 操作对象
		 */
		public function get handler():* { return _handler; }
		
	}
	
}