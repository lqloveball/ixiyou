 /*
  *Copyright (c) 2009 Ryan Liu 
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  * 
  *     http://www.apache.org/licenses/LICENSE-2.0
  *     
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */
package com.ixiyou.effects 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	/**
	 * @author Ryan Liu | www.ryan-liu.com
	 * @since 2009-9-4 22:41
	 * 
	 * Initial Object Parameters:
	 * 1) startString : String - the starting string,default value is empty.
	 * 2) endString : String - the ending string,default value is empty.
	 * 3) duration : Number - duration of the effect.
	 * 4) delay : Number - the delay before tween begins.
	 * 5) ease : Function - used for the easing varialbes.e.g. fl.motion.easing.Linear.easeIn.
	 * 6) sampleString : String - contains the characters that will be randomly picked for the string tween effect.Default value is [a-z 0-9 ]
	 * 
	 * Event:
	 * 1)Event.INIT : when StringTween is initialized and start to play.
	 * 2)Event.CHANGE : while StringTween is playing and StringTween.string is being changed.
	 * 3)Event.COMPLETE : when StringTween is complete.
	 * 
	 * 初始化参数：
	 * 1) startString : String - 起始字符串，默认值为空。
	 * 2) endString : String -结束字符串，默认值为空。
	 * 3) duration : Number - 效果的持续时间。
	 * 4) delay : Number - 在效果开始前的延迟时间。
	 * 5) ease : Function - 缓动方程，如 fl.motion.easing.Linear.easeIn.
	 * 6) sampleString : String - 包含效果中随机抽取的字符，默认是[a-z 0-9 ]的字符。
	 * 
	 * 事件：
	 * 1)Event.INIT : 当StringTween初始化完毕并开始播放。
	 * 2)Event.CHANGE : StringTween在运行，并且StringTween.string在变化时.
	 * 3)Event.COMPLETE : StringTween播放完毕。
	 * 
	 * 
		//------------------------------------------------------------------
		var str:String = "StringTween Class is for doing this kind of string effect.";
		var initObj:Object = { duration:1.5,ease:Sine.easeInOut,startString:str,endString:"Click to reverse this tween."};

		var strtween = new StringTween(initObj);
		strtween.addEventListener(Event.CHANGE, onChange);

		function onChange(e:Event) {
			tf.text = strtween.string;
		}

		stage.addEventListener('click',onClick);
		function onClick(e:MouseEvent){
			strtween.reverse();
		}
		//------------------------------------------------------------------
		import fl.motion.easing.*
		var str:String = "StringTween Class is for doing this kind of string effect.";
		var initObj:Object = { duration:1.5,ease:Sine.easeInOut,endString:str};
		//initObj.sampleString = "-="
		var strtween = new StringTween(initObj);
		strtween.addEventListener(Event.CHANGE, onChange);

		function onChange(e:Event) {
			tf.text = strtween.string;
		}

		stage.addEventListener('click',onClick);
		function onClick(e:MouseEvent){
			strtween.reset(initObj);
		}
	 */
	public class StringTween extends EventDispatcher {
		
		private var startString:String;
		private var endString:String;
		private var currentString:String;
		private var sampleStr:String ;
		private var startLength:int;
		private var endLength:int;
		private var curLength:int;
		private var sampleLength:int;
		private var start:Number;
		private var position:Number;
		private var end:Number;
		private var duration:Number;
		private var delay:Number;
		private var ticker:Shape;
		private var vars:Object;
		private var easeFunc:Function
		private var reversed:Boolean = false;

		/**
		 * Construct StringTween.建立StringTween
		 * @param	vars an Object that contains both string values and properties to set on StringTween. 
		 */
		public function StringTween(vars:Object ) {
			ticker = new Shape();
			reset(vars);
		}
		/**
		 * Initialize all parameters.
		 */
		private function init():void {
			startString = vars.startString || "";
			startLength = startString.length;
			currentString = startString;
			endString = vars.endString || "";
			endLength = endString.length;
			sampleStr = vars.sampleString ||  "abcdefghijklmnopqrstuvwxyz1234567890+-";
			sampleLength = sampleStr.length;
			duration = vars.duration || 1;
			delay = vars.delay || 0;
			delay = delay > 0?delay:0;
			easeFunc = vars.ease || linearEase;
		}
		/**
		 * reset initial parameters and restart StringTween.
		 * @param	vars
		 */
		public function reset(vars:Object):void {
			this.vars = vars;
			init();
			play();
			if (hasEventListener(Event.INIT)) dispatchEvent(new Event(Event.INIT));
		}
		/**
		 * start tween
		 */
		private function play():void {
			start = getTimer() / 1000 +delay;
			end = start + duration;
			ticker.addEventListener(Event.ENTER_FRAME, tickHandler);
		}
		/**
		 * reverse the tween.If a StringTween is reversed in the middle of tweening, the value will jump to then destination or start value.
		 */
		public function reverse():void {
			reversed = !reversed;
			var tempStr:String = vars.startString;
			vars.startString = vars.endString;
			vars.endString = tempStr;
			reset(vars);
		}
		/**
		 * handles enterFrame event.
		 * @param	e
		 */
		private function tickHandler(e:Event):void {
			updateTween(getTimer() / 1000);
		}
		/**
		 * update StringTween.Calculate tween progress and dispatch events.
		 * @param	time Current time in second.
		 */
		private function updateTween(time:Number):void {
			if (time >= end) {
				position = end;
			} else {
				position = time;
			}
			var past:Number = position - start
			if (past < 0) return;
			
			var ratio:Number = easeFunc(past/duration, 0, 1, 1);
			updateString(ratio);		
			
			if (hasEventListener(Event.CHANGE)) dispatchEvent(new Event(Event.CHANGE));
			
			if ( position == end) {
				ticker.removeEventListener(Event.ENTER_FRAME, tickHandler);
				if (hasEventListener(Event.COMPLETE) ) dispatchEvent(new Event(Event.COMPLETE));
				
			}
		}
		/**
		 * update current string by picking part of startString or endString and some random characters.
		 * @param	ratio a number between 0 -1 that indicates the progress of StringTween
		 */
		private function updateString(ratio:Number):void {
			var curLength:int , finalLength:int, pendingLength:int, loop:int;
			
			curLength = startLength + (endLength - startLength) * ratio;
			finalLength = (curLength > endLength?endLength:curLength) * ratio;
			pendingLength = curLength - finalLength;
			if (endString != "") {
				currentString = endString.substr(0, finalLength);
				loop = pendingLength
			} else {
				currentString = startString.substr(0, pendingLength);
				loop = finalLength;
			}
			
			var i:int = 0, rid:int ;
			while (i < loop) {
				i++
				rid = Math.random() * sampleLength;
				currentString += sampleStr.charAt(rid);
			}
		}
		/**
		 * returns a string of StringTween
		 */
		public function get  string ():String {
			return currentString;
			}
		/**
		 * default easing function,equals Linear.easeNone.
		 * @param	t
		 * @param	b
		 * @param	c
		 * @param	d
		 * @return
		 */
		private function linearEase(t:Number, b:Number, c:Number, d:Number):Number {
			return t;
		}
	}
	
}