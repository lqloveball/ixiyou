package com.ixiyou.utils.display 
{
	
	
	/**
	 * 镜像显示对象，镜像出来的显示内容是由对原对象进行位图绘制得到的
	 * @author magic
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	 
	 
	public class DisplayCopy 
	{
		/**根据显示对象生成一个shape
		 * @param	view
		 * @param	rect
		 * @return
		 */
		public static function copyAsShape(view:DisplayObject,rect:Rectangle=null):Shape {
			if (rect == null) {
				if (view.stage) {
					rect = view.stage.getRect(view);
				}
				else rect = view.getRect(view);
				trace(rect)
			}
			var shape:Shape = new Shape();
			var db:BitmapData = copyAsBitmapData(view, rect);
			shape.graphics.beginBitmapFill(db,new Matrix(1,0,0,1,rect.x,rect.y));
			shape.graphics.drawRect(rect.x,rect.y, db.width, db.height);
			shape.x = view.x;
			shape.y = view.y;
			//db.dispose();
			return shape;
		}
		
		/**
		 * 根据显示对象生成一个bitmap
		 * @param	view
		 * @param	rect
		 * @return
		 */
		public static function copyAsBitmap(view:DisplayObject, rect:Rectangle = null):Bitmap {
			if (rect == null) {
				rect = view.getRect(view);
			}
			var db:BitmapData = copyAsBitmapData(view, rect);
			var bitmap:Bitmap = new Bitmap(db);
			bitmap.x = view.x+rect.x;
			bitmap.y = view.y+rect.y;
			return bitmap;
		}
		
		/**
		 * 根据显示对象生成一个sprite
		 * @param	view
		 * @param	rect
		 * @return
		 */
		public static function copyAsSprite(view:DisplayObject, rect:Rectangle = null):Sprite {
			if (rect == null) {
				rect = view.getRect(view);
			}
			var db:BitmapData = copyAsBitmapData(view, rect);
			var sp:Sprite = new Sprite();
			sp.graphics.beginBitmapFill(db,new Matrix(1,0,0,1,-rect.x,-rect.y));
			sp.graphics.drawRect(rect.x, rect.y, db.width, db.height);
			sp.x = view.x;
			sp.y = view.y;
			//db.dispose();
			return sp;
		}
		
		/**
		 * 根据显示对象生成一个bitmapdata
		 * @param	view
		 * @param	rect
		 * @return
		 */
		public static function copyAsBitmapData(view:DisplayObject, rect:Rectangle = null):BitmapData {
			if (rect == null) {
				rect = view.getRect(view);
			}
			var db:BitmapData = new BitmapData(int(rect.width), int(rect.height), true, 0);
			db.draw(view,new Matrix(1,0,0,1,-rect.x,-rect.y));
			return db;
		}
	}
	
}