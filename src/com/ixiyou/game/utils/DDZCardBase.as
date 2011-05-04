package com.ixiyou.game.utils
{
	
	
	/**
	 * 牌的基类
	 * 
	 *	单张牌数据类型Object类型
	 *	var obj:Object={color:花色, points:牌面点数,id:牌的id号} 
	 *	color:"x"//红心, "f"//方块 , "h"//黑桃,  "c"//草花 ,"k"//鬼
	 *  points:点数从0-14，然后 0-12是3点到2点，13-14是大小鬼
	 * 	id:每张牌的唯一的id号
	 * @author spe
	 */
	public class DDZCardBase 
	{
		/**
		 * 一副参照牌牌
		 */
		private static var _allLicense:Array
		/**
		 * 一副参照牌
		 * 内部一副牌 当对这副牌进行添加删除操作后会自动还原成一幅完整的牌
		 * 适合做比较或查询使用
		 * @return
		 */
		public static  function get referenceLicense():Array {
			if (_allLicense == null||_allLicense.length<54)_allLicense = DDZCardBase.createLicense()
			return _allLicense
			
		}
		/**
		 * 发牌
		 * @return [玩家1，玩家2，玩家3，地主牌]
		 */
		public static function distribution(value:Array):Array
		{
			var arr:Array = value
			arr.sort(function():Number {return Math.random()>0.5 ? 1 : -1})
			var licensingArr:Array = new Array(4)
			for (var i:uint = 0; i < 54; i++)
			{
				var num:uint = uint(i / 17  >> 0)
				if(licensingArr[num]==null)licensingArr[num]=new Array()
				licensingArr[num].push(arr[i])
				
			}
			return licensingArr
		}
		/**
		 * 创建一副斗地主牌 
		 * @return 创建一副牌的
		 */
		public static function createLicense():Array
		{
			var arr:Array = new Array()
			//花色
			var color:uint
			//牌面点数
			var points:uint
			//牌的id号
			var id:uint
			for (var i:uint = 0; i < 54; i++)
			{
				id=i
				var obj:Object=new Object()
				color = uint(i / 13 >> 0)
				obj.points = uint(i % 13)
				obj.id = id
				if (color == 0) obj.color = "x"//红心
				if (color == 1) obj.color = "f"//方块
				if (color == 2) obj.color = "h"//黑桃
				if (color == 3) obj.color = "c"//草花
				if (color == 4) obj.color = "g"//鬼
				if (color == 4) obj.points += 13
				arr.push(obj)
			}
			return arr
		}
		/**
		 * 查询某ID号的牌面点数大小
		 * @param	value ID号
		 * @return 牌点数
		 */
		public static function  id2points(value:uint):uint
		{
			return referenceLicense[value].points
		}
		/**
		 * 查询某ID号的牌面花色
		 * @param	value ID号
		 * @return
		 */
		public static function id2color(value:uint):String
		{
			return referenceLicense[value].color
		}
		/**
		 * 查询某ID号的牌所有类型
		 * @param	value ID号
		 * @return {color:花色, points:牌面点数,id:牌的id号} 
		 */
		public static function id2Obj(value:uint):Object
		{
			var obj:Object = new Object()
			obj.color = String(referenceLicense[value].color)
			obj.points = uint(referenceLicense[value].points)
			obj.id=value
			return obj
		}
		/**
		 * 出牌规则
		 * @param	value 出的牌数组
		 * @return Object{bool:是否合法,type:牌型,length:牌的长度,start:开始的点数,info:提示信息}
		 * bool:布朗类型
		 * type:牌型 0：单 1：单顺 2：对 3：双顺 4：三张 5：三顺 6：三带一7：三带二8：四代二单9：四代二对 20：炸弹 21：火箭 99：错误类型
		 */
		public static function gameRules(value:Array):Object {
			var obj:Object = new Object()
			obj.length = value.length
			//判断最多出牌数
			if (value.length > 20) {
				obj={bool:false,type:99,length:99,start:[],info:"错误:不能超出20张牌"}
				return obj
			}
			//判断最少出牌数
			if (value.length == 0) { 
				obj={bool:false,type:99,length:99,start:[],info:"错误:不能发空牌"}
				return obj
			}
			//整理牌组，把所有点数相同放到一起，编出牌型
			var sortArr:Array = sort(value)
			//把牌型编组
			var groupArr:Array = group(sortArr)
			if(groupArr.length==0)return obj={bool:false,type:99,length:99,start:[],info:"错误:你的牌有问题，不能大过4张的组"}
			//牌型个数
			var groupLength:uint = groupNum(groupArr)
			var temp:Object 
			switch (groupLength)
			{
				case 0:
					temp={bool:false,type:99,length:99,start:[],info:"错误:不能发空牌"}
				break;
				case 1:
					//只有一组数据类型算法
					trace(1)
					temp= group1(groupArr)
				break;
				case 2:	
					trace(2)
					temp= group2(groupArr)
					
				break;
				case 3:	
					trace(3)
						temp= group3(groupArr)
				break;
				case 4:
					trace(4)
					temp= group4(groupArr)

				break;
				case 5:	
					temp = {bool:false,type:99,length:99,start:groupArr,info:"错误:不可能存在的牌型"}
				break;
				default:
					temp = {bool:false,type:99,length:99,start:groupArr,info:"错误:不可能存在的牌型"}
				break;
			}
			obj.bool = temp.bool
			obj.type = temp.type
			obj.start = temp.start
			obj.info = temp.info
			obj.length = temp.length
			return obj
		}
		/**
		 * 只有一组牌的算法
		 * @param	arr 
		 * @return 
		 */
		public static function group1(arr:Array):Object
		{
			//trace("1组算法")
			var obj:Object = new Object()
			//bool:是否合法,type:牌型,length:牌的长度,start:开始的点数,info:错误类型
			//type:牌型 0：单 1：单顺 2：对 3：双顺 4：三张 5：三顺 6：三带一7：三带二8：四代二单9：四代二对 20：炸弹 21：火箭 99：错误类型
			//测试单张情况
			//火箭
			if (arr[0].length == 2&&arr[0][0][0].points>12)
				return obj = { bool:true, type:21, length:arr[0].length, start:arr[0][0][0].points, info:"火箭" }
			if (arr[0].length == 1)
				return obj = { bool:true, type:0, length:arr[0].length, start:arr[0][0][0].points, info:"单张" }
			if (arr[0].length >= 5 && dealShun(arr[0]))
				return obj = {bool:true, type:1, length:arr[0].length, start:arr[0][0][0].points, info:"单顺" }
			//测试双张情况
			if (arr[1].length == 1)
				return obj = { bool:true, type:2,length:arr[1].length, start:arr[1][0][0].points, info:"对子" }
			if (arr[1].length >= 3 && dealShun(arr[1]))
				return obj = { bool:true, type:3, length:arr[1].length, start:arr[1][0][0].points, info:"双顺" }
			
			//测试三张情况
			if (arr[2].length == 1 )
				return obj = { bool:true, type:4, length:arr[2].length, start:arr[2][0][0].points, info:"三张" }
			//特殊情况
			if (arr[2].length==4 && dealShun(arr[2]))
				return obj = { bool:true, type:"5,6", length:'4,3', start:arr[2][0][0].points+","+arr[2][1][0].points, info:"三顺 或 三带一" }
			//三顺子
			if (arr[2].length > 1 && dealShun(arr[2]))
				return obj = { bool:true, type:5, length:arr[2].length, start:arr[2][0][0].points, info:"三顺" }
			//特殊情况
			var tempObj:Object
			if (arr[2].length > 1) {
				tempObj = dealShunObj(arr[2])
				if (tempObj.bool) {
					if((arr[2].length - tempObj.length)*3 == tempObj.length)
						return obj = { bool:true, type:6, length:tempObj.length, start:tempObj.start, info:"三带一" }
					return obj = { bool:false,type:99,length:99,start:arr, info:"错误:单一牌型规则,无效牌组 3" };
				}else {
					return obj = { bool:false,type:99,length:99,start:arr, info:"错误:单一牌型规则,无效牌组 3" };
				}
			}
			//测试4张牌的情况
			if (arr[3].length == 1)
				return obj = { bool:true, type:20, length:arr[3].length, start:arr[3][0][0].points, info:"炸弹" }
			/**开始要考虑特殊算法*/
			if (arr[3].length > 1) {
				tempObj = dealShunObj(arr[3])
				if (tempObj.bool) {
					//全连
					if (arr[3].length - tempObj.length == 0) {
						if (tempObj.length % 2 == 0) {
							tempObj.start=arr[3][tempObj.length/2][0].points
							tempObj.length=String(tempObj.length+','+tempObj.length/2)
							return obj = { bool:true, type:'6,9', length:tempObj.length, start:arr[3][0][0].points+','+tempObj.start, info:"三带一或四带二" }
						}
						else {
							return obj = { bool:true, type:6, length:tempObj.length, start:arr[3][0][0].points, info:"三带一" }
						}
					}
					//部分连
					if (tempObj.length  == (arr[3].length - tempObj.length) * 2)
						return obj = { bool:true, type:8, length:tempObj.length, start:tempObj.start, info:"四代二单" }
					if (tempObj.length == (arr[3].length - tempObj.length))
						return obj = { bool:true, type:9, length:tempObj.length, start:tempObj.start, info:"四代二对" }
				}
				else {
					//没有顺，但可以组成四代二对，以最大点数为准
					if (arr[3].length == 2)
						return obj = { bool:true, type:9, length:1, start:arr[3][1][0].points, info:"四代二对" }
				}
				
			}
				
			return obj = { bool:false,type:99,length:99,start:arr, info:"错误:单一牌型规则,无效牌组" };
		}
		/**
		 * 有2组牌算法
		 * @param	arr
		 * @return
		 */
		public static function group2(arr:Array):Object
		{
			//trace("2组算法")
			var obj:Object = new Object()
			//bool:是否合法,type:牌型,length:牌的长度,start:开始的点数,info:错误类型
			//type:牌型 0：单 1：单顺 2：对 3：双顺 4：三张 5：三顺 6：三带一7：三带二8：四代二单9：四代二对 20：炸弹 21：火箭 99：错误类型
			//测试错误情况
			//错误：单牌组合对组不可能同时出现
			if (arr[0].length >= 1 && arr[1].length >= 1)
				return obj = { bool:false, type:99, length:99, start:arr, info:"错误:单牌组合对组不可能同时出现" }
			//三张组 单张组
			if (arr[2].length > 0 && arr[0].length > 0) {
				//三带一
				if (arr[2].length ==1 &&arr[0].length ==1)
					return obj = { bool:true, type:6, length:arr[2].length, start:arr[2][0][0].points, info:String("三带一") }
				//三带一
				if (arr[2].length == arr[0].length && dealShun(arr[2]))
					return obj = { bool:true, type:6, length:arr[2].length, start:arr[2][0][0].points, info:String("三带一") }
					return obj = { bool:false,type:99,length:99,start:arr, info:"错误:双牌型规则,无效牌组 3 1" };
			}
			//三张组 对子组
			if (arr[2].length > 0 && arr[1].length > 0) {
				//三带一
				if (arr[2].length == arr[1].length*2 && dealShun(arr[2]))
					return obj = { bool:true, type:6, length:arr[2].length, start:arr[2][0][0].points, info:"三带一" }
				//三带一
				if (arr[2].length ==1&& arr[1].length==1)
					return obj = { bool:true, type:7, length:arr[2].length, start:arr[2][0][0].points, info:"三带二" }
				//三带二
				if (arr[2].length == arr[1].length && dealShun(arr[2]))
					return obj = { bool:true, type:7, length:arr[2].length, start:arr[2][0][0].points, info:"三带二" }
				return obj = { bool:false,type:99,length:99,start:arr, info:"错误:双牌型规则,无效牌组 3 2" };
			}
			var tempObj:Object
			//四张组 单张组
			if (arr[3].length > 0 && arr[0].length > 0) {
				
				tempObj = dealShunObj(arr[3])
				if (tempObj.bool) {
					if(arr[0].length==arr[3].length*2)
						return obj = { bool:true, type:8, length:tempObj.length, start:tempObj.start, info:"四代二单" }
				}
				else {
					if (arr[3].length == 1 && arr[0].length == 2)
						return obj = { bool:true, type:8, length:1, start:arr[3][0][0].points, info:"四代二单" }	
					return obj = { bool:false,type:99,length:99,start:arr, info:"错误:双牌型规则,无效牌组 4 1" };
				}
			}
			//四张组 对组
			if (arr[3].length > 0 &&arr[1].length>0) {
				tempObj = dealShunObj(arr[3])
				if (tempObj.bool) { 
					if(arr[1].length==arr[3].length*2)
						return obj = { bool:true, type:9, length:tempObj.length, start:tempObj.start, info:"四代二对" }
					if(arr[1].length==arr[3].length)
						return obj = { bool:true, type:8, length:tempObj.length, start:tempObj.start, info:"四代二单" }
				}
				else {
					if(arr[3].length==1&&arr[1].length==2)return obj = { bool:true, type:9, length:1, start:arr[3][0][0].points, info:"四代二对" }
					if(arr[3].length==1&&arr[1].length==1)return obj = { bool:true, type:8, length:1, start:arr[3][0][0].points, info:"四代二单" }
					return obj = { bool:false,type:99,length:99,start:arr, info:"错误:双牌型规则,无效牌组 4 2" };
				}
			}
			//四张组 三张组
			if (arr[3].length > 0 && arr[2].length > 0) {
				if (dealShun(arr[2]) && arr[3].length*2 == arr[2].length) {
					return obj={bool:true,type:7,length:arr[2].length,start:arr[2][0][0].points,info:"三带二"}
				}
				if (dealShun(arr[2]) && arr[3].length*4 == arr[2].length) {
					return obj={bool:true,type:6,length:arr[2].length,start:arr[2][0][0].points,info:"三带一"}
				}
				if (dealShun(arr[3]) && arr[3].length*2 == arr[2].length*3) {
					return obj = { bool:true, type:8, length:arr[3].length, start:arr[3][0][0].points, info:"四代二单" }
				}
				return obj = { bool:false,type:99,length:99,start:arr, info:"错误:双牌型规则,无效牌组 4 3" };
			}
			return obj = { bool:false,type:99,length:99,start:arr, info:"错误:双牌型规则,无效牌组" };
		}
			
		/**
		 * 有3组牌算法
		 * @param	arr
		 * @param	Statistics
		 * @return
		 */
		public static function group3(arr:Array):Object
		{
			//trace("3组算法")
			var obj:Object = new Object()
			//bool:是否合法,type:牌型,length:牌的长度,start:开始的点数,info:错误类型
			//type:牌型 0：单 1：单顺 2：对 3：双顺 4：三张 5：三顺 6：三带一7：三带二8：四代二单9：四代二对 20：炸弹 21：火箭 99：错误类型
			//1 2 3
			if (arr[0].length > 0 && arr[1].length > 0 && arr[2].length > 0) {
				if (dealShun(arr[2]) && arr[2].length == arr[0].length + arr[1].length*2)
					return obj={bool:true,type:6,length:arr[2].length,start:arr[2][0][0].points,info:"三带一"}
				return obj = { bool:false,type:99,length:99,start:arr, info:"错误:三牌型规则,无效牌组 1 2 3" };
			}
			//1 2 4
			if (arr[0].length > 0 && arr[1].length > 0 && arr[3].length > 0) {
				if (dealShun(arr[3]) && arr[3].length*2 == arr[0].length + arr[1].length*2)
					return obj={bool:true,type:8,length:arr[2].length,start:arr[3][0][0].points,info:"四代二单"}
				return obj = { bool:false,type:99,length:99,start:arr, info:"错误:三牌型规则,无效牌组 1 2 4" };
			}
			var tempObj:Object
			var allnum:uint
			//1 3 4
			if (arr[0].length > 0 && arr[2].length > 0 && arr[3].length > 0) {
				tempObj = dealShunObj(arr[3], arr[2])
				
				if (tempObj.bool) {
					allnum=arr[0].length+ arr[2].length*3+ arr[3].length*4
					//3来带1
					if (tempObj.zhang == 3) {
						if (tempObj.length == allnum - tempObj.length * 3)
							return obj={bool:true,type:6,length:tempObj.length,start:tempObj.start,info:"三带一"}
					}
					//4来带1
					if (tempObj.zhang == 4) {
						if (tempObj.length * 2 == allnum - tempObj.length * 4)
							return obj={bool:true,type:8,length:tempObj.length,start:tempObj.start,info:"四代二单"}
					}
				}
				return obj = { bool:false,type:99,length:99,start:arr, info:"错误:三牌型规则,无效牌组 1 3 4" };
			}
			//2 3 4
			if (arr[1].length > 0 && arr[2].length > 0 && arr[3].length > 0) {
				//3可以带2
				if (dealShun(arr[2])&&(arr[2].length==arr[1].length+arr[3].length*2)) 
					return obj = { bool:true, type:7, length:arr[2].length, start:arr[2][0][0].points, info:"三带二" }
				//需要3和4进行混合计算
				tempObj = dealShunObj(arr[3], arr[2])
				if (tempObj.bool) {
					allnum=arr[1].length*2+ arr[2].length*3+ arr[3].length*4
					//3来带1
					if (tempObj.zhang == 3) {
						if (tempObj.length == allnum - tempObj.length * 3)
							return obj={bool:true,type:6,length:tempObj.length,start:tempObj.start,info:"三带一"}
					}
					//4来带1
					if (tempObj.zhang == 4) {
						if (tempObj.length * 2 == allnum - tempObj.length * 4)
							return obj={bool:true,type:8,length:tempObj.length,start:tempObj.start,info:"四代二单"}
					}
				}
				return obj = { bool:false,type:99,length:99,start:arr, info:"错误:三牌型规则,无效牌组 2 3 4" };	
			}
			return obj = { bool:false,type:99,length:99,start:arr, info:"错误:三牌型规则,无效牌组" };
		}
		
		/**
		 * 有4组算法
		 * @param	arr
		 * @return
		 */
		public static function group4(arr:Array):Object
		{
			//trace("4组算法")
			var obj:Object = new Object()
			var allnum:uint
			var tempObj:Object
			allnum = arr[0].length + arr[1].length * 2 + arr[2].length * 3 + arr[3].length * 4
			tempObj = dealShunObj(arr[3], arr[2])
			
			//3来带1
			if (tempObj.zhang == 3) {
				if (tempObj.length == allnum - tempObj.length * 3)
					return obj={bool:true,type:6,length:tempObj.length,start:tempObj.start,info:"三带一"}
			}
			//4来带1
			if (tempObj.zhang == 4) {
				if (tempObj.length * 2 == allnum - tempObj.length * 4)
					return obj={bool:true,type:8,length:tempObj.length,start:tempObj.start,info:"四代二单"}
			}
			return obj = { bool:false,type:99,length:99,start:arr, info:"错误:四牌型规则,无效牌组" };
		}
		
		/**
		 * 处理顺子对象
		 * @param	arr0 第一组 牌组
		 * @param	arr1 第二组 没第2组时候只以第一组来进行计算
		 * @return	{ bool:是否顺子, length:顺子长度, start:顺子开始点数 ,zhang:顺子张数}
		 */
		public static function dealShunObj(arr0:Array, arr1:Array=null):Object
		{
			var arr:Array = new Array
			var newArr:Array = new Array()
			if (arr1 != null) arr = arr0.concat(arr1)
			else arr=arr0.concat()
			for (var i:uint= 0; i < arr.length; i++)
			{
				newArr.push({points:arr[i][0].points,length:arr[i].length})
			}
			//升序排列
			newArr.sortOn ("points", [Array.NUMERIC]);
			for (i =0; i < newArr.length; i++)
			{
				if (newArr[i].points > 11) {
					newArr.splice(i, newArr.length - i)
					break
				}
			}
			//如果没有可以顺的牌
			if(newArr.length<2)return { bool:false, length:0, start:0 ,zhang:0 }
			var num:uint=1
			var maxNum:uint = 0
			var startNum:uint=0
			var zhang:uint = 0
			newArr.forEach(
				function (element:*, index:int, arr:Array):void {
					  if (index > 0) {
						  if (arr[index - 1].points + 1 == element.points) num += 1
						  else num = 1
					  }
					  if (maxNum < num) {
						  maxNum = num
						  startNum = arr[(index + 1) - num].points
						  zhang=(index + 1) - num
					  }
				}
			);
			arr = newArr.slice(zhang, zhang + maxNum)
			zhang=0
			arr.forEach(
				function (element:*, index:int, arr:Array):void {
					  if (index > 0) {
						if (arr[index - 1].length > element.length) zhang = element.length
						else zhang = arr[index - 1].length
					  } 
				}
			)
			if (maxNum>=2 ) return { bool:true, length:maxNum, start:startNum,zhang:zhang }
			else return { bool:false, length:maxNum, start:startNum ,zhang:zhang }
		}
		/**
		 * 判断是否顺子
		 * @param	arr0 第一组 牌组
		 * @param	arr1 第二组 没第2组时候只以第一组来进行计算
		 * @return
		 */
		public static function dealShun(arr0:Array, arr1:Array=null):Boolean
		{
			var arr:Array = new Array
			var newArr:Array = new Array()
			if (arr1 != null) arr = arr0.concat(arr1)
			else arr = arr0.concat()
			var i:uint
			for (i= 0; i < arr.length; i++)
			{
				newArr.push(arr[i][0].points)
			}
			//升序排列
			newArr.sort (Array.NUMERIC);
			return shunzi(newArr)
		}
		/**
		 * 判断顺子
		 * @param	value
		 * @return
		 */
		public static function shunzi(value:Array):Boolean {
			if(value.length<2)return false
			if(value[(value.length - 1)]>11)return false
			for (var i:uint = 1; i < value.length; i++)
			{
				if ((value[i - 1]) != (value[i] - 1))return false
			}
			return true
		}
		
		/**
		 * 计算不同牌型有多少组
		 * @param	value group处理过后的分组数据
		 * @return 牌组数
		 */
		public static function groupNum(value:Array):uint
		{
			var num:uint=0
			for (var i:uint = 0; i < value.length; i++)
			{
				if (value[i].length > 0)num+=1
			}
			return num
		}
		/**
		 * 对牌型进行分组，同样长度在以组，如【[2,2,2]，[3,3,3]，[4,4,4]】,【[6],[7],[8]】
		 * 还可以理解成单张和单张是一组，2张的和2张的是一组
		 * @param	value 经过sort整理后的牌数据
		 * @return 分组的数据
		 */
		public static function group(value:Array):Array {
			var arr:Array = [[],[],[],[]]
			for (var i:uint = 0; i < value.length; i++ )
			{
				
				//单张
				if ((value[i] as Array).length == 1) arr[0].push(value[i])
				//双张
				if ((value[i] as Array).length == 2) arr[1].push(value[i])
				//三张
				if ((value[i] as Array).length == 3) arr[2].push(value[i])
				//四张
				if((value[i] as Array).length ==4)arr[3].push(value[i])
				if((value[i] as Array).length >4)return arr=new Array()
			}
			return arr
		}
		/**
		 * 整理牌数据的数组 把同点数放到一起，生成牌型组
		 * @param	value [红桃3，黑桃3，方块4，草花4，红桃4]
		 * @return 2维数组【 [红桃3，黑桃3],[方块4，草花4，红桃4]】
		 */
		public static function sort(value:Array):Array
		{
			//把所有牌按牌面点数大小先排序
			value.sortOn ("points", [Array.NUMERIC]);
			//把所有牌按牌面点数分类摆放
			var arr:Array = new Array()
			arr.push(new Array(value[0]))
			for (var i:uint = 1; i < value.length; i++ )
			{
				if (value[i].points == value[uint(i - 1)].points)
				{
					(arr[uint(arr.length - 1)] as Array).push(value[i])
				}
				else
				{
					arr.push(new Array(value[i]))
				}
			}		
			return arr
		}
	}
	
}