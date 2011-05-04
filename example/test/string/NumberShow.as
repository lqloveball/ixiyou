package  
{
	import flash.display.Sprite;
	import com.ixiyou.utils.StringUtil
	/**
	 * 万位加分割
	 * @author spe email:md9yue@@q.com
	 */
	public class NumberShow extends Sprite
	{
		
		public function NumberShow() 
		{
			var num:Number = -12345678.888
			trace(StringUtil.addStrOn1000(num))
			return
			var zf:String = ''
			if (num < 0) {
				num = -num
				zf='-'
			}
			var fd:String=''
			if (num != num >> 0) {
				fd = '.'+String(num).split('.')[1]
				num=num>>0
			}
			var str:String = String(num)
			var newStr:String=''
			while (str.length> 0) {
				if (newStr == '') newStr = str.substring(str.length - 3, str.length)
				else newStr= str.substring(str.length - 3, str.length)+','+newStr
				str = str.substring(0, str.length - 3)
			}
			newStr=zf+newStr+fd
			trace(num+':'+newStr)
		}
		
	}

}