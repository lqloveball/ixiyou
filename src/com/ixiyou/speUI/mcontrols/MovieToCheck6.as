package com.ixiyou.speUI.mcontrols 
{
	
	
	/**
	 * 影片剪辑转换成CheckBox按钮,6帧形式，通常用来做复选框按钮
	 * 分别是
	 * 不选默认 不选移上 选择默认 选择移上 禁止选中 禁止不选中
	 * @author spe
	 */
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event
	import flash.events.MouseEvent;
	import com.ixiyou.events.SelectEvent
	import com.ixiyou.speUI.core.Iselect
	public class MovieToCheck6 extends MovieToCheck2
	{
		//是否使用
		protected var _enabled:Boolean
		public function MovieToCheck6(config:MovieClip,formerly:Boolean=false,parentBool:Boolean=false) 
		{
			super(config,formerly,parentBool)
			enabled=true
		}
		/**
		 * 鼠标事件
		 */
		override protected function initMouse():void {
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver,false,0,true)
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut,false,0,true)
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown,false,0,true)
			//addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true)
			addEventListener(MouseEvent.CLICK, mouseClick,false,0,true)
		}
		/**
		 * 鼠标放开
		 * @param	e
		 */
		override protected function mouseUp(e:MouseEvent):void {
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
		override  protected function mouseOut(e:MouseEvent):void {
			if (!enabled) return
			if (select)_btn.gotoAndStop(3)
			else _btn.gotoAndStop(1)
		}
		/**
		 * 鼠标经过样式
		 * @param	e
		 */
		override protected function mouseOver(e:MouseEvent):void {
			if (!enabled) return
			if (select)_btn.gotoAndStop(4)
			else _btn.gotoAndStop(2)
			//else _btn.gotoAndStop(4)
		}
		/**
		 * 鼠标按下后
		 * @param	e
		 */
		override protected function mouseDown(e:MouseEvent):void {
			if (!enabled) return
			if(_selectLock)return
			if (select)_btn.gotoAndStop(1)
			else _btn.gotoAndStop(3)
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver)
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true)	
		}
		/**
		 * 鼠标点击
		 * @param	e
		 */
		override protected function mouseClick(e:MouseEvent):void {
		}
		/**
		 *  是否锁定不能改变选择状态，作为复选，单选时候使用
		 */
		override public function set selectLock(value:Boolean):void {
			if(value==_selectLock)return
			_selectLock = value
		}
		/**
		 * 按钮禁止使用,设置为取消选择
		 */
		public function set enabled(value:Boolean):void 
		{
			if (_enabled == value) return
			_enabled = value
			if (!enabled) {
				this.mouseEnabled = false
				if (select)_btn.gotoAndStop(4)
				else _btn.gotoAndStop(6)
			}else {
				this.mouseEnabled = true
				if (select)_btn.gotoAndStop(3)
				else _btn.gotoAndStop(1)
			}
		}
		public function get enabled():Boolean { return _enabled; }
		/**
		 * 设置选择
		 */
		override public function set select(value:Boolean):void 
		{
			if (_select == value) return
			if(_selectLock)return
			_select = value
			if (_select) {
				dispatchEvent(new Event(Event.SELECT))
				dispatchEvent(new SelectEvent(SelectEvent.SELECT,data,select))
				if (enabled)_btn.gotoAndStop(3)
				else _btn.gotoAndStop(5)
			}
			else {
				dispatchEvent(new SelectEvent(SelectEvent.RESELECT,data,select))
				if (enabled)_btn.gotoAndStop(1)
				else _btn.gotoAndStop(6)
			}
			dispatchEvent(new SelectEvent(SelectEvent.UPSELECT,data,select))
		}
		
		/**
		 * 删除索引
		 */
		override public function destory():void {
			super.destory()
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)	
		}
	}

}