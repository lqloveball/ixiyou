package com.ixiyou.data 
{
	/**
	 * History 是一个保存和操作历史记录的对象,可以通过前进、后退、添加等操作来控制记录的指针.
	 * @author Sean
	 * @version 1.0
	 */	
	public class History
	{
		private var maxNum:uint;
		private var finger:int;
		private var _items:Array;
		/**
		 * 构造函数.
		 * @param max 允许保存的最大记录数，默认100
		 * @return 
		 * 
		 */		
		public function History(max:uint = 100){
			maxNum = max;
			finger = -1;
			_items = new Array();
		}
		
		/**
		 * 将一个记录压入集合，并返回当前指针位置.
		 * @param o 一个记录
		 * @return 当前指针位置
		 * 
		 */		
		public function push(o:Object):int{
			//如果指针在集合中间，则删除指针之后的记录
			if(finger < this.size()-1){
				_items.splice(finger+1);
			}
			//添加记录到最后
			_items.push(o);
			//如果集合长度超过最大记录数，则删除第一个元素
			if(_items.length > maxNum){
				_items.shift();
			}
			
			//将指针设置到集合最后面
			finger = _items.length - 1;
			
			return finger;
		}
		
		/**
		 * 是否存在上一个记录.
		 * @return 如果存在，则返回true,否则返回false.
		 * 
		 */		
		public function hasBack():Boolean{
			return finger > -1 && this.size() >= 1;
		}
		
		/**
		 * 是否存在下一个记录.
		 * @return 如果存在，则返回true,否则返回false
		 * 
		 */		
		public function hasNext():Boolean{
			return this.size() >= 1 && finger < this.size()-1;
		}
		
		/**
		 * 尝试将指针上移一个记录，并返回移动之前的记录.
		 * @return 
		 * 
		 */		
		public function back():Object{
			if (hasBack()) {
				return getItemByIndex(--finger);
			}else{
				return null;
			}
		}
		
		/**
		 * 尝试将指针下移一个记录，并返回移动之后的记录.
		 * @return 
		 * 
		 */		
		public function next():Object{
			if (hasNext()) {
				return getItemByIndex(++finger);
			}else{
				return null;
			}
		}
		/**
		 * 返回当前集合的大小.
		 * @return 当前集合的大小
		 * 
		 */		
		public function size():uint{
			return _items.length;
		}
		
		/**
		 * 返回所有历史记录集合.
		 * @return 历史记录集合
		 * 
		 */		
		public function toArray():Array{
			return _items;
		}
		
		/**
		 * 删除所有记录集.
		 * 
		 */		
		public function clear():void{
			finger = -1;
			_items = new Array();
		}
		
		/**
		 * 尝试获取指定位置的记录.
		 * @param index 指定的位置.
		 * @return 如果存在，则返回，否则返回null
		 * 
		 */		
		private function getItemByIndex(index:uint):Object{
			return _items[index];
		}
	}
}