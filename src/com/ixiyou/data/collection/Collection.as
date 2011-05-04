package com.ixiyou.data.collection 
{
	import com.ixiyou.data.ICollection;
	import com.ixiyou.data.Iterator;
	import com.ixiyou.data.iterator.Iteratorimpl;
	/**
	 * 此类提供了 Collection 接口的骨干实现，从而最大限度地减少了实现此接口所需的工作. 
	 * 
	 * 要实现一个不可修改的 collection，程序员只需扩展此类，并提供 iterator 和 size 方法的实现。
	 * （iterator 方法返回的迭代器必须实现 hasNext 和 next。）
	 * 
	 * 要实现可修改的 collection，程序员还必须另外重写此类的 add 方法
	 * （否则，会抛出 UnsupportedOperationException），并且 iterator 方法返回的迭代器必须另外实现其 remove 方法。
	 * 
	 * 按照 Collection 接口规范中的推荐，程序员通常应该提供一个 void （无参数）和 Collection 构造方法。
	 * 
	 * 此类中每个非抽象方法的文档详细描述了其实现。如果要实现的 collection 允许更有效的实现，则可以重写这些方法中
	 * 的每个方法。
	 * @author Sean
	 * 
	 */	
	public class Collection implements ICollection
	{
		protected var _items : Array;
		/**
		 * 实例化Collection
		 * @roseuid 4382E72903D8
		 */
		public function Collection(...args)
		{
			if(args.length > 0)
				_items = new Array(args);
			else
				_items = new Array();
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function add(o : Object) : uint {
			return _items.push(o);
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function remove(o : Object) : uint {
			var result : int = -1;
			var itemIndex : int = internalGetItem(o);
			if (itemIndex > -1) {
				_items.splice(itemIndex,1);
				result = itemIndex;
			}
			return(result);
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function contains(o : Object) : Boolean {
			return(internalGetItem(o) > -1);
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function containsAll(c : ICollection) : Boolean {
			//如果大小都不对，肯定是 False
			if(this.size() < c.size()) return false;
			var result:Boolean = true;
			var i:Number = c.size();
			var _iterator:Iterator = c.iterator();
			while(--i-(-1)){
				if(!contains(_iterator.next())){
					result = false;
					break;
				}
			}
			return result;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function addAll(c : ICollection) : uint {
			if(c.isEmpty()) return 0;
			_items = _items.concat(c.toArray());
			return _items.length;
		}
	
		/**
		 * @inheritDoc 
		 */	
		public function removeAll(c : ICollection) : Boolean {
			if(c.isEmpty()) return false;
			var result:Boolean = false;
			var i:Number = c.size();
			var _iterator:Iterator = c.iterator();
			while(--i-(-1)){
				if(remove(_iterator.next())){
					result = true;
				}
			}
			return result;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function retainAll(c : ICollection) : Boolean {
			if(c.isEmpty()){ 
				clear();
				return true;
			}
			var result:Boolean = false;
			var i:Number = this.size();
			while(--i-(-1)){
				if(!c.contains(_items[i])){
					_items.splice(i,1);
					result = true;
				}
			}
			return (result);
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function clear() : void {
			_items = new Array();
		}
	
		/**
		 * @inheritDoc 
		 */	
		public function equals(o : Object) : Boolean {
			var result:Boolean = true;
			var _o:Collection = Collection(o);
			var i:Number = this.size();
			while(--i-(-1)){
				if(!_o.contains(_items[i])){
					result = false;
					break;
				}
			}
			return result;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function isEmpty() : Boolean {
			return ( _items.length == 0 );
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function size() : int {
			return _items.length;
		}
	
		/**
		 * @inheritDoc 
		 */	
		public function toArray() : Array {
			return _items;
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function iterator() : Iterator {
			var _iter:Iteratorimpl = new Iteratorimpl();
			_iter.init(this);
			return (_iter);
		}
		
		/**
		 * @inheritDoc 
		 */	
		public function getItemAt(i : int) : Object {
			return (_items[i]);
		}
		
		/** 
		 * 返回元素所在编号
		 * @param item 一个元素
		 * @return Number 元素所在编号
		 */
		private function internalGetItem(item:Object):int {
			var result:int = -1;
			var i:int = _items.length;
			while(--i-(-1)){
				if (_items[i] == item) {
					result = i;
					break;
				}
			}
			return result; 
		}
		
	}
}