package com.ixiyou.speUI.containers 
{
	
	/**
	 * 实现之添加一个现实对象的容器
	 * @author 
	 */
	import flash.display.DisplayObject
	public class OneBox  extends Canvas
	{
		
		public function OneBox(config:*=null) 
		{
			super(config)
			
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