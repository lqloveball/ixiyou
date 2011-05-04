package com.ixiyou.speUI.controls 
{
	
	
	/**
	 * 输入文本
	 * @author spe
	 */
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
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
	import com.ixiyou.speUI.collections.OneSprite
	import com.ixiyou.speUI.controls.skins.TextInputSkin;
	public class MBgTextInput extends SpeComponent 
	{

		//按钮样式
		protected var _skin:Sprite
		//输入对象
		protected var _label:TextField;
		//装按钮样式的盒子
		protected var _bg:MovieClip 
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
		/**
		 * 静态方法获取
		 * @param	movie 
		 * @param	bool 是否放回原来父级位置
		 * @return
		 */
		public static function getTextInput(movie:Sprite, bool:Boolean = true):MBgTextInput {
			
			if (movie != null && movie['_bg'] != null && movie['_bg'].totalFrames == 2) {
				var pr:DisplayObjectContainer
				if (movie && movie.parent != null ) {
					 pr=movie.parent
				}
				var temp:MBgTextInput = new MBgTextInput(movie)
				if (bool&& pr!=null) {
					 pr.addChild(temp)
				}
				return temp
			}
			return null
		}
		public function MBgTextInput(movie:Sprite,config:*=null) 
		{
			if (movie!=null&&movie['_bg']!=null&&movie['_bg'].totalFrames == 2) {
				setSkin(movie)
			}
			else {
				throw new Error("com.ixiyou.speUI.controls.MBgTextInput:创建MBgTextInput使用的MovieClip不符合规格,需要有_bg,_bg帧数应为2");
				return 
			}
			if (config) {
				if (config.text != null) text = config.text
				if (config.label != null) text = config.label
				if (config.displayAsPassword != null) displayAsPassword = config.displayAsPassword 
				if (config.id != null)
					id = config.id;
				if (config.toolTip == null)
					setToolTip(config.toolTip )
				if (config.point != null)
					setChildIndex(config.point[0],config.point[1])
				if (config.x != null)
					x = config.x;
				if (config.y != null)
					y = config.y;
				if (config.borderMetrics != null) {
					borderMetrics.top = config.borderMetrics.top;
					borderMetrics.left = config.borderMetrics.left;
					borderMetrics.right = config.borderMetrics.right;
					borderMetrics.bottom = config.borderMetrics.bottom;
				}
					
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
				if(config.toolTip!=null)setToolTip(config.toolTip)
				if (config.owner != null)
					config.owner.addChild(this);
				if(config.autoSize!=null)
					autoSize=config.autoSize
				if (config.childs != null && config.childs is Array)
					for (var i:int; i < config.childs.length; i++)addChild(config.childs[i]);
			}
			if (width <= 0) this.width = 100
			if (height <= 0) this.height = 22
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
			_bg.width  = width;
			_bg.height = height;
		}
		/**
		 * 获取输入的文本
		 */
		public function get textField():TextField{return _label}
		/**组件皮肤*/
		private function setSkin(value:Sprite):void {
			if (_skin && this.contains(_skin)) removeChild(_skin)
			_skin = value
			var __x:Number=_skin.x
			var __y:Number=_skin.y
			_skin.x=_skin.y=0
			addChild(_skin)
			_bg = Sprite(_skin).getChildByName('_bg') as MovieClip
			_bg.x = _bg.x= 0;
			if(_label)_label.removeEventListener(TextEvent.TEXT_INPUT, TEXT_INPUT)
			if(_label)_label.removeEventListener(FocusEvent.FOCUS_IN, FOCUS_IN)
			if (_label)_label.removeEventListener(FocusEvent.FOCUS_OUT, FOCUS_OUT)
			_label = Sprite(_skin).getChildByName('_label') as TextField
			_label.type = TextFieldType.INPUT;
			_label.displayAsPassword = displayAsPassword
			_label.multiline = multiline
			_label.wordWrap=wordWrap
			_textEdge.top = _label.y
			_textEdge.left=_label.x
			_textEdge.right = _bg.width - _label.x - _label.width
			_textEdge.bottom=_bg.height-_label.y-_label.height
			_label.addEventListener(TextEvent.TEXT_INPUT, TEXT_INPUT)
			_label.addEventListener(FocusEvent.FOCUS_IN, FOCUS_IN)
			_label.addEventListener(FocusEvent.FOCUS_OUT,FOCUS_OUT)
			hitShow()
			setSize(_skin.width, _skin.height)
			setLocation(__x,__y)
			//upSize()
		}
		/**
		 * 显示状态
		 */
		public function hitShow():void {
			if(_bg==null)return
			if (hitBool) {
				_bg.gotoAndStop(2)
			}else {
				_bg.gotoAndStop(1)
			}
		}
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
