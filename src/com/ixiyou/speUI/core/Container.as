package com.ixiyou.speUI.core 
{
	
	/**
	 * 容器基类
	 * 只允许绝对位置对齐
	 * 容器大小根据内部元素决定,并且是指允许绝对位置对其
	 * @author 
	 */
	import flash.display.DisplayObject
	import flash.display.Shape;
	import flash.display.Sprite
	import flash.display.DisplayObjectContainer
	import flash.events.Event
	import com.ixiyou.events.LocationEvent
	import com.ixiyou.events.ResizeEvent
	public class Container extends ContainerBase implements IContainer
	{
		//容器内部布局方式
		protected var _nlayout:LayoutMode = new LayoutMode()
		//容器内布局纵向间隔
		private var _verticalGap:Number = 0;
		//容器内布局横向间隔
		private var _horizontalGap:Number = 0;

		public function Container(config:*=null) 
		{
			
			super(config)
			if (config) {
				if (config.verticalGap != null)
					verticalGap = config.verticalGap;
				if (config.horizontalGap != null)
					horizontalGap = config.horizontalGap;
				if (config.layout != null)
					setLayout(config.layout)
				else setLayout(LayoutMode.ABSOLUTE)
			}
		}
		/**设置容器对齐方式*/
		public function setLayout(value:String):void {
			//只允许绝对位置对齐方式
			if (value != LayoutMode.ABSOLUTE) {
				nLayout.align= LayoutMode.ABSOLUTE
				return
			}
			nLayout.align=value
			layoutChilds()
		}
		/**容器内部对齐方式*/
		public function get nLayout():LayoutMode{return _nlayout}
		/**执行对内部元素布局*/
		public function layoutChilds():void {
			//判断容器是否绝对对齐
			if (this.nLayout.align == LayoutMode.ABSOLUTE)Layout_absolute()
		}
		/** 内部布局 ,绝对位置*/
		protected function Layout_absolute():void
		{
			if(this.nLayout.align!=LayoutMode.ABSOLUTE)return
			var maxW:Number = 0;
			var maxH:Number = 0;
			var child:DisplayObject 
			var component:SpeComponent
			var i:int
			//有上级，是容器，是布局容器，还是自身还是自动适应
			if (parent&&parent is ILayoutContainer && this.autoSize) {
				maxW = parent.width
				maxH=parent.height
			}else {
				for ( i= 0; i < numChildren; i++)
				{	
					child = getChildAt(i);
					if (child is SpeComponent) {
						component = child as SpeComponent
						if (!component.autoSize) {
							if(component.x + component.width > maxW)maxW = component.x  + component.width 
							if(component.y + component.height> maxH)maxH = component.y + component.height
						}
						else {
							component.layoutLocation(0,0)
						}
					}else {
						if(child.x + child.width > maxW)maxW = child.x + child.width;
						if (child.y + child.height > maxH)maxH = child.y + child.height;
					}
				}
			}
			setSize(maxW, maxH)
		}
		/**纵向间隔*/
		public function set verticalGap(value:Number):void
		{
			if(_verticalGap==value)return
			_verticalGap = value
			layoutChilds()
		}
		public function get verticalGap():Number{return _verticalGap;}
		/**横向间隔*/
		public function set horizontalGap(value:Number):void
		{
			if (horizontalGap == value) return
			_horizontalGap = value;
			layoutChilds()
		}
		public function get horizontalGap():Number{return _horizontalGap;}
		/**纵向对齐*/
		public function get verticalAlign():String{return nLayout.verticalAlign}
		/**横向对齐*/
		public function get horizontalAlign():String { return nLayout.horizontalAlign}	
		
		
		/**重写添加显示对象方法*/
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			
			return addChildAt(child, numChildren);
		}
		/**重写添加显示对象到层方法*/
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			//try {
               if (child.parent && child.parent.parent && child.parent.parent is IContainer) {
					var formerParent:DisplayObjectContainer = child.parent.parent;
					formerParent.removeChild(child);
				}
				
				if (index > numChildren) index = numChildren
				
				_box.addChildAt(child, index);
				child.addEventListener(Event.RESIZE,childResize)
				if (child is SpeComponent) SpeComponent(child).addEventListener(SpeComponent.AUTO_SIZE, childAutoSize)
				layoutChilds()
           // }
           // catch(e:TypeError) {
             //   trace(e);
            //}
			return child;
		}
		//子对象自动适应时候
		protected function childAutoSize(e:Event):void {
			try{
				var child:SpeComponent=e.target as SpeComponent
				if (this.contains(child)) {
					//做处理
				}
				else {
					//trace("非子级删除")
					child.removeEventListener(SpeComponent.AUTO_SIZE, childAutoSize)
				}
			}catch(e:ArgumentError){
				trace(e.toString()+" 错误：组件子级，事件对象不是显示对象类型")
			}
		}
		//子对象大小变化
		protected function childResize(e:Event):void {
			try{
				var child:DisplayObject=e.target as DisplayObject
				if (this.contains(child)) 
					layoutChilds()
				else
					child.removeEventListener(Event.RESIZE, childResize)
			}catch(e:ArgumentError){
				trace(e.toString()+" 错误：组件子级，事件对象不是显示对象类型")
			}
		}
		/**重写删除显示对象方法*/
		override public function removeChild(child:DisplayObject):DisplayObject {
			return removeChildAt(getChildIndex(child));
		}
		/**
		 * 重写删除指定层显示对象方法
		 * @param	index 删除什么位置的对象
		 * @return 删除的对象
		 */
		override public function removeChildAt(index:int):DisplayObject 
		{
			var temp:DisplayObject = _box.removeChildAt(index);
			if (temp is SpeComponent) SpeComponent(temp).removeEventListener(SpeComponent.AUTO_SIZE, childAutoSize)
			temp.removeEventListener(Event.RESIZE, childResize)
			layoutChilds()
			return temp
		}
		
		/**
		 * 破坏所有索引，垃圾回收
		 */
		override public function destory():void {
			super.destory()
			var temp:DisplayObject
			for (var i:int = 0; i < numChildren; i++) 
			{
				temp = getChildAt(i);
				if (temp is SpeComponent) SpeComponent(temp).removeEventListener(SpeComponent.AUTO_SIZE, childAutoSize)
				temp.removeEventListener(Event.RESIZE, childResize)
			}
		}
	}	
}