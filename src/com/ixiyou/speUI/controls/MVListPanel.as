package com.ixiyou.speUI.controls 
{
	import com.ixiyou.speUI.controls.skins.MVListPanelSkin;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.core.ISkinComponent
	import com.ixiyou.speUI.core.IListIteam
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite
	import flash.geom.Rectangle;
	[Event(name="upSelect", type="com.ixiyou.events.ListEvent")]
	/**
	 * 内部嵌入一个MVList控件，对列表项实际处理还是直接对list直接进行处理
	 * @author spe
	 */
	public class MVListPanel extends SpeComponent implements ISkinComponent
	{
		protected var _list:MVList = new MVList()
		protected var _bg:DisplayObject
		protected var _listRect:Rectangle = new Rectangle()
		protected var _skin:*
		public function MVListPanel(config:*=null) 
		{
			addChild(_list)
			super(config)
			if (config) {
				if (config.skin != null) skin = config.skin
				if (config.showProperty!=null) showProperty = config.showProperty
				if (config.data != null) data = config.data
			}
			if (!skin) skin = null
			if (width <= 0) this.width = 200
			if (height <= 0) this.height = 150
		}
		/**
		 * 设置选择通过位置
		 * @param	value
		 */
		public function setSelectByIndex(value:uint):void {
			list.setSelectByIndex(value)
		}
		/**
		 * 设置选择
		 */
		public function set select(value:Object):void { list.select = value	}
		public function get select():Object { return list.select; }
		/**设置组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				_skin = value;
				var _skinSprite:Sprite = _skin
				try {
					var _scrollBarSkin:Sprite
					//有背景时候
					if (_skinSprite.getChildByName('_bg')) {
						if (_skinSprite.getChildByName('rectMc')) {
							var rectMc:Sprite=_skinSprite.getChildByName('rectMc') as Sprite
							_listRect.top = rectMc.y
							_listRect.left = rectMc.x
							_listRect.right = _skinSprite.getChildByName('_bg').width - rectMc.x - rectMc.width
							_listRect.bottom=_skinSprite.getChildByName('_bg').height-rectMc.y-rectMc.height
						}else {
							_listRect.left=_listRect.right=_listRect.bottom=_listRect.top=0
						}
						bg = _skinSprite.getChildByName('_bg')
					}
					list.skin = skin
					if (_skinSprite.getChildByName('iteamSkin')) {
						list.iteamRect = new Rectangle(0,0,_skinSprite.getChildByName('iteamSkin').width,_skinSprite.getChildByName('iteamSkin').height)
					}
					/*
					//更换滚动条皮肤
					if (_skinSprite.getChildByName('_scrollBar')) {
						list.getScrollBar.skin = _skinSprite.getChildByName('_scrollBar')
						//upSize()
					}
					if (_skinSprite.getChildByName('iteamTemplate')) {
						list.iteamTemplate = _skinSprite.getChildByName('iteamTemplate') as IListIteam
					}
					*/
					upSize()
				}catch (e:TypeError) {
					skin=new MVListPanelSkin()
				}
			}else if (value == null){skin=new MVListPanelSkin()}
		}
		/**
		 * 装列表项的盒子
		 */
		public function get box():DisplayObjectContainer { return list.box; }
		/**
		 * 删除指定属性值的对象
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @param	allBool 是否全部删除
		 */
		public function removeByProperty(property:String, value:*= null, allBool:Boolean = true):void {
			list.removeByProperty(property,value,allBool)
		}
		/**
		 * 删除指定对象
		 * @param	obj
		 */
		public function remove(obj:Object):void {
			list.remove(obj)
		}
		/**
		 * 删除指定位置的对象
		 * @param	index
		 */
		public function removeAt(index:uint):void {
			list.removeAt(index)
		}
		/**
		 * 添加数据添加末尾
		 * @param	obj
		 */
		public function add(obj:Object):void {			list.add(obj)
		}
		/**
		 * 添加到指定位置
		 * @param	obj 数据
		 * @param	index 添加的指定位置
		 */
		public function addAt(obj:Object, index:uint):void {
			list.addAt(obj,index)
		}
		/**
		 * 是否包含指定对象
		 * @param	value
		 */
		public function containsObj(value:Object):Boolean {return list.containsObj(value)		}
		/**
		 * 搜索指定属性值的对象
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @param	allBool 是否全部搜索
		 */
		public function searchByProperty(property:String, value:*= null, allBool:Boolean = true):* {return list.searchByProperty(property,value,allBool)}
		/**
		 * 搜索指定属性值的对象 [位置]
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @param	allBool 是否全部搜索
		 */
		public function searchByPropertyIndex(property:String, value:*= null, allBool:Boolean = true):* {
			return list.searchByPropertyIndex(property,value,allBool)
		}
		/**
		 * 获取项
		 * @param	value 项目的ID
		 * @return
		 */
		public function getIteamByNum(value:uint):IListIteam {
			return list.getIteamByNum(value)
		}
		/**
		 * 作为表现的属性
		 */
		public function set showProperty(value:String):void {list.showProperty=value}
		public function get showProperty():String{return list.showProperty}
		
		/**
		 * 位于 selectedIndex 处的数据提供程序中的项目
		 */
		public function get selectedIteam():Object{ return list.selectedIteam}
		/**
		 *  选中项目在列表中索引位置
		 */
		public function get selectedIndex():int { return list.selectedIndex; }
		/**
		 * 数据项的区域大小，其实主要还是高的啦
		 */
		public function set iteamRect(value:Rectangle):void 
		{
			list.iteamRect=value
		}
		/**
		 * 防止被修改使用副本
		 */
		public function get iteamRect():Rectangle{return list.iteamRect}
		/**
		 * 显示列表区域
		 */
		public function set listRect(value:Rectangle):void 
		{
			_listRect = value
			upSize()
		}
		public function get listRect():Rectangle { return _listRect; }
		/**
		 * 设置背景
		 */
		public function set bg(value:DisplayObject):void {
			if (_bg == value) return
			if (_bg && this.contains(_bg)) removeChild(_bg)
			_bg = value
			addChildAt(bg, 0)
			bg.x=bg.y=0
			bg.width = width
			bg.height=height
		}
		public function get bg():DisplayObject { return _bg; }
		/**
		 * 设置数据
		 * null 空数据，为删除数据
		 */
		public function set data(value:Array):void {list.data=value}
		public function get data():Array { return list.data}
		/**
		 * 列表组件
		 */
		public function get list():MVList { return _list; }
		/**
		 * 滚动条
		 */
		public function get getScrollBar():MVScrollBar { return list.getScrollBar; }
		/**
		 * 更新组件大小
		 */
		override public function upSize():void {
			if (bg) {
				bg.width = width
				bg.height=height
			}
			if (list) {
				list.x = listRect.left
				list.y = listRect.top
				list.width = width - (listRect.left + listRect.right)
				//trace(list.x,width,(listRect.left+ listRect.right),list.width,list.getScrollBar.width)
				list.height = height - listRect.top - listRect.bottom
				
			}
		}
	}

}