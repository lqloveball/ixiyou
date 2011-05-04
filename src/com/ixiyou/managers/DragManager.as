package com.ixiyou.managers 
{
	import com.ixiyou.utils.display.DisplayCopy;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	/**
	 * 拖动管理类
	 * @author magic
	 */
	public class DragManager
	{
		/**
		 * 直接拖动
		 */
		public static const DIRECT:String = "direct";
		/**
		 * 图标拖动
		 */
		public static const ICON:String = "icon";
		
		private var _lockCenter:Boolean;
		private var _target:DisplayObject;
		private var _icon:DisplayObject;
		private var _dragIcon:DisplayObject;
		private var _type:String;
		private var _alpha:Number;
		private var _bounds:Rectangle;
		
		///*********拖动时的回调函数************///
		private var dragHandler:Function;
		private var startHandler:Function;
		private var stopHandler:Function;
		
		///***********拖动时的临时数据***********///
		private var _targetX:Number;
		private var _targetY:Number;
		private var _mouseX:Number;
		private var _mouseY:Number;
		private var _oldAlpha:Number;
		private var _mouseStage:DisplayObjectContainer;
		
		/**
		 * 记录正在拖动的对象
		 */
		private static var _dragMap:Dictionary = new Dictionary();
		/**
		 * 记录注册过的拖动对象
		 */
		private static var _regMap:Dictionary = new Dictionary();
		
		private static var _active:Boolean = false;
		/**
		 * 拖动一个显示对象
		 * @param	target	被拖动的对象
		 * @param	type	拖动类型
		 * @param	icon	拖动时的显示图标
		 * @param	lockCenter	锁定到鼠标位置中央
		 * @param	alpha	图标的透明度
		 * @param	bounds	拖动范围
		 * @param	stopHandler	拖动停止时回调		function(dm:DragManager):void{}
		 * @param	dragHandler	拖动过程中回调		function(dm:DragManager):void{}
		 */
		public static function startDrag(target:DisplayObject,type:String = "icon", icon:DisplayObject = null,lockCenter:Boolean=true, alpha:Number = 0.5,bounds:Rectangle=null,stopHandler:Function=null,dragHandler:Function = null):DragManager {
			var dm:DragManager = new DragManager(target, type, icon,lockCenter, alpha,bounds);
			dm.dragHandler = dragHandler;
			dm.stopHandler = stopHandler;
			dm.start();
			return dm
		}
		/**
		 * 停止对显示对象的拖动
		 * @param	target
		 */
		public static function stopDrag(target:DisplayObject):void {
			try {
				_dragMap[target].stop();
			}catch (e:Error) {
				
			}
		}
		
		/**
		 * 对象是否注册拖动
		 * @param	target
		 */
		public static function isRegister(target:DisplayObject):Boolean {
			return _regMap[target] != null;
		}
		/**
		 * 对象是否被拖动
		 * @param	target
		 * @return
		 */
		public static function isDrag(target:DisplayObject):Boolean {
			return _dragMap[target] != null;
		}
		
		
		 /**
		  * 注册一个有拖动行为的显示对象
		  * @param	target	被拖动的对象
		  * @param	type	拖动类型
		  * @param	icon	拖动时的显示图标
		  * @param	lockCenter	锁定到鼠标位置中央
		  * @param	alpha	图标的透明度
		  * @param	bounds	拖动范围
		  * @param	stopHandler	拖动停止时回调		function(dm:DragManager):void{}
		  * @param	startHandler	开始拖动时回调	function(dm:DragManager):void{}
		  * @param	dragHandler	拖动过程中回调		function(dm:DragManager):void{}
		  */
		public static function register(target:DisplayObject,type:String = "icon", icon:DisplayObject = null,lockCenter:Boolean=true,  alpha:Number = 0.5,bounds:Rectangle=null, stopHandler:Function=null, startHandler:Function = null, dragHandler:Function = null):void {
			var dm:DragManager = new DragManager(target, type, icon,lockCenter, alpha,bounds);
			dm.startHandler = startHandler;
			dm.dragHandler = dragHandler;
			dm.stopHandler = stopHandler;
			dm.register();
		}
		
		/**
		 * 取消拖动行为
		 * @param	target
		 */
		public static function unRegister(target:DisplayObject):void {
			try {
				_dragMap[target].unRegister();
			}catch (e:Error) {
				
			}
		}
		
		/**
		 * 实例化一个拖动
		 * @param	target	被拖动的对象
		 * @param	type	拖动类型
		 * @param	icon	拖动时的显示图标
		 * @param	lockCenter	锁定到鼠标位置中央
		 * @param	alpha	图标的透明度
		 * @param	bounds	拖动范围
		 */
		public function DragManager(target:DisplayObject,type:String="icon",icon:DisplayObject=null,lockCenter:Boolean=false,alpha:Number=0.5,bounds:Rectangle=null) 
		{
			_target = target;
			_lockCenter = lockCenter;
			_type = type;
			_alpha = alpha;
			_icon = icon;
			_bounds = bounds;
		}
		
		/**
		 * 开始拖动
		 */
		public function start():void {
			if (_dragMap[_target] != null) {
				_dragMap[_target].stop();
			}
			_dragMap[_target] = this;
			if (_type == ICON) {
				if (_icon == null) {
					_dragIcon =DisplayCopy.copyAsShape(_target);
				}else {
					_dragIcon =_icon
				}
				_target.stage.addChild(_dragIcon);
				if (_lockCenter) {
					var rect:Rectangle = _dragIcon.getRect(_dragIcon);
					_dragIcon.x = _target.stage.mouseX - rect.width * 0.5 - rect.x;
					_dragIcon.y = _target.stage.mouseY - rect.height * 0.5 - rect.y;
				}else {
					var pt:Point = new Point(_target.x, _target.y);
					pt=_target.parent.localToGlobal(pt);
					_dragIcon.x = pt.x;
					_dragIcon.y = pt.y;
				}
			}else if (_type == DIRECT) {
				_dragIcon = _target;
				_oldAlpha = _dragIcon.alpha;
			}
			_dragIcon.alpha = _alpha;
			_targetX = _dragIcon.x;
			_targetY = _dragIcon.y;
			_mouseStage = _dragIcon.parent;
			_mouseX = _mouseStage.mouseX;
			_mouseY = _mouseStage.mouseY;
			_target.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler);
			_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			if (startHandler != null) {
				startHandler(this);
			}
		}
		
		/**
		 * 注册拖动
		 */
		public function register():void {
			var active:InteractiveObject = _target as InteractiveObject;
			if (active) {
				if (_regMap[_target] != null) {
					_regMap[_target].unRegister();
				}
				active.addEventListener(MouseEvent.MOUSE_DOWN, onActive);
			}else {
				throw new Error("拖动对象无法侦听鼠标事件不能注册");
			}
		}
		
		/**
		 * 取消注册
		 */
		public function unRegister():void {
			var active:InteractiveObject = _target as InteractiveObject;
			if (active) {
				active.removeEventListener(MouseEvent.MOUSE_DOWN, onActive);
				delete _regMap[_target];
			}
		}
		
		/**
		 * 停止拖动
		 */
		public function stop():void {
			try{
				_dragIcon.stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
				_dragIcon.stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
			}catch (e:Error) { }
			
			if (_type == ICON) {
				_dragIcon.stage.removeChild(_dragIcon);
			}else {
				_dragIcon.alpha = _oldAlpha;
			}
			delete _dragMap[_target];
			if (stopHandler != null) stopHandler(this);
			_dragIcon = null;
		}
		
		/**
		 * 注册过的拖动对象被激活
		 * @param	e
		 */
		private function onActive(e:Event):void {
			if (e.eventPhase == 3 && _active) return;
			_active = true;
			_target.addEventListener(MouseEvent.MOUSE_MOVE, checkDrag);
			_target.addEventListener(MouseEvent.MOUSE_UP, endCheck);
		}
		
		/**
		 * 检测激活对象是否拖动
		 * @param	me
		 */
		private function checkDrag(me:MouseEvent):void {
			_active = false;
			endCheck()
			start();
		}
		/**
		 * 结束对激活对象的检测
		 * @param	me
		 */
		private function endCheck(me:MouseEvent = null):void {
			_active = false;
			_target.removeEventListener(MouseEvent.MOUSE_MOVE, checkDrag);
			_target.removeEventListener(MouseEvent.MOUSE_UP, endCheck);
		}
		
		/**
		 * 拖动时放开鼠标
		 * @param	me
		 */
		private function upHandler(me:MouseEvent):void {
			stop();
		}
		
		/**
		 * 拖动时鼠标移动
		 * @param	me
		 */
		private function moveHandler(me:MouseEvent):void {
			if (_bounds) {
				var tempX:Number = _target.parent.mouseX;
				var tempY:Number = _target.parent.mouseY;
				if (tempX > _bounds.right || tempX < _bounds.left || tempY<_bounds.top||tempY>_bounds.bottom) return;
			}
			_dragIcon.x = _targetX + _mouseStage.mouseX - _mouseX;
			_dragIcon.y = _targetY + _mouseStage.mouseY - _mouseY;
			if (dragHandler!=null) dragHandler(this);
		}
		
		/**
		 * 锁定到鼠标位置中央
		 */
		public function get lockCenter():Boolean { return _lockCenter; }
		/**
		 * 拖动目标
		 */
		public function get target():DisplayObject { return _target; }
		/**
		 * 拖动时的图标
		 */
		public function get dragIcon():DisplayObject { return _dragIcon; }
		/**
		 * 拖动类型
		 */
		public function get type():String { return _type; }
		/**
		 * 图标透明度
		 */
		public function get alpha():Number { return _alpha; }
		public function set alpha(value:Number):void 
		{
			_alpha = value;
			if (_dragIcon != null) {
				_dragIcon.alpha = _alpha;
			}
		}
		
		/**
		 * 拖动范围
		 */
		public function get bounds():Rectangle { return _bounds; }
		public function set bounds(value:Rectangle):void 
		{
			_bounds = value;
		}
	}

}