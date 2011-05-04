package com.ixiyou.speUI.mcontrols 
{
	/**
	 * 横向滑块
	 * 资源描述 _slider 一个movie的2帧按钮
	 * _sliderState 一个进度显示块
	 * _sliderBg 滑块背景
	 * @author spe
	 */
	import com.ixiyou.speUI.collections.MSprite
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*
	import com.ixiyou.speUI.core.ISlider;
	import com.ixiyou.speUI.core.IDestory
	import flash.geom.Rectangle;
	import caurina.transitions.Tweener
	//数据更新
	[Event(name="upData", type="flash.events.Event")]
	
	public class MovieHSlider extends MSprite implements ISlider,IDestory
	{
		//是否背景点击
		protected var _allowTrackClick:Boolean = true
		//最大
		protected var _maximum:Number = 100
		//最小
		protected var _minimum:Number = 0
		//差值
		protected var _middleNum:Number=100
		//当前值
		protected var _value:Number = 0
		//指定是否为滑块启用实时拖动。
		protected var _liveDragging:Boolean = false
		//是否整数化
		protected var _intBool:Boolean = true
		
		//样式
		protected var _skin:*
		protected var _slider:MovieToBtn3
		protected var _sliderState:Sprite
		protected var _sliderBg:Sprite
		private var _stage:Stage
		public function MovieHSlider(skin:Sprite, formerly:Boolean = false, parentBool:Boolean=false,config:*= null):void {
			if (formerly) {
				this.x = skin.x
				this.y = skin.y
				skin.x = skin.y = 0
				_width = skin.width
				_height=skin.height
			}
			if (skin.parent && parentBool) {
				skin.parent.addChild(this)
				this.name=skin.name
			}
			super(config)
			this.skin = skin
			
			addEventListener(MouseEvent.MOUSE_DOWN,mouseBgDown)
			if (width <= 0) this.width = 100
			if (config) {
				if(config.liveDragging!=null)liveDragging=config.liveDragging
				if (config.skin) skin = config.skin
				if (config.maximum) maximum = config.maximum
				if (config.minimum) minimum = config.minimum
				if (config.value) value = config.value
				if(config.allowTrackClick!=null)allowTrackClick=config.allowTrackClick
			}
		}
		/**组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				try {
					if(_skin&&contains(_skin))removeChild(_skin)
					_skin = value;
					if (_slider) {
						removeChild(_slider)
						_slider.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
					}
					_slider = new MovieToBtn3(Sprite(_skin).getChildByName('_slider') as MovieClip)
					_slider.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
					addChild(_slider)
					_slider.y=0
					if(_sliderState&&this.contains(_sliderState))removeChild(_sliderState)
					_sliderState = Sprite(_skin).getChildByName('_sliderState') as Sprite
					//_sliderState.width = this.width
					_sliderState.y=_sliderState.x=0
					addChildAt(_sliderState, 0)
					if(_sliderBg&&this.contains(_sliderBg))removeChild(_sliderBg)
					_sliderBg = Sprite(_skin).getChildByName('_sliderBg') as  Sprite
					//_sliderBg.width = this.width
					_sliderBg.x=_sliderBg.y=0
					addChildAt(_sliderBg, 0)
					_height = Math.max(_sliderBg.height, _sliderState.height, _slider.height)
					_sliderState.y = (_height-_sliderState.height ) / 2
					_sliderBg.y=(_height-_sliderBg.height)/2
					upSize()
				}catch (e:TypeError) {
					trace(e,'MovieHSlider皮肤文件错误')
				}
			}
		}
		/**
		 * 重写大小更新
		 */
		override public function upSize():void {
			if (_slider) {
				computeMask()
				computeSliderX()
				_sliderBg.width = this.width
			}
		}
		/**
		 * 是否背景点击
		 * @param	e
		 */
		private function mouseBgDown(e:MouseEvent):void {
			if(e.target is MovieToBtn3)return
			if(!allowTrackClick)return
			var num:Number = Number(middleNum * (this.mouseX / (this.width - _slider.width)) + minimum)
			if (num < this.minimum)num=minimum
			if (num > this.maximum) num = maximum
			value=num
		}
		/**
		 * 鼠标按下
		 * @param	e
		 */
		private function mouseDown(e:MouseEvent):void {
			_slider.startDrag(false, new Rectangle(0, 0, this.width - _slider.width, 0))
			_stage=this.stage
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp)
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove)
			
		}
		/**
		 * 鼠标释放
		 * @param	e
		 */
		private function mouseUp(e:MouseEvent):void {
			_slider.stopDrag()
			value = (middleNum * computeNumFormSlider()) + minimum
			computeMask()
			//_valueBox.visible=false
			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove)
		}
		/**
		 * 鼠标移动
		 * @param	e
		 */
		private function mouseMove(e:MouseEvent):void {
			if (liveDragging) {
				var va:Number=(middleNum * computeNumFormSlider())+minimum
				if (_value == va) return
				if(va<minimum||va>maximum)return
				_value =va
				if (intBool) _value = int(_value)
				//_sliderMask.height = _sliderState.height
				_sliderState.width = (width - _slider.width) * ((_value-minimum) / middleNum) + _slider.width / 2;
				dispatchEvent(new Event('upData'))
			}else {
				//trace('---')
				var num:Number = (middleNum * computeNumFormSlider())+minimum
				if (intBool) num = int(num)
				//_sliderMask.height = _sliderState.height
				_sliderState.width = (width-_slider.width) * ((num-minimum)/ middleNum)+_slider.width/2;
			}
		}
		/**
		 * 计算滑块位置
		 */
		private function computeSliderX():void {
			if (_slider) {
				Tweener.addTween(_slider,{time:.2,x:(width - _slider.width)* computeNumFormValue()})
				//_slider.x = (width - _slider.width)* computeNumFormValue()
			}
		}
		/**
		 * 计算遮罩
		 */
		private function computeMask():void {
			//_sliderMask.height = _sliderState.height
			Tweener.addTween(_sliderState,{time:.2,width:(width-_slider.width)*computeNumFormValue()+_slider.width/2})
			//_sliderMask.width =
		}
		/**
		 * 根据滑块计算百分比
		 * @return
		 */
		private function computeNumFormSlider():Number {
			//trace(_slider.x,(this.width-_slider.width),_slider.x/(this.width-_slider.width))
			return	_slider.x/(this.width-_slider.width)
		}
		/**
		 * 根据值来计算值百分比
		 * @return
		 */
		private function computeNumFormValue():Number {
			return (value-minimum)/middleNum;
		}
		/**
		 * 指定在轨道上单击是否会移动滑块。
		 */
		public function set allowTrackClick(va:Boolean):void {
			_allowTrackClick = va

		}
		public function get allowTrackClick():Boolean { return _allowTrackClick }
		/**
		 * 整数化
		 */
		public function set intBool(value:Boolean):void {
			if (_intBool == value) return
			_intBool = value
			if (_intBool) {
				_maximum = int(value)
				_minimum = int(_minimum)
				_middleNum=_maximum-_minimum
			}
		}
		public function get intBool():Boolean { return _intBool; }
		/**
		 * 滑块上允许的最大值。
		 */
		public function set maximum(va:Number):void {
			if (intBool) {
				va = int(va)
				_minimum = int(_minimum)
			}
			if (_maximum == va || va < this.minimum) return
			
			_maximum = va
			computeSliderX()
			//computeMask()
			if (value > maximum) value = maximum
			if(value < minimum) value = minimum
			
			//_middleNum=_maximum-_minimum
		}
		public function get maximum():Number{return _maximum}
		/**
		 * 滑块控件上允许的最小值。
		 */
		public function set minimum(va:Number):void {
			if (intBool) {
				va = int(va)
				_maximum = int(_maximum)
			}
			if (_minimum == va||va>this.maximum) return
			_minimum = va
			//computeSliderX()
			//computeMask()
			if (value > maximum) value = maximum
			if(value < minimum) value = minimum
			
			//_middleNum=_maximum-_minimum
		}
		public function get minimum():Number{return _minimum}
		/**
		 * 包含滑块的位置，并且此值介于 minimum 属性和 maximum 属性之间。
		 */
		public function set value(va:Number):void {
			if (intBool)va = int(va)
			if (_value == va) return
			if(va<minimum||va>maximum)return
			_value = va
			computeSliderX()
			computeMask()
			dispatchEvent(new Event('upData'))
		}
		public function get value():Number { return _value }
		/**
		 * 中间差值
		 */
		public function get middleNum():Number{return maximum-minimum}
		/**
		 * 指定是否为滑块启用实时拖动。
		 */
		public function set liveDragging(value:Boolean):void {
			_liveDragging=value
		}
		public function get liveDragging():Boolean { return _liveDragging }
		/**
		 * 摧毁
		 */
		override public function destory():void {
		
		}
	}
}