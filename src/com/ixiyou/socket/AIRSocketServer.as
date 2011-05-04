package com.ixiyou.socket 
{
	
	import flash.events.EventDispatcher;
	import flash.events.*
	import flash.net.* 
	import flash.utils.ByteArray;
	import com.ixiyou.socket.events.SocketServerEvent
	//不支持socket服务
	[Event(name = 'ErrorSupported', type = "flash.events.Event")]
	//客户端关闭
	[Event(name = 'close', type = "com.ixiyou.socket.events.SocketServerEvent")]
	//服务器段关闭客户端
	[Event(name = 'ServerCloseClient', type = "com.ixiyou.socket.events.SocketServerEvent")]
	//服务器关闭
	[Event(name = 'ServerClose', type = "com.ixiyou.socket.events.SocketServerEvent")]
	//服务器开启
	[Event(name = 'ServerOpen', type = "com.ixiyou.socket.events.SocketServerEvent")]
	//客户端连接上
	[Event(name = 'connect', type = "com.ixiyou.socket.events.SocketServerEvent")]
	// 解码错误
	[Event(name = 'decode_error', type = "com.ixiyou.socket.events.SocketServerEvent")]
	//接收客户端数据
	[Event(name = 'received', type = "com.ixiyou.socket.events.SocketServerEvent")]
	//发送消息给客户端
	[Event(name = 'sendToClient', type = "com.ixiyou.socket.events.SocketServerEvent")]
	//发送消息给客户端错误
	[Event(name = 'SendToClient_Error', type = "com.ixiyou.socket.events.SocketServerEvent")]
	//客户端 无效
	[Event(name = 'ClientInvalid_Error', type = "com.ixiyou.socket.events.SocketServerEvent")]
	//错误连接 关闭客户端时候出错
	[Event(name = 'ioError', type = "com.ixiyou.socket.events.SocketServerEvent")]

	/**
	 * AIR SocketServer服务端
	 * 
	 * 例子
	 * 
	 	import com.ixiyou.socket.AIRSocketServer;
		import com.ixiyou.socket.ISocketServer;
		import com.ixiyou.socket.events.SocketServerEvent;
		socketServer=new AIRSocketServer()
		
		socketServer.addEventListener(SocketServerEvent.SERVEROPEN,serverOpen)
		
		socketServer.addEventListener(SocketServerEvent.SERVEROPEN_ERROR,serverOpen_Error)
		socketServer.addEventListener(SocketServerEvent.SERVERCLOSE,serverClose)
		socketServer.addEventListener(SocketServerEvent.SERVERCLOSECLIENT,serverCloseClient)
		socketServer.addEventListener(SocketServerEvent.CLOSE,clientClose)
		socketServer.addEventListener(SocketServerEvent.CONNECT,clientConnect)
		socketServer.addEventListener(SocketServerEvent.RECEIVED,clientReceived)
		socketServer.addEventListener(SocketServerEvent.DECODE_ERROR,clientDecode_error)
		socketServer.addEventListener(SocketServerEvent.SENDTOCLIENT,sendToClient)
		socketServer.addEventListener(SocketServerEvent.SENDTOCLIENT_ERROR,sendToClient_Error)
		socketServer.addEventListener(SocketServerEvent.CLIENTINVALID_ERROR,clientInvalid_Error)
		socketServer.addEventListener(SocketServerEvent.IO_ERROR,clientClose_Error)
		socketServer.bind(1300)

	 	//服务器开启
		private function serverOpen(e:SocketServerEvent):void{}
		//服务器开启错误
		private function serverOpen_Error(e:SocketServerEvent):void{}
		//服务器关闭
		private function serverClose(e:SocketServerEvent):void{}
		//服务器段关闭客户端
		private function serverCloseClient(e:SocketServerEvent):void{}
		//客户端关闭
		private function clientClose(e:SocketServerEvent):void{}
		//客户端连接上
		private function clientConnect(e:SocketServerEvent):void{}
		//接收客户端数据
		private function clientReceived(e:SocketServerEvent):void{}
		//接受客户端消息解码错误
		private function clientDecode_error(e:SocketServerEvent):void{}
		//发送消息给客户端
		private function sendToClient(e:SocketServerEvent):void{}
		//发送消息给客户端错误
		private function sendToClient_Error(e:SocketServerEvent):void{}
		//发送消息给客户端 出现无效客户端
		private function clientInvalid_Error(e:SocketServerEvent):void{}
		//错误连接  关闭客户端时候出错
		private function clientClose_Error(e:SocketServerEvent):void{}
		
		
	 * @author spe email:md9yue@@q.com
	 */
	public class AIRSocketServer extends EventDispatcher  implements ISocketServer
	{
		private var _serverSocket:ServerSocket
		private var _connected:Boolean=false;
		private var _listLength:uint=0;
		public function AIRSocketServer() 
		{
		}
		/**
		 * 绑定开启服务器
		 * @param	localPort 端口
		 * @param	localAddress ip
		 */
		public function bind(localPort:int, localAddress:String='0.0.0.0'):void {
			var event:SocketServerEvent 
			if (!ServerSocket.isSupported) {
				event =new SocketServerEvent(SocketServerEvent.SERVEROPEN_ERROR,null,localPort,localAddress)
				dispatchEvent(event)
				return 
			}
			if (!serverSocket) {
				_serverSocket = new ServerSocket();
				_connected=false
			}
			else if(serverSocket) 
            {
                if(serverSocket.bound)serverSocket.close();
				serverSocket.removeEventListener( ServerSocketConnectEvent.CONNECT, onConnect );
                _serverSocket = new ServerSocket();
				_connected=false
            }
			try{ 
				serverSocket.bind(localPort,localAddress);
	            serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT,onConnect);
				listen(listLength)
				_connected=true
				 event = new SocketServerEvent(SocketServerEvent.SERVEROPEN)
				dispatchEvent(event)
			}catch (error:Error) {  
				trace(error)
				event =new SocketServerEvent(SocketServerEvent.SERVEROPEN_ERROR,null,localPort,localAddress)
				dispatchEvent(event)
			} 
		}
		/**
		 * 检测客户端连接
		 * @param	e
		 */
		private function onConnect(e:ServerSocketConnectEvent):void 
		{
			var client:Socket
            client = e.socket as Socket;
            client.addEventListener( Event.CLOSE,onClientSocketClose);
			client.addEventListener( ProgressEvent.SOCKET_DATA, onClientSocketData );
			var event:SocketServerEvent = new SocketServerEvent(SocketServerEvent.CONNECT,client,client.remotePort,client.remoteAddress)
			dispatchEvent(event)
			
		}
		/**
		 * 接收客户发送消息
		 * @param	e
		 */
		private function onClientSocketData(e:ProgressEvent):void 
		{
			var client:Socket=e.target as Socket
            var bytes:ByteArray = new ByteArray();
			var event:SocketServerEvent
            client.readBytes(bytes, 0, client.bytesAvailable);
			try{                  
                bytes.uncompress();  
				event = new SocketServerEvent(SocketServerEvent.RECEIVED,client,client.remotePort,client.remoteAddress)
				event.data=bytes
				dispatchEvent(event)
                //this.dispatchEvent(new BaseSocketEvent(BaseSocketEvent.RECEIVED, bytes.readObject()));  
            }catch (error:Error) {  
				event = new SocketServerEvent(SocketServerEvent.DECODE_ERROR,client,client.remotePort,client.remoteAddress)
				dispatchEvent(event)
            }  
			
		}
		/**
		 * 检测客户关闭
		 * @param	e
		 */
		private function onClientSocketClose(e:Event):void 
		{
			var client:Socket = e.target as Socket;
			client.removeEventListener( Event.CLOSE,onClientSocketClose);
			client.removeEventListener( ProgressEvent.SOCKET_DATA, onClientSocketData );
			var event:SocketServerEvent = new SocketServerEvent(SocketServerEvent.CLOSE,client,client.remotePort,client.remoteAddress)
			dispatchEvent(event)
		}
		/**
		 * 关闭服务器
		 */
		public function close():void {
			if (serverSocket) {
				serverSocket.close()
				_connected=false
				var event:SocketServerEvent = new SocketServerEvent(SocketServerEvent.SERVERCLOSE,null)
				dispatchEvent(event)
			}
		}
		/**
		 * 对客户发送消息
		 * @param	client 客户端
		 * @param	value 发送的数据
		 */
		public function send(client:Socket, value:Object):void {
			var event:SocketServerEvent
			 try
            {
                if( client != null && client.connected)
                {
					var bytes:ByteArray = new ByteArray();  
					bytes.writeObject(value);  
					bytes.compress();  
					client.writeBytes(bytes);  
					client.flush();  
					event = new SocketServerEvent(SocketServerEvent.SENDTOCLIENT, client, client.remotePort, client.remoteAddress)
					event.data=value
					dispatchEvent(event)
                }
                else {
					if (client) {
						event = new SocketServerEvent(SocketServerEvent.CLIENTINVALID_ERROR, client,client.remotePort,client.remoteAddress)
						event.data=value
						dispatchEvent(event)
						trace( "Error：存在无效连接客户端，并给其发送消息");
					}else {
						//trace( "没有客户端存在");
					}
					
				}
            }
            catch ( error:Error )
            {
				//var event:SocketServerEvent 
				if (client) event = new SocketServerEvent(SocketServerEvent.SENDTOCLIENT_ERROR, client, client.remotePort, client.remoteAddress)
				else event = new SocketServerEvent(SocketServerEvent.SENDTOCLIENT_ERROR)
				dispatchEvent(event)
            }
		}
		/**
		 * 关闭客户端
		 * @param	client
		 */
		public function closeClient(client:Socket):void {
			var event:SocketServerEvent
			try
            {
                if( client != null && client.connected )
                {
					client.close()
					client.removeEventListener( Event.CLOSE,onClientSocketClose);
					client.removeEventListener( ProgressEvent.SOCKET_DATA, onClientSocketData );
					event = new SocketServerEvent(SocketServerEvent.SERVERCLOSECLIENT,client,client.remotePort,client.remoteAddress)
					dispatchEvent(event)
				}
			}catch
			( error:Error )
            {
				
				if (client) event = new SocketServerEvent(SocketServerEvent.IO_ERROR, client)
				else event = new SocketServerEvent(SocketServerEvent.IO_ERROR)
				event.data=error
				dispatchEvent(event)
            }
		}
		/**
		 * 服务器是否连接
		 */
		public function get connected():Boolean{return _connected}
		/**
		 * 设置服务器连接数
		 * @param	backlog
		 */
		public function listen(backlog:uint = 0):void {
			if (serverSocket) {
				_listLength=backlog
				serverSocket.listen(listLength)
			}
		}
		/**
		 * 端口
		 */
		public function get localPort():int{return serverSocket.localPort}
		/**
		 * ip地址
		 */
		public function get localAddress():String {return serverSocket.localAddress}
		/**
		 * socket服务端
		*/
		public function get serverSocket():ServerSocket { return _serverSocket; }
		
		public function get listLength():uint { return _listLength; }
		
		
	}

}