package com.ixiyou.net
{
	
	/**加载资源里的类class类
	* 学习参考http://www.xiaos8.com/article.asp?id=90
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;
  
	public class ClassLoader extends EventDispatcher
	{
		
		public var url:String;
		public var loader:Loader;
		
		/**
		 * 构造函数
		 * @param 参数1可以是字符串，可以是ByteArray，如果为前者则采用load方法，后者采用loadBytes方法
		 * @param 参数2是创建带有指定 LoaderContext 对象的ClassLoader实例，LoaderContext 可以设置是否加载跨域文件，应用程序域等，详见官方LoaderContext类讲解！
		 * @return 
		*/
		public function ClassLoader(obj:Object = null,lc:LoaderContext = null) {
		  if(obj != null){
			if(obj is ByteArray){
			  loadBytes(obj as ByteArray,lc);
			}else if(obj is String){
			  load(obj as String,lc);
			}else{
			  throw new Error("参数错误，构造函数第一参数只接受ByteArray或String");
			}
		  }
		}
		
		/**
		 * 加载地址
		 * @param 
		 * @return 
		*/
		public function load(_url:String,lc:LoaderContext = null):void{
		  url = _url;
		  loader = new Loader;
		  loader.load(new URLRequest(url),lc);
		  addEvent();
		}
		
		/**
		 * 字节方式加载
		 * @param 
		 * @return 
		*/
		public function loadBytes(bytes:ByteArray,lc:LoaderContext = null):void{
		  loader = new Loader;
		  loader.loadBytes(bytes,lc);
		  addEvent();
		}
	
		/**
		 * 开始侦听
		 * @param 
		 * @return 
		*/
		private function addEvent():void{
		  loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressFun);
		  loader.contentLoaderInfo.addEventListener(Event.COMPLETE,completeFun);
		}
		/**
		 * 结束侦听
		 * @param 
		 * @return 
		*/
		private function delEvent():void{
		  loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,progressFun);
		  loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,completeFun);
		}
		
		/**
		 * 加载成功，发布成功事件
		 * @param 
		 * @return 
		*/
		private function completeFun(e:Event):void {
		  delEvent();
		  dispatchEvent(e);
		}
		/**
		 * 加载过程
		 * @param 
		 * @return 
		*/
	
		private function progressFun(e:ProgressEvent):void{
		  dispatchEvent(e);
		}
		/**
		 * 获取定义
		 * @param 
		 * @return 
		*/
		public function getClass(className:String):Object {
		  return loader.contentLoaderInfo.applicationDomain.getDefinition(className);
		}
		/**
		 * 是否含有该定义
		 * @param 
		 * @return 
		*/
		public function hasClass(className:String):Boolean {
		  return loader.contentLoaderInfo.applicationDomain.hasDefinition(className);
		}
		/**
		 * 清除
		 * @param 
		 * @return 
		*/
		public function clear():void{
		  loader.unload();
		  loader = null;
		}
  }	
}