package com.ixiyou.data.list 
{
	import com.ixiyou.data.collection.Collection;
	import com.ixiyou.data.ICollection;
	import com.ixiyou.data.IList;
	/**
	 * List 接口的大小可变的数组实现.
	 * @author wersling
	 * 
	 */	
	public class ArrayList extends Collection implements IList
	{
		/**
		 * 构造函数.
		 * @param args
		 * 
		 */		
		public function ArrayList(...args){
			super();
			if(args.length > 0)
				_items = new Array(args);
			else
				_items = new Array();
		}
		
		/**
		 * @inheritDoc 
		 * 在列表的指定位置插入指定元素（可选操作）.
		 */	
		public function addIn(o : Object, index : int) : Boolean {
			if(!o || index < 0) return false;
			if(index >= this.size()){
				_items.push(o);
				return true;
			}
			_items.splice(index,0,o);
			return true;
		}
		
		/**
		 * @inheritDoc 
		 * 返回列表中指定位置的元素.
		 */	
		public function Get(index : int) : Object {
			return _items[index];
		}
	
		/**
		 * @inheritDoc 
		 * 用指定元素替换列表中指定位置的元素（可选操作）.
		 */	
		public function Set(index : int, element : Object) : Array {
			 return _items.splice(index,1,element);
		}
		
		/**
		 * @inheritDoc 
		 * 返回列表中首次出现指定元素的索引，或者如果列表不包含此元素，则返回 -1.
		 */	
		public function indexOf(o : Object) : int {
			var l:Number = this.size();
			while (--l > -1 && this.Get(l) !== o){};
			return l;
		}
		
		/**
		 * @inheritDoc 
		 * -1。更正式地说，返回满足下面条件的最高索引 i：(o==null ? get(i)==null :o.equals(get(i)))，或者如果没有这样的索引，则返回 -1。 
		 */	
		public function lastIndexOf(o : Object) : int {
			var i:Number = _items.length;
			while(--i-(-1))
			{
				if(_items[i] === o) {
					return i;
				}
			}
			return -1;
		}
		
		/**
		 * 将数组中的元素转换为字符串、在元素间插入指定的分隔符、连接这些元素然后返回结果字符串。
		 * @param delimiter - 在返回字符串中分隔数组元素的字符或字符串。如果省略此参数，则使用逗号 (,) 作为默认分隔符。
		 * @return String
		 * @roseuid 43851E2503A9
		 */
		public function join(delimiter:String) : String
		{
			return _items.join(delimiter);
		}
		
		/**
		 * 删除数组中最后一个元素，并返回该元素的值。
		 * @return Object
		 * @roseuid 43851E730280
		 */
		public function pop() : Object
		{
			return _items.pop();
		}
		
		/**
		 * 将一个或多个元素添加到数组的结尾，并返回该数组的新长度。
		 * @param o
		 * @return uint
		 * @roseuid 43851EA503B9
		 */
		public function push(o:Object) : uint
		{
			return _items.push(o);
		}
		
		/**
		 * 在当前位置倒转数组。
		 * @return Array 返回一个新 Array
		 * @roseuid 43851EC6005D
		 */
		public function reverse() : Array
		{
			return _items.reverse();
		}
		
		/**
		 * 删除数组中第一个元素，并返回该元素。
		 * @return Object
		 * @roseuid 4385214900AB
		 */
		public function shift() : Object
		{
			return _items.shift();
		}
		/**
		 * 搜索出对象指定值相同数据的对象
		 * @param	value
		 * @param	data
		 * @return
		 */
		public function searchItem(value:String, data:*):ArrayList {
			var temp:Object
			var arr:Array=new Array()
			for (var i:int = 0; i < _items.length; i++) 
			{
				temp = _items[i]
				if (temp[value]) {
					if (temp[value] == data) arr.push(temp[value])
				}
			}
			return new ArrayList(arr);
		}
		/**
		 * 返回由原始数组中某一范围的元素构成的新数组，而不修改原始数组。
		 * @param startIndex	开始位置
		 * @param endIndex		结束位置
		 * @return ArrayList	由原始数组中某一范围的元素构成的新数组
		 * @roseuid 438521670157
		 */
		public function slice(startIndex:int, endIndex:int) : ArrayList
		{
			return new ArrayList(_items.slice(startIndex,endIndex));
		}
		
		/**
		 * 根据数组中的一个或多个字段对数组中的元素进行排序。数组应具有下列特性： 
		 * 
		 * 该数组是索引数组，不是关联数组。 
		 * 该数组的每个元素都包含一个具有一个或多个属性的对象。 
		 * 所有这些对象都至少有一个公用属性，该属性的值可用于对该数组进行排序。这样的属性称为 field。 
		 * 如果您传递多个 fieldName 参数，则第一个字段表示主排序字段，第二个字段表示下一个排序字段，依此类推。
		 * Flash 根据 Unicode 值排序。（ASCII 是 Unicode 的一个子集。）如果所比较的两个元素中的任何一个不包含在
		 *  fieldName 参数中指定的字段，则认为该字段为 undefined，并且在排序后的数组中不按任何特定顺序连续放置这
		 *  些元素。
		 * 
		 * 默认情况下，Array.sortOn() 按以下方式进行排序：
		 * 
		 * 排序区分大小写（Z 优先于 a）。 
		 * 按升序排序（a 优先于 b）。 
		 * 修改该数组以反映排序顺序；在排序后的数组中不按任何特定顺序连续放置具有相同排序字段的多个元素。 
		 * 数值字段按字符串方式进行排序，因此 100 优先于 99，因为 "1" 的字符串值比 "9" 的低。 
		 * Flash Player 7 添加了 options 参数，您可以使用该参数覆盖默认排序行为。若要对简单数组（例如，仅具有
		 * 一个字段的数组）进行排序，或要指定一种 options 参数不支持的排序顺序，请使用 Array.sort()。
		 * 
		 * 若要传递多个标志，请使用按位"或"(|) 运算符分隔它们
		 * @param fieldName - 一个标识要用作排序值的字段的字符串，或一个数组，其中的第一个元素表示主排序字段，
		 * 第二个元素表示第二排序字段，依此类推。
		 * 
		 * @param options - [可选] - 所定义常数的一个或多个数字或名称，相互之间由 bitwise OR (|) 运算符隔开，
		 * 它们可以更改排序行为。options 参数可接受以下值： 
		 * 
		 * Array.CASEINSENSITIVE 或 1 
		 * Array.DESCENDING 或 2 
		 * Array.UNIQUESORT 或 4 
		 * Array.RETURNINDEXEDARRAY 或 8 
		 * Array.NUMERIC 或 16 
		 * 如果您使用标志的字符串形式（例如，DESCENDING），而不是数字形式 (2)，则启用代码提示。
		 * @return ArrayList 返回值取决于是否传递任何参数： 
		 * 			如果您为 options 参数指定值 4 或 Array.UNIQUESORT，并且要排序的两个或多个元素具有相
		 * 	同的排序字段，则返回值 0 并且不修改数组。 
		 * 			如果为 options 参数指定值 8 或 Array.RETURNINDEXEDARRAY，则返回反映排序结果的数组并且不修改数组。
		 * 			否则，不返回任何结果并修改该数组以反映排序顺序。
		 * @roseuid 438523B003C8
		 */
		public function sortOn(fieldName:Object,options:Object = null) : ArrayList
		{
			return new ArrayList(_items.sortOn(fieldName,options));
		}
		
		/**
		 * 给数组添加元素以及从数组中删除元素。此方法会修改数组但不制作副本。
		 * @param startIndex - 一个整数，它指定插入或删除动作开始处的数组中元素的索引。
		 * 您可以指定一个负整数来指定相对于数组结尾的位置（例如，-1 是数组的最后一个元素）。
		 * @param deleteCount - [可选] - 一个整数，它指定要删除的元素数量。该数量包括 startIndex 参数中指定的元素。
		 * 如果没有为 deleteCount 参数指定值，则该方法将删除从 startIndex 元素到数组中最后一个元素之间的所有值。
		 * 如果该参数的值为 0，则不删除任何元素。
		 * @param value - [可选] - 指定要在 startIndex 参数中指定的插入点处插入到数组中的值。
		 * 
		 * @return net.manaca.data.list.ArrayList
		 * @roseuid 438524360280
		 */
		public function splice(startIndex:int,deleteCount:int,value:Object) : Array
		{
			return _items.splice(startIndex,deleteCount,value);
		}
		
		/**
		 * 将一个或多个元素添加到数组的开头，并返回该数组的新长度。
		 * @param o - 一个或多个要插入到数组开头的数字、元素或变量。
		 * @return Number
		 * @roseuid 438524A501F3
		 */
		public function unshift(o:Object) : uint
		{
			return _items.unshift(o);
		}
		
	}
}