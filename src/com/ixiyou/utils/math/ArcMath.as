package com.ixiyou.utils.math
{
	
	/**
	* 圆弧、角度方面计算
	* @author spe
	*/
	import flash.geom.Point
	
	public class ArcMath 
	{
		public static function sinD(angle:Number):Number {
			return Math.sin(angle * Math.PI / 180);
		}

		public static function cosD(angle:Number):Number {
			return Math.cos(angle * Math.PI / 180);
		}

		public static function tanD(angle:Number):Number {
			return Math.tan(angle * Math.PI / 180);
		}

		public static function asinD(ratio:Number):Number {
			return Math.asin(ratio) * 180 / Math.PI;
		}

		public static function acosD(ratio:Number):Number {
			return Math.acos(ratio) * 180 / Math.PI;
		}

		public static function atanD(ratio:Number):Number {
			return Math.atan(ratio) * 180 / Math.PI;
		}
		
		public static function atan2D(y:Number,x:Number):Number {
			return Math.atan2(y,x) * 180 / Math.PI;
		}
		/*求两点间距离*/
		public static function distance(x1:Number,y1:Number,x2:Number,y2:Number):Number {
			var dx:Number=x2 - x1;
			var dy:Number=y2 - y1;
			return Math.sqrt(dx * dx + dy * dy);
		}
		/*计算两点间连线的倾斜角*/
		public static function angleOfLine(x1:Number,y1:Number,x2:Number,y2:Number):Number {
			return atan2D(y2 - y1,x2 - x1);
		}
		/*角度度转换为弧度*/
		public static function degreesToRadians(angle:Number):Number {
			return angle * Math.PI / 180;
		}
		/*弧度转换为角度*/
		public static function radiansToDegrees(angle:Number):Number {
			return angle * 180 / Math.PI;
		}
		/*将一个角度转化为在0~360度之间*/
		public static function fixAngle(angle:Number):Number {
			angle%= 360;
			return angle < 0?angle + 360:angle;
		}
		/*将笛卡尔坐标系转化为极坐标系,p为点对象*/
		public static function cartesianToPolar(px:Number,py:Number):Point {
			var rt:Point=new Point();
			var radius:Number=Math.sqrt(px * px + py * py);//半径
			var theta:Number=atan2D(py,px);//角度
			rt.x=radius;
			rt.y=theta;
			return rt;
		}
		/*将极坐标系转化为笛卡尔坐标系*/
		public static function polarToCartesian(pr:Number,pt:Number):Point {
			var rt:Point=new Point();
			var x:Number=pr * cosD(pt);
			var y:Number=pr * sinD(pt);
			rt.x=x;
			rt.y=y;
			return rt;
		}
		/**角度，圆形点x,y，X方向轴长，Y方轴长，计算椭圆形 上的点
		 * @param x0圆形点x
		 * @param y0圆形点y
		 * @param a X方向轴长
		 * @param b Y方轴长 为空就是园形
		 * @param r 角度
		 * @return 
		*/
		static public function getRPoint(x0:Number, y0:Number,  r:Number,a:Number, b:Number=0):Point { 
			r=fixAngle(r)
		   r = r * Math.PI / 180; 
		   if (b == 0) b = a
		   var point:Point=new Point(Math.cos(r) * a + x0,Math.sin(r) * b + y0)
		   return point
		} 
		
	
		/**
		 * 知道半径 角度 算出在圆形上的点
		 * @param	_angle
		 * @param	Hypotenuse
		 * @param	_mPoint
		 * @return
		 */
		static public function  dot_angle_Hypotenuse(_angle:Number, Hypotenuse:Number, _mPoint:Point = null):Point {
			
			if(_mPoint==null)_mPoint=new Point(0, 0)
			var value:Point
			var _x:Number 
			var _y:Number
			//先记录原数据
			var __angle:Number = _angle
			//超过360或小于0的都转换下
			_angle=fixAngle(_angle)
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
				_x += _mPoint.x
				_y += _mPoint.y
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
					_x = 0-adjacent
					_y=0 - opposite
				}
				else if (_angle > 270 && _angle < 360) {
					_x = 0 + adjacent
					_y=	0-opposite
				}else {
					_x = 0 + adjacent
					_y=0+opposite
				}
				_x += _mPoint.x
				_y += _mPoint.y
				value=new Point(_x,_y)
				return value
			}
		}
		/**半径和360的角度 算出邻边(斜边 和角度计算 邻边)
		 * 
		 * @param isBool 是否允许带负数坐标 默认是长度无负
		 * @return 0出现先在坐标线上了
		*/
		static public function adjacent_angle360_Hypotenuse(_angle:Number, Hypotenuse:Number, isBool:Boolean = false):Number {
			
			_angle=fixAngle(_angle)
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
			 return adjacent_angle_Hypotenuse(_angle, Hypotenuse, isBool)
		}
		/**半径和夹角度 算出邻边(斜边 和角度计算 邻边)
		 * 
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
			_angle=fixAngle(_angle)
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
			return opposite_angle_Hypotenuse(_angle, Hypotenuse,isBool)
		}
		/**一个对边，一个角算 斜边
		 * 
		 * @param 
		 * @return 
		*/
		static public function Edge_angle_Hypotenuse(_angle:Number, Edge:Number, isBool:Boolean = false):Number {
			//出现在线上直接是0
			if ((_angle==0|| _angle == 90)||(_angle==270|| _angle == 360)||_angle == 180) {
				return 0
			}
			var opposite:Number = Edge/(Math.sin(_angle * Math.PI / 180))
			if (!isBool) return Math.abs(opposite)
			else return opposite
		}
		/**半径和夹角度 算出对边(斜边 和角度计算 对边)
		 * 
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
		/**返回当前点处在另外一点的哪个象限中 或 返回另外一点处在当前点的哪个象限中,0为在坐标线上
		 * 
		 * 21
		 * 34
		 * @param isMaster 反转象限(对应关系反过啦)
		 * @return 0出现先在坐标线上了
		*/
		static public function quadrant(_zPoint:Point,_mPoint:Point,isMaster:Boolean = false):int{
			var _x:Number =_zPoint.x
			var _y:Number=_zPoint.y;
			if(_x == _mPoint.x || _y == _mPoint.y){
				return 0;
			}
			var num:int;
			var p1:Boolean = (_x - _mPoint.x) > 0;
			var p2:Boolean = (_y - _mPoint.y) > 0;
			num = isMaster ? (p1 ? (p2 ? 2 : 3) : (p2 ? 1 : 4)) : (p1 ? (p2 ? 4 : 1) : (p2 ? 3 : 2));
			return num;
		}
		/**计算2点的距离
		 * 
		 * @param isQuadrant 非负
		 * @return 
		*/
		static public function distance2(_zPoint:Point,_mPoint:Point,isQuadrant:Boolean = false):Number{
			var _x:Number =_zPoint.x
			var _y:Number=_zPoint.y;
			var num:Number = Math.sqrt(Math.pow(_mPoint.x - _x, 2) + Math.pow(_mPoint.y - _y, 2));
			//非负
			if(!isQuadrant) num = Math.abs(num);
			return num;
		}
		/**2点间的夹角关系 _zPoint相对于_mPoint，呵呵，和实际算数是反的哦
		 * 
		 * @param isRadian 是否转用弧度
		 * @return 
		*/
		static public function angle2(_zPoint:Point,_mPoint:Point,isRadian:Boolean = false):Number{
		  var _x:Number =_zPoint.x
		  var _y:Number=_zPoint.y
		  var numx:Number = _mPoint.x - _x;
		  var numy:Number = _mPoint.y - _y;
		  var num:Number = Math.atan(numy/numx);
		  if(!isRadian) num = num * 180 / Math.PI;
		  return num;
		}
		/**计算2个点之间的角度关系 _zPoint相对于_mPoint
		 * 
		 * @param isRadian 是否转用弧度
		 * @return 
		*/
		static public function angle(_zPoint:Point, _mPoint:Point, isRadian:Boolean = false):Number {
			var _x:Number =_zPoint.x
			var _y:Number=_zPoint.y
			var numx:Number = _mPoint.x - _x;
			var numy:Number = _mPoint.y - _y;
			var num:Number = Math.atan(numy/numx);
			if (!isRadian) {
				num = Math.abs(num) * 180 / Math.PI;// 弧度转角度
				var temp:int=quadrant(_zPoint,_mPoint)
				if (num == 0 &&temp==0&&_x>_mPoint.x) {
					num=0
				}
				else if(num == 0 &&temp==0&&_x<_mPoint.x) {
					num=180
				}
				else if(num == 90 &&temp==0&&_y>_mPoint.y) {
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
		/**360角转夹角
		 * 
		 * @param 
		 * @return 
		*/
		public static function angle360ToAngle(_angle:Number):Number {
			_angle = fixAngle(_angle)
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
		/**360角计算象限
		 *
		 * @param 
		 * @return 
		*/
		public static function angleToQuadrant(_angle:Number):Number {
			_angle=fixAngle(_angle)
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