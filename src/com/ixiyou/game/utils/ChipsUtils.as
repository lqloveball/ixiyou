package com.ixiyou.game.utils 
{
	/**
	 * 下注方面计算
	 * @author spe
	 */
	import com.ixiyou.utils.ObjectUtil
	public class ChipsUtils
	{
		/**
		 * 计算某面值有多少个
		 * @param	value   
		 * @param	arrStr 
		 * @return {chip:筹码面额, num:筹码个数, surplu:剩余 }
		 */
		public static function computeChips(value:uint, arrStr:String):Object {
			var i:uint 
			var temp:uint=0
			var obj:Object
			var arr:Array=arrStr.split(',')
			//计算出目前最大码
			for (i = arr.length-1 ; i >=0 ; i--) 
			{
				if (value >= uint(arr[i])) {
					temp = uint(arr[i]);
					break
				}
			}
			obj = {chip:temp, num:uint(value/ temp), surplu:(value % temp) }
			//trace(obj.chip,obj.num,obj.surplu)
			return obj
		}
		/**
		 * 找钱算法，制定面额需要找多少张分别不同的 从大到小
		 * @param	value
		 * @param	arrStr 默认'1,5,10,50,100,500,1000,5000,10000,50000,100000,500000'
		 * @return [{chip:筹码面额, num:筹码个数, surplu:剩余 },{chip:筹码面额, num:筹码个数, surplu:剩余 }]
		 */
		public static function getChips(value:uint, arrStr:String = '1,5,10,50,100,500,1000,5000,10000,50000,100000,500000'):Array {
			if(value==0)return []
			var arr:Array=new Array()
			var obj:Object = computeChips(value, arrStr)
			//trace(obj.num + '个:'+ obj.chip , '余:' + obj.surplu)
			arr.push(obj)
			while (obj.surplu != 0) { 
				obj = computeChips(obj.surplu, arrStr)
				arr.push(obj)
				//trace(obj.num + '个:'+ obj.chip , '余:' + obj.surplu)
			}
			//trace(ObjectUtil.ObjtoString(arr[0] as Object),ObjectUtil.ObjtoString(arr[1] as Object))
			return arr
		}
		/**
		 * 把Obj数据转换成Array
		 * @param	obj
		 * @return
		 */
		public static function dataToArr(obj:Object):Array {
			var arr:Array = new Array()
			if(!obj.num&& !obj.chip)return arr
			//[ num=1 chip=10 surplu=0 ]
			for(var i:int = 0; i < obj.num; i++) {
				arr.push(obj.chip)
			}
			return arr
		}
		/**
		 * 返回可直接使用的数据数组
		 * @param	value
		 * @return
		 */
		public static function getChipsArr(value:uint):Array {
			if(value==0)return new Array()
			var arr:Array = getChips(value)
			var MoneyArr:Array=new Array()
			for (var i:int = 0; i < arr.length; i++) {
				//trace(ObjectUtil.ObjtoString(arr[i]))
				//trace('ccc:'+i,arr[i].chip,arr[i].num,arr[i].surplu)
				//trace(ChipsUtils.dataToArr(arr[i]))
				MoneyArr=MoneyArr.concat(ChipsUtils.dataToArr(arr[i]))
			}
			return MoneyArr
		}
	}

}