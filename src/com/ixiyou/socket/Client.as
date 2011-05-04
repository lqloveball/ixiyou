package com.ixiyou.socket
{
	import flash.events.*;
	import flash.net.*
	import flash.utils.*;
	/**
	 * 客户端
	 * @author spe email:md9yue@@q.com
	 */
	public class Client extends EventDispatcher 
	{
		private var _socket:Socket;
		private var _userData:IUserSocket
		//创建这个客户端时间
		private var _birthTime:uint
		private var _activation:Boolean = false
		//第几个连接上服务器的客户端
		private var _atListNumber:uint=0
		/**
		 * 构造函数
		 * @param	socket
		 */
		public function Client(socket:Socket,num:uint) 
		{
			this.socket = socket
			_atListNumber=num
			_birthTime=getTimer()
		}
		/**
		 * 客户端的连接的socket对象
		 */
		public function get socket():Socket { return _socket; }
		public function set socket(value:Socket):void 
		{
			if(_socket == value)return 
			_socket = value;
		}
		/**
		 * 客户端是否激活
		 */
		public function get activation():Boolean { return _activation; }
		
		public function set activation(value:Boolean):void 
		{
			_activation = value;
		}
		/**
		 * 客户端连接的用户数据的id
		 * 如果是空说明用户数据还未绑定
		 */
		public function get id():String {
			if(userData)return userData.id;
			else return ''
		}
		
		/**
		 * 用户数据 绑定用户数据
		 */
		public function get userData():IUserSocket { return _userData; }
		public function set userData(value:IUserSocket):void 
		{
			if (!userData) {
				_userData = value;
				_userData.socket = socket
				_userData.client=this
			}
		}
		/**
		 * 这客户端对象创建时间
		 */
		public function get birthTime():uint { return _birthTime; }
		/**
		 * 第几个连接上来的
		 */
		public function get atListNumber():uint { return _atListNumber; }
		/**
		 * 摧毁这个客户端
		 */
		public function destroy():void {
			
		}
		
		
	}

}