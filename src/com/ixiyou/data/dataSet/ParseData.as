package com.ixiyou.data.dataSet
{
	/**
	 * ...解析数据
	 * @author lcj
	 */
	public class ParseData 
	{
		public function ParseData() 
		{
		}
		/*
			解析从WebService(.net)接收到的DataTable对象 转换成Flash可认的DataTable对象
			例子:
			var dt:DataTable = ParseData.GetDataTable(result);
			for (var i:uint = 0; i < dt.Rows.length; i++)
			{
				trace(dt.Rows[i][0]);
				trace(dt.Rows[i][1]);
				trace(dt.Rows[i]["ID"]);
			}
		*/
		public static function GetDataTable(obj:Object):DataTable
		{
			var dt:DataTable = new DataTable();
			if (obj == null)
				return dt;
			var tableName:String = GetTableName(obj);
			dt.TableName = tableName;
			var l:uint;
			l = ObjectToArray(obj.Tables[tableName].Rows).length;
			for (var i:uint=0; i < l; i++ )
			{
				var row:DataRow = dt.NewRow();
				var cells:Array = ObjectToArray(obj.Tables[tableName].Rows[i]);
				for (var j:uint=0; j < cells.length; j++ )
				{
					var arr:Array = (cells[j] as String).split("♀");
					if (i == 0)
					{
						var c:DataColumn = new DataColumn();
						var dataType:String;
						if ((obj.Tables[tableName].Rows[i][arr[0]]) is String)
							dataType = "String";
						else if ((obj.Tables[tableName].Rows[i][arr[0]]) is int)
							dataType = "int";
						else if ((obj.Tables[tableName].Rows[i][arr[0]]) is Date)
							dataType = "Date";
						else if ((obj.Tables[tableName].Rows[i][arr[0]]) is Boolean)
							dataType = "Boolean";
						else if ((obj.Tables[tableName].Rows[i][arr[0]]) is Number)
							dataType = "Number";
						else if ((obj.Tables[tableName].Rows[i][arr[0]]) is uint)
							dataType = "uint";
						c.DataType = dataType;
						c.ColumnName = arr[0];
						dt.Columns.push(c);
					}
					row.SetValue(arr[0], arr[1]);
				}
				dt.Rows.push(row.array);
			}
			return dt;
		}
		//获取 TableName
		private static function GetTableName(obj:Object):String
		{
			return ObjectToString(obj.Tables);
		}
		//Object转成String
		private static function ObjectToString(obj:Object):String
		{
			var Str:String;
			for (var prop:* in obj)
			{ 
				if (prop is String)
				{
					Str = prop;
					break;
				}
			}
			return Str;
		}
		//Object转成Array
		private static function ObjectToArray(obj:Object):Array
		{
			var arr:Array = new Array();
			for (var prop:* in obj)
			{
				arr.push(prop+"♀"+obj[prop]);
			}
			return arr;
		}
		
		
	}
}