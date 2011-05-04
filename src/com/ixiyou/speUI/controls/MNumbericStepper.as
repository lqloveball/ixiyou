package com.ixiyou.speUI.controls 
{
	
	
	/**
	 * 数值调整器
	 * @author spe
	 */
	import flash.display.*;
	import flash.events.*;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.core.ISkinComponent;
	import com.ixiyou.speUI.collections.TabBox;
	import com.ixiyou.speUI.controls.skins.MNumbericStepperSkin
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.getTimer;
	public class MNumbericStepper extends SpeComponent implements ISkinComponent
	{
		//最大值
		protected var _maximun:Number=10
		//最小值
		protected var _minimun:Number=0
		//当前值
		protected var _value:Number=0
		//每次变化值
		protected var _stepSize:Number=1
		//是否可使用
		protected var _enabled:Boolean = true
		//
		//如果是小数点，保留位数
		public var definition:uint=1
		protected var _bg1:DisplayObject
		protected var _bg2:DisplayObject
		protected var _upRec:Rectangle=new Rectangle()
		protected var _upBtn:SimpleButton
		protected var _downRec:Rectangle=new Rectangle()
		protected var _downBtn:SimpleButton
		protected var _textRec:Rectangle=new Rectangle()
		protected var _text:TextField
		protected var hitBool:Boolean = false
		//记录旧时间
		protected var _oldDelayTime:uint
		//延迟毫秒
		public var scrollDelay:uint = 350
		protected var _valueSense:Boolean
		//样式
		protected var _skin:*
		//事件
		[Event(name="upData", type="flash.events.Event")]
		public static var UPDATA:String = 'upData';
		public function MNumbericStepper(config:*=null) 
		{
			super(config)
			if (config) {
				if (config.skin) skin = config.skin
				if (config.enabled!=null) enabled = config.enabled
			}
			if (skin == null ) skin = null
			if (width <= 0) this.width = 68	
			if (height <= 0) this.height = 29
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDown)
		}
		private function mouseDown(e:MouseEvent):void {
			hitBool = true
			if (hitBool) {
				_bg1.visible = false
				_bg2.visible=true
			}else {
				_bg1.visible = true
				_bg2.visible=false
			}
			if (e.target == _upBtn || e.target == _downBtn) {
				if (e.target == _upBtn)_valueSense = true
				if (e.target == _downBtn)_valueSense = false	
				_oldDelayTime = getTimer()
				ChangeValue(stepSize, _valueSense)
				addEventListener(Event.ENTER_FRAME, ENTER_FRAME)
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp)
			}
			
		}
		
		private function mouseUp(e:MouseEvent):void {
			hitBool = false
			if (hitBool) {
				_bg1.visible = false
				_bg2.visible=true
			}else {
				_bg1.visible = true
				_bg2.visible=false
			}
			removeEventListener(Event.ENTER_FRAME, ENTER_FRAME)
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
		}
		/**
		 * 帧触发
		 * @param	e
		 */
		private function ENTER_FRAME(e:Event):void {
			if (getTimer() - _oldDelayTime > scrollDelay) {
				ChangeValue(stepSize, _valueSense)
			}
		}
		public function ChangeValue(va:Number, valueSense:Boolean):void {
			if (valueSense) {
				if (value + va > maximun) value = maximun
				else value+=va 
			}else {
				if (value - va<this.minimun) value = minimun
				else value-=va 
			}
			
		}
		/**
		 * 是否禁止使用
		 */
		public function set enabled(va:Boolean):void 
		{
			_enabled = va
			_oldDelayTime = getTimer()
		}
		
		public function get enabled():Boolean { return _enabled; }
		/**
		 * 设置当前值
		 */
		public function set value(va:Number):void 
		{
			if (_value == va) return
			if (va > maximun) va = maximun
			if (va < minimun) va = minimun
			_value = va
			if (_text) {
				//(value*definition*10>>0)/(definition*10)
				_text.text=(value*definition*10>>0)/(definition*10)+''
			}
			dispatchEvent(new Event(MNumbericStepper.UPDATA))
		}
		public function get value():Number { return _value; }
		/**
		 * 最大值
		 */
		public function get maximun():Number { return _maximun; }
		public function set maximun(va:Number):void 
		{
			if (_maximun == va) return
			_maximun = va;
			value = Math.min(_maximun, _value);
			
		}
		
		/**
		 * 最小值
		 */
		public function get minimun():Number { return _minimun; }
		public function set minimun(va:Number):void 
		{
			if (_minimun == va) return;
			_minimun = va;
			value = Math.max(_minimun, _value);
		}
		
		/**
		 * 变动值
		 */
		public function get stepSize():Number { return _stepSize; }
		public function set stepSize(va:Number):void 
		{
			if (_stepSize == va) return
			_stepSize = va;
		}
		
		/**组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(va:*):void {
			if (va is Sprite) {
				try {
					if (_skin && this.contains(_skin)) removeChild(_skin)
					_skin = va;
					addChild(_skin)
					
					_bg1 = Sprite(_skin).getChildByName('_bg1')
					_bg1.x=_bg1.y=0
					_bg2 = Sprite(_skin).getChildByName('_bg2')
					_bg2.x=_bg2.y=0
					_upBtn = Sprite(_skin).getChildByName('_upBtn') as SimpleButton
					_upRec.width = _bg1.width - _upBtn.x
					_upRec.height= _upBtn.y
					
					_downBtn = Sprite(_skin).getChildByName('_downBtn') as SimpleButton
					_downRec.width = _bg1.width - _downBtn.x
					_downRec.height = _bg1.height -_downBtn.y
					
					_text = Sprite(_skin).getChildByName('_text') as TextField
					_text.text = value.toString()
					_textRec.x = _text.x;
					_textRec.y = _text.y;
					_textRec.width = Sprite(_skin).width - _text.x - _text.width
					_textRec.height=Sprite(_skin).height- _text.y- _text.height
					
					if (hitBool) {
						_bg1.visible = false
						_bg2.visible=true
					}else {
						_bg1.visible = true
						_bg2.visible=false
					}
					_width = _bg1.width
					_height=_bg1.height
					upSize()
				}catch (e:TypeError) {
					trace(e)
					skin=new MNumbericStepperSkin()
				}
			}else if (va == null){skin=new MNumbericStepperSkin()}
		}
		/**
		 * 组件大小改变
		 */
		override public function upSize():void {
			if (skin) {
				_text.width = width - _textRec.width - _textRec.x
				_text.height=height-_textRec.height-_textRec.y
				_bg1.width = width
				_bg1.height=height
				_bg2.width = width
				_bg2.height=height
				_upBtn.x = width - _upRec.width
				_upBtn.y = _upRec.height
				_downBtn.x = width - _downRec.width
				_downBtn.y=height-_downRec.height
			}
		}
		/**
		 * 清楚事件索引
		 */
		override public function destory():void {
			super.destory()
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			removeEventListener(Event.ENTER_FRAME, ENTER_FRAME)
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
		}
		
	}

}