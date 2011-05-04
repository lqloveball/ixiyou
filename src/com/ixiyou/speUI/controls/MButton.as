package com.ixiyou.speUI.controls 
{
	
	/**
	 * 按钮
	 * @author spe
	 */
	import flash.display.DisplayObject
	import flash.events.Event
	import flash.events.MouseEvent
	public class MButton extends MButtonBase
	{
		protected var _label:MLabel = new MLabel()
	
		//指定一个用作按钮弹起状态
		protected var _upColor:uint=0x0
		//指定一个用作按钮经过状态
		protected var _overColor:uint=0x0
		//指定一个用作按钮“按下”状态
		protected var _downColor:uint=0x0
		//指定一个用作按钮“禁止使用”状态
		protected var _pdColor:uint=0x0
		//文本颜色
		protected var _color:String = '0x0,0x151515,0x414141,0x797979';
		public function MButton(config:*=null)  
		{
			
			_label.percentHeight = 1
			_label.truncateToFit=false
			super(config)
			addChild(_label)
			setColor(_color)
			if (config) {
				if (config.label)label = config.label
				if(config.color)setColor(config.color)
			}
			if (width <= 0) this.width = 80
			if (height <= 0) this.height = 25
			_label.addEventListener(Event.RESIZE, labelResize)
		}
		/**
		 * 获取到这个文本字段
		 */
		public function get labelText():MLabel { return _label; }
		/**初始化*/
		override public function initialize():void {
			if (_initialized) return;
			_initialized=true
			//初始化过就不再初始化,决大部分组件只初始化一次
			if (_stateBox) {
				if (enabled)_stateBox.gotoAndStop(MButtonBase.UPSTATE)
				else _stateBox.gotoAndStop(MButtonBase.PDSTATE)
			}
			textColor()
		}
		/**
		 * 设置按钮文本颜色
		 * @param	value
		 */
		public function setColor(value:String):void {
			_color=value
			var arr:Array = value.split(",")
			upColor = uint(arr[0])
			overColor = uint(arr[1])
			downColor = uint(arr[2])
			pdColor = uint(arr[3])
			textColor()
		}
		protected function textColor():void {
			switch (_stateBox.nowLabel) 
			{
				case MButtonBase.UPSTATE:
					_label.textColor = _upColor
					break;
				case MButtonBase.OVERSTATE:
					_label.textColor = _overColor
					break;
				case MButtonBase.DOWNSTATE:
					_label.textColor = _downColor
					break;
				case MButtonBase.PDSTATE:
					_label.textColor = _pdColor
					break;
				default:
					_label.textColor = _upColor
			}
		}
		public function set upColor(value:uint):void 
		{
			_upColor=value
			textColor()
		}
		public function get upColor():uint { return _upColor; }
		public function set overColor(value:uint):void 
		{
			
			_overColor=value
			textColor()
		}
		public function get overColor():uint { return _overColor; }
		public function set downColor(value:uint):void 
		{
			
			_downColor=value
			textColor()
		}
		public function get downColor():uint { return _downColor; }
		public function set pdColor(value:uint):void 
		{
			
			_pdColor=value
			textColor()
		}
		public function get pdColor():uint { return _pdColor; }
		/**
		 * 计算文字位置
		 * @param	e
		 */
		private function labelResize(e:Event = null):void {
			_label.setLocation(int((width - _label.width) / 2), int((height -_label.textField.textHeight) / 2-2))
		}
		/**
		 * 设置label
		 */
		public function set label(value:String):void 
		{
			_label.text = value
		}
		public function get label():String { return _label.text; }
		/**
		 * 获取文本组件
		 */
		public function get mLabel():MLabel { return _label; }
		
		/**
		 * 鼠标放开
		 * @param	e
		 */
		override protected function mouseUp(e:MouseEvent):void {
			if (!enabled) {
				_stateBox.gotoAndStop(MButtonBase.PDSTATE)
				return
			}
			_stateBox.gotoAndStop(MButtonBase.UPSTATE)
			textColor()
		}
		/**
		 * 鼠标移开
		 * @param	e
		 */
		override protected function mouseOut(e:MouseEvent):void {
			if (!enabled) {
				_stateBox.gotoAndStop(MButtonBase.PDSTATE)
				return
			}
			_stateBox.gotoAndStop(MButtonBase.UPSTATE)
			
			textColor()
		}
		/**
		 * 鼠标经样式
		 * @param	e
		 */
		override protected function mouseOver(e:MouseEvent):void {
			if (!enabled) {
				_stateBox.gotoAndStop(MButtonBase.PDSTATE)
				return
			}
			_stateBox.gotoAndStop(MButtonBase.OVERSTATE)
			textColor()
		}
		/**
		 * 鼠标按下后
		 * @param	e
		 */
		override protected function mouseDown(e:MouseEvent):void {
			if (!enabled) {
				_stateBox.gotoAndStop(MButtonBase.PDSTATE)
				return
			}
			_stateBox.gotoAndStop(MButtonBase.DOWNSTATE)
			textColor()
		}
		
		/**组件大小更新*/
		override public function upSize():void {
			labelResize()
			//_nowStateBox.setSize(this.width, height)
			_stateBox.setAllMovieSize(width,height)
			
			
		}
	}
	
}