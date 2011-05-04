package com.ixiyou.utils
{
	
	/**
	* 数字操作
	* @author spe
	*/
	public class NumberUtil 
	{
		//var f:Number = 0.30000000000000004
		//f.toFixed(1)        //四舍五入,可返回指定位数的Number类型
		//Math.round(f)        //四舍五入,只返回无小数的Number类型
		//Math.ceil(f)        //向上取整,只返回无小数的Number类型
		//Math.floor(f)        //向下取整,只返回无小数的Number类型 

		/*取最大小数 0.0999999998--->0.09
		*
		*/
		public static function maxNumber(num:Number):Number {
			var jie:String
			var srcStr:String = num.toString()
			var dotPos:uint = srcStr.indexOf(".");
			//var dotPos1:uint = srcStr.lastIndexOf("0");
			jie = srcStr.slice(0, dotPos)
			var dotStr:String = srcStr.slice(dotPos + 1)
			var arr:Array = dotStr.split("")
			var w:String = ""
			for (var i:uint = 0; i < arr.length; i++ ) {
				 w+=arr[i]
				if(Number(arr[i])>0)break
			}
			jie = jie + "." + w
			return Number(jie)
		}
		/*取最大小数 0.0999999998--->0.1
		*
		*/
		public static function maxNumber2(num:Number):Number {
			var jie:String
			var srcStr:String = num.toString()
			var dotPos:uint = srcStr.indexOf(".");
			//var dotPos1:uint = srcStr.lastIndexOf("0");
			jie = srcStr.slice(0, dotPos)
			var dotStr:String = srcStr.slice(dotPos + 1)
			var arr:Array = dotStr.split("")
			var w:String = ""
			var w2:uint=0
			for (var i:uint = 0; i < arr.length; i++ ) {
				 w+=arr[i]
				if (Number(arr[i]) > 0) {
					if( i < arr.length-1)w2=uint(arr[i+1])
					break
				}
			}
			if (w2 >= 5) jie = jie + "." + (Number(w) + 1)
			else jie = jie + "."+w 
			
			return Number(jie)
		}
		/*数字保留小数点后位数处理
		*1.00102  ,3---->1.001
		*/
		public static function FormatNumber1(num:Number,nAfterDot:int=0x7FFFFFFF):Number
		{
			var jie:String
			var srcStr:String = num.toString()
			var dotPos:uint = srcStr.indexOf(".");
			jie = srcStr.slice(0, dotPos)
			var dotStr:String = srcStr.slice(dotPos + 1)
			if(dotStr.length>=nAfterDot)dotStr=dotStr.slice(0,nAfterDot)
			jie=jie+"."+dotStr
			return Number(jie)
		}
		/*计算有几位小数
		*
		*/
		public static function dotNum(num:Number):uint {
			var srcStr:String = num.toString()
			var dotPos:uint = srcStr.indexOf(".");
			var jie:String
			jie = srcStr.slice(dotPos+1)
			return jie.length
		}
		/*数字保留小数点后位数处理 带四舍五入
		*
		*/
		public static function FormatNumber3(num:Number,nAfterDot:int):Number
		{
			var jie:String
			var srcStr:String = num.toString()
			var dotPos:uint = srcStr.indexOf(".");
			jie = srcStr.slice(0, dotPos)
			var dotStr:String = srcStr.slice(dotPos + 1)
			if (dotStr.length >= nAfterDot) dotStr = dotStr.slice(0, nAfterDot)
			
			
			var dotStr2:uint = uint(srcStr.slice(dotPos +nAfterDot + 1, dotPos +nAfterDot + 2)) 
			
			if (dotStr2 * 2 >= 10) { 
			
				jie=jie+"."+(Number(dotStr)+1)
			}
			else {
				jie=jie+"."+dotStr
			}
			return Number(jie)
		}
		/*数字取小数点后位数处理
		*1.777--->0.777
		*/
		public static function FormatNumber2(num:Number,nAfterDot:int=0x7FFFFFFF):Number
		{
			var jie:String
			var srcStr:String = num.toString()
			var dotPos:uint = srcStr.indexOf(".");
			var dotStr:String = srcStr.slice(dotPos + 1)
			if(dotStr.length>=nAfterDot)dotStr=dotStr.slice(0,nAfterDot)
			jie="0."+dotStr
			return Number(jie)
		}
		/*计算出位数 负数负数位
		*1个位 2十位 3百位 4千位........
		*/
		public static function tenNum(num:Number):int {
			num=Math.abs(num)
			var jie:String
			var srcStr:String = num.toString()
			var dotPos:uint = srcStr.indexOf(".");
			var dotStr:String
			if (dotPos != -1) dotStr= srcStr.slice(0, dotPos)
			else dotStr = srcStr
			if (dotStr.length == 1 && dotStr == "0") return 0
			else return dotStr.length
		}
		/*计算出位数值 负数负数位 -257.3333 --->2
		*1个位 2十位 3百位 4千位........
		*/
		public static function tenNumToNum(num:Number):uint {
			num=Math.abs(num)
			var jie:String
			var srcStr:String = num.toString()
			var dotPos:uint = srcStr.indexOf(".");
			var dotStr:String
			if (dotPos != -1) dotStr= srcStr.slice(0, dotPos)
			else dotStr = srcStr
			return Number(dotStr.slice(0, 1))
		}
		/*整5 整10 整1 整个0就代表不能整
		*
		*/
		public static function zhengNum(num:uint):uint {
			if (num > 10) num = 10
			if(num <0) num = 0
			if(num==0||num==1)return 1
			if (num == 4 || num == 5 || num == 6) return 5
			if (num == 9 || num == 10) return 10
			if (num == 2 || num == 3 || num == 8 || num == 7) return 0
			return 0
		}
		/*有整成最大数
		*整10001---->10000   15001---->20000
		*/
		public static function zhengMax(num:Number):uint {
			if (uint(num) < num) num = uint(num) + 1
			var w:uint = tenNum(num)
			if (w > 1) {
				var i:uint 
				for (i = 0; i < w - 1; i++ ) {
					num=num/10
				}
				//if (uint(num) == num) return num
				if (FormatNumber2(num,0x7FFFFFFF) * 2 >= 1) num = uint(num) + 1
				else num = uint(num)
				for (i = 0; i < w - 1; i++ ) {
					num=num*10
				}
				return num
			}else {
				return num
			}
		}
		/*有整成最大数
		*整10001---->20000   15001---->20000
		*/
		public static function zhengMax2(num:Number):uint {
			if (uint(num) < num) num = uint(num) + 1
			var w:uint = tenNum(num)
			if (w > 1) {
				var i:uint 
				for (i = 0; i < w - 1; i++ ) {
					num=num/10
				}
				if (uint(num) != num)  num = uint(num)+1
				
				for (i = 0; i < w - 1; i++ ) {
					num=num*10
				}

				return num
			}else {
				return num
			}
		}
		/*判断是否有带小数点
		*
		*/
		public static function dotBool(num:Number):Boolean
		{
			var srcStr:String = num.toString()
			var dotPos:int = srcStr.indexOf(".");
			if (dotPos != -1) return true
			else return false
		}
		/**
		 * ----------------------------------------------------- 处理文本与数字有关的部分 以下算法来自
		 * http://code.google.com/p/ghostcat/
		 * 
		 */
		/**
		 * 将日期转换为字符串
		 * 
		 * @param date	日期
		 * @param format	日期格式（yyyy-mm-dd,yyyy-m-d,yyyy年m月d日,Y年M月D日）
		 * @return 转换完毕的字符串
		 * 
		 */		
		public static function toDateString(date:Date,format:String=""):String
		{
			var y:int = date.fullYear;
			var m:int = date.month;
			var d:int = date.date;
			
			switch (format){
				case "yyyy-mm-dd":
					return y +"-" + fillZeros(m.toString(),2) + "-" + fillZeros(d.toString(),2);
					break;
				case "yyyy-m-d":
					return y +"-" + m +"-" + d;
					break;
				case "yyyy年m月d日":
					return y +"年" + m +"月" + d + "日";
					break;
				case "Y年M月D日":
					return toChineseNumber(y) +"年" + toChineseNumber(m) +"月" + toChineseNumber(d) + "日";
					break;
			}
			return date.toString();
		}
		
		/**
		 * 将时间转换为字符串
		 * 
		 * @param date	日期
		 * @param format	时间格式（hh:mm:ss，h:m:s，hh:mm:ss:ss.s，h:m:s:ss.s，h小时m分钟s秒，H小时M分钟S秒）
		 * @return 转换完毕的字符串
		 * 
		 */		
		public static function toTimeString(date:Date,format:String=""):String
		{
			var h:int = date.hours;
			var m:int = date.minutes;
			var s:int = date.seconds;
			var ms:Number = date.milliseconds/10;
			
			switch (format){
				case "hh:mm:ss":
					return fillZeros(h.toString(),2) + ":" + fillZeros(m.toString(),2) + ":" + fillZeros(s.toString(),2);
					break;
				case "h:m:s":
					return h + ":" + m + ":" + s;
					break;
				case "hh:mm:ss:ss.s":
					return fillZeros(h.toString(),2) + ":" + fillZeros(m.toString(),2) + ":" + fillZeros(s.toString(),2) + ":" + ms.toFixed(1);
					break;
				case "h:m:s:ss.s":
					return h + ":" + m + ":" + s + ":" + ms.toFixed(1);
					break;
				case "h小时m分钟s秒":
					return h + "小时" + m + "分钟" + s + "秒";
					break;
				case "H小时M分钟S秒":
					return toChineseNumber(h) + "小时" + toChineseNumber(m) + "分钟" + toChineseNumber(s) + "秒";
					break;
			}
			return date.toString();
		}
		
		private static const chineseMapping:Array = ["","一","二","三","四","五","六","七","八","九"];
		private static const chineseLevelMapping:Array = ["","十","百","千"]
		private static const chineseLevel2Mapping:Array = ["","万","亿","兆"]
		
		/**
		 * 转换为汉字数字
		 * 
		 */		
		public static function toChineseNumber(n:int):String
		{
			var result:String = "";
			var level:int = 0;
			while (n > 0)
			{
				var v:int = n % 10;
				if (level % 4 ==0)
					result = chineseLevel2Mapping[level / 4] + result;
				
				if (v > 0)
				{
					if (level % 4 == 1 && v == 1){
						result = chineseLevelMapping[level % 4] + result;
					}else{
						result = chineseMapping[v] + chineseLevelMapping[level % 4] + result;
					}
				}
				else
				{
					result = chineseMapping[v] + result;
				}
				n = n / 10;
				level++;
			}
			
			return result;
		}
		
		private static const punctuationMapping:Array = [[",",".",":",";","?","\\","\/","[","]","`"],
			["，","。","：","；","？","、","、","【","】","·"]]
		
		public static function toChinesePunctuation(v:String,m1:Boolean = false,m2:Boolean = false):String
		{
			var result:String = "";
			for (var i:int = 0;i<v.length;i++)
			{
				var ch:String = v.charAt(i);
				if (ch == "'")
				{
					m1 = !m1;
					result += m1?"‘":"’";
				}
				else if (ch == "\"")
				{
					m2 = !m2;
					result += m2?"“":"”";
				}
				else
				{
					var index:int = (punctuationMapping[0] as Array).indexOf(v.charAt(i));
					if (index != -1)
						result += punctuationMapping[1][index];
					else
						result += v.charAt(i);
				}
			}
			return result;
		}
		
		/**
		 * 在数字中添加千位分隔符
		 * 
		 */		 	
		public static function addNumberSeparator(value:int):String
		{
			var result:String = "";
			while (value >= 1000)
			{
				var v:int = value % 1000;
				result =  "," + fillZeros(v.toString(),3) + result;
				value = value / 1000;
			}
			return result = String(value) + result;
		}
		
		/**
		 * 将数字用0补足长度
		 * 
		 */		
		public static function fillZeros(str:String, len:int, flag:String="0"):String
		{
			while (str.length < len) 
			{
				str = flag + str;
			}
			return str;
		}
	}
	
}