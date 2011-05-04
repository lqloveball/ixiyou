package com.ixiyou.geom.display
{
	
	/**
	 * HSB颜色
	 * HSB色彩模式,把颜色分为色相、饱和度、明度三个因素。
	 * HSB(Hue色相、Saturation饱和度、Brightness明度)
	 * 在HSB模式中，H(hues)表示色相，S(saturation)表示饱和度，B（brightness）表示亮度。 
	 * 色相：是纯色，即组成可见光谱的单色。红色在0度，绿色在120度，蓝色在240度。它基本上是RGB模式全色度的饼状图。 
	 * 饱和度：表示色彩的纯度，为0时为会色。白、黑和其他灰色色彩都没有饱和度的。在最大饱和度时，每一色相具有最纯的色光。 亮度：是色彩的明亮读。为0时即为黑色。最大亮度是色彩最鲜明的状态。
	 * http://baike.baidu.com/view/587127.htm
	 * @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import com.ixiyou.utils.display.ColorUtil
	public class HSB 
	{
		/**
		* HUE (0-360)
		*/		
		public var h:Number = 0;
		/**
		* SATURATION (0-100)
		*/		
		public var s:Number = 0;
		/**
		* BRIGHTNESS (0-100)
		*/		
		public var b:Number = 0;
		
		public function HSB(h : Number = 0 , s : Number = 0 , b : Number = 0):void
		{
			this.h = h;
			this.s = s;
			this.b = b;
		}
		public function toRGB():uint {
			return ColorUtil.HSB2RGB(this)
		}
		public function toString():String{
			return [h,s,b].toString();
		}
		
	}
	
}