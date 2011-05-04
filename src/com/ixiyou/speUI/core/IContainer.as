package com.ixiyou.speUI.core 
{
	
	/**
	 * 容器接口
	 * 有内部对其方式
	 * @author ...
	 */
	public interface IContainer 
	{
		/**设置容器对齐方式*/
		function setLayout(value:String):void 
		/**容器内部对齐方式*/
		function get nLayout():LayoutMode
		/**执行对内部元素布局*/
		function layoutChilds():void;
		/**纵向间隔*/
		function get verticalGap():Number;
		/**横向间隔*/
		function get horizontalGap():Number;
		/**纵向对齐*/
		function get verticalAlign():String;
		/**横向对齐*/
		function get horizontalAlign():String;
	}
	
}