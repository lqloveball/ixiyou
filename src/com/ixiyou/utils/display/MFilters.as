package com.ixiyou.utils.display
{
	
	/**滤镜类
	* "Shadow"  阴影滤镜
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import flash.filters.*
	public class MFilters 
	{
		/**灰色
		 * 
		 * @param 
		 * @return 
		*/
		static public function  gray():ColorMatrixFilter {	
			var gray_Matrix:Array=new Array()
			gray_Matrix =	[0.3086, 0.6094, 0.0820, 0, 0,
							0.3086, 0.6094, 0.0820, 0, 0,
							0.3086, 0.6094, 0.0820, 0, 0,
							0    , 0    , 0    , 1, 0];
			var ColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter(gray_Matrix);//亮度
			return ColorMatrix_filter
		}
		/**亮度
		 * 
		 * @param val 取值为-255到255
		 * @return 
		*/
		static public function  brightness(val:Number):ColorMatrixFilter {	
			var Brightness_Matrix:Array=new Array()
			Brightness_Matrix =[1,0,0,0,val,
								0,1,0,0,val,
								0,0,1,0,val,
								0,0,0,1,0];
			var ColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter(Brightness_Matrix);//亮度
			return ColorMatrix_filter
		}
		/**对比度
		 * 
		 * @param val 取值为0到10
		 * @return 
		*/
		static public function  contrast (val:Number):ColorMatrixFilter  {
			var contrast_Matrix:Array=new Array()
			contrast_Matrix = [val, 0, 0, 0, (1-val)*128,
								 0, val, 0, 0, (1-val)*128, 
								 0, 0, val, 0, (1-val)*128,
								 0, 0, 0, 1, 0];
			var contrast_filter:ColorMatrixFilter = new ColorMatrixFilter(contrast_Matrix);//亮度
			return contrast_filter
		}
		/**反相
		 * 
		 * @param 
		 * @return 
		*/
		static public function  oppositionHue():ColorMatrixFilter {	
			var gray_Matrix:Array=new Array()
			gray_Matrix =	[-1,  0,  0, 0, 255,
							0 , -1,  0, 0, 255,
							0 ,  0, -1, 0, 255,
							0 ,  0,  0, 1,   0];
			var ColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter(gray_Matrix);//亮度
			return ColorMatrix_filter
		}
		/**阈值
		 * 
		 * @param val(取值为-255到255)
		 * @return 
		*/
		static public function  limen(val:Number):ColorMatrixFilter {	
			var gray_Matrix:Array=new Array()
			gray_Matrix =	[0.3086*256,0.6094*256,0.0820*256,0,-256*val,
							0.3086*256,0.6094*256,0.0820*256,0,-256*val,
							0.3086*256,0.6094*256,0.0820*256,0,-256*val,
							0, 0, 0, 1, 0];
			var ColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter(gray_Matrix);//亮度
			return ColorMatrix_filter
		}
		/**色彩饱和度
		 * 
		 * @param 取值为0到255
		 * @return 
		*/
		static public function  saturation(val:Number):ColorMatrixFilter {	
			var gray_Matrix:Array=new Array()
			gray_Matrix =	[0.3086*(1-val)+ val, 0.6094*(1-val)    , 0.0820*(1-val)    , 0, 0,
							0.3086*(1-val)   , 0.6094*(1-val) + val, 0.0820*(1-val)    , 0, 0,
							0.3086*(1-val)   , 0.6094*(1-val)    , 0.0820*(1-val) + val, 0, 0,
							0        , 0        , 0        , 1, 0];
			var ColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter(gray_Matrix);//亮度
			return ColorMatrix_filter
		}
		/**色彩通道
		 * 
		 * @param RGB均为0-2，A为0-1
		 * @return 
		*/
		static public function  colorChannels(R:Number,G:Number,B:Number,A:Number):ColorMatrixFilter {	
			var gray_Matrix:Array=new Array()
			gray_Matrix =	[R,0,0,0,0,
							0,G,0,0,0,
							0,0,B,0,0,
							0,0,0,A,0];
			var ColorMatrix_filter:ColorMatrixFilter = new ColorMatrixFilter(gray_Matrix);//亮度
			return ColorMatrix_filter
		}
		
		/**
		 * Stroke (描边)
		 * @param 
		 * @return 
		*/
		static public function Stroke(color:Number = 0x000000, alpha:Number = .1, blurX:Number = 2, blurY:Number = 2, strength:Number = 6,
		inner:Boolean = false, knockout:Boolean = false,
		quality:Number = 3
		):BitmapFilter {
			return new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout);
		}
		/**
		 * 5宽度阴影滤镜
		 * @param	color
		 * @param	alpha
		 * @param	blurX
		 * @param	blurY
		 * @param	strength
		 * @param	inner
		 * @param	knockout
		 * @param	quality
		 * @return
		 */
		static public function getShadowFilter(color:Number = 0x000000,
            alpha:Number = 0.5,
            blurX:Number = 5,
            blurY:Number = 5,
            strength:Number = 2,
            inner:Boolean = false,
            knockout:Boolean = false,
            quality:Number = 3):BitmapFilter {
            return new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout);
        }
		/**模糊滤镜
		* ...
		* @author 
		*/
		static public function getBlurFilter(blurX:uint=5,blurY:uint=5,HIGH:uint=3):BlurFilter {
			return new BlurFilter(blurX,blurY,HIGH);
		}
		
	}
	
}