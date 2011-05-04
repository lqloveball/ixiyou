package com.ixiyou.utils.math 
{
	import flash.geom.Point;
	
	/**
	 * 直线 y=k*x+c
	 * 用于点和线之间的简单几何运算
	 * @author magic
	 */
	public class Line 
	{
		/**
		 * 斜率
		 */
		public var k:Number;
		/**
		 * 常数系数
		 */
		public var c:Number;
		public function Line(k:Number=1,c:Number=0) 
		{
			this.k = k;
			this.c = c;
		}
		
		/**
		 * 点到线的垂线
		 * @param	pt
		 * @return
		 */
		public function rightLine(pt:Point):Line {
			var tempK:Number = -1 / k;
			var tempC:Number = pt.y - pt.x * tempK;
			return new Line(tempK, tempC);
		}
		
		/**
		 * 垂点
		 * @param	pt
		 * @return
		 */
		public function rightPoint(pt:Point):Point {
			return crossPoint(rightLine(pt));
		}
		
		/**
		 * 垂距
		 * @param	pt
		 * @return
		 */
		public function rightDistance(pt:Point):Number {
			return Point.distance(rightPoint(pt), pt);
		}
		
		/**
		 * 交点
		 * @param	line
		 * @return
		 */
		public function crossPoint(line:Line):Point {
			var x:Number = (c - line.c) / (line.k - k);
			var y:Number = x * k + c;
			return new Point(x, y);
		}
		
		/**
		 * 平行线间的距离
		 * @param	line
		 * @return
		 */
		public function distance(line:Line):Number {
			if (line.k != k) return 0;
			return rightDistance(new Point(line.getX(0), 0));
		}
		
		/**
		 * 已知直线的y值求x值
		 * @param	y
		 * @return
		 */
		public function getX(y:Number):Number {
			return (y-c)/k
		}
		
		/**
		 * 已知直线的x值求y值
		 * @param	x
		 * @return
		 */
		public function getY(x:Number):Number {
			return k * x + c;
		}
		/**
		 * 求已知横坐标所在的点
		 * @param	x
		 * @return
		 */
		public function getPointByX(x:Number):Point {
			return new Point(x, k * x + c);
		}
		/**
		 * 求已知纵坐标所在的点
		 * @param	y
		 * @return
		 */
		public function getPointByY(y:Number):Point {
			return new Point((y - c) / k, y);
		}
		/**
		 * 是否相等
		 * @param	line
		 * @return
		 */
		public function equal(line:Line):Boolean {
			return line.k == k && line.c == c;
		}
		
		/**
		 * 克隆
		 * @return
		 */
		public function clone():Line {
			return new Line(k, c);
		}
		
		/**
		 * 由两个点创建一条直线
		 * @param	pt1
		 * @param	pt2
		 * @return
		 */
		public static function getLineByPoint(pt1:Point,pt2:Point):Line {
			var k:Number = (pt1.y - pt2.y) / (pt1.x - pt2.x);
			var c:Number = pt1.y - pt1.x * k;
			return new Line(k, c);
		}
	}
	
}