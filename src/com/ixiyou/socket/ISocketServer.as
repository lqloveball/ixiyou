package com.ixiyou.socket 
{
	import flash.events.IEventDispatcher;
	import flash.net.Socket;
	/**
	 * AIR SocketServer服务端接口
	 * @author spe email:md9yue@@q.com
	 */
	public interface ISocketServer extends IEventDispatcher
	{
		/**
		 * 绑定开启服务器
		 * @param	localPort 端口
		 * @param	localAddress ip
		 */
		function bind(localPort:int, localAddress:String='0.0.0.0'):void
		/**
		 * 关闭服务器
		 */
		function close():void
		/**
		 * 对客户发送消息
		 * @param	client 客户端
		 * @param	value 发送的数据
		 */
		function send(client:Socket, value:Object ):void
		/**
		 * 关闭客户端
		 * @param	client
		 */
		function closeClient(client:Socket):void 
		/**
		 * 服务器是否连接
		 */
		function get connected():Boolean
		/**
		 * 设置服务器连接数
		 */
		function listen(backlog:uint = 0):void 
		/**
		 * 端口
		 */
		function get localPort():int
		/**
		 * ip地址
		 */
		function get localAddress():String
	}
	
}