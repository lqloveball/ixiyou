package com.ixiyou.speUI.controls 
{
	
	/**
	 * 基础按钮组件 无文字 4种状态 正常 移上 按下 禁用
	 * 大小更加导入的皮肤决定
	 * 适用用只用图片和动画的按钮，按钮大小可以由皮肤决定的情况下
	 * 
	 * @author spe
	 */
	import com.ixiyou.speUI.collections.SMovieClipBase;
	import com.ixiyou.speUI.controls.skins.ButtonSkin;
	import com.ixiyou.speUI.core.ISkinComponent;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.containers.OneContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.display.DisplayObject;
	public class MButtonBase extends SpeComponent implements ISkinComponent
	{
		//是否启用
		protected var _enabled:Boolean=true
		//指定一个用作按钮弹起状态
		public static var UPSTATE:String = 'upState';
		//指定一个用作按钮经过状态
		public static var OVERSTATE:String = 'overState';
		//指定一个用作按钮“按下”状态
		public static var DOWNSTATE:String = 'downState';
		//指定一个用作按钮“禁止使用”状态
		public static var PDSTATE:String = 'pdState';
		//选择状态
		public static var SELECTSTATE:String = 'selectState';
		//选择经过
		public static var SELECTOVERSTATE:String = 'selectOverState';
		//选择按下
		public static var SELECTDOWNSTATE:String = 'selectDownState';
		//禁止使用但选择了
		public static var PDSELECTSTATE:String = 'pdSelectState';
		//按钮样式
		protected var _skin:*
		//装按钮样式的盒子
		protected var _stateBox:SMovieClipBase = new SMovieClipBase()
		public function MButtonBase(config:*=null) 
		{
		
			this.mouseChildren = false
			this.useHandCursor = true
			buttonMode=true
			//_stateBox.graphics.beginFill(0)
			//_stateBox.graphics.drawRect(0,0,100,100)
			addChild(_stateBox)
			initMouse()
			super(config)
			if (config) {
				if (config.skin) skin = config.skin
				if (config.enabled!=null) enabled = config.enabled
			}
			if(skin==null )skin=null
		}
		/**
		 * 鼠标事件
		 */
		protected function initMouse():void {
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver,false,0,true)
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut,false,0,true)
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown,false,0,true)
			addEventListener(MouseEvent.MOUSE_UP, mouseUp,false,0,true)
		}
		/**
		 * 删除索引
		 */
		override public function destory():void {
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver)
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut)
			removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
		}
		/**初始化*/
		override public function initialize():void {
			if (_initialized) return;
			_initialized=true
			//初始化过就不再初始化,决大部分组件只初始化一次
			setSize(_stateBox.width, _stateBox.height)
			//_stateBox.addEventListener(Event.RESIZE, RESIZE)
			if (enabled)_stateBox.gotoAndStop(UPSTATE)
			else _stateBox.gotoAndStop(PDSTATE)
		}
		private function RESIZE(e:Event):void {
			setSize(_stateBox.width,_stateBox.height)
		}
		/**
		 * 鼠标放开
		 * @param	e
		 */
		protected function mouseUp(e:MouseEvent):void {
			if (!enabled) {
				_stateBox.gotoAndStop(PDSTATE)
				return
			}
			_stateBox.gotoAndStop(UPSTATE)
		}
		/**
		 * 鼠标经样式
		 * @param	e
		 */
		protected function mouseOver(e:MouseEvent):void {
			if (!enabled) {
				_stateBox.gotoAndStop(PDSTATE)
				return
			}
			_stateBox.gotoAndStop(OVERSTATE)
		}
		/**
		 * 鼠标按下后
		 * @param	e
		 */
		protected function mouseDown(e:MouseEvent):void {
			if (!enabled) {
				_stateBox.gotoAndStop(PDSTATE)
				return
			}
			_stateBox.gotoAndStop(DOWNSTATE)
		}
		/**
		 * 鼠标移开
		 * @param	e
		 */
		protected function mouseOut(e:MouseEvent):void {
			if (!enabled) {
				_stateBox.gotoAndStop(PDSTATE)
				return
			}
			_stateBox.gotoAndStop(UPSTATE)
		}
		/**
		 * 设置禁止使用
		 */
		public function set enabled(value:Boolean):void 
		{
			if (_enabled == value) return
			_enabled=value
			if (_enabled == false) {
				_stateBox.gotoAndStop(PDSTATE)
				this.mouseEnabled=false
			}else {
				this.mouseEnabled = true
				_stateBox.gotoAndStop(UPSTATE)
			}
		}
		public function get enabled():Boolean{return _enabled}

		/**组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				
					try {
						_skin = value;
						var flabel:String
						if (_stateBox) flabel = _stateBox.nowLabel
						_stateBox.clearFrame()
						if( Sprite(_skin).parent&& Sprite(_skin).parent.contains( Sprite(_skin))) Sprite(_skin).parent.removeChild( Sprite(_skin))
						
						if (Sprite(_skin).getChildByName('_' + UPSTATE))_stateBox.replaceLabel(UPSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
						
						if (Sprite(_skin).getChildByName('_' + OVERSTATE))_stateBox.replaceLabel(OVERSTATE, Sprite(_skin).getChildByName('_' + OVERSTATE))
						else _stateBox.replaceLabel(OVERSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
						
						if (Sprite(_skin).getChildByName('_' + DOWNSTATE))_stateBox.replaceLabel(DOWNSTATE, Sprite(_skin).getChildByName('_' + DOWNSTATE))
						else _stateBox.replaceLabel(DOWNSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
						
						if (Sprite(_skin).getChildByName('_' + SELECTSTATE))_stateBox.replaceLabel(SELECTSTATE, Sprite(_skin).getChildByName('_' + SELECTSTATE))
						else _stateBox.replaceLabel(SELECTSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
						
						if (Sprite(_skin).getChildByName('_' + SELECTOVERSTATE))_stateBox.replaceLabel(SELECTOVERSTATE, Sprite(_skin).getChildByName('_' + SELECTOVERSTATE))
						else if(Sprite(_skin).getChildByName('_' + SELECTSTATE))_stateBox.replaceLabel(SELECTOVERSTATE, Sprite(_skin).getChildByName('_' + SELECTSTATE))
						else _stateBox.replaceLabel(SELECTOVERSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
						
						if (Sprite(_skin).getChildByName('_' + SELECTDOWNSTATE))_stateBox.replaceLabel(SELECTDOWNSTATE, Sprite(_skin).getChildByName('_' + SELECTDOWNSTATE))
						else if(Sprite(_skin).getChildByName('_' + SELECTSTATE))_stateBox.replaceLabel(SELECTDOWNSTATE, Sprite(_skin).getChildByName('_' + SELECTSTATE))
						else _stateBox.replaceLabel(SELECTDOWNSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
						
						if (Sprite(_skin).getChildByName('_' + PDSTATE))_stateBox.replaceLabel(PDSTATE, Sprite(_skin).getChildByName('_' + PDSTATE))
						else if(Sprite(_skin).getChildByName('_' + SELECTSTATE))_stateBox.replaceLabel(PDSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
						
						if (Sprite(_skin).getChildByName('_' + PDSELECTSTATE))_stateBox.replaceLabel(PDSELECTSTATE, Sprite(_skin).getChildByName('_' + PDSELECTSTATE))
						else if(Sprite(_skin).getChildByName('_' + PDSTATE))_stateBox.replaceLabel(PDSELECTSTATE, Sprite(_skin).getChildByName('_' + PDSTATE))
						else _stateBox.replaceLabel(PDSELECTSTATE, Sprite(_skin).getChildByName('_' + UPSTATE))
						upSize()
						if(flabel)_stateBox.gotoAndStop(flabel)
					}catch (e:TypeError) {
						skin=new ButtonSkin()
					}
			}else if (value == null){skin=new ButtonSkin()}
		}	
		/**组件大小更新*/
		override public function upSize():void {
			//if (width != _stateBox.width || height != _stateBox.height) setSize(_stateBox.width, _nowStateBox.height)
		}
	}
	
}