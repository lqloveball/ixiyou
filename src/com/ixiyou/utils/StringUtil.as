package com.ixiyou.utils
{
	
	/**
	* 字符操作
	* @author spe
	*/

	import flash.utils.ByteArray;
	public class StringUtil
	{
        public static function addStrOn1000(num:Number, value:String=','):String {
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
				else newStr= str.substring(str.length - 3, str.length)+value+newStr
				str = str.substring(0, str.length - 3)
			}
			//trace(num,zf,newStr,fd)
			newStr = zf + newStr + fd
			return newStr
		}
       /**
		 * 计算密码强度 
		 * @param pw
		 * @return 
		 * 
		 */
		public static function evaluatePwd(pw:String):int
		{ 
			return pw.replace(/^(?:([a-z])|([A-Z])|([0-9])|(.)){5,}|(.)+$/g,"$1$2$3$4$5").length;
		}
		/**
		 * 忽略大小字母比较字符是否相等;
		 * @param	char1
		 * @param	char2
		 * @return
		 */
        public static function equalsIgnoreCase(char1:String,char2:String):Boolean{
            return char1.toLowerCase() == char2.toLowerCase();
        }
		/**
		 *转小写 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function toLocaleLowerCase(value:String):String{return value.toLocaleLowerCase()}
		/**
		 *转大写 
		 * @param value
		 * @return 
		 * 
		 */		
		public static function toLocaleUpperCase(value:String):String{return value.toLocaleUpperCase()}
		/**
		 * 比较字符是否相等;
		 * @param	char1
		 * @param	char2
		 * @return
		 */
        public static function equals(char1:String,char2:String):Boolean{
            return char1 == char2;
        }
        
        /**
         * 是否为Email地址;
         */
        public static function isEmail(char:String):Boolean{
            if(char == null){
                return false;
            }
            char = String(trim(char));
            var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/; 
            var result:Object = pattern.exec(char);
            if(result == null) {
                return false;
            }
            return true;
        }
		/**
		 * 是否是数值字符串;
		 * @param	char
		 * @return
		 */
        public static function isNumber(char:String):Boolean{
            if(char == null){
                return false;
            }
            return !isNaN(Number(char))
        }
         /**
         * 检测是否是数字
         * 
         * @param text
         * @param digits	指定小数位
         * @return 
         * @author flashyiyi
         */
        public static function isNumber2(text:String,digits:int = -1):Boolean
        {
        	if (digits > 0)
        		return new RegExp("^-?(\\d|,)*\\.\\d{"+digits.toString()+"}$").test(text);
        	else
        		return (/^-?(\d|,)*[\.]?\d*$/).test(text);
        }
        //是否为Double型数据;
        public static function isDouble(char:String):Boolean{
            char = trim(char);
            var pattern:RegExp = /^[-\+]?\d+(\.\d+)?$/; 
            var result:Object = pattern.exec(char);
            if(result == null) {
                return false;
            }
            return true;
        }
       
		/**
		 * Integer;
		 * @param	char
		 * @return
		 */
        public static function isInteger(char:String):Boolean{
            if(char == null){
                return false;
            }
            char = trim(char);
            var pattern:RegExp = /^[-\+]?\d+$/; 
            var result:Object = pattern.exec(char);
            if(result == null) {
                return false;
            }
            return true;
        }
		/**
		 * English;
		 * @param	char
		 * @return
		 */
        public static function isEnglish(char:String):Boolean{
            if(char == null){
                return false;
            }
            char = trim(char);
            var pattern:RegExp = /^[A-Za-z]+$/; 
            var result:Object = pattern.exec(char);
            if(result == null) {
                return false;
            }
            return true;
        }
		/**
		 * 中文;
		 * @param	char
		 * @return
		 */
        public static function isChinese(char:String):Boolean{
            if(char == null){
                return false;
            }
            char = trim(char);
            var pattern:RegExp = /^[\u0391-\uFFE5]+$/; 
            var result:Object = pattern.exec(char);
            if(result == null) {
                return false;
            }
            return true;
        }
        /**
         * 双字节
         * @param	char
         * @return
         */
        public static function isDoubleChar(char:String):Boolean{
            if(char == null){
                return false;
            }
            char = trim(char);
            var pattern:RegExp = /^[^\x00-\xff]+$/; 
            var result:Object = pattern.exec(char);
            if(result == null) {
                return false;
            }
            return true;
        }
		/**
		 * 含有中文字符
		 * @param	char
		 * @return
		 */
        public static function hasChineseChar(char:String):Boolean{
            if(char == null){
                return false;
            }
            char = trim(char);
            var pattern:RegExp = /[^\x00-\xff]/; 
            var result:Object = pattern.exec(char);
            if(result == null) {
                return false;
            }
            return true;
        }
		/**
		 * 注册字符;
		 * @param	char
		 * @param	len
		 * @return
		 */
        public static function hasAccountChar(char:String,len:uint=15):Boolean{
            if(char == null){
                return false;
            }
            if(len < 10){
                len = 15;
            }
            char = trim(char);
            var pattern:RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0,"+len+"}$", ""); 
            var result:Object = pattern.exec(char);
            if(result == null) {
                return false;
            }
            return true;
        }
		/**
		 * URL地址;
		 * @param	char
		 * @return
		 */
        public static function isURL(char:String):Boolean{
            if(char == null){
                return false;
            }
            char = trim(char).toLowerCase();
            var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\':+!]*([^<>\"\"])*$/; 
            var result:Object = pattern.exec(char);
            if(result == null) {
                return false;
            }
            return true;
        }
		/**
		 * 是否为空白;
		 * @param	char
		 * @return
		 */
        public static function isWhitespace(char:String):Boolean{
            switch (char) {
				case "":
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                    return true;    
                default:
                    return false;
            }
        }
		public static function  isSpecial(valuel:String):Boolean {
			if(valuel.indexOf('\\')!=-1||
			valuel.indexOf('\/')!=-1||
			valuel.indexOf('<')!=-1||
			valuel.indexOf('>')!=-1||
			valuel.indexOf('"')!=-1||
			valuel.indexOf('*')!=-1||
			valuel.indexOf('?')!=-1||
			valuel.indexOf(':')!=-1||
			valuel.indexOf('|') != -1) return true
			else return false
		}
		/**
		 * 去左右空格;
		 * @param	char
		 * @return
		 */
        public static function trim(char:String):String{
            if(char == null){
                return null;
            }
            return rtrim(ltrim(char));
        }
        
        /**
         * 去左空格; 
         */
        public static function ltrim(char:String):String{
            if(char == null){
                return null;
            }
            var pattern:RegExp = /^\s*/; 
            return char.replace(pattern,"");
        }
        
        /**
         * 去右空格;
         */
        public static function rtrim(char:String):String{
            if(char == null){
                return null;
            }
            var pattern:RegExp = /\s*$/; 
            return char.replace(pattern,"");
        }
        
        /**
		 * 是否为前缀字符串;
		 **/
        public static function beginsWith(char:String, prefix:String):Boolean{            
            return (prefix == char.substring(0, prefix.length));
        }
        
		/**
		 * 是否为后缀字符串;
		 * @param	char
		 * @param	suffix
		 * @return
		 */
        public static function endsWith(char:String, suffix:String):Boolean{
            return (suffix == char.substring(char.length - suffix.length));
        }
        
		/**
		 * 去除指定字符串;
		 * @param	char
		 * @param	remove
		 * @return
		 */
        public static function remove(char:String,remove:String):String{
            return replace(char,remove,"");
        }

		/**
		 * 字符串替换;
		 * @param	char
		 * @param	replace
		 * @param	replaceWith
		 * @return
		 */
        public static function replace(char:String, replace:String, replaceWith:String):String{            
            return char.split(replace).join(replaceWith);
        }
		/**
		 * 正则替换字符
		 * @param	char
		 * @param	replace
		 * @param	replaceWith
		 * @return
		 */
         public static function replaceRegExp(char:String, replace:String, replaceWith:String):String {  
			var value:RegExp=new RegExp(replace,'g')
            return char.replace(value,replaceWith)
        }
		/**
		 * utf16转utf8编码;
		 * @param	char
		 * @return
		 */
        public static function utf16to8(char:String):String{
            var out:Array = new Array();
            var len:uint = char.length;
            for(var i:uint=0;i<len;i++){
                var c:int = char.charCodeAt(i);
                if(c >= 0x0001 && c <= 0x007F){
                    out[i] = char.charAt(i);
                } else if (c > 0x07FF) {
                    out[i] = String.fromCharCode(0xE0 | ((c >> 12) & 0x0F),
                                                 0x80 | ((c >>  6) & 0x3F),
                                                 0x80 | ((c >>  0) & 0x3F));
                } else {
                    out[i] = String.fromCharCode(0xC0 | ((c >>  6) & 0x1F),
                                                 0x80 | ((c >>  0) & 0x3F));
                }
            }
            return out.join('');
        }
        
		/**
		 * utf8转utf16编码;
		 * @param	char
		 * @return
		 */
        public static function utf8to16(char:String):String{
            var out:Array = new Array();
            var len:uint = char.length;
            var i:uint = 0;
			 var char2:int
			 var char3:int
            while(i<len){
                var c:int = char.charCodeAt(i++);
                switch(c >> 4){
                    case 0: case 1: case 2: case 3: case 4: case 5: case 6: case 7:
                        // 0xxxxxxx
                        out[out.length] = char.charAt(i-1);
                        break;
                    case 12: case 13:
                        // 110x xxxx   10xx xxxx
                        char2 = char.charCodeAt(i++);
                        out[out.length] = String.fromCharCode(((c & 0x1F) << 6) | (char2 & 0x3F));
                        break;
                    case 14:
                        // 1110 xxxx  10xx xxxx  10xx xxxx
                        char2 = char.charCodeAt(i++);
                        char3 = char.charCodeAt(i++);
                        out[out.length] = String.fromCharCode(((c & 0x0F) << 12) |
                            ((char2 & 0x3F) << 6) | ((char3 & 0x3F) << 0));
                        break;
                }
            }
            return out.join('');
        }
        /**
		 * 截取字符串
		* choice:Boolean = false窃取字符前
		*/
        public static function interceptString(str:String, choice:Boolean = false,val:String=","):String {
			var num:uint = str.indexOf(val)
			if (choice) str = str.slice(num+1)
			else str = str.slice(0,num)
			return str
		}
		/**
		 * 转换字符编码
		 **/ 
        public static function encodeCharset(char:String,charset:String):String{  
            var bytes:ByteArray = new ByteArray();  
            bytes.writeUTFBytes(char);  
            bytes.position = 0;  
            return bytes.readMultiByte(bytes.length,charset);  
        }  
          
        /**
		 * 添加新字符到指定位置
		 **/        
        public static function addAt(char:String, value:String, position:int):String {  
            if (position > char.length) {  
                position = char.length;  
            }  
            var firstPart:String = char.substring(0, position);  
            var secondPart:String = char.substring(position, char.length);  
            return (firstPart + value + secondPart);  
        }  
          
        /**
		 * 替换指定位置字符
		 */  
        public static function replaceAt(char:String, value:String, beginIndex:int, endIndex:int):String {  
            beginIndex = Math.max(beginIndex, 0);             
            endIndex = Math.min(endIndex, char.length);  
            var firstPart:String = char.substr(0, beginIndex);  
            var secondPart:String = char.substr(endIndex, char.length);  
            return (firstPart + value + secondPart);  
        }  
          
        /**
		 * 删除指定位置字符
		 **/ 
        public static function removeAt(char:String, beginIndex:int, endIndex:int):String {  
            return StringUtil.replaceAt(char, "", beginIndex, endIndex);  
        }  
        
        /**
		 * 修复双换行符
		 **/ 
        public static function fixNewlines(char:String):String {  
            return char.replace(/\r\n/gm, "\n");  
        }  
		/**
		 * 是否包含指定字符
		 * @param	str
		 * @param	val
		 * @return
		 */
		public static function Contains(str:String,val:String):Boolean{
			var bool:Boolean=new Boolean()
			var num:Number = str.lastIndexOf(val)
			if(num==-1)bool=false
			else bool=true
			return bool
		}
		/**
		 * 转换为小写,返回此字符串的一个副本，其中所有大写的字符均转换为小写字符。
		 */
		public static function toLowerCase(value:String):String {
			return value.toLowerCase()
		}
		/**
		 * 转换为大写,返回此字符串的一个副本，其中所有小写的字符均转换为大写字符。
		 */
		public static function toUpperCase(value:String):String {
			return value.toUpperCase()
		}
		/**
         * 匹配半角字符
         * 
         * @param str
         * @return 
         * @author flashyiyi
         */        
        public static function matchAscii(str:String):Array
        {
        	return str.match(/[\x00-\xFF]*/g);
        }
		/**
         * 将文件路径字符串切分为数组。最后两个将会是文件名和扩展名。
         * 
         * @param url	路径
         * @return 
         *  @author flashyiyi
         */        
        public static function splitUrl(url:String):Array
        {
        	return url.split(/\/+|\\+|\.|\?/ig);
        }
		 /**
		 * 删除HTML标签
		 * @author flashyiyi
		 */		
		public static function removeHTMLTag(text:String):String
		{
        	return text.replace(/<.*?>/g,"");
        }
		
	}
}
	
