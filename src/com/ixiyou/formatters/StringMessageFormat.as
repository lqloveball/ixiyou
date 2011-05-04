package com.ixiyou.formatters
{
	/**
	 * 字符信息格式化
	 * @author Sean
	 * 
	 */	
	public class StringMessageFormat
	{
		//需要格式的样式
		private var template:String = "";
		/**
		 * 构造一个信息格式化对象
		 * @param template : String - 要格式化的字符模板
		 * @param locale : Locale -  区域 
		 */
		public function StringMessageFormat(template : String) {
			this.template = template;
		}
		
		/**
		 * 静态方法，格式化指定的字符
		 * @param template:String － 要格式化的字符模板
		 * @param result:Array - 格式化依据
		 */
		static public function formatSingle(template:String,what:Array,result:Array):String{
			return new StringMessageFormat(template).format(what,result);
		}
		
		/**
		 * 格式化指定的字符
		 * @param result:Array - 格式化依据
		 */
		public function format(what:Array,result:Array):String{
			var len:uint = what.length;
			if(len != result.length) return template;
			for (var i : uint = 0; i < len; i++) {
				template = template.split("{"+what[i]+"}").join(result[i]);
			}
			return template;
		}
	}
}