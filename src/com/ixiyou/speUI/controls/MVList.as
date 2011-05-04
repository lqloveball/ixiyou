package com.ixiyou.speUI.controls 
{

	/**
	 * V列表组件
	 * 注意skin皮肤实现方式，与皮肤使用与其他组件有区别
	 * @author ...
	 */
	import com.ixiyou.geom.ScrollType;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.core.ISkinComponent
	import com.ixiyou.events.ListEvent;
	import com.ixiyou.utils.ArrayUtil;
	import com.ixiyou.utils.ReflectUtil;
	import com.ixiyou.speUI.core.IListBase;
	import com.ixiyou.speUI.core.IListIteam;
	import com.ixiyou.speUI.controls.listClasses.ListIteamDefault;
	import com.ixiyou.speUI.controls.skins.MVListSkin;
	import com.ixiyou.speUI.collections.MSprite;
	import com.ixiyou.utils.layout.ArrangeShowUtil;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent
	import flash.utils.getTimer;
	[Event(name = "removeData", type = "com.ixiyou.events.ListEvent")]
	[Event(name = "removeAllData", type = "com.ixiyou.events.ListEvent")]
	[Event(name = "addData", type = "com.ixiyou.events.ListEvent")]
	[Event(name = "addAllData", type = "com.ixiyou.events.ListEvent")]
	[Event(name="upSelect", type="com.ixiyou.events.ListEvent")]
	public class MVList extends SpeComponent implements IListBase,ISkinComponent
	{
		//用来装列表的盒子
		protected var _boxMask:Shape=new Shape()
		protected var _box:MSprite = new MSprite()
		protected var scrollBar:MVScrollBar
		protected var _hideType:String=MVScrollBar.HITSSLIDER
		//列表数据
		protected var _data:Array=new Array()
		//生成项目列表
		protected var _iteamArr:Array
		//默认作为显示的标识
		protected var _showProperty:String = "label"
		//删除时候是否直接摧毁组件
		public var removeDestory:Boolean = true
		//项的范本，用来获取项的类使用
		protected var _iteamTemplate:IListIteam
		//项的skin样式
		protected var _iteamSkin:Sprite
		//整体皮肤
		protected var _skin:*
		//项的区域
		protected var  _iteamRect:Rectangle = new Rectangle()
		//
		protected var _selectMouseModel:String=MouseEvent.MOUSE_DOWN
		//选中数据
		protected var _select:Object
		//是否允许多选
		protected var _selectMore:Boolean=false
		//当前现在显示项位置
		public function MVList(config:*=null) 
		{
			_box.autoSize = true;
			addChild(_box);
			_boxMask.graphics.beginFill(0x0);
			_boxMask.graphics.drawRect(0, 0, 10, 10);
			addChild(_boxMask);
			_box.mask = _boxMask;
			scrollBar = new MVScrollBar();
			addChild(scrollBar);
			scrollBar.content = _box
			scrollBar.addEventListener(Event.SCROLL,scroll)
			super(config)
			if (config) {
				if (config.iteamTemplate!=null)iteamTemplate=config.iteamTemplate
				if (config.skin != null) skin = config.skin
				if (config.removeDestory!=null) removeDestory = config.removeDestory
				if (config.showProperty!=null) showProperty = config.showProperty
				if (config.data != null) data = config.data
			}
			if(skin==null)skin=null
			if (width <= 0) this.width = 200
			if (height <= 0) this.height = 150
			iniMouse()
		}
		
		/**设置组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				_skin = value;
				var _skinSprite:Sprite=_skin
					try {
						var _scrollBarSkin:Sprite
						//更换滚动条皮肤
						if (_skinSprite.getChildByName('_scrollBar')) {
							scrollBar.skin = _skinSprite.getChildByName('_scrollBar')
							upSize()
						}
						if (_skinSprite.getChildByName('iteamTemplate')) {
							iteamTemplate = _skinSprite.getChildByName('iteamTemplate') as IListIteam
							//trace('iteamTemplate')
						}
						if (_skinSprite.getChildByName('iteamSkin')) {
							iteamSkin = _skinSprite.getChildByName('iteamSkin') as Sprite
							
						}
					}catch (e:TypeError) {
						//trace(e)
						skin=new MVListSkin()
					}
			}else if (value == null){skin=new MVListSkin()}
		}
		/**
		 * 数据项的区域大小，其实主要还是高的啦
		 */
		public function set iteamRect(value:Rectangle):void 
		{
			_iteamRect=value
			clearDraw()
			draw()
		}
		/**
		 * 防止被修改使用副本
		 */
		public function get iteamRect():Rectangle{return _iteamRect.clone()}
		/*
		 * 数据项的皮肤，注意主要还是靠iteamTemplate决定，skin 只是考虑皮肤做的很准确情况下作替换使用，特别是项区域高度
		*/
		 public function set iteamSkin(value:Sprite):void 
		{
			if (_iteamSkin == value) return
			_iteamSkin = value
			_iteamRect.width = value.width
			_iteamRect.height = value.height
	
			//trace(iteamRect)
			clearDraw()
			draw()
		}
		public function get iteamSkin():Sprite { return _iteamSkin; }
		/**
		 * 项目的样式，对应有写项目需要样式的使用
		 */
		public function get iteamSkinClass():Class {
			if (iteamSkin) return ReflectUtil.getClass(iteamSkin)
			return null
		}
		/**
		 * 数据项的类范本
		 */
		public function set iteamTemplate(value:IListIteam):void {
			if (_iteamTemplate == value) return
			_iteamTemplate = value
			if(_iteamTemplate is DisplayObject) var obj:DisplayObject = _iteamTemplate as DisplayObject
			else return
			//trace(iteamTemplate)
			_iteamRect.width = obj.width
			_iteamRect.height = obj.height
			clearDraw()
			draw()
		}
		/**
		 * 数据项的类范本
		 */
		public function get iteamTemplate():IListIteam { return _iteamTemplate }
		/**
		 * 数据项的类
		 */
		public function get iteamClass():Class {
			if (iteamTemplate) return ReflectUtil.getClass(iteamTemplate)
			else return ListIteamDefault
		}
		/**
		 * 获取项
		 * @param	value 项目的ID
		 * @return
		 */
		public function getIteamByNum(value:uint):IListIteam {
			//不存在数据
			if (!data || !iteamArr) return null
			//超出数据索引范围
			if (value >= data.length) return null
			var temp:IListIteam 
			var obj:DisplayObject
			if (_iteamArr[value] == null) {
				temp = new iteamClass() as IListIteam
				if (iteamSkinClass) temp.skin = new iteamSkinClass()
				DisplayObject(temp).height=_iteamRect.height
				temp.showProperty = showProperty
				temp.data = data[value];
				_iteamArr[value] =temp
				obj = temp as DisplayObject
				obj.y=value*_iteamRect.height
				//box.addChild(obj)
				return temp
			}
			else {
				temp = _iteamArr[value] as IListIteam
				DisplayObject(temp).height=_iteamRect.height
				obj = temp as DisplayObject
				obj.y=value*_iteamRect.height
				return temp
			}
			return null;
		}
		/**
		 * 清除绘制，进行重新绘图使用
		 */
		public function clearDraw():void {
			if (_iteamArr) {
				for (var i:int = 0; i < _iteamArr.length; i++) 
				{
					if (_iteamArr[i] != null) {
						//对项进行摧毁操作
						if ( _iteamArr[i] is IListIteam) {
							var temp:IListIteam = _iteamArr[i] as IListIteam
							//进行摧毁
							temp.destory()
						}
						//对项删除显示列表操作
						if (_iteamArr[i] is DisplayObject) {
							var display:DisplayObject = _iteamArr[i] as DisplayObject
							if(_box.contains(display))_box.removeChild(display)
						}
					}
				}
			}
			if (data && data.length > 0)_iteamArr = new Array(data.length)
			else _iteamArr=new Array(0)
		}
		/**
		 * 绘制
		 */
		protected function draw():void {
			if (!data) return
			
			//clearDraw()
			box.height = _iteamRect.height * data.length
			scrollBar.upSlider()
			var arr:Array=ArrangeShowUtil.getVTileViewArr(iteamRect,new Rectangle(box.x,box.y,box.width,box.height),new Rectangle(0,0,width,height))
			var i:int
			var addArr:Array = new Array()
			var removeArr:Array = new Array()
			for (i = 0; i < _box.numChildren; i++) 
			{
				removeArr.push(_box.getChildAt(i))
			}
			//trace(iteamRect)
			for ( i= 0; i < arr.length; i++) 
			{
				var temp:IListIteam = getIteamByNum(arr[i])
				addArr.push(temp)
				
				if(temp&&temp.data==select)temp.select=true
				if (temp) {
					if(!_box.contains(DisplayObject(temp)))_box.addChild(DisplayObject(temp))
				}
			}
			for (i = 0; i < removeArr.length; i++) 
			{
				if (!ArrayUtil.inArr(addArr, removeArr[i])) {
					var obj:DisplayObject = removeArr[i] as DisplayObject
					if(_box.contains(obj))_box.removeChild(obj)
				}
			}
			
		}
		/**
		 * 鼠标事件，允许继承修改，方便修改扩展功能
		 */
		protected function iniMouse():void {
			if (selectMouseModel == MouseEvent.MOUSE_DOWN) {
				box.removeEventListener(MouseEvent.CLICK, mouseCLICK)
				box.addEventListener(MouseEvent.MOUSE_DOWN,mouseCLICK)
			}else {
				box.addEventListener(MouseEvent.CLICK, mouseCLICK)
				box.removeEventListener(MouseEvent.MOUSE_DOWN,mouseCLICK)
			}
			
		}
		/**
		 * 鼠标点击事件
		 * @param	e
		 */
		protected function mouseCLICK(e:MouseEvent):void {
			var tmep:DisplayObject=e.target as DisplayObject
			while (!(tmep is IListIteam)) tmep = tmep.parent
			var temp2:IListIteam=tmep as IListIteam
			select=temp2.data
		}
		/**
		 * 搜索指定属性值的对象
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @param	allBool 是否全部搜索
		 * @return  null为空
		 */
		public function searchByProperty(property:String, value:*= null, allBool:Boolean = true):* {
			var result:Array = null
			var i:int
			for (i=0;i < data.length;i++) 
			{
				var obj:Object =data[i]
				if (obj.hasOwnProperty(property)) {
					if (value && obj[property] == value || value == null) {
						if (result == null) result = new Array()
						result.push(obj)
					}
				}
			}
			if (result && result.length > 0) {
				if (allBool) return result
				else return result[0]
			}else return result
		}
		/**
		 * 是否包含指定对象
		 * @param	value
		 */
		public function containsObj(value:Object):Boolean {
			var num:int = data.indexOf(value)
			if (num == -1) return false
			else return true
		}
		/**
		 * 搜索指定属性值的对象 [位置]
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @param	allBool 是否全部搜索
		 */
		public function searchByPropertyIndex(property:String, value:*= null, allBool:Boolean = true):* {
			var result:Array = null
			var i:int
			for (i=0;i < data.length;i++) 
			{
				var obj:Object =data[i]
				if (obj.hasOwnProperty(property)) {
					if (value && obj[property] == value || value == null) {
						if (result == null) result = new Array()
						result.push(i)
					}
				}
			}
			if (result && result.length > 0) {
				if (allBool) return result
				else return result[0]
			}else return result
		}
		/**
		 * 搜索对象所在位置
		 * @param	value 对象
		 * @return -1就是没找到指定对象
		 */
		public function getIndexByObj(value:Object):int { return data.indexOf(value) }
		/**
		 * 设置选择通过位置
		 * @param	value
		 */
		public function setSelectByIndex(value:uint):void {
			if(!data||data.length==0)return
			if (data.length <= value) value = data.length - 1
			select=data[value]
		}
		/**
		 * 设置选中的数据  null或不存在数据做删除选择处理,Array做多选处理,Object做单选处理.
		 */
		public function set select(value:Object):void {	
			if (_select == value) return
			var arr:Array
			var num:uint
			var i:int
			var temp:IListIteam
			//删除操作
			if (_select) {
				//多项删除选择
				if (_select is Array) {
					arr = _select as Array
					for (i= 0; i < arr.length; i++) 
					{
						num = getIndexByObj(arr[i]) 
						if (num >= 0) {
							temp = getIteamByNum(num)
							if(temp)temp.select=false
						}
					}
				}else {
					//单选删除
					num = getIndexByObj(_select) 
					if(num<0)return
					temp = getIteamByNum(num)
					if(temp)temp.select=false
				}
			}
			//值为null做删除处理
			if(value==null)return
			//选择中处理
			//多选
			if (value is Array) { 
				selectMore(value as Array)
			}else {
				selectOne(value)
			}
		}
		/**
		 * 选择中项目
		 */
		public function get select():Object { return _select }
		/**
		 * 单选
		 * @param	value
		 */
		private function selectOne(value:Object):void {
			var num:int
			var temp:IListIteam
			//单选
			if (containsObj(value)){
				_select = value;
				num = getIndexByObj(value) ;
				temp = getIteamByNum(num);
				if (temp) temp.select = true;
				dispatchEvent(new ListEvent(ListEvent.UPSELECT,false,false,_select))
			}
		}
		/**
		 * 多选
		 * @param	arr
		 */
		private function selectMore(arr:Array):void {
			var num:uint
			var i:int
			var temp:IListIteam
			if (arr.length == 0){return}
			if (arr.length == 1) {
				num = getIndexByObj(arr[0]) 
				if(num!=-1) {
					temp = getIteamByNum(num)
					if (temp) { temp.select = true }
					_select = arr[0];
					dispatchEvent(new ListEvent(ListEvent.UPSELECT,false,false,_select))
				}
				return 
			}
			//确定多项
			_select = arr
			for (i = 0; i <arr.length ; i++) 
			{
				num = getIndexByObj(arr[i]) 
				if (num >= 0) {
					temp = getIteamByNum(num)
					if(temp)temp.select=true
				}
			}
			dispatchEvent(new ListEvent(ListEvent.UPSELECT,false,false,_select))
		}
		
		/**
		 * 选择中项目等同select
		 */
		public function get selectedIteam():Object { return select; }
		/**
		 * 选中项目在列表中索引位置
		 */
		public function get selectedIndex():int {
			if (!data) return -1 
			else return data.indexOf(_select); 
		}
		/**
		 * 设置数据
		 * null 空数据，为删除数据
		 */
		public function set data(value:Array):void {
			if (_data == value) return
			if(value)_data = value
			else _data=new Array()
			//初始化位置
			box.y = box.x = 0
			if (data) {
				box.height = _iteamRect.height * data.length
				_iteamArr = new Array(data.length)
			}
			else {
				box.height = 0
			}
			scrollBar.upSlider()
			clearDraw()
			draw()
			if (value) dispatchEvent(new ListEvent(ListEvent.ADD_ALLDATA))
			else dispatchEvent(new ListEvent(ListEvent.REMOVE_AllDATA))
		}
		public function get data():Array { return _data}
		/**
		 * 项的列表
		 */
		public function get iteamArr():Array {return _iteamArr}
		/**
		 * 添加数据添加末尾
		 * @param	obj
		 */
		public function add(obj:Object):void {

			data.push(obj)
			if (data) box.height = _iteamRect.height * data.length
			scrollBar.upSlider()
			draw()
			dispatchEvent(new ListEvent(ListEvent.ADD_DATA))
		}
		/**
		 * 添加到指定位置
		 * @param	obj 数据
		 * @param	index 添加的指定位置
		 */
		public function addAt(obj:Object, index:uint):void {
			if (index > data.length) return
			data.splice(index, 0, obj)
			//-start---因为是中间添加插入，需要直接创建显示对象
			var temp:IListIteam = new iteamClass() as IListIteam
			temp.showProperty = showProperty
			temp.data = data[index];
			_iteamArr.splice(index, 0, temp)
			//-end-------
			if (data) box.height = _iteamRect.height * data.length
			scrollBar.upSlider()
			draw()
			dispatchEvent(new ListEvent(ListEvent.ADD_DATA))
		}
		/**
		 * 删除指定对象
		 * @param	obj
		 */
		public function remove(obj:Object):void {
			var num:int = data.indexOf(obj)
			if (num == -1) return 
			removeAt(num)
		}
		/**
		 * 删除指定位置的对象
		 * @param	index
		 */
		public function removeAt(index:uint):void {

			if (index > data.length) return
			data.splice(index, 1)
			var temp:IListIteam =_iteamArr[index] as IListIteam
			_iteamArr.splice(index, 1)
			if (temp) temp.destory()
			if (data) box.height = _iteamRect.height * data.length
			scrollBar.upSlider()
			draw()
			dispatchEvent(new ListEvent(ListEvent.REMOVE_DATA))
		}
		/**
		 * 删除指定属性值的对象
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @param	allBool 是否全部删除
		 */
		public function removeByProperty(property:String, value:*= null, allBool:Boolean = true):void {
			var result:Array = null
			var i:int
			//var o:uint=getTimer()
			for (i=0;i < data.length;i++) 
			{
				var obj:Object = data[i]
				if (obj[property]) {
					if (value && obj[property] == value || value == null) {
						if (result == null) result = new Array()
						result.push(obj)
						if (!allBool)break
					}
				}
			}
			if (result && result.length > 0) {
				if (allBool)
					for (i = 0; i < result.length; i++) remove(result[i])
				else remove(result[0])
			}
		}
		/**
		 * 数据滚动时候
		 * @param	e
		 */
		private function scroll(e:Event):void {
			draw()
		}
			
		/**
		 * 作为表现的属性
		 */
		public function set showProperty(value:String):void {
			if (_showProperty == value) return
			_showProperty = value
			clearDraw()
			draw()
		}
		public function get showProperty():String { return _showProperty }
		/**
		 * 隐藏模式
		 */
		public function get hideType():String { return _hideType; }
		
		public function set hideType(value:String):void 
		{
			if (_hideType == value) return 
			_hideType = value
			scrollBar.hideType=_hideType
			draw()
		}
		/**
		 * 重写调整大小
		 */
		override public function upSize():void {
			if (hideType == MVScrollBar.HITSSLIDER)_boxMask.width = width - scrollBar.width
			else _boxMask.width=width
			_boxMask.height = height
			box.width = width
			scrollBar.x = width - scrollBar.width
			scrollBar.height = height
			draw()
		}
		/**
		 * 装列表项的盒子
		 */
		public function get box():DisplayObjectContainer { return _box; }
		/**
		 * 滚动条
		 */
		public function get getScrollBar():MVScrollBar { return scrollBar; }
		
		public function get selectMouseModel():String { return _selectMouseModel; }
		
		public function set selectMouseModel(value:String):void 
		{
			if (_selectMouseModel == value) return 
			_selectMouseModel = value
			iniMouse()
		}
		/**
		 * 摧毁事件机制
		 */
		override public function destory():void {
			super.destory()
			box.removeEventListener(MouseEvent.CLICK,mouseCLICK)
		}
	}
	
}