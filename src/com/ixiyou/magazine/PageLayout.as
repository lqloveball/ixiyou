package com.ixiyou.magazine 
{
	/**
	 * 页面
	 * @author spe
	 */
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.*;
	import com.ixiyou.events.ResizeEvent
	import flash.utils.ByteArray;
	import flash.system.LoaderContext
	import flash.system.ApplicationDomain
	public class PageLayout extends Sprite
	{
		//是否加载
		public var loadBool:Boolean = false
		//数据
		private var _data:Object
		private var _loader:Loader = new Loader()
		private var _bg:Shape = new Shape()
		//寬
		protected var _width:Number=0;
		//高;
		protected var _height:Number=0;
		//页面的ID号
		protected var _id:String = ''
		//页面采用的数据类型
		protected var _type:String = ''
		//页面数据
		protected var _src:String = ''
		//页码
		protected var _index:uint = 0
		//显示数据内容
		protected var _showObj:*
		public function PageLayout(config:*=null) 
		{
			addChild(_bg)
			drawRect(_bg.graphics,10,10,0xffffff,0)
			if (config) {
				if (config.width != null && config.height != null) {
					setSize(config.width,config.height)
				}else {
					if (config.width!=null) width = config.width
					if (config.height!=null) height = config.height
				}
				if (config.data != null) data = config.data
				if(config.index!=null)index=config.index
			}
		}
		/**
		 * 设置加载
		 * @param	value
		 */
		public function setPageLoad(value:ByteArray):void {
			if(_showObj==value)return
			if (!contains(_loader)) addChild(_loader)
			var context:LoaderContext = new LoaderContext();
			//air使用
			context.allowLoadBytesCodeExecution=true
			_loader.loadBytes(value,context)
			_showObj=value
		}
		/**
		 * 设置显示对象
		 * @param	value
		 */
		public function setDisplayObject(value:DisplayObject):void {
			if(_showObj==value)return
			if (contains(_loader)) removeChild(_loader)
			addChild(value)
			_showObj=value
		}
		/**
		 * 页面显示数据
		 */
		public function get showObj():* { return _showObj; }
		/**
		 * 加载对象
		 */
		public function get loader():Loader { return _loader; }
		/**
		 * 设置数据
		 */
		public function get data():Object { return _data; }
		public function set data(value:Object):void 
		{
			_data = value;
			if (_data.id)_id = _data.id
			if (_data.type)_type = _data.type
			if (_data.src)_src = _data.src
			index=_data.index
		}
		public function set index(value:uint):void {
			_index = value
			_data.index=value
		}
		/**
		 * 页码
		 */
		public function get index():uint { return _index; }
		/**
		 * 页面ID
		 */
		public function get id():String { return _id }
		/**
		 * 页面类型
		 */
		public function get type():String { return _type; }
		/**
		 * 页面地址
		 */
		public function get src():String { return _src; }
		/**设置高度*/
		override public function set height(value:Number):void {	setSize(_width,value);}
		override public function get height():Number{return _height;}
		/**设置宽度*/
		override public function set width(value:Number):void{setSize(value,_height);}
		override public function get width():Number { return _width; }
		
		
		
		
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
		/**组件大小更新*/
		public function upSize():void {
			//trace('------------', width,height)
			_bg.width = width
			_bg.height = height
			//drawRect(graphics,width,height)
		}
		/**
		 * 摧毁
		 */
		public function destory():void {
			if (_loader.content) {
				_loader.unloadAndStop()
			}
		}
		/**
		 * 绘制
		 * @param	obj
		 * @param	w
		 * @param	h
		 * @param	color
		 */
		private function drawRect(obj:Graphics, w:uint=10, h:uint=10,color:uint=0x0,ap:Number=1):void {
			obj.clear()
			obj.beginFill(color,ap)
			obj.drawRect(0,0,w,h)
		}
		
	}

}