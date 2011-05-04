package com.ixiyou.speUI.mcontrols 
{
	import com.ixiyou.speUI.collections.MSprite;
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import caurina.transitions.*
	import flash.text.*;
	import flash.utils.getTimer;
	import flash.utils.*
	//更新
	[Event(name="scroll", type="flash.events.Event")]
	/**
	 * 文本滚动条
	 * @author spe email:md9yue@qq.com
	 */
	public class MovieToTextVScrollBar extends MSprite
	{
		//是否背景点击
		protected var _allowTrackClick:Boolean = true
		//最大;
		protected var _maxScrollPosition:Number = 0;
		//最小
		protected var _minScrollPosition:Number = 0;
		//差值
		//protected var _pageSize:Number = 0;
		//按下箭头按钮时的滚动量。
		protected var _lineScrollSize:Number = 1;
		//按下滚动条轨道时滚动滑块的移动量。
		protected var _wheelScrollSize:Number = 1;
		//是否自动隐藏
		protected var  _hideBool:Boolean = false
		//滚动轴
		protected var _wheelBool:Boolean = true
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
		//记录是否持续动
		protected var _oldDelayTime:uint
		//控制的显示对象
		protected var _content:TextField
		//皮肤
		protected var _skin:*
		protected var _slider:MovieToCheck2
		//记录原始滑块大小
		protected var _sliderRect:Rectangle=new Rectangle()
		protected var _sliderBtn:MovieClip
		protected var _nextBtn:SimpleButton
		protected var _previousBtn:SimpleButton
		protected var _scrollBg:DisplayObject
		//是否自动计算
		public var sliderAutoSize:Boolean = true
		protected var sliderPot:Point=new Point()
	
		public static var UPDATA:String =Event.SCROLL
		public function MovieToTextVScrollBar(skin:Sprite,config:*=null,formerly:Boolean=false,parentBool:Boolean=false) 
		{
			var tempParent:DisplayObjectContainer
			
			if (formerly) {
				this.x = skin.x
				this.y = skin.y
				_height=skin.height
			}
			//parent
			if (skin.parent&& parentBool) {
				tempParent=skin.parent
				this.name=skin.name
			}
			if (skin) this.skin = skin
		
			if(tempParent)tempParent.addChild(this)
			if (config) {
				if(config.x!=null)
					x = config.x;
				if(config.y!=null)
					y = config.y;
				if(config.autoSize!=null)
					autoSize = config.autoSize;
				if (config.size != null&&config.size is Array)
				{
					width = config.size[0];
					height = config.size[1];
				}
				if (config.width != null)
					width = config.width;
				
				if (config.height != null)
					height = config.height;
				if (config.scrollDelay!=null) scrollDelay = config.scrollDelay
				if (config.hideBool!=null)  hideBool = config.hideBool
				if (config.scrollDelay!=null)  scrollDelay = config.scrollDelay
				if (config.allowTrackClick!=null) allowTrackClick = config.allowTrackClick
				if (config.tweenerBool!=null) tweenerBool = config.tweenerBool
				if (config.tweenerTime) tweenerTime = config.tweenerTime
				if (config.content!=null) content = config.content
			}
			if (height <= 0) this.height = 150
			//super(config)
		}
		/**
		 * 设置内容
		 */
		public function set content(value:TextField):void {
			if (_content == value) return;
			if(_content!=null)_content.removeEventListener(Event.SCROLL,SCROLL)
			_content = value
			if(_content!=null)_content.addEventListener(Event.SCROLL,SCROLL)
			upSlider()
		}
		public function get content():TextField { return _content; }
		/**
		 * 背景点选
		 */
		public function set allowTrackClick(value:Boolean):void {
			if (_allowTrackClick == value) return
			_allowTrackClick=value
		}
		public function get allowTrackClick():Boolean { return _allowTrackClick; }
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
		public function get pageSize():Number { return _maxScrollPosition - _minScrollPosition-_slider.height  }
		/**
		 * 最小值
		 */
		public function get minScrollPosition():Number { return _minScrollPosition; }
		/**
		 * 最大值
		 */
		public function get maxScrollPosition():Number { return _maxScrollPosition; }
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
					skin1.x=skin1.y=0
					
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
					
					_sliderBtn = Sprite(_skin).getChildByName('_sliderBtn') as MovieClip;
					//if(skin1.contains(_sliderBtn))skin1.removeChild(_sliderBtn)
					_sliderRect.width = _sliderBtn.width
					_sliderRect.height = _sliderBtn.height
					_slider=new MovieToCheck2(_sliderBtn)
				
					addChild(_slider)
					//_slider.setSize(_sliderRect.width,_sliderRect.height)
					_slider.addEventListener(MouseEvent.MOUSE_DOWN,sliderDown)

					if(_scrollBg)_scrollBg.removeEventListener(MouseEvent.MOUSE_DOWN,scrollDown)
					_scrollBg = Sprite(_skin).getChildByName('_scrollBg')
					_scrollBg.addEventListener(MouseEvent.MOUSE_DOWN, scrollDown)
					upSize()
					
				}catch (e:TypeError) {
					trace('movieToTextVscrollBar skin error:',e)
				}
			}
		}
		//背景按下
		private function scrollDown(e:MouseEvent):void {
			stopScroll()
			if (_scrollBg && e.target != _scrollBg) return
			if(!allowTrackClick)return
			if (content == null) return
			if (e.target == _sliderBtn || e.target == _previousBtn || e.target == _nextBtn) return	
			if (this.mouseY > _previousBtn.height && this.mouseY <= _previousBtn.height + pageSize + _slider.height) {
				var num:Number
				if (mouseY >= _previousBtn.height + pageSize) num =  1
				else num = (mouseY - _previousBtn.height) / pageSize
				this.content.scrollV=uint(this.content.maxScrollV*num)
			}
		}
		//前后按钮按下
		private function btnDown(e:MouseEvent):void {
			stopScroll()
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
			stopScroll()
			if(content==null)return
			sliderPot.x = _slider.mouseX
			sliderPot.y=_slider.mouseY
			_slider.selectLock=false
			_slider.select = true
			_slider.selectLock=true
			if(_content!=null)_content.removeEventListener(Event.SCROLL,SCROLL)
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
			if (_content != null)_content.addEventListener(Event.SCROLL, SCROLL)
			upSlider()
			if(content==null)return
		}
		//滑块移动
		private function sliderMove(e:MouseEvent):void {
			var pt:Point =new Point(0, this.mouseY) 
			if (pt.y < _previousBtn.height+sliderPot.y)pt.y = _previousBtn.height
			else if (pt.y > pageSize+_previousBtn.height+sliderPot.y)pt.y  = pageSize+_previousBtn.height
			else pt.y=pt.y-sliderPot.y
			_slider.y=pt.y 
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
		 * 滚动
		 * @param	e
		 */
		private function SCROLL(e:Event):void {
			upSlider()
			dispatchEvent(new Event(Event.SCROLL))
		}
		/**
		 * 设置滚动
		 * @param	value 滚动距离
		 * @param	sense 滚动方向
		 */
		public function scrollToValue(value:Number, sense:Boolean):void {
			if(!computeCMBool())return
			if (sense) {
				if (content.maxScrollV > content.scrollV) content.scrollV += 1
				upSlider()
			}else {
				if (content.scrollV > 1) content.scrollV -= 1
				upSlider()
			}
		}
		/**
		 * 百分比计算对象的位置
		 */
		private function computeContentValue(value:Number):void {
			if (!computeCMBool()) return
			content.scrollV=uint(content.maxScrollV*value)
			
		}
		/**
		 * 计算滑动位置
		 */
		public function upSlider():void {
			if (computeCMBool()) {
				_slider.visible=true
				_slider.y=_previousBtn.height+pageSize*computeNumFormContent()
			}
			else {
				_slider.y = _previousBtn.height
				if (hideBool)_slider.visible = false
				else _slider.visible = true
			}
		}
		/**
		 * 根据滑块计算百分比
		 * @return
		 */
		private function computeNumFormSlider():Number {
			return	(_slider.y-_previousBtn.height)/pageSize
		}	
		/**
		 * 根据对象计算当前百分比
		 * @return
		 */
		public function computeNumFormContent():Number {
			if (!computeCMBool()) return 0
			if (content.maxScrollV == 1 && content.scrollV == 1) return 0
			return (content.scrollV-1)/(content.maxScrollV-1)
		}
		/**
		 * 计算位置合理性
		 */
		private function  computeCMBool():Boolean {
			var bool:Boolean=false
			if (content != null) {
				if (content.maxScrollV > 1)bool=true
				if (content.maxScrollV == 1 ) _slider.y = _previousBtn.height
			}
			if (!bool) {
				_slider.y = _previousBtn.height
				//if (sliderAutoSize)_slider.height = _maxScrollPosition - _minScrollPosition 
				//else _slider.height = _sliderRect.height
				if(hideBool)_slider.visible = false
				else _slider.visible = true
			}
			else {
				if (sliderAutoSize) {
					if (content.maxScrollV <= 10) {
						var num:Number = ((10 - content.maxScrollV) / 10) * (_maxScrollPosition - _minScrollPosition)
						//trace(num,_sliderRect.height)
						//if (num > _sliderRect.height)_slider.height = num
						//else _slider.height = _sliderRect.height
					}//else _slider.height = _sliderRect.height
					/*
					//算法2
					var num:Number = 1 / content.maxScrollV * (_maxScrollPosition - _minScrollPosition)
					trace(num, _sliderRect.height)
					if(num> _sliderRect.height)_slider.height = num
					else _slider.height = _sliderRect.height
					*/
				}
				else {
					//_slider.height = _sliderRect.height
				}
			}
				
			
			return bool
		}
		/**
		 * 更新组件大小
		 */
		override public function upSize():void {
			if (_previousBtn) {
				if (height < _previousBtn.height + _nextBtn.height + _sliderRect.height) {
					setSize(_previousBtn.width, _previousBtn.height + _nextBtn.height + _sliderRect.height + 10)
					return
				}
				_maxScrollPosition = this.height - _nextBtn.height
				_minScrollPosition = this._previousBtn.height
				_scrollBg.x = _scrollBg.y = 0
				
				_previousBtn.x = _previousBtn.y = 0
				_previousBtn.x=(_scrollBg.width-_previousBtn.width)/2
				_slider.x = 0
				_slider.x=(_scrollBg.width-_slider.width)/2
				_slider.y = _previousBtn.height
				
			
				
				
				_scrollBg.height = this.height

				_nextBtn.x = 0
				_nextBtn.x=(_scrollBg.width-_nextBtn.width)/2
				_nextBtn.y = this.height - _nextBtn.height
				upSlider()
			}
		}
		//---------------自动滚动--------------
		private var scrollvInterval:Number
		private var scrollvIntervalTime:Number
		private var loop:Boolean=false
		/**
		 * 开启自动滚动
		 * @param	bool 开启
		 * @param	value 滚动秒数
		 * @param	value 关闭
		 */
		public function openScroll(bool:Boolean=true,value:Number=500,_loop:Boolean=true):void {
			scrollvIntervalTime = value
			clearInterval(scrollvInterval)
			scrollvIntervalTime = value
			loop=_loop
			upSlider()
			if (bool) {
				scrollvInterval=setInterval(automaticScroll,scrollvIntervalTime)
			}
		}
		public function automaticScroll():void {
			if (!content) {
				clearInterval(scrollvInterval)
				return
			}
			content.scrollV += 1
			upSlider()
			if (content.maxScrollV <= content.scrollV) {
				if (!loop) clearInterval(scrollvInterval)
				else {
					content.scrollV=0
				}
			}
		}
		public function stopScroll():void {
			clearInterval(scrollvInterval)
		}
		/**
		 * 清楚事件索引
		 */
		override public function destory():void {
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
			if (_content != null)_content.removeEventListener(Event.SCROLL, SCROLL)
			_content=null
		}
	}

}