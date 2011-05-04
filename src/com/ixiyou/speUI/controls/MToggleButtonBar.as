package com.ixiyou.speUI.controls 
{
	import com.ixiyou.events.DataSpeEvent;
	import com.ixiyou.events.ResizeEvent;
	import com.ixiyou.events.SelectEvent;
	import com.ixiyou.speUI.controls.skins.MToggleButtonBarSkin1;
	import com.ixiyou.speUI.controls.skins.MToggleButtonBarSkin2;
	import com.ixiyou.speUI.core.HContainer;
	import com.ixiyou.speUI.core.LayoutMode;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.core.ISkinComponent
	import com.ixiyou.managers.CheckManager
	import com.ixiyou.speUI.controls.MCheckButton
	import com.ixiyou.utils.display.DisplayUtil;
	import com.ixiyou.utils.ReflectUtil;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	[Event(name = "select", type = "flash.events.Event")]
	[Event(name="upSelect", type="import com.ixiyou.events.SelectEvent")]
	/**
	 * ToggleButtonBar 控件定义一组水平或垂直按钮，这些按钮保持其选中或取消选中状态。
	 * 在 ToggleButtonBar 控件中，只有一个按钮可以处于选中状态。
	 * 这就意味着，当用户在 ToggleButtonBar 控件中选择一个按钮后，该按钮将保持选中状态直到用户选择其它按钮。 
	 * 
	 * 注意，高的原则:改变高度所有高度跟随改变,宽度组件的宽度，执行改变事件。组件的宽度等于内部的宽度
	 * @author spe
	 */
	public class MToggleButtonBar extends SpeComponent implements ISkinComponent
	{
		//按钮样式
		protected var _skin:*
		//protected var _selectedIndex:int = 0
		//横向布局容器
		protected var _box:HContainer = new HContainer()
		//按钮组
		protected var _btnArr:Array = new Array()
		//数据组
		protected var _data:Array
		//按钮样式
		protected var _headSkin:Sprite
		protected var _middleSkin:Sprite
		protected var _tailSkin:Sprite
		//按钮显示标签
		protected var _showProperty:String = 'label'
		//样式适应皮肤比例
		public var autoSkin:Boolean = true
		//按钮管理器
		protected var _btnManager:CheckManager = new CheckManager(false)

		//默认选择选项 -1不选择
		public var defaultIndex:int = -1
		//默认按钮宽度
		public var defaultBtnWidth:uint=80
		public function MToggleButtonBar(config:*=null) 
		{
			_btnManager.addEventListener("upSelect", upSelect)
			_box.addEventListener(ResizeEvent.WRESIZE,wResize)
			addChild(_box)
			super(config)
			if (config && config.horizontalGap != null) horizontalGap = config.horizontalGap
			else horizontalGap=-1
			if (config) {
				if(config.defaultBtnWidth!=null)defaultBtnWidth=config.defaultBtnWidth
				if(config.defaultIndex!=null)defaultIndex=config.defaultIndex
				if(config.autoSkin!=null)autoSkin=config.autoSkin
				if (config.skin != null) skin = config.skin
				if (config.showProperty!=null) showProperty = config.showProperty
				if (config.data != null) data = config.data
			}
			//if (width <= 0) this.width = 100
			if (height <= 0) this.height = 50
			if (!skin) skin = null
		}
		/**
		 * 宽度改变
		 * @param	e
		 */
		private function wResize(e:ResizeEvent):void {
			dispatchEvent(new ResizeEvent(ResizeEvent.WRESIZE))
		}
		/**
		 * 获取宽度
		 */
		override public function get width():Number { return _box.width; }
		/**
		 * 数据选择更新
		 * @param	e
		 */
		protected function upSelect(e:SelectEvent):void {
			var btn:MCheckButton 
			for (var i:int = 0; i < btnArr.length; i++) 
			{
				btn = btnArr[i] as MCheckButton
				if(btn.parent)btn.parent.setChildIndex(btn,0)
			}
			DisplayUtil.moveTop(selectedBtn)
			dispatchEvent(new SelectEvent(SelectEvent.UPSELECT,selected))
			dispatchEvent(new Event(Event.SELECT))
		}
		/**
		 * 设置选择项目
		 * @param	value
		 */
		public function setSelectedByIndex(value:uint):void 
		{
			if (!btnArr||btnArr.length < 1) return
			if (value >= btnArr.length) value = btnArr.length - 1
			var btn:MCheckButton = btnArr[value];
			btn.select=true
		}
		/**
		 * 设置选择
		 * @param	label
		 */
		public function setSelectedByProperty(property:String,value:*):void {
			if (!btnArr || btnArr.length < 1) return
			var btn:MCheckButton = searchByProperty(property, value)
			if(btn)btn.select=true
		}
		public function get currentHead():MCheckButton{return selected}
		/**
		 * 当前项位置
		 */
		public function get currentIndex():int { return selectedIndex }
		/**
		 * 当前选择位置
		 */
		public function get selectedIndex():int {
			if (!btnManager.dataArr||!btnManager.selected) return -1
			return btnManager.dataArr.indexOf(btnManager.selected)
		}
		/**
		 * 当前选择的数据
		 */
		public function get selected():* {
			if (!btnManager.dataArr || !btnManager.selected) return null
			var btn:MCheckButton = btnManager.selected as MCheckButton 
			if(!btn)return null
			return btn.data
		}
		/**
		 * 当前选择的数据
		 */
		public function get selectedBtn():MCheckButton {
			if (!btnManager.dataArr || !btnManager.selected) return null
			var btn:MCheckButton = btnManager.selected as MCheckButton 
			if(!btn)return null
			return btn
		}
		/**
		 * 间隔
		 */
		public function get horizontalGap():Number { return _box.horizontalGap; }
		public function set horizontalGap(value:Number):void {
			_box.horizontalGap = value;
		}
		/**
		 * 按钮管理器
		 */
		public function get btnManager():CheckManager { return _btnManager; }
		/**
		 * 设置数据
		 * null 空数据，为删除数据
		 */
		public function set data(value:Array):void {
			clearBtn()
			if(value)return
			var btn:MCheckButton
			for (var i:int = 0; i < value.length; i++) 
			{
				if (i == 0) {
					if (headClass) btn = new MCheckButton( {width:defaultBtnWidth,height:height, skin:new headClass(), data:value[i] } )
					else if (middleClass) btn = new MCheckButton( {width:defaultBtnWidth,height:height, skin:new middleClass(), data:value[i] } )
					else btn = new MCheckButton( {width:defaultBtnWidth,height:height, data:value[i] } )
				}else if (i == value.length - 1) {
					if (tailClass) btn = new MCheckButton( {width:defaultBtnWidth,height:height, skin:new tailClass(), data:value[i] } )
					else if (middleClass) btn = new MCheckButton( {width:defaultBtnWidth, height:height,skin:new middleClass(), data:value[i] } )
					else btn = new MCheckButton( {width:defaultBtnWidth,height:height, data:value[i] } )
					
				}else {
					if (middleClass) btn = new MCheckButton( {width:defaultBtnWidth, skin:new middleClass(), data:value[i] } )
					else btn = new MCheckButton( {width:defaultBtnWidth,height:height,data:value[i] } )
				}
				btn.labelAlign=LayoutMode.MIDDLE
				if (value[i][showProperty]) btn.label = value[i][showProperty]
				else btn.label='no data'
				btnManager.push(btn)
				btnArr.push(btn)
				_box.addChild(btn)
			}
			/**
			 * 设置默认选择项目
			 */
			if (defaultIndex >=0&&defaultIndex<btnArr.length) {
				btn = btnArr[defaultIndex] as MCheckButton
				btn.select = true
			}
		}
		//public function get data():Array { return _data; }
		/**
		 * 插入数据
		 * @param	obj
		 */
		public function add(obj:Object):void {
			addAt(obj)
		}
		/**
		 * 插入指定位置
		 * @param	obj
		 * @param	index
		 */
		public function addAt(obj:Object, index:int = -1):void {
			if (index<0||index>btnArr.length)index=btnArr.length
			var btn:MCheckButton
			var oldBtn:MCheckButton
			if (index == 0) {
				if (btnArr.length > 0) {
					oldBtn = btnArr[0] as MCheckButton;
					oldBtn.height=height
					if (middleClass)oldBtn.skin = new middleClass()
				}
				if (headClass) btn = new MCheckButton( {width:defaultBtnWidth,height:height, skin:new headClass(), data:obj } )
				else if (middleClass) btn = new MCheckButton( {width:defaultBtnWidth,height:height, skin:new middleClass(), data:obj } )
				else btn = new MCheckButton( {width:defaultBtnWidth,height:height,data:obj } )
			}else if (index == btnArr.length) {
				if (tailClass) btn = new MCheckButton( { width:defaultBtnWidth,height:height,skin:new tailClass(), data:obj} )
				else if (middleClass) btn = new MCheckButton( {width:defaultBtnWidth,height:height, skin:new middleClass(), data:obj } )
				else btn = new MCheckButton( {width:defaultBtnWidth,height:height, data:obj } )
				if (btnArr.length-1 >= 0) {
					oldBtn = btnArr[btnArr.length-1] as MCheckButton
					if (middleClass)oldBtn.skin = new middleClass()
				}
				
			}else {
				if (middleClass) btn = new MCheckButton( {width:defaultBtnWidth,height:height, skin:new middleClass(), data:obj } )
				else btn = new MCheckButton( {width:defaultBtnWidth,height:height, data:obj } )
			}
			btn.labelAlign=LayoutMode.MIDDLE
			if (obj[showProperty]) btn.label =obj[showProperty]
			else btn.label='no data'
			btnManager.push(btn)
			btnArr.splice(index,0,btn)
			_box.addChildAt(btn,index)
		}
		/**
		 * 搜索指定属性值的对象
		 * @param	property 属性值名
		 * @param	value 属性值 
		 */
		public function searchByProperty(property:String,value:*):MCheckButton {
			for (var i:int=0;i < btnArr.length;i++) 
			{
				var btn:MCheckButton =btnArr[i]
				if (btn.data[property]&&btn.data[property]==value)return btn
			}
			return null
		}
		/**
		 * 删除指定位置
		 * @param	index
		 */
		public function removeAt(index:int = -1):void {
			if (index<0||index > btnArr.length - 1) index = btnArr.length - 1
			if (index < 0) index = 0
			var btn:MCheckButton = btnArr[index];
			if (!btn) return
			if (_box.contains(btn)){_box.removeChild(btn) }
			btnManager.remove(btn)
			btnArr.splice(index,1)
			btn.destory()
			upAddRemoveSkin()
		}
		/**
		 * 删除指定对象
		 * @param	obj
		 */
		public function remove(obj:Object):void {
			var btn:MCheckButton = searchByData(obj)
			if(!btn) return
			if (_box.contains(btn)) { _box.removeChild(btn) }
			btnManager.remove(btn)
			var num:int=btnArr.indexOf(btn)
			if (num != -1) btnArr.splice(num, 1)
			//if(value.select=this.selected)
			btn.destory()
			upAddRemoveSkin()
		}
		/**
		 * 删除指定数据下属性等于某值的项目
		 * @param	property
		 * @param	value
		 * @return
		 */
		public function removeByProperty(property:String,value:*):void{
			var btn:MCheckButton = searchByProperty(property,value)
			if(!btn)return
			remove(btn.data)
		}
		/**
		 * 对象添加删除后样式改变
		 */
		protected function upAddRemoveSkin():void {
			var btn:MCheckButton 
			if (btnArr.length >= 2) {
				btn = btnArr[0] as MCheckButton;
				//trace(btn.skin is headClass)
				if (!(btn.skin is headClass))	btn.skin=new headClass()
				btn = btnArr[btnArr.length - 1] as MCheckButton;
				//trace(btn.data.label,btn.skin is tailClass)
				if (!(btn.skin is tailClass))btn.skin=new tailClass()
			}else {
				btn = btnArr[0] as MCheckButton;
				if (!(btn.skin is middleClass))	btn.skin=new middleClass()
			}
		}
		/**
		 * 搜索指定属性值的对象
		 * @param	property 属性值名
		 * @param	value 属性值 
		 */
		public function searchByData(value:*):MCheckButton {
			for (var i:int=0;i < btnArr.length;i++) 
			{
				var btn:MCheckButton =btnArr[i]
				if (btn.data&&btn.data==value)return btn
			}
			return null
		}
		
		
		/**
		 * 清空所有按钮
		 */
		protected function clearBtn():void {
			var btn:MCheckButton
			for (var i:int = 0; i <btnArr.length; i++) 
			{
				btn= btnArr[i] as MCheckButton
				if (_box.contains(btn)) { _box.removeChild(btn) }
				btnManager.remove(btn)
				btn.destory()
			}
			btnManager.clear()
			_btnArr=new Array()
		}
		public function get btnArr():Array { return _btnArr; }
		/**
		 * 作为表现的属性
		 */
		public function set showProperty(value:String):void {
			if(_showProperty==value)return
			_showProperty = value
			var btn:MCheckButton
			for (var i:int = 0; i < btnArr.length; i++) 
			{
				btn = btnArr[i] as MCheckButton
				if(btn.data[showProperty])btn.label=btn.data[showProperty]
			}
		}
		public function get showProperty():String{return _showProperty}
		/**设置组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				_skin = value;
				var skinSprite:Sprite=_skin
				try {
					if (skinSprite.getChildByName('_head'))_headSkin = skinSprite.getChildByName('_head') as Sprite
					if (skinSprite.getChildByName('_middle'))_middleSkin = skinSprite.getChildByName('_middle')	 as Sprite
					if (skinSprite.getChildByName('_tail'))_tailSkin = skinSprite.getChildByName('_tail') as Sprite
					if (!_middleSkin) new TypeError('不能没有默认皮肤')
					if (!_headSkin)_headSkin = _middleSkin
					if (!_tailSkin)_tailSkin = _middleSkin
					if (autoSkin) {
						if (_height != _middleSkin.height) {
							var hevent:ResizeEvent = new ResizeEvent(ResizeEvent.HRESIZE);
							hevent.oldHeight = _height;
							_height=_middleSkin.height
							dispatchEvent(hevent)
						}
					}
					initSkin()
				}catch (e:TypeError) {
					skin=new MToggleButtonBarSkin1()
				}
			}else if (value == null){skin=new MToggleButtonBarSkin1()}
		}
		
		/**
		 * 初始化皮肤
		 */
		protected function initSkin():void {
			var btn:MCheckButton
			for (var i:int = 0; i < btnArr.length; i++) 
			{
				btn= btnArr[i] as MCheckButton
				if (i == 0) {
					if (headClass) btn.skin = new headClass()
					else if (middleClass) btn.skin =new middleClass()
				}else if (i == btnArr.length - 1) {
					//addChild(new tailClass())
					if (tailClass) btn.skin = new tailClass()
					else if (middleClass) btn.skin =new middleClass()
				}else {
					if (middleClass)btn.skin = new middleClass()
				}
			}
			upSize()
		}
		/**组件大小更新*/
		override public function upSize():void {
			var btn:MCheckButton
			for (var i:int = 0; i < btnArr.length; i++) 
			{
				btn = btnArr[i] as MCheckButton
				btn.height=height
			}
		}
		/**
		 * 头部
		 */
		protected function get headClass():Class {
			return ReflectUtil.getClass(_headSkin)
		}
		/**
		 * 中间默认
		 */
		protected function get middleClass():Class {
			return ReflectUtil.getClass(_middleSkin)
		}
		/**
		 * 尾部
		 */
		protected function get tailClass():Class {
			return ReflectUtil.getClass(_tailSkin)
		}
		/**
		 * 摧毁
		 */
		override public function destory():void {
			super.destory()
			_box.removeEventListener(ResizeEvent.WRESIZE, wResize)
			_btnManager.removeEventListener("upSelect", upSelect)
		}
	}

}