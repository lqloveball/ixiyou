package com.ixiyou.speUI.collections 
{
	
	
	/**
	 * 最简单的TAB滑门块,继承于Sprite，只显示一个,显示区域大小使用的是scrollRect
	 * @author spe
	 */
	import com.ixiyou.speUI.collections.OneSprite;
	import com.ixiyou.speUI.core.ISize
	import com.ixiyou.speUI.core.IDestory
	import com.ixiyou.events.ResizeEvent
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Rectangle;
	public class TabBox extends OneSprite implements ISize,IDestory
	{
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
		//判断百分比是高否开启
		protected var percentHeightBool:Boolean = false;
		//talList列表
		protected var _tabList:Array = new Array()
		//当前tab
		protected var _currentIndex:int = -1;
		//总帧数
		protected var _automaticLabel:uint = 0
		//添加给帧的显示对象是否初始化
		public var addTabInitBool:Boolean=true
		//是否适应大小
		public static var AUTO_SIZE:String = 'auto_resize';
		public function TabBox(config:*=null) 
		{
			scrollRect=new Rectangle()
			if (config) {
				if(config.autoSize!=null)
					autoSize = config.autoSize;
				if (config.x !=null)x=config.x
				if (config.y !=null)y=config.y
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
			}
			if (width <= 0) this.width = 200
			if (height <= 0) this.height = 100
			addEventListener(Event.ADDED_TO_STAGE, init);
			//trace(_tabList['--'])
		}
		/**
		 * 当前帧，如果是-1那就说当前没显示对象帧
		 */
		public function get currentIndex():int { return _currentIndex; }
		/**
		 * 标签列表
		 */
		public function get tabList():Array { return _tabList; }
		/**
		 *  总标签数
		 */
		public function get tabLength():uint { return _tabList.length; }
		/**
		 * 当前标签
		 */
		public function get nowLabel():String {
			var obj:Object = getIndexObj(currentIndex)
			if(obj&&obj.label)return obj.label
			return null;
		}
		/**
		 * 替换指定标签帧 有指定标签存在，使用替换,没有指定标签存在就创建一个
		 * @param	label 
		 */
		public function replaceLabel(label:String,value:DisplayObjectContainer):void {
			var obj:Object
			var temp:DisplayObject
			if (hasLabel(label)) {
				obj = getLabelObj(label)
				temp=obj.value
				obj.value = value
				if (contains(temp)) {
					removeChild(temp)
					temp = obj.value
					addChild(temp)
				}
			}else {
				addTab(label,value)
			}
		}
		/**
		 * 添加标签容器
		 * @param	label
		 * @param	value
		 * @param	index
		 * @return
		 */
		public function addTab(label:String=null,value:DisplayObjectContainer=null,index:int=-1):Object {
			if (index < 0||index>tabLength) index = tabLength
			//已经有标签存在
			if(!label&&hasLabel(label))return getLabelObj(label)
			//显示对象归位0.0
			if (addTabInitBool)value.y=value.x=0
			//提供自动命名
			if (label == null) {
				label = String(this.name + _automaticLabel)
				_automaticLabel+=1
			}
			if(!value)value=new Sprite()
			var obj:Object={label:label,value:value}
			_tabList.splice(index, 0, obj)
			if (currentIndex == -1) {
				gotoAndStop(0)
			}
			return obj
		}
		/**
		 * 删除指定序列tab
		 * @param	index
		 * @return
		 */
		public function removeIndex(index:int = -1):Object {
			if(tabLength==0)return null
			if (index < 0||index>=tabLength) index = tabLength-1
			var obj:Object = tabList[index]
			var temp:DisplayObject = obj.value
			if(this.contains(temp))removeChild(temp)
			return obj
		}
		/**
		 * 删除指定序列tab
		 * @param	index
		 * @return
		 */
		public function removeLabel(label:String):Object {
			var obj:Object = getLabelObj(label)
			if(!obj)return null
			var temp:DisplayObject = obj.value as DisplayObject
			if(this.contains(temp))removeChild(temp)
			return obj
		}
		/**
		 *  批量添加序列tab
		 * @param	arr {label:label,value:value}
		 */
		public function addAllTab(arr:Array):void {
			clearTab()
			if (!arr) return
			var obj:Object
			for (var i:int = 0; i <arr.length ; i++) 
			{
				obj = arr[i] as Object;
				if (obj.value && obj.value is DisplayObject) {
					if (obj.label) addTab(obj.value, obj.label)
					else addTab(obj.value)
				}
			}
		}
		/**
		 * 清楚所有序列tab
		 */
		public function clearTab():void {
			if (numChildren > 0) {
				var num:uint=this.numChildren 
				for ( var i:int = 0; i < num; i++) {
					if(getChildAt(0))this.removeChild(getChildAt(0))
				}
			}
			_tabList=new Array()
			_currentIndex=-1
		}
		/**
         * 是否存在某个标签
         * 
         * @param labelName
         * @return 
         * 
         */
        public function hasLabel(label:String):Boolean {
			return getLabelIndex(label) != -1;
		}
		/**
         * 获得标签的序号
         *  
         * @param labelName
         * @return 
         * 
         */
        public function getLabelIndex(label:String):int
        {
        	for (var i:int = 0;i<this.tabList.length;i++)
        	{
        		if (tabList[i].label == label)return i;
        	}
        	return -1;
        }
		
		/**
		 * 指定帧的标签
		 * @param	index
		 * @return
		 */
		public function getIndexLabel(index:uint):String {
			if(tabList[index])return tabList[index].label
			return null
		}
		/**
		 * 指定标签的对象
		 * @param	value
		 */
		public function getIndexObj(index:uint):Object {
			if(tabList[index])return tabList[index]
			return null
		}
		/**
		 * 根据标签获取对象
		 * @param	label
		 * @return
		 */
		public function getLabelObj(label:String):Object {
			var num:int = getLabelIndex(label)
			if (num == -1) return null
			return tabList[num]
		}
		/**
		 * 更加标签获取容器
		 * @param	label
		 * @return
		 */
		public function getLabelContainer(label:String):DisplayObjectContainer {
			var obj:Object = getLabelObj(label)
			if(!obj)return null
			return obj.value;
		}
		/**
		 * 根据位置获取容器
		 * @param	index
		 * @return
		 */
		public function getIndexContainer(index:uint):DisplayObjectContainer {
			var obj:Object = getIndexObj(index)
			if(!obj)return null
			return obj.value;
		}
		/**
		 * 设置为显示标签
		 * @param	label
		 */
		public function setTabByLabel(label:String):void 
		{
			gotoAndStop(label)
		}
		/**
		 * 设置为第几个标签
		 * @param	value
		 */
		public function setTabByIndex(value:uint):void {
			gotoAndStop(value)
		}
		/**
		 * 跳转停止
		 * @param	value可以试帧数也可以帧标签，注意这里的帧开始位置为0开始不是FLASH的1
		 */
		public function gotoAndStop(value:*):void {
			var temp:DisplayObject
			var index:int = -1
			var obj:Object
			if (value is uint) {
				obj = getIndexObj(value)
				if (obj && obj.value) {
					temp = obj.value as DisplayObject
					add(temp)
					index = value
					_currentIndex = index
					dispatchEvent(new Event(Event.SELECT))
				}
				//_currentIndex=index
			}else if (value is String) {
				obj = getLabelObj(value)
				if (obj && obj.value) {
					temp = obj.value as DisplayObject
					add(temp)
					index = getLabelIndex(value)
					_currentIndex = index
					dispatchEvent(new Event(Event.SELECT))
				}
				//_currentIndex=index
			}
		}
		/**
		 * 要求当前只能添加一个显示对象的方法
		 * @param	child
		 * @return
		 */
		public function add(child:DisplayObject):DisplayObject {return adAt(child, numChildren);}
		/**
		 * 要求当前只能添加一个显示对象的方法层方法
		 * @param	child
		 * @param	index
		 * @return
		 */
		public function adAt(child:DisplayObject, index:int):DisplayObject {
			if (numChildren > 0) {
				var num:uint=this.numChildren 
				for ( var i:int = 0; i < num; i++) {
					if(getChildAt(0))this.removeChild(getChildAt(0))
				}
			}
			return addChildAt(child,0)
		}
		/**
		 * 初始化到场景
		 * @param	e
		 */
		private function init(e:Event = null):void {
			if (parent) parent.addEventListener(Event.RESIZE, iniToStageSize)
			ResetSize()
		}
		/**组件父级发生变化时候，判断是否是这个组件父级，是就对组件大小重设，否需要移除监听*/
		private function iniToStageSize(e:Event):void{
			try{
				var d:DisplayObject=e.target as DisplayObject
				if (parent && d == parent)ResetSize()
				else d.removeEventListener(Event.RESIZE, iniToStageSize)
			}catch(e:ArgumentError){
				trace(e.toString()+" 错误：组件父级，事件对象不是显示对象类型")
			}
			
		}
		/**组件大小重设，
		 * 一般在组件被新的容器装载、
		 * 组件边界发生变化时候
		 * 执行大小重设由组件自行计算重设的大小
		 * */
		public function ResetSize():void {
			//父级不存在时候
			if (!parent) return
			//父级是布局类型容器不进行计算大小计算，这方面计算教给容器负责
			//if (owner is IVHContainer || owner is ILayoutContainer)return
			//自动适应大小时候
			if (autoSize) { 
				//父级是场景
				if (parent is Stage) {setSize(Stage(parent).stageWidth,Stage(parent).stageHeight)}
				else setSize(parent.width, parent.height)
			}
			//都是百分比时候
			else if (percentHeightBool && percentWidthBool) {
				//父级是场景
				if (parent is Stage) setSize(Stage(parent).stageWidth * percentWidth , Stage(parent).stageHeight * percentHeight)
				else setSize(parent.width*percentWidth,parent.height*percentHeight)
			}
			else if (percentWidthBool) {
				//父级是场景
				if (parent is Stage) setSize(Stage(parent).stageWidth * percentWidth, height)
				else setSize(parent.width*percentWidth,height)
			}
			else if (percentHeightBool) {
				//父级是场景
				if (parent is Stage) setSize(width, Stage(parent).stageHeight * percentHeight)
				else setSize(width,parent.height*percentHeight)
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
		/** 
		 * 百分比寬度
		 * */
		public function get percentWidth():Number{
			return _percentWidth;
		}
		/**
		 * 百分比寬度
		 * value 0-1
		 */
		public function set percentWidth(value:Number):void{
			if (value < 0&&value>1) return
			if (percentHeight != value)
			{
				if(this.autoSize)autoSize=false
				percentWidthBool = true
				_percentWidth = value;
				ResetSize()
			}
		}
		/** 百分比高度 */
		public function get percentHeight():Number{
			return _percentHeight;
		}
		public function set percentHeight(value:Number):void{
			if (value < 0&&value>1) return
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
		/**自动适应宽高*/
		public function set autoSize(value:Boolean):void{
			if (_autoSize != value)
			{
				_autoSize = value;
				this.dispatchEvent(new Event(BgShape.AUTO_SIZE))
				ResetSize()
			}
		}
		public function get autoSize():Boolean { return _autoSize; }
		/**组件大小更新*/
		public function upSize():void {
			//trace([this.width,this.height])
			var rect:Rectangle=scrollRect
			rect.width = width
			rect.height = height
			scrollRect=rect
		}
		/**
		 * 破坏所有索引，垃圾回收
		 */
		public function destory():void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (parent) parent.removeEventListener(Event.RESIZE, iniToStageSize)
		}
	}

}