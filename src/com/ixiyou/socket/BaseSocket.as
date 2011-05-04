package com.ixiyou.socket
{
	/**
	 * 原作者：KingLong
	 * 提升Socket数据传输效率 
	 * AMF3和ByteArray的特性对原来数据进行压缩后再传输
	 * http://www.klstudio.com/post/179.html
	 * 网站：http://www.klstudio.com/
	 * */
	import flash.events.*;  
    import flash.net.Socket;  
    import flash.net.ObjectEncoding;  
    import flash.system.Security;  
    import flash.utils.ByteArray;  
    
  	import com.ixiyou.socket.events.BaseSocketEvent
	[Event(name = 'received', type = "com.ixiyou.socket.events.BaseSocketEvent")]
    public class BaseSocket extends EventDispatcher{  
          
        private var _host:String;  
        private var _port:uint;  
        private var _socket:Socket;  
          
        public function BaseSocket(host:String, port:uint = 80) {  
            this._host = host;  
            this._port = port;  
            this._socket = new Socket();  
            this._socket.objectEncoding = ObjectEncoding.AMF3;            
            Security.loadPolicyFile("xmlsocket://" + this.host + ":" + this.port);  
            this._socket.addEventListener(Event.CONNECT, handler);  
            this._socket.addEventListener(Event.CLOSE, handler);  
            this._socket.addEventListener(IOErrorEvent.IO_ERROR, handler);  
            this._socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler);  
            this._socket.addEventListener(ProgressEvent.SOCKET_DATA, handler);  
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
          
        public function connect(host:String='', port:int=0):void { 
			if (_host != host&&host!='')_host = host
			if (_port != port && port != 0)_port = port
			if (connected) {
				trace('已经连接的关闭 重新连接')
				//this.dispatchEvent(new BaseSocketEvent(BaseSocketEvent.CLOSE)); 
			}
            this._socket.connect(this.host,this.port);  
        }  
          
        public function close():void {  
            this._socket.close();  
        }  
          
        public function send(params:Object=null):void {  
            if (!this.connected || params == null) {  
                return;  
            }  
            var bytes:ByteArray = new ByteArray();  
            bytes.writeObject(params);  
            bytes.compress();  
            this._socket.writeBytes(bytes);  
            this._socket.flush();  
            this.dispatchEvent(new BaseSocketEvent(BaseSocketEvent.SENDING, params));             
        }  
          
        private function received():void {                
            var bytes:ByteArray = new ByteArray();  
            while (this._socket.bytesAvailable > 0) {  
                this._socket.readBytes(bytes, 0, this._socket.bytesAvailable);  
            }  
            try{                  
                bytes.uncompress();  
                this.dispatchEvent(new BaseSocketEvent(BaseSocketEvent.RECEIVED, bytes.readObject()));  
            }catch (error:Error) {  
                this.dispatchEvent(new BaseSocketEvent(BaseSocketEvent.DECODE_ERROR));  
            }  
        }  
          
        private function handler(event:Event):void {  
			trace(event.type)
            switch(event.type) {  
                case Event.CLOSE:  
                    this.dispatchEvent(new BaseSocketEvent(BaseSocketEvent.CLOSE));  
                    break;  
                case Event.CONNECT:                   
                case IOErrorEvent.IO_ERROR:  
                case SecurityErrorEvent.SECURITY_ERROR:  
                    this.dispatchEvent(new BaseSocketEvent(event.type));  
                    break;  
                case ProgressEvent.SOCKET_DATA:  
                    this.received();  
                    break;  
            }  
        }  
    }
}