package com.ixiyou.utils
{
	
	/**
	* 对象操作
	* @author spe
	*/
	public final class ObjectUtil
	{
		/**
		 * 把一个对象转成String类型
		 * @param	obj
		 * @return
		 */
		public static function ObjtoString(obj:Object):String
		{
			var str:String="[ "
			for (var prop:* in obj)
			{
				str+=(prop+"="+obj[prop]+" "); 
			}
			str += "]"
			return str
		}
		//获得对象的第一获取到数据
		public static function objOneObj(obj:Object):* {
			var _obj:*
			for (var prop:* in obj)
			{
				_obj = (obj[prop]); 
				break
			}
			return _obj
		}
		//获得对象的第一获取到数据toString
		public static function objOneStr(obj:Object):String {
			var str:String 
			for (var prop:* in obj)
			{
				str = (String(obj[prop])); 
				break
			}
			return str
		}
		//获取一个变量的的toString
		public static function value2toString(obj:Object, value:String):String {
			var str:String="no data"
			if(obj[value]!=null)str = String(obj[value])
			return str
		}
	
		/**
		 * 合并数据 
		 * @param	source 数据源
		 * @param	value 新数据源
		 * @param	inBeing 是否覆盖
		 * @return
		 */
		public static function combinedData(source:Object,value:Object,inBeing:Boolean=true):Object {
			var key:*
			if (!inBeing) {
				for (key in value) source[key] = value[key];
			}else {
				for (key in value) {
					if(!source.hasOwnProperty(key)) source[key] = value[key];
				}
			}
			return source
		}
		/**
		 * 更新数据
		 * @param	source 数据源
		 * @param	value 要进行更新数据
		 * @param	inBeing 是否只对原有存在数据更新，false的话，源数据不存在值不更新
		 * @return
		 */
		public static function upData(source:Object, value:Object, inBeing:Boolean = true):Object {
			var key:*
			if (!inBeing) {
				for (key in value) source[key] = value[key];
			}else {
				for (key in value) {
					if(source.hasOwnProperty(key)) source[key] = value[key];
				}
			}
			return source
			
		}
		//复制一个对象
		public static function copyObj(obj:Object):Object {
			var newObj:Object = new Object()
			for (var prop:* in obj)
			{
				newObj[prop]=obj[prop]
			}
			return newObj
		}
		
	}
	
}