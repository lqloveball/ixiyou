package com.ixiyou.speUI.core 
{
	
	/**
	 * 列表组件接口 
	 * @author spe
	 */
	public interface IListBase 
	{
		/**
		 * 设置选中的数据
		 */
		function set select(value:Object):void
		function get select():Object
		/** 设置数据*/
		function set data(value:Array):void
		function get data():Array
		/**根据目前数据和样式绘制*/
		//function draw():void
		/**清空数据*/
		//function clear():void
		/**
		 * 插入数据
		 * @param	value 插入的数据
		 */
		function add(value:Object):void 
		/**
		 * 删除数据
		 * @param	value 删除指定数据
		 */
		function remove(value:Object):void
		/**
		 * 项的列表
		 */
		function get iteamArr():Array
		
		/**
		 * 设置数据的展现样式
		 */
		//function set iteamSkin(value:IListIteam):void
		//function get iteamSkin():IListIteam
		/**
		 * 作为表现的属性
		 */
		function set showProperty(value:String):void
		function get showProperty():String
		
	}
	
}