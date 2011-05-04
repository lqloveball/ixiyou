package com.ixiyou.speUI.core
{

	
	/**
	 * 选择组合控件接口,做下拉列表的按钮这样类似的功能
	 * @author spe
	 */
	public interface IMComboBase
	{
		
		/**
		 * 所选项目的数据提供程序中的索引
		 */
		function get selectedIndex():int
		/**
		 * 位于 selectedIndex 处的数据提供程序中的项目
		 */
		function get selectedIteam():Object
		/**
		 * 位于 selectedIndex 处的数据提供程序中的项目
		 */
		function get value():Object
		/**
		 * 作为表现的属性
		 */
		function set showProperty(value:String):void
		/**
		 * 作为表现的属性
		 */
		function get showProperty():String
	}

}