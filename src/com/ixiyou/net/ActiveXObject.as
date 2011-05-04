package com.ixiyou.net 
{
	
	/**
	 * ActiveX控件对象,在网页中可以直接调用ActiveX控件的方法
	 * 该类的只能在网页中使用
	 * @author magic
	 */
	
	import flash.external.ExternalInterface;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	dynamic  public class ActiveXObject extends Proxy
	{
		private static var ID:uint = 0;
		private static var NEEDINIT:Boolean = true;
		
		//activeX实例在网页中的唯一标识
		private var _activeXId:String;
		//该activeX是否可用
		private var _available:Boolean = false;
		
		/**
		 * 实例化一个activeX控件
		 * 参考javascript的new ActiveXObject()
		 * @param	activeXName		控件名称
		 */
		public function ActiveXObject(activeXName:String) 
		{
			_activeXId = "flashActiveX" + (ID++);
			try 
			{
				/**
				 * 调用js实例化一个ActiveXObject对象
				 */
				ExternalInterface.call("eval", "var " + _activeXId + "= new ActiveXObject(\"" + activeXName + "\")");
				_available = true;
			}catch (e:Error) {
				//throw e;
			}
		}
		
		override flash_proxy function getProperty(name:*):*{}
		override flash_proxy function setProperty(name:*, value:*):void{}
		
		/**
		 * 定义函数调用方式
		 */
		override flash_proxy function callProperty(name:*, ... rest):*{
			if (!_available) return;
			rest.unshift(_activeXId + "." + name);
			return ExternalInterface.call.apply(null,rest);
		}
		
		/**
		 * 该ActiveX对象是否可用
		 */
		public function get available():Boolean { return _available; }
		
	}
}