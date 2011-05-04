package com.ixiyou.events 
{
	/**
	 * 选择时间
	 * @author spe
	 */
	import flash.events.Event;
	public class SelectEvent extends Event
	{
		
		//选择更新 不区分是取消还是选择
		public static const UPSELECT:String = 'upSelect';
		//选择 默认的Event选择是select
		public static const SELECT:String = 'Select';
		//取消选择
		public static const RESELECT:String = 'ReSelect';
		//选择更新 提供给event类型的的选择更新字符索引
		public static const UP_SELECT:String = 'DataUpSelect'
		
		//更新带的数据
		public  var data:*
		public  var select:Boolean
		public function SelectEvent(type:String,data:*=null,select:Boolean=false,bubbles:Boolean = false,cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
			this.select = select;
		}
		
	}

}