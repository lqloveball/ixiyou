package com.ixiyou.speUI.controls 
{
	
	/**
	 * 横向滑块
	 * @author spe
	 */
	import flash.events.*;
	import flash.display.*;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.controls.MButtonBase;
	import com.ixiyou.speUI.core.ISlider;
	import com.ixiyou.speUI.core.ISkinComponent;
	import com.ixiyou.speUI.controls.skins.HSliderSkin
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import caurina.transitions.Tweener
	//数据更新
	[Event(name="upData", type="flash.events.Event")]
	public class MHSlider extends SpeComponent implements ISlider,ISkinComponent
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
		//数据更新
		public static var UPDATA:String = 'upData';
		//样式
		protected var _skin:*
		//
		private var _stage:Stage
		protected var _slider:MButtonBase
		protected var _sliderState:DisplayObject
		protected var _sliderBg:DisplayObject
		protected var _sliderMask:Shape = new Shape()
	
		public function MHSlider(config:*=null) 
		{
			super(config)
			
			if (width <= 0) this.width = 100
			if(skin==null )skin=null
			addChild(_slider)
			_sliderMask.graphics.beginFill(0)
			_sliderMask.graphics.drawRect(0, 0, 10, 10)
			addChild(_sliderMask)
			_slider.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			addEventListener(MouseEvent.MOUSE_DOWN,mouseBgDown)
			if (config) {
				if(config.liveDragging!=null)liveDragging=config.liveDragging
				if (config.skin) skin = config.skin
				if (config.maximum) maximum = config.maximum
				if (config.minimum) minimum = config.minimum
				if (config.value) value = config.value
				if(config.allowTrackClick!=null)allowTrackClick=config.allowTrackClick
			}
		}
		/**
		 * 是否背景点击
		 * @param	e
		 */
		private function mouseBgDown(e:MouseEvent):void {
			if(e.target is MButtonBase)return
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
			//computeMask()
			// _valueBox.visible=false
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
				_sliderMask.height = _sliderState.height
				_sliderMask.width = (width - _slider.width) * ((_value-minimum) / middleNum) + _slider.width / 2;
				dispatchEvent(new Event(MHSlider.UPDATA))
			}else {
				//trace('---')
				var num:Number = (middleNum * computeNumFormSlider())+minimum
				if (intBool) num = int(num)
				_sliderMask.height = _sliderState.height
				_sliderMask.width = (width-_slider.width) * ((num-minimum)/ middleNum)+_slider.width/2;
			}
		}
		/**
		 * 计算遮罩
		 */
		private function computeMask():void {
			_sliderMask.height = _sliderState.height
			Tweener.addTween(_sliderMask,{time:.2,width:(width-_slider.width)*computeNumFormValue()+_slider.width/2})
			//_sliderMask.width =
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
		 * 根据滑块计算百分比
		 * @return
		 */
		private function computeNumFormSlider():Number {
			return	_slider.x/(this.width-_slider.width)
		}
		/**
		 * 根据值来计算值百分比
		 * @return
		 */
		private function computeNumFormValue():Number {
			return (value-minimum)/middleNum;
		}
		/**组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				try {
					_skin = value;
					if (_slider == null)_slider = new MButtonBase( { skin:Sprite(_skin).getChildByName('_slider') } )
					else _slider.skin = Sprite(_skin).getChildByName('_slider')
					
					if(_sliderState&&this.contains(_sliderState))removeChild(_sliderState)
					_sliderState = Sprite(_skin).getChildByName('_sliderState')
					//_sliderState.width = this.width
					_sliderState.x=_sliderState.y=0
					addChildAt(_sliderState, 0)
					_sliderState.mask=_sliderMask
					if(_sliderBg&&this.contains(_sliderBg))removeChild(_sliderBg)
					_sliderBg = Sprite(_skin).getChildByName('_sliderBg')
					//_sliderBg.width = this.width
					_sliderBg.x=_sliderBg.y=0
					addChildAt(_sliderBg, 0)
					
					upSize()
				
				}catch (e:TypeError) {
					trace(e)
					skin=new HSliderSkin()
				}
			}else if (value == null){skin=new HSliderSkin()}
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
			computeMask()
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
			computeSliderX()
			computeMask()
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
			dispatchEvent(new Event(MHSlider.UPDATA))
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
		 * 重写大小更新
		 */
		override public function upSize():void {
			if (_slider) {
				computeMask()
				computeSliderX()
				_sliderBg.width = this.width
				_sliderState.width = this.width
			}
		}
		/**
		 * 重写删除
		 */
		override public function destory():void {
			super.destory()
			removeEventListener(MouseEvent.MOUSE_DOWN,mouseBgDown)
			_slider.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,mouseMove)
		}
	}
	
}