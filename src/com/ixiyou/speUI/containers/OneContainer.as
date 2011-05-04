package com.ixiyou.speUI.containers 
{
	
	/**
	 * 只能显示最后一个加载对象的容器
	 * @author dd
	 */
	import flash.display.DisplayObject
	import com.ixiyou.speUI.core.Container
	public class OneContainer extends Container
	{
		
		public function OneContainer(config:*=null) 
		{
			super(config)
		}
		public function get child():DisplayObject {
			if (numChildren>0) return getChildAt(0)
			else return null
		}
		/**重写添加显示对象到层方法
		 * 实现只能加载一个显示对象
		 * */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			if (numChildren > 0) {
				var num:uint=this.numChildren 
				for ( var i:int = 0; i < num; i++) {
					if(getChildAt(0))this.removeChild(getChildAt(0))
				}
			}
			return super.addChildAt(child,0)
		}
	}
	
}