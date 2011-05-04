package com.ixiyou.net 
{
	import flash.display.Loader;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	
	/**
	 * 缓存管理类
	 * 将数据保存在sharedobject中可用关键字及版本号查询,索引,修改
	 * @author magic
	 */
	public class Cache
	{
		private var _so:SharedObject;
		private var _map:Object;
		public function Cache(name:String, localPath:String = null, secure:Boolean = false) {
			_so = SharedObject.getLocal(name, localPath, secure);
			if (_so.data.map == null) {
				_so.data.map = new Object();
				_so.flush();
			}
			_map = _so.data.map;
		}
		
		/**
		 * 插入一个数据到本地缓存库
		 * @param	key			唯一标识
		 * @param	data		数据
		 * @param	version		版本号
		 * @param	date		时间
		 */
		public function add(key:String,data:*, version:String = null, date:Date = null):void {
			if (date == null) {
				date = new Date();
			}
			_map[key] = { version:version, data:data, date:date.getTime() };
			_so.flush();
		}
		/**
		 * 是否存在于缓存这中
		 * @param	key		唯一标识
		 * @param	version	版本号
		 * @return
		 */
		public function isCache(key:String,version:String=null):Boolean {
			return _map[key] != null && (version == null || _map[key].version == version);
		}
		
		/**
		 * 获取版本号
		 * @param	key		唯一标识
		 * @return
		 */
		public function getVersion(key:String):String {
			return _map[key].version;
		}
		
		/**
		 * 获取数据
		 * @param	key		唯一标识
		 * @return
		 */
		public function getData(key:String):* {
			return _map[key].data;
		}
		
		/**
		 * 获取时间
		 * @param	key		唯一标识
		 * @return
		 */
		public function getDate(key:String):Date {
			var time:Number = _map[key].time;
			var date:Date = new Date();
			date.setTime(time);
			return date;
		}
		/**
		 * 设置版本号
		 * @param	key		唯一标识
		 * @param	version	版本号
		 */
		public function setVersion(key:String, version:String):void {
			_map[key].version = version;
			_so.flush();
		}
		
		/**
		 * 设置数据
		 * @param	key		唯一标识
		 * @param	data	数据
		 */
		public function setData(key:String, data:*):void {
			_map[key].data = data;
			_so.flush();
		}
		
		/**
		 * 设置时间
		 * @param	key		唯一标识
		 * @param	date	时间
		 */
		public function setDate(key:String, date:Date):void {
			_map[key].time = date.getTime();
			_so.flush();
		}
		/**
		 * 删除指定的数据
		 * @param	key
		 */
		public function remove(key:String):void {
			delete _map[key];
			_so.flush();
		}
		/**
		 * 清空缓存
		 */
		public function clear():void {
			_so.clear();
			_so.data.map = new Object();
			_map = _so.data.map;
		}
	}
}