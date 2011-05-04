package com.ixiyou.speUI.controls 
{
	
	/**
	 * 树型的雏形
	 * @author magic
	 */
	
	import com.ixiyou.events.ResizeEvent;
	import com.ixiyou.speUI.collections.MSprite;
	import com.ixiyou.speUI.controls.MCheckButton;
	import com.ixiyou.speUI.core.VContainer;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class MTreeBase extends MSprite
	{
		
		private var _isOpen:Boolean = false;
		private var _headSpace:Number = 0;
		private var _indent:Number = 0;
		private var _autoOpen:Boolean = true;
		protected var _head:InteractiveObject
		protected var _box:VContainer;
		public function MTreeBase(config:*=null) 
		{
			if (config != null) {
				if (config.head != null) {
					head = config.head;
				}else {
					head = new Sprite();
				}
				if (config.box != null) {
					box = config.box;
				}else {
					box = new VContainer();
				}
				if (config.isOpen != null) {
					isOpen = config.isOpen;
				}
				super(config);
			}else {
				box = new VContainer();
				head = new Sprite();
			}
		}
		
		
		/**节点图标*/
		public function get head():InteractiveObject { return _head; }
		public function set head(value:InteractiveObject):void 
		{
			if (_head == value) return;
			if (_head != null&&_autoOpen) {
				_head.removeEventListener(MouseEvent.CLICK, headClick);
				super.removeChild(_head);
			}
			_head = value;
			if (_autoOpen) {
				_head.addEventListener(MouseEvent.CLICK, headClick);
			}
			super.addChild(_head);
			resize();
		}
		
		/**节点是否展开*/
		public function get isOpen():Boolean { return _isOpen; }
		public function set isOpen(value:Boolean):void 
		{
			if (_isOpen == value) return;
			_isOpen = value;
			if (_isOpen) {
				super.addChild(_box);
			}else {
				super.removeChild(_box);
			}
			resize();
		}
		
		/**子树容器*/
		public function get box():VContainer { return _box; }
		public function set box(value:VContainer):void 
		{
			if (_box == value) return;
			if (_box != null) {
				_box.removeEventListener(ResizeEvent.RESIZE, boxResize);
				if (_isOpen) {
					super.removeChild(_box);
				}
			}
			_box = value;
			_box.addEventListener(ResizeEvent.RESIZE, boxResize);
			_box.x = _indent;
			_box.y = _head.height + _headSpace;
			if (_isOpen) {
				super.addChild(_box);
				resize();
			}
		}
		/**head与子节点间的间距*/
		public function get headSpace():Number { return _headSpace; }
		public function set headSpace(value:Number):void 
		{
			if (_headSpace == value) return;
			_headSpace = value;
			_box.y = _head.height + _headSpace;
			if (_isOpen) {
				resize();
			}
		}
		
		/**子节点缩进量*/
		public function get indent():Number { return _indent; }
		public function set indent(value:Number):void 
		{
			if (_indent == value) return;
			_indent = value;
			if (_box != null) _box.x = _indent;
			resize();
		}
		
		/**点击图标时自动展开*/
		public function get autoOpen():Boolean { return _autoOpen; }
		public function set autoOpen(value:Boolean):void 
		{
			if (_autoOpen == value) return;
			_autoOpen = value;
			if (_head != null) {
				if (_autoOpen) {
					_head.addEventListener(MouseEvent.CLICK, headClick);
				}else {
					_head.removeEventListener(MouseEvent.CLICK, headClick);
				}
			}
		}
		
		/**子节点之间的间距*/
		public function get leading():Number { return _box.verticalGap; }
		public function set leading(value:Number):void { _box.verticalGap = value; }
		
		/**点击图标 */
		private function headClick(me:MouseEvent):void {
			isOpen = !_isOpen;
			resize();
		}
		
		/** 重置组件大小 */
		protected function resize():void {
			if (_isOpen) {
				setSize(Math.max(_head.width,_box.width+_indent),_head.height + _box.height+_headSpace)
			}else {
				setSize(_head.width,_head.height)
			}
		}
		
		/**_box大小改变*/
		private function boxResize(re:ResizeEvent=null):void {
			resize();
		}
	}
}