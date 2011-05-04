package com.ixiyou.speUI.controls 
{
	import com.ixiyou.events.ListEvent;
	import com.ixiyou.speUI.collections.SMovieClipBase;
	import com.ixiyou.speUI.controls.skins.MComboBoxSkin;
	import com.ixiyou.speUI.core.IListIteam;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.core.IMComboBase
	import com.ixiyou.speUI.core.ISkinComponent
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.utils.setTimeout;
	[Event(name="upSelect", type="com.ixiyou.events.ListEvent")]
	/**
	 * ComboBox 控件包含下拉列表，用户可从中选择单个值,注意使用皮肤时候组件高度会使用皮肤默认高度
	 * @author spe
	 */
	public class MComboBox extends SpeComponent implements IMComboBase,ISkinComponent
	{
		//列表
		protected var _listPanel:MVListPanel = new MVListPanel()
		//列表高
		protected var _listHeight:uint = 100
		//列表默认出现位置，9宫格位置
		protected var _listDirection:uint = 8
		//皮肤
		protected var _skin:*
		//按钮部分 默认，移上，按下，禁止使用
		protected var _stateBox:SMovieClipBase=new SMovieClipBase()
		//标签
		protected var _arrow:MovieClip
		//文字标题
		protected var _label:TextField
		//文字区域
		protected var _labelRect:Rectangle=new Rectangle()
		//是否启用
		protected var _enabled:Boolean = true
		//目前状态 0,默认1，移上，2按下，3禁止
		protected var _state:uint = 0
		//是否自动适应皮肤
		public var autoSkin:Boolean = true
		//是否按下
		protected var _downBool:Boolean = false
		//是否放开
		protected var _upBool:Boolean = false
		//
		//指定一个用作按钮弹起状态
		protected static var UPSTATE:String = 'upState';
		//指定一个用作按钮经过状态
		protected static var OVERSTATE:String = 'overState';
		//指定一个用作按钮“按下”状态
		protected static var DOWNSTATE:String = 'downState';
		//指定一个用作按钮“禁止使用”状态
		protected static var PDSTATE:String = 'pdState';
		public function MComboBox(config:*=null) 
		{
			addChild(_stateBox)
			//addChild(_listPanel)
			_listPanel.list.addEventListener(ListEvent.ADD_ALLDATA, addAllData)
			_listPanel.list.addEventListener(ListEvent.UPSELECT,upSelect)
			
			if (config) {
				if(config.listDirection!=null)listDirection=config.listDirection
				if(config.autoSkin!=null)autoSkin=config.autoSkin
				if (config.skin != null) skin = config.skin
				if (config.showProperty!=null) showProperty = config.showProperty
				if (config.data != null) data = config.data
			}
			super(config)
			if (width <= 0) this.width = 100
			if (height <= 0) this.height = 50
			if (!skin) skin = null
			this.mouseChildren=false
			initMouse()
		}
		/**
		 * 鼠标事件
		 */
		protected function initMouse():void {
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver)
			addEventListener(MouseEvent.MOUSE_OUT,mouseOut)
		}
		protected function mouseOver(e:MouseEvent):void {
			if (!enabled) {
				goto(4)
				return 
			}
			if (_downBool) goto(3)
			else goto(2)
			
		}
		protected function mouseOut(e:MouseEvent):void {
			if (!enabled) {
				goto(4)
				return 
			}
			goto(1)
		}
		protected function mouseDown(e:MouseEvent):void {
			//trace('down',e.target)
			if (!enabled) {
				goto(4)
				return 
			}
			if (!_downBool) {
				goto(3)
				show()
				e.stopPropagation()
			}
			else {
				if (e.target == this ) {
					goto(1)
					hit()
					e.stopPropagation()
					return
				}
				if (e.target == _listPanel||_listPanel.contains(DisplayObject( e.target))||this.contains(DisplayObject( e.target))) return
				goto(1)
				hit()
				e.stopPropagation()
			}
		}
		/**
		 * 设置选择通过位置
		 * @param	value
		 */
		public function setSelectByIndex(value:uint):void {listPanel.setSelectByIndex(value)}
		/**
		 * 设置选择
		 */
		public function set select(value:Object):void { listPanel.select = value	}
		/**
		 * 设置选择
		 */
		public function get select():Object { return listPanel.select; }
		/**
		 * 显示
		 */
		protected function show():void {
			listDirection=listDirection
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			_downBool = true
		}
		/**
		 * 设置列表出现方位 九宫格
		 */
		public function set listDirection(value:uint):void 
		{
			_listDirection=value
			if (_listPanel) {
				if (stage) {
					if (_listDirection == 1 || _listDirection == 2 || _listDirection == 3 ) {
						_listPanel.x = this.localToGlobal(new Point()).x
						_listPanel.y = this.localToGlobal(new Point()).y - _listPanel.height
					}
					else if (_listDirection == 4) {
						_listPanel.x = this.localToGlobal(new Point()).x-width
						_listPanel.y = this.localToGlobal(new Point()).y
					}else if (_listDirection == 6) {
						_listPanel.x = this.localToGlobal(new Point()).x+width
						_listPanel.y = this.localToGlobal(new Point()).y
					}
					else  {
						_listPanel.x = this.localToGlobal(new Point()).x
						_listPanel.y = this.localToGlobal(new Point()).y + height
					}
					stage.addChild(_listPanel)
				}
			}
		}
		public function get listDirection():uint { return _listDirection; }
		/**
		 * 隐藏
		 */
		protected function hit():void {
			if (_listPanel.parent)_listPanel.parent.removeChild(_listPanel)
			_downBool=false
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			//if(stage)stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
		}
		/**
		 * 添加新数据时候
		 * @param	e
		 */
		protected function addAllData(e:ListEvent=null):void {
			if (data) {_listPanel.select=data[0]			}
		}
		/**
		 *  更新选择
		 * @param	e
		 */
		protected function upSelect(e:ListEvent):void { 
			var obj:Object
			if (e.data) obj = e.data
			else return
			if (obj && obj[this.showProperty] && _label)_label.text = obj[this.showProperty];
			hit()
			dispatchEvent(new ListEvent(e.type,false,false,e.data))
		}
		/**设置组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				_skin = value;
				var _skinSprite:Sprite = _skin
				try {
					var _scrollBarSkin:Sprite
					if(_skinSprite.parent)_skinSprite.parent.removeChild(_skinSprite)
					if (_skinSprite.getChildByName('listPanel')) {
						listPanel.skin=_skinSprite.getChildByName('listPanel')
					}
					if (_skinSprite.getChildByName('_labelBtnBg')) {
						var _labelBtnBg:DisplayObjectContainer=_skinSprite.getChildByName('_labelBtnBg') as DisplayObjectContainer
						if (_labelBtnBg.getChildByName('_' + UPSTATE))_stateBox.replaceLabel(UPSTATE, _labelBtnBg.getChildByName('_' + UPSTATE))
						
						if (_labelBtnBg.getChildByName('_' + OVERSTATE))_stateBox.replaceLabel(OVERSTATE, _labelBtnBg.getChildByName('_' + OVERSTATE))
						else _stateBox.replaceLabel(OVERSTATE, _labelBtnBg.getChildByName('_' + UPSTATE))
						
						if (_labelBtnBg.getChildByName('_' + DOWNSTATE))_stateBox.replaceLabel(DOWNSTATE, _labelBtnBg.getChildByName('_' + DOWNSTATE))
						else _stateBox.replaceLabel(DOWNSTATE, _labelBtnBg.getChildByName('_' + UPSTATE))

						if (autoSkin)_height = _skinSprite.getChildByName('_labelBtnBg').height
						
					}
					if (_skinSprite.getChildByName('_label')) {
						if(_label&&contains(_label))removeChild(_label)
						_label = _skinSprite.getChildByName('_label') as TextField
						addChild(_label)
						if(selectedIteam&&selectedIteam[this.showProperty])_label.text=selectedIteam[this.showProperty]
						_labelRect.top = _label.y
						_labelRect.left = _label.x
						_labelRect.bottom = _stateBox.height - _label.height - _label.y
						_labelRect.right= _stateBox.width - _label.width - _label.x
					}
					if (_skinSprite.getChildByName('_arrow')) {
						if(_arrow&&contains(_arrow))removeChild(_arrow)
						_arrow = _skinSprite.getChildByName('_arrow') as MovieClip
						if(_arrow.totalFrames < 4) new TypeError('不能使用少于4帧的资源文件')
						addChild(_arrow)
					}
					upSize()
					//
				}catch (e:TypeError) {
					trace(e)
					skin=new MComboBoxSkin()
				}
			}else if (value == null){skin=new MComboBoxSkin()}
		}
		/**
		 * 数据项的区域大小，其实主要还是高的啦
		 */
		public function set iteamRect(value:Rectangle):void 
		{
			listPanel.iteamRect=value
		}
		/**
		 * 防止被修改使用副本
		 */
		public function get iteamRect():Rectangle{return listPanel.iteamRect.clone()}
		/**
		 * @inheritDoc
		 */
		override public function upSize():void {
			if (listPanel) {
				listPanel.width = width
				listPanel.height=listHeight
			}
			if (_label) {
				_label.x = _labelRect.left
				_label.y = _labelRect.top
				_label.width = width - _labelRect.left - _labelRect.right
				_label.height=height- _labelRect.top - _labelRect.bottom
			}
			if (_arrow) {
				_arrow.x =_label.x+ _label.width+(_labelRect.right - _arrow.width)/ 2
				_arrow.y=(height-_arrow.height)/2+1
			}
			_stateBox.setAllMovieSize(width,height)
			goto(_state)	
		}
		/**
		 * 帧跳转
		 * @param	value
		 */
		protected function goto(value:uint):void {
			if (!_stateBox||_stateBox.totalFrames<value) return
			_stateBox.gotoAndStop(value)
			if(_arrow)_arrow.gotoAndStop(value)
			if (_stateBox.numChildren < 1) return
		}
		/**
		 * 是否禁止
		 */
		public function set enabled(value:Boolean):void 
		{
			if (_enabled == value) return
			_enabled = value
			if (_enabled) {
				_state=0
				this.mouseEnabled=true
			}else {
				_state=1
				this.mouseEnabled=false
			}
			goto(_state)
		}
		public function get enabled():Boolean { return _enabled; }
		/**
		 * 设置数据
		 * null 空数据，为删除数据
		 */
		public function set data(value:Array):void {listPanel.data=value}
		public function get data():Array { return listPanel.data}
		/**
		 * 设置列表高度
		 */
		public function set listHeight(value:uint):void {
			if (_listHeight == value) return
			_listHeight = value
			listPanel.height=_listHeight
		}
		public function get listHeight():uint { return _listHeight; }
		/**
		 * 列表组件
		 */
		public function get listPanel():MVListPanel { return _listPanel; }
		/**
		 * 作为表现的属性
		 */
		public function set showProperty(value:String):void {listPanel.showProperty=value}
		public function get showProperty():String { return listPanel.showProperty }
		
		/**
		 * 所选项目的数据提供程序中的索引
		 */
		public function get selectedIndex():int{return listPanel.selectedIndex}
		/**
		 * 位于 selectedIndex 处的数据提供程序中的项目
		 */
		public function get selectedIteam():Object{ return listPanel.selectedIteam}
		/**
		 * 位于 selectedIndex 处的数据提供程序中的项目
		 */
		public function get value():Object { return selectedIteam }
		/**
		 * 装列表项的盒子
		 */
		public function get box():DisplayObjectContainer { return listPanel.box; }
		
		public function get labelText():TextField { return _label; }
		/**
		 * 删除指定属性值的对象
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @param	allBool 是否全部删除
		 */
		public function removeByProperty(property:String, value:*= null, allBool:Boolean = true):void {
			listPanel.removeByProperty(property,value,allBool)
		}
		/**
		 * 删除指定对象
		 * @param	obj
		 */
		public function remove(obj:Object):void {
			listPanel.remove(obj)
		}
		/**
		 * 删除指定位置的对象
		 * @param	index
		 */
		public function removeAt(index:uint):void {
			listPanel.removeAt(index)
		}
		/**
		 * 添加数据添加末尾
		 * @param	obj
		 */
		public function add(obj:Object):void {			listPanel.add(obj)}
		/**
		 * 添加到指定位置
		 * @param	obj 数据
		 * @param	index 添加的指定位置
		 */
		public function addAt(obj:Object, index:uint):void { listPanel.addAt(obj, index) }
			/**
		 * 是否包含指定对象
		 * @param	value
		 */
		public function containsObj(value:Object):Boolean {return listPanel.containsObj(value)		}
		/**
		 * 搜索指定属性值的对象
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @param	allBool 是否全部搜索
		 */
		public function searchByProperty(property:String, value:*= null, allBool:Boolean = true):* {return listPanel.searchByProperty(property,value,allBool)}
		/**
		 * 搜索指定属性值的对象 [位置]
		 * @param	property 属性值名
		 * @param	value 属性值 设为null则表示不限制property的值
		 * @param	allBool 是否全部搜索
		 */
		public function searchByPropertyIndex(property:String, value:*= null, allBool:Boolean = true):* {
			return listPanel.searchByPropertyIndex(property,value,allBool)
		}
		/**
		 * 获取项
		 * @param	value 项目的ID
		 * @return
		 */
		public function getIteamByNum(value:uint):IListIteam {
			return listPanel.getIteamByNum(value)
		}
		/**
		 * @inheritDoc
		 */
		override public function destory():void {
			super.destory()
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown)
			//if (stage) stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp)
			_listPanel.list.removeEventListener(ListEvent.ADD_ALLDATA, addAllData)
			_listPanel.list.removeEventListener(ListEvent.UPSELECT,upSelect)
		}
		
	}

}