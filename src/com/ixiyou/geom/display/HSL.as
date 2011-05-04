package com.ixiyou.geom.display
{
	
	/**
	 * HSL颜色
	 * HSB色彩模式,把颜色分为色相、饱和度、明度三个因素。
	 * 色调(H)、饱和度(S)、亮度(L)
	 * H: hue,色调，
	 * S：saturation 饱和度
	 * L lum 亮度
	 * 概述
	 * HSL色彩模式是工业界的一种颜色标准，是通过对色调(H)、饱和度(S)、亮度(L)三个颜色通道的变化以及它们相互之间的叠加来得到各式各样的颜色的，HSL即是代表色调，饱和度，亮度三个通道的颜色，这个标准几乎包括了人类视力所能感知的所有颜色，是目前运用最广的颜色系统之一。 
	 * HSL色彩模式使用HSL模型为图像中每一个像素的HSL分量分配一个0~255范围内的强度值。HSL图像只使用三种通道，就可以使它们按照不同的比例混合，在屏幕上重现16777216种颜色。
	 * 在 HSL 模式下，每种 HSL 成分都可使用从 0到 255的值。（其中L是从黑（0）到白（255）渐变）
	 * Windows自带画图程序中菜单栏->颜色->编辑颜色->规定自定义颜色 中可以通过修改E(H)SL的值（0～240）以得到对应RGU(B)的值。
	 * http://baike.baidu.com/view/1508629.htm
	 * @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import com.ixiyou.utils.display.ColorUtil
	public class HSL 
	{
		/**
		* HUE (0-360)
		*/		
		public var h:Number = 0;
		/**
		* SATURATION (0-1)
		*/		
		public var s:Number = 0;
		/**
		* lum (0-1)
		*/		
		private var _l:Number = 0;
		
		public function HSL(h : Number = 0 , s : Number = 0 , l : Number = .5):void
		{
			this.h = h;
			this.s = s;
			this.l = l;
		}
		
		public  function set l(_l:Number):void {
			
			if (_l < -1) _l = -1
			if(_l>1)_l=1
			this._l=_l;
		}
		public  function  get l():Number{return _l}
		public function toRGB():uint {
			return ColorUtil.HSL2RGB(this)
		}
		public function toString():String{
			return [h,s,l].toString();
		}
		
	}
	
}