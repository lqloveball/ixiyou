package com.ixiyou.speUI.core
{
	/**
	 * speUI组件基类
	 * 主要 实现 初始化组件  自动适应宽高  百分比宽高 边界
	 * @author spe
	 * */
	import com.ixiyou.speUI.controls.MToolTip;
	import flash.display.DisplayObject;
	import flash.display.Stage
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.ixiyou.managers.ToolTipManager
	import com.ixiyou.events.LocationEvent
	import com.ixiyou.events.ResizeEvent
	//坐标改变
	[Event(name = 'location', type = "com.ixiyou.events.LocationEvent")]
	//x坐标改变
	[Event(name = 'Location_x', type = "com.ixiyou.events.LocationEvent")]
	//y坐标改变
	[Event(name = 'Location_y', type = "com.ixiyou.events.LocationEvent")]
	//高的改变
	[Event(name = 'HResize', type = "com.ixiyou.events.ResizeEvent")]
	//宽高改变
	[Event(name = 'Resize', type = "com.ixiyou.events.ResizeEvent")]
	//宽的改变
	[Event(name = 'WResize', type = "com.ixiyou.events.ResizeEvent")]
	//设置自动适应宽高
	[Event(name = "auto_resize", type = "flash.events.Event")]
	//默认改变大小
	[Event(name="resize", type="flash.events.Event")]
	public class SpeComponent extends Sprite implements ISpeComponent,IDestory
	{
		//是否初始过
		protected var _initialized:Boolean = false;
		//是否可以修改坐标
		protected var _LocationBool:Boolean = true
		//坐标
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		//是否可以调整组件大小
		protected var _SizeBool:Boolean = true
		//自动适应宽高
		private var _autoSize:Boolean = false;
		//寬
		protected var _width:Number = 0;
		//高度
		protected var _height:Number = 0;
		//组件的寬度百分币
		private var _percentWidth:Number = 0;
		//组件的高度百分币
		private var _percentHeight:Number = 0;
		//判断百分比寬是否开启
		protected var percentWidthBool:Boolean = false;
		public function get pWidthBool():Boolean { return percentWidthBool; }
		//判断百分比是高否开启
		protected var percentHeightBool:Boolean = false;
		public function get pHidthBool():Boolean { return percentHeightBool; }
		//组件的ID
		private var _id:String = null;
		//针对父级容器边距
		private var _borderMetrics:EdgeMetrics 
		//针对父级容器布局方式
		private var _pLayout:LayoutMode
		//针对父级容器布局方式是否开启
		private var _pLayoutBool:Boolean=true
		//提示框组件
		protected var _toolTip:DisplayObject;
		//设置自动适应父级容器大小发出设置事件，注意是设置
		public static var  AUTO_SIZE:String = "auto_resize";
		
		/**
		 * 构造函数
		 * */
		public function SpeComponent(config:*=null)
		{
			_pLayout = new LayoutMode()
			_pLayout.addEventListener(LayoutMode.UPMODE, pLayoutUpMode)
			_pLayout.addEventListener(LayoutMode.UPLAYOUT,pLayoutUpLayout)
			_borderMetrics = new EdgeMetrics();
			_borderMetrics.addEventListener(EdgeMetrics.UPEDGEMETRICS,upEdgeMetrics)
			addEventListener(Event.ADDED_TO_STAGE,init);
			if (config) {
				if (config.id != null)
					id = config.id;
				if (config.toolTip == null)
					setToolTip(config.toolTip )
				if (config.point != null)
					setChildIndex(config.point[0],config.point[1])
				if (config.x != null)
					x = config.x;
					
				if (config.y != null)
					y = config.y;
				if (config.borderMetrics != null) {
					borderMetrics.top = config.borderMetrics.top;
					borderMetrics.left = config.borderMetrics.left;
					borderMetrics.right = config.borderMetrics.right;
					borderMetrics.bottom = config.borderMetrics.bottom;
				}
					
				if (config.size != null&&config.size is Array)
				{
					width = config.size[0];
					height = config.size[1];
				}
				if (config.width != null)
					width = config.width;
				
				if (config.height != null)
					height = config.height;
					
				if (config.pWidth != null)
					percentWidth = config.pWidth;
					
				if (config.pHeight != null)
					percentHeight = config.pHeight;
					
				if (config.percentWidth != null)
					percentWidth = config.percentWidth;
					
				if (config.percentHeight != null)
					percentHeight = config.percentHeight;
				if(config.toolTip!=null)setToolTip(config.toolTip)
				if (config.owner != null)
					config.owner.addChild(this);
				if (config.parent != null)
					config.parent.addChild(this);
				if(config.autoSize!=null)
					autoSize=config.autoSize
				if (config.childs != null && config.childs is Array)
					for (var i:int; i < config.childs.length; i++)addChild(config.childs[i]);
				
			}
		}
		/** 组件加载进现实对象初始化
		 * @param 
		 * @return 
		*/
		protected function init(event:Event=null):void
		{
			if (parent) parent.addEventListener(Event.RESIZE, iniToStageSize)
			if (!_initialized) initialize();
			ResetSize()
		}
		/**组件父级发生变化时候，判断是否是这个组件父级，是就对组件大小重设，否需要移除监听*/
		protected function iniToStageSize(e:Event):void{
			try{
				var d:DisplayObject = e.target as DisplayObject
				if (parent && d == parent)ResetSize()
				else d.removeEventListener(Event.RESIZE, iniToStageSize)
			}catch(e:ArgumentError){
				trace(e.toString()+" 错误：组件父级，事件对象不是显示对象类型")
			}
		}
		/**初始化*/
		public function initialize():void {
			//初始化过就不再初始化,决大部分组件只初始化一次
			if (_initialized) return;
			_initialized = true;
			//trace(this+"init")
		}
		/**针对父级对齐方式*/
		public function get pLayout():LayoutMode { return _pLayout; }
		/**针对父级布局方式改变时候*/
		protected function pLayoutUpLayout(e:Event):void {
			this.dispatchEvent(new Event(e.type))
		}
		protected function pLayoutUpMode(e:Event):void {
			this.dispatchEvent(new Event(e.type))
		}
		/** 鼠标悬停时显示的内容
		 * @return 
		 * 
		 */	
		public function get toolTip() :DisplayObject{return _toolTip}
		public function set toolTip(value:DisplayObject) :void {
			if (_toolTip == value) return
			_toolTip = value
			if (_toolTip != null)
				ToolTipManager.getInstance().push(this,_toolTip)
			else
				ToolTipManager.getInstance().remove(this);

		}
		public function setToolTip(value:*) :void {
			if (value is DisplayObject) {
				toolTip=value
			}
			else if (value is String) {
				if (toolTip&&toolTip is MToolTip) {
					MToolTip(toolTip).text = value
					return
				}
				toolTip=new MToolTip({label:value}) as DisplayObject
			}else if (value == null) {
				toolTip=null
			}
		}
		/** 组件ID*/
		public function get id():String{return _id;}		
		public function set id(value:String):void{_id = value;}
		/**组件边界*/
		public function get borderMetrics():EdgeMetrics { return _borderMetrics }
		/**组件边界改变时候*/
		protected function upEdgeMetrics(e:Event):void {
			this.dispatchEvent(new Event(EdgeMetrics.UPEDGEMETRICS))
			if (owner&&owner is ILayoutContainer) {
				ILayoutContainer(owner).setChildLocation(this)
			}
		}
		/**自动适应宽高*/
		public function set autoSize(value:Boolean):void{
			if (_autoSize != value)
			{
				_autoSize = value;
				this.dispatchEvent(new Event(SpeComponent.AUTO_SIZE))
				ResetSize()
			}
		}
		public function get autoSize():Boolean { return _autoSize; }
		/**
		 * 父级改变，组件大小重设，
		 * 一般在组件被新的容器装载、
		 * 组件边界发生变化时候
		 * 执行大小重设由组件自行计算重设的大小
		 * */
		public function ResetSize():void {
			
			//父级不存在时候
			if (!owner) return
			//trace(this,owner is IVHContainer , owner is ILayoutContainer)
			//父级是布局类型容器不进行计算大小计算，这方面计算教给容器负责，父级调整大小同时还会调整位置布局
			if (owner is ILayoutContainer) ILayoutContainer(owner).setChildLocation(this)
			//父级是横纵排列容器，不进行计算大小，父级帮忙判断。
			if (owner is IVHContainer)return
			
			//自动适应大小时候
			if (autoSize) { 
				//父级是场景
				if (parent is Stage) {setSize(Stage(parent).stageWidth,Stage(parent).stageHeight)}
				else setSize(parent.width, parent.height)
			}
			//都是百分比时候
			else if (percentHeightBool && percentWidthBool) {
				//trace(this,'----------wh')
				//父级是场景
				if (parent is Stage) setSize(Stage(parent).stageWidth * percentWidth, Stage(parent).stageHeight * percentHeight)
				else setSize(parent.width*percentWidth,parent.height*percentHeight)
			}
			else if (percentWidthBool) {
				//trace(this,'----------w')
				//父级是场景
				if (parent is Stage) setSize(Stage(parent).stageWidth * percentWidth, height)
				else setSize(parent.width*percentWidth,height)
			}
			else if (percentHeightBool) {
				//trace(this,'----------h')
				//父级是场景
				if (parent is Stage) setSize(width, Stage(parent).stageHeight * percentHeight)
				else setSize(width,parent.height*percentHeight)
			}	
		}
		/**
		 * 是否锁定大小
		 * */
		public function set SizeBool(value:Boolean):void 
		{
			if(_SizeBool==value)return
			_SizeBool = value
			setSize(_width,_height)
		}
		/**
		 * 是否锁定大小
		 */
		public function get SizeBool():Boolean { return _SizeBool; }
		/**不考虑锁定情况下设置大小*/
		public function layoutSetSize(w:Number, h:Number):void {
			if (w != _width || h != _height) {
				var event:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
				event.oldHeight = _height;
				event.oldWidth = _width;
				if (w != _width) {
					var wevent:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
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
		/**设置大小*/
		public function setSize(w:Number, h:Number):void {
			
			//大小被锁定
			if (!SizeBool) {
				 _width = w 
				 _height=h
				return
			}
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
				dispatchEvent(new Event(Event.RESIZE))
				dispatchEvent(event);
				
			}
		}
		
		/** 
		 * 百分比寬度 在布局容器中无效
		 * */
		public function get percentWidth():Number
		{
			return _percentWidth;
		}
		/**
		 * 百分比寬度 在布局容器中无效
		 * value 0-1
		 */
		public function set percentWidth(value:Number):void
		{
			if (value < 0&&value>1) return
			if (percentHeight != value)
			{
				if(this.autoSize)autoSize=false
				percentWidthBool = true
				_percentWidth = value;
				ResetSize()
			}
		}
		/** 
		 * 百分比高度 在布局容器中无效
		 * */
		public function get percentHeight():Number
		{
			return _percentHeight;
		}
		/** 
		 * 百分比高度 在布局容器中无效
		 * */
		public function set percentHeight(value:Number):void
		{
			//trace(this,value)
			if (value < 0&&value>1) return
			//trace(this,value)
			if (percentHeight != value)
			{
				
				if(this.autoSize)autoSize=false
				percentHeightBool = true
				_percentHeight = value;
				ResetSize()
			}
		}
		/**设置高度*/
		override public function set height(value:Number):void {
			if (value < 0) return
				if(this.autoSize)autoSize=false
				percentHeightBool=false
				setSize(_width,value);
		}
		override public function get height():Number{return _height;}
		/**设置宽度*/
		override public function set width(value:Number):void{
			if (value < 0) return
				if(this.autoSize)autoSize=false
				percentWidthBool=false
				setSize(value,_height);
		}
		override public function get width():Number { return _width; }
		/**可以不考虑锁定坐标,重新设置位置*/
		public function layoutLocation(_x:Number, _y:Number):void {
			if (super.x != _x || super.y != _y) {
				var event:LocationEvent = new LocationEvent(LocationEvent.LOCATION);
				event.oldx = super.x;
				event.oldy = super.y;
				if (super.x != _x) {
					var eventx:LocationEvent = new LocationEvent(LocationEvent.LOCATION_X);
					eventx.oldx = super.x;
					super.x = _x
					dispatchEvent(eventx);
				}
				if (super.y != _y) {
					var eventy:LocationEvent = new LocationEvent(LocationEvent.LOCATION_Y);
					eventy.oldy = super.y;
					super.y = _y
					dispatchEvent(eventy);
				}
				dispatchEvent(event);
			}
		}
		/**是否锁定大小*/
		public function set LocationBool(value:Boolean):void 
		{
			if(_LocationBool==value)return
			_LocationBool = value
			setLocation(_x,_y)
		}
		public function get LocationBool():Boolean { return _LocationBool; }
		/** 设置组件的X Y坐标*/
		public function setLocation(_x:Number, _y:Number):void{
			//移动坐标被锁定
			if (!LocationBool){
				this._x = _x
				this._y = _y
				return
			}
			//这里还可以添加一些情况下不改变坐标
			if (super.x != _x || super.y != _y) {
				var event:LocationEvent = new LocationEvent(LocationEvent.LOCATION);
				event.oldx = super.x;
				event.oldy = super.y;
				if (super.x != _x) {
					var eventx:LocationEvent = new LocationEvent(LocationEvent.LOCATION_X);
					eventx.oldx = super.x;
					super.x = _x
					this._x = _x
					dispatchEvent(eventx);
				}
				if (super.y != _y) {
					var eventy:LocationEvent = new LocationEvent(LocationEvent.LOCATION_Y);
					eventy.oldy = super.y;
					super.y = _y
					this._y = _y
					dispatchEvent(eventy);
				}
				
				dispatchEvent(event);
			}
		}
		/**设置X坐标*/
		override public function set x(value:Number):void{
			if (x == value) return;
			setLocation(value,y)
		}
		override public function get x():Number{return super.x;}
		/**设置Y坐标*/
		override public function set y(value:Number):void{
			if (super.y == value) return;
			setLocation(x,value)
		}
		override public function get y():Number{return super.y;}
		/**组件的父级容器*/
		public function get owner():DisplayObjectContainer {
			if (parent &&parent.parent&& parent.parent is Container) return parent.parent 
			else return parent	
		}
		/**组件大小更新*/
		public function upSize():void {
			//trace(this,width,height)
			/*
			//测试使用
			
			this.graphics.clear()
			this.graphics.beginFill(Math.random()*0xffffff,.5)
			this.graphics.drawRect(0,0,this.width,this.height)
			*/
		}
		/*设置组件皮肤*/
		//function get skin():*{}
		//function set skin(value:*):void{}
		
		/**
		 * 破坏所有索引，垃圾回收
		 */
		public function destory():void {
			toolTip = null
			_pLayout.removeEventListener(LayoutMode.UPMODE, pLayoutUpMode)
			_pLayout.removeEventListener(LayoutMode.UPLAYOUT, pLayoutUpLayout)
			_borderMetrics.removeEventListener(EdgeMetrics.UPEDGEMETRICS,upEdgeMetrics)
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (parent) parent.removeEventListener(Event.RESIZE, iniToStageSize)
		}
	}
}