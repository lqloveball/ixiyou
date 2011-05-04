package com.ixiyou.utils.display 
{
	import flash.display.DisplayObject;
	import flash.geom.*;
	/**
	 * 形状变形
	 * @author spe
	 */
	public class TransformUtil
	{
		/**
		 * 创建按缩放比的矩阵 
		 * @param width
		 * @param height
		 * @param rotation
		 * @param tx
		 * @param ty
		 * @return 
		 * 
		 */
		public static function createBox(scaleX:Number,scaleY:Number,rotation:Number = 0,tx:Number = 0,ty:Number = 0):Matrix
		{
			var m:Matrix = new Matrix();
			m.createBox(scaleX,scaleY,rotation,tx,ty);	
			return m;
		}
		
		/**
		 * 创建用于填充的矩阵
		 * @param width
		 * @param height
		 * @param rotation
		 * @param tx
		 * @param ty
		 * 
		 */
		public static function createGradientBox(width:Number,height:Number,rotation:Number = 0,tx:Number = 0,ty:Number = 0):Matrix
		{
			var m:Matrix = new Matrix();
			m.createGradientBox(width,height,rotation,tx,ty);	
			return m;
		}
		
		/**
		 * 矩阵相加
		 * @param m1
		 * @param m2
		 * @return 
		 * 
		 */
		public static function concat(m1:Matrix,m2:Matrix):Matrix
		{
			var m:Matrix = m1.clone();
			m.concat(m2);
			return m;
		}
		
		/**
		 * 矩阵取反
		 * @param m
		 * @return 
		 * 
		 */
		public static function invert(m:Matrix):Matrix
		{
			var m:Matrix = m.clone();
			m.invert();
			return m;
		}
		
		/**
		 * 自定义注册点缩放
		 * 
		 * @param displayObj	显示对象
		 * @param scaleX	缩放比X
		 * @param scaleY	缩放比Y
		 * @param point	新的注册点（相对于原注册点的坐标）
		 * 
		 */        
		public static function scaleAt(displayObj:DisplayObject,scaleX:Number,scaleY:Number,point:Point=null):void   
		{   
			if (!point)
				point = new Point();
		
			var m:Matrix = displayObj.transform.matrix;
			m.translate(-point.x,-point.y);  
			m.a = scaleX;
			m.d = scaleY;
			m.translate(point.x,point.y);   
			displayObj.transform.matrix = m;
		}
		
		/**
		 * 自定义注册点旋转
		 * 
		 * @param displayObj	显示对象
		 * @param angle	旋转角度（0 - 360）
		 * @param point	新的注册点（相对于原注册点的坐标）
		 * 
		 */								
		public static function rotateAt(displayObj:DisplayObject,angle:Number,point:Point=null):void   
		{   
			if (!point)
				point = new Point();
			
			var m:Matrix = new Matrix();
			m.translate(-point.x, -point.y); 
			m.rotate(angle / 180 * Math.PI);
			m.translate(point.x, point.y);  
			displayObj.transform.matrix = m;
		}
		
		/**
		 * 水平翻转
		 */
		public static function flipH(displayObj:DisplayObject):void
		{
			var m:Matrix = displayObj.transform.matrix.clone();
			m.a = -m.a;
			displayObj.transform.matrix = m;
		}
		
		/**
		 * 垂直翻转
		 */		
		public static function flipV(displayObj:DisplayObject):void
		{
			var m:Matrix = displayObj.transform.matrix.clone();
			m.d = -m.d;
			displayObj.transform.matrix = m;
		}
		
		/**
		 * 按像素斜切
		 * @param displayObj
		 * 
		 */
		public static function chamfer(displayObj:DisplayObject,dx:Number = 0,dy:Number = 0):void
		{
			var rect:Rectangle = displayObj.getRect(displayObj);
			
			var m:Matrix = displayObj.transform.matrix.clone();
			m.c = Math.tan(Math.atan2(dx,rect.height));
			m.b = Math.tan(Math.atan2(dy,rect.width));
			displayObj.transform.matrix = m;
		}
	}

}