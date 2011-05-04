package com.ixiyou.managers 
{
	import flash.events.EventDispatcher;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject 
	import flash.events.MouseEvent
	import flash.events.Event
	import flash.events.TimerEvent
	import flash.utils.Dictionary
	import flash.utils.getTimer;
	import flash.utils.Timer
	[Event(name = "md1Click", type = "flash.events.Event")]
	[Event(name="md2Click", type="flash.events.Event")]
	/**
	 * 自定义双击事件类
	 * @author spe
	 */
	public class Mouse2Click extends EventDispatcher
	{
		
		private var _mouseObj:InteractiveObject
		private var _delay:uint
		private var sta:Boolean=false
		private var old:int
		static public var MD1_ClICK:String = "md1Click";
		static public var MD2_ClICK:String = "md2Click";
		protected var _fun:Function = null
		private var _target:InteractiveObject=null
		public function Mouse2Click(obj:InteractiveObject, delay:uint = 300,fun:Function=null) {
			mouseObj = obj
			_delay = delay
			old = getTimer()
			this.fun=fun
		}
		
		private function chick(e:MouseEvent):void {
			if (e.target == mouseObj || DisplayObjectContainer(mouseObj).contains(InteractiveObject(e.target))) {
				var newTime:int = getTimer() - old
				old=getTimer()
				if (newTime < delay) {
					//strace(e.target,'双击')
					dispatchEvent(new Event(MD2_ClICK))
					if(e.target is InteractiveObject)_target=e.target as InteractiveObject
					_mouseObj.dispatchEvent(new MouseEvent(Mouse2Click.MD2_ClICK,e.bubbles,e.cancelable,e.localX,e.localY,e.relatedObject,e.ctrlKey,e.altKey,e.shiftKey,e.buttonDown))
					if (this.fun != null)fun()
				}else {
					//trace(e.target,'单击')
					dispatchEvent(new Event(MD1_ClICK))
					if(e.target is InteractiveObject)_target=e.target as InteractiveObject
					_mouseObj.dispatchEvent(new MouseEvent(Mouse2Click.MD1_ClICK,e.bubbles,e.cancelable,e.localX,e.localY,e.relatedObject,e.ctrlKey,e.altKey,e.shiftKey,e.buttonDown))
				}
			}
			
		}
		/**
		 * 鼠标事件对象
		 */
		public function get mouseObj():InteractiveObject { return _mouseObj; }
		public function set mouseObj(value:InteractiveObject):void 
		{
			if (_mouseObj) {
				InteractiveObject(_mouseObj).removeEventListener(MouseEvent.CLICK, chick);
			}
			_mouseObj = value;
			InteractiveObject(_mouseObj).addEventListener(MouseEvent.CLICK, chick);
		}
		/**
		 * 鼠标事件时间
		 */
		public function get delay():uint { return _delay; }
		
		public function set delay(value:uint):void 
		{
			_delay = value;
		}
		
		public function get fun():Function { return _fun; }
		
		public function set fun(value:Function):void 
		{
			if(value!=null)_fun = value;
		}
		
		public function get target():InteractiveObject { return _target; }
		/**
		 * 摧毁
		 */
		public function destory():void {
			_mouseObj=null
			InteractiveObject(_mouseObj).removeEventListener(MouseEvent.CLICK, chick);
		}
		
	}

}