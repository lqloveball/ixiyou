package com.ixiyou.data.dataSet
{
	/**
	 * ...DataTable对象
	 * @author lcj
	 */
	public class DataTable
	{
		//行集合

		public var Rows:Array;
		//列集合

		public var Columns:Array;
		private var tableName:String;
		public function DataTable()
		{ 
			Rows = new Array();
			Columns = new Array();
		}
		//增加一个新行

		public function NewRow():DataRow
		{
			var dr:DataRow = new DataRow();
			return dr;
		}
		//设置DataTable的名称

		public function set TableName(value:String):void
		{
			tableName = value;
		}
		//获取DataTable的名称

		public function get TableName():String
		{
			return tableName;
		}
		
	}
	
}