package com.ixiyou.data.iterator 
{
	import com.ixiyou.data.Iterator;
	import com.ixiyou.data.ICollection;
	/**
	 * 实现对集合进行迭代的迭代器. 
	 * @author Sean
	 * 
	 */	
	public class Iteratorimpl implements Iterator
	{
		private var _collection : ICollection;

		private var _cursor : Number;
		
		/**
		 * 构造函数
		 * @param 无
		 */
		public function Iteratorimpl() {
		}
		
		/**
		 * 初始化.
		 * @param c
		 * 
		 */		
		public function init(c:ICollection):void{
			_collection = c;
			_cursor = 0;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function hasNext() : Boolean {
			return (_cursor < _collection.size());
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function next() : Object {
			return(_collection.getItemAt(_cursor++));
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function remove() : void {
			_collection.toArray().pop();
		}
	}
}