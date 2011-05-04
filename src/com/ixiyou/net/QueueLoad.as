package com.ixiyou.net 
{
	import com.ixiyou.events.QueueLoadEvent;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * @eventType 成功预加载一个文件
	 */
	[Event(name = "loaded", type = "com.ixiyou.events.QueueLoadEvent")]
	/**
	 * @eventType 遇到一个无法加载的文件
	 */
	[Event(name = "ioError", type = "flash.events.IOErrorEvent")]
	/**
	 * @eventType 当前文件预加载进度
	 */
	[Event(name = "progress", type = "com.ixiyou.events.QueueLoadEvent")]
	/**
	 * @eventType	队列加载完毕
	 */
	[Event(name = "complete", type = "com.ixiyou.events.QueueLoadEvent")]
	
	/**
	 * @eventType 开始队列加载
	 */
	[Event(name = "start", type = "com.ixiyou.events.QueueLoadEvent")]
	
	/**
	 * @eventType 加载新文件
	 */
	[Event(name = "load", type = "com.ixiyou.events.QueueLoadEvent")]
	
	
	
	/**
	 * 预加载,当加载的外部资源比较多时，可以使用该类
	 * @author ChenXiaolin
	 */
	public class QueueLoad extends EventDispatcher
	{
		
		//记录所有的地址
		private var _mapUrls:Object;
		//记录所有的id标识
		private var _mapIds:Dictionary;
		//记录所有加载内容
		private var _map:Dictionary;
		//预加载
		private var _perloader:URLLoader;
		private var _nowPerloader:Perloader;
		
		//试探性加载(用于判断文件大小及能否正常加载)
		private var _testLoader:URLLoader;
		private var _nowTest:Perloader;
		//未知加载队列
		private var _unkowns:Array;
		//等待加载的队列
		private var _waits:Array;
		//加载完成的队列
		private var _completes:Array;
		//丢失或加载错误对立
		private var _loses:Array;
		
		private var _request:URLRequest;
		//队列总字节
		private var _bytesTotal:uint = 0;
		//队列加载的字节
		private var _bytesLoaded:uint=0;
		
		public function QueueLoad() 
		{
			_unkowns = new Array();
			_waits = new Array();
			_loses = new Array();
			_completes = new Array();
			_mapIds = new Dictionary();
			_mapUrls = new Object();
			
			_map = new Dictionary();
			
			_perloader = new URLLoader();
			_perloader.addEventListener(IOErrorEvent.IO_ERROR, error);
			_perloader.addEventListener(Event.COMPLETE, complete);
			_perloader.addEventListener(ProgressEvent.PROGRESS, progress);
			
			_testLoader = new URLLoader();
			_testLoader.addEventListener(IOErrorEvent.IO_ERROR, error);
			_testLoader.addEventListener(ProgressEvent.PROGRESS, endTest);
		}
		
		/**
		 * 队列中已被加载的字节数
		 */
		public function get bytesLoaded():uint {
			return _nowPerloader.bytesLoaded+ _bytesLoaded;
		}
		/**
		 * 队列文件的字节总数
		 */
		public function get bytesTotal():uint {
			return _bytesTotal;
		}
		
		/**
		 * 未知状态的队列
		 */
		public function get unkowns():Array { return _unkowns; }
		
		/**
		 * 等待加载的队列（包括unkowns队列）
		 */
		public function get waits():Array { return _waits; }
		/**
		 * 已经加载完毕的队列
		 */
		public function get completes():Array { return _completes; }
		/**
		 * 加载失败的队列
		 */
		public function get loses():Array { return _loses; }
		
		/**
		 * 添加将新的地址或修改已有地址,当url为数组时为批量添加/修改
		 * @param	url			地址可以是string,URLRequest或由string,URLRequest组成的数组
		 * @param	index		添加到队列中的位置大于0时有效
		 * @param	prs			{id:"",type:""}
		 * @return
		 */
		public function insert(url:*, index:int = -1, prs:Object = null):* {
			
			if (url == null) return false;
			
			if(prs!=null){
				var id:String = prs.id as String;
				var type:String = prs.type as String;
			}
			if (_map[url] != null) {
				//trace('修改')
			   //修改
				var pl:Perloader = _map[url] as Perloader;
				if (id != null) {
					_map[id] = pl;
				}
				if (index <= 0) return true;
				if (pl.index >= 0) {
					_waits.splice(pl.index, 1);
					_waits.splice(index, 0, pl);
				}
				upList();
				return true;
			}
			if ((url is String) || (url is URLRequest)) {
				//trace('添加')
				//添加
				pl = new Perloader(url,prs);
				if (id != null)	_map[id] = pl;
				_map[pl.request] = pl;
				_map[pl.url] = pl;
				if (index >= 0) {
					_waits.splice(index, 0, pl);
					_unkowns.push(pl);
					upList();
				}else {
					_waits.push(pl);
					_unkowns.push(pl);
					
				}
				return true;
			}else if (url is Array) {
				trace(_waits.length)
			//批量添加
				var temp:Array = new Array();
				for (var i:int = url.length - 1; i >= 0; i--) {
					temp[i]=insert(url[i], index, id);
				}
				return temp;
			}
			return false;
		}
		/**
		 * 添加将新的地址或修改已有地址,当url为数组时为批量添加/修改
		 * @param	url			地址可以是string,URLRequest或由string,URLRequest组成的数组
		 * @param	index		添加到队列中的位置大于0时有效
		 * @param	prs			{id:"",type:""}
		 * @return
		 */
		public function add(url:*, index:int = -1, prs:Object = null):* {return insert(url,index,prs)}
		/**
		 * 从队列中删除
		 * @param	url
		 */
		public function remove(url:*):void {
			var pl:Perloader = _map[url] as Perloader;
			if (pl == null) return;
			if (_map[pl.url] == pl) delete _map[pl.url];
			if (_map[pl.request] == pl) delete _map[pl.request];
			if (_map[pl.id] == pl)	delete _map[pl.id];
			if (pl.index == -1) {
				removefromArray(pl, _completes);
			}else if (pl.index == -2) {
				removefromArray(pl, _loses);
			}else if(pl.bytesTotal==0) {
				removefromArray(pl, _waits);
				removefromArray(pl, _unkowns);
			}else {
				removefromArray(pl, _waits);
			}
		}
		
		/**
		 * 获取数据
		 * @param	url
		 * @return
		 */
		public function getData(url:*):*{
			return _map[url].data;
		}
		
		
		/**
		 * 根据urlrequet,rul地址或者id别称获取加载对象在队列中的位置
		 * @param	url		urlrequet,rul地址或者id别称
		 * @return
		 */
		public function getIndex(url:*):int {
			if (_map[url] == null) return -1;
			return _map[url].index;
		}
		
		/**
		 * 进行加载
		 */
		public function start():void 
		{
			dispatchEvent(new QueueLoadEvent(QueueLoadEvent.START));
			load();
		}
		
		/**
		 * 加载队列中的第一个文件
		 */
		private function load():void {
			//trace(_waits.length)
			if (_waits.length == 0) {
				dispatchEvent(new QueueLoadEvent(QueueLoadEvent.COMPLETE));
				return;
			}
			
			_nowPerloader = _waits[0];
			_perloader.dataFormat = _nowPerloader.type;
			_perloader.load(_nowPerloader.request);
			dispatchEvent(new QueueLoadEvent(QueueLoadEvent.LOAD,_nowPerloader));
		}
		
		/**
		 * 停止加载
		 */
		public function stop():void {
			try{
				_perloader.close();
			}catch (e:Error) {
			}
		}
		
		/**
		 * 更新列表
		 */
		public function upList():void {
			for (var i:int = _waits.length - 1; i >= 0; i-- ) 
				_waits[i].index = i;
			_unkowns.sortOn("index", Array.DESCENDING | Array.NUMERIC);
			if (_nowPerloader != _waits[0])	load();
			if (_nowTest != _unkowns[0]) testload();
		}
		
		/**
		 * 清空队列
		 */
		public function clear():void {
			if (_unkowns.length > 0) {
				try {
					_testLoader.close();
				}catch (e:Error) {
					
				}
			}
			if (_waits.length > 0) {
				try {
					_perloader.close();
				}catch (e:Error) {
					
				}
			}
			
			while (_unkowns.length > 0) _unkowns.pop();
			while (_waits.length > 0) _waits.pop();
			while (_completes.length > 0) _completes.pop();
			while (_loses.length > 0) _loses.pop();
			
			for (var i:* in _mapIds) delete _mapIds[i];
			for (var j:* in _mapUrls) delete _mapUrls[i];
			for (var k:* in _map) delete _map[k];
		}
		
		/**
		 * 加载失败
		 * @param	ioe
		 */
		private function error(ioe:IOErrorEvent):void {
			dispatchEvent(ioe);
			if (ioe.currentTarget == _perloader) {
				if (_nowPerloader.bytesTotal != 0) {
					_bytesTotal -= _nowPerloader.bytesTotal;
				}
				_nowPerloader.index = -2;
				_loses.push(_nowPerloader);
				removefromArray(_nowPerloader, _waits);
				if (_unkowns.length != 0) {
					testload();
				}
			}else {
				_nowTest.index = -2;
				_loses.push(_nowTest);
				removefromArray(_nowTest, _unkowns);
				removefromArray(_nowTest, _waits);
				if (_waits.length == 0) {
					dispatchEvent(new QueueLoadEvent(QueueLoadEvent.COMPLETE));
				}else{
					load();
				}
			}
		}
		
		/**
		 * 成功加载完
		 * @param	e
		 */
		private function complete(e:Event):void {
			_nowPerloader.index = -1;
			_nowPerloader.data = _perloader.data;
			dispatchEvent(new QueueLoadEvent(QueueLoadEvent.LOADED, _nowPerloader));
			_completes.push(_nowPerloader);
			removefromArray(_nowPerloader, _waits);
			_bytesLoaded += _nowPerloader.bytesTotal;
			if (_waits.length == 0) {
				dispatchEvent(new QueueLoadEvent(QueueLoadEvent.COMPLETE));
			}else{
				load();
			}
		}
		
		/**
		 * 监听当前文件加载进度
		 * @param	e
		 */
		private function progress(e:ProgressEvent):void {
			if (_nowPerloader.bytesTotal == 0) {
				removefromArray(_nowPerloader, _unkowns);
				_nowPerloader.bytesTotal = e.bytesTotal;
				_bytesTotal += e.bytesTotal;
			}
			_nowPerloader.bytesLoaded = e.bytesLoaded;
			dispatchEvent(new QueueLoadEvent(QueueLoadEvent.PROGRESS, _nowPerloader));
		}
		
		/**
		 * 试探完毕
		 * @param	e
		 */
		private function endTest(e:ProgressEvent):void {
			_nowTest.bytesTotal = _testLoader.bytesTotal;
			_bytesTotal += _nowTest.bytesTotal;
			_testLoader.close();
			removefromArray(_nowTest, _unkowns);
			if(_unkowns.length!=0)
				testload();
		}
		
		
		/**
		 * 试探性加载
		 */
		private function testload():void {
			if (_unkowns.length >= 1) {
				_nowTest = _unkowns[0];
			}
			_testLoader.load(_nowTest.request);
		}
		
		/**
		 * 从数组中删除一个对象
		 * @param	obj
		 * @param	arr
		 */
		private function removefromArray(obj:Object, arr:Array):void {
			var len:int = arr.length;
			for (var i:int = 0; i < len; i++) 
			{
				if (arr[i] == obj) {
					arr.splice(i, 1);
				}
			}
		}
	}
}
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.ByteArray;

class Perloader {
	/**
	 * id
	 * 地址
	 * 加载时使用的URLRequest实例
	 * 加载类型
	 * 在队列中的位置
	 * 文件总字节数
	 * 文件已经被加载的字节数
	 * 被加载的数据
	 */
	public var id:String;
	public var url:String;
	public var request:URLRequest;
	public var type:String;
	public var index:int;
	public var bytesTotal:uint;
	public var bytesLoaded:uint=0;
	public var data:*;
	public var prs:Object
	public function Perloader(url:*,prs:Object) {
		if (url is URLRequest) {
			this.url = url.url;
			request = url;
		}else {
			request = new URLRequest(url);
			this.url = url;
		}
		this.prs=prs
		if(prs.id)this.id = prs.id;
		if(prs.type)this.type = prs.type;
		if (type == URLLoaderDataFormat.BINARY || type == URLLoaderDataFormat.VARIABLES) {
			this.type = type;
		}else {
			this.type = URLLoaderDataFormat.TEXT;
		}
		
	}
}