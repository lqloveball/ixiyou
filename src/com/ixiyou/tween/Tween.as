/**
* http://www.roading.net/blog/?tag=tween
* @author roading
* @link http://roading.net
* 
* @param	startProps 开始属性 array类型
* @param	endProps  结束属性 array类型
* @param	timeSeconds  持续时间  秒为单位
* @param	animType	 动作类型 有31种运动效果
* @param	delay		延迟时间 秒为单位
	var t:Tween = new Tween([1,2,3],[4,5,6],2,'liner',1);
	t.addEventListener('tween',tweening);
	function tweening(e:DataSpeEvent):void
	{
	trace(e.data);//e.data也是array类型，在这里，可以给你需要改变的属性赋值
	}
	
*/
package  com.ixiyou.tween
{
	import flash.utils.Dictionary;
	import flash.display.*;
	import flash.utils.*;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.geom.*;
	//
	import com.ixiyou.tween.events.DataSpeEvent;
	public class Tween extends EventDispatcher
	{
		//{-----------------------------------------------------------------------------------------
		//开始属性，tweening属性，结束属性
		protected var _startProps:Array;
		protected var _currentProps:Array;
		protected var _endProps:Array;
		//运行时间
		protected var _timeSeconds:Number;
		//延迟时间
		protected var _delay:Number;
		//动作类型
		protected var _animType:Function;
		//开始时间
		protected var _startTimer:Number;
		//
		protected var timer:Timer;
		//
		public function Tween(startProps:Array, endProps:Array, timeSeconds:Number=2, animType:String="linear", delay:Number=0)
		{
			_timeSeconds = timeSeconds;
			_delay = delay;
			_startTimer = getTimer() + _delay * 1000;
			_animType = TweenType[animType.toLowerCase()];
			_startProps = startProps;
			_endProps = endProps;
			_currentProps = [];
			//
			timer = new Timer(frame);
			timer.addEventListener(TimerEvent.TIMER, tweenHandler);
			timer.start();
			if (_delay) timer.delay = _delay;
		}
		/**
		 * tweening
		 * @param	e
		 */
		protected function tweenHandler(e:TimerEvent):void
		{
			if (getTimer() - _startTimer < 0) return;
			var isEnd:Boolean = false;
			for(var i:* in _startProps)
			{
				_currentProps[i] = _animType(getTimer()-_startTimer,_startProps[i],_endProps[i]-_startProps[i] ,(_timeSeconds * 1000));
				if(_startTimer + (_timeSeconds * 1000) <= getTimer())
				{
					_currentProps[i] = _endProps[i];
					isEnd = true;
				}
			}
			dispatchEvent(new DataSpeEvent('tween', _currentProps));
			dispatchEvent(new Event('tween'));
			if(isEnd)stop();
		}
		/**
		 * stop
		 */
		public function stop(state:int=0):void
		{
			timer.stop();
			//状态的确定，0为停止运动  大于0为到完成状态  小于0为还原状态
			for(var i:* in _startProps)
			{
				if(state>0)
				this._currentProps[i] = this._endProps[i];
				else if(state<0)
				this._currentProps[i] = this._startProps[i];
			}
			//
			dispatchEvent(new DataSpeEvent('complete', _currentProps));
			dispatchEvent(new Event('tweenEnd'));
			dispatchEvent(new Event('complete'));
		}
		//}
		//{----------------static--function---------------------------------------------------------------
		//
		static public var frame:Number = 20;
		/**
		 * 存储当前tween使用的实例集合
		 */
		private static var mcDict:Dictionary = new Dictionary();
		//
		public static function alpha2(mc:*, propDest_a:Number, timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			var _tween:Tween = new Tween([mc.alpha], [propDest_a], timeSeconds, animType, delay);
			_tween.addEventListener('tween', tweenHolderHandler);
			function tweenHolderHandler(e:DataSpeEvent):void
			{
				mc.alpha = e.data[0];
				//trace('alpha tween==',mc.alpha);
			}
			addTween(mc, _tween, 'alpha');
			return _tween;
		};			
		public static function rotate2(mc:*, propDest_rotation:Number, timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			var _tween:Tween = new Tween([mc.rotation], [propDest_rotation], timeSeconds, animType, delay);
			_tween.addEventListener('tween', tweenHolderHandler);
			function tweenHolderHandler(e:DataSpeEvent):void
			{
				mc.rotation = e.data[0]; 
			}
			addTween(mc, _tween, 'rotate');
			return _tween;
		};
		public static function scale2(mc:*, propDest_xscale:Number, propDest_yscale:Number, timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			var _tween:Tween = new Tween([mc.scaleX, mc.scaleY], [propDest_xscale, propDest_yscale], timeSeconds, animType, delay);
			_tween.addEventListener('tween', tweenHolderHandler);
			function tweenHolderHandler(e:DataSpeEvent):void
			{
				mc.scaleX = e.data[0];
				mc.scaleY = e.data[1];
			}
			addTween(mc, _tween, 'scale');
			return _tween;
		};
		public static function size2(mc:*, propDest_w:Number, propDest_h:Number, timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			var _tween:Tween = new Tween([mc.width, mc.height], [propDest_w, propDest_h], timeSeconds, animType, delay);
			_tween.addEventListener('tween', tweenHolderHandler);
			function tweenHolderHandler(e:DataSpeEvent):void
			{
				mc.width = e.data[0];
				mc.height = e.data[1];
			}
			addTween(mc, _tween, 'size');
			return _tween;
		};
		public static function move2(mc:*, propDest_x:Number, propDest_y:Number, timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			var _tween:Tween = new Tween([mc.x, mc.y], [propDest_x, propDest_y], timeSeconds, animType, delay);
			_tween.addEventListener('tween', tweenHolderHandler);
			function tweenHolderHandler(e:DataSpeEvent):void
			{
				mc.x = e.data[0];
				mc.y = e.data[1];
			}
			addTween(mc, _tween, 'slide');
			return _tween;
		};
		/////
		public static function w2(mc:*, propDest_w:Number,  timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			var _tween:Tween = new Tween([mc.width], [propDest_w], timeSeconds, animType, delay);
			_tween.addEventListener('tween', tweenHolderHandler);
			function tweenHolderHandler(e:DataSpeEvent):void
			{
				mc.width = e.data[0];
			}
			addTween(mc, _tween, 'w');
			return _tween;
		};
		public static function h2(mc:*, propDest_h:Number,  timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			var _tween:Tween = new Tween([mc.height], [propDest_h], timeSeconds, animType, delay);
			_tween.addEventListener('tween', tweenHolderHandler);
			function tweenHolderHandler(e:DataSpeEvent):void
			{
				mc.height = e.data[0];
			}
			addTween(mc, _tween, 'h');
			return _tween;
		};
		public static function x2(mc:*, propDest_x:Number,  timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			var _tween:Tween = new Tween([mc.x], [propDest_x], timeSeconds, animType, delay);
			_tween.addEventListener('tween', tweenHolderHandler);
			function tweenHolderHandler(e:DataSpeEvent):void
			{
				mc.x = e.data[0];
			}
			addTween(mc, _tween, 'x');
			return _tween;
		};
		public static function y2(mc:*, propDest_y:Number,  timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			var _tween:Tween = new Tween([mc.y], [propDest_y], timeSeconds, animType, delay);
			_tween.addEventListener('tween', tweenHolderHandler);
			function tweenHolderHandler(e:DataSpeEvent):void
			{
				mc.y = e.data[0];
			}
			addTween(mc, _tween, 'y');
			return _tween;
		};
		
		/**
		 * 根据rgb值选择高光渐变效果
		 * 注意，亮度一般为1，变小则变化慢。反之则快
		 * 
		 * 颜色设置需要为0的应该设置为-0xff,如红色为0xff,-0xff,-0xff
		 * 
		 * @example
		 * Tween.colorTransform2(loader,-0xff,-0xff,-0xff,1,time).addEventListener('tweenEnd',tcomplete);
		 * function tcomplete(e){
		 * 		Tween.colorTransform2(loader,0xff,-0xff,-0xff,1,time);
		 * 	}
		 * @param	mc
		 * @param	r
		 * @param	g
		 * @param	b
		 * @param	brightness
		 * @param	timeSeconds
		 * @param	animType="linear"
		 * @param	delay
		 * @return
		 */
		public static function colorTransform2(mc:*, r:Number,g:Number,b:Number,brightness:Number=1, timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			var colorNow:ColorTransform = mc.transform.colorTransform;
			//
			var _tween:Tween = new Tween([colorNow.alphaMultiplier,colorNow.alphaOffset,colorNow.blueMultiplier,colorNow.blueOffset,colorNow.greenMultiplier,colorNow.greenOffset,colorNow.redMultiplier,colorNow.redOffset], [colorNow.alphaMultiplier,colorNow.alphaOffset,brightness,b,brightness,g,brightness,r], timeSeconds, animType, delay);
			_tween.addEventListener('tween', tweenHolderHandler);
			function tweenHolderHandler(e:DataSpeEvent):void
			{
				var ncts:ColorTransform = new ColorTransform(e.data[6], e.data[4], e.data[2], e.data[0], e.data[7], e.data[5], e.data[3], e.data[1]);
				mc.transform.colorTransform = ncts;
				//trace('set color===',ncts.color);
			}
			addTween(mc, _tween, 'color');
			return _tween;
		}
		/**
		 * 直接设置值
		 * @param	mc
		 * @param	r
		 * @param	g
		 * @param	b
		 * @param	brightness
		 */
		public static function colorTransform(mc:*, r:Number,g:Number,b:Number,brightness:Number=1):void
		{
			var colorNow:ColorTransform = mc.transform.colorTransform;
			var data:Array = [colorNow.alphaMultiplier,colorNow.alphaOffset,brightness,b,brightness,g,brightness,r];
			var ncts:ColorTransform = new ColorTransform(data[6], data[4], data[2], data[0], data[7], data[5], data[3], data[1]);
			mc.transform.colorTransform = ncts;
		}
		/**
		 * 亮度调节
		 * @param	mc
		 * @param	brightness
		 * @param	c
		 * @param	timeSeconds
		 * @param	animType
		 * @param	delay
		 * @return
		 */
		public static function brightness2(mc:*, brightness:Number=1,c:Number=255, timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			return colorTransform2(mc,c,c,c,brightness,timeSeconds, animType,delay);
		}
		/**
		 * @example
		 * 请参考colorTransform2
		 */
		public static function color2(mc:*, color:Number,brightness:Number=0 , timeSeconds:Number=2, animType:String="linear", delay:Number=0):Tween
		{
			return colorTransform2(mc,color >> 16 & 0xff, color >> 8 & 0xff, color & 0xff,brightness,timeSeconds, animType,delay);
		};
		//
		public static function color(mc:*, color:Number,brightness:Number=0):void
		{
			colorTransform(mc, color >> 16 & 0xff, color >> 8 & 0xff, color & 0xff, brightness);
		}
		
		//{
		/**
		 * mc当前所有的tween
		 * @param	mc
		 * @return
		 */
		public static function getTweens(mc:*) :*
		{
			return mcDict[mc];
		};
		/**
		 * 是否正在谈运动中
		 * @param	mc
		 * @return
		 */
		public static function isTweening(mc:*) :Boolean
		{
			if (mcDict[mc]&&mcDict[mc].length>0 ) return true;
			return false;
		};
		/**
		 * 停止当前tween
		 * @param	mc
		 * @param	prop
		 */
		public static function stopTween(mc:*, prop:*=null,state:int=0):void 
		{
			if (!mcDict[mc])
			{
				for (var i:uint = 0; i < mcDict[mc].length; i++)
				{
					if (!prop || mcDict[mc][i].type == prop)
					{
						mcDict[mc][i].tween.stop(state);
						mcDict[mc].splice(i, 1);
						break;
					}
				}
			}
		};
		/**
		 * 增加tween
		 * @param	mc
		 * @param	tween
		 * @param	type
		 */
		private static function addTween(mc:*,tween:Tween,type:String):void
		{
			if (!mcDict[mc]) mcDict[mc] = [];
			mcDict[mc].push({type:type,tween:tween});
		}
		//}
		
		//{animiType
		static public var linear:String = "linear";
		static public var easeinquad:String = "easeinquad";
		static public var easeoutquad:String = "easeoutquad";
		static public var easeinoutquad:String = "easeinoutquad";
		static public var easeincubic:String = "easeincubic";
		static public var easeoutcubic:String = "easeoutcubic";
		static public var easeinoutcubic:String = "easeinoutcubic";
		static public var easeinquart:String = "easeinquart";
		static public var easeoutquart:String = "easeoutquart";
		static public var easeinoutquart:String = "easeinoutquart";
		static public var easeinquint:String = "easeinquint";
		static public var easeoutquint:String = "easeoutquint";
		static public var easeinoutquint:String = "easeinoutquint";
		static public var easeinsine:String = "easeinsine";
		static public var easeoutsine:String = "easeoutsine";
		static public var easeinoutsine:String = "easeinoutsine";
		static public var easeinexpo:String = "easeinexpo";
		static public var easeoutexpo:String = "easeoutexpo";
		static public var easeinoutexpo:String = "easeinoutexpo";
		static public var easeincirc:String = "easeincirc";
		static public var easeoutcirc:String = "easeoutcirc";
		static public var easeinoutcirc:String = "easeinoutcirc";
		static public var easeinelastic:String = "easeinelastic";
		static public var easeoutelastic:String = "easeoutelastic";
		static public var easeinoutelastic:String = "easeinoutelastic";
		static public var easeinback:String = "easeinback";
		static public var easeoutback:String = "easeoutback";
		static public var easeinoutback:String = "easeinoutback";
		static public var easeinbounce:String = "easeinbounce";
		static public var easeoutbounce:String = "easeoutbounce";
		static public var easeinoutbounce:String = "easeinoutbounce";
		//
		static public var animTypes:Array = ['linear','easeinquad','easeoutquad','easeinoutquad','easeincubic','easeoutcubic','easeinoutcubic','easeinquart','easeoutquart','easeinoutquart','easeinquint','easeoutquint','easeinoutquint','easeinsine','easeoutsine','easeinoutsine','easeinexpo','easeoutexpo','easeinoutexpo','easeincirc','easeoutcirc','easeinoutcirc','easeinelastic','easeoutelastic','easeinoutelastic','easeinback','easeoutback','easeinoutback','easeinbounce','easeoutbounce','easeinoutbounce'];
		//}
	}
}