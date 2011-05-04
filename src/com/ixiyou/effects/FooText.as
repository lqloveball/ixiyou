package com.ixiyou.effects 
{
	
	/**
	 * 像素转圆点动画
	 * startDraw()
	 * addEventListener(FooText.DRAWEND,dd)
	 * private function dd(e:Event):void {
	 * 	clearDraw()
	 * }
	 * @author spe
	 */
	import flash.display.*; 
	import flash.events.Event;
    import flash.text.*; 
    import flash.filters.*; 
    import flash.geom.*; 
    import caurina.transitions.Tweener;
	import flash.utils.*;
	public class FooText extends Sprite{ 
        private var bd:BitmapData;
		private var tf:TextField
		private var _w:uint 
		private var _time:Number 
		private var _delay:Number
		//绘制结束
		[Event(name="drawEnd", type="flash.events.Event")]
		public static var DRAWEND:String = 'drawEnd';
		//清除结束
		[Event(name="clearEnd", type="flash.events.Event")]
		public static var CLEAREND:String = 'clearEnd';
        public function FooText():void{ 
            tf = new TextField(); 
			tf.autoSize = "left"; 
        } 
		/**
		 * 生成效果
		 * @param	lable 效果文字
		 * @param	w 文字的点
		 * @param	time 时间
		 * @param	delay 延迟出现使用时间
		 * @param	textColor 文本使用颜色
		 */
		public function startDraw(lable:String = 'Hello\nWorld!!!',w:uint = 2, time:Number = 1, delay:Number = 1,textColor:uint=0x0):void {
			tf.textColor = 0x000000; 
			tf.text = lable; 
			_w = w;
			_time = time;
			_delay = delay;
			if (bd) bd.dispose();
			bd = new BitmapData(tf.width, tf.height, false, 0x3399ff); 
            bd.draw(tf); 
			//十分模糊
            bd.applyFilter(bd, bd.rect, new Point(), new BlurFilter()); 
            bd.draw(tf);
            for(var i:int = 0; i < bd.width; i++){ 
                for(var j:int = 0; j < bd.height; j++){ 
                    Tweener.addTween( 
						addChild(randomize(bd.getPixel(i, j))),  
                        { 
                            x: i * (_w), 
                            y: j * (_w), 
                            alpha: 1, 
                            delay: _delay*_time * Math.random(), 
                            time: _time 
                        } 
                    );
                } 
            }
			setTimeout(function():void{dispatchEvent(new Event(FooText.DRAWEND))},_delay*_time*1000+500)
			bd.dispose()
		}
		/**
		 * 清除消失
		 * @param	time
		 * @param	delay
		 */
		public function clearDraw(time:Number=1,delay:Number=1):void {
			_time = time
			_delay=delay
			var num:uint=this.numChildren
			for (var i:int = 0; i < num; i++) 
			{
				Tweener.addTween( 
						getChildAt(i),  
						{ 
							x:_w*tf.width* Math.random() , 
							y:_w*tf.height* Math.random(), 
							alpha: 0, 
							delay:_delay*_time * Math.random(), 
							time: _time,
							onComplete:function():void {
								removeChild(this)
							}
						} 
					);
			}
			setTimeout(function():void{dispatchEvent(new Event(FooText.CLEAREND))},_delay*_time*1000+500)
		}
        private function randomize(color:uint):DisplayObject { 
			var d:Shape = new Shape()
			d.graphics.beginFill(color); 
			d.graphics.drawCircle(0, 0,_w/2); 
			d.graphics.endFill(); 
            d.x = _w*tf.width* Math.random(); 
            d.y = _w*tf.height* Math.random(); 
            d.alpha = 0; 
            return d; 
        } 
    } 
}