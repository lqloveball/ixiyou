/**
* ...http://www.roading.net/blog/?tag=tween
* @author roading
* @link http://roading.net
* 
* @see 运动算法修改自：http://www.robertpenner.com/easing/
*/
package  com.ixiyou.tween
{
	public class TweenType
	{
		public static  function linear(t:Number,b:Number,c:Number,d:Number):Number
		{
			// simple linear tweening - no easing
			return c * t / d + b;
		}
		public static  function easeinquad(t:Number,b:Number,c:Number,d:Number):Number
		{
			// quadratic (t^2) easing in - accelerating from zero velocity
			return c * (t /= d) * t + b;
		}
		public static  function easeoutquad(t:Number,b:Number,c:Number,d:Number):Number
		{
			// quadratic (t^2) easing out - decelerating to zero velocity
			return -c * (t /= d) * (t - 2) + b;
		}
		public static  function easeinoutquad(t:Number,b:Number,c:Number,d:Number):Number
		{
			// quadratic (t^2) easing in/out - acceleration until halfway, then deceleration
			if ((t/=d/2) < 1) return c/2*t*t + b;
			return -c / 2 * ((--t) * (t - 2) - 1) + b;
		}
		public static  function easeincubic(t:Number,b:Number,c:Number,d:Number):Number
		{
			// cubic (t^3) easing in - accelerating from zero velocity
			return c * (t /= d) * t * t + b;
		}
		public static  function easeoutcubic(t:Number,b:Number,c:Number,d:Number):Number
		{
			// cubic (t^3) easing out - decelerating to zero velocity
			return c * ((t = t / d - 1) * t * t + 1) + b;
		}
		
		public static  function easeinoutcubic(t:Number,b:Number,c:Number,d:Number):Number
		{
			// cubic (t^3) easing in/out - acceleration until halfway, then deceleration
			if ((t/=d/2) < 1) return c / 2 * t * t * t + b;
			return c / 2 * ((t -= 2) * t * t + 2) + b;
		}
		public static  function easeinquart(t:Number,b:Number,c:Number,d:Number):Number
		{
			// quartic (t^4) easing in - accelerating from zero velocity
			return c * (t /= d) * t * t * t + b;
		}
		public static  function easeoutquart(t:Number,b:Number,c:Number,d:Number):Number
		{
			// quartic (t^4) easing out - decelerating to zero velocity
			return -c * ((t = t / d - 1) * t * t * t - 1) + b;
		}
		public static  function easeinoutquart(t:Number,b:Number,c:Number,d:Number):Number
		{
			// quartic (t^4) easing in/out - acceleration until halfway, then deceleration
			if ((t/=d/2) < 1) return c/2*t*t*t*t + b;
			return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
		}
		public static  function easeinquint(t:Number,b:Number,c:Number,d:Number):Number
		{
			// quintic (t^5) easing in - accelerating from zero velocity
			return c * (t /= d) * t * t * t * t + b;
		}
		public static  function easeoutquint(t:Number,b:Number,c:Number,d:Number):Number
		{
			// quintic (t^5) easing out - decelerating to zero velocity
			return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
		}
		public static  function easeinoutquint(t:Number,b:Number,c:Number,d:Number):Number
		{
			// quintic (t^5) easing in/out - acceleration until halfway, then deceleration
			if ((t/=d/2) < 1) return c/2*t*t*t*t*t + b;
			return c/2*((t-=2)*t*t*t*t + 2) + b;
		}
		public static  function easeinsine(t:Number,b:Number,c:Number,d:Number):Number
		{
			// sinusoidal (sin(t)) easing in - accelerating from zero velocity
			return -c * Math.cos(t/d * (Math.PI/2)) + c + b;
		}
		public static  function easeoutsine(t:Number,b:Number,c:Number,d:Number):Number
		{
			// sinusoidal (sin(t)) easing out - decelerating to zero velocity
			return c * Math.sin(t/d * (Math.PI/2)) + b;
		}
		public static  function easeinoutsine(t:Number,b:Number,c:Number,d:Number):Number
		{
			// sinusoidal (sin(t)) easing in/out - acceleration until halfway, then deceleration
			return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
		}
		public static  function easeinexpo(t:Number,b:Number,c:Number,d:Number):Number
		{
			// exponential (2^t) easing in - accelerating from zero velocity
			return (t == 0) ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
		}
		public static  function easeoutexpo(t:Number,b:Number,c:Number,d:Number):Number
		{
			// exponential (2^t) easing out - decelerating to zero velocity
			return (t == d) ? b + c : c * ( -Math.pow(2, -10 * t / d) + 1) + b;
		}
		public static  function easeinoutexpo(t:Number,b:Number,c:Number,d:Number):Number
		{
			// exponential (2^t) easing in/out - acceleration until halfway, then deceleration
			if (t==0) return b;
			if (t==d) return b+c;
			if ((t/=d/2) < 1) return c/2 * Math.pow(2, 10 * (t - 1)) + b;
			return c / 2 * ( -Math.pow(2, -10 * --t) + 2) + b;
		}
		public static  function easeincirc(t:Number,b:Number,c:Number,d:Number):Number
		{
			// circular (sqrt(1-t^2)) easing in - accelerating from zero velocity
			return -c * (Math.sqrt(1 - (t /= d) * t) - 1) + b;
		}
		public static  function easeoutcirc(t:Number,b:Number,c:Number,d:Number):Number
		{
			// circular (sqrt(1-t^2)) easing out - decelerating to zero velocity
			return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
		}
		public static  function easeinoutcirc(t:Number,b:Number,c:Number,d:Number):Number
		{
			// circular (sqrt(1-t^2)) easing in/out - acceleration until halfway, then deceleration
			if ((t/=d/2) < 1) return -c/2 * (Math.sqrt(1 - t*t) - 1) + b;
			return c/2 * (Math.sqrt(1 - (t-=2)*t) + 1) + b;
		}
		public static  function easeinelastic(t:Number,b:Number,c:Number,d:Number):Number
		{
			var s:Number=1,a:Number=1,p:Number=0;
			// elastic (exponentially decaying sine wave)
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			if (a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin( (t * d - s) * (2 * Math.PI) / p )) + b;
		}
		public static  function easeoutelastic(t:Number,b:Number,c:Number,d:Number):Number
		{
			var s:Number=1,a:Number=1,p:Number=0;
			// elastic (exponentially decaying sine wave)
			if (t==0) return b;  if ((t/=d)==1) return b+c;  if (!p) p=d*.3;
			if (a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			return a * Math.pow(2, -10 * t) * Math.sin( (t * d - s) * (2 * Math.PI) / p ) + c + b;
		}
		public static  function easeinoutelastic(t:Number,b:Number,c:Number,d:Number):Number
		{
			var s:Number=1,a:Number=1,p:Number=0;
			// elastic (exponentially decaying sine wave)
			if (t==0) return b;  if ((t/=d/2)==2) return b+c;  if (!p) p=d*(.3*1.5);
			if (a < Math.abs(c)) { a=c; s=p/4; }
			else s = p/(2*Math.PI) * Math.asin (c/a);
			if (t < 1) return -.5*(a*Math.pow(2,10*(t-=1)) * Math.sin( (t*d-s)*(2*Math.PI)/p )) + b;
			return a * Math.pow(2, -10 * (t -= 1)) * Math.sin( (t * d - s) * (2 * Math.PI) / p ) * .5 + c + b;
		}
		public static  function easeinback(t:Number,b:Number,c:Number,d:Number):Number
		{
			 var s:Number;
		// Robert Penner's explanation for the s parameter (overshoot ammount):
		//  s controls the amount of overshoot: higher s means greater overshoot
		//  s has a default value of 1.70158, which produces an overshoot of 10 percent
		//  s==0 produces cubic easing with no overshoot
			// back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in - backtracking slightly, then reversing direction and moving to target
			if (isNaN(s)) s = 1.70158;
			return c * (t /= d) * t * ((s + 1) * t - s) + b;
		}
		public static  function easeoutback(t:Number,b:Number,c:Number,d:Number):Number
		{
			var s:Number;
			// back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing out - moving towards target, overshooting it slightly, then reversing and coming back to target
			if (isNaN(s)) s = 1.70158;
			return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
		}
		public static  function easeinoutback(t:Number,b:Number,c:Number,d:Number):Number
		{
			var s:Number;
			// back (overshooting cubic easing: (s+1)*t^3 - s*t^2) easing in/out - backtracking slightly, then reversing direction and moving to target, then overshooting target, reversing, and finally coming back to target
			if (isNaN(s)) s = 1.70158; 
			if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
			return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
		}
		public static  function easeinbounce(t:Number,b:Number,c:Number,d:Number):Number
		{
		// This were changed a bit by me (since I'm not using Penner's own Math.* functions)
		// So I changed it to call getValue() instead (with some different arguments)
			// bounce (exponentially decaying parabolic bounce) easing in
			return c - easeoutbounce (d-t,b,c,d) + b;
		}
		public static  function easeoutbounce(t:Number,b:Number,c:Number,d:Number):Number
		{
			// bounce (exponentially decaying parabolic bounce) easing out
			if ((t/=d) < (1/2.75)) {
			  return c*(7.5625*t*t) + b;
			} else if (t < (2/2.75)) {
			  return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
			} else if (t < (2.5/2.75)) {
			  return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
			} else {
			  return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
			}
		}
		public static  function easeinoutbounce(t:Number,b:Number,c:Number,d:Number):Number
		{
			// bounce (exponentially decaying parabolic bounce) easing in/out
			if (t < d/2) return easeinbounce (t*2,b,c,d) * .5 + b;
			return easeoutbounce(t*2-d,b,c,d) * .5 + c * .5 + b;
		}
		
	}
}