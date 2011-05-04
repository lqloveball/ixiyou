package com.ixiyou.air.ui 
{
	import com.ixiyou.air.ui.skins.AIRWindowsUISkin;
	import com.ixiyou.speUI.mcontrols.MovieToBtn3;
	import com.ixiyou.speUI.containers.Canvas;
	import com.ixiyou.speUI.core.ISkinComponent;
	import com.ixiyou.speUI.controls.MCheckButtonByMovie6;
	import com.ixiyou.air.managers.AIRWindowsManager;
	import com.ixiyou.geom.DragEdge;
	import com.ixiyou.utils.display.IDoubleClick;
	import com.ixiyou.events.*
	import flash.display.*;
	import flash.geom.*;
	import flash.text.TextField;
	import flash.events.*;
	/**
	 * 使用了speUI组件 所以这个东西不通用，废弃了
	 * AIR窗口基础
	 * @author spe
	 */
	public class AIRWindowsUI extends Sprite implements ISkinComponent
	{
		//是否初始化
		private var _initBool:Boolean = false
		//场景对齐方式
		protected var _stageAlign:String
		//场景模式
		protected var _stageScaleMode:String
		//内部容器区域
		protected var _rect:Rectangle = new Rectangle()
		//内部容器
		protected var _box:Canvas = new Canvas()
		//皮肤
		protected var _skin:*
		//关闭模式 true:close 还是 false:隐藏
		public var closeMode:Boolean=false
		//关闭按钮
		protected var _closeBtn:MovieToBtn3
		//关闭按钮区
		protected var closeRect:Rectangle=new Rectangle()
		//从最小化或最大化状态恢复此窗口按钮
		protected var _restoreBtn:MovieToBtn3
		protected var restoreRect:Rectangle=new Rectangle()
		//最小化按钮
		protected var _minBtn:MovieToBtn3
		protected var minRect:Rectangle=new Rectangle()
		//最大化按钮
		protected var _maxBtn:MovieToBtn3
		protected var maxRect:Rectangle=new Rectangle()
		//标题栏
		protected var _titleText:TextField
		//背景
		protected var _windowBg:DisplayObject
		//采用
		public static var AUTO_SIZE:String = 'auto_resize';
		//寬
		protected var _width:Number = 0;
		//高度
		protected var _height:Number = 0;
		//拉伸区域
		public var haulEdge:DragEdge
		//双击按钮管理器
		protected var mouseClicker:IDoubleClick
		//是否可拖动改变大小
		protected var _resizable:Boolean = true
		//拖动大小模式 true:非直接拖动 false拖动
		public var reSizeMode:Boolean = true
		/*
		 * 当前是否拖动改变大小中
		 **/
		protected var reSizeBool:Boolean=false
		public function AIRWindowsUI(config:*=null) 
		{
			haulEdge = new DragEdge(this, 8)
			addChild(_box)
			addEventListener(Event.ADDED_TO_STAGE, init);
			if (config) {
				if (config.size != null&&config.size is Array)
				{
					setSize(config.size[0],config.size[1])
				}
				if(config.reSizeMode!=null)reSizeMode=config.reSizeMode
				if(config.resizable!=null)resizable=config.resizable
				if(config.closeMode)closeMode=config.closeMode
				if (config.width != null)
					width = config.width;
				if (config.height != null)
					height = config.height;
				if(config.skin)skin=config.skin
				if(!window&&config.window&&config.window is NativeWindow)window=config.window
			}
			if(!skin)skin=null
			//考虑到时文类，那一开始就拥有窗口对象了
			if (window) iniWindows()
			mouseClicker = new IDoubleClick(this, 300, function():void {
				var rc:Rectangle=new Rectangle(rect.x,0,width-rect.x-rect.width,rect.y)
				if(rc.contains(mouseX,mouseY))	maxOrRestore()
				})
			addEventListener(MouseEvent.MOUSE_DOWN, MOUSE_DOWN)
		}
		//----------------------------------
		/**
		 * 初始化到场景
		 * @param	e
		 */
		protected function init(e:Event = null):void {
			if (stage && !window && stage.nativeWindow) window = stage.nativeWindow
			initialize()
			
		}
		/**
		 * 初始化
		 */
		public function initialize():void {
			if(_initBool)return
			stageScaleMode = StageScaleMode.NO_SCALE;
			stageAlign = StageAlign.TOP_LEFT;
			_initBool=true
		}
		/**
		 * 窗口
		 */
		public function set window(value:NativeWindow):void 
		{
			//窗口对象只被加载一次
			if (window) return
			value.stage.addChild(this)
			iniWindows()
		}
		/**
		 * 初始化界面
		 */
		protected function iniWindows():void {
			if (window) {
				windowManager.add(window)
				addEvent(window)
				initialize()
				ResetSize()
				if(_titleText)_titleText.text=window.title
			}
		}
		/**
		 * 窗口
		 */
		public function get window():NativeWindow { return stage.nativeWindow; }
		//------------------------与窗口操作相关的一些方法-----------
		/**
		 * 窗口大小改变中
		 * @param	e
		 */
		protected function reSizeIng(e:NativeWindowBoundsEvent):void 
		{
			//trace('reSizeIng',e.afterBounds,e.beforeBounds,stage.stageWidth,stage.stageHeight)
		}
		/**
		 * 窗口大小改变
		 * @param	e
		 */
		protected function reSize(e:NativeWindowBoundsEvent):void 
		{
			ResetSize()
		}
		/**
		 * 窗口移动中
		 * afterBounds 未处理的窗口的新范围。 
		 * beforeBounds 未处理的窗口的旧范围。 
		 * @param	e
		 */
		protected function windowMoveIng(e:NativeWindowBoundsEvent):void 
		{
			
		}
		/**
		 * 窗口移动
		 * afterBounds 窗口的新范围。 
		 * beforeBounds 窗口的旧范围。 
		 * @param	e
		 */
		protected function windowMove(e:NativeWindowBoundsEvent):void 
		{
			
		}
		/**
		 * 窗口关闭中
		 * @param	e
		 */
		protected function closeIng(e:Event):void 
		{
			var win:NativeWindow = e.target as NativeWindow
			var obj:Object=windowManager.getWindowByPrototype(window)
			if (obj) {
				if (obj && obj.closeQuerist) {
					e.preventDefault()
					//插入询问关闭的方法
				}
			}
		}
		/**
		 * 关闭窗口事件
		 * @param	e
		 */
		protected function closeEvent(e:Event):void 
		{			
		}
		/**
		 * 激活
		 * @param	e
		 */
		protected function activate(e:Event):void {
			//trace('激活')
		}
		/**
		 * 在取消激活窗口后由此 NativeWindow 对象调度。
		 * @param	e
		 */
		protected function deaCtivate(e:Event):void 
		{
			
		}
		
		/**
		 * 场景全屏
		 * */
		public function set displayState(value:Boolean):void {
			if (!stage) return
			if (value) this.stage.displayState = StageDisplayState.FULL_SCREEN
			else this.stage.displayState = StageDisplayState.NORMAL
		}
		public function get displayState():Boolean {
			if (this.stage.displayState == StageDisplayState.FULL_SCREEN ) return true
			else return false
		}
		/**
		 * 场景对齐方式
		 * */
		public function set stageAlign(value:String):void 
		{
			if(value==stageAlign)return
			if (value == StageAlign.TOP_LEFT || value == StageAlign.BOTTOM || value == StageAlign.BOTTOM_LEFT||
			value == StageAlign.LEFT || value == StageAlign.RIGHT || value == StageAlign.TOP ||
			value == StageAlign.TOP_RIGHT) {
				if(stage)stage.align = value
			}
		}
		public function get stageAlign():String { return stage.align; }
		/**
		 * 场景模式
		 */
		public function set stageScaleMode(value:String):void 
		{
			if (stageScaleMode == value) return
			if (value == StageScaleMode.EXACT_FIT || value == StageScaleMode.NO_BORDER||
			value ==StageScaleMode.NO_SCALE||value ==StageScaleMode.SHOW_ALL) {
				if(stage)stage.scaleMode = value
			}
		}
		public function get stageScaleMode():String { return _stageScaleMode; }
		/**
		 * 窗口列表管理器
		 */
		public function get windowManager():AIRWindowsManager { return AIRWindowsManager.instance; }
		/**组件大小重设，
		 * 一般在组件被新的容器装载、
		 * 组件边界发生变化时候
		 * 执行大小重设由组件自行计算重设的大小
		 * */
		public function ResetSize():void {
			if (window) {
				if (window.displayState == NativeWindowDisplayState.MAXIMIZED) {
					if (maxBtn) maxBtn.visible = false
					if (restoreBtn) restoreBtn.visible = true
					if (window.systemChrome == NativeWindowSystemChrome.NONE) {
						setSize(stage.stageWidth - 10, stage.stageHeight - 10)
						this.x =this.y= 5
					}
					else {
						setSize(stage.stageWidth, stage.stageHeight)
						this.x =this.y=0
					}
				}
				else if (window.displayState == NativeWindowDisplayState.NORMAL) {
					if (maxBtn) maxBtn.visible = true
					if (restoreBtn) restoreBtn.visible = false
					setSize(stage.stageWidth, stage.stageHeight)
					this.x =this.y=0
				}else {
					if (maxBtn) maxBtn.visible = false
					if (restoreBtn) restoreBtn.visible = true
					setSize(stage.stageWidth, stage.stageHeight)
					this.x =this.y=0
				}
			}
		}
		/**设置大小*/
		public function setSize(w:Number, h:Number):void {
			if (w != _width || h != _height) {
				var event:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
				event.oldHeight = _height;
				event.oldWidth = _width;
				if (w != _width) {
					var wevent:ResizeEvent = new ResizeEvent(ResizeEvent.WRESIZE);
					event.oldWidth = _width;
					_width = w;
					dispatchEvent(wevent)
				} 
				if (h != _height) {
					var hevent:ResizeEvent = new ResizeEvent(ResizeEvent.HRESIZE);
					hevent.oldHeight = _height;
					_height = h;
					dispatchEvent(hevent)
				} 
				upSize();
				dispatchEvent(event);
				dispatchEvent(new Event(Event.RESIZE))//大小变化事件
			}
		}
		/**设置高度*/
		override public function set height(value:Number):void {
			if (value < 0) return
			setSize(_width,value);
		}
		override public function get height():Number{return _height;}
		/**设置宽度*/
		override public function set width(value:Number):void{
			if (value < 0) return
			setSize(value,_height);
		}
		override public function get width():Number { return _width; }
		/**
		 * 破坏所有索引，垃圾回收
		 */
		public function destory():void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if(window)moveEvent(window)
		}
		/**设置组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				try {
					if (_skin) {if(contains(_skin))removeChild(_skin)}
					_skin = value
					addChild(_skin)
					var skinMC:Sprite = _skin
					if (skinMC.getChildByName('windowBg'))windowBg = skinMC.getChildByName('windowBg')
					else windowBg=null
					var rect:DisplayObject
					if (skinMC.getChildByName('rect')) rect = skinMC.getChildByName('rect')
					if (rect) {
						if(skinMC.contains(rect))skinMC.removeChild(rect)
						_rect.x = rect.x
						_rect.y = rect.y
						_rect.width = _windowBg.width - rect.width - rect.x
						_rect.height=_windowBg.height-rect.height-rect.y
					}
					else {
						_rect.x=_rect.y=_rect.width=_rect.height=0
					}
					if (skinMC.getChildByName('closeBtn')) {
						closeBtn = new MovieToBtn3(skinMC.getChildByName('closeBtn') as MovieClip, true)
						closeRect.y = closeBtn.y
						closeRect.x=skinMC.width-closeBtn.x
					}
					else closeBtn=null
					if (skinMC.getChildByName('minBtn')) {
						minBtn = new MovieToBtn3(skinMC.getChildByName('minBtn') as MovieClip, true)
						minRect.y = minBtn.y
						minRect.x=skinMC.width-minBtn.x
					}
					else minBtn=null
					if (skinMC.getChildByName('maxBtn')) {
						maxBtn = new MovieToBtn3(skinMC.getChildByName('maxBtn') as MovieClip, true)
						maxRect.y = maxBtn.y
						maxRect.x=skinMC.width-maxBtn.x
					}
					else maxBtn=null
					if (skinMC.getChildByName('restoreBtn')) {
						restoreBtn = new MovieToBtn3(skinMC.getChildByName('restoreBtn') as MovieClip, true)
						restoreRect.y = restoreBtn.y
						restoreRect.x=skinMC.width-restoreBtn.x
					}
					else restoreBtn = null
					setChildIndex(_box, numChildren - 1)
					if (skinMC.getChildByName('windowTitle')) _titleText=skinMC.getChildByName('windowTitle') as TextField
					if(window)_titleText.text=window.title
					upSize()
				}catch (e:TypeError) {
					skin=new AIRWindowsUISkin()
				}
			}else if (value == null){skin=new AIRWindowsUISkin()}
		}
		/**界面背景*/
		public function set windowBg(value:DisplayObject):void 
		{
			if (_windowBg) {
				//if (_windowBg is InteractiveObject) InteractiveObject(_windowBg).removeEventListener(MouseEvent.MOUSE_DOWN, bgDown)
				_windowBg=null
			}
			if (value) {
				_windowBg=value
				//if (_windowBg is InteractiveObject) InteractiveObject(_windowBg).addEventListener(MouseEvent.MOUSE_DOWN, bgDown)
			}
		}
		/**
		 * 鼠标安下
		 * @param	e
		 */
		private function MOUSE_DOWN(e:MouseEvent):void 
		{
			if(e.target!=_windowBg)return
			var num:uint = haulEdge.mouseRect(mouseX, mouseY)
			if (num==5) {
				if (!window.active) window.activate()
				window.startMove()
			}else {
				if (window.displayState == NativeWindowDisplayState.NORMAL&&resizable) {
					//DragHaulRectManager.getInstance().startDrag(this, num,_minObj)
					if (num == 1) window.startResize (NativeWindowResize.TOP_LEFT) 
					if (num == 2) window.startResize (NativeWindowResize.TOP) 
					if (num == 3) window.startResize (NativeWindowResize.TOP_RIGHT) 
					if (num == 4) window.startResize (NativeWindowResize.LEFT) 
					if (num == 6) window.startResize (NativeWindowResize.RIGHT) 
					if (num == 7) window.startResize (NativeWindowResize.BOTTOM_LEFT) 
					if (num == 8) window.startResize (NativeWindowResize.BOTTOM) 
					if (num == 9) window.startResize (NativeWindowResize.BOTTOM_RIGHT)
					if (reSizeMode) {
						reSizeBool=true
						stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp)
					}
				}
			}
		}
		/**
		 * 拖动鼠标释放
		 * @param	e
		 */
		private function stageMouseUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp)
			reSizeBool = false
			ResetSize()
		}
		
		public function get windowBg():DisplayObject { return _windowBg; }
		/**界面的标题*/
		public function get titleText():TextField { return _titleText; }
		/**最大化按钮*/
		public function set maxBtn(value:MovieToBtn3 ):void 
		{
			if (maxBtn) {
				maxBtn.removeEventListener(MouseEvent.CLICK, maxfun)
				if(contains(maxBtn))removeChild(maxBtn)
			}
			if (value) {
				_maxBtn = value
				addChild(maxBtn)
				maxBtn.addEventListener(MouseEvent.CLICK, maxfun)
			}
		}
		public function get maxBtn():MovieToBtn3 { return _maxBtn; }
		public function maxfun(e:MouseEvent=null):void 
		{
			if(window)window.maximize()
		}
		/**
		 * 最小化按钮
		 */
		public function set minBtn(value:MovieToBtn3 ):void 
		{
			if (minBtn) {
				minBtn.removeEventListener(MouseEvent.CLICK, minfun)
				if(contains(minBtn))removeChild(minBtn)
			}
			if (value) {
				_minBtn = value
				addChild(minBtn)
				minBtn.addEventListener(MouseEvent.CLICK, minfun)
			}
		}
		public function get minBtn():MovieToBtn3 { return _minBtn; }
		public function minfun(e:MouseEvent=null):void 
		{
			if(window)window.minimize()
		}
		/**
		 * 返原按钮
		 */
		public function set restoreBtn(value:MovieToBtn3 ):void 
		{
			if (restoreBtn) {
				restoreBtn.removeEventListener(MouseEvent.CLICK, restorefun)
				if(contains(restoreBtn))removeChild(restoreBtn)
			}
			if (value) {
				_restoreBtn = value
				addChild(restoreBtn)
				restoreBtn.addEventListener(MouseEvent.CLICK, restorefun)
			}
		}
		public function get restoreBtn():MovieToBtn3 { return _restoreBtn; }
		public function restorefun(e:MouseEvent=null):void 
		{
			if(window)window.restore()
		}
		/**
		 * 大小切换
		 */
		private function maxOrRestore():void {
			if (!window) return
			if (window.displayState == NativeWindowDisplayState.MAXIMIZED) {
					window.restore()
			}
			else if (window.displayState == NativeWindowDisplayState.NORMAL) {
				window.maximize()
			}
		}
		/**
		 * 关闭按钮
		 */
		public function set closeBtn(value:MovieToBtn3):void 
		{
			if (closeBtn) {
				closeBtn.removeEventListener(MouseEvent.CLICK, closefun)
				if(contains(closeBtn))removeChild(closeBtn)
			}
			if (value) {
				_closeBtn = value
				addChild(closeBtn)
				closeBtn.addEventListener(MouseEvent.CLICK, closefun)
			}
		}
		public function get closeBtn():MovieToBtn3 { return _closeBtn; }
		/**
		 * 关闭窗口
		 * @param	e
		 */
		private function closefun(e:MouseEvent):void 
		{
			if (window) {
				if (!closeMode) windowManager.hit(window)
				else windowManager.close(window)
			}
		}
		/**
		 * 重写大小重新绘制
		 */
		public function upSize():void {
			haulEdge.upRect()
			_box.x = _rect.x
			_box.y = _rect.y
			_box.width = width - rect.width-rect.x
			_box.height = height - rect.height-rect.y
			if (windowBg){
				windowBg.width = width
				windowBg.height=height
			}
			if (closeBtn) closeBtn.x = width - closeRect.x
			if (minBtn) minBtn.x = width - minRect.x
			if (maxBtn) maxBtn.x = width - maxRect.x
			if (restoreBtn) restoreBtn.x = width - restoreRect.x
		}
		/**
		 * 区域
		 */
		public function get rect():Rectangle { return _rect; }
		/**
		 * 是否可以拉动呢
		 */
		public function get resizable():Boolean { return _resizable; }
		
		public function set resizable(value:Boolean):void 
		{
			_resizable = value;
		}
		/**
		 * 添加显示对象到内部容器
		 * @param	value
		 */
		public function add(value:DisplayObject):void { _box.addChild(value) }
		/**
		 * 删除指定内容
		 * @param	value
		 */
		public function remove(value:DisplayObject):void{ if(_box.contains(value))_box.removeChild(value)}
		/**
		 * 添加显示对象到内部容器，指定层级
		 * @param	value
		 */
		public function addAt(value:DisplayObject, index:int = -1):void {
			if(index<0)index=_box.numChildren
			_box.addChildAt(value, index)
		}
		/**
		 * 添加事件
		 * @param	value
		 */
		private function addEvent(value:NativeWindow):void {
			value.addEventListener(Event.ACTIVATE, activate)
			value.addEventListener(Event.CLOSE, closeEvent)
			value.addEventListener(Event.CLOSING, closeIng)
			value.addEventListener(Event.DEACTIVATE, deaCtivate)
			value.addEventListener(NativeWindowBoundsEvent.MOVE, windowMove)
			value.addEventListener(NativeWindowBoundsEvent.MOVING, windowMoveIng)
			value.addEventListener(NativeWindowBoundsEvent.RESIZE, reSize)
			value.addEventListener(NativeWindowBoundsEvent.RESIZING,reSizeIng)
		}
		/**
		 * 删除事件
		 * @param	value
		 */
		private function moveEvent(value:NativeWindow):void {
			value.removeEventListener(Event.ACTIVATE, activate)
			value.removeEventListener(Event.CLOSE, closeEvent)
			value.removeEventListener(Event.CLOSING, closeIng)
			value.removeEventListener(Event.DEACTIVATE, deaCtivate)
			value.removeEventListener(NativeWindowBoundsEvent.MOVE, windowMove)
			value.removeEventListener(NativeWindowBoundsEvent.MOVING, windowMoveIng)
			value.removeEventListener(NativeWindowBoundsEvent.RESIZE, reSize)
			value.removeEventListener(NativeWindowBoundsEvent.RESIZING,reSizeIng)
		}
	}

}