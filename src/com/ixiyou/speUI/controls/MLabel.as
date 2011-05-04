package com.ixiyou.speUI.controls 
{
	
	/**
	 * 用于短文本字符串的显示区 一行不可编辑的文本
	 * @author dd
	 */
	import com.ixiyou.speUI.core.SpeComponent
	import flash.geom.Point;
	import flash.text.*
	import flash.display.DisplayObject
	import flash.display.Shape
	public class MLabel extends SpeComponent
	{
		protected var _labelStr:String = ''
		//ICO对象
		protected var _ico:DisplayObject
		//默认ICO
		protected var __ico:Shape = new Shape()
		//输入对象
		protected var _label:TextField = new TextField()
		//对文字裁切
		protected var _truncateToFit:Boolean = true
		//图标和文字间的间隔
		protected var _icoGap:uint=3
		//背景颜色
		protected var _backgroundColor:uint = 0xffffff
		//背景是否开启
		protected var _background:Boolean = false
		//背景透明度
		protected var _bgAlpha:Number = 1
		//是否支持HTML
		protected var _htmlBool:Boolean=false
		public function MLabel(config:*=null) 
		{
			ico = __ico
			_label.embedFonts=false
			_label.gridFitType = GridFitType.PIXEL;
			_label.antiAliasType = AntiAliasType.ADVANCED;
			_label.thickness=400;
			//不自动换行
			_label.wordWrap = false
			//默认不可选
			selectable = false
			icoGap=3
			addChild(_label)
			super(config)
			if (config) {
				if (config.icoGap != null) icoGap = config.icoGap
				if (config.bgAlpha != null) bgAlpha = config.bgAlpha
				if (config.truncateToFit!=null)truncateToFit=config.truncateToFit
				if (config.background != null) background = config.background
				if (config.backgroundColor != null) backgroundColor = config.backgroundColor
				if (config.textColor != null) textColor = config.textColor
				if (config.ico != null) ico = config.ico
				if (config.selectable != null) selectable = config.selectable
				if (config.htmlText != null) text = config.htmlText
				if (config.text != null) text = config.text
				if (config.label != null) text = config.label
				if (config.defaultTextFormat != null) defaultTextFormat = config.defaultTextFormat 
				else defaultTextFormat = new TextFormat('宋体,Arial', 12, 0x0)
				if (config.textSize != null) textSize = config.textSize
			}
			if (width <= 0) this.width = 100
			if (height <= 0) this.height = 25
		}
		/**
		 * 背景透明度
		 */
		public function set bgAlpha(value:Number):void 
		{
			if (_bgAlpha == value) return
			_bgAlpha = value;
			//if (_bgAlpha < 0)_bgAlpha = 0
			//else(_bgAlpha > 1)_bgAlpha = 1
			upSize()
		}
		public function get bgAlpha():Number { return _bgAlpha; }
		/**
		 * 是否使用背景
		 */
		public function set background(value:Boolean):void {
			if (_background == value) return
			_background = value
			upSize()
		}
		public function get background():Boolean{return _background}
		/**
		 * 背景
		 */
		public function set backgroundColor(value:uint):void {
			if (_backgroundColor == value) return
			_backgroundColor = value
			upSize()
		}
		public function get backgroundColor():uint{return _backgroundColor}
		/**
		 * 文本对象操作
		 */
		public function get textField():TextField { return _label; }
		/**
		 * ico设置
		 */
		public function set ico(value:DisplayObject):void {
			if (_ico == value) return
			if (_ico!=null&&this.contains(_ico)) removeChild(_ico)
			if (value==null)value=__ico
			_ico = value
			addChild(_ico)
			dealSize()
		}
		public function get ico():DisplayObject { return _ico; }
		/**
		 * 图标与文字间间隔
		 */
		public function set icoGap(value:uint):void 
		{
			if (value == _icoGap) return 
			_icoGap = value
			dealSize()
		}
		public function get icoGap():uint{return _icoGap}
		/**
		 * 计算大小
		 */
		protected function dealSize():void {
			//无切断
			var _w:Number
			var _h:Number
			if (!truncateToFit) {
				_w = _label.textWidth + 4 + this._ico.width
				if (_ico.width > 0)_w += _icoGap
			}
			else _w = this.width
			if ( _label.textHeight + 4 > _ico.height)_h = _label.textHeight + 4
			else _h = _ico.height
			//trace([_w,_h])
			if (_w != width || _h != height) setSize(_w, _h)
			else upSize()
		}
		/**组件大小更新*/
		override public function upSize():void {
			//trace('size:',width,height)
			_label.width = this.width - ico.width	
			//_label.wordWrap = true
			_label.height = this._label.textHeight+4
			_label.x = uint(ico.width)
			if (ico.width > 0) {
				_label.width -= _icoGap
				_label.x=uint(_label.x+_icoGap)
			}
			ico.y = (this.height - ico.height) / 2
			//计算需要。。。号
			if (truncateToFit) {
				if (_htmlBool) return
				_label.wordWrap = true
				//_label.condenseWhite=false
				_label.text =  _labelStr.replace(/ /g, "")
				var num:uint = _label.getLineText(0).length
				if (_label.maxScrollV > 1) {
					var str:String = _labelStr.slice(0,num) + '...'
					_label.text=str
				}
				_label.wordWrap = false
			}else {
				if (_htmlBool)_label.htmlText = _labelStr
				else _label.text=_labelStr
			}
			//测试使用
			this.graphics.clear()
			if (background) {
				this.graphics.beginFill(backgroundColor,bgAlpha)
				this.graphics.drawRect(0,0,this.width,this.height)
			}
		}
		public function set textSize(value:uint):void 
		{
			var old:TextFormat=_label.defaultTextFormat
			var format:TextFormat=new TextFormat(old.font,value,old.color,old.bold,old.italic,old.underline,old.url,old.target,old.align,old.leftMargin,old.rightMargin,old.indent)
			defaultTextFormat=format
		}
		public function get textSize():uint { return _label.defaultTextFormat.size as uint; }
		/**
		 * 指定应用于新插入文本（例如，使用 replaceSelectedText() 方法插入的文本或用户输入的文本）的格式。
		 * 这里添加了并修改当前
		 */
		public function set defaultTextFormat(format:TextFormat):void {
			_label.defaultTextFormat = format
			setTextFormat(format)
		}
		/**
		 * 将 format 参数指定的文本格式应用于文本字段中的指定文本。
		 */
		public function setTextFormat(format:TextFormat, beginIndex:int = -1, endIndex:int = -1):void {
			_label.setTextFormat(format, beginIndex, endIndex)
			dealSize()
		}
		/**
		 * 文本颜色
		 */
		public function get textColor(): uint { return _label.textColor; }
		public function set textColor(value:uint):void {
			_label.textColor=value
		}
		/**
		 * 指定是否可以选择文本。
		 */
		public function set selectable(value:Boolean):void {_label.selectable=value}
		public function get selectable():Boolean {return _label.selectable }
		/**
		 * 指定 Label 控件显示的文本，包括表示该文本样式的 HTML 标签。
		 */
		public function set htmlText(value:String):void {
			if (_labelStr == value) return
			_labelStr = value
			_htmlBool=true
			_label.htmlText = _labelStr 
			dealSize()
		}
		public function get htmlText():String { return _labelStr }
		/**
		 * 指定由此控件显示的纯文本。
		 */
		public function set text(value:String ):void {
			if (_labelStr == value) return
			_labelStr = value
			_htmlBool=false
			_label.text = _labelStr
			dealSize()
		}
		public function get text():String { return _label.text; }
		/**
		 * 指定由此控件显示的纯文本。
		 */
		public function set label(value:String ):void {text= value}
		public function get label():String { return _labelStr; }
		/**
		 * 如果此属性为 true，并且 Label 控件大小小于其文本大小，则使用可本地化的字符串（如“...”）截断 Label 控件的文本。
		 */
		public function set truncateToFit(value:Boolean):void {
			if (_truncateToFit == value) return
			_truncateToFit = value
			dealSize()
		}
		public function get truncateToFit():Boolean { return _truncateToFit; }
	}
	
}