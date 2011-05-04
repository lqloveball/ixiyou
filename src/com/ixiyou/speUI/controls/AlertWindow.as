package com.ixiyou.speUI.controls 
{
	
	
	/**
	 * 提示框组件
	 * @author spe
	 */
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.core.ISkinComponent;
	import com.ixiyou.speUI.controls.skins.AlertWindowSkin
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	//点击关闭
	[Event(name = "close", type = "flash.events.Event")]
	//点击确定
	[Event(name="ensure", type="flash.events.Event")]
	public class AlertWindow extends SpeComponent implements ISkinComponent
	{
		//点击关闭
		public static var CLOSE:String = 'close';
		//点击确定
		public static var ENSURE:String = 'ensure';
		//按钮样式
		protected var _skin:*
		//
		protected var _windBg:DisplayObject
		protected var _closeBtn:SimpleButton
		protected var _ensureBtn:SimpleButton
		protected var _abrogateBtn:SimpleButton
		protected var _labelText:TextField
		protected var _infoText:TextField
		protected var _infoRect:Rectangle = new Rectangle()
		protected var _closeRect:Rectangle = new Rectangle()
		protected var _btnRect:Rectangle = new Rectangle()
		private var _label:String = 'label'
		private var _info:String = 'info'
		private var _centerBool:Boolean = true
		private var _centerRandom:Boolean=true
	
		private var _data:Object
		
		public function AlertWindow(config:*=null) 
		{
			super(config)
			if (config) {
				if (config.skin) skin = config.skin
				if (config.label) label = config.label
				if (config.info) info = config.info
				if (config.data) data =  config.data
			}
			if (skin == null ) skin = null
			if (width <= 0) this.width = 300
			if (height <= 0) this.height = 150
			//trace(config.skin,skin);
		}
		/**
		 * 是否随即范围
		 */
		public function set centerRandom(value:Boolean):void 
		{
			if (_centerRandom == value) return
			_centerRandom=value
		}
		public function get centerRandom():Boolean { return _centerRandom; }
		/**
		 * 是否针对父级居中
		 */
		public function set centerBool(value:Boolean):void 
		{
			if (_centerBool == value) return
			_centerBool = value
			ResetSize()
		}
		public function get centerBool():Boolean { return _centerBool; }
		/**
		 * 附加数据
		 */
		public function set data(value:Object):void 
		{
			if (_data == value) return
			_data=value
		}
		public function get data():Object { return _data; }
		/**
		 * 标题
		 */
		public function set label(value:String):void 
		{
			if (_label == value) return
			_label = value
			if(_labelText)_labelText.text=_label
		}
		public function get label():String { return _label; }
		/**
		 * 提示信息
		 */
		public function set info(value:String):void 
		{
			if (_info == value) return
			_info = value
			if(_infoText)_infoText.text=info
		}
		public function get info():String { return _info; }
		private function downDrag(e:MouseEvent):void {
			if (_skin) Sprite(_skin).startDrag()
			parent.setChildIndex(this,parent.numChildren-1)
		}
		private function upDrag(e:MouseEvent):void {
			if (_skin)Sprite(_skin).stopDrag()
		}
		/**组件皮肤*/
		public function get skin():*{ return _skin }
		public function set skin(value:*):void {
			if (value is Sprite) {
				try {
					
					if (_skin && this.contains(_skin)) removeChild(_skin)
					if (_skin) {
						Sprite(_skin).removeEventListener(MouseEvent.MOUSE_DOWN, downDrag)
						Sprite(_skin).removeEventListener(MouseEvent.MOUSE_UP,upDrag)
					}
					_skin = value;
					Sprite(_skin).addEventListener(MouseEvent.MOUSE_DOWN, downDrag)
						Sprite(_skin).addEventListener(MouseEvent.MOUSE_UP,upDrag)
					addChild(_skin)
					if(_closeBtn)_closeBtn.removeEventListener(MouseEvent.CLICK,close)
					_closeBtn = Sprite(_skin).getChildByName('_closeBtn') as SimpleButton
					_closeBtn.addEventListener(MouseEvent.CLICK,close)
					_closeRect.width =  Sprite(_skin).width - _closeBtn.x
					
					if(_ensureBtn)_ensureBtn.removeEventListener(MouseEvent.CLICK,ensure)
					_ensureBtn = Sprite(_skin).getChildByName('_ensureBtn') as SimpleButton
					_ensureBtn.addEventListener(MouseEvent.CLICK,ensure)
					
					if(_abrogateBtn)_abrogateBtn.removeEventListener(MouseEvent.CLICK,close)
					_abrogateBtn = Sprite(_skin).getChildByName('_abrogateBtn') as SimpleButton
					_abrogateBtn.addEventListener(MouseEvent.CLICK,close)
					_btnRect.width = _abrogateBtn.x - (_ensureBtn.x + _ensureBtn.width)
					_btnRect.x = Sprite(_skin).width - _abrogateBtn.x
					_btnRect.y= Sprite(_skin).height-_abrogateBtn.y
					
					_labelText = Sprite(_skin).getChildByName('_label') as TextField
					_labelText.text = _label
					_labelText.selectable = false
					
					_infoText = Sprite(_skin).getChildByName('_info') as TextField
					_infoText.text = info
					_infoText.selectable=false
					_windBg = Sprite(_skin).getChildByName('_windBg')
					
					_infoRect.x = _infoText.x
					_infoRect.y=_infoText.y
					_infoRect.width = Sprite(_skin).width-_infoText.width-_infoText.x
					_infoRect.height=Sprite(_skin).height-_infoText.height-_infoText.y
					
					upSize()
				}catch (e:TypeError) {
					trace(e)
					skin= new AlertWindowSkin()
				}
			}else if (value == null){skin=new AlertWindowSkin()}
		}
		/**
		 * 关闭
		 * @param	e
		 */
		public function close(e:MouseEvent=null):void { 
			if(parent)parent.removeChild(this)
			dispatchEvent(new Event(AlertWindow.CLOSE))
		}
		/**
		 * 确定
		 * @param	e
		 */
		public function ensure(e:MouseEvent=null):void {
			if(parent)parent.removeChild(this)
			dispatchEvent(new Event(AlertWindow.ENSURE))
		}
	
		/**
		 * 更新组件大小
		 */
		override public function upSize():void {
			if (skin) {
				_windBg.width = this.width
				_windBg.height = this.height
				_closeBtn.x = width - _closeRect.width
				_infoText.width = width-_infoRect.width-_infoRect.x
				_infoText.height =height-_infoRect.y-_infoRect.height
				
				_abrogateBtn.x = width - _btnRect.x
				_abrogateBtn.y=height - _btnRect.y
				_ensureBtn.y=_abrogateBtn.y
				_ensureBtn.x = _abrogateBtn.x-_ensureBtn.width-_btnRect.width
				
			}
		}
		/**
		 * 父级改变，组件大小重设，
		 * 一般在组件被新的容器装载、
		 * 组件边界发生变化时候
		 * 执行大小重设由组件自行计算重设的大小
		 * */
		override public function ResetSize():void {
			super.ResetSize()
			if (parent&&centerBool) {
				this.x = (parent.width - this.width)/2
				this.y = (parent.height - this.height) / 2
				if ( Math.random() * 1 > .5) {
					if (centerRandom) x -= Math.random() * 30
					if(centerRandom)y-=Math.random()*30
				}else {
					if (centerRandom) x += Math.random() * 30
					if(centerRandom)y+=Math.random()*30
				}
				
			}
		}
		/**
		 * 清楚事件索引
		 */
		override public function destory():void {
			super.destory()
			if(_closeBtn)_closeBtn.removeEventListener(MouseEvent.CLICK,close)
			if(_ensureBtn)_ensureBtn.removeEventListener(MouseEvent.CLICK,ensure)
			if (_abrogateBtn)_abrogateBtn.removeEventListener(MouseEvent.CLICK, close)
			if (_skin) {
				Sprite(_skin).removeEventListener(MouseEvent.MOUSE_DOWN, downDrag)
				Sprite(_skin).removeEventListener(MouseEvent.MOUSE_UP,upDrag)
			}
		}
	}

}