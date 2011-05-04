package com.ixiyou.managers 
{
	
	/**
	* 提示管理器
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class ToolTipManager extends EventDispatcher
	{
		private static var instance : ToolTipManager;
		/**
		 * 返回这个类的实例，做为静态方法返回实例。这样保证这个实例是唯一
		 * @param 
		 * @return 
		*/
		public static function getInstance() : ToolTipManager {
			if (instance == null)
				instance = new ToolTipManager();
			return instance;
		}
		public var _stage:Stage
		//显示时间
		public var showTime:uint = 5000
		//鼠标移动间隔
		public var mouseTime:uint = 10
		//使用显示时间间隔
		public var TimeBool:Boolean=true
		//提示框
		public var _toolTip:DisplayObject;
		//事件时间
		private var showTimer:Timer;
		//事件对象
		private var currentObj:InteractiveObject;
		//事件对象列表
		private var objects:Dictionary;
		/**
		 * 构造函数
		 * @param 
		 * @return 
		*/
		
		public function ToolTipManager(target:IEventDispatcher=null) 
		{
			super(target);
			objects = new Dictionary();
			showTimer=new Timer(showTime,uint(showTime/mouseTime));
			showTimer.addEventListener(TimerEvent.TIMER, TIMER);
			showTimer.addEventListener(TimerEvent.TIMER_COMPLETE, TIMER_COMPLETE)
		}
		/**
		 * 添加对象的帮�?
		 * @param obj
		 * @param msg
		 * 
		 */		
		public function push(obj:DisplayObject, toolTip:DisplayObject):void {
			
			if (obj is InteractiveObject) {
				//如果已经有了
				if (objects[obj] == null) {
					if(_stage==null&&obj.stage)_stage=obj.stage
					objects[obj] = toolTip
					if(objects[obj] is InteractiveObject)InteractiveObject(objects[obj]).mouseEnabled=false
					obj.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHanlder);
					obj.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHanlder);
					DisplayObject(obj).addEventListener(Event.REMOVED_FROM_STAGE,mouseOutHanlder);
				}
				else {
					trace(objects[obj])
				}
				//if (obj.hasOwnProperty("toolTip")) objects[obj] = obj["toolTip"];
				
			}
		}
		/**
		 * 删除对象
		 * @param obj
		 * 
		 */		
		public function remove(obj:Object):void{
			if (objects[obj] != null) {
				//trace("shanchu")
				var toolTip:DisplayObject=DisplayObject(objects[obj])
				if(toolTip&&toolTip.stage.contains(toolTip))toolTip.stage.removeChild(_toolTip)
				InteractiveObject(obj).removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHanlder);
				InteractiveObject(obj).removeEventListener(MouseEvent.MOUSE_OUT,mouseOutHanlder);
				objects[obj] == null;
				
			}
		}
		
		private function mouseOverHanlder(e:MouseEvent):void {
			currentObj = InteractiveObject(e.currentTarget);//等于当前正在使用某个事件侦听器处理 Event 对象的对象。
			if (currentObj.stage) {
				if (_stage == null && currentObj.stage)_stage = currentObj.stage
				showTimer.reset();
				showTimer.delay=mouseTime
				showTimer.start();
				_toolTip = objects[currentObj] as DisplayObject;
				if(_toolTip is InteractiveObject)InteractiveObject(_toolTip).mouseEnabled=false
				var x:int = currentObj.stage.mouseX;
				var y:int = currentObj.stage.mouseY;
				var stage:Stage = currentObj.stage
				if (stage.stageWidth - (_toolTip.width + x + 15) < 0) x=x-_toolTip.width-10
				else x= x +15
				if (stage.stageHeight - (_toolTip.height + y) < 0) y=y-_toolTip.height 
				else y = y
				_toolTip.x = x;
				_toolTip.y = y;
				currentObj.stage.addChild(_toolTip);
			}
			e.stopPropagation();//停止冒泡
		}
		private function mouseOutHanlder(e:Event):void {
			hide()
			showTimer.reset();
			e.stopPropagation();//停止冒泡
		}
		
		/*显示市跟随鼠标运算
		 *
		*/
		private function TIMER(e:TimerEvent):void  {
			if(currentObj.stage){
				var x:int = currentObj.stage.mouseX;
				var y:int = currentObj.stage.mouseY;
				var stage:Stage = currentObj.stage
				if (stage.stageWidth - (_toolTip.width + x + 15) < 0) x=x-_toolTip.width-10
				else x= x +15
				if (stage.stageHeight - (_toolTip.height + y) < 0) y=y-_toolTip.height 
				else y = y
				_toolTip.x = x;
				_toolTip.y = y;
			} 
		}
		/*
		 *超出显示时间
		*/
		private function TIMER_COMPLETE(e:TimerEvent) :void {
			if (TimeBool) {
				showTimer.reset();
				hide()
			}
			else {
				showTimer.start();
			}
			
		}
		/*屏蔽显示
		 *
		*/
		private function hide():void  {
			if(currentObj&&currentObj.stage&&_toolTip&&currentObj.stage.contains(_toolTip)){
					currentObj.stage.removeChild(_toolTip);
			}else {
				if(_toolTip&&_toolTip.stage&&_toolTip.stage.contains(_toolTip))_toolTip.stage.removeChild(_toolTip);
			}
		}
	}
	
}