package com.ixiyou.speUI.mcontrols 
{
	import com.ixiyou.speUI.collections.skins.CursorSkin;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.FrameLabel;
	/**
	 * 系统光标
	 * @author spe
	 */
	public class CursorSprite extends Sprite
	{
		//实现单例使用的属性
		private static var instance:CursorSprite
		/**单例*/
		public static function getInstance():CursorSprite {
			if (instance == null)instance = new CursorSprite();
			return instance;
		}
		//原型
		private var _prototype:MovieClip
		//当前状态
		private var _nowState:String = '';
		//光标帧列表
		private var _currentLabels:Array
		//光标标示列表
		private var _labels:Array
		//光标状态
		//默认光标
		public static var DEFAULT:String = 'default'
		//移动
		public static var MOVE:String = 'move'
		//默认使用2
		public static var DEFAULT2:String = 'default2'
		//拉伸 左上 与右下
		public static var RECT_1_9:String = 'rect_1_9'
		//拉伸 右上 与左下
		public static var RECT_3_7:String = 'rect_3_7'
		//拉伸 上下
		public static var RECT_2_8:String = 'rect_2_8'
		//拉伸 左右
		public static var RECT_4_6:String = 'rect_4_6'
		//横向拉伸
		public static var HRECT:String = 'hRect'
		//纵向拉伸
		public static var VRECT:String = 'vRect'
		/**
		 * 构造函数
		 * @param	__prototype
		 */
		public function CursorSprite(__prototype:MovieClip = null) {
			if (__prototype) prototype = __prototype
			else prototype=new CursorSkin()
		}
		/**
		 * 拥有的标签
		 */
		public function get currentLabels():Array { return _currentLabels; }
		/**
		 *  是否拥有此状态
		 * @param	value
		 * @return
		 */
		public function haveState(value:String):Boolean {
			if (!prototype) return false
			//如果有标签组，判断是否有对应标签存在
			if (!currentLabels) return false
			var bool:Boolean = false
			var frameLabel:FrameLabel
			for (var i:int = 0; i < currentLabels.length; i++) 
			{
				frameLabel = FrameLabel(currentLabels[i])
				if (value == frameLabel.name)bool = true
			}
			//标签不存在
			if (bool) return true
			return false
		}
		/**
		 * 当前状态
		 */
		public function get nowState():String { return _nowState; }
		/**
		 * 设置光标状态
		 * @param	value
		 */
		public function setState(value:String):void {
			if (!prototype) return
			if (haveState(value)) {
				_nowState=value
				prototype.gotoAndStop(value)
			}
			else {
				if (prototype.currentLabel) {
					_nowState=prototype.currentLabel
					prototype.gotoAndStop(prototype.currentLabel)
				}else {
					prototype.gotoAndStop(1)
					_nowState=''
				}
			}
		}
		/**
		 * 光标原型
		 */
		public function set prototype(value:MovieClip):void 
		{
			if (_prototype == value) return
			if(_prototype&&this.contains(_prototype))removeChild(_prototype)
			_prototype = value
			_prototype.stop()
			_prototype.mouseChildren = false
			_prototype.mouseEnabled = false
			_currentLabels = _prototype.currentLabels
			//设置标签
			if (_currentLabels) {
				_labels=new Array()
				for (var i:int = 0; i <_currentLabels.length ; i++)_labels.push(FrameLabel(_currentLabels[i]).name)
			}
			addChild(_prototype)
			setState(nowState)
		}
		public function get prototype():MovieClip { return _prototype; }
		public function get labels():Array { return _labels; }
	}

}