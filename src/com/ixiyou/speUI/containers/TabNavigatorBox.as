package com.ixiyou.speUI.containers 
{
	import com.ixiyou.events.ResizeEvent;
	import com.ixiyou.speUI.collections.TabBox;
	import com.ixiyou.speUI.controls.MToggleButtonBar;
	import com.ixiyou.speUI.core.SpeComponent;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * 拥有ToggleButtonBar按钮控制组与Tabbox切换显示
	 * @author spe
	 */
	public class TabNavigatorBox extends SpeComponent
	{
		//标签按钮
		protected var _btnBar:MToggleButtonBar = new MToggleButtonBar()
		protected var _btnMask:Shape=new Shape()
		//显示区域
		protected var _tabBox:TabBox = new TabBox()
		protected var _tabRect:Rectangle = new Rectangle()
		protected var _btnRect:Rectangle=new Rectangle()
		public function TabNavigatorBox(config:*=null) 
		{
			//btnBar.defaultIndex=0
			_btnMask.graphics.beginFill(0)
			_btnMask.graphics.drawRect(0,0,10,10)
			tabBox.addEventListener(Event.SELECT,boxSelect)
			btnBar.addEventListener(ResizeEvent.HRESIZE,headHReSize)
			btnBar.addEventListener(ResizeEvent.WRESIZE, headWReSize)
			btnBar.addEventListener(Event.SELECT,btnSelect)
			addChild(btnBar)
			addChild(tabBox)
			addChild(_btnMask)
			btnBar.mask=_btnMask
			super(config)
			if (config) {
				if(config.headWidth!=null)headWidth=config.headWidth
				if(config.headGap!=null)headGap=config.headGap
			}
			if (width <= 0) this.width = 300
			if (height <= 0) this.height = 100
		}
		private function btnSelect(e:Event):void {
			this.setTabByIndex(btnBar.selectedIndex)
		}
		private function boxSelect(e:Event):void {
			btnBar.setSelectedByIndex(currentIndex)
		}
		/**
		 * 滑块间距离
		 */
		public function get headGap():int{ return btnBar.horizontalGap; }
		public function set headGap(value:int):void 
		{
			btnBar.horizontalGap=value
		}
		/**
		 * 默认按钮宽度
		 */
		public function set headWidth(value:uint):void 
		{
			btnBar.defaultBtnWidth=value
		}
		public function get headWidth():uint { return btnBar.defaultBtnWidth; }
		
		/**
		 * 宽度发生改变
		 * @param	e
		 */
		private function headWReSize(e:ResizeEvent):void 
		{
			trace(width,btnBar.width)
		}
		/**
		 *  高度发生改变
		 * @param	e
		 */
		private function headHReSize(e:ResizeEvent):void 
		{
			if (height > btnBar.height) {
				trace('headHReSize')
				upSize()
			}
			else {
				setSize(width,btnBar.height)
			}
		}
		
		/**
		 * 当前帧，如果是-1那就说当前没显示对象帧
		 */
		public function get currentIndex():int { return tabBox.currentIndex; }
		/**
		 * 标签列表
		 */
		public function get tabList():Array { return tabBox.tabList; }
		/**
		 *  总标签数
		 */
		public function get tabLength():uint { return tabBox.tabLength; }
		/**
		 * 当前标签
		 */
		public function get nowLabel():String { return tabBox.nowLabel; }
		/**
		 * 按钮组
		 */
		public function get btnBar():MToggleButtonBar { return _btnBar; }
		/**
		 * 背景组
		 */
		public function get tabBox():TabBox { return _tabBox; }
		/**
		 * 替换指定标签帧 有指定标签存在，使用替换,没有指定标签存在就创建一个
		 * @param	label 
		 */
		public function replaceLabel(label:String, value:DisplayObjectContainer):void {
			tabBox.replaceLabel(label, value)
		}
		/**
		 * 添加标签容器
		 * @param	label
		 * @param	value
		 * @param	index
		 * @return
		 */
		public function addTab(label:String, value:DisplayObjectContainer = null, index:int = -1):Object {
			if(!value)value=new Sprite()
			btnBar.addAt( { label:label, value:value },index )
			if(btnBar.btnArr.length==1)btnBar.setSelectedByIndex(0)
			return tabBox.addTab(label, value, index)
		}
		
		/**
		 * 删除指定序列tab
		 * @param	index
		 * @return
		 */
		public function removeIndex(index:int = -1):Object {
			var obj:Object = tabBox.removeIndex(index)
			btnBar.removeAt(index)
			return obj
		}
		/**
		 * 删除指定序列tab
		 * @param	index
		 * @return
		 */
		public function removeLabel(label:String):Object {
			var obj:Object = tabBox.removeLabel(label)
			btnBar.removeByProperty('label',label)
			return obj
		}
		/**
		 * 清楚所有序列tab
		 */
		public function clearTab():void {
			tabBox.clearTab()
			btnBar.data=null
		}
		/**
         * 是否存在某个标签
         * 
         * @param labelName
         * @return 
         * 
         */
        public function hasLabel(label:String):Boolean { return tabBox.hasLabel(label) }
		/**
         * 获得标签的序号
         *  
         * @param labelName
         * @return 
         * 
         */
        public function getLabelIndex(label:String):int  { return tabBox.getLabelIndex(label) }
		/**
		 * 指定帧的标签
		 * @param	index
		 * @return
		 */
		public function getIndexLabel(index:uint):String { return tabBox.getIndexLabel(index) }
		/**
		 * 指定标签的对象
		 * @param	value
		 */
		public function getIndexObj(index:uint):Object {return tabBox.getIndexObj(index)
		}
		/**
		 * 根据标签获取对象
		 * @param	label
		 * @return
		 */
		public function getLabelObj(label:String):Object {return tabBox.getLabelObj(label)
		}
		/**
		 * 更加标签获取容器
		 * @param	label
		 * @return
		 */
		public function getLabelContainer(label:String):DisplayObjectContainer {
			return tabBox.getLabelContainer(label)
		}
		/**
		 * 根据位置获取容器
		 * @param	index
		 * @return
		 */
		public function getIndexContainer(index:uint):DisplayObjectContainer {
			return tabBox.getIndexContainer(index)
		}
		/**
		 * 设置为显示标签
		 * @param	label
		 */
		public function setTabByLabel(label:String):void 
		{
			tabBox.setTabByLabel(label)
		}
		/**
		 * 设置为第几个标签
		 * @param	value
		 */
		public function setTabByIndex(value:uint):void {
			tabBox.setTabByIndex(value)
		}
		/**
		 * 重新大小发生改变
		 */
		override public function upSize():void {
			if (tabBox) {
				_btnMask.width = width
				_btnMask.height= btnBar.height
				_tabRect.width=width
				_tabRect.height = height - btnBar.height
				_tabRect.y=btnBar.height
				//trace(_tabRect)
				tabBox.setSize(_tabRect.width, _tabRect.height)
				tabBox.y=_tabRect.y
			}
		}
	}

}