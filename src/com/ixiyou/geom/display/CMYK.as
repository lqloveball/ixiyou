package com.ixiyou.geom.display
{
	
	/**
	 * CMYK颜色
	*/
	import com.ixiyou.utils.display.ColorUtil
	public class CMYK 
	{
		/**
		 *Cyan 0-100
		*/
		public var c:Number = 0;
		
		/**
		 *Magenta 0-100
		*/
		public var m:Number = 0;
		
		/**
		 * Yellow 0-100
		*/
		public var y:Number = 0;
		/**
		 * blacK 0-100
		*/
		public var k:Number = 0;
		
		public function CMYK(c : Number = 0 , m : Number = 0 , y : Number = 0,k:Number=0):void
		{
			this.c = c;
			this.m = m;
			this.y = y;
			this.k = k
		}
		public function CMY2RGB():uint {
			return ColorUtil.CMY2RGB(this)
		}
		public function CMYK2RBG():uint {
			var R:uint   =   (255   -   c)   *   ((255   -   k)   /   255)     
			var G:uint   =   (255   -   m)   *   ((255   -   k)   /   255)     
			var B:uint   =   (255   -   y)   *   ((255   -   k)   /   255) 
			var rgb:uint=ColorUtil.RGBtoColor(R,G,B)
			return rgb
		}
		public function toString():String{
			return [c,m,y,k].toString();
		}
	}
	
}