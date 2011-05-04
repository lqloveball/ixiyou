package com.ixiyou.speUI.collections
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event
	/**
	 * 简单容器 只有重写改变大小
	 * @author spe
	 */
	public class MSizeBox extends Sprite
	{
		//寬
		protected var _width:Number = 0;
		//高度
		protected var _height:Number = 0;
		public function MSizeBox(config:*=null) 
		{
			if (config) {
				if(config.x!=null)
					x = config.x;
				if(config.y!=null)
					y = config.y;
				if (config.width != null)
					width = config.width;
				if (config.height != null)height = config.height;
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
		}
		/**设置高度*/
		override public function set height(value:Number):void {
			if (value < 0) return
				setSize(_width,value);
		}
		override public function get height():Number{return _height;}
		/**设置宽度*/
		override public function set width(value:Number):void{
			if (value < 0) return
			setSize(value,_height);
		}
		override public function get width():Number { return _width; }
			/**设置大小*/
		public function setSize(w:Number, h:Number):void {
			if (w != _width || h != _height) {
				
				if (w != _width) _width = w;
				if (h != _height)_height = h;
				upSize();
				dispatchEvent(new Event(Event.RESIZE))//大小变化事件
			}
		}
		public function upSize():void {
			
		}
	}

}