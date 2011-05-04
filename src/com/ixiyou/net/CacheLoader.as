package com.ixiyou.net 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 缓存下载
	 * 能将下载的东西自动保存在缓存中，二次下载时自动从缓存中提取
	 * @author magic
	 */
	public class CacheLoader extends URLLoader
	{
		private var _url:String;
		private var _cache:Cache;
		public var version:String;
		public var date:Date;
		
		/**
		 * 创建实例
		 * @param	cache	缓存管理类
		 */
		public function CacheLoader(cache:Cache) {
			_cache = cache;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function load(request:URLRequest):void 
		{
			removeListen();
			_url = request.url;
			if (_cache.isCache(_url) && (version == null || version == _cache.getVersion(_url)) && (date == null || date.time <= _cache.getDate(_url).time)) {
				data = _cache.getData(_url);
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			upDate(request);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function close():void 
		{
			removeListen();
			super.close();
		}
		/**
		 * 强制重新加载
		 * @param	request
		 */
		public function upDate(request:URLRequest):void {
			addListen();
			super.load(request);			
		}
		
		private function complete(e:Event):void {
			_cache.add(_url, data, version, date);
			removeListen();
		}
		private function onIOError(e:IOErrorEvent):void {
			removeListen();
		}
		
		private function addListen():void {
			addEventListener(Event.COMPLETE, complete);
			addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		private function removeListen():void {
			try {
				removeEventListener(Event.COMPLETE, complete);
				removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}catch (e:Error) {
				
			}
		}
	}
	
}