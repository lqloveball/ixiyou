package com.ixiyou.speUI.controls 
{
	
	
	/**
	 * 输入文本
	 * @author spe
	 */
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextFieldType;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.events.FocusEvent;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.core.EdgeMetrics
	import com.ixiyou.speUI.core.ISkinComponent;
	import com.ixiyou.speUI.controls.skins.TextInputSkin;
	[Event(name = 'textInput', type = "flash.events.TextEvent")]
	[Event(name = 'focusIn', type = "flash.events.FocusEvent")]
	[Event(name = 'focusOut', type = "flash.events.FocusEvent")]
	[Event(name = 'change', type = "flash.events.Event")]

	public class MTextInput extends SpeComponent implements ISkinComponent
	{

		//按钮样式
		protected var _skin:*
		//输入对象
		protected var _label:TextField;
		//指定一个输入状态背景
		protected var _inState:DisplayObject
		//指定一个不输入状态背景
		protected var _outState:DisplayObject
		//文本边界
		protected var _textEdge:EdgeMetrics = new EdgeMetrics()
		//显示状态
		protected var hitBool:Boolean = false
		//是否密码
		protected var _displayAsPassword:Boolean = false
		//是否换行
		protected var _wordWrap:Boolean = false
		//是否多行
		protected var _multiline:Boolean = false
		//能输入多少字符
		protected var _maxChars:int=0
		public function MTextInput(config:*=null) 
		{
			
			if (config) {
				if (config.skin != null) skin = config.skin
				else skin = null
				if (config.text != null) text = config.text
				if (config.label != null) text = config.label
				if (config.displayAsPassword != null) displayAsPassword = config.displayAsPassword 
			}
			if (skin == null ) skin = null
			super(config)
			if (width <= 0) this.width = 100
			if (height <= 0) this.height = 25

		}
		/**
		 * 能输入最多字符数
		 */
		public function set maxChars(value:int):void 
		{
			_maxChars=value
			_label.maxChars=value
		}
		public function get maxChars():int { return _maxChars; }
		/**
		 * 是否多行
		 */
		public function set multiline(value:Boolean):void 
		{
			_multiline=value
			_label.multiline=value
		}
		public function get multiline():Boolean { return _multiline; }
		/**
		 * 是否换行
		 */
		public function set wordWrap(value:Boolean):void 
		{
			_wordWrap=value
			_label.wordWrap=value
		}
		public function get wordWrap():Boolean { return _wordWrap; }
		/**
		 * 指定由此控件显示的纯文本。
		 */
		public function set text(value:String ):void {
			_label.text = value
		}
		public function get text():String { return _label.text; }
		/**
		 * 指定由此控件显示的纯文本。
		 */
		public function set label(value:String ):void {text= value}
		public function get label():String { return text; }
		/**
		 * 是否密码
		 */
		public function set displayAsPassword(value:Boolean):void 
		{
			if (_displayAsPassword== value) return
			_displayAsPassword=value
			_label.displayAsPassword=_displayAsPassword
		}
		public function get displayAsPassword():Boolean { return _displayAsPassword; }
		/**
		 * 焦点
		 * @param	e
		 */
		protected function FOCUS_IN(e:FocusEvent):void {
			//trace('in')
			hitBool = true
			hitShow()
			dispatchEvent(e)
		}
		/**
		 * 失去焦点
		 * @param	e
		 */
		protected function FOCUS_OUT(e:FocusEvent):void {
			//trace('out')
			hitBool = false
			hitShow()
			dispatchEvent(e)
		}
		/**
		 * 文字输入
		 * @param	e
		 */
		protected function TEXT_INPUT(e:TextEvent):void {
			
			this.dispatchEvent(e)
		}
		/**组件大小更新*/
		override public function upSize():void {
			if (!_skin) return
			hitShow()
			_label.x = _textEdge.left
			_label.y=_textEdge.top
			_label.width = this.width-_textEdge.left-_textEdge.right
			_label.height = this.height-_textEdge.top-_textEdge.bottom
			_inState.width = _outState.width = width;
			_inState.height = _outState.height = height;
		}

		/**组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				try {
					if (_skin && this.contains(_skin)) removeChild(_skin)
					_skin = value;
					addChild(_skin)
					_skin.x=_skin.y=0
					_inState = Sprite(_skin).getChildByName('_inState') as DisplayObject
					_outState = Sprite(_skin).getChildByName('_outState') as DisplayObject
					_inState.x = _outState.x= 0;
					_inState.y = _outState.y = 0;
					if(_label)_label.removeEventListener(TextEvent.TEXT_INPUT, TEXT_INPUT)
					if(_label)_label.removeEventListener(FocusEvent.FOCUS_IN, FOCUS_IN)
					if (_label)_label.removeEventListener(FocusEvent.FOCUS_OUT, FOCUS_OUT)
					if (_label)_label.removeEventListener(Event.CHANGE, CHANGE)
					var str:String = ''
					if (_label) str = _label.text
					_label = Sprite(_skin).getChildByName('_label') as TextField
					_label.text=str
					_label.type = TextFieldType.INPUT;
					_label.displayAsPassword = displayAsPassword
					_label.wordWrap=wordWrap
					_textEdge.top = _label.y
					_textEdge.left=_label.x
					_textEdge.right = _inState.width - _label.x - _label.width
					_textEdge.bottom=_inState.height-_label.y-_label.height
					_label.addEventListener(TextEvent.TEXT_INPUT, TEXT_INPUT)
					_label.addEventListener(FocusEvent.FOCUS_IN, FOCUS_IN)
					_label.addEventListener(FocusEvent.FOCUS_OUT, FOCUS_OUT)
					_label.addEventListener(Event.CHANGE, CHANGE)
					hitShow()
					upSize()
				}catch (e:TypeError) {
					skin=new TextInputSkin()
				}
			}else if (value == null){skin=new TextInputSkin()}
		}
		/**
		 * 数据改变后
		 * @param	e
		 */
		private function CHANGE(e:Event):void 
		{
			dispatchEvent(e)
		}
		/**
		 * 显示状态
		 */
		private function hitShow():void {
			if(_inState==null||_outState==null)return
			if (hitBool) {
				_inState.visible = true
				_outState.visible=false
			}else {
				_inState.visible = false
				_outState.visible=true
			}
		}
		/**
		 * 获取输入的文本
		 */
		public function get textField():TextField{return _label}
		/**
		 * 破坏所有索引，垃圾回收
		 */
		override public function destory():void {
			super.destory()
			if(_label)_label.removeEventListener(TextEvent.TEXT_INPUT, TEXT_INPUT)
			if(_label)_label.removeEventListener(FocusEvent.FOCUS_IN, FOCUS_IN)
			if(_label)_label.removeEventListener(FocusEvent.FOCUS_OUT,FOCUS_OUT)
		}
	}
}