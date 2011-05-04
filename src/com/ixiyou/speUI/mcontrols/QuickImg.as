package com.ixiyou.speUI.mcontrols 
{
	import flash.display.Sprite;
	import flash.display.Loader;
	import flash.display.Bitmap
	import flash.events.IOErrorEvent;
	import flash.net.*
	import flash.events.Event
	import flash.events.ProgressEvent
	
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	/**
	 * 快速加载图片器
	 * @author spe email:md9yue@qq.com
	 */
	public class QuickImg extends Sprite
	{
		private var _loader:Loader
		private var _url:String
		private var _loadend:Boolean = false
		private var _plan:Number = 0
		private var completeFun:Function = null
		private var progressFun:Function = null
		private var errorFun:Function = null
		private var _rectBool:Boolean=false
		public var rectw:uint = 0
		public var recth:uint=0
		private var _middle:Boolean=false
		/**
		 * 构造函数
		 * @param	url 加载地址
		 * @param	completeFun 加载完成事件 传递本对象
		 * @param	progressFun 加载进度 传递本对象
		 * @param	errorFun 加载错误 传递本对象
		 */
		public function QuickImg(url:String='',completeFun:Function=null,progressFun:Function=null,errorFun:Function=null) 
		{
			if (completeFun!=null) this.completeFun = completeFun
			if (progressFun!=null) this.progressFun = progressFun
			if(errorFun!=null)this.errorFun=errorFun
			if (url != '') {
				load(url)
			}
		}
		/**
		 * 加载进度
		 * @param	e
		 */
		private function progress(e:ProgressEvent):void 
		{
			_loadend = false
			_plan=e.bytesLoaded/e.bytesTotal
			dispatchEvent(e)
			if (progressFun != null) progressFun(this)
			dispatchEvent(e)
		}
		
		/**
		 * 加载错误
		 * @param	e
		 */
		private function error(e:IOErrorEvent):void 
		{
			
			_plan=0
			_loadend = false
			if (errorFun != null) errorFun(this)
			dispatchEvent(e)
		}
		/**
		 * 加载完成
		 * @param	e
		 */
		private function complete(e:Event):void 
		{
			_plan=1
			dispatchEvent(new Event(Event.COMPLETE))
			_loadend = true
			if (loader.content is Bitmap) {
				Bitmap(loader.content).smoothing=true
			}
		
			if (loader.content.width != 0 && loader.content.height != 0) {
				middleFun(null)
			}else {
				loader.addEventListener(Event.ENTER_FRAME,middleFun)
			}
			if (completeFun != null) completeFun(this)
			dispatchEvent(e)
		}
		/**
		 * 
		 * @param	e
		 */
		private function middleFun(e:Event=null):void {
			if (loader&&loader.content&&loader.content.width != 0 && loader.content.height != 0) {
				loader.removeEventListener(Event.ENTER_FRAME, middleFun)
					if (middle) {
						loader.x = -loader.width / 2;
						loader.y = -loader.height / 2;
					}
					if (rectBool) {
						loader.content.width = rectw;
						loader.content.height = recth;
					}
					
			}
		}
		/**
		 * 开始加载
		 * @param	value
		 */
		public function load(value:String):void {
			if (_loader) {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete)
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, error)
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress)
				loader.removeEventListener(Event.ENTER_FRAME,middleFun)
				removeChild(loader)
			}
			_url = value
			_loadend = false
			_loader = new Loader()
			addChild(loader)
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, complete)
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, error)
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progress)
			var request:URLRequest=new URLRequest(url)
			loader.load(request)
		}
		/**
		 * 图片地址
		 */
		public function get url():String { return _url; }
		/**
		 * 加载对象
		 */
		public function get loader():Loader { return _loader; }
		/**
		 * 是否加载完成
		 */
		public function get loadend():Boolean { return _loadend; }
		/**
		 * 进度
		 */
		public function get plan():Number { return _plan; }
		/**
		 * 居中
		 */
		public function get middle():Boolean { return _middle; }
		
		public function set middle(value:Boolean):void 
		{
			_middle = value;
		}
		/**
		 * 加载完成后缩放
		 */
		public function get rectBool():Boolean { return _rectBool; }
		
		public function set rectBool(value:Boolean):void 
		{
			_rectBool = value;
		}
		public function setRect(w:uint, h:uint):void {
			rectw =w
			recth = h
			//middleFun()
		}
		/**
		 * 破坏所有索引，垃圾回收
		 */
		public function destory():void {
			if (loader ) {
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete)
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, error)
				loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,progress)
				if(loadend)loader.unload()
			}
			
		}
		
		
	}

}