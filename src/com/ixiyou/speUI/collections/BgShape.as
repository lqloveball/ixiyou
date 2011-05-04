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
	import com.ixiyou.speUI.core.IDestory;
	import com.ixiyou.speUI.core.IBackground;
	//设置自动适应父级容器大小发出设置事件
		[Event(name = "auto_resize", type = "flash.events.Event")];
	public class BgShape extends Shape implements ISize,IDestory,IBackground
	{
		
		//自动适应宽高
		private var _autoSize:Boolean = false;
		//寬
		protected var _width:Number = 0;
		//高度
		protected var _height:Number = 0;
		//组件的寬度百分币
		private var _percentWidth:Number = 0;
		//组件的高度百分币
		private var _percentHeight:Number = 0;
		//判断百分比寬是否开启
		protected var percentWidthBool:Boolean = false;
		//判断百分比是高否开启
		protected var percentHeightBool:Boolean = false;
		//采用
		protected var _bgColor:uint=0xdcdcdc
		protected var _bgBitmap:BitmapData=new BitmapData(10,10,true,0xffffffff)
		//目前使用的背景模式
		protected var _nowBg:*
		
		protected var _line:Number=-1
		protected var _lineColor:uint=0x0
		protected var _angle:Number = 0
		//设置自动适应父级容器大小发出设置事件
		public static var  AUTO_SIZE:String = "auto_resize";
		public function BgShape(config:*=null) 
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
		 * 初始化到场景
		 * @param	e
		 */
		private function init(e:Event = null):void {
			if (parent) parent.addEventListener(Event.RESIZE, iniToStageSize)
			ResetSize()
		}
		/**组件父级发生变化时候，判断是否是这个组件父级，是就对组件大小重设，否需要移除监听*/
		private function iniToStageSize(e:Event):void{
			try{
				var d:DisplayObject=e.target as DisplayObject
				if (parent && d == parent)ResetSize()
				else d.removeEventListener(Event.RESIZE, iniToStageSize)
			}catch(e:ArgumentError){
				trace(e.toString()+" 错误：组件父级，事件对象不是显示对象类型")
			}
			
		}
		/**组件大小重设，
		 * 一般在组件被新的容器装载、
		 * 组件边界发生变化时候
		 * 执行大小重设由组件自行计算重设的大小
		 * */
		public function ResetSize():void {
			//父级不存在时候
			if (!parent) return
			//父级是布局类型容器不进行计算大小计算，这方面计算教给容器负责
			//if (owner is IVHContainer || owner is ILayoutContainer)return
			//自动适应大小时候
			if (autoSize) { 
				//父级是场景
				//trace(parent,parent.width, parent.height)
				if (parent is Stage) {setSize(Stage(parent).stageWidth,Stage(parent).stageHeight)}
				else setSize(parent.width, parent.height)
			}
			//都是百分比时候
			else if (percentHeightBool && percentWidthBool) {
				//父级是场景
				if (parent is Stage) setSize(Stage(parent).stageWidth * percentWidth , Stage(parent).stageHeight * percentHeight)
				else setSize(parent.width*percentWidth,parent.height*percentHeight)
			}
			else if (percentWidthBool) {
				//父级是场景
				if (parent is Stage) setSize(Stage(parent).stageWidth * percentWidth, height)
				else setSize(parent.width*percentWidth,height)
			}
			else if (percentHeightBool) {
				//父级是场景
				if (parent is Stage) setSize(width, Stage(parent).stageHeight * percentHeight)
				else setSize(width,parent.height*percentHeight)
			}	
		}
		/**设置大小*/
		public function setSize(w:Number, h:Number):void {
			if (w != _width || h != _height) {
				var event:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
				event.oldHeight = _height;
				event.oldWidth = _width;
				if (w != _width) {
					var wevent:ResizeEvent = new ResizeEvent(ResizeEvent.WRESIZE);
					event.oldWidth = _width;
					_width = w;
					dispatchEvent(wevent)
				} 
				if (h != _height) {
					var hevent:ResizeEvent = new ResizeEvent(ResizeEvent.HRESIZE);
					hevent.oldHeight = _height;
					_height = h;
					dispatchEvent(hevent)
				} 
				upSize();
				dispatchEvent(event);
				dispatchEvent(new Event(Event.RESIZE))//大小变化事件
			}
		}
		/** 
		 * 百分比寬度
		 * */
		public function get percentWidth():Number{
			return _percentWidth;
		}
		/**
		 * 百分比寬度
		 * value 0-1
		 */
		public function set percentWidth(value:Number):void{
			if (value < 0&&value>1) return
			if (percentHeight != value)
			{
				if(this.autoSize)autoSize=false
				percentWidthBool = true
				_percentWidth = value;
				ResetSize()
			}
		}
		/** 百分比高度 */
		public function get percentHeight():Number{
			return _percentHeight;
		}
		public function set percentHeight(value:Number):void{
			if (value < 0&&value>1) return
			if (percentHeight != value)
			{
				if(this.autoSize)autoSize=false
				percentHeightBool = true
				_percentHeight = value;
				ResetSize()
			}
		}
		/**设置高度*/
		override public function set height(value:Number):void {
			if (value < 0) return
				if(this.autoSize)autoSize=false
				percentHeightBool=false
				setSize(_width,value);
		}
		override public function get height():Number{return _height;}
		/**设置宽度*/
		override public function set width(value:Number):void{
			if (value < 0) return
				if(this.autoSize)autoSize=false
				percentWidthBool=false
				setSize(value,_height);
		}
		override public function get width():Number { return _width; }
		/**自动适应宽高*/
		public function set autoSize(value:Boolean):void{
			if (_autoSize != value)
			{
				_autoSize = value;
				this.dispatchEvent(new Event(BgShape.AUTO_SIZE))
				ResetSize()
			}
		}
		public function get autoSize():Boolean { return _autoSize; }
		/**
		 * 设置背景
		 * @param 
		 * @return 
		*/
		public function set bg(_nowBg:*):void  {
			if (_nowBg is uint) {
				_bgColor = _nowBg as uint
				this._nowBg = _bgColor
				upSize()
			}
			else if (_nowBg is BitmapData) {
				_bgBitmap = _nowBg as BitmapData
				this._nowBg = _bgBitmap
				upSize()
			}
			else {
				_bgColor = 0xdcdcdc
				this._nowBg = _bgColor
				upSize()
			}
		}
		public function get bg():* {
			if(!_nowBg)_nowBg=_bgColor
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
		public function upSize():void {
			//trace([this.width,this.height])
			drawBg()
		}
		/**
		 * 绘制背景
		 */
		public function drawBg():void {
			graphics.clear()
			if (bg is uint) graphics.beginFill(bg as uint)
			else graphics.beginBitmapFill(bg as BitmapData)
			graphics.drawRoundRect(0,0,width,height,angle,angle)
		}
		
		/**
		 * 破坏所有索引，垃圾回收
		 */
		public function destory():void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (parent) parent.removeEventListener(Event.RESIZE, iniToStageSize)
		}
	}
	
}