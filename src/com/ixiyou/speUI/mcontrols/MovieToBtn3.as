package com.ixiyou.speUI.mcontrols 
{
	
	
	/**
	 * 影片剪辑转换成按钮按钮,3帧形式，通常用的按钮，带禁止点击功能
	 * 分别是
	 * 不选择 选择 禁止点击
	 * @author spe
	 */
	import com.ixiyou.speUI.core.IDestory;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.ixiyou.speUI.core.ISkinComponent
	
	public class MovieToBtn3 extends Sprite implements IDestory,ISkinComponent
	{
		//所使用的影片剪辑
		protected var _btn:MovieClip
		//是否使用
		protected var _enabled:Boolean = true
		//
		private var _data:Object
		public function MovieToBtn3(config:MovieClip,formerly:Boolean=false,parentBool:Boolean=false) 
		{
			if (formerly) {
				x = config.x
				y = config.y
				//if(config.parent)config.parent.addChild(this)
			}
			if (config.parent && parentBool) {
				config.parent.addChild(this)
				this.name=config.name
			}
			_btn = config
			_btn.x = 0
			_btn.y=0
			addChild(_btn)
			_btn.mouseEnabled = false
			_btn.mouseChildren=false
			mouseChildren=false
			_btn.gotoAndStop(1)
			initMouse()
			this.buttonMode = true
			this.useHandCursor =true
		}
		/**设置组件皮肤*/
		public function get skin():*{
			return _btn
		}
		public function set skin(value:*):void {
			if (value is MovieClip) {
				var gNum:int
				if (_btn) {
					gNum = _btn.currentFrame
					if (contains(_btn)) removeChild(_btn)
					addChild(_btn)
					_btn = value
					_btn.gotoAndStop(gNum)
				}
			}
		}
		/**
		 * 按钮禁止使用,设置为取消选择
		 */
		public function set enabled(value:Boolean):void 
		{
			
			_enabled = value
			if (!enabled) {
				this.mouseEnabled = false
				_btn.gotoAndStop(3)
			}else {
				this.mouseEnabled = true
				_btn.gotoAndStop(1)
			}
			
		}
		public function get enabled():Boolean { return _enabled; }
		/**
		 * 对象的原型按钮
		 */
		public function get btn():MovieClip { return _btn; }
		/**
		 * 按钮数据
		 */
		public function get data():Object { return _data; }
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		/**
		 * 鼠标事件
		 */
		protected function initMouse():void {
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver)
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			addEventListener(MouseEvent.MOUSE_UP, mouseUp)
			addEventListener(MouseEvent.CLICK, mouseClick)
		}
		/**
		 * 鼠标放开
		 * @param	e
		 */
		protected function mouseUp(e:MouseEvent):void {	
		}
		/**
		 * 鼠标移开
		 * @param	e
		 */
		 protected function mouseOut(e:MouseEvent):void {
			
			if (!enabled) {
				_btn.gotoAndStop(3)
				return
			}
			
			_btn.gotoAndStop(1)
			 
		}
		/**
		 * 鼠标经过样式
		 * @param	e
		 */
		protected function mouseOver(e:MouseEvent):void {
			
			if (!enabled) { 
				_btn.gotoAndStop(3)
				return
			}
			_btn.gotoAndStop(2)
		}
		/**
		 * 鼠标按下后
		 * @param	e
		 */
		protected function mouseDown(e:MouseEvent):void {
		}
		/**
		 * 鼠标点击
		 * @param	e
		 */
		protected function mouseClick(e:MouseEvent):void {
			//trace('testMouseClick')
		}
		/**
		 * 摧毁所有事件索引
		 */
		public  function destory():void {
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver)
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
			removeEventListener(MouseEvent.CLICK, mouseClick)
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)	
		}
	}

}