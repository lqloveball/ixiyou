package com.ixiyou.FMS.events
{
	
	
	/**
	 * FMS
	 * @author spe
	 */
	import flash.events.Event
	public class FmsEvent extends Event
	{
		//开始连接
		public static var LINK_START:String = "linkStart"
		//连接成功
		public static var LINK_SUCCESS:String = "Success"
		//网络错未能连接上
		public static var LINK_FAILED:String = "Failed"
		//未登录过后的断开
		public static var LINK_CLOSENO:String = "CloseNo"
		//曾经登录过后的断开
		public static var LINK_CLOSED:String = "Closed"
		//服务器拒绝连接
		public static var LINK_REJECTED:String = "Rejected"
		//服务器拒绝连接
		public static var LINK_REJECTED_MSG:String = "Rejected_msg"
		//执行重新连接命令
		public static var LINK_RETRY:String = "Retry"
		//close命令执行的关闭
		public static var LINK_CLOSE:String="Close"
		//服务器拒绝连接 断开的连接
		public static var LINK_REJECTED_CLOSE:String = "Rejected_Close"
		/**
		 *数据 
		 */		
		public var data:*
		/**
		 * 构造函
		 * @param	type 事件类型
		 * @param	data 相关数据
		 * @param	bubbles
		 * @param	cancelable
		 */
		
		public function FmsEvent(type:String, data:* = null,bubbles:Boolean = false,cancelable:Boolean = false )
		{
			super(type,bubbles, cancelable);
			this.data = data;
		}
	}

}