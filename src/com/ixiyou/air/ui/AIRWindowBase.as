package com.ixiyou.air.ui 
{
	import com.ixiyou.air.managers.AIRWindowsLister;
	import com.ixiyou.air.utils.WindowsUtil
	import flash.display.*;
	import flash.events.*
	import flash.geom.*;
	import flash.text.*;
	import flash.desktop.*
	/**
	 * 基础窗口
	 * @author spe email:md9yue@@q.com
	 */
	public class AIRWindowBase extends Sprite 
	{
		/**
		 * window大小区域
		 */
		protected var windowRect:Rectangle = new Rectangle()
		/**
		 * 是否设置过 window
		 */
		protected var setWindowBool:Boolean=false
		public function AIRWindowBase() 
		{
			if (stage) init()
			else addEventListener(Event.ADDED_TO_STAGE,init)
		}
		/**
		 * 窗口管理器
		 */
		public function get windowLister():AIRWindowsLister {
			return AIRWindowsLister.instance
		}
		/**
		 * 设置窗口
		 */
		public function setWindow(value:NativeWindow):Boolean 
		{
			//trace('setWindow')
			//窗口对象只被加载一次
			//if (window) return false
			if(setWindowBool)return false
			if (value&&!value.stage.contains(this)) {value.stage.addChild(this)}
			AIRWindowsLister.instance.addWindow(window)
			addEvent(window)
			upWindowSize()
			setWindowBool=true
			return true
		}
		/**
		 * 初始化
		 * @param	e
		 */
		protected function init(e:Event=null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//trace('初始化添加进场景')
			stage.addEventListener(Event.RESIZE,stageReSize)
			if(window)setWindow(window)
		}
		
		
		/**
		 * 桌面窗口对象
		 */
		public function get window():NativeWindow { return stage.nativeWindow; }
		/**
		 * AIR 应用程序
		 */
		public function get nativeApplication():NativeApplication { return NativeApplication.nativeApplication }
		/**
		 * 自毁
		 */
		public function destory():void {
			if(window)removeEvent(window)
		}
		/**
		 * 显示窗口
		 */
		public function showWindow():void {
			if (window) {
				WindowsUtil.show(window)
			}
		}
		/**
		 * 隐藏窗口
		 */
		public function hitWindow():void {
			if (window) {
				WindowsUtil.hit(window)
			}
		}
		/**
		 * 关闭窗口
		 */
		public function closeWindow():void {
			window.close()
		}
		/**
		 * 关闭程序
		 */
		public function closeApp():void {
			nativeApplication.exit()
		}
		/**
		 * 更新窗口大小 场景变化时候
		 * @param	e
		 */
		protected function stageReSize(e:Event):void 
		{
			if (window.displayState == NativeWindowDisplayState.MAXIMIZED) {
					/**
					 * 对最大化这样类似的按钮操作
					 */
					//是否系统镶边
					if (window.systemChrome == NativeWindowSystemChrome.NONE) {
						//这是实际显示区域
						windowRect=new Rectangle(5,5,stage.stageWidth - 10, stage.stageHeight - 10)
					}
					else {
						//这是实际显示区域
						windowRect=new Rectangle(0,0,stage.stageWidth, stage.stageHeight)
					}
					upSize()
			}
		}
		/**
		 * 更新窗口大小
		 */
		public function upWindowSize():void {
			//trace('upWindowSize', window.systemChrome, window.displayState, stage.stageWidth, stage.stageHeight)
			if (window) {
				//var rect:Rectangle
				if (window.displayState == NativeWindowDisplayState.MAXIMIZED) {
					//最大化  发现最大化会 因为stage 区域晚执行，所有采用stage区域来监听
					/*
					//是否系统镶边
					if (window.systemChrome == NativeWindowSystemChrome.NONE) {
						//这是实际显示区域
						windowRect=new Rectangle(5,5,stage.stageWidth - 10, stage.stageHeight - 10)
					}
					else {
						//这是实际显示区域
						windowRect=new Rectangle(0,0,stage.stageWidth, stage.stageHeight)
					}
					*/
				}
				else if (window.displayState == NativeWindowDisplayState.NORMAL) {
					//正常状态normal
					/**
					 * 对最大化这样类似的按钮操作
					 */
					windowRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight)
					upSize()
				}
				else {
					//最小化
					/**
					 * 对最大化这样类似的按钮操作
					 */
					windowRect = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight)
					upSize()
				}
				
			}
		}
		/**
		 * 更新程序界面大小
		 */
		public function upSize():void
		{
			//window.displayState == NativeWindowDisplayState.MAXIMIZED
			//window.systemChrome == NativeWindowSystemChrome.NONE
			//window.displayState == NativeWindowDisplayState.NORMAL
			//window.displayState == NativeWindowDisplayState.MINIMIZED
			this.x = windowRect.x
			this.y=windowRect.y
		}
		
		
		
		
		/**
		 * 添加事件
		 * @param	value
		 */
		protected function addEvent(value:NativeWindow):void {
			//trace('addEvent')
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
		protected function removeEvent(value:NativeWindow):void {
			
			value.removeEventListener(Event.CLOSE, closeEvent)
			value.removeEventListener(Event.CLOSING, closeIng)
			value.removeEventListener(Event.ACTIVATE, activate)
			value.removeEventListener(Event.DEACTIVATE, deaCtivate)
			value.removeEventListener(NativeWindowBoundsEvent.MOVE, windowMove)
			value.removeEventListener(NativeWindowBoundsEvent.MOVING, windowMoveIng)
			value.removeEventListener(NativeWindowBoundsEvent.RESIZE, reSize)
			value.removeEventListener(NativeWindowBoundsEvent.RESIZING,reSizeIng)
		}
		//------------------------与窗口操作相关的一些方法---------------------------------------//
		/**
		 * 窗口大小改变中
		 * @param	e
		 */
		protected function reSizeIng(e:NativeWindowBoundsEvent):void 
		{
			//trace('reSizeIng',e.afterBounds,e.beforeBounds,stage.stageWidth,stage.stageHeight)
		}
		/**
		 * 窗口大小改变
		 * @param	e
		 */
		protected function reSize(e:NativeWindowBoundsEvent):void 
		{
			//trace('reSize', e.afterBounds, e.beforeBounds, stage.stageWidth, stage.stageHeight)
			//stage.width = e.beforeBounds.width
			//stage.height=e.beforeBounds.height
			upWindowSize()
		}
		/**
		 * 窗口移动中
		 * afterBounds 未处理的窗口的新范围。 
		 * beforeBounds 未处理的窗口的旧范围。 
		 * @param	e
		 */
		protected function windowMoveIng(e:NativeWindowBoundsEvent):void 
		{
			
		}
		/**
		 * 窗口移动
		 * afterBounds 窗口的新范围。 
		 * beforeBounds 窗口的旧范围。 
		 * @param	e
		 */
		protected function windowMove(e:NativeWindowBoundsEvent):void 
		{
			
		}
		/**
		 * 激活
		 * @param	e
		 */
		protected function activate(e:Event):void {
			//trace('激活')
		}
		/**
		 * 在取消激活窗口后由此 NativeWindow 对象调度。
		 * @param	e
		 */
		protected function deaCtivate(e:Event):void 
		{
			
		}
		/**
		 * 窗口关闭中
		 * @param	e
		 */
		protected function closeIng(e:Event):void 
		{
			var win:NativeWindow = e.target as NativeWindow
			//如果要终止关闭请用e.preventDefault()，比如询问是否关闭
			//e.preventDefault()
			
		}
		/**
		 * 关闭窗口事件 
		 * @param	e
		 */
		protected function closeEvent(e:Event):void 
		{		
			destory()
		}
		//------------------------与窗口操作相关的一些方法 end---------------------------------------//
	}

}