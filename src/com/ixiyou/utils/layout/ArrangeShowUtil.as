package com.ixiyou.utils.layout
{
	/**
	 * 排列布局展示工具类
	 * @author spe
	 */
	import flash.geom.Point
	import flash.geom.Rectangle
	public class ArrangeShowUtil
	{
		//-----------------------区块列表算法显示计算方法-----------------------------
		/**
		 * 计算区块能显示数
		 * @param	iteamRect 项大小
		 * @param	showRect 显示区域大小
		 * @param	bool 是否补差算法 比如显示12.5个 就是显示13 显示0或.5时候就是最少1
		 * @return
		 */
		public static function getTileViewNum(iteamRect:Number, showRect:Number,bool:Boolean=true):uint {
			if (iteamRect > showRect) {
				if (bool) return 1
				else return 0
			}
			if (bool)return  Math.ceil(showRect / iteamRect);
			else return Math.floor(showRect / iteamRect);
		}
		/**
		 * 纵向列表 按区块计算目前显示的区块开始数与结束的数组
		 * @param	iteamRect
		 * @param	allRect
		 * @param	showRect
		 * @return
		 */
		public static function getVTileViewArr(iteamRect:Rectangle, allRect:Rectangle, showRect:Rectangle):Array {
			var arr:Array=new Array()
			var num:uint 
			var i:int
			//查询相交区域
			var intersectionRect:Rectangle = allRect.intersection(showRect)
			//判断区域是否需要显示
			if (intersectionRect.x == 0 && intersectionRect.y == 0 && intersectionRect.width == 0 && intersectionRect.height == 0) return arr
			//num= getTileViewNum(iteamRect.height, showRect.height)
			//计算交集区域能拥有多少显示对象
			num = getTileViewNum(iteamRect.height, intersectionRect.height)
			var start:uint=0
			//交集区域的Y坐标小于显示区域Y坐标内那开始肯定是0
			//trace(intersectionRect,allRect)
			if (intersectionRect.y == allRect.y) start = 0
			else if(intersectionRect.y > allRect.y){
				start = getTileViewNum(iteamRect.height, intersectionRect.y - allRect.y,false)
			}else {
				start = 0
			}
			//trace(start,num)
			for (i= 0; i < num+1; i++) arr.push(i+start)
			//常规情况
			return arr
		}
		//--------------------------------简单网格排列--------------------------
		/**
		 * 根据一排有多少个来计算
		 * @param	hNum 一排几个
		 * @param	boxw  盒子宽度
		 * @param	gridh  对象高度
		 * @param	gridLength 总个数
		 * @return
		 */
		public static function gridHArr(hNum:uint, gridLength:uint, boxw:uint,gridh:uint):Array {
			var arr:Array=new Array()
			var gridw:uint = boxw / hNum
			var px:int
			var py:int
			var pt:Point
			for (var i:uint = 0; i < gridLength; i++) 
			{
				px = (i % hNum)*gridw
				py = (i / hNum >> 0)*gridh
				pt = new Point(px, py)
				arr.push(pt)
				//trace(pt)
			}
			return arr
		}
		//--------------------------------网格排列----------------------------------\\
		/**
		 * 网格排列物件 算出所有的排列的坐标位置列表(单个内部居中 算法 带间隔 )
		 * @param	gridw 格子的宽
		 * @param	gridh 格子的高
		 * @param	_boxw 盒子的宽
		 * @param	_boxh 盒子的高
		 * @param	interval 格子的间隔
		 * @return
		 */
		public static function gridCenterIntervalPointArr(gridw:int, gridh:int,_boxw:int, _boxh:int,interval:int=2):Array {
			var arr:Array=new Array()
			var pt:Point
			var _w:int = gridChildNum(gridw+interval, _boxw)
			var _h:int = gridChildNum(gridh+interval, _boxh)
			var _all:int=gridAllNum(gridw+interval,gridh+interval,_boxw,_boxh)
			//trace(_w, _h)
			var _x:Number = ((_boxw /_w)-gridw)/2
			var _y:Number = ((_boxh / _h) - gridh) / 2
			//trace(_x,_y)
			var px:int
			var py:int
			for (var i:int = 0; i < _all; i++) 
			{
				px = (i % _w) * (_boxw / _w) + _x
				py = (i / _w >> 0) * (_boxh / _h) + _y
				pt=new Point(px,py)
				//pt=new Point((i % _w)*(gridw+interval)+_x,(i/_w>>0)*(gridh+interval)+_y)
				arr.push(pt)
			}
			return arr
		}
		/**
		 * 网格排列物件 算出所有的排列的坐标位置列表(单个内部居中 算法)
		 * @param	gridw 格子的宽
		 * @param	gridh 格子的高
		 * @param	_boxw 盒子的宽
		 * @param	_boxh 盒子的高
		 * @return
		 * 
		 */
		public static function gridCenterPointArr(gridw:int, gridh:int,_boxw:int, _boxh:int):Array {
			var arr:Array=new Array()
			var pt:Point
			var _w:int = gridChildNum(gridw, _boxw)
			var _h:int = gridChildNum(gridh, _boxh)
			//trace(_w, _h)
			var _all:int=gridAllNum(gridw,gridh,_boxw,_boxh)
			var _x:Number = ((_boxw /_w)-gridw)/2
			var _y:Number = ((_boxh / _h) - gridh) / 2
			var px:int
			var py:int
			for (var i:int = 0; i < _all; i++) 
			{
				px = (i % _w)*(_boxw /_w)+_x
				py=(i/_w>>0)*(_boxh /_h)+_y
				pt=new Point(px,py)
				arr.push(pt)
			}
			return arr
		}
		/**
		 * 网格排列物件 算出所有的排列的坐标位置列表(边缘内缩 算法 带间隔 )
		 * @param	gridw 格子的宽
		 * @param	gridh 格子的高
		 * @param	_boxw 盒子的宽
		 * @param	_boxh 盒子的高
		 * @param	interval 格子的间隔
		 * @return
		 */
		public static function gridIntervalPointArr(gridw:int, gridh:int,_boxw:int, _boxh:int,interval:int=2):Array {
			var arr:Array=new Array()
			var pt:Point
			var _w:int = gridChildNum(gridw+interval, _boxw)
			var _h:int = gridChildNum(gridh+interval, _boxh)
			var _all:int=gridAllNum(gridw+interval,gridh+interval,_boxw,_boxh)
			//trace(_w, _h)
			var _x:Number = (_boxw - _w * (gridw + interval)+interval) / 2
			var _y:Number = (_boxh - _h * (gridh + interval) + interval) / 2
			var px:int
			var py:int
			for (var i:int = 0; i < _all; i++) 
			{
				px = (i % _w) * (gridw + interval) + _x
				py=(i/_w>>0)*(gridh+interval)+_y
				pt=new Point(px,py)
				arr.push(pt)
			}
			return arr
		}
		/**
		 * 网格排列物件 算出所有的排列的坐标位置列表(边缘内缩 算法)
		 * @param	gridw 格子的宽
		 * @param	gridh 格子的高
		 * @param	_boxw 盒子的宽
		 * @param	_boxh 盒子的高
		 * @return
		 */
		public static function gridPointArr(gridw:int,gridh:int,_boxw:int,_boxh:int):Array
		{
			var arr:Array=new Array()
			var pt:Point
			var _w:int = gridChildNum(gridw, _boxw)
			var _h:int = gridChildNum(gridh, _boxh)
			var _all:int=gridAllNum(gridw,gridh,_boxw,_boxh)
			//trace(_w, _h)
			//trace(_all)
			var _x:Number = (_boxw - _w * gridw) / 2
			var _y:Number = (_boxh - _h * gridh) / 2
			var px:int
			var py:int
			for (var i:int = 0; i < _all; i++) 
			{
				px = (i % _w)*gridw+_x
				py=(i/_w>>0)*gridh+_y
				pt=new Point(px,py)
				arr.push(pt)
			}
			return arr
		}
		/**
		 * 网格内创建多少个网格
		 * @param	gridw 格子的宽
		 * @param	gridh 格子的高
		 * @param	_boxw 盒子的宽
		 * @param	_boxh 盒子的高
		 * @return
		 */
		public static function gridAllNum(gridw:int, gridh:int, _boxw:int, _boxh:int,vb:Boolean=true,hb:Boolean=true):int {
			var num:int = 0
			//计算V排列多少个
			var vn:int = gridChildNum(gridw, _boxw, vb)
			//计算H排列多少个
			var hn:int = gridChildNum(gridh, _boxh, hb)
			//如果2个都为零
			if (vn == 0 && hn == 0) return 0
			//如果只有一个为零，把零计算成1
			if (vn == 0) return vn = 1
			if(hn == 0)return hn=1
			return vn*hn
		}
		/**
		 * 容纳数:根据子对象长度 算 上级对象容纳数
		 * @param	child 子对象
		 * @param	parent 上级对象
		 * @param	oneBool 父对象小于子对象时候是否 要至少留1  默认 为排列为1
		 * @return
		 */
		public static function gridChildNum(child:int,parent:int,oneBool:Boolean=true):int {
			if (child > parent) {
				if (oneBool) return 1
				else return 0
			}
			else return parent/child>>0
		}
		//--------------------------------网格排列 end ----------------------------------\\
		//------------------------------------------环状 start--------------------
		/**
		 * 环状排列物体,只做简单的排列，不适合做互动使用
		 * @param	childNum 排列的物件个数
		 * @param	w 长半径
		 * @param	h 高半径
		 * @param	x 原点X
		 * @param	y 原点Y
		 * @param	angle 原点角度
		 * @return
		 */
		public static function ringPointArr(childNum:uint, w:uint=100, h:uint=50,x:int=100, y:int=50,angle:Number=0):Array {
			if (w == 0) w = 100;
			if (h == 0) h = 100;
			var arr:Array=new Array()
			var pt:Point
			var _fangle:Number = 360 / childNum;
			//转换0-360角度
			angle = (angle+90) % 360
			angle = angle < 0?angle + 360:angle;
			//
			var nowAngle:Number
			for (var i:int = 0; i < childNum; i++) 
			{
				nowAngle = angle + _fangle * (i );
				nowAngle = nowAngle * Math.PI / 180;
				pt = new Point(Math.cos(nowAngle) * w + x, Math.sin(nowAngle) * h + y);
				arr.push(pt);
			}
			return arr;
		}
		/**
		 * 环状排列物体,加入的剔除消隐计算从后180度开始计数,只做简单的排列，不适合做互动使用
		 * @param	childNum 排列的物件个数
		 * @param	w 长半径
		 * @param	h 高半径
		 * @param	x 原点X
		 * @param	y 原点Y
		 * @param	angle 基础角度
		 * @return
		 */
		public static function ringSuperPointArr(childNum:uint, w:uint = 100, h:uint = 50, x:int = 100, y:int = 50, angle:Number = 0):Array {
			if (w == 0) w = 100;
			if (h == 0) h = 100;
			var arr:Array=new Array()
			var pt:Object
			var _fangle:Number = 360 / childNum;
			//转换0-360角度
			angle = (angle+90) % 360
			angle = angle < 0?angle + 360:angle;
			//
			var nowAngle:Number
			var _pAngle:Number
			for (var i:int = 0; i < childNum; i++) 
			{
				nowAngle = angle + _fangle * (i );
				nowAngle = nowAngle % 360
				nowAngle = nowAngle < 0?nowAngle + 360:nowAngle;
				_pAngle = nowAngle * Math.PI / 180;
				pt = { x:Math.cos(_pAngle) * w + x, y:Math.sin(_pAngle) * h + y ,angle:nowAngle}
				if (nowAngle > 180) {
					if (nowAngle > 180 && nowAngle < 270) pt.value = 1 - (nowAngle-180) / 90
					else pt.value=(nowAngle-270)/90
				}else pt.value=1
				//trace(pt.value)
				arr.push(pt);
			}
			return arr;
		}
		/**
		 * 按排列数计数环排列点
		 * @param	childNum
		 * @param	childAll
		 * @param	w
		 * @param	h
		 * @param	x
		 * @param	y
		 * @return 
		 */
		public static function ringPoint(childNum:uint,childAll:uint,w:uint = 100, h:uint = 50, x:int = 100, y:int = 50):Object {
			if (w == 0) w = 100;
			if (h == 0) h = 100;
			var pt:Object
			if(childNum>=childAll||childAll<0)return pt
			var _fangle:Number = 360 /childAll;
			//转换0-360角度
			var angle:Number
			var _pAngle:Number
			angle = _fangle * (childNum)+90;
			angle = angle % 360
			angle = angle < 0?angle + 360:angle;
			_pAngle = angle * Math.PI / 180;
			//trace(angle)
			pt = { x:Math.cos(_pAngle) * w + x, y:Math.sin(_pAngle) * h + y ,angle:angle}
			if (angle > 180) {
				if (angle > 180 && angle < 270) pt.value = 1 - (angle-180) / 90
				else pt.value=(angle-270)/90
			}else pt.value=1
			//trace('x:'+pt.x,'y:'+pt.y,'value:'+pt.value,'angle:'+pt.angle)
			return pt
		}
		/**
		 * 环形技术排列的位置
		 * @param	childNum 在列表中实际位置
		 * @param	childAll 列表长度
		 * @param	startNum 起始位置
		 * @return
		 */
		public static function ringPointNum(childNum:uint =7, childAll:uint = 8, startNum:uint = 3):uint {
			var num:uint
			if (childNum < startNum) num = -(0 - startNum - childNum)
			if (childNum == startNum) num = 0
			if (childNum > startNum)num = childAll - 1 - startNum
			return 0
		}
		//------------------------------------------环状 end--------------------
	}

}