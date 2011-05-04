package com.ixiyou.utils.math
{
	
	/**
	* 坐标计算的方法
	* @author spe
	*/
	import flash.geom.Point
	public class MGraphPaper 
	{
		/**
		 * 任意数转成360角度
		 * @param 
		 * @return 
		*/
		static public function angle360(_angle:Number):Number {
			//超过360或小于0的都转换下
			if(_angle==360||_angle==0)return _angle
			_angle = _angle % 360
			if (_angle < 0) {
				_angle = 360 + _angle
			}
			return _angle
		}
		/**
		 * 知道半径 角度 算出在圆形上的点
		 * @param 
		 * @return 
		*/
		static public function  dot_angle_Hypotenuse(_angle:Number, Hypotenuse:Number, _Point:Point = null):Point {
			if(_Point==null)_Point=new Point(0, 0)
			var value:Point
			var _x:Number 
			var _y:Number
			//先记录原数据
			var __angle:Number = _angle
			//超过360或小于0的都转换下
			_angle = ArcMath.fixAngle(_angle)
			/*
			if (_angle >=360) {
				_angle = _angle % 360
			}
			if (_angle < 0) {
				_angle = 360 + _angle
			}
			*/
			//如果出现在坐标线上
			if ((_angle==0|| _angle == 90)||(_angle==270|| _angle == 360)||_angle == 180 ) {
				if (_angle == 0) {
					_y = 0
					_x=0+Hypotenuse
				}
				else if (_angle ==360) {
					_y = 0
					_x=0-Hypotenuse
				}
				else if (_angle == 90) {
					_y = 0+Hypotenuse
					_x=0
				}
				else if (_angle == 180) {
					_y = 0
					_x=0-Hypotenuse
				}
				else if (_angle == 270) {
					_y = 0-Hypotenuse
					_x=0
				}
				_x += _Point.x
				_y += _Point.y
				value=new Point(_x,_y)
				return value
			}else {
				//对边
				var opposite:Number=MGraphPaper.opposite_angle_Hypotenuse(_angle, Hypotenuse)
				//邻边
				var adjacent:Number = MGraphPaper.adjacent_angle_Hypotenuse(_angle, Hypotenuse)
				if (_angle > 90 && _angle < 180) {
					_x = 0 - adjacent 
					_y = 0+ opposite
					//trace(opposite)
				}else if (_angle > 180 && _angle < 270) {
					_x = 0 - opposite
					_y=0-adjacent
				}
				else if (_angle > 270 && _angle < 360) {
					_x = 0 + adjacent
					_y=	0-opposite
				}else {
					_x = 0 + adjacent
					_y=0+opposite
				}
				_x += _Point.x
				_y += _Point.y
				value=new Point(_x,_y)
				return value
			}
		}
		/**
		 * 圆心点半径和360的角度 算出邻边(斜边 和角度计算 邻边)
		 * @param isBool 是否允许带负数坐标 默认是长度无负
		 * @return 0出现先在坐标线上了
		*/
		static public function adjacent_angle360_Hypotenuse(_angle:Number, Hypotenuse:Number, isBool:Boolean = false):Number {
			
			_angle=angle360(_angle)
			//出现在线上直接是0
			if ((_angle==0|| _angle == 90)||(_angle==270|| _angle == 360) ||_angle == 180) {
				return 0
			}
			//转成象限坐标
			if (_angle > 90 && _angle <=180) {
				_angle=0-(180-_angle)
			}
			else if (_angle > 180 && _angle  <=270) {
				_angle=(270-_angle)
			}
			else if (_angle > 270 && _angle  <=360) {
				_angle=0-(360-_angle)
			}
			var adjacent:Number = Math.cos(_angle * Math.PI / 180) * Hypotenuse
			if (!isBool) return Math.abs(adjacent)
			else return adjacent
		}
		/**
		 * 半径和夹角度 算出邻边(斜边 和角度计算 邻边)
		 * @param isBool 是否允许带负数坐标 默认是长度无负
		 * @return 0出现先在坐标线上了
		*/
		static public function adjacent_angle_Hypotenuse(_angle:Number, Hypotenuse:Number, isBool:Boolean = false):Number {
			//出现在线上直接是0
			if ((_angle==0|| _angle == 90)||(_angle==270|| _angle == 360)||_angle == 180) {
				return 0
			}
			var adjacent:Number = Math.cos(_angle * Math.PI / 180) * Hypotenuse
			if (!isBool) return Math.abs(adjacent)
			else return adjacent
		}
		/**半径和360角度 算出对边(斜边 和角度计算 对边)
		 * 
		 * @param isBool 是否允许带负数坐标 默认是长度无负
		 * @return 0出现先在坐标线上了
		*/
		static public function opposite_angle360_Hypotenuse(_angle:Number, Hypotenuse:Number,isBool:Boolean=false):Number {
			_angle=angle360(_angle)
			//出现在线上直接是0
			if ((_angle==0|| _angle == 90)||(_angle==270|| _angle == 360)||_angle == 180) {
				return 0
			}
			//转成象限坐标
			if (_angle > 90 && _angle <=180) {
				_angle=0-(180-_angle)
			}
			else if (_angle > 180 && _angle  <=270) {
				_angle=(270-_angle)
			}
			else if (_angle > 270 && _angle  <=360) {
				_angle=0-(360-_angle)
			}
			var opposite:Number = Math.sin(_angle * Math.PI / 180) * Hypotenuse
			if (!isBool) return Math.abs(opposite)
			else return opposite
		}
		/**
		 * 半径和夹角度 算出对边(斜边 和角度计算 对边)
		 * @param isBool 是否允许带负数坐标 默认是长度无负
		 * @return 0出现先在坐标线上了
		*/
		static public function opposite_angle_Hypotenuse(_angle:Number, Hypotenuse:Number,isBool:Boolean=false):Number {
			//出现在线上直接是0
			if ((_angle==0|| _angle == 90)||(_angle==270|| _angle == 360)||_angle == 180) {
				return 0
			}
			var opposite:Number = Math.sin(_angle * Math.PI / 180) * Hypotenuse
			if (!isBool) return Math.abs(opposite)
			else return opposite
		}
		/**
		 * 返回当前点处在另外一点的哪个象限中 或 返回另外一点处在当前点的哪个象限中,0为在坐标线上
		 * 21
		 * 34
		 * @param isMaster 反转象限(对应关系反过啦)
		 * @return 0出现先在坐标线上了
		*/
		static public function quadrant(_zPoint:Point,_Point:Point,isMaster:Boolean = false):int{
			var _x:Number =_zPoint.x
			var _y:Number=_zPoint.y;
			if(_x == _Point.x || _y == _Point.y){
				return 0;
			}
			var num:int;
			var p1:Boolean = (_x - _Point.x) > 0;
			var p2:Boolean = (_y - _Point.y) > 0;
			num = isMaster ? (p1 ? (p2 ? 2 : 3) : (p2 ? 1 : 4)) : (p1 ? (p2 ? 4 : 1) : (p2 ? 3 : 2));
			return num;
		}
		/**
		 * 计算2点的距离
		 * @param isQuadrant 非负
		 * @return 
		*/
		static public function getToPoint(_zPoint:Point,_Point:Point,isQuadrant:Boolean = false):Number{
			var _x:Number =_zPoint.x
			var _y:Number=_zPoint.y;
			var num:Number = Math.sqrt(Math.pow(_Point.x - _x, 2) + Math.pow(_Point.y - _y, 2));
			//非负
			if(!isQuadrant) num = Math.abs(num);
			return num;
		}
		/**
		 * 2点间的夹角关系 顺时，呵呵，和实际算数是反的哦
		 * @param 
		 * @return 
		*/
		static public function angle2(_zPoint:Point,_Point:Point,isRadian:Boolean = false):Number{
		  var _x:Number =_zPoint.x
		  var _y:Number=_zPoint.y
		  var numx:Number = _Point.x - _x;
		  var numy:Number = _Point.y - _y;
		  var num:Number = Math.atan(numy/numx);
		  if(!isRadian) num = num * 180 / Math.PI;
		  return num;
		}
		/**
		 * 计算2个点之间的角度关系 _zPoint相对于_Point
		 * @param isRadian 是否转用弧度
		 * @return 
		*/
		static public function angle(_zPoint:Point, _Point:Point, isRadian:Boolean = false):Number {
			var _x:Number =_zPoint.x
			var _y:Number=_zPoint.y
			var numx:Number = _Point.x - _x;
			var numy:Number = _Point.y - _y;
			var num:Number = Math.atan(numy/numx);
			if (!isRadian) {
				num = Math.abs(num) * 180 / Math.PI;// 弧度转角度
				var temp:int=quadrant(_zPoint,_Point)
				if (num == 0 &&temp==0&&_x>_Point.x) {
					num=0
				}
				else if(num == 0 &&temp==0&&_x<_Point.x) {
					num=180
				}
				else if(num == 90 &&temp==0&&_y>_Point.y) {
					num=270
				}else if (temp == 2) {
					num=180-num
				}
				else if (temp == 3) {
					num=180+num
				}
				else if (temp == 4) {
					num=360-num
				}
				//上面按数学顺时针计算，这里要倒过来下
				if(num!=0)num=360-num
				return num
			}
			else {
				return num
			}
		
		}
		/**
		 * 360角转夹角（正常情况下）
		 * @param 
		 * @return 
		*/
		static public function angle360ToAngle(_angle:Number):Number {
			_angle = MGraphPaper.angle360(_angle)
		
			if ((_angle == 0 || _angle == 90) || (_angle == 270 || _angle == 360) || _angle == 180) {
				return 0
			}
			else {
				if (_angle > 90 && _angle <=180) {
					return 180-_angle
				}
				else if (_angle > 180 && _angle  <=270) {
					return _angle-180
				}
				else if (_angle > 270 && _angle  <=360) {
					return 360-_angle
				}
				else {
					return _angle
				}
			}
		}
		/**
		 * 360角换象限（正常情况下）
		 * @param 
		 * @return 
		*/
		static public function angleToQuadrant(_angle:Number):Number {
			_angle=MGraphPaper.angle360(_angle)
			if ((_angle == 0 || _angle == 90) || (_angle == 270 || _angle == 360) || _angle == 180) {
				return 0
			}
			else {
				
				if (_angle > 90 && _angle <=180) {
					return 2
				}
				else if (_angle > 180 && _angle  <=270) {
					return 3
				}
				else if (_angle > 270 && _angle  <=360) {
					return 4
				}
				else {
					return 1
				}
			}
		}
		
	}
	
}