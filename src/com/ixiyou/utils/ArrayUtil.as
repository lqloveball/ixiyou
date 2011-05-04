package com.ixiyou.utils 
{
	/**
	 * 数组类
	 * @author spe
	 */
	public final class ArrayUtil
	{
		public static function randomArraySorty2(arr:Array):Array {
			var newArr:Array = new Array()
			while(arr.length>0){
				var item:Object = arr.splice((arr.length*Math.random())>>0,1)[0]
				newArr.push(item)
			}
			return newArr
		}
		/**
		 * 随机打乱数组
		 * @param	arr
		 * @return
		 */
		public static function randomArraySorty(arr:Array):Array {
			var length:int=arr.length+1
			arr.sort(sortRandom,0);
			return arr
		}
		/**
		 * 
		 * @param	length
		 * @return
		 */
		private static function sortRandom(length:int,length1:int):int {
			return Math.floor(Math.random()>.5?-1:1);
		}
		/**
		 * 是否包含指定属性值的对象
		  * @param	arr 数组
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @return 
		 */
		public static function inArrByProperty(arr:Array, property:String, value:*= null):Boolean{
			var result:Array = null
			var i:int
			for (i=0;i < arr.length;i++) 
			{
				var obj:Object =arr[i]
				if (obj.hasOwnProperty(property)) {
					if (value && obj[property] == value || value == null) {
						return true
					}
				}
			}
			return false
		}
		/**
		 * 
		 * 搜索指定属性值的对象
		 * @param	arr 数组
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @param	allBool 是否全部搜索
		 * @return  null为无数据,Array就是多数据
		 */
		public static function searchByProperty(arr:Array, property:String, value:*= null, allBool:Boolean = true):* {
			var result:Array = null
			var i:int
			for (i=0;i < arr.length;i++) 
			{
				var obj:Object =arr[i]
				if (obj.hasOwnProperty(property)) {
					if (value && obj[property] == value || value == null) {
						if (result == null) result = new Array()
						result.push(obj)
					}
				}
			}
			if (result && result.length > 0) {
				if (allBool) return result
				else return result[0]
			}else return result
		}
		/**
		 * 搜索数组中的数
		 * @param	arr
		 * @param	data
		 * @return
		 */
		public static function inArr(arr:Array, data:*):Boolean {
			var index:int;
			index = arr.indexOf(data);
			if (index != -1) return true
			else  return false
		}
		/**
		 * 从数组中删除指定对象
		 * @param obj	数组
		 * @param data	要删除的内容
		 * 
		 */		
		public static function remove(arr:Array,data:*):*
		{
			var index:int;
			index = arr.indexOf(data);
			if (index!=-1)
			var obj:*=	arr.splice(index, 1);
			return obj
		}
		//----------------------------以下方法来自 @author flashyiyi http://code.google.com/p/ghostcat/------------------//
		/**
		 * 将一个数组附加在另一个数组之后
		 * 
		 * @param arr	目标数组
		 * @param value	附加的数组
		 * 
		 */
		public function append(arr:Array,value:Array):void
		{
			arr.push.apply(null,value);
		}
		
		/**
		 * 获得两个数组的共用元素
		 * 
		 * @param array1	对象1
		 * @param array2	对象2
		 * 
		 */
		public static function hasShare(array1:Array,array2:Array):Array
		{
			var result:Array = [];
			for each (var obj:* in array1)
            {
                if (array2.indexOf(obj)!=-1)
                   	result.push(obj);
            }
            return result;
		}
		
		/**
		 * 获得数组中特定标示的对象
		 * 
		 * getMapping([{x:0,y:0},{x:-2,y:4},{x:4,y:2}],"x",-2) //{x:-2:y:4}(x = -2)
		 * getMapping([[1,2],[3,4],[5,6]],0,3) //[3,4](第一个元素为3)
		 *  
		 * @param arr	数组
		 * @param value	值
		 * @param field	键
		 * @return 
		 * 
		 */
		public static function getMapping(arr:Array, value:*, field:* = 0):Object
        {
            for (var i:int = 0;i<arr.length;i++)
            {
            	var o:* = arr[i];
            	
                if (o[field] == value)
                	return o[i];
            }
            return null;
        }
        
        /**
		 * 获得数组中某个键的所有值
		 * 
		 * getFieldValues([{x:0,y:0},{x:-2,y:4},{x:4,y:2}],"x")	//[0,-2,4]
		 *  
		 * @param arr	数组
		 * @param field	键
		 * @return 
		 * 
		 */
		public static function getFieldValues(arr:Array, field:*):Array
        {
        	var result:Array = [];
            for (var i:int = 0;i<arr.length;i++)
            {
            	var o:* = arr[i];
                result.push(o[field]);
            }
            return result;
        }
	}
}