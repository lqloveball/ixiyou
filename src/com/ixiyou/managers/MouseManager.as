package com.ixiyou.managers
{
	
	/**
	* 鼠标样式发报者
	* 鼠标的光标 控制工具
	* @author spe
	*/
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.ui.Mouse

	public class MouseManager extends EventDispatcher
	{
		private static var instance : MouseManager;
		//场景字典
		private static var stageDic:Dictionary=new Dictionary()
		/**
		 * 返回这个类的实例，做为静态方法返回实例。这样保证这个实例是唯一
		 * @param 
		 * @return 
		*/
		public static function getInstance(value:Stage = null) : MouseManager {
			/**
			 * 默认方式
			 */
			if (value == null) {
				if (instance == null)
				instance = new MouseManager();
				return instance;
			}else {
				//从字典里获取
				if (stageDic[value] != null) return stageDic[value] as MouseManager
				else {
					//字典里没有，创建一个
					var temp:MouseManager = new MouseManager();
					temp.stage=value
					stageDic[value] =temp
					return temp
				}
			}
		}
		
		private var _stage:Stage
		//鼠标样式
		public var _mouseStyle:DisplayObject;
		//鼠标事件时间
		private var showTimer:Timer;
		//鼠标事件对象
		private var currentObj:InteractiveObject;
		//鼠标事件对象列表
		private var objects:Dictionary;
		//移开鼠标样式事件发报
		public static var MOUSESTYLEOUT:String = 'mouseStyleOut'
		//移进鼠标样式事件发报
		public static var MOUSESTYLEOVER:String = 'mouseStyleOver'
		//默认鼠标
		private var _default:Object={mouseStyle:null,hide:true}
		/**
		 * 构造函数
		 * @param 
		 * @return 
		*/
		public function MouseManager(target:IEventDispatcher=null) 
		{
			super(target);
			objects = new Dictionary();
			showTimer=new Timer(10,0);
			showTimer.addEventListener(TimerEvent.TIMER,triggTimeConplete);
		}
		/**
		 * 设置场景
		 */
		public function set stage(value:Stage ):void 
		{
			//字典已经存在的一个场景
			if(stageDic[value]!=null)return
			if (stage) return
			_stage = value
			stageDic[value] = this
			
		}
		
		
		public function get stage():Stage {
			return _stage
		}
		/**
		 * 默认鼠标光标 
		 */
		public function get dmouseStyle():DisplayObject { return _default.mouseStyle; }
		public function get dmouseHit():Boolean { return _default.hide; }
		/**
		 * 因为默认光标 考虑到场景空白区域未必能有鼠标触发事件，所以独立添加
		 * @param	stage
		 * @param	value
		 */
		public function setDefaultStyle(stage:Stage,value:DisplayObject,hide:Boolean=true):void 
		{
			if (!this.stage) this.stage = stage
			if (_default.mouseStyle == value) return
			_default.hide=hide
			if (dmouseStyle != null ) {
				dmouseStyle.removeEventListener(Event.ENTER_FRAME,ENTER_FRAME)
				if( stage && stage.contains(dmouseStyle))stage.removeChild(dmouseStyle)
			}
			_default.mouseStyle = value
			if (_default.mouseStyle) {
				if (stage && _default.mouseStyle && !stage.contains(_default.mouseStyle))stage.addChild(_default.mouseStyle);
				if (dmouseHit) Mouse.hide();
				else Mouse.show();
				_default.mouseStyle.addEventListener(Event.ENTER_FRAME,ENTER_FRAME)
			}else {
				_default.hide=false
			}
		}
		private function ENTER_FRAME(e:Event):void {
			if (stage) {
				dmouseStyle.x = stage.mouseX;;
				dmouseStyle.y = stage.mouseY;
			}
		}
		/**
		 * 获取对应的显示对象的鼠标样式
		 * @param	obj
		 * @return
		 */
		public function getMouseStyle(obj:DisplayObject):DisplayObject {
			if (objects[obj] != null&&objects[obj].mouseStyle!=null) {
				return objects[obj].mouseStyle 
			}
			return null;
		}
		/**
		 * 获取鼠标样式对象
		 */
		public function getMouseObj(obj:DisplayObject):Object {
			if (objects[obj] != null) {
				return objects[obj]
			}
			return null;
		}
		/**
		 * 设置已有的对象是否隐藏鼠标
		 * @param	obj
		 * @param	hide
		 * @return
		 */
		public function setMouseObjHide(obj:DisplayObject, hide:Boolean):Object {
			//trace('setMouseObjHide',hide)
			if (objects[obj] != null) {
				var temp:Object = objects[obj]
				temp.hide = hide
				if (currentObj && currentObj == obj) {
					//是否隐藏系统鼠标
					if (temp.hide) Mouse.hide();
					else  Mouse.show();
				}
				return temp
			}
			return null
		}
		/**
		 * 添加对象
		 * @param obj
		 * @param msg
		 * 
		 */		
		public function push(obj:DisplayObject,mouseStyle:DisplayObject,hide:Boolean=true):void{
			if (obj is InteractiveObject) {
				if (stage != null && obj.stage != null&&obj.stage!=stage) {
					throw (new Error("#001 -(场景不匹配,一般发生在AIR情况下)"));
					return
				}
				if (!mouseStyle) {
					throw (new Error("#002 -(不能使用空对象作为鼠标样式)"));
					return
				}
				//如果已经有了
				if (objects[obj] == null) {
					if (stage == null && obj.stage)stage = obj.stage
					objects[obj]=new Object()
					objects[obj].mouseStyle = mouseStyle
					objects[obj].hide = hide
					if(objects[obj].mouseStyle  is InteractiveObject)InteractiveObject(objects[obj].mouseStyle).mouseEnabled=false
					obj.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHanlder);
					obj.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHanlder);
					DisplayObject(obj).addEventListener(Event.REMOVED_FROM_STAGE,mouseOutHanlder);
				}else {
					var temp:Object = objects[obj]
					if (obj &&stage) {
						if (stage.contains(temp.mouseStyle)) {
							stage.removeChild(temp.mouseStyle)
							stage.addChild(mouseStyle)
						}
					}
					temp.hide = hide
					temp.mouseStyle = mouseStyle
					if(temp.mouseStyle  is InteractiveObject)InteractiveObject(temp.mouseStyle).mouseEnabled=false
				}
				//if(obj.hasOwnProperty("mouseStyle")) objects[obj] = obj["mouseStyle"];
			}
		}
		/**
		 * 删除对象
		 * @param obj
		 * 
		 */		
		public function remove(obj:DisplayObject):void {
			//如果已经有了
			if(objects[obj] != null){
				InteractiveObject(obj).removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHanlder);
				InteractiveObject(obj).removeEventListener(MouseEvent.MOUSE_OUT, mouseOutHanlder);
				var temp:Object = objects[obj]
				if (obj &&stage) {
					if(stage.contains(temp.mouseStyle)){stage.removeChild(temp.mouseStyle);}
					obj.dispatchEvent(new Event(MouseManager.MOUSESTYLEOUT))
				}
				if (dmouseStyle == null) {
					Mouse.show();
				}else {
					Mouse.hide();
					stage.addChild(dmouseStyle);
				}
				showTimer.stop();
				objects[obj] = null;
			}
		}
		/**
		 * 按钮移动上去
		 * @param 
		 * @return 
		*/
		private function mouseOverHanlder(e:MouseEvent):void{
			currentObj = InteractiveObject(e.currentTarget);//等于当前正在使用某个事件侦听器处理 Event 对象的对象。
			if (currentObj.stage) {
				if (stage == null && currentObj.stage)stage = currentObj.stage
				if(stage&&dmouseStyle&&stage.contains(dmouseStyle) )stage.removeChild(dmouseStyle);
				showTimer.start();
				var obj:Object=objects[currentObj]
				_mouseStyle = obj.mouseStyle as DisplayObject;
			
				//是否隐藏系统鼠标
				if (obj.hide) Mouse.hide();
				else  Mouse.show();
				if(currentObj.stage){
					var x:int = currentObj.stage.mouseX;
					var y:int = currentObj.stage.mouseY;
					_mouseStyle.x = x;
					_mouseStyle.y = y;
				} 
				stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMovie)
				currentObj.stage.addChildAt(_mouseStyle,currentObj.stage.numChildren);
				currentObj.dispatchEvent(new Event(MouseManager.MOUSESTYLEOVER))
			}
			e.stopPropagation()
		}
		/**
		 * 按钮离开
		 * @param 
		 * @return 
		*/
		private function mouseOutHanlder(e:Event=null):void {
			if(e.target!=currentObj)return
			if (currentObj && currentObj.stage) {
				if(stage==null&&currentObj.stage)stage=currentObj.stage
				if(currentObj.stage.contains(_mouseStyle)){
					currentObj.stage.removeChild(_mouseStyle);
				}
				currentObj.dispatchEvent(new Event(MouseManager.MOUSESTYLEOUT))
			}
			if (dmouseStyle == null) {
				Mouse.show();
			}else {
				if (dmouseHit) Mouse.hide();
				else Mouse.show();
				stage.addChild(dmouseStyle);
			}
			currentObj=null
			showTimer.stop();
			e.stopPropagation()
		}
		/**
		 * 移动出原来的样式对象
		 * @param	e
		 */
		private function stageMovie(e:MouseEvent):void 
		{
			
			var bool:Boolean
			if (currentObj is DisplayObjectContainer) {
				bool=DisplayObjectContainer(currentObj).contains(e.target as DisplayObject)
			}
			//trace(currentObj, e.target, bool)
			if (currentObj != e.target&&!bool) {
				if (currentObj && currentObj.stage) {
				if(stage==null&&currentObj.stage)stage=currentObj.stage
				if(currentObj.stage.contains(_mouseStyle)){
					currentObj.stage.removeChild(_mouseStyle);
				}
					currentObj.dispatchEvent(new Event(MouseManager.MOUSESTYLEOUT))
				}
				if (dmouseStyle == null) {
					Mouse.show();
				}else {
					if (dmouseHit) Mouse.hide();
					else Mouse.show();
					stage.addChild(dmouseStyle);
				}
				currentObj=null
				showTimer.stop();
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMovie)
			}
			e.stopPropagation()
		}
		/**
		 * 鼠标跟随
		 * @param 
		 * @return 
		*/
		private function triggTimeConplete(e:TimerEvent):void{
			if (currentObj.stage) {
				if(_mouseStyle&&currentObj.stage.contains(_mouseStyle))currentObj.stage.setChildIndex(_mouseStyle,currentObj.stage.numChildren-1)
				var x:int = currentObj.stage.mouseX;
				var y:int = currentObj.stage.mouseY;
				_mouseStyle.x = x;
				_mouseStyle.y = y;
			} 
		}
	}
	
}