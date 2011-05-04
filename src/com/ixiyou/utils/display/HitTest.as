package com.ixiyou.utils .display
{
		
	import flash.display.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 不规则物品碰撞检测
	 * 
	 */
	public class HitTest
	{
		/**
		 * 不规则物品碰撞检测
		 * 
		 * @param target1	物品1
		 * @param target2	物品2
		 * @param accurracy	检测精度
		 * @return 
		 * 
		 */
		public static function complexHitTestObject(target1:DisplayObject, target2:DisplayObject, accurracy:Number = 1):Boolean
		{
			return complexIntersectionRectangle(target1,target2,accurracy).width != 0;
		}
		                
		/**
		 * 获得两个不规则物品的交叠矩形
		 *  
		 * @param target1	物品1
		 * @param target2	物品2
		 * @param accurracy	检测精度
		 * @return 
		 * 
		 */
		public static function complexIntersectionRectangle(target1:DisplayObject,target2:DisplayObject, accurracy:Number = 1):Rectangle
		{                     
			if (accurracy <= 0) 
				throw new Error("ArgumentError: Error #5001: Invalid value for accurracy",5001);
			
			if (!target1.hitTestObject(target2)) 
				return new Rectangle();
			
			var hitRectangle:Rectangle = intersectionRectangle( target1, target2 );
			if (hitRectangle.width * accurracy < 1 || hitRectangle.height * accurracy < 1) 
				return new Rectangle();
			
			try
			{                        
				var bitmapData:BitmapData = new BitmapData(hitRectangle.width * accurracy, hitRectangle.height * accurracy, false, 0x000000); 
			}
			catch(e:Error)
			{
				return new Rectangle();
			}
			
			bitmapData.draw(target1, getDrawMatrix( target1, hitRectangle, accurracy ), new ColorTransform( 1, 1, 1, 1, 255, -255, -255, 255 ) );
			bitmapData.draw(target2, getDrawMatrix( target2, hitRectangle, accurracy ), new ColorTransform( 1, 1, 1, 1, 255, 255, 255, 255 ), BlendMode.DIFFERENCE );
			
			var intersection:Rectangle = bitmapData.getColorBoundsRect( 0xFFFFFFFF,0xFF00FFFF );
			bitmapData.dispose();
			
			if (accurracy != 1)
			{
				intersection.x /= accurracy;
				intersection.y /= accurracy;
				intersection.width /= accurracy;
				intersection.height /= accurracy;
			}
			
			intersection.x += hitRectangle.x;
			intersection.y += hitRectangle.y;
			
			return intersection;
		}
		
		//修正绘制位图时的大小问题
		private static function getDrawMatrix(target:DisplayObject, hitRectangle:Rectangle, accurracy:Number):Matrix
		{
			var localToGlobal:Point;;
			var matrix:Matrix;
			                        
			var rootConcatenatedMatrix:Matrix = target.stage.transform.concatenatedMatrix;
			                        
			localToGlobal = target.localToGlobal(new Point());
			matrix = target.transform.concatenatedMatrix;
			matrix.tx = localToGlobal.x - hitRectangle.x;
			matrix.ty = localToGlobal.y - hitRectangle.y;
			
			matrix.a = matrix.a / rootConcatenatedMatrix.a;
			matrix.d = matrix.d / rootConcatenatedMatrix.d;
			if (accurracy != 1) 
				matrix.scale( accurracy, accurracy );
			
			return matrix;
		}
		
		/**
		 * 获得两个矩形物体的交叠矩形（比complexIntersectionRectangle要快）
		 * 
		 * @param target1
		 * @param target2
		 * @return 
		 * 
		 */
		public static function intersectionRectangle(target1:DisplayObject, target2:DisplayObject):Rectangle
		{
			if (!target1.stage || !target2.stage) 
				return new Rectangle();
			
			var bounds1:Rectangle = target1.getBounds(target1.stage);
			var bounds2:Rectangle = target2.getBounds(target2.stage);
			 
			return bounds1.intersection(bounds2);
		}
		
		/**
		 * 遍历第2个物体的子对象并执行一次HitTestObject
		 * 
		 * @param target1
		 * @param target2
		 * @return 
		 * 
		 */
		public static function hitTestObjectChildren(target1:DisplayObject,target2:DisplayObject):Boolean
		{
			var size:int = (target2 is DisplayObjectContainer)?(target2 as DisplayObjectContainer).numChildren : 0;
			if (size == 0)
				return target1.hitTestObject(target2);
			else
			{
				for (var i:int = 0;i < size;i++)
				{
					if (target1.hitTestObject((target2 as DisplayObjectContainer).getChildAt(i)))
						return true;
				}
			}
			return false;
		}
		
		/**
		 * 遍历物体的子对象并执行一次HitTestPoint
		 * 
		 * @param target2
		 * @param x	舞台x
		 * @param y	舞台y
		 * @param shapeFlag	是否位图检测
		 * @return 
		 * 
		 */
		public static function hitTestPointChildren(target2:DisplayObject,x:Number,y:Number,shapeFlag:Boolean=false):Boolean
		{
			var size:int = (target2 is DisplayObjectContainer)?(target2 as DisplayObjectContainer).numChildren : 0;
			if (size == 0)
				return target2.hitTestPoint(x,y,shapeFlag);
			else
			{
				for (var i:int = 0;i < size;i++)
				{
					var item:DisplayObject = (target2 as DisplayObjectContainer).getChildAt(i);
					if (item.hitTestPoint(x,y))
					{
						if (shapeFlag)
						{
							if (item.hitTestPoint(x,y,shapeFlag))
								return true;
						}
						else
							return true;
					}
				}
			}
			return false;
		}
		
		/**
		 * 遍历第2个物体的子对象并执行一次complexHitTestObject
		 *  
		 * @param target1
		 * @param target2
		 * @return 
		 * 
		 */
		public static function complexHitTestObjectChildren(target1:DisplayObject,target2:DisplayObject):Boolean
		{
			var size:int = (target2 is DisplayObjectContainer)?(target2 as DisplayObjectContainer).numChildren : 0;
			if (size == 0)
				return complexHitTestObject(target1,target2);
			else
			{
				for (var i:int = 0;i < size;i++)
				{
					if (complexHitTestObject(target1,(target2 as DisplayObjectContainer).getChildAt(i)))
						return true;
				}
			}
			return false;
		}
	}
}