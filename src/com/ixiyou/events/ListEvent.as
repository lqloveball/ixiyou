package com.ixiyou.events 
{
	
	/**
	 * 列表组件事件
	 * @author spe
	 */
	import flash.events.Event;
	import com.ixiyou.speUI.core.IListIteam
	public class ListEvent extends Event
	{
		/**
		 * 删除数据
		 */
		public static const REMOVE_DATA:String = "removeData";
		/**
		 *删除所有数据
		 */
		public static const REMOVE_AllDATA:String='removeAllData'
		/**
		 * 添加数据
		 */
		public static const ADD_DATA:String = "addData";
		/**
		 * 添加全部数据
		 */
		public static const ADD_ALLDATA:String="addAllData"
		/**
		 * 选择数据更新
		 */
		public static const UPSELECT:String = "upSelect"
		/*
		 * 选择中数据或添加数据
		 */
		public var data:*;
		public function ListEvent(type:String, bubbles:Boolean = false,cancelable:Boolean = false,
								    data:* = null) 
		{
			super(type, bubbles, cancelable);
			this.data = data
		}
		
	}
	
}