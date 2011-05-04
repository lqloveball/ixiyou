package com.ixiyou.geom.display
{
	
	/**
	* RGB颜色...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class RGB 
	{
		/**
		* HUE (0-360)
		*/		
		public var r:Number = 0;
		/**
		* SATURATION (0-100)
		*/		
		public var g:Number = 0;
		/**
		* BRIGHTNESS (0-100)
		*/		
		public var b:Number = 0;
		
		public function RGB(r : Number = 0 , g : Number = 0 , b : Number = 0):void
		{
			this.r = r;
			this.g = g;
			this.b = b;
		}
		public function toRGB():uint {
			return (r << 16) | (g << 8) | b;
		}
		public function toString():String{
			return [r,g,b].toString();
		}
		
	}
	
}