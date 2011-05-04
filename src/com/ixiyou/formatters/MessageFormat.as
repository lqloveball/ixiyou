package com.ixiyou.formatters
{
	/**
	 * 信息格式化对象
	 * @author wersling
	 * 
	 */	
	public class MessageFormat
	{
		//需要格式的样式
		private var template:String = "";
		/**
		 * 构造一个信息格式化对象
		 * @param template : String - 要格式化的字符模板
		 * @param locale : Locale -  区域 
		 */
		public function MessageFormat(template : String) {
			this.template = template;
		}
		
		/**
		 * 静态方法，格式化指定的字符
		 * @param template:String － 要格式化的字符模板
		 * @param result:Array - 格式化依据
		 */
		static public function formatSingle(template:String,result:Array):String{
			return new MessageFormat(template).format(result);
		}
		
		/**
		 * 格式化指定的字符
		 * @param result:Array - 格式化依据
		 */
		public function format(result:Array):String{
			var len:uint = result.length;
			for (var i : uint = 0; i < len; i++) {
				template = template.split("{"+i+"}").join(result[i]);
			}
			return template;
		}
	}
}