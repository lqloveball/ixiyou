package com.ixiyou.paintPanel 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * 绘图纸
	 * @author spe email:md9yue@@q.com
	 */
	public class DrawPage extends Sprite
	{
		//用来出来的绘制对象
		private var _bmp:Bitmap
		//寬
		protected var _width:Number = 300;
		//高度
		protected var _height:Number = 300;
		public function DrawPage() 
		{
			
		}
		/**设置高度*/
		override public function set height(value:Number):void {
			if (value < 0) return
			setSize(_width,value);
		}
		override public function get height():Number{return _height;}
		/**设置宽度*/
		override public function set width(value:Number):void{
			setSize(value,_height);
		}
		override public function get width():Number { return _width; }

		private function setSize(w:uint, h:uint):void
		{
			//大小相同就不修改
			if (w == _width && h == _height) return
			var temp:Bitmap = new Bitmap(new BitmapData(w, h, true, 0x0))
			//如果有原来画面就复制原来的画面
			if (bmp) temp.bitmapData.draw(bmp)
			//附加新的画面
			bmp=temp
		}
		/**
		 * 设置画面
		 */
		public function get bmp():Bitmap { return _bmp; }
		
		public function set bmp(value:Bitmap):void 
		{
			//是否拥有原来画面，有就要删除处理
			if (_bmp) {
				if(contains(_bmp))removeChild(_bmp)
			}
			_bmp = value;
			addChild(_bmp)
		}
		/**
		 * 显示bitmapData数据
		 */
		public function get bitmapData():BitmapData { return bmp.bitmapData; }
		
		
	}

}