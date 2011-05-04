package com.ixiyou.speUI.controls 
{
	import com.ixiyou.speUI.core.LayoutMode;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.core.Iselect
	import com.ixiyou.speUI.core.ISkinComponent
	import com.ixiyou.speUI.controls.skins.MCheckButtonByMovie6Skin
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.ixiyou.events.SelectEvent
	import flash.text.TextField;
	//选择
	[Event(name = "Select", type = "flash.events.Event;")]
	//选择更新
	[Event(name = "upSelect", type = "flash.events.Event;")]
	//取消选择
	[Event(name="reSelect", type="flash.events.Event;")]
	/**
	 * 靠6帧来做的 选按钮
	 * 区别于MCheckButton 没有label属性设置,不能9宫格缩放
	 * 区别于MovieToCheck6可以创建后换皮肤
	 * 
	 * 状态 默认 不选移上 选择默认 选择移上 禁止不选中  禁止选中
	 * @author spe
	 */
	public class MCheckButtonByMovie6 extends SpeComponent implements Iselect,ISkinComponent
	{
		public static var UPSELECT:String =SelectEvent.UPSELECT
		
		public static var SELECT:String =SelectEvent.SELECT
		
		public static var RESELECT:String = SelectEvent.RESELECT
		
		//选择否
		protected var _select:Boolean = false
		//设置数据
		public var data:*
		//选择锁定
		protected var _selectLock:Boolean = false
		//皮肤
		protected var _skin:*
		//是否禁止使用
		protected var _enabled:Boolean = true
		//
		protected var _btn:MovieClip
		//标签
		protected var _label:MLabel = new MLabel()
		//
		protected var _labelAlign:String = LayoutMode.LEFT
		public var labelAlignNum:uint=5
		public function MCheckButtonByMovie6(config:*=null) 
		{
			_label.percentHeight = 1
			_label.truncateToFit=false
			addChild(_label)
			super(config)
			if (config) {
				if (config.select!=null) select = config.select
				if (config.data != null) data = config.data
				if (config.label) label = config.label
				if(config.skin)skin=config.skin
			}
			if (width <= 0) this.width = 80
			if (height <= 0) this.height = 25
			if(skin==null)skin=new MCheckButtonByMovie6Skin()
			initMouse()
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
		 * 设置选择
		 */
		 public function set select(value:Boolean):void 
		{
			if (_select == value) return
			if(_selectLock)return
			_select = value
			if (_select) {
				
				if (enabled)goto(3)
				else goto(5)
				dispatchEvent(new Event(Event.SELECT,data,select))
				dispatchEvent(new SelectEvent(SelectEvent.SELECT,data,select))
			}
			else {
				if (enabled)goto(1)
				else goto(6)
				dispatchEvent(new SelectEvent(SelectEvent.RESELECT,data,select))
			}
			dispatchEvent(new SelectEvent(SelectEvent.UPSELECT,data,select))
		}
		 public function get select():Boolean { return _select; }
		 /**
		 * 按钮禁止使用,设置为取消选择
		 */
		public function set enabled(value:Boolean):void 
		{
			if (_enabled == value) return
			_enabled = value
			if (!enabled) {
				this.mouseEnabled = false
				if (select)goto(6)	
				else goto(5)	
			}else {
				this.mouseEnabled = true
				if (select)goto(3)
				else goto(1)
			}
			
		}
		public function get enabled():Boolean { return _enabled; }
		
		/**组件皮肤*/
		public function set skin(value:*):void {
			if (value is MovieClip&&MovieClip(value).totalFrames==6) {
				try {
					if (_skin && contains(Sprite(_skin))) removeChild(Sprite(_skin))
					_skin = value;
					_btn=_skin
					addChildAt(_skin,0)
					upSize()
				}catch (e:TypeError) {
					skin=new MCheckButtonByMovie6()
				}
				
			}else if (value == null){skin=new MCheckButtonByMovie6()}
		}
		public function get skin():* { return _skin; }
		/**
		 * 大小更新
		 */
		override public function upSize():void {
			if (_btn) {
				if (this.enabled) {
					if (select) goto(3)
					else goto(1)
				}else {
					if (select) goto(6)
					else goto(5)
				}
			}
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
			if (_labelAlign == LayoutMode.LEFT)_label.x = labelAlignNum
			else if (_labelAlign == LayoutMode.RIGHT)_label.x = width - _label.width - labelAlignNum
			else _label.x = (width - _label.width) / 2
			_label.y = (height -_label.textField.textHeight) / 2-2
		}
		public function get labelAlign():String { return _labelAlign; }
		/**
		 * 设置标签
		 */
		public function set label(value:String):void 
		{
			_label.text = value
			labelAlign=labelAlign
		}
		public function get label():String { return _label.text; }
		/**
		 * 文档对象
		 */
		public function get mLabel():MLabel { return _label; }
		/**
		 * 调整时候处理大小问题
		 * @param	value
		 */
		protected function goto(value:uint):void {
			if (!_btn) return
			var temp:DisplayObject
			_btn.gotoAndStop(value)
			temp = _btn.getChildAt(0)
			if(!temp)return
			temp.width = width
			temp.height = height
		}
		/**
		 * 鼠标事件
		 */
		protected function initMouse():void {
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver,false,0,true)
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut,false,0,true)
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown,false,0,true)
			//addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true)
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
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
			removeEventListener(MouseEvent.CLICK, mouseClick)
		}
		
		/**
		 * 鼠标点击事件
		 * @param	e
		 */
		private function mouseClick(e:MouseEvent):void {
		}
		/**
		 * 鼠标放开
		 * @param	e
		 */
		protected function mouseUp(e:MouseEvent):void {
			if (!enabled) return
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver)
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)	
			if (_select) {
				select = false
			}else {
				select=true
			}
		}
		/**
		 * 鼠标移开
		 * @param	e
		 */
		protected function mouseOut(e:MouseEvent):void {
		if (!enabled) return
			if (select)goto(3)
			else goto(1)
		}
		/**
		 * 鼠标经过样式
		 * @param	e
		 */
		protected function mouseOver(e:MouseEvent):void {
			if (!enabled) return
			if (select)goto(4)
			else goto(2)
		}
		/**
		 * 鼠标按下后
		 * @param	e
		 */
		protected function mouseDown(e:MouseEvent):void {
			if (!enabled) return
			if(_selectLock)return
			if (select)goto(1)
			else goto(3)
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver)
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true)	
		}
		
	}

}