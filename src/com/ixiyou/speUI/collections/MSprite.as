package com.ixiyou.speUI.collections 
{
	
	/**
	 * 专门用来做背景铺垫的 显示元素 
	 * 可以设置 宽 高 
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
	[Event(name="resize", type="flash.events.Event")]
	public class MSprite extends Sprite implements ISize,IDestory
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
		public static var AUTO_SIZE:String = 'auto_resize';
		public function MSprite(config:*=null) 
		{
			if (config) {
				if(config.x!=null)
					x = config.x;
				if(config.y!=null)
					y = config.y;
				if(config.autoSize!=null)
					autoSize = config.autoSize;
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
				
				
			}
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		/**
		 * 初始化到场景
		 * @param	e
		 */
		protected function init(e:Event = null):void {
			if (parent) parent.addEventListener(Event.RESIZE, iniToStageSize)
			ResetSize()
		}
		/**组件父级发生变化时候，判断是否是这个组件父级，是就对组件大小重设，否需要移除监听*/
		protected function iniToStageSize(e:Event):void{
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
		public function set autoSize(value:Boolean):void {
			if (_autoSize == value) return
			_autoSize = value;
			if(_autoSize){
				this.dispatchEvent(new Event(MSprite.AUTO_SIZE))
				ResetSize()
			}
		}
		public function get autoSize():Boolean { return _autoSize; }
		/**组件大小更新*/
		public function upSize():void {	}
		/**
		 * 破坏所有索引，垃圾回收
		 */
		public function destory():void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (parent) parent.removeEventListener(Event.RESIZE, iniToStageSize)
		}
	}
	
}