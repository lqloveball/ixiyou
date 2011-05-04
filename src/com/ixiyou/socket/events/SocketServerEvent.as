package com.ixiyou.socket.events 
{
	import flash.events.*;  
	import flash.net.Socket;
	/**
	 * 服务器端事件
	 * @author spe email:md9yue@@q.com
	 */
	public class SocketServerEvent  extends Event
	{  
		/**
		* 客户端关闭
		*/
		public static const CLOSE:String = Event.CLOSE;  
		/**
		 * 服务器段关闭客户端
		 */
		public static const SERVERCLOSECLIENT:String = 'ServerCloseClient' 
		/**
		 * 服务器关闭
		 */
		public static const SERVERCLOSE:String = 'ServerClose'  
		/**
		 * 服务器开启
		 */
		public static const SERVEROPEN:String = 'ServerOpen'  
		/**
		 * 客户端连接上
		 */
        public static const CONNECT:String = Event.CONNECT;  
		/**
		 * 接受客户端消息解码错误
		 */
		public static const DECODE_ERROR:String = "decode_error";  
		/**
		 * 接收客户端数据
		 */
        public static const RECEIVED:String = "received";  
		/**
		 * 发送消息给客户端
		 */
		public static const SENDTOCLIENT:String = "sendToClient";  
		/**
		 * 发送消息给客户端错误
		 */
		public static const SENDTOCLIENT_ERROR:String = "SendToClient_Error";  
		/**
		 * 发送消息给客户端 出现无效客户端
		 */
		public static const CLIENTINVALID_ERROR:String = "ClientInvalid_Error";  
		/**
		 * 错误连接  关闭客户端时候出错
		 */
		public static const IO_ERROR:String = IOErrorEvent.IO_ERROR; 
		/**
		 * 服务器端开启错误
		 */
		public static const SERVEROPEN_ERROR:String = 'ServerOpen_Error'; 
		
		private var _socket:Socket
		private var _remoteAddress:String
		private var _remotePort:uint
		private var _data:Object=null
		public function SocketServerEvent(type:String, _socket:Socket=null,_remotePort:uint=0,_remoteAddress:String='0.0.0.0')
		{
			 super(type, true);  
			 this._socket = _socket
			 this._remoteAddress=_remoteAddress
			 this._remotePort=_remotePort
		}
		override public function toString():String {  
            return formatToString("SocketServerEvent", "type", 'bubbles',"socket", "remotePort", "data");  
        }  
		public function get socket():Socket { return _socket; }
		
		public function get remoteAddress():String { return _remoteAddress; }
		
		public function get remotePort():uint { return _remotePort; }
		
		public function get data():Object { return _data; }
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		
	}

}