package com.ixiyou.utils.display
{
	
	/**
	* 对颜色值进行处理的方法
	* @author spe
	*/
	import flash.geom.ColorTransform;
	import com.ixiyou.geom.display.CMYK;
	import com.ixiyou.geom.display.HSB
	import com.ixiyou.geom.display.RGB
	import com.ixiyou.geom.display.HSL
	
	public class ColorUtil 
	{
		/**调节颜色亮度靠-255至255
		 * 
		 * @param color:颜色值
		 * @param  brite:亮度 -255到255
		 * @return 
		*/
		public static function colorBrightness(color:uint, brite:Number):uint{
			var r:Number = Math.max(Math.min(((color >> 16) & 0xFF) + brite, 255), 0);
			var g:Number = Math.max(Math.min(((color >> 8) & 0xFF) + brite, 255), 0);
			var b:Number = Math.max(Math.min((color & 0xFF) + brite, 255), 0);
			
			return (r << 16) | (g << 8) | b;
		}
		/**颜色加深
		 * 
		 * @param Percentage：0到1
		 * @return 
		*/
		public static function colorDeepen(color:uint, Percentage:Number):uint {
			var r:Number;
			var g:Number;
			var b:Number;
			if (Percentage < 1&&Percentage> 0) Percentage = 1 - Percentage
			else if (Percentage >= 1) Percentage = 1.1
			else Percentage = 0
			if (Percentage == 0) {
				
				return color;
			}
			else
			{
				r = ((color >> 16) & 0xFF) * Percentage;
				g = ((color >> 8) & 0xFF) * Percentage;
				b = (color & 0xFF) * Percentage;
			}	
			return (r << 16) | (g << 8) | b;
		}
		/**颜色减淡
		 * 
		 * @param Percentage：0到1
		 * @return 
		*/
		public static function colorDodge(color:uint, Percentage:Number):uint {
			var r:Number;
			var g:Number;
			var b:Number;
			
			if (Percentage < 1&&Percentage > 0) Percentage =1-(1 - Percentage)
			else if (Percentage >= 1) Percentage = 1.1
			else Percentage = 0
			
			if (Percentage == 0) {
				
				return color;
			}
			else
			{
				r = ((color >> 16) & 0xFF);
				g = ((color >> 8) & 0xFF);
				b = (color & 0xFF);
				
				r += ((0xFF - r) * Percentage);
				g += ((0xFF - g) * Percentage);
				b += ((0xFF - b) * Percentage);
				
				r = Math.min(r, 255);
				g = Math.min(g, 255);
				b = Math.min(b, 255);
			}	
			return (r << 16) | (g << 8) | b;
		}
		/** 颜色对比度
		 *
		 * @param percent 对比度 0-100原来颜色到饱和度从0-100  -100到0反色度
		 * @return 
		*/
		public static function colorContrast(color:uint,percent:int):uint{
			var result:ColorTransform = new ColorTransform();
			result.color=color
			result.redMultiplier = result.blueMultiplier = result.greenMultiplier = percent;
			result.redOffset = result.blueOffset = result.greenOffset = 128 - (128/100 * percent);
			return result.color;
		}
		/**两个颜色相乘
		 * 
		 * @param 
		 * @return 
		*/
		public static function rgbMultiply(rgb1:uint, rgb2:uint):uint{
			var r1:Number = (rgb1 >> 16) & 0xFF;
			var g1:Number = (rgb1 >> 8) & 0xFF;
			var b1:Number = rgb1 & 0xFF;
			
			var r2:Number = (rgb2 >> 16) & 0xFF;
			var g2:Number = (rgb2 >> 8) & 0xFF;
			var b2:Number = rgb2 & 0xFF;
			
			return ((r1 * r2 / 255) << 16) |
				   ((g1 * g2 / 255) << 8) |
				    (b1 * b2 / 255);
		} 
		
		/**RGB设置颜色
		 * 
		 * @param r
		 * @param g
		 * @param b
		 * 
		 */		
		public static function RGBtoColor(r:uint, g:uint, b:uint):uint {
			var color:uint= (r << 16) | (g << 8) | b;
			return color 
		}
		/**RGB色
		 * 
		 * @param 
		 * @return 
		*/
		public static function RGB2Color(rgb:RGB):uint {
			return (rgb.r << 16) | (rgb.g << 8) | rgb.b;
		}	
		/**HSB转颜色
		 * 
		 * @param 
		 * @return 
		*/
		public static function HSB2RGB(hsb:HSB):uint{
			var _r:Number = 0;
			var _g:Number = 0;
			var _b:Number = 0;
			
			hsb.s *= 2.55;
			hsb.b *= 2.55;
			if (!hsb.h && !hsb.s) {
				_r = _g = _b = hsb.b;
			} else {
				var diff:Number = (hsb.b*hsb.s)/255;
				var low:Number = hsb.b-diff;
				if (hsb.h>300 || hsb.h<=60) {
					_r = hsb.b;
					if(hsb.h > 300){
						_g = Math.round(low);
						hsb.h = (hsb.h-360)/60;
						_b = -Math.round(hsb.h*diff - low);
					}else{
						_b = Math.round(low);
						hsb.h = hsb.h/60;
						_g = Math.round(hsb.h*diff + low);
					}
				} else if (hsb.h>60 && hsb.h<180) {
					_g = hsb.b;
					if (hsb.h<120) {
						_b = Math.round(low);
						hsb.h = (hsb.h/60-2)*diff;
						_r = Math.round(low-hsb.h);
					} else {
						_r = Math.round(low);
						hsb.h = (hsb.h/60-2)*diff;
						_b = Math.round(low+hsb.h);
					}
				} else {
					_b = hsb.b;
					if (hsb.h<240) {
						_r = Math.round(low);
						hsb.h = (hsb.h/60-4)*diff;
						_g = Math.round(low-hsb.h);
					} else {
						_g = Math.round(low);
						hsb.h = (hsb.h/60-4)*diff;
						_r = Math.round(low+hsb.h);
					}
				}
			}
			var color:uint = RGBtoColor(_r, _g, _b);
			return color
		}
		/**HSL转颜色
		 * 
		 * @param 
		 * @return 
		*/
		public static function HSL2RGB(hsl:HSL):uint {
			/*
			var color:uint = new HSB(hsl.h, hsl.s, 100).toRGB()
			color=colorBrightness(color,hsl.l*255)
			return color
			*/
			var H:Number=hsl.h
			var	S:Number=hsl.s
			var L:Number=hsl.l
			var p1:Number, p2:Number;
			var rgb:RGB = new RGB();
			if (L<=0.5) {
				p2 = L*(1+S);
			} else {
				p2 = L+S-(L*S);
			}
			p1 = 2*L-p2;
			if (S == 0) {
				rgb.r = L;
				rgb.g = L;
				rgb.b = L;
			} else {
				rgb.r = CalculationHSL(p1, p2, H+120);
				rgb.g = CalculationHSL(p1, p2, H);
				rgb.b = CalculationHSL(p1, p2, H-120);
			}
			rgb.r *= 255;
			rgb.g *= 255;
			rgb.b *= 255;
			return rgb.toRGB();
		}
		/**HSL计算过程
		 * 
		 * @param 
		 * @return 
		*/
		public static function CalculationHSL(q1:Number, q2:Number, hue:Number):Number {
			if (hue>360) {
				hue = hue-360;
			}
			if (hue<0) {
				hue = hue+360;
			}
			if (hue<60) {
				return (q1+(q2-q1)*hue/60);
			} else if (hue<180) {
				return (q2);
			} else if (hue<240) {
				return (q1+(q2-q1)*(240-hue)/60);
			} else {
				return (q1);
			}
		}
		/**CMY颜色转颜色
		 * 
		 * @param 
		 * @return 
		*/
		public static function CMY2RGB(cmyk:CMYK):uint {
			var k:uint
			k = 1-cmyk.k/100;
			var color:uint = RGBtoColor((255 - cmyk.c * 2.55) * k, (255 - cmyk.m * 2.55) * k, (255 - cmyk.y * 2.55) * k);
			return color
		}
		/**
		 * 颜色转RGB
		 * @param	color
		 * @return
		 */
		public static function Color2RGB(color:uint):RGB {
			var r:Number = (color >> 16) & 0xFF;
			var g:Number = (color >> 8) & 0xFF;
			var b:Number = color & 0xFF;
			var rgb:RGB=new RGB(r,g,b)
			return rgb
		}
		/**颜色转HSL
		 * 
		 * @param 
		 * @return 
		*/
		public static function RGB2HSL(color:uint):HSL {
			var rgb:RGB = Color2RGB(color)
			var R:Number=rgb.r
			var G:Number=rgb.g
			var B:Number=rgb.b
			R /= 255;
			G /= 255;
			B /= 255;
			var max:Number, min:Number, diff:Number, r_dist:Number, g_dist:Number, b_dist:Number;
			var hsl:HSL = new HSL();
			max = Math.max(Math.max(R, G), B);
			min = Math.min(Math.min(R, G), B);
			diff = max-min;
			hsl.l = (max+min)/2;
			if (diff == 0) {
				hsl.h = 0;
				hsl.s = 0;
			} else {
				if (hsl.l<0.5) {
				hsl.s = diff/(max+min);
			} else {
				hsl.s = diff/(2-max-min);
			}
			r_dist = (max-R)/diff;
			g_dist = (max-G)/diff;
			b_dist = (max-B)/diff;
			if (R == max) {
				hsl.h = b_dist-g_dist;
			} else if (G == max) {
				hsl.h = 2+r_dist-b_dist;
			} else if (B == max) {
				hsl.h = 4+g_dist-r_dist;
				}
			hsl.h *= 60;
			if (hsl.h<0) {
				hsl.h += 360;
				}
			if (hsl.h>=360) {
				hsl.h -= 360;
				}
			}
			return hsl;
		}
		/**
		 * 颜色转CMY
		 * @param 
		 * @return 
		*/
		public static function RGB2CMY(color:uint):CMYK {
			var rgb:uint = color;
			var _r:Number = (rgb >> 16) & 0xFF;
			var _g:Number = (rgb >> 8) & 0xFF;
			var _b:Number = (rgb) & 0xFF;
			
			var ratio:Number = 100/255;
			
			var cmy:CMYK = new CMYK();
			cmy.c = Math.round(100-_r*ratio);
			cmy.m = Math.round(100-_g*ratio);
			cmy.y = Math.round(100 - _b * ratio);
			return cmy;
		}
		/** 
		 *颜色转HSB颜色
		 * @param 
		 * @return 
		*/
		public static function RGB2HSB(color:uint):HSB{
			var rgb:uint = color;
			var _r:Number = (rgb >> 16) & 0xFF;
			var _g:Number = (rgb >> 8) & 0xFF;
			var _b:Number = (rgb) & 0xFF;
			
			var hsb:HSB = new HSB();
			var low:Number = Math.min(_r, Math.min(_g, _b));
			var high:Number = Math.max(_r, Math.max(_g, _b));
			hsb.b = high*100/255;
			var diff:Number = high-low;
			if (diff) {
				hsb.s = Math.round(100*(diff/high));
				if (_r == high) {
					hsb.h = Math.round(((_g-_b)/diff)*60);
				} else if (_g == high) {
					hsb.h = Math.round((2+(_b-_r)/diff)*60);
				} else {
					hsb.h = Math.round((4+(_r-_g)/diff)*60);
				}
				if (hsb.h>360) {
					hsb.h -= 360;
				} else if (hsb.h<0) {
					hsb.h += 360;
				}
			} else {
				hsb.h = hsb.s=0;
			}
			return hsb;
		}
		
		/**
		 * 随机颜色
		 * @param 
		 * @return 
		*/
		public static function randomColor():uint {
			var color:uint = uint(Math.random()*0xffffff)
			return color
		}
	}
	
}