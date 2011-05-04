package com.ixiyou.air.managers 
{
	import com.ixiyou.air.utils.WindowsUtil;
	import com.ixiyou.events.AIRWindowsEvent;
	import com.ixiyou.utils.core.Singleton
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.geom.Rectangle;
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NativeWindowBoundsEvent;
	import flash.utils.Dictionary;
	/**
	 * 窗口管理器
	 * @author spe
	 */
	public class AIRWindowsManager extends Singleton
	{
		protected var _list:Array = new Array()
		protected var _dic:Dictionary = new Dictionary()
		protected var _nativeApplication:NativeApplication
		/**
		 * 单例模式获取
		 */
		static public function get instance():AIRWindowsManager
		{
			return Singleton.getInstanceOrCreate(AIRWindowsManager) as AIRWindowsManager;
		}
		/**
		 * 构造函数
		 */
		public function AIRWindowsManager() {
			super()
		}
		/**
		 * 指定在关闭所有窗口后是否应自动终止应用程序。
		 */
		public function set autoExit(value:Boolean):void 
		{
			if(nativeApplication.autoExit!=value)nativeApplication.autoExit=value
		}
		public function get autoExit():Boolean { return nativeApplication.autoExit; }
		/**
		 * 指定在当前用户登录时是否自动启动此应用程序。
		 */
		public function set startAtLogin(value:Boolean):void 
		{
			if(nativeApplication.startAtLogin!=value)nativeApplication.startAtLogin=value
		}
		public function get startAtLogin():Boolean {
			return nativeApplication.startAtLogin; 
		}
		
		/**
		 * 包含此应用程序的所有已打开的本机窗口的数组。
		 */
		public function get openedWindows():Array { return nativeApplication.openedWindows; }
		/**
		 * 管理列表内是否包含窗口
		 * @param	value
		 */
		public function contains(value:NativeWindow):Boolean {
			var num:int = list.indexOf(value)
			if (num < 0) return false
			else return true
		}
		/**
		 * 创建窗口并添加
		 * @param	title 窗口标题
		 * @param   bounds 窗口大小
		 * @param	type 指定要创建的窗口的类型
		 * @param	systemChrome 指定是否为窗口提供系统镶边。
		 * @param	transparent 指定窗口是否支持针对桌面的透明度和 Alpha 混合。
		 * @param	resizable 指定窗口是否可调整大小。
		 * @param	maximizable 指定窗口是否可最大化。
		 * @param	minimizable 指定窗口是否可最小化。
		 * @return
		 */
		public  function addWindow(title:String = 'windows',bounds:Rectangle=null,
			type:String = 'normal', 
			systemChrome:String = 'standard',
			transparent:Boolean =false,
			resizable:Boolean = true,
			maximizable:Boolean=true,minimizable:Boolean=true):NativeWindow {
			var wins:NativeWindowInitOptions = WindowsUtil.windowType(type, systemChrome, transparent, resizable, maximizable, minimizable)
			var win:NativeWindow = new NativeWindow(wins)
			win.title = title
			if (!bounds)bounds=new Rectangle(0,0,300,300)
			win.bounds = bounds
			add(win)
			return win
		}
		/**
		 *  创建窗口
		 * @param	itle
		 * @param	bounds
		 * @param	type
		 * @param	systemChrome
		 * @param	transparent
		 * @param	resizable
		 * @param	maximizable
		 * @param	minimizable
		 * @return
		 */
		public function foundWindow(title:String = 'windows',bounds:Rectangle=null,
			type:String = 'normal', 
			systemChrome:String = 'standard',
			transparent:Boolean =false,
			resizable:Boolean = true,
			maximizable:Boolean=true,minimizable:Boolean=true):NativeWindow {
			var wins:NativeWindowInitOptions = WindowsUtil.windowType(type, systemChrome, transparent, resizable, maximizable, minimizable)
			var win:NativeWindow = new NativeWindow(wins)
			win.title = title
			if (!bounds)bounds=new Rectangle(0,0,300,300)
			win.bounds = bounds
			//add(win)
			return win
		}
		/**
		 * 添加窗口
		 * @param	value
		 */
		public function add(value:NativeWindow,id:String='',closeQuerist:Boolean=false):void {
			if (!contains(value)) {
				list.push(value)
				addEvent(value)
				//对字典添加工作
				if (id != '' && _dic[id] == null)_dic[id] = {window:value,id:id,closeQuerist:closeQuerist}
				_dic[value] = { window:value, id:id ,closeQuerist:closeQuerist}
				dispatchEvent(new AIRWindowsEvent(AIRWindowsEvent.ADD_WINDOW,value,_dic[value]))
			}
			
		}
		/**
		 * 获取对象在字典里的属性
		 * @param	value
		 * @return
		 */
		public function getWindowByPrototype(value:NativeWindow):Object { return _dic[value]; }
		/**
		 * 设置窗口关闭是否询问
		 * @param	value
		 * @param	bool
		 * @return
		 */
		public function setWinowCloseQuerist(value:NativeWindow,bool:Boolean):Boolean {
			if (getWindowByPrototype(value)) {
				_dic[value].closeQuerist=bool
				return true
			}else {
				return false
			}
		}
		/**
		 * 添加事件
		 * @param	value
		 */
		private function addEvent(value:NativeWindow):void {
			value.addEventListener(Event.ACTIVATE, activate)
			value.addEventListener(Event.CLOSE, closeEvent)
			value.addEventListener(Event.CLOSING, closeIng)
			value.addEventListener(Event.DEACTIVATE, deaCtivate)
			value.addEventListener(NativeWindowBoundsEvent.MOVE, windowMove)
			value.addEventListener(NativeWindowBoundsEvent.MOVING, windowMoveIng)
			value.addEventListener(NativeWindowBoundsEvent.RESIZE, reSize)
			value.addEventListener(NativeWindowBoundsEvent.RESIZING,reSizeIng)
		}
		/**
		 * 删除事件
		 * @param	value
		 */
		private function removeEvent(value:NativeWindow):void {
			value.removeEventListener(Event.ACTIVATE, activate)
			value.removeEventListener(Event.CLOSE, closeEvent)
			value.removeEventListener(Event.CLOSING, closeIng)
			value.removeEventListener(Event.DEACTIVATE, deaCtivate)
			value.removeEventListener(NativeWindowBoundsEvent.MOVE, windowMove)
			value.removeEventListener(NativeWindowBoundsEvent.MOVING, windowMoveIng)
			value.removeEventListener(NativeWindowBoundsEvent.RESIZE, reSize)
			value.removeEventListener(NativeWindowBoundsEvent.RESIZING,reSizeIng)
		}
		/**
		 * 窗口大小改变中
		 * @param	e
		 */
		private function reSizeIng(e:NativeWindowBoundsEvent):void 
		{
			dispatchEvent(e)
		}
		/**
		 * 窗口大小改变
		 * @param	e
		 */
		private function reSize(e:NativeWindowBoundsEvent):void 
		{
			dispatchEvent(e)
		}
		/**
		 * 窗口移动中
		 * afterBounds 未处理的窗口的新范围。 
		 * beforeBounds 未处理的窗口的旧范围。 
		 * @param	e
		 */
		private function windowMoveIng(e:NativeWindowBoundsEvent):void 
		{
			dispatchEvent(e)
		}
		/**
		 * 窗口移动
		 * afterBounds 窗口的新范围。 
		 * beforeBounds 窗口的旧范围。 
		 * @param	e
		 */
		private function windowMove(e:NativeWindowBoundsEvent):void 
		{
			dispatchEvent(e)
		}
		
		/**
		 * 窗口关闭中
		 * @param	e
		 */
		private function closeIng(e:Event):void 
		{
			var win:NativeWindow = e.target as NativeWindow
			if (_dic[win] != null) {
				var obj:Object = _dic[win]
				if (obj && obj.closeQuerist) {
					//需要在关闭前询问阻止
					e.preventDefault()
					dispatchEvent(new AIRWindowsEvent(AIRWindowsEvent.CLOSEQUERIST,win,obj))
				}
			}
		}
		/**
		 * 关闭窗口事件
		 * @param	e
		 */
		private function closeEvent(e:Event):void 
		{
			var win:NativeWindow = e.target as NativeWindow
			if (_dic[win] != null)	var obj:Object = _dic[win]
			dispatchEvent(new AIRWindowsEvent(AIRWindowsEvent.CLOSE, win, obj))
			
		}
		/**
		 * 激活
		 * @param	e
		 */
		private function activate(e:Event):void {
			dispatchEvent(new AIRWindowsEvent(e.type,e.target as NativeWindow))
		}
		/**
		 * 在取消激活窗口后由此 NativeWindow 对象调度。
		 * @param	e
		 */
		private function deaCtivate(e:Event):void 
		{
			dispatchEvent(new AIRWindowsEvent(e.type,e.target as NativeWindow))
		}
		/**
		 * 删除指定窗口
		 * @param	value
		 */
		public function remove(value:NativeWindow,closeBool:Boolean=false):void {
			var num:int = list.indexOf(value)
			if (num >= 0) list.splice(num, 1)
			//对字典的清除工作
			var obj:Object
			var oobj:Object=_dic[value]
			if (_dic[value] != null) {
				obj = _dic[value]
				_dic[value] = null
				removeEvent(value)
				dispatchEvent(new AIRWindowsEvent(AIRWindowsEvent.REMOVE_WINDOW,value,oobj))
			}
			if (obj) {
				if(obj.id!='')_dic[obj.id]=null
			}
			if(closeBool)value.close()
		}
		/**
		 * 更加ID号获取窗口对象
		 * @param	value
		 * @return
		 */
		public function getWindowByID(value:String):NativeWindow {
			var win:NativeWindow
			if (_dic[value] != null&&value!='') {
				win=_dic[value].window
			}
			return win;
		}
		/**
		 * 打开显示
		 * @param	value
		 */
		public function show(value:NativeWindow):void {
			WindowsUtil.show(value)
		}
		/**
		 * 隐藏关闭
		 * @param	value
		 */
		public function hit(value:NativeWindow):void {
			WindowsUtil.hit(value)
		}
		/**
		 * 关闭指定窗口
		 * @param	value
		 */
		public function close(value:NativeWindow):void {
			remove(value)
			value.close()
		}
		/**
		 * 关闭所有窗口
		 */
		public function closeAll():void {
			if(!list)return
			var temp:NativeWindow
			dispatchEvent(new AIRWindowsEvent(AIRWindowsEvent.CLOSE_ALL))
			for (var i:int = 0; i < list.length; i++) 
			{
				temp = list[i] as NativeWindow
				close(temp)
			}
		}
		/**
		 * 窗口列表
		 */
		public function get list():Array { return _list; }		
		/**
		 * 关闭程序
		 */
		public function exit():void {
			nativeApplication.exit()
		} 
		/**
		 * NativeApplication 对象的单一实例。
		 */
		public function get nativeApplication():NativeApplication {
			if (_nativeApplication == null) {
				_nativeApplication = NativeApplication.nativeApplication;
				_nativeApplication.addEventListener(Event.EXITING, exitIng)
				_nativeApplication.addEventListener(Event.DEACTIVATE, appDeactivate)
				_nativeApplication.addEventListener(Event.NETWORK_CHANGE,netWork)
			}
			return _nativeApplication
		}
		/**
		 * 当新的网络连接变为可用或现有网络连接中断时调度。 
		 * @param	e
		 */
		private function netWork(e:Event):void 
		{
			dispatchEvent(e)
		}
		/**
		 * 将桌面焦点切换到不同的应用程序时调度。
		 * @param	e
		 */
		private function appDeactivate(e:Event):void 
		{
			dispatchEvent(e)
		}
		/**
		 * 程序关闭前
		 * @param	e
		 */
		private function exitIng(e:Event):void 
		{
			dispatchEvent(e)
		}
	}

}