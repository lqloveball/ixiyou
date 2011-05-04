package com.ixiyou.air.utils 
{
	/**
	 * 窗口操作工具
	 * @author spe
	 */
	import flash.display.*
	import flash.geom.Rectangle;
	import com.ixiyou.air.ui.AIRWindowBase
	public class WindowsUtil
	{
		/**
		 * 创建窗口
		 * @param	title 窗口标题
		 * 			bounds 窗口大小
		 * @param	type 指定要创建的窗口的类型
		 * @param	systemChrome 指定是否为窗口提供系统镶边。
		 * @param	transparent 指定窗口是否支持针对桌面的透明度和 Alpha 混合。
		 * @param	resizable 指定窗口是否可调整大小。
		 * @param	maximizable 指定窗口是否可最大化。
		 * @param	minimizable 指定窗口是否可最小化。
		 * @return
		 */
		public static function foundNativeWindow(title:String = 'windows',bounds:Rectangle=null,
			type:String = 'normal', 
			systemChrome:String = 'standard',
			transparent:Boolean =false,
			resizable:Boolean = true,
			maximizable:Boolean=true,minimizable:Boolean=true):NativeWindow {
			var wins:NativeWindowInitOptions = windowType(type, systemChrome, transparent, resizable, maximizable, minimizable)
			var win:NativeWindow = new NativeWindow(wins)
			win.title = title
			if (!bounds)bounds=new Rectangle(0,0,300,300)
			win.bounds=bounds
			return win
		}
		/**
		 * 创建窗口
		 * @param	window
		 * @param	skin
		 * @return
		 */
		public static function foundAIRWindowBase(nativeWindow:NativeWindow,window:AIRWindowBase):AIRWindowBase {
			window.setWindow(nativeWindow)
			return window
		}
		/**
		 * 窗口类型数据 NativeWindowInitOptions
		 * @param	type 指定要创建的窗口的类型
		 * @param	systemChrome 指定是否为窗口提供系统镶边。
		 * @param	transparent 指定窗口是否支持针对桌面的透明度和 Alpha 混合。
		 * @param	resizable 指定窗口是否可调整大小。
		 * @param	maximizable 指定窗口是否可最大化。
		 * @param	minimizable 指定窗口是否可最小化。
		 * @return 
		 */
		public static function windowType(type:String = 'normal', 
			systemChrome:String = 'standard',
			transparent:Boolean =false,
			resizable:Boolean = true,
			maximizable:Boolean=true,minimizable:Boolean=true):NativeWindowInitOptions {
			var wins:NativeWindowInitOptions = new NativeWindowInitOptions()
			wins.maximizable = maximizable
			wins.minimizable = minimizable
			wins.resizable = resizable
			if (systemChrome == NativeWindowSystemChrome.STANDARD || NativeWindowSystemChrome.NONE) wins.systemChrome = systemChrome
			else wins.systemChrome = NativeWindowSystemChrome.STANDARD
			
			if (wins.systemChrome == NativeWindowSystemChrome.NONE) wins.transparent = transparent
			else wins.transparent = false
			
			if (type == NativeWindowType.NORMAL || type == NativeWindowType.UTILITY || type == NativeWindowType.LIGHTWEIGHT) wins.type = type
			else wins.type = NativeWindowType.NORMAL
			return wins
		}
		/**
		 * 打开 激活过但被关闭了，会返回false
		 * @param	value 
		 */
		public static function show(value:NativeWindow):Boolean {
			if (!value.active) value.activate()
			if (value.closed) return false
			return true
		}
		
		/**
		 * 关闭(隐藏) 还未被激活或者被关闭了都会返回 false
		 * @param	value
		 */
		public static function hit(value:NativeWindow):Boolean {
			if (value.closed||!value.active) return false
			if(value.visible)value.visible = false
			return true
		}
		/**
		 * 是否窗口被激活过被被关闭的 false:还未激活过就关闭的
		 * @param	value
		 * @return 
		 */
		public static function isClose(value:NativeWindow):Boolean {
			if (value.closed == true && value.active == true) return true
			else return false
		}
		/**
		 * 如果此窗口成功地放到了后面，则为 true；如果此窗口不可见或最小化，则为 false。  
		 * @param	value
		 */
		public static function windowBack(value:NativeWindow):Boolean {
			return value.orderToBack()
		}
		/**
		 * 如果此窗口成功地放到了前面，则为 true；如果此窗口不可见或最小化，则为 false。  
		 * @param	value
		 */
		public static function windowTop(value:NativeWindow):Boolean {
			return value.orderToFront()
		}
		/**
		 * 置后
		 * @param	value1
		 * @param	value2
		 * @return
		 */
		public static function windowBackOf(value1:NativeWindow, value2:NativeWindow):Boolean {
			return value1.orderInBackOf(value2)
		}
		/**
		 * 置前
		 * @param	value1
		 * @param	value2
		 * @return
		 */
		public static function windowTopOf(value1:NativeWindow, value2:NativeWindow):Boolean {
			return value1.orderInFrontOf(value2)
		}
	}

}