package com.ixiyou.data.dataSet
{
	/**
	 * ...列对象

	 * @author lcj
	 */
	internal class DataColumn
	{
		private var dataType:String;
		//设置列的数据类型
		public function set DataType (val:String) : void
		{
			dataType = val;
		}
		//获取列的数据类型
		public function get DataType () : String
		{
			return dataType;
		}
		private var columnName:String;
		//设置列的名称
		public function set ColumnName(val:String):void
		{
			columnName = val;
		}
		//获取列的名称
		public function get ColumnName():String
		{
			return columnName;
		}
		public var defaultValue:Object;
		//设置列的默认的值

		public function set DefaultValue(val:Object):void
		{
			defaultValue = val;
		}
		//获取列的默认的值

		public function get DefaultValue():Object
		{
			return defaultValue;
		}
	}
	
}