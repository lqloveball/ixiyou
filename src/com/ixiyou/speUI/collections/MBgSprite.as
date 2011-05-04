package com.ixiyou.speUI.collections 
{
	
	/**
	 * 专门用来做背景铺垫的 显示元素 不需要鼠标互动
	 * 可以设置 宽 高  背景颜色||平铺背景图片 圆弧角
	 * @author spe
	 */
	import flash.display.*;
	import flash.display.BitmapData;
	import flash.events.Event;
	import com.ixiyou.events.ResizeEvent;
	import com.ixiyou.speUI.core.ISize;
	import com.ixiyou.speUI.core.IDestory
	import com.ixiyou.speUI.core.IBackground
	[Event(name="auto_resize", type="flash.events.Event")]
	public class MBgSprite extends MSprite implements IBackground
	{
		
		
		//采用
		protected var _bgColor:uint=0xdcdcdc
		protected var _bgBitmap:BitmapData=new BitmapData(10,10,true,0xffffffff)
		protected var _nowBg:*=null//目前使用的背景模式
		protected var _angle:Number = 0
		public static var AUTO_SIZE:String = 'auto_resize';
		public function MBgSprite(config:*=null) 
		{
			if (config) {
				if(config.autoSize!=null)
					autoSize = config.autoSize;
				else autoSize = true;
				if (config.size != null&&config.size is Array)
				{
					width = config.size[0];
					height = config.size[1];
				}
				if (config.width != null)
					width = config.width;
				
				if (config.height != null)
					height = config.height;
				if (config.pWidth != null)
					percentWidth = config.pWidth;
					
				if (config.pHeight != null)
					percentHeight = config.pHeight;
					
				if (config.percentWidth != null)
					percentWidth = config.percentWidth;
					
				if (config.percentHeight != null)
					percentHeight = config.percentHeight;
				
				if (config.bg != null) {
					bg = config.bg;
				}
			}
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		/**
		 * 设置背景
		 * @param 
		 * @return 
		*/
		public function set bg(_nowBg:*):void  {
			if (_nowBg is uint) {
				_bgColor = _nowBg
				this._nowBg = _bgColor
				upSize()
			}
			else if (_nowBg is BitmapData) {
				_bgBitmap = _nowBg
				this._nowBg = _bgBitmap
				upSize()
			}
			else {
				_nowBg=null
				upSize()
			}
		}
		public function get bg():* {
			return _nowBg
		}
		/**
		 * 是否圆弧角
		 * @param 
		 * @return 
		*/
		public function set angle(_angle:Number):void  {
			if (this._angle != _angle) {
				this._angle = _angle
				upSize()
			}
		}
		public function get angle():Number {
			return _angle
		}
		/**组件大小更新*/
		override public function upSize():void {
			super.upSize()
			drawBg()
		}
		/**
		 * 绘制背景
		 */
		public function drawBg():void {
			graphics.clear()
			if(bg==null)return
			if (bg is uint) graphics.beginFill(bg)
			else graphics.beginBitmapFill(bg)
			graphics.drawRoundRect(0,0,width,height,angle,angle)
		}
		
	}
	
}