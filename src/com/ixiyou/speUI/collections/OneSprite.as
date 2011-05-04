package com.ixiyou.speUI.collections 
{
	
	
	/**
	 * 只能加载一个子对象的器器
	 * @author spe
	 */
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	public class OneSprite extends Sprite
	{
		/**
		 * 构造函数
		 */
		public function OneSprite() {}
		/**重写添加显示对象方法*/
		override public function addChild(child:DisplayObject):DisplayObject {return addChildAt(child,0);}
		/**重写添加显示对象到层方法
		 * 实现只能加载一个显示对象
		 * */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			while(numChildren > 0)removeChildAt(0)
			return super.addChildAt(child,0)
		}
	}

}