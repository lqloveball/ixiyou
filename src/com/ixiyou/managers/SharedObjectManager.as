package com.ixiyou.managers 
{
	import flash.events.*;
	import flash.net.SharedObject
	/**
	 * 本地存储对象
	 * @author spe email:md9yue@qq.com
	 */
	public class SharedObjectManager extends EventDispatcher
	{

		private var _so:SharedObject
		private var _name:String
		/**
		 * 创建共享对象
		 * @param	name  对象的名称。 该名称可以包含正斜杠 (/)；例如，work/addresses 是合法名称。 共享对象名称中不允许使用空格，也不允许使用以下字符：  ~ % & \ ; : " ' , < > ? # 
		 * @param	localPath 创建了共享对象的 SWF 文件的完整路径或部分路径，这将确定共享对象的本地存储位置。 如果未指定此参数，则使用完整路径。
		 * @param	secure
		 */
		public function SharedObjectManager(name:String,localPath:String='/',secure:Boolean=false) 
		{
			_name=name
			_so = SharedObject.getLocal(name, localPath, secure)
			so.addEventListener(AsyncErrorEvent.ASYNC_ERROR, async_Error)
			so.addEventListener(NetStatusEvent.NET_STATUS, net_Status)
			so.addEventListener(SyncEvent.SYNC,Sync)
		}
		/**
		 * 在服务器更新了远程共享对象后调度。
		 * @param	e
		 */
		private function Sync(e:SyncEvent):void 
		{
			
		}
		/**
		 * 在 SharedObject 实例报告其状态或错误情况时调度。
		 * @param	e
		 */
		private function net_Status(e:NetStatusEvent):void 
		{
			trace('[so ',name,' netStatus ] :' ,e.info.code)
			switch (e.info.code) {
                case "SharedObject.Flush.Success":
                    trace("User granted permission -- value saved.\n");
                    break;
                case "SharedObject.Flush.Failed":
                   trace("User denied permission -- value not saved.\n");
                    break;
            }

		}
		/**
		 * 在异步引发异常（即来自本机异步代码）时调度。
		 * @param	e
		 */
		private function async_Error(e:AsyncErrorEvent):void 
		{
			
		}
		/**
		 * 本地存储对象
		 */
		public function get so():SharedObject { return _so; }
		/**
		 * 本地对象数据
		 */
		public function get data():Object { return so.data }
		/**
		 * 本地对象名
		 */
		public function get name():String { return _name; }
		
		
		/**
		 * 对于本地共享对象，清除所有数据并从磁盘删除共享对象。 
		 */
		public function clear():void { so.clear() }
		
		/**
		 * 是否拥有属性
		 * @param	value
		 * @return
		 */
		public function hasOwnProperty(value:String):Boolean {
			if (data[value] != undefined) return true
			else return false
		}
		/**
		 * 设置数据
		 * @param	name
		 * @param	value
		 */
		public function setData(name:String, value:Object = null):void {
			data[name]=value
			flush()
		}
		/**
		 * 获取数据
		 * @param	value
		 * @return
		 */
		public function getData(value:String):Object {
			//trace('dd',data[value])
			if (data[value]!=undefined) return data[value]
			else return null
		}
		/**
		 * 立即插入数据
		 * @return
		 */
		public function flush():String{return so.flush()}
		/**
		 * 数据大小
		 * @return
		 */
		public function size():uint{return so.size}
	}

}