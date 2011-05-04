package com.ixiyou.data.dataSet
{
	/**
	 * 行对象
	 * @author lcj
	 */
	internal class DataRow
	{
		//行对象列的集合

		public var array:Array;
		public function DataRow()
		{
			array = new Array();
		}
		//设置列的值

		public function SetValue(id:String,obj:Object):void
		{
			array[id] = obj;
			array.push(obj);
		}
		public function push(obj:Object):uint
		{
			return this.push(obj);
		}
		public function get length () : uint
		{
			return array.length;
		}
		public function pop () : * 
		{
			return array.pop();
		}
		public function shift () : *
		{
			return array.shift();
		}
		public function sort () : *
		{
			return array.sort();
		}
		public function splice () : *
		{
			return array.splice();
		}
		
	}
}