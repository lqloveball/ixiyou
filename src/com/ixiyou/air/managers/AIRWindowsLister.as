package com.ixiyou.air.managers 
{
	import com.ixiyou.air.utils.WindowsUtil
	import flash.display.*
	import flash.desktop.*;
	import flash.events.*;
	import flash.geom.*
	import flash.utils.*;
	import com.ixiyou.events.*;
	/**
	 * 窗口列表管理
	 * @author spe email:md9yue@@q.com
	 */
	public class AIRWindowsLister 
	{
		
		
		private static var _instance : AIRWindowsLister
		static public function get instance():AIRWindowsLister
		{
			if (_instance == null) _instance=new AIRWindowsLister()
			return _instance
		
		}
		/**
		 * 窗口列表
		 */
		protected var list:Array 
		/**
		 * 窗口字典
		 */
		protected var dic:Dictionary 
		/**
		 * list窗口列表全部关闭是否退出
		 */
		public var autoExit:Boolean = false
		public var exitIngFun:Function=null
		public function AIRWindowsLister() 
		{
			list = new Array()
			dic = new Dictionary()
			nativeApplication.addEventListener(Event.EXITING, exitIng)
	
		}
		public function get lenght():uint{return list.length}
		/**
		 * 关闭程序
		 */
		public function exit():void {
			nativeApplication.exit()
		}
		/**
		 *  程序在关闭前的操作 比如做所有数据保存
		 * @param	e
		 */
		private function exitIng(e:Event):void 
		{
			if (exitIngFun != null) {
				e.preventDefault()
				exitIngFun()
			}
		}
		/**
		 * 添加窗口
		 * @param	value
		 */
		public function addWindow(value:NativeWindow):void {
			if (!dic[value]) {
				dic[value] = value
				addEvent(value)
				if (list.indexOf(value) == -1) {
					list.push(value)
				}
			}
		}
		/**
		 * 删除窗口
		 * @param	value
		 */
		public function removeWindow(value:NativeWindow):void {
			removeEvent(value)
			if (list.indexOf(value) != -1) {
					list.splice(list.indexOf(value),1)
			}
			//当列表中窗口都消失了就执行整个程序退出
			if (list.length <= 0&&autoExit) {
				nativeApplication.exit()
			}
		}
		/**
		 * 添加事件
		 * @param	value
		 */
		private function addEvent(value:NativeWindow):void {
			value.addEventListener(Event.CLOSE, closeEvent)
		}
		/**
		 * 删除事件
		 * @param	value
		 */
		private function removeEvent(value:NativeWindow):void {
			value.removeEventListener(Event.CLOSE, closeEvent)
		}
		 /*
		  * 关闭窗口事件
		 * @param	e
		 */
		private function closeEvent(e:Event):void 
		{
			var win:NativeWindow = e.target as NativeWindow
			removeWindow(win)
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
		 * 包含此应用程序的所有已打开的本机窗口的数组。
		 */
		public function get openedWindows():Array { return nativeApplication.openedWindows; }
		/**
		 * Air程序
		 */
		public function get nativeApplication():NativeApplication{return NativeApplication.nativeApplication}
		
	}

}