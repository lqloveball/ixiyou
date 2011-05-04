package com.ixiyou.utils.net 
{
	/**
	 * 快速操作加载操作
	 * @author spe
	 */
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.utils.Dictionary
	public class LoadDataApace
	{
		private static  var dic:Dictionary=new Dictionary()
		private static  var id:int = 0
		
		private var _loader:URLLoader;
		private var _callBack:Function;
		private var _once:Boolean = false;
		private var _parameters:Object;
		private var _reqeust:URLRequest;
		public function LoadDataApace(config:*=null) {
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, complete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, error);
			_reqeust = new URLRequest();
			if (config == null) return;
			if (config.callBack) {
				_callBack = config.callBack;
			}
			if (config.params) {
				_parameters = config.params;
			}
			if (config.dataFormat) {
				_loader.dataFormat = config.dataFormat;
			}
		}
		
		/**
		 * 数据加载格式
		 */
		public function get dataFormat():String {
			return _loader.dataFormat;
		}
		public function set dataFormat(value:String):void {
			_loader.dataFormat = value;
		}
		
		/**
		 * 回调用函数
		 */
		public function get callBack():Function {
			return _callBack;
		}
		public function set callBack(value:Function):void {
			_callBack = value;
		}
		
		/**
		 * 用于请示的参数
		 */
		public function get params():Object {
			return _parameters;
		}
		public function set params(value:Object):void {
			if (_parameters == value) return;
			_parameters = value;
		}
		
		/**
		 * 加载数据
		 * @param	url
		 * @param	method
		 */
		public function load(url:String, method:String = null):void {
			close();
			_reqeust.url = url;
			if (method != null) {
				_reqeust.method = method;
			}
			if (_parameters != null) {
				var vars:URLVariables = new URLVariables();
				for (var i:String in _parameters) {
					vars[i] = _parameters[i];
				}
				_reqeust.data = vars;
			}else {
				_reqeust.data = null;
			}
			_loader.load(_reqeust);
		}
		
		/**
		 * 摧毁实例
		 */
		public function destroy():void {
			close();
			removeListeners();
			_loader = null;
			_reqeust = null;
		}
		
		/**
		 * 关闭加载流
		 */
		public function close():void {
			try 
			{
				_loader.close();
			}catch (e:Error) {
				
			}
		}
		
		/**
		 * 加载文本
		 * @param	url
		 * @param	callBack
		 */
		public function loadText(url:String, callBack:Function = null):void {
			dataFormat = URLLoaderDataFormat.TEXT;
			if (callBack != null) {
				_callBack = callBack;
			}
			load(url);
		}
		
		/**
		 * 加载二进制文件
		 * @param	url
		 * @param	callback
		 */
		public function loadByteArray(url:String, callback:Function = null):void {
			dataFormat = URLLoaderDataFormat.BINARY;
			if (callBack != null) {
				_callBack = callBack;
			}
			load(url);
		}
		/**
		 * 加载变量
		 * @param	url
		 * @param	callback
		 */
		public function loadVars(url:String, callback:Function = null):void {
			dataFormat = URLLoaderDataFormat.VARIABLES;
			if (callBack != null) {
				_callBack = callBack;
			}
			load(url);
		}
		
		private function addListeners():void {
			_loader.addEventListener(Event.COMPLETE, complete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, error);
		}
		private function removeListeners():void {
			_loader.removeEventListener(Event.COMPLETE, complete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, error);
		}
		private function error(ioe:IOErrorEvent):void {
			_callBack(null);
			if (_once) {
				destroy();
			}
		}
		private function complete(e:Event):void {
			_callBack(_loader.data);
			if (_once) {
				destroy();
			}
		}
		
		/**
		 * 一次性加载外部文体
		 * @param	_url
		 * @param	func
		 * @param	format
		 */
		public static function loadText(url:String, callBack:Function):void {
			var lda:com.ixiyou.utils.net.LoadDataApace = new com.ixiyou.utils.net.LoadDataApace();
			lda._once = true;
			lda.loadText(url, callBack);
		}
		
		
		/**
		 * 一次性加载二进制文件
		 * @param	url
		 * @param	callback
		 */
		public static function loadByteArray(url:String, callback:Function = null):void {
			var lda:com.ixiyou.utils.net.LoadDataApace = new com.ixiyou.utils.net.LoadDataApace();
			lda._once = true;
			lda.loadByteArray(url, callback);
		}
		/**
		 * 一次性加载变量
		 * @param	url
		 * @param	callback
		 */
		public static function loadVars(url:String, callback:Function = null):void {
			var lda:com.ixiyou.utils.net.LoadDataApace = new com.ixiyou.utils.net.LoadDataApace();
			lda._once = true;
			lda.loadVars(url, callback);
		}
		
		
		/**打开网页
		 * 
		 * @param 
		 * @return 
		*/
		/*public static function getUrll(url:String, window:String = "_blank"):void {
			var getURLRequest:URLRequest = new URLRequest(url)
			//navigateToURL(getURLRequest,window);
		}*/
	}

}