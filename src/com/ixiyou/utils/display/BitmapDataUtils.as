package com.ixiyou.utils.display
{
	
	/**
	* 把一个显示对象转成BitmapData
	* @author spe
	*/
	public class BitmapDataUtils 
	{
		
		import flash.display.*;
		import flash.geom.Matrix;
		import flash.geom.Point;
		import flash.geom.Rectangle;
		import flash.geom.ColorTransform;
		import com.ixiyou.utils.math.MathUtil;
		import com.ixiyou.utils.ArrayUtil;
		/**
		 * 返回指定对象绘制的指定宽高BitmapData对象
		 * 
		 * @param d 绘制对象
		 * @param size 返回的BitmapData宽高
		 * @param area 只获取的对象大小
		 * @param backgroundColor 背景用来填补的颜色
		 * @return 
		*/
		static public function getBitmapDataBySize(d:DisplayObject, size:Rectangle, area:Rectangle = null, backgroundColor:int = -1):BitmapData
		{
			if(d.width < 1 || d.height < 1) return null;
			d = new Bitmap(getBitmapData(d,area));
			var s:Number = size.width/d.width < size.height/d.height ? size.width/d.width : size.height/d.height;
			//var s:Number =w/d.width < h/d.height ?w/d.width : h/d.height;
			var max:Matrix = new Matrix();
			max.scale(s,s);
			
			var p:Point = new Point();
				p.x = (size.width-d.width*s)/2;
				p.y = (size.height-d.height*s)/2;
				
			var old_bmd:BitmapData;
			old_bmd = new BitmapData(d.width*s,d.height*s,true,0xFFFFFF);
			old_bmd.draw(d,max);
			
			var new_bmd:BitmapData;
			if(backgroundColor == -1){
				new_bmd = new BitmapData(size.width,size.height,true,0xFFFFFF);
			}else{
				new_bmd = new BitmapData(size.width,size.height,false,backgroundColor);
			}
			new_bmd.copyPixels(old_bmd, new Rectangle(0, 0, old_bmd.width, old_bmd.height), p);
			old_bmd.dispose()
			old_bmd=null
			return new_bmd;
		}
		/**
		 * 返回指定宽高BitmapData对象
		 * @param d 绘制对象
		 * @param w h 返回的BitmapData宽高
		 * @param area 只获取的对象大小
		 * @param backgroundColor 背景用来填补的颜色
		 * @return 
		*/
		static public function getBitmapDataBySize2(d:DisplayObject, w:uint,h:uint, area:Rectangle = null, backgroundColor:int = -1):BitmapData
		{
			if(d.width < 1 || d.height < 1) return null;
			d = new Bitmap(getBitmapData(d,area));
			var s:Number =w/d.width < h/d.height ?w/d.width : h/d.height;
			
			var max:Matrix = new Matrix();
			max.scale(s,s);
			
			var p:Point = new Point();
				p.x = (w-d.width*s)/2;
				p.y = (h-d.height*s)/2;
				
			var old_bmd:BitmapData;
			old_bmd = new BitmapData(d.width*s,d.height*s,true,0xFFFFFF);
			old_bmd.draw(d,max);
			
			var new_bmd:BitmapData;
			if(backgroundColor == -1){
				new_bmd = new BitmapData(w,h,true,0xFFFFFF);
			}else{
				new_bmd = new BitmapData(w,h,false,backgroundColor);
			}
			new_bmd.copyPixels(old_bmd, new Rectangle(0, 0, old_bmd.width, old_bmd.height), p);
			old_bmd.dispose()
			old_bmd=null
			return new_bmd;
		}
		/**
		 * 返回指定对象绘制的BitmapData对象
		 * @param target 需要绘制的对象
		 * @param area 绘制区域
		 * @return 绘制好的BitmapData对象，如果指定对象大小为0或者指定区域大小为0,则返回null
		 * 
		 */		
		static public function getBitmapData(target:DisplayObject,area:Rectangle = null):BitmapData{
			//如果目标对象大小为空，则返回null
			if(target == null || target.width < 1 || target.height < 1) return null;
			//如果目标对象大小为空，则返回null
			if(area != null){
				if(area.width < 1 || area.height < 1) return null;
			}
			
			var result:BitmapData;
			if(area != null && area.width > 0 && area.height > 0){
				result = new BitmapData(area.width,area.height,true,0);
			}else{
				result = new BitmapData(target.width,target.height,true,0);
			}
			if (area){ result.draw(target, new Matrix(1,0, 0, 1,-area.x,-area.y))}
			else {result.draw(target)}
			return result;
		}
		/**
		 * 位图转 字符串
		 * @param 
		 * @return 
		*/
		/*
		public static function encode(img:BitmapData):String{
			//var a:uint = getTimer();
			var result:String = "";
			var w:uint = img.width;
			var h:uint = img.height;
			result = [w, h].toString();
			//trace(result)
			for(var i:uint = 0 ; i < h ; i ++){
				for(var j:uint = 0 ; j < w ; j++){
					var c:String = img.getPixel32(j,i).toString(16);
					if(c == "ffffffff") c = "";
					result = result + "," + c;
				}
			}
			
			return result;
		}
		*/
		/**
		 * 字符串 转 位图
		 * @param 
		 * @return 
		*/
		/*
		public static function decode(str:String):BitmapData{
			var result:BitmapData;
			var arr:Array = str.split(",");
			if(arr.length < 3) return null;
			var w:uint = uint(arr[0]);
			var h:uint = uint(arr[1]);
			
			result = new BitmapData(w,h,true,0);
			var len:uint = arr.length - 2;
			if (len != w * h) return result;
			arr.splice(0, 2)
			var _x:uint
			var _y:uint
			var c:String 
			for (var i:uint = 0 ; i < arr.length ; i ++) {
				_x = (i % w)
				_y=uint(i/w)
				c= arr[i];
				if (c == "") c = "ffffffff";
				result.setPixel32(_x,_y,uint("0x" + c));
			}
			return result;
		}
		*/
		
		/**
		 * 倒影对象
		 * @param	obj 显示对象
		 * @param	alpha1 透明度1
		 * @param	alpha2 透明度2
		 * @param	start 开始
		 * @param	end 结束
		 * @param	maskNum 角度
		 * @return
		 */
		static public function Reflection(obj:DisplayObject,alpha1:Number=0.8,alpha2:Number=0,start:uint=0,end:uint=255,maskNum:Number=.5):Bitmap{ 
			//对源显示对象做上下反转处理 
			var bd:BitmapData=new BitmapData(obj.width,obj.height,true,0); 
			var mdMtx:Matrix=new Matrix(); 
			mdMtx.d = -1;
			mdMtx.ty = bd.height; 
			bd.draw(obj,mdMtx); 
			//生成一个渐变遮罩 
			var width:int=bd.width; 
			var height:int=bd.height; 
			mdMtx=new Matrix(); 
			mdMtx.createGradientBox(width,height,maskNum * Math.PI); 
			var shape:Shape = new Shape(); 
			shape.graphics.beginGradientFill(GradientType.LINEAR,[0,0],[alpha1,alpha2],[start,end],mdMtx) 
			shape.graphics.drawRect(0,0,width,height); 
			shape.graphics.endFill(); 
			
			var mask_bd:BitmapData=new BitmapData(width,height,true,0); 
			mask_bd.draw(shape); 
			//生成最终效果 
			bd.copyPixels(bd,bd.rect,new Point(0,0),mask_bd,new Point(0,0),false); 
			//将倒影位图放在源显示对象下面 
			var ref:Bitmap = new Bitmap(); 
			ref.bitmapData=bd; 
			return ref
		}
		
		//------------------------- 以下方法来自 @author flashyiyi http://code.google.com/p/ghostcat/-------------------------//
		/**
		 * 获得一个位图的平均颜色
		 * 
		 * @param source	位图源
		 * @return 
		 * 
		 */
		public static function getAvgColor(source:BitmapData):uint
		{
			var m:Matrix = new Matrix();
			m.scale(1/source.width,1/source.height);
			var bitmap:BitmapData = new BitmapData(1,1,true,0);
			bitmap.draw(source,m);
			var c:uint = bitmap.getPixel32(0,0);
			bitmap.dispose();
			return c;
		}
		
		/**
		 * 将一个不透明的位图设置某个透明色并返回透明位图
		 * 
		 * @param source	位图源
		 * @param c	32位颜色值
		 * 
		 */
		public static function getTransparentBitmapData(source:BitmapData,transparentColor:uint=0xFFFFFFFF):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width,source.height,true,0);
			result.threshold(source,source.rect,new Point(),"==",transparentColor,0,0xFFFFFFFF,true);
			return result;
		}
		
		/**
		 * 魔术套索
		 *  
		 * @param source
		 * @param x
		 * @param y
		 * @param offest	取色容错范围
		 * @param near	是否连续
		 * @return 返回的是一个白色位图，非透明区域即是选择区域
		 * 
		 */
		public static function magicPole(source:BitmapData,x:int,y:int,offest:int = 0,near:Boolean = true):BitmapData
		{
			var c:uint = source.getPixel32(x,y);
			var c1:uint = offestColor(c,-offest);
			var c2:uint = offestColor(c,offest);
			var temp:BitmapData = new BitmapData(source.width,source.height,true,0xFFFFFFFF);
			temp.threshold(source,source.rect,new Point(),"<",c1,0x0);
			temp.threshold(source,source.rect,new Point(),">",c2,0x0);
			if (near)
			{
				temp.floodFill(x,y,0xFFFF0000);
				temp.threshold(temp,temp.rect,new Point(),"!=",0xFFFF0000,0x0);
				temp.colorTransform(temp.rect,new ColorTransform(1,1,1,1,0,255,255));
			}
			return temp;
		}
		
		private static function offestColor(rgb:uint, brite:Number):uint
		{
			var a:Number = (rgb >> 24) & 0xFF;
			var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
			var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
			var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);
			
			return (a << 24) | (r << 16) | (g << 8) | b;;
		} 
		
		/**
		 * 绘制一个位图。这个位图能确保容纳整个图像。
		 * 
		 * @param displayObj
		 * @return 
		 * 
		 */
		public static function drawToBitmap(displayObj:DisplayObject):BitmapData
		{
			var rect:Rectangle = displayObj.getBounds(displayObj);
			var m:Matrix = new Matrix();
			m.translate(-rect.x,-rect.y);
			var bitmap:BitmapData = new BitmapData(rect.width,rect.height,true,0);
			bitmap.draw(displayObj,m);
			return bitmap;
		}
		/**
		 * 切分位图为一组较小的位图
		 * 
		 * @param source
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */
		public static function separateBitmapData(source:BitmapData,width:int,height:int):Array
		{
			var result:Array = [];
			for (var j:int = 0;j < Math.ceil(source.height / height);j++)
			{
				for (var i:int = 0;i < Math.ceil(source.width / width);i++)
				{
					var bitmap:BitmapData = new BitmapData(width,height,true,0);
					bitmap.copyPixels(source,new Rectangle(i*width,j*height,width,height),new Point());
					result.push(bitmap);
				}	
			}
			return result;
		}
		
		/**
		 * 横向拼合位图
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public static function concatBitmapDataH(source:Array):BitmapData
		{
			
			var width:Number = MathUtil.sum(ArrayUtil.getFieldValues(source,"width"));
			var height:Number = MathUtil.max(ArrayUtil.getFieldValues(source,"height"));
			var result:BitmapData = new BitmapData(width,height,true,0);
			
			var x:int = 0;
			for (var i:int = 0;i < source.length; i++)
			{
				var bitmap:BitmapData = source[i];
				result.copyPixels(bitmap,new Rectangle(0,0,bitmap.width,bitmap.height),new Point(x,0));
				
				x += bitmap.width;
			}	
			return result;
		}
		
		/**
		 * 纵向向拼合位图
		 * 
		 * @param source
		 * @return 
		 * 
		 */
		public static function concatBitmapDataV(source:Array):BitmapData
		{
			
			var width:Number = MathUtil.max(ArrayUtil.getFieldValues(source,"width"));
			var height:Number = MathUtil.sum(ArrayUtil.getFieldValues(source,"height"));
			var result:BitmapData = new BitmapData(width,height,true,0);
			
			var y:int = 0;
			for (var i:int = 0;i < source.length; i++)
			{
				var bitmap:BitmapData = source[i];
				result.copyPixels(bitmap,new Rectangle(0,0,bitmap.width,bitmap.height),new Point(0,y));
				
				y += bitmap.height;
			}	
			return result;
		}
		/**
		 * 在一个限定的宽度内拼合位图
		 * 
		 * @param source	位图数据源
		 * @param maxWidth	最大宽度
		 * @param resultRect	结果矩形区域数据
		 * @return 
		 * 
		 */
		public static function concatBitmapDataLimitWidth(source:Array,maxWidth:int,resultRects:Array = null):BitmapData
		{
			if (!resultRects)
				resultRects = [];
				
			var x:int = 0;
			var y:int = 0;
			var mh:int = 0;
			for (var i:int = 0;i < source.length;i++)
			{
				var bitmap:BitmapData = source[i];
				if (x + bitmap.width <= maxWidth)
				{
					if (bitmap.height > mh)
						mh = bitmap.height;
				}
				else
				{
					x = 0;
					y += mh;
					mh = 0;
				}
				resultRects.push(new Rectangle(x,y,bitmap.width,bitmap.height))
				x += bitmap.width;
			}
			
			var result:BitmapData = new BitmapData(maxWidth,y + mh,true,0);
			
			for (i = 0;i < resultRects.length;i++)
			{
				bitmap = source[i];
				result.copyPixels(bitmap,bitmap.rect,(resultRects[i] as Rectangle).topLeft);
			}
			
			return result;
		}
		/**
		 * 缩放BitmapData
		 * 
		 * @param source
		 * @param scaleX
		 * @param scaleY
		 * @return 
		 * 
		 */
		public static function scale(source:BitmapData,scaleX:Number =1.0,scaleY:Number = 1.0):BitmapData
		{
			var result:BitmapData = new BitmapData(source.width * scaleX,source.height * scaleY,true,0);
			var m:Matrix = new Matrix();
			m.scale(scaleX,scaleY);
			result.draw(source,m);
			return result;
		}
		
		/**
		 * 清除位图内容 
		 * 
		 * @param source
		 * 
		 */
		public static function clear(source:BitmapData):void
		{
			source.fillRect(source.rect,0);
		}
		
		/**
		 * 获取位图的非透明区域，可以用来做图片按钮的hitArea区域
		 * 
		 * @param source	图像源
		 * @return 
		 * 
		 */
		public static function getMask(source:BitmapData):Shape
		{
			var s:Shape = new Shape();
			s.graphics.beginFill(0);
			for(var i:int = 0;i < source.width;i++)
			{
				for(var j:int = 0;j < source.height;j++)
				{
					if (source.getPixel32(i,j))
						s.graphics.drawRect(i,j,1,1);
				}
			}
			s.graphics.endFill();
			return s;
		}
		
		/**
		 * 回收一个数组内所有的BitmapData
		 *  
		 * @param bitmapDatas
		 * 
		 */
		public static function dispose(items:Array):void
		{
			for each (var item:* in items)
			{
				if (item is BitmapData)
					(item as BitmapData).dispose();
					
				if (item is Bitmap)
				{
					(item as Bitmap).bitmapData.dispose();
					if ((item as Bitmap).parent)
						(item as Bitmap).parent.removeChild(item as Bitmap);
				}
			}
		}
	}
	
}