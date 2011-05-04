package  com.ixiyou.formatters
{
	/**
	 * 日期信息. 
	 * @author Sean
	 */	
	public class DateInfo
	{
		/**
		* 长的星期名称.
		 * @default ["Sunday", "Monday", "Tuesday", "Wednesday","Thursday", "Friday", "Saturday"]
		*/
		public var dayNamesLong:Array = ["Sunday", "Monday", "Tuesday", "Wednesday","Thursday", "Friday", "Saturday"];
		
		/**
		* 短的星期名称.
		 * @default  ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
		*/
		public var dayNamesShort:Array = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
		
		/**
		* 长的月份名称.
		 * @default ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
		*/
		public var monthNamesLong:Array = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		
		/**
		* 短的月份名称.
		 * @default ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct","Nov", "Dec"]
		*/
		public var monthNamesShort:Array = ["Jan", "Feb", "Mar", "Apr", "May", "Jun","Jul", "Aug", "Sep", "Oct","Nov", "Dec"];
		
		/**
		* 一天中的时间表示.
		 * @default ["AM", "PM"]
		*/
		public var timeOfDay:Array = ["AM", "PM"];
		
		/**
		* 日期名称.
		 * @default [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
		*/
		public var todayNames:Array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31];
		
		/**
		* 时间格式.
		*/
		public var time : String = "h:mm:ss A";
		
		/**
		* 长日期格式.
		*/
		public var dateLong:String = "EEEE, MMMM dd, YYYY";
		
		/**
		* 短日期格式.
		*/
		public var dateShort:String = "M/d/YYYY";
	}
}