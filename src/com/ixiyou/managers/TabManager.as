package com.ixiyou.managers 
{
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.Dictionary
	import flash.display.InteractiveObject;
	import flash.events.*;
	import flash.utils.getTimer;
	/**
	 * tab管理器
	 * @author spe email:md9yue@qq.com
	 */
	public class TabManager extends EventDispatcher
	{
		private static var _instance : TabManager;
		/**
		 * TAB管理单例
		 * @return
		 */
		public static function get instance():TabManager {
			if(_instance == null)_instance = new TabManager();
			return _instance;
		}
		private var _stage:Stage
		private var _tabChildren:Boolean = true
		private var _focusRect:Boolean=true
		private var dictionary:Dictionary
		private var queueArr:Array=new Array()
		public function TabManager() { dictionary = new Dictionary() }
		
		/**
		 * 添加
		 * @param	value 焦点对象
		 * @param	num 对象位置
		 */
		public function add(value:InteractiveObject,num:uint):void {
			
		}
		/**
		 * 删除
		 * @param	value 焦点对象
		 */
		public function remove(value:InteractiveObject):void {
			
		}
		/**
		 * 场景
		 */
		public function get stage():Stage { return _stage; }
		
		public function set stage(value:Stage):void 
		{
			_stage = value;
			stage.tabChildren = tabChildren
			stage.stageFocusRect = focusRect

			stage.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			stage.addEventListener(FocusEvent.FOCUS_IN, onFcusIn)
			stage.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChange)

		}
		

		private var keyFocusTime:int
		private function keyFocusChange(e:FocusEvent):void 
		{
			keyFocusTime=getTimer()
			//trace('keyFocusChange',e.target,focus)
		}
		
		private function onFcusIn(e:FocusEvent):void
		{
			//trace('onFcusIn', e.target, focus, getTimer() - keyFocusTime)
			if (getTimer() - keyFocusTime>20)return
			if (customRectBool && focus&&!(focus is TextField)) {
					var p:Point = focus.localToGlobal(new Point())
					showRect.x = p.x
					showRect.y=p.y
					showRect.width = focus.getRect(focus).width
					showRect.height = focus.getRect(focus).height
					draw()
					stage.addChild(customRect)
			}
		}
		
		/**
		 * 移除焦点
		 * @param	e
		 */
		private function onFocusOut(e:FocusEvent):void 
		{
			//trace('onFocusOut',e.target,focus)
			if (!focus||(focus is TextField)) {
				if (stage.contains(customRect)) stage.removeChild(customRect)
				if(customRect.parent)customRect.parent.removeChild(customRect)
			}
			//
		}
		

		/**
		 * 是否开启TAB功能
		 */
		public function get tabChildren():Boolean { return _tabChildren; }
		
		public function set tabChildren(value:Boolean):void 
		{
			_tabChildren = value;
			if(stage)stage.tabChildren=_tabChildren
		}
		/**
		 * 当前键盘焦点对象
		 */
		public function get focus():InteractiveObject {
			if (!stage) return null
			return stage.focus
		}
		/**
		 * 是否出现系统焦点显示框
		 */
		public function get focusRect():Boolean { return _focusRect; }
		
		public function set focusRect(value:Boolean):void 
		{
			_focusRect = value;
			if(stage)stage.stageFocusRect=_focusRect
		}
		private var _customRectBool:Boolean
		/**
		 * 自定义焦点显示框
		 */
		public function get customRectBool():Boolean { return _customRectBool; }
		public function set customRectBool(value:Boolean):void 
		{
			_customRectBool = value;
			if (!customRectBool) {
				if (stage.contains(customRect)) stage.removeChild(customRect)
				if(customRect.parent)customRect.parent.removeChild(customRect)
			}else {
				focusRect=false
			}
		}
		
		private var _customRect:Shape = new Shape()
		/**
		 * 自定义显示框
		 */
		public function get customRect():Shape { return _customRect; }
		private var _customColor:uint=0x0000ff
		private var showRect:Rectangle = new Rectangle()
		private var _lineNum:uint=2
		/**
		 * 设置自定义颜色
		 */
		public function get customColor():uint { return _customColor; }
		
		public function set customColor(value:uint):void 
		{
			_customColor = value;
			draw()
		}
		/**
		 * 线条宽度
		 */
		public function get lineNum():uint { return _lineNum; }
		
		public function set lineNum(value:uint):void 
		{
			_lineNum = value;
			draw()
		}
		
		/**
		 * 进行自定义绘制
		 */
		public function draw():void {
			customRect.graphics.clear()
			customRect.graphics.lineStyle(lineNum, _customColor)
			customRect.graphics.drawRect(showRect.x,showRect.y,showRect.width,showRect.height)
		}
		
		
	}

}