package com.ixiyou.utils.keyboard 
{
	
	
	/**
	 * 快捷键
	 * @example
	import com.ixiyou.utils.keyboard.HotKey;
	import com.ixiyou.utils.keyboard.KeyStroke;
	import flash.display.Sprite;
	public class Keytest extends Sprite
	{
		
		public function Keytest() 
		{
			var hk:HotKey = new HotKey(stage);
			hk.registerKeys(function():void { trace("AK") }, [KeyStroke.VK_A, 70]);
			hk.registerKeys(function():void { trace("a&&K") }, KeyStroke.VK_A, 70);
			hk.registerLongKeys(function():void { trace("d__0.5") }, 500, KeyStroke.VK_D);
			hk.registerLinkKeys(function():void { trace("a_S_D") }, 1000, KeyStroke.VK_A, KeyStroke.VK_S, KeyStroke.VK_D);
			hk.registerLinkKeys(function():void { trace("D_D_D") }, 500, KeyStroke.VK_D, KeyStroke.VK_D, KeyStroke.VK_D);
			hk.registerKeys(testAK, KeyStroke.VK_A, KeyStroke.VK_K);
			//hk.removeKeys(testAK, KeyStroke.VK_A, KeyStroke.VK_K);
		}
		private function testAK():void {
			trace("ak");
		}
	}
	 * 
	 * @author magic
	 */
	
	 
	import flash.display.InteractiveObject;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	 
	public class HotKey 
	{
		private var _enabled:Boolean = true;
		private var _target:InteractiveObject;
		private var _linkKey:Array;
		private var _longKey:Dictionary;
		private var _codes:Array;
		private var _codesToString:String;
		public function HotKey(target:InteractiveObject=null) 
		{
			_codes = new Array();
			_linkKey = new Array();
			_longKey = new Dictionary();
			if (target) {
				this.target = target;
			}
		}
		
		/***********setter and getter***************/
		/**
		 * 热键是否有效
		 */
		public function get enabled():Boolean { return _enabled; }
		
		public function set enabled(value:Boolean):void 
		{
			if (_enabled == value) return;
			_enabled == value;
			onFocusOut(null);
		}
		
		/**
		 * 侦听目标
		 */
		public function get target():InteractiveObject { return _target; }
		
		public function set target(value:InteractiveObject):void 
		{
			if (_target == value) return;
			if (_target != null) {
				_target.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				_target.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
			onFocusOut(null);
			_target = value;
			if (_target != null) {
				_target.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				_target.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				_target.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				_target.stage.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			}
		}
		
		/********************public********************/
		/**
		 * 注册一个热键
		 * @param	action
		 * @param	...keys
		 * @return
		 */
		public function registerKeys(action:Function, ...keys):Boolean {
			return registerLongKeys(action, 0, keys);
		}
		
		/**
		 * 注册一个连按组合键
		 * @param	action
		 * @param	time
		 * @param	...keys
		 * @return
		 */
		public function registerLinkKeys(action:Function, time:Number=500, ...keys):Boolean {
			var temp:Array = parseKey(keys);
			if (temp == null || temp.length == 0) return false;
			_linkKey.push(new LinkKey(action, time, temp));
			return true;
		}
		/**
		 * 注册一个长按组合键
		 * @param	action
		 * @param	time
		 * @param	...keys
		 * @return
		 */
		public function registerLongKeys(action:Function, time:Number=500, ...keys):Boolean {
			var temp:Array = parseKey(keys);
			if (temp == null || temp.length == 0) return false;
			var lk:LongKey = new LongKey(action, time, temp);
			if (_longKey[lk.idCode] == null) {
				_longKey[lk.idCode] = new Array();
			}
			_longKey[lk.idCode].push(lk);
			return true;
		}
		
		
		/**
		 * 删除一个组合键
		 * @param	action
		 * @param	...keys
		 */
		public function removeKeys(action:Function, ...keys):void { removeLongKeys(action, 0, keys); }
		
		/**
		 * 删除一个连按组合键
		 * @param	action
		 * @param	time
		 * @param	...keys
		 */
		public function removeLinkKeys(action:Function, time:int, ...keys):void {
			var temp:Array = parseKey(keys);
			if (temp == null || temp.length == 0) return;
			var lk:LinkKey = new LinkKey(action, time, temp);
			for (var i:int = _linkKey.length - 1; i >= 0; i--) {
				if (lk.equal(_linkKey[i])) {
					_linkKey.splice(i, 1);
				}
			}
			
		}
		
		/**
		 * 删除一个长按组合键
		 * @param	action
		 * @param	time
		 * @param	...keys
		 */
		public function removeLongKeys(action:Function, time:int, ...keys):void { 
			var temp:Array = parseKey(keys);
			if (temp == null || temp.length == 0) return;
			var lk:LongKey = new LongKey(action, time, temp);
			temp = _longKey[lk.idCode] as Array;
			if (temp != null) {
				for (var i:int = temp.length - 1; i >= 0; i--) {
					if (lk.equal(temp[i])) {
						temp.splice(i, 1);
					}
				}
				if (temp.length == 0) {
					delete _longKey[lk.idCode];
				}
			}
		}
		
		/********************private*******************/
		/**
		 * 有按键弹起
		 * @param	key
		 */
		private function onKeyUp(key:KeyboardEvent):void {
			if (!_enabled) return;
			removeCode(key.keyCode)
		}
		/**
		 * 有按键按下
		 * @param	key
		 */
		private function onKeyDown(key:KeyboardEvent):void {
			if (!_enabled) return;
			var timer:int = getTimer();
			if (appendCode(key.keyCode)) {
				for (var i:int = _linkKey.length - 1; i >= 0; i--) {
					var lk:LinkKey = _linkKey[i] as LinkKey;
					if (lk.check(key.keyCode, timer)) {
						for (var s:int = _linkKey.length - 1; s >= 0; s--) _linkKey[s].index = 0;
						break;
					}
				}
				if (_longKey[_codesToString] != null) {
					var temp:Array = _longKey[_codesToString];
					for (i = temp.length - 1; i >= 0; i--) {
						temp[i].start(timer);
					}
				}
			}else {
				if (_longKey[_codesToString] != null) {
					temp = _longKey[_codesToString];
					for (i = temp.length - 1; i >= 0; i--) {
						temp[i].check(timer);
					}
				}
			}
		}
		
		/**
		 * 目标失去焦点
		 * @param	fe
		 */
		private function onFocusOut(fe:FocusEvent):void {
			while (_codes.length > 0) {
				_codes.pop();
			}
		}
		/**
		 * 解析热键
		 * @param	keys
		 * @return
		 */
		private function parseKey(keys:Array):Array {
			var temp:Array = new Array();
			var len:int = keys.length;
			if (len == 0) return temp;
			for (var i:int = 0; i < len; i++) 
			{
				if (keys[i] is IKeyStroke) {
					temp = temp.concat(keys[i].getCodes());
				}else if (keys[i] is uint) {
					temp.push(keys[i]);
				}else if (keys[i] is Array) {
					var parsKeys:Array = parseKey(keys[i]);
					if (parsKeys == null) {
						return null;
					}else {
						temp = temp.concat(parsKeys);
					}
				}else {
					return null;
				}
			}
			return temp;
		}
		
		/**
		 * 删除一组热键
		 * @param	keys	由uint组成的数组
		 */
		private function removeKeycodes(keys:Array):void {
			keys.sort(Array.NUMERIC);
			delete _longKey[keys.join('|')];
		}
		/**
		 * 在按键队列中添加一个按键
		 * @param	code
		 * @return
		 */
		private function appendCode(code:uint):Boolean {
			if (_codes.indexOf(code) >= 0) return false;
			_codes.push(code);
			_codes.sort(Array.NUMERIC);
			_codesToString = _codes.join('|');
			return true;
		}
		
		/**
		 * 从按键队列中删除一个按键
		 * @param	code	删除按键的keycode
		 * @return
		 */
		private function removeCode(code:uint):Boolean {
			var index:int = _codes.indexOf(code);
			if (index>= 0) {
				_codes.splice(index, 1);
				_codesToString = _codes.join('|');
				return true;
			}else {
				return false;
			}
		}
	}
}


/**
 * 连按键
 */
class LinkKey {
	private var keys:Array;
	public var index:int = 0;
	private var maxIndex:int;
	private var endTime:uint;
	private var duration:uint;
	private var action:Function;
	public var idCode:String;
	public function LinkKey(action:Function, duration:int, keys:Array):void {
		this.action = action;
		this.duration = duration;
		this.keys = keys;
		maxIndex = keys.length - 1;
		idCode = keys.join('|') + '|' + duration;
	}
	
	/**
	 * 检验
	 * @param	key
	 * @param	time
	 * @return
	 */
	public function check(key:uint, time:uint):Boolean {
		if (keys[index] == key) {
			if (index == 0) {
				endTime = time + duration;
				index=1;
			}else if(time>endTime) {
				index = 0;
			}else {
				index++;
			}
			if (index > this.maxIndex) {
				action();
				index = 0;
				return true;
			}
		}else if(index!=0) {
			index = 0;
		}
		return false;
	}
	
	/**
	 * 比较是否相同
	 * @param	lk
	 * @return
	 */
	public function equal(lk:LinkKey):Boolean {
		return lk.idCode == idCode && lk.duration == duration && lk.action == action;
	}
	
	
}

/**
 * 长按键
 */
class LongKey {
	private var endTime:int=int.MAX_VALUE;
	public var action:Function;
	public var duration:int;
	public var idCode:String;
	
	public function LongKey(action:Function, duration:int, keys:Array):void {
		keys.sort(Array.NUMERIC);
		idCode = keys.join('|');
		this.duration = duration;
		this.action = action;
	}
	
	/**
	 * 开始侦听按下时间
	 * @param	timer
	 */
	public function start(timer:int):void {
		if (duration == 0) {
			action();
		}else{
			endTime = timer + duration;
		}
	}
	
	/**
	 * 检验按下时间
	 * @param	timer
	 */
	public function check(timer:int):void {
		if (timer >= endTime) {
			action();
			endTime = int.MAX_VALUE;
		}
	}
	
	/**
	 * 比较是否相同
	 * @param	lk
	 * @return
	 */
	public function equal(lk:LongKey):Boolean {
		return lk.idCode == idCode && lk.duration == duration && lk.action == action;
	}
}