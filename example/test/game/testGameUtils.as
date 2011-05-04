package  
{
	
	
	/**
	 * ...
	 * @author ...
	 */
	import flash.display.Sprite;
	import com.ixiyou.game.utils.ChipsUtils
	import com.ixiyou.utils.ObjectUtil
	public class testGameUtils extends Sprite
	{
		
		public function testGameUtils() 
		{
			//trace(ChipsUtils.getChips(4772223))
			var arr:Array = ChipsUtils.getChips(10)
			for (var i:int = 0; i < arr.length; i++) 
			{
				trace(ObjectUtil.ObjtoString(arr[i]))
			}
			trace(zxh_result(6))
		}
		private function getResult(value:uint):uint {
			if(value>=20)value=value-20
			return value
		}
		/**
		 * 结果换算
		 * @param	value 0庄，1庄 庄对 ，2庄 闲对 ，3庄 双对，4闲，5闲 庄对 ，6闲 闲对 7闲 双对，8和 ，9和 庄对 ，10和 闲对 11和 双对
		 * @return 0庄，1闲，2和(不加20的情况下)
		 */
		private function zxh_result(value:uint):uint {
			return getResult(value)/4>>0
		}
	}

}