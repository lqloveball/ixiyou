package com.ixiyou.utils 
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * 单例管理
	 * @author magic
	 */
	public class SingIeton
	{
		private static var _dict:Dictionary = new Dictionary();
		public function SingIeton() 
		{
		}
		
		/**
		 * 获取单例
		 * @param	ref		类或者类名称
		 * @return	该类的一个单例
		 */
		public static function getInstance(ref:*):* {
			var type:Class = parseClass(ref);
			if (type == null) return null;
			if (_dict[type] == null) {
				_dict[type] = new type();
			}
			return _dict[type];
		}
		
		/**
		 * 把已有的一个对象变成SingIteon中的单例
		 * @param	ref
		 */
		public static function setInstance(ref:Object):void {
			var type:Class = getDefinitionByName(getQualifiedClassName(ref)) as Class;
			_dict[type] = ref;
		}
		
		/**
		 * 删除单例
		 * @param	ref
		 */
		public static function removeInstance(ref:*):void {
			var type:Class = parseClass(ref);
			if (type == null) return;
			delete _dict[type];
		}
		/**
		 * 该类型的单例是否存在
		 * @param	ref
		 * @return
		 */
		public static function existInstance(ref:*):Boolean {
			var type:Class = parseClass(ref);
			return _dict[type] != null;
		}
		/**
		 * 按类或类名解析成类
		 * @param	ref
		 * @return
		 */
		private static function parseClass(ref:*):Class{
			var type:Class = null;
			if (ref is Class) {
				type = ref;
			}else if (ref is String) {
				try{
					type = getDefinitionByName(ref) as Class;
				}catch (e:Error) {
				}
			}
			return type;
		}
	}

}