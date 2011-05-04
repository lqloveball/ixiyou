package com.ixiyou.utils.display
{
	
	/**
	* 绘制方法
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import flash.display.Graphics
	import flash.geom.Matrix
	import com.ixiyou.utils.math.ArcMath
	import flash.geom.Point;
	public class DrawUtil 
	{
		/**
		 * 绘制矩形
		 * @param	graphics
		 * @param	color
		 * @param	alpha
		 * @param	x
		 * @param	y
		 * @param	width
		 * @param	height
		 */
		public static function drawRect_beginFill(graphics:Graphics,color:uint=0x0,alpha:Number=1,x:Number=0, y:Number=0, 
							  width:Number=100, height:Number=100):void 
		{
			graphics.beginFill(color, alpha)
			graphics.drawRect(x,y,width,height)
		}
		/*
		* 绘制圆角矩形
		*
		*/
		public static function drawRoundRectComplex(graphics:Graphics, x:Number, y:Number, 
							  width:Number, height:Number, 
                              topLeftRadius:Number, topRightRadius:Number, 
                              bottomLeftRadius:Number, bottomRightRadius:Number):void
		{
			var xw:Number = x + width;
			var yh:Number = y + height;

			// Make sure none of the radius values are greater than w/h.
			// These are all inlined to avoid function calling overhead
			var minSize:Number = width < height ? width * 2 : height * 2;
			topLeftRadius = topLeftRadius < minSize ? topLeftRadius : minSize;
			topRightRadius = topRightRadius < minSize ? topRightRadius : minSize;
			bottomLeftRadius = bottomLeftRadius < minSize ? bottomLeftRadius : minSize;
			bottomRightRadius = bottomRightRadius < minSize ? bottomRightRadius : minSize;
			
			// Math.sin and Math,tan values for optimal performance.
			// Math.rad = Math.PI / 180 = 0.0174532925199433
			// r * Math.sin(45 * Math.rad) =  (r * 0.707106781186547);
			// r * Math.tan(22.5 * Math.rad) = (r * 0.414213562373095);
			//
			// We can save further cycles by precalculating
			// 1.0 - 0.707106781186547 = 0.292893218813453 and
			// 1.0 - 0.414213562373095 = 0.585786437626905

			// bottom-right corner
			var a:Number = bottomRightRadius * 0.292893218813453;		// radius - anchor pt;
			var s:Number = bottomRightRadius * 0.585786437626905; 	// radius - control pt;
			graphics.moveTo(xw, yh - bottomRightRadius);
			graphics.curveTo(xw, yh - s, xw - a, yh - a);
			graphics.curveTo(xw - s, yh, xw - bottomRightRadius, yh);

			// bottom-left corner
			a = bottomLeftRadius * 0.292893218813453;
			s = bottomLeftRadius * 0.585786437626905;
			graphics.lineTo(x + bottomLeftRadius, yh);
			graphics.curveTo(x + s, yh, x + a, yh - a);
			graphics.curveTo(x, yh - s, x, yh - bottomLeftRadius);

			// top-left corner
			a = topLeftRadius * 0.292893218813453;
			s = topLeftRadius * 0.585786437626905;
			graphics.lineTo(x, y + topLeftRadius);
			graphics.curveTo(x, y + s, x + a, y + a);
			graphics.curveTo(x + s, y, x + topLeftRadius, y);

			// top-right corner
			a = topRightRadius * 0.292893218813453;
			s = topRightRadius * 0.585786437626905;
			graphics.lineTo(xw - topRightRadius, y);
			graphics.curveTo(xw - s, y, xw - a, y + a);
			graphics.curveTo(xw, y + s, xw, y + topRightRadius);
			graphics.lineTo(xw, yh - bottomRightRadius);
		}
		/**
		 * 绘制一个圆环.
		 * @see #drawRoundRect()
		 * @see #fillRoundRect()
		 * @param radius top left radius, if other corner radius if undefined, will be set to this radius
		 */
		static public function roundRect(graphics:Graphics,x:Number,y:Number,width:Number,height:Number, radius:Number, trR:Number = NaN, blR:Number = NaN, brR:Number = NaN):void{
			var tlR:Number = radius;
			if(isNaN(trR)) trR = radius;
			if(isNaN(blR)) blR = radius;
			if(isNaN(brR)) brR = radius;
			//Bottom right
			graphics.moveTo(x+blR, y+height);
			graphics.lineTo(x+width-brR, y+height);
			graphics.curveTo(x+width, y+height, x+width, y+height-brR);
			//Top right
			graphics.lineTo (x+width, y+trR);
			graphics.curveTo(x+width, y, x+width-trR, y);
			//Top left
			graphics.lineTo (x+tlR, y);
			graphics.curveTo(x, y, x, y+tlR);
			//Bottom left
			graphics.lineTo (x, y+height-blR );
			graphics.curveTo(x, y+height, x+blR, y+height);
		}
	
		/**
		 * 绘制一个多边型.
		 * @param g A graphics object.
		 * @param points The polygon points.
		 * 
		 */	
		static public function drawPolygon(g:Graphics,points:Array):void{
			g.moveTo(points[0].x, points[0].y);
			for(var i:Number=1; i<points.length; i++){
				g.lineTo(points[i].x, points[i].y);
			}
			g.lineTo(points[0].x, points[0].y);
		}
		/**
		 * 绘制一个具有填充的 环状矩形
		 * @param graphics graphics对象
		 * @param x 外环的x位置
		 * @param y 外环的y位置
		 * @param w1 外环的宽
		 * @param h1 外环的高
		 * @param w2 内环的宽
		 * @param h2 内环的高
		 * 
		 */	
		public static function drawRectangleRing(graphics:Graphics,x:Number, y:Number, w1:Number, h1:Number, w2:Number, h2:Number):void{
			graphics.drawRect(x, y, w1, h1);
			graphics.drawRect(x+(w1-w2)/2, y+(h1-h2)/2, w2, h2);
		}
		/**
		 * 渐变矩形
		 * @param Gra 绘制对象
		 * @param color1 第一颜色
		 * @param color2 第2颜色
		 * @param alpha1 透明度1
		 * @param alpha2 透明度2
		 * @param rotation 角度 百分比×180度
		 * @param wei1
		 * @param wei2
		 * @return 
		*/
		static public function gradientRect(Gra:Graphics,width:Number,height:Number,color1:uint=0x0,color2:uint=0xffffff,alpha1:Number=1,alpha2:Number=1,rotation:Number=0,wei1:int=0,wei2:int=0):void {
			var mtr:Matrix = new Matrix()
			//var line:Number =Point.distance(new Point(),new Point(width, height))
			//
			mtr.createGradientBox(width,height,rotation * Math.PI / 180); 
			Gra.beginGradientFill("linear",[color1,color2],[alpha1,alpha2],[wei1,wei2],mtr)
			Gra.drawRect(0,0,width,height); 
		}
		/*设置渐变色
		*
		*/
		static public function gradientFill(Gra:Graphics, color1:uint = 0x0, color2:uint = 0xffffff, alpha1:Number = 1, alpha2:Number = 1, rotation:Number = 0, wei1:int = 0, wei2:int = 255):void {
			var mtr:Matrix = new Matrix()
			mtr.createGradientBox(100,100,rotation); 
			Gra.beginGradientFill("linear",[color1,color2],[alpha1,alpha2],[wei1,wei2],mtr)
		}
		/**绘制饼状图
		 * @param g 绘制对象
		 * @param _x
		 * @param _y
		 * @param _a x方向轴
		 * @param _b y方向轴
		 * @param minR 开始角度
		 * @param maxR 结束角度
		 * @param color 颜色
		 * @param _alpha 透明度
		 * @return 
		*/
		static public function Pie(g:Graphics,_x:Number=50,_y:Number=50,_a:Number=50,_b:Number=0,minR:Number=0,maxR:Number=360,color:uint=0xff00ff,_alpha:Number=1):void  {
			var step:uint=1;
			g.beginFill(color,_alpha); 
			g.moveTo(_x,_y); 
			if(_b==0)_b=_a
			while (minR + step < maxR) { 
				g.lineTo(ArcMath.getRPoint(_x,_y ,minR,_a,_b).x,ArcMath.getRPoint(_x,_y,minR,_a,_b).y); 
				minR+= step; 
			}
			g.lineTo(ArcMath.getRPoint(_x,_y ,maxR,_a,_b).x,ArcMath.getRPoint(_x,_y ,maxR,_a,_b).y); 
			g.endFill(); 
		}
	}
	
}