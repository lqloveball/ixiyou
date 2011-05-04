package com.ixiyou.speUI.util 
{
	import flash.display.*
	/**
	 * 帮助快速创建界面的辅助类
	 * @author spe
	 */
	public class UIBuilder
	{
		
		/**
		 * 快速 设置原型坐标和添加
		 * @param	UI 创建的UI对象
		 * @param	prototype 原型
		 */
		public static function setPrototype(UI:DisplayObjectContainer, prototype:DisplayObject):DisplayObject {
			UI.addChild(prototype)
			UI.x = prototype.x
			UI.y = prototype.y
			prototype.x = prototype.y = 0;
			return prototype
		}
		
	}

}