/**
 *  Arduino控制器 socket
	var arduino:ArduinoSocket = new ArduinoSocket();
	
	//arduino.addEventListener( Event.CLOSE, onClose );
	//arduino.addEventListener( Event.CONNECT, onConnect );
	//arduino.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorEvent );
	//arduino.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
	
	arduino.addEventListener(DataEvent.DATA, onArduinoData );
	arduino.connect( "127.0.0.1", 5333 );
	function onArduinoData( e:DataEvent ):void
	{
		trace( "data:", e.data );
	}
 */


package com.ixiyou.socket
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	public class ArduinoSocket extends EventDispatcher
	{
		
		private var _host		: String;
		private var _socket		: Socket;
		private var _port:uint;
		
		
		public function ArduinoSocket( host:String = null, port:int = 0 )
		{
			super();
			_host=host
			_port=port
			_socket = new Socket();
			_socket.addEventListener( Event.CLOSE, onClose );
			_socket.addEventListener( Event.CONNECT, onConnect );
			_socket.addEventListener( IOErrorEvent.IO_ERROR, onIOErrorEvent );
			_socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityError );
			_socket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketData );
		}
		
		public function get host():String {  
            return _host;  
        }  
          
        public function get port():uint {  
            return _port;  
        }  
          
        public function get connected():Boolean {  
            return this._socket.connected;  
        }  
	
		
		public function get socket():Socket { return _socket; }
		
		public function close():void
		{
			_socket.close();
		}
		
		public function connect( host:String = '', port:int = 0 ):void
		{			
			if (_host != host&&host!='')_host = host
			if (_port != port && port != 0)_port = port
			if (connected) {
				trace('已经连接的关闭 重新连接')
				//this.dispatchEvent(new BaseSocketEvent(BaseSocketEvent.CLOSE)); 
			}
			this._socket.connect(this.host,this.port);  
			trace( "connecting" );
		}
		
		public function send( value:String ):void
		{			
			_socket.writeUTFBytes( value );
			_socket.flush();
		}
		
		
		private function onClose( event:Event ):void
		{
			trace( "onClose" );
			dispatchEvent( event );
		}
		
		private function onConnect( event:Event ):void
		{
			trace( "onConnect" );
			dispatchEvent( event );
		}
		
		private function onIOErrorEvent( event:IOErrorEvent ):void
		{
			trace( "onIOErrorEvent" );
			dispatchEvent( event );
		}
		
		private function onSecurityError( event:SecurityErrorEvent ):void
		{
			trace( "onSecurityError" );
			dispatchEvent( event );
		}
		
		private function onSocketData( event:ProgressEvent ):void
		{
			var value:String=_socket.readUTFBytes(_socket.bytesAvailable) 
			dispatchEvent( new DataEvent('arduinoData', false, false,value ));
			dealData(value);
		}
		private var arduinoTemp:String=''
		private function dealData(value:String, fe:String = '|'):void {
			//trace('>>接收数据----------------------------')
			var arr:Array = value.split(fe)
			//trace(value + '< >' + arr)
			if (arr.length == 1) {
				arduinoTemp += arr[0];
			}else {
				for (var i:int = 0; i < arr.length-1; i++) 
				{
					var item:String = arr[i];
					arduinoTemp += item;
					readData(arduinoTemp)
					arduinoTemp=''
				}
				arduinoTemp +=arr[arr.length-1]
			}
			//trace('<<接收数据----------------------------')
		}
		private function readData(value:String):void {
			//trace(value)
			dispatchEvent( new DataEvent( DataEvent.DATA, false, false, value));
		}
	}
	
	
	
}