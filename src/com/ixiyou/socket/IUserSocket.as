package com.ixiyou.socket 
{
	import flash.net.Socket
	import com.ixiyou.socket.Client
	/**
	 * 客户端用户模型接口
	 * @author spe email:md9yue@@q.com
	 */
	public interface IUserSocket 
	{
		 /**
		  * 用户ID
		  */
		 function set id(value:String):void 
		 function get id():String
		/**
		 * 用户所使用 socket对象
		 */
		 function set socket(value:Socket):void 
		 function get socket():Socket
		/**
		 * 用户的客户端对象
		 */
		 function set client(value:Client):void 
		 function get client():Client
	}
	
}