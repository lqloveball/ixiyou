package com.ixiyou.events 
{
	import flash.events.Event;
	
	/**
	 * QueueLoad的事件对象
	 * @author magic
	 */
	public class QueueLoadEvent extends Event 
	{
		/**
		 * 所有队列加载完毕
		 */
		public static const COMPLETE:String = "complete";
		/**
		 * 成功加载一个文件
		 */
		public static const LOADED:String = "loaded";
		/**
		 * 当前文件加载进度
		 */
		public static const PROGRESS:String = "progress";
		
		/**
		 * 开始队列加载
		 */
		public static const START:String = "start";
		
		/**
		 * 加载新文件
		 */
		public static const LOAD:String = "load";
		
		
		private var _info:Object;
		
		public function QueueLoadEvent(type:String,info:Object=null) 
		{ 
			super(type);
			_info = info;
		} 
		
		/**
		 * 当前文件加载信息
		 * id 		在QueueLoad中唯一标识
		 * url		文件地址
		 * request	加载时使用的URLRequest实例
		 * type	加载类型
		 * bytesTotal	文件总字节数
		 * bytesLoaded	文件已经被加载的字节数
		 * data		被加载的数据
		 */
		public function get info():Object { return _info; }
	}
	
}