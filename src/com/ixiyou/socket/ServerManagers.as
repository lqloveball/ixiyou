package com.ixiyou.socket 
{
	import flash.net.ServerSocket
	import flash.events.EventDispatcher;
	import flash.net.Socket
	import flash.utils.ByteArray
	import com.ixiyou.socket.AIRSocketServer;
	import com.ixiyou.socket.ISocketServer;
	import com.ixiyou.socket.events.SocketServerEvent;
	/**
	 * 服务器端管理
	 * 
	 * 可以参考这个进行游戏服务器端方面的扩展
	 * @author spe email:md9yue@@q.com
	 */
	public class ServerManagers extends EventDispatcher
	{
		private var _server:AIRSocketServer
		private var _clientList:ClientList
		public function ServerManagers() 
		{
			_server = new AIRSocketServer()
			_clientList = new ClientList()
			
			server.addEventListener(SocketServerEvent.SERVEROPEN,serverOpen)
			server.addEventListener(SocketServerEvent.SERVEROPEN_ERROR,serverOpen_Error)
			server.addEventListener(SocketServerEvent.SERVERCLOSE,serverClose)
			server.addEventListener(SocketServerEvent.SERVERCLOSECLIENT,serverCloseClient)
			server.addEventListener(SocketServerEvent.CLOSE,clientClose)
			server.addEventListener(SocketServerEvent.CONNECT,clientConnect)
			server.addEventListener(SocketServerEvent.RECEIVED,clientReceived)
			server.addEventListener(SocketServerEvent.DECODE_ERROR,clientDecode_error)
			server.addEventListener(SocketServerEvent.SENDTOCLIENT,sendToClient)
			server.addEventListener(SocketServerEvent.SENDTOCLIENT_ERROR,sendToClient_Error)
			server.addEventListener(SocketServerEvent.CLIENTINVALID_ERROR,clientInvalid_Error)
			server.addEventListener(SocketServerEvent.IO_ERROR, clientClose_Error)
			
			
		}
		/**
		 * 关闭客户端
		 * @param	client
		 */
		public function closeClient(client:Socket):void {
			server.closeClient(client)
		}
		/**
		 * 发送消息给客户端
		 * @param	client
		 * @param	value
		 */
		public function sendClient(client:Socket,value:Object):void {
			server.send(client,value)
		}
		/**
		 * 群发消息，除了自己
		 * @param	value
		 */
		public function sendAllClient(value:Object,oclient:Socket=null,postOld:Boolean=false):void {
			var client:Socket
			//var user:String = 'user_' + clientList.getClientBySocket(oclient).atListNumber
			for (var i:int = 0; i < clientList.list.length; i++) 
			{
				var item:Client = clientList.list[i] as Client;
				client = item.socket
				
				if (client != oclient) {
					server.send(client,value)
				}else {
					if(postOld)server.send(oclient,value)
				}
			}
		}
		/**
		 *开启绑定服务端
		 */
		public function bind(value:int):void {
			server.bind(value)
		}
		//服务器开启
		protected function serverOpen(e:SocketServerEvent):void {
			DebugOutput.push('socket','服务器开启')
		}
		//服务器开启错误
		protected function serverOpen_Error(e:SocketServerEvent):void {
			DebugOutput.push('socket','服务器开启错误')
		}
		//服务器关闭
		protected function serverClose(e:SocketServerEvent):void {
			DebugOutput.push('socket','服务器关闭')
		}
		//服务器段关闭客户端
		protected function serverCloseClient(e:SocketServerEvent):void {
			closeClientUp(e.socket,true)
			//var client:Client=clientList.remove(e.socket)
			//DebugOutput.push('clinet','服务器段关闭客户端 '+'在线人数:'+clientList.length)
		}
		
		//客户端关闭
		protected function clientClose(e:SocketServerEvent):void {
			closeClientUp(e.socket,false)
			//var client:Client = clientList.remove(e.socket)
			//DebugOutput.push('clinet','客户端关闭 '+'在线人数:'+clientList.length)
		}
		/**
		 * 关闭客户端 更新列表
		 * @param	socket
		 * @param	serverClose
		 */
		protected function closeClientUp(socket:Socket,serverClose:Boolean):void {
			var client:Client = clientList.remove(socket)
			sendAllClient("user_"+client.atListNumber+' 用户下线了!',null)
			DebugOutput.push('clinet','关闭客户端 '+'在线人数:'+clientList.length+' 是否服务段关闭:'+serverClose)
		}
		/**
		 * 客户端连接上
		 * @param	e
		 */
		protected function clientConnect(e:SocketServerEvent):void {
			var client:Client = clientList.add(e.socket)
			/*
			server.send(client.socket,'userid:'+client.atListNumber)
			*/
			DebugOutput.push('clinet','客户端连接上 '+'在线人数:'+clientList.length)
			
		}
		/**
		 * 接收客户端数据
		 * @param	e
		 */
		protected function clientReceived(e:SocketServerEvent):void {
			 var bytes:ByteArray = e.data as ByteArray
			var data:*=bytes.readObject()
			DebugOutput.push('clinet', '接收客户端数据 ' + clientList.getClientBySocket(e.socket).atListNumber + ":" + data)
			//测试代码
			//sendClient(e.socket, data)
			var client:Client = clientList.getClientBySocket(e.socket) 
			if (client.atListNumber) {
				
			}
			/*
			var sendData:String='user_'+client.atListNumber+' send:'+data
			sendAllClient(e.socket, sendData)
			sendClient(e.socket,'你说:'+data)
			*/
			/*
			if (data == 'close') {
				//执行关闭时候 还没发送完成就已经关闭了
				//sendClient(e.socket, '\n你丫~~你自己要关掉的啊！')
				closeClient(e.socket)
			}
			*/
		}
		//接受客户端消息解码错误
		protected function clientDecode_error(e:SocketServerEvent):void {
			DebugOutput.push('socket','接受客户端消息解码错误')
		}
		//发送消息给客户端
		protected function sendToClient(e:SocketServerEvent):void {
			DebugOutput.push('clinet','发送消息给客户端'+clientList.getClientBySocket(e.socket).atListNumber+':'+e.data)
		}
		//发送消息给客户端错误
		protected function sendToClient_Error(e:SocketServerEvent):void {
			DebugOutput.push('socket','发送消息给客户端错误')
		}
		//发送消息给客户端 出现无效客户端
		protected function clientInvalid_Error(e:SocketServerEvent):void {
			DebugOutput.push('socket','发送消息给客户端 出现无效客户端')
		}
		//错误连接  关闭客户端时候出错
		protected function clientClose_Error(e:SocketServerEvent):void {
			DebugOutput.push('socket','错误连接  关闭客户端时候出错')
		}
		public function get server():AIRSocketServer { return _server; }
		/**
		 * 客户端对象列表
		 */
		public function get clientList():ClientList { return _clientList; }
		//public function get list():ClientList { return _clientList; }
	}

}