package com.ixiyou.speUI.controls 
{
	
	/**
	 * 单选复选按钮
	 * @author spe
	 */
	import com.ixiyou.speUI.controls.MButton;
	import com.ixiyou.speUI.controls.skins.CheckButtonSkin
	import com.ixiyou.speUI.core.Iselect
	import com.ixiyou.speUI.core.LayoutMode;
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.ixiyou.events.SelectEvent
	//选择
	[Event(name = "Select", type = "com.ixiyou.events.SelectEvent;")]
	//选择更新
	[Event(name = "upSelect", type = "com.ixiyou.events.SelectEvent;")]
	//取消选择
	[Event(name="reSelect", type="com.ixiyou.events.SelectEvent;")]
	public class MCheckButton extends MButton implements Iselect
	{
		//指定一个用作按钮“选择”状态
		protected var _selectColor:uint = 0x0
		protected var _selectOverColor:uint = 0x0
		protected var _selectDownColor:uint = 0x0
		protected var _pdSelectColor:uint = 0x0
		//是否选择
		protected var _select:Boolean = false
		//按钮相关数据
		public var data:*
		//锁定选择
		protected var _selectLock:Boolean = false
		//对齐
		protected var _labelAlign:String = LayoutMode.LEFT
		public var labelAlignNum:uint=5
		//指定一个用作按钮弹起状态
		public static var UPSTATE:String = 'upState';
		//指定一个用作按钮经过状态
		public static var OVERSTATE:String = 'overState';
		//指定一个用作按钮“按下”状态
		public static var DOWNSTATE:String = 'downState';
		//指定一个用作按钮“禁止使用”状态
		public static var PDSTATE:String = 'pdState';
		//选择状态
		public static var SELECTSTATE:String = 'selectState';
		//选择经过
		public static var SELECTOVERSTATE:String = 'selectOverState';
		//选择按下
		public static var SELECTDOWNSTATE:String = 'selectDownState';
		//禁止使用但选择了
		public static var PDSELECTSTATE:String = 'pdSelectState';
		public function MCheckButton(config:*=null) 
		{
			//文本颜色
			_color = '0x0,0x151515,0x414141,0x797979,0x151515';
			super(config)
			if (config) {
				if (config.select!=null) select = config.select
				if (config.data!=null)data = config.data
			}
			
			
		}
		/**初始化*/
		override public function initialize():void {
			if (_initialized) return;
			_initialized=true
			//初始化过就不再初始化,决大部分组件只初始化一次
			if (_stateBox) {
				if (enabled) {
					if (select)_stateBox.gotoAndStop(MButtonBase.SELECTSTATE)
					else _stateBox.gotoAndStop(MButtonBase.UPSTATE)
				}
				else _stateBox.gotoAndStop(MButtonBase.PDSTATE)
			}
			textColor()
		}
		/**
		 *  是否锁定不能改变选择状态，作为复选，单选时候使用
		 */
		public function set selectLock(value:Boolean):void {
			if(value==_selectLock)return
			_selectLock = value
		}
		public function get selectLock():Boolean {
			return _selectLock
		}
		/**
		 * 鼠标事件
		 */
		override protected function initMouse():void {
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver,false,0,true)
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut,false,0,true)
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown,false,0,true)
			addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true)
			addEventListener(MouseEvent.CLICK, mouseClick,false,0,true)
		}
		/**
		 * 删除索引
		 */
		override public function destory():void {
			super.destory()
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver)
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
			removeEventListener(MouseEvent.CLICK, mouseClick)
		}
		/**
		 * 鼠标点击事件
		 * @param	e
		 */
		private function mouseClick(e:MouseEvent):void {
			if (_select) {
				select=false
			}else {
				select=true
			}
		}
		/**
		 * 按钮禁止使用,设置为取消选择
		 */
		override public function set enabled(value:Boolean):void 
		{
			if (_enabled == value) return
			_enabled=value
			if (_enabled == false) {
				if (select) _stateBox.gotoAndStop(PDSELECTSTATE)
				else _stateBox.gotoAndStop(PDSTATE)
				this.mouseEnabled = false
				_selectLock=true
			}else{
				this.mouseEnabled = true
				_selectLock = false
				if (select) _stateBox.gotoAndStop(SELECTSTATE)
				else _stateBox.gotoAndStop(UPSTATE)
			}
		}
		/**
		 * 设置选择
		 */
		 public function set select(value:Boolean):void 
		{
			if (_select == value) return
			if (_selectLock) return
			_select = value
			if (_select) {
				//trace(SelectEvent.SELECT)
				_stateBox.gotoAndStop(SELECTSTATE)
				dispatchEvent(new Event(Event.SELECT))
				dispatchEvent(new SelectEvent(SelectEvent.SELECT,this.data,select))	
			}else {
				//trace(SelectEvent.RESELECT)
				_stateBox.gotoAndStop(UPSTATE)
				dispatchEvent(new SelectEvent(SelectEvent.RESELECT,this.data,select))
			}
			//trace(SelectEvent.UPSELECT)
			dispatchEvent(new SelectEvent(SelectEvent.UPSELECT, data, select))
			textColor()
		}
		public function get select():Boolean { return _select; }
		/**
		 * 鼠标放开
		 * @param	e
		 */
		override protected function mouseUp(e:MouseEvent):void {
			if (!enabled) {
				if (_select) _stateBox.gotoAndStop(PDSELECTSTATE)
				else _stateBox.gotoAndStop(PDSTATE)
				return
			}
			if (select) _stateBox.gotoAndStop(SELECTSTATE)
			else _stateBox.gotoAndStop(UPSTATE)
			textColor()
		}
		/**
		 * 鼠标移开
		 * @param	e
		 */
		override protected function mouseOut(e:MouseEvent):void {
			if (!enabled) {
				if (_select) _stateBox.gotoAndStop(PDSELECTSTATE)
				else _stateBox.gotoAndStop(PDSTATE)
				return
			}
			if (select) _stateBox.gotoAndStop(SELECTSTATE)
			else _stateBox.gotoAndStop(UPSTATE)
			textColor()
		}
		/**
		 * 鼠标经过样式
		 * @param	e
		 */
		override protected function mouseOver(e:MouseEvent):void {
			if (!enabled) {
				if (_select) _stateBox.gotoAndStop(PDSELECTSTATE)
				else _stateBox.gotoAndStop(PDSTATE)
				return
			}
			if (select) _stateBox.gotoAndStop(SELECTOVERSTATE)
			else _stateBox.gotoAndStop(OVERSTATE)
			textColor()
		}
		/**
		 * 鼠标按下后
		 * @param	e
		 */
		override protected function mouseDown(e:MouseEvent):void {
			if (!enabled) {
				if (_select) _stateBox.gotoAndStop(PDSELECTSTATE)
				else _stateBox.gotoAndStop(PDSTATE)
				return
			}
			if (select) _stateBox.gotoAndStop(SELECTDOWNSTATE)
			else _stateBox.gotoAndStop(DOWNSTATE)
			textColor()
		}
		/**
		 * 按钮颜色
		 */
		override protected function textColor():void {
			//trace(_stateBox.nowLabel)
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
				case MButtonBase.SELECTSTATE:
					_label.textColor = _selectColor
					break;
				case MButtonBase.SELECTOVERSTATE:
					_label.textColor = _selectOverColor
					break;
				case MButtonBase.SELECTDOWNSTATE:
					_label.textColor = _selectDownColor
					break;
				case MButtonBase.PDSELECTSTATE:
					_label.textColor = _pdSelectColor
					break;
				default:
					_label.textColor = _upColor
			}
		}
		/**
		 * 设置按钮文本颜色
		 * @param	value
		 */
		override public function setColor(value:String):void {
			_color=value
			var arr:Array = value.split(",")
			upColor = uint(arr[0])
			overColor = uint(arr[1])
			downColor = uint(arr[2])
			pdColor = uint(arr[3])
			if (arr[4])_selectColor = uint(arr[4])
			else _selectColor=upColor
			if (arr[5])_selectOverColor = uint(arr[5])
			else _selectOverColor=_selectColor
			if (arr[6])_selectDownColor = uint(arr[6])
			else _selectDownColor=_selectOverColor
			if (arr[7])_pdSelectColor = uint(arr[7])
			else _pdSelectColor=_selectDownColor
			textColor()
		}
		/**组件皮肤*/
		override public function set skin(value:*):void {
			if (value is Sprite) {
				try {
					var flabel:String
					if (_stateBox) flabel = _stateBox.nowLabel
					_stateBox.clearFrame()
					_skin = value;
					if( Sprite(_skin).parent&& Sprite(_skin).parent.contains( Sprite(_skin))) Sprite(_skin).parent.removeChild( Sprite(_skin))
					if (Sprite(_skin).getChildByName('_' + UPSTATE))_stateBox.replaceLabel(UPSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
					
					if (Sprite(_skin).getChildByName('_' + OVERSTATE))_stateBox.replaceLabel(OVERSTATE, Sprite(_skin).getChildByName('_' + OVERSTATE))
					else _stateBox.replaceLabel(OVERSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
					
					if (Sprite(_skin).getChildByName('_' + DOWNSTATE))_stateBox.replaceLabel(DOWNSTATE, Sprite(_skin).getChildByName('_' + DOWNSTATE))
					else _stateBox.replaceLabel(DOWNSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
					
					if (Sprite(_skin).getChildByName('_' + SELECTSTATE))_stateBox.replaceLabel(SELECTSTATE, Sprite(_skin).getChildByName('_' + SELECTSTATE))
					else _stateBox.replaceLabel(SELECTSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
					
					if (Sprite(_skin).getChildByName('_' + SELECTOVERSTATE))_stateBox.replaceLabel(SELECTOVERSTATE, Sprite(_skin).getChildByName('_' + SELECTOVERSTATE))
					else if(Sprite(_skin).getChildByName('_' + SELECTSTATE))_stateBox.replaceLabel(SELECTOVERSTATE, Sprite(_skin).getChildByName('_' + SELECTSTATE))
					else _stateBox.replaceLabel(SELECTOVERSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
					
					if (Sprite(_skin).getChildByName('_' + SELECTDOWNSTATE))_stateBox.replaceLabel(SELECTDOWNSTATE, Sprite(_skin).getChildByName('_' + SELECTDOWNSTATE))
					else if(Sprite(_skin).getChildByName('_' + SELECTSTATE))_stateBox.replaceLabel(SELECTDOWNSTATE, Sprite(_skin).getChildByName('_' + SELECTSTATE))
					else _stateBox.replaceLabel(SELECTDOWNSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
					
					if (Sprite(_skin).getChildByName('_' + PDSTATE))_stateBox.replaceLabel(PDSTATE, Sprite(_skin).getChildByName('_' + PDSTATE))
					else _stateBox.replaceLabel(PDSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
					
					if (Sprite(_skin).getChildByName('_' + PDSELECTSTATE))_stateBox.replaceLabel(PDSELECTSTATE, Sprite(_skin).getChildByName('_' + PDSELECTSTATE))
					else if(Sprite(_skin).getChildByName('_' + PDSTATE))_stateBox.replaceLabel(PDSELECTSTATE, Sprite(_skin).getChildByName('_' + PDSTATE))
					else _stateBox.replaceLabel(PDSELECTSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
					upSize()
					if(flabel)_stateBox.gotoAndStop(flabel)
				}catch (e:TypeError) {
					skin=new CheckButtonSkin()
				}
				
			}else if (value == null){skin=new CheckButtonSkin()}
		}
		/**组件大小更新*/
		override public function upSize():void {
			super.upSize()
			//_stateBox.setAllMovieSize(width,height)
			if (_label) {
				labelAlign=labelAlign
			}
		}
		/**
		 * 设置标签对齐方式
		 */
		public function set labelAlign(value:String):void 
		{
			_labelAlign = value
			if (_labelAlign == LayoutMode.LEFT)_label.x = int(labelAlignNum)
			else if (_labelAlign == LayoutMode.RIGHT)_label.x = int(width - _label.width - labelAlignNum)
			else _label.x = int((width - _label.width) / 2)
			_label.y = int((height -_label.textField.textHeight) / 2-2)
		}
		public function get labelAlign():String { return _labelAlign; }
	}
	
}