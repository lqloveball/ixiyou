package com.ixiyou.utils.display 
{
	/**
	 * 我的常用位图出来
	 * @author spe
	 */
	public class BitmapSpeUtil
	{
		import com.ixiyou.speUI.collections.ScaleBitmap;
		import flash.display.*;
		import flash.geom.*
		/**
		 * 提供一个Bitmap
		 * @param	value
		 * @return
		 */
		public static function getBitmapFromBitmapData(value:BitmapData):Bitmap {
			return new Bitmap(value)
		}
		/**
		 * 提供一个Bitmap
		 * @param	value
		 * @return
		 */
		public static function getBitmapFromString(value:String):Bitmap {
			return new Bitmap(BitmapData2String.decode64(value))
		}
		/**
		 * 绘制一个位图
		 * 
		 * @param displayObj
		 * @return 
		 * 
		 */
		public static function getBitmapFromDisplayObject(displayObj:DisplayObject):Bitmap
		{
			var rect:Rectangle = displayObj.getBounds(displayObj);
			var m:Matrix = new Matrix();
			m.translate(-rect.x,-rect.y);
			var bitmap:BitmapData = new BitmapData(rect.width,rect.height,true,0);
			bitmap.draw(displayObj, m);
			return new Bitmap(bitmap);
		}
		/**
		 * 
		 * @param	value
		 * @param	rect
		 * @return
		 */
		public static function getScaleBitmap0(value:String,rect:Rectangle):ScaleBitmap {
			var temp:ScaleBitmap 
			temp = new ScaleBitmap(BitmapData2String.decode64(value));
			try 
			{
				temp.scale9Grid = rect
			} catch (e:TypeError) {
				return null
			}
			return temp
		}
		/**
		 * 提供一9宫格图片
		 * @param	value
		 * @param	rect
		 * @return 9宫格的图片
		 */
		public static function getScaleBitmap1(value:BitmapData,rect:Rectangle):ScaleBitmap {
			var temp:ScaleBitmap 
			temp = new ScaleBitmap(value);
			try 
			{
				temp.scale9Grid = rect
			} catch (e:TypeError) {
				return null
			}
			return temp
		}
		/**
		 * 提供一9宫格图片
		 * @param	value
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 * @return
		 */
		public static function getScaleBitmap2(value:BitmapData, x:uint = 0, y:uint = 0, width:uint = 0, height:uint = 0):ScaleBitmap {
			return getScaleBitmap1(value,new Rectangle(x,y,width,height))
		}
	}

}