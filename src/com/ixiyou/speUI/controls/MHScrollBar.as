package com.ixiyou.speUI.controls 
{
	
	
	/**
	 * 纵向滚动条
	 * @author spe
	 */
	import com.ixiyou.speUI.controls.skins.HScrollBarSkin;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.core.ISkinComponent;
	import flash.display.*;
	import flash.geom.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import caurina.transitions.Tweener
	import flash.utils.getTimer;
	[Event(name="scroll", type="flash.events.Event")]
	public class MHScrollBar extends SpeComponent implements ISkinComponent
	{
		//是否背景点击
		protected var _allowTrackClick:Boolean = true
		//最大;
		protected var _maxScrollPosition:Number = 0;
		//最小
		protected var _minScrollPosition:Number = 0;
		//差值
		//protected var _pageSize:Number = 0;
		//按下箭头按钮时的滚动量（以像素为单位）。
		protected var _lineScrollSize:Number = 10;
		//按下滚动条轨道时滚动滑块的移动量（以像素为单位）。
		protected var _wheelScrollSize:Number = 10;
		//[read-only] 获取下一个可以滚动的值。该属性为只读
		protected var _nextScroll: Number
		//[read-only] 获取上一个可以滚动的值。该属性为只读 
		protected var _previousScroll: Number
		//是否自动隐藏
		protected var  _hideBool:Boolean = false
		//滚动轴
		protected var _wheelBool:Boolean = true
		//坐标系对齐
		public var coordinateBool:Boolean=true
		//是否缓动
		public var tweenerBool:Boolean = true
		//缓动时间
		public var tweenerTime:Number = .2
		//鼠标按住事件
		protected var _mouseDownBool:Boolean = false
		//滚动方向
		protected var _scrollSense:Boolean = false
		//延迟滚动时间毫秒
		public var scrollDelay:uint = 350
		protected var _oldDelayTime:uint
		//控制的显示对象
		protected var _content:DisplayObject
		//显示对象对应的遮罩
		protected var _mask:DisplayObject
		//皮肤
		protected var _skin:*
		protected var _slider:MCheckButton
		//记录原始滑块大小
		protected var _sliderRect:Rectangle=new Rectangle()
		protected var _sliderBtn:Sprite
		protected var _nextBtn:SimpleButton
		protected var _previousBtn:SimpleButton
		protected var _scrollBg:DisplayObject
		//是否自动计算
		public var sliderAutoSize:Boolean = true
		protected var sliderPot:Point=new Point()
		//更新
		
		public static var UPDATA:String =Event.SCROLL
		
		public function MHScrollBar(config:*=null) 
		{
			super(config)
			if (config) {
				if (config.skin!=null) skin = config.skin
				if (config.scrollDelay) scrollDelay = config.scrollDelay
				if (config.wheelBool!=null)  wheelBool = config.wheelBool
				if (config.hideBool!=null)  hideBool = config.hideBool
				if (config.scrollDelay)  scrollDelay = config.scrollDelay
				if (config.allowTrackClick!=null) allowTrackClick = config.allowTrackClick
				if (config.tweenerBool!=null) tweenerBool = config.tweenerBool
				if (config.tweenerTime) tweenerTime = config.tweenerTime
				if (config.coordinateBool!=null)coordinateBool=config.coordinateBool
				if (config.content!=null) content = config.content
			}
			if (width <= 0) this.width = 150
			if (skin == null ) skin = null
			
		}
		/**
		 * 设置内容
		 */
		public function set content(value:DisplayObject):void {
			if (_content == value) return;
			if (value.mask == null) return;
			_content = value
			_mask = _content.mask
			upSlider()
			if (wheelBool) if (_content is InteractiveObject) InteractiveObject(_content).addEventListener(MouseEvent.MOUSE_WHEEL, MOUSE_WHEEL)
			else if (_content is InteractiveObject) InteractiveObject(_content).removeEventListener(MouseEvent.MOUSE_WHEEL, MOUSE_WHEEL)
			
		}
		public function get content():DisplayObject { return _content; }
		/**
		 * 是否支持滚轮
		 */
		public function set wheelBool(value:Boolean):void 
		{
			if (_wheelBool == value) return
			_wheelBool = value
			if (_wheelBool) if (_content is InteractiveObject) InteractiveObject(_content).addEventListener(MouseEvent.MOUSE_WHEEL, MOUSE_WHEEL)
			else if (_content is InteractiveObject) InteractiveObject(_content).removeEventListener(MouseEvent.MOUSE_WHEEL, MOUSE_WHEEL)
		}
		public function get wheelBool():Boolean { return _wheelBool; }
		/**
		 * 是否自动隐藏
		 */
		public function set hideBool(value:Boolean):void 
		{
			if (_hideBool == value) return
			_hideBool = value
			upSlider()
		}
		public function get hideBool():Boolean { return _hideBool; }
		/**组件皮肤*/
		public function get skin():*{ return _skin }
		public function set skin(value:*):void {
			if (value is Sprite) {
				try {
					if (_skin && this.contains(_skin)) removeChild(_skin)
					//if (_skin) {}
					_skin = value;
					var skin1:Sprite=Sprite(_skin)
					addChild(skin1)

					
					if (_previousBtn) {
						_previousBtn.removeEventListener(MouseEvent.MOUSE_DOWN, btnDown)
						//_previousBtn.removeEventListener(MouseEvent.MOUSE_UP, btnUp)
					}
					_previousBtn = Sprite(_skin).getChildByName('_previousBtn') as SimpleButton
					_previousBtn.addEventListener(MouseEvent.MOUSE_DOWN,btnDown)
					//_previousBtn.addEventListener(MouseEvent.MOUSE_UP, btnUp)
					
					if (_nextBtn) {
						_nextBtn.removeEventListener(MouseEvent.MOUSE_DOWN, btnDown)
						//_nextBtn.removeEventListener(MouseEvent.MOUSE_UP, btnUp)
					}
					_nextBtn = Sprite(_skin).getChildByName('_nextBtn') as SimpleButton
					_nextBtn.addEventListener(MouseEvent.MOUSE_DOWN,btnDown)
					//_nextBtn.addEventListener(MouseEvent.MOUSE_UP, btnUp)
					
					_sliderBtn = Sprite(_skin).getChildByName('_sliderBtn') as Sprite;
					//if(skin1.contains(_sliderBtn))skin1.removeChild(_sliderBtn)
					_sliderRect.width = _sliderBtn.width
					_sliderRect.height = _sliderBtn.height
					if (!_slider)_slider=new MCheckButton({skin:_sliderBtn})
					else _slider.skin=_sliderBtn
					addChild(_slider)
					_slider.setSize(_sliderRect.width,_sliderRect.height)
					_slider.addEventListener(MouseEvent.MOUSE_DOWN,sliderDown)
				
					
					if(_scrollBg)_scrollBg.removeEventListener(MouseEvent.MOUSE_DOWN,scrollDown)
					_scrollBg = Sprite(_skin).getChildByName('_scrollBg')
					
					_scrollBg.addEventListener(MouseEvent.MOUSE_DOWN, scrollDown)
					upSize()	
				}catch (e:TypeError) {
					trace(e)
					skin= new HScrollBarSkin()
				}
			}else if (value == null) {
				skin = new HScrollBarSkin()
			}
		}
		/**
		 * 滚轮事件
		 * @param	e
		 */
		private function MOUSE_WHEEL(e:MouseEvent):void {
			if(!content)return
			if (e.delta < 0) {
				scrollToValue(wheelScrollSize,true)
			}else {
				scrollToValue(wheelScrollSize,false)
			}
		}
		//背景按下
		private function scrollDown(e:MouseEvent):void {
			if (_scrollBg && e.target != _scrollBg) return
			if(!allowTrackClick)return
			if (content == null) return
			if (this.mouseX > _previousBtn.width && this.mouseX <= _previousBtn.width + pageSize + _slider.width) {
				var num:Number=mouseX
				if(mouseX>=_previousBtn.width + pageSize)num=_previousBtn.width + pageSize
				Tweener.addTween(_slider, { time:tweenerTime, x:num, 
					onUpdate:function():void { 
						computeContentValue(computeNumFormSlider())
						dispatchEvent(new Event(Event.SCROLL))
					}
				})
			}
		}
		
		//前后按钮按下
		private function btnDown(e:MouseEvent):void {
			if (content == null) return
			_mouseDownBool = true
			if (e.target == _nextBtn)_scrollSense = true
			else _scrollSense = false
			scrollToValue(lineScrollSize,_scrollSense)
			_oldDelayTime = getTimer()
			stage.addEventListener(MouseEvent.MOUSE_UP,stageUp)
			addEventListener(Event.ENTER_FRAME,ENTER_FRAME)
		}
		//按钮鼠标放开
		private function stageUp(e:MouseEvent):void {
			_mouseDownBool = false
			stage.removeEventListener(MouseEvent.MOUSE_UP,stageUp)
			removeEventListener(Event.ENTER_FRAME,ENTER_FRAME)
		}
		
		//滑块按下
		private function sliderDown(e:MouseEvent):void {
			if (content == null) return
			sliderPot.x = _slider.mouseX
			sliderPot.y=_slider.mouseY
			_slider.selectLock=false
			_slider.select = true
			_slider.selectLock=true
			stage.addEventListener(MouseEvent.MOUSE_UP, sliderUp)
			stage.addEventListener(MouseEvent.MOUSE_MOVE, sliderMove)
			
		}
		//滑块放开
		private function sliderUp(e:MouseEvent):void {
			_slider.selectLock=false
			_slider.select = false
			_slider.selectLock=true
			stage.removeEventListener(MouseEvent.MOUSE_UP, sliderUp)
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, sliderMove)
			//_slider.stopDrag()
			if(content==null)return
		}
		//滑块移动
		private function sliderMove(e:MouseEvent):void {
			var pt:Point =new Point(this.mouseX,0) 
			if (pt.x < _previousBtn.width+sliderPot.x)pt.x = _previousBtn.width
			else if (pt.x > pageSize+_previousBtn.width+sliderPot.x)pt.x  = pageSize+_previousBtn.width
			else pt.x=pt.x-sliderPot.x
			_slider.x = pt.x
			
			computeContentValue(computeNumFormSlider())
		}
		/**
		 * 帧触发
		 * @param	e
		 */
		private function ENTER_FRAME(e:Event):void {
			if (getTimer() - _oldDelayTime > scrollDelay) {
				scrollToValue(lineScrollSize,_scrollSense)
			}
		}
		/**
		 * 设置滚动
		 * @param	value 滚动距离
		 * @param	sense 滚动方向
		 */
		public function scrollToValue(value:Number, sense:Boolean):void {
			var num:Number
			if (!computeCMBool()) return
			if (sense) {
				if ( -(content.x - _mask.x)+value >= computeContentSize()) num = _mask.x - computeContentSize()
				else num = content.x - value
				if (tweenerBool) Tweener.addTween(content, { time:tweenerTime, x:num,
					onUpdate:function():void { 
						upSlider()
						dispatchEvent(new Event(Event.SCROLL))
					}
				})
				else {
					content.x = num
					upSlider()
					dispatchEvent(new Event(Event.SCROLL))
				}

			}else {
				if (content.x + value >= _mask.x)num = _mask.x
				else num = content.x + value
				if (tweenerBool) Tweener.addTween(content, { time:tweenerTime, x:num,
					onUpdate:function():void { 
						upSlider()
						dispatchEvent(new Event(Event.SCROLL))
					}
				})
				else {
					content.x = num
					upSlider()
					dispatchEvent(new Event(Event.SCROLL))
				}
			}
		}
		/**
		 * 百分比计算对象的位置
		 */
		private function computeContentValue(value:Number):void {
			if (!computeCMBool())return
			if (content.width <= content.mask.width) {
				 content.x = content.mask.x
				 dispatchEvent(new Event(Event.SCROLL))
				return
			}
			
			if (value > 1 || value < 0) return
			
			var __x:Number = -value * computeContentSize() + content.mask.x
			if (tweenerBool) Tweener.addTween(content, { time:tweenerTime, x:__x,
				onUpdate:function():void { 
					upSlider()
					dispatchEvent(new Event(Event.SCROLL))
				}
			})
			else {
				
				content.x = __x
				upSlider()
				dispatchEvent(new Event(Event.SCROLL))
			}
			
		}
		/**
		 * 根据滑块计算百分比
		 * @return
		 */
		private function computeNumFormSlider():Number {
			return	(_slider.x-_previousBtn.width)/pageSize
		}	
		/**
		 * 计算滑动位置
		 */
		public function upSlider():void {
			if (computeCMBool()) {
				_slider.visible = true
				_slider.x = _previousBtn.width + pageSize * computeNumFormContent()
				
			}
			else {
				_slider.x=_previousBtn.width
				if (hideBool)_slider.visible = false
				else _slider.visible = true
			}
		}
		
		/**
		 * 根据对象计算当前百分比
		 * @return
		 */
		private function computeNumFormContent():Number {
			computeCMBool()
			return (_mask.x-content.x)/computeContentSize()
		}
		/**
		 * 计算可以移动范围
		 * @return
		 */
		public function computeContentSize():Number {
			var _size:Number = 0
			if (computeCMBool()) {
				_size = content.width - content.mask.width
				 return _size
			}
			else return _size
		}
		/**
		 * 计算位置合理性
		 */
		private function  computeCMBool():Boolean {
			var bool:Boolean=false
			if (content != null && content.mask != null) {
				if (content.width > content.mask.width) bool = true
				if (coordinateBool&&content.y > content.mask.y) content.y = content.mask.y
				if (content.x > content.mask.x) content.x = content.mask.x
				if (bool && content.x < content.mask.x &&  content.mask.x-content.x  > content.width - content.mask.width) content.x=content.mask.x-(content.width-content.mask.width)
			}
			if (!bool) {
				_slider.x = _previousBtn.width
				if (sliderAutoSize)_slider.width = _maxScrollPosition - _minScrollPosition 
				else _slider.width = _sliderRect.width
				if(hideBool)_slider.visible = false
				else _slider.visible = true
			}else {
				if (sliderAutoSize) {
					var num:Number=(content.width - content.mask.width)/(_maxScrollPosition - _minScrollPosition)
					if (num < 1) {
						num = (_maxScrollPosition - _minScrollPosition) * (1 - num)
						if(_sliderRect.width>num)num= _sliderRect.width
						_slider.width = num
					}
					else _slider.width = _sliderRect.width
				}
				else {
					_slider.width = _sliderRect.width
				}
			}
			return bool
		}
		/**
		 * 当前滚动条位置
		 */
		public function set scrollPosition(value:Number):void {
			if(value<0&&value>1)return
			computeContentValue(value)
		}
		public function get scrollPosition():Number {return computeNumFormSlider()}
		/**
		 * 下一滚动位置
		 */
		public function get nextScroll():Number { 
			if (!computeCMBool()) return _nextScroll
			var num:Number
			if ( -(content.x - _mask.x)+lineScrollSize >= computeContentSize()) num = _mask.x - computeContentSize()
			else num = content.x - lineScrollSize
			return num
		}
		/**
		 * 上一滚动位置
		 */
		public function get previousScroll():Number {
			if (!computeCMBool()) return _previousScroll
			var num:Number
			if (content.x + lineScrollSize >= _mask.x)num = _mask.x
			else num = content.x + lineScrollSize
			return num
		}
		/**
		 * 点击滚动
		 */
		public function set lineScrollSize(value:Number):void { 
			
			_lineScrollSize=value
		}
		public function get lineScrollSize():Number { return _lineScrollSize; }
		/**
		 * 滚动
		 */
		public function set wheelScrollSize(value:Number):void 
		{
			_wheelScrollSize=value
		}
		public function get wheelScrollSize():Number { return _wheelScrollSize; }
		/**
		 * 差值
		 */
		public function get pageSize():Number { return _maxScrollPosition - _minScrollPosition-_slider.width  }
		/**
		 * 最小值
		 */
		public function get minScrollPosition():Number { return _minScrollPosition; }
		/**
		 * 最大值
		 */
		public function get maxScrollPosition():Number { return _maxScrollPosition; }
		/**
		 * 背景点选
		 */
		public function set allowTrackClick(value:Boolean):void {
			if (_allowTrackClick == value) return
			_allowTrackClick=value
		}
		public function get allowTrackClick():Boolean { return _allowTrackClick; }
		/**
		 * 更新组件大小
		 */
		override public function upSize():void {
			if (_previousBtn) {
				if (width < _previousBtn.width + _nextBtn.width + _sliderRect.width) {
					setSize(_previousBtn.width + _nextBtn.width + _sliderRect.width, _previousBtn.height)
					return
				}
				_maxScrollPosition = this.width - _nextBtn.width
				_minScrollPosition = this._previousBtn.width
				//_pageSize = _maxScrollPosition - _minScrollPosition
				
				_previousBtn.x = _previousBtn.y = 0
				_slider.x = _previousBtn.width
				_slider.y = 0
				
				_scrollBg.x=_scrollBg.y=0
				_scrollBg.width = this.width

				_nextBtn.x = this.width - _nextBtn.width
				_nextBtn.y = 0
				upSlider()
			}	
		}
	
		/**
		 * 清楚事件索引
		 */
		override public function destory():void {
			super.destory()
			removeEventListener(Event.ENTER_FRAME,ENTER_FRAME)
			if (_scrollBg)_scrollBg.removeEventListener(MouseEvent.MOUSE_DOWN, scrollDown)
			if (_sliderBtn) _sliderBtn.removeEventListener(MouseEvent.MOUSE_DOWN, sliderDown) 
			if (_nextBtn) {
				_nextBtn.removeEventListener(MouseEvent.MOUSE_DOWN, btnDown) 
				//_nextBtn.removeEventListener(MouseEvent.MOUSE_UP, btnUp)
			}
			if (_previousBtn) {
				_previousBtn.removeEventListener(MouseEvent.MOUSE_DOWN, btnDown)
				//_previousBtn.removeEventListener(MouseEvent.MOUSE_UP, btnUp)
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP,stageUp)
			removeEventListener(Event.ENTER_FRAME, ENTER_FRAME)
			stage.removeEventListener(MouseEvent.MOUSE_UP, sliderUp)
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, sliderMove)
			if (_content!=null&&_content is InteractiveObject)InteractiveObject(_content).removeEventListener(MouseEvent.MOUSE_WHEEL, MOUSE_WHEEL)
			_content=null
			_mask=null
		}
	}

}