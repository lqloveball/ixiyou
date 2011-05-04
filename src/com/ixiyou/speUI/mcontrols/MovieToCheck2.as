package com.ixiyou.speUI.mcontrols 
{
	
	
	/**
	 * 影片剪辑转换成CheckBox按钮,2帧形式，通常用来开关按钮
	 * 分别是
	 * 不选择 选择
	 * @author spe
	 */
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event
	import flash.events.MouseEvent;
	import com.ixiyou.events.SelectEvent
	import com.ixiyou.speUI.core.Iselect
	import com.ixiyou.speUI.core.IDestory
	import com.ixiyou.speUI.core.ISkinComponent
	import com.ixiyou.events.SelectEvent
	[Event(name = 'upSelect', type = "com.ixiyou.events.SelectEvent")]
	[Event(name = 'ReSelect', type = "com.ixiyou.events.SelectEvent")]
	[Event(name = 'Select', type = "com.ixiyou.events.SelectEvent")]
	public class MovieToCheck2 extends Sprite implements Iselect,IDestory,ISkinComponent
	{
		
		//选择更新
		public static var UPSELECT:String = SelectEvent.UPSELECT;
		//选择
		public static var SELECT:String = SelectEvent.SELECT;
		//取消选择
		public static var RESELECT:String = SelectEvent.RESELECT;
		//所使用的影片剪辑
		protected var _btn:MovieClip
		//对应捆绑数据
		public var data:*
		//选择锁定
		protected var _selectLock:Boolean = false
		//是否选择
		protected var _select:Boolean = false
		public function MovieToCheck2(config:MovieClip,formerly:Boolean=false,parentBool:Boolean=false) 
		{
			if (formerly) {
				this.x = config.x
				this.y = config.y
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
			this.mouseChildren=false
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
		 * 对象的原型按钮
		 */
		public function get btn():MovieClip { return _btn; }
		/**
		 * 鼠标事件
		 */
		protected function initMouse():void {
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver,false,0,true)
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut,false,0,true)
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown,false,0,true)
			addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true)
			addEventListener(MouseEvent.CLICK, mouseClick,false,0,true)
		}
		/**
		 * 鼠标放开
		 * @param	e
		 */
		protected function mouseUp(e:MouseEvent):void {}
		/**
		 * 鼠标移开
		 * @param	e
		 */
		 protected function mouseOut(e:MouseEvent):void {}
		/**
		 * 鼠标经过样式
		 * @param	e
		 */
		protected function mouseOver(e:MouseEvent):void {}
		/**
		 * 鼠标按下后
		 * @param	e
		 */
		protected function mouseDown(e:MouseEvent):void {}
		/**
		 * 鼠标点击
		 * @param	e
		 */
		protected function mouseClick(e:MouseEvent):void {
			if (_select) {
				select = false
			}else {
				select=true
			}
		}
		/**
		 *  是否锁定不能改变选择状态，作为复选，单选时候使用
		 */
		public function set selectLock(value:Boolean):void {
			_selectLock=value
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
				_btn.gotoAndStop(2)
				dispatchEvent(new Event(Event.SELECT))
				dispatchEvent(new SelectEvent(SelectEvent.SELECT,data,select))
				
			}
			else {
				dispatchEvent(new SelectEvent(SelectEvent.RESELECT,data,select))
				_btn.gotoAndStop(1)
			}
			dispatchEvent(new SelectEvent(SelectEvent.UPSELECT,data,select))
		}
		 public function get select():Boolean { return _select; }
		/**
		 * 删除索引
		 */
		public function destory():void {
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver)
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
			removeEventListener(MouseEvent.CLICK, mouseClick)
		}
	}

}