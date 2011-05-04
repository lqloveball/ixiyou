package com.ixiyou.utils
{
	/**
	 * 随机数
	 * spe
	*/
    public class RandomUtil {
		/**
         * 随机获得一个指定范围内的整数N，并且 较小数 <= N < 较大数
         * @param	n1
         * @param	n2
         * @return 数据值
         */
		public static function intRange(n1 : uint, n2 : uint):uint {
            return Math.random() * (n2 - n1) + n1;
        }
		/**
		 * 范围取值
		 * @param	max
		 * @param	min
		 * @return
		 */
		public static function NumberRange(startNum:Number,endNum:Number):Number {
			return (Math.random()*(endNum-startNum) + startNum)
			}
		/**
		 * 随机获取一个布尔值，true或者false
		 */
        public static function get boolean() : Boolean {
            return Math.random() < .5;
        }
		/**
		 * 随机获取一个波形值，1或者-1
		 */
        public static function get wave() : int {
            return Math.random() < .5 ? -1 : 1;
        }
		/**
		 * 随机获得一个32位色颜色代码
		 */
        public static function get color() : uint {
            return Math.random() * 0xffffff;
        }
       /**
        * 随机获得0~num的整数，其中不包括num
        * @param	num 整数
        * @return
        */
		public static function integet(num : int) : int {
            return Math.random() * num;
        }
       /**
        * 随机获得0~num的双精度浮点小数，其中不包括num
        * @param	num
        * @return
        */
		public static function number(num : int) : Number {
            return Math.random() * num;
        }
		/**
		 * 随机获得所有指定参数中的任何一个字符
		 * @param	...args
		 * @return
		 */
        public static function char(...args) : String {
            return args[int(Math.random() * args.length)];
        }
		/**
		 * 一组数的中的随机数
		 * @param	args 整数
		 * @return
		 */
		public static function randomObjArr(...args):* {
			return args[int(Math.random() * args.length)]
		}
		/**
		 * 随机获得一个指定长度的字符串，范围是26个大小字母和10个数字
		 * @param	num
		 * @return
		 */
        public static function string(num : int) : String {
            for (var i : uint = 0,src : String = "";i < num;i++) {
                src += charRanges("0", "9", "A", "Z", "a", "z");
            }
            return src;
        }
        
		/**
		 * 	随机获得一个指定范围内的字符N，包括两个范围界线的字符
		 * @param	n1
		 * @param	n2
		 * @return
		 */
        public static function numRange(n1 : Number, n2 : Number) : Number {
            if (n1 < 0 || n2 < 0) {
                throw new Error("参数错误：不可为负数。");
            }
            return Math.random() * (n2 - n1) + n1;
        }
		/**
		 * 随机获得多个指定范围内的字符，参数成双输入，若出现奇数个参数则报错
			如 Random.intRanges(4,8,12,20,45,70); 则可能返回4~8,12~20,45~70之间的任何一个整数，获得的随机数界限标准可参考 Random.charRange(n1:Stirng, n2: Stirng)
		 * @param	s1
		 * @param	s2
		 * @return
		 */
        public static function charRange(s1 : String, s2 : String) : String {
            var n1 : uint = s1.charCodeAt(0),n2 : uint = s2.charCodeAt(0);
            return String.fromCharCode(int(Math.random() * (n2 - n1)) + n1);
        }
		/**
		 * 随机获得多个指定范围内的整数，参数成双输入，若出现奇数个参数则报错
			如 Random.intRanges(4,8,12,20,45,70); 则返回4~8,12~20,45~70之间的任何一个整数，获得的随机数界限标准可参考 Random.intRange(n1:int, n2:int)

		 * @param	s1
		 * @param	s2
		 * @return
		 */
        public static function intRanges(...args) : int {
            var n1s : Array = new Array();
            var n2s : Array = new Array();
            while (args.length) {
                n1s.push(args.shift());
                n2s.push(args.shift());
            }
            var len : uint = n1s.length;
            var s1 : uint = 0, s2 : uint = 0;
            for (var i : uint = 0;i < len; i++) {
                s1 += n1s[i];
                s2 += n2s[i];
            }
            var r : int = Math.random() * (s2 - s1) + n1s[0];
            i = 0;
            while (r >= n2s[i++]) {
                r += n1s[i] - n2s[i - 1];
            }
            return r;
        }
       /**
        * Random.numRanges(…args) : Number
		同Random.intRanges(…args),只是返回的类型是双精度浮点
        * @param	...args
        * @return
        */
		public static function numRanges(...args) : Number {
            var n1s : Array = new Array();
            var n2s : Array = new Array();
            while (args.length) {
                n1s.push(args.shift());
                n2s.push(args.shift());
            }
            var len : uint = n1s.length;
            var s1 : uint = 0, s2 : uint = 0;
            for (var i : uint = 0;i < len; i++) {
                s1 += n1s[i];
                s2 += n2s[i];
            } 
            do {
                var r : Number = Math.random() * (s2 - s1) + n1s[0];
                i = 0;
                while (r >= n2s[i++]) {
                    r += n1s[i] - n2s[i - 1];
                }
            } while (isNaN(r));
            return r;
        }
       /**
        * 
        * @param	...args
        * @return
        */
		public static function charRanges(...args) : String {
            var n1s : Array = new Array();
            var n2s : Array = new Array();
            while (args.length) {
                n1s.push(args.shift().charCodeAt(0));
                n2s.push(args.shift().charCodeAt(0) + 1);
            }
            var len : uint = n1s.length;
            var s1 : uint = 0, s2 : uint = 0;
            for (var i : uint = 0;i < len; i++) {
                s1 += n1s[i];
                s2 += n2s[i];
            }
            var r : int = Math.random() * (s2 - s1) + n1s[0];
            i = 0;
            while (r >= n2s[i++]) {
                r += n1s[i] - n2s[i - 1];
            }
            return String.fromCharCode(r);
        }
		/**
		 * Random.strRanges(num:uint, …args) : String
			随机获得指定长度的多个指定范围内的字符串，参考Random.charRanges(…args)
		 * @param	num
		 * @param	...args
		 * @return
		 */
        public static function strRanges(num : uint,...args) : String {
            var n1s : Array = new Array();
            var n2s : Array = new Array();
            while (args.length) {
                n1s.push(args.shift().charCodeAt(0));
                n2s.push(args.shift().charCodeAt(0) + 1);
            }
            var len : uint = n1s.length;
            var s1 : uint = 0, s2 : uint = 0;
            for (var i : uint = 0;i < len; i++) {
                s1 += n1s[i];
                s2 += n2s[i];
            }
            var src : String = "";
            while (num-- > 0) {
                var r : int = Math.random() * (s2 - s1) + n1s[0];
                i = 0;
                while (r >= n2s[i++]) {
                    r += n1s[i] - n2s[i - 1];
                }
                src += String.fromCharCode(r);
            }
            return src;
        }
        /**
         * 随即颜色值
         * @param	...args
         * @return
         */
		public static function colorRanges(...args) : uint {
            return intRange(args[0], args[1] + 1) << 16 + intRange(args[2], args[3] + 1) << 8 + intRange(args[4], args[5] + 1);
        }
		/**
		 * Random.disorder(arr:Array) : Array
		随机打乱数组，并返回(是否使用返回又实际需求决定)
		 * @param	arr
		 * @return
		 */
        public static function disorder(arr : Array) : Array {
            var len : uint = arr.length;
            var cache : *,ti : uint;
            for (var i : uint = 0;i < len;i++) {
                ti = int(Math.random() * len);
                cache = arr[i];
                arr[i] = arr[ti];
                arr[ti] = cache;
            } 
            while (--i >= 0) {    
                ti = int(Math.random() * len);
                cache = arr[i];
                arr[i] = arr[ti];
                arr[ti] = cache;
            }
            return arr;
        }
       /**
        * Random.takeOut(num:uint, arr:Array) : Array 
	随机从原数组中取出指定个数的元素，并且在原数组中删除它们。从表面上看此函数功能与Random.find函数相同，但是Random.find不修改原数组，效率更高，此方法在需要删除随机选中的元素时使用更为妥当。
        * @param	num
        * @param	arr
        * @return
        */
		public static function takeOut(num : uint,arr : Array) : Array {
            var newArr : Array = new Array(num);
            for (var i : uint = 0;i < num; i++) {
                newArr.push(arr.splice(int(Math.random() * arr.length)), 1);
            }
            return newArr;
        }
		/**
		 * Random.find(num:uint, arr:Array) : Array
		随机从原数组中取出指定个数的元素，在新数组中返回。
		 * @param	num
		 * @param	arr
		 * @return
		 */
        public static function find(num : uint, arr : Array) : Array {
            var newArr : Array = arr.concat();
            var cache : *,ti : uint, len : uint = arr.length;
            for (var i : uint = 0;i < num; i++) {
                ti = int(Math.random() * len);
                cache = newArr[i];
                newArr[i] = newArr[ti];
                newArr[ti] = cache;
            }
            return newArr.splice(0, num);
        }
    }
}
