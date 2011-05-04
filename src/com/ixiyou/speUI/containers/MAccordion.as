package com.ixiyou.speUI.containers 
{
	import com.ixiyou.events.SelectEvent;
	import com.ixiyou.managers.CheckManager;
	import com.ixiyou.speUI.containers.skins.MAccordionSkin;
	import com.ixiyou.speUI.controls.MCheckButton;
	import com.ixiyou.speUI.core.ContainerBase;
	import com.ixiyou.speUI.core.ISkinComponent;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.controls.MCheckButton;
	import com.ixiyou.utils.ArrayUtil;
	import com.ixiyou.utils.ReflectUtil;
	import caurina.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * Accordion 导航器容器具有一组子容器，但一次只能显示其中一个。
	 * @author spe
	 */
	public class MAccordion extends SpeComponent implements ISkinComponent
	{
	
		//当前可见子容器的从零开始的索引。
		protected var _selectedIndex:int = -1
		//容器列表 
		protected var _contentList:Array = new Array()
		//皮肤
		protected var _skin:*
		//背景
		protected var _bg:DisplayObject
		//默认头部
		protected var _defaultHeader:Class
		//用来装显示对象的盒子
		protected var contentBox:SpeComponent=new SpeComponent()
		//单选管理器
		protected var headerManager:CheckManager = new CheckManager(false)
		protected var _edgeRect:Rectangle=new Rectangle()
		public function MAccordion(config:*=null) 
		{
			
			addChild(contentBox)
			headerManager.addEventListener(SelectEvent.UPSELECT,upSelect)
			super(config)
			if (width <= 0) this.width = 200
			if (height <= 0) this.height = 300
			if(skin==null )skin=null
		}
		/**
		 *  更新选择
		 * @param	e
		 */
		private function upSelect(e:SelectEvent):void {
			var select:MCheckButton = headerManager.selected as MCheckButton
			var num:int = contentList.indexOf(select.data)
			if (num == -1) return
			selectedIndex=num
		}

		/**
		 * 对当前可见子容器的引用。
		 */
		public function get selectedChild():ContainerBase {
			if (contentList.length < 1) return null
			var obj:Object = contentList[selectedIndex]
			if (!obj) return null
			var box:ContainerBase = obj.box as ContainerBase
			
			return box; }
		/**
		 * 当前选择的容器名
		 */
		public function get selectedName():String {
			if (contentList.length < 1) return null
			var obj:Object = contentList[selectedIndex]
			if (!obj) return null
			//var box:ContainerBase=obj.box as ContainerBase
			//var header:MCheckButton = obj.header as MCheckButton
			return obj.name as String;
		}
		public function set selectedIndex(value:int):void {
			//if (_selectedIndex == value) return
			if (_selectedIndex < 0||_selectedIndex>contentList.length-1) _selectedIndex = 0
			else _selectedIndex = value
			if(contentList.length==0)_selectedIndex=-1
			upContentLocation()
		}
		/**
		 * 当前可见子容器的从零开始的索引。
		 */
		public function get selectedIndex():int { 
			if(contentList.length==0)_selectedIndex=-1
			return _selectedIndex;
		}
		
		/**
		 *容器列表 [{name:String,box:VBox,header:MCheckButton},{name:String,box:VBox}]
		 */
		public function get contentList():Array { return _contentList}
		
		/**设置组件皮肤*/
		public function get skin():*{}
		public function set skin(value:*):void { 
			if (value is Sprite) {
					try {
						_skin = value;
						var skinObj:Sprite=Sprite(_skin)
						if( Sprite(_skin).parent&& Sprite(_skin).parent.contains( Sprite(_skin))) Sprite(_skin).parent.removeChild( Sprite(_skin))
						bg = skinObj.getChildByName('_bg')
						
						_defaultHeader = ReflectUtil.getClass(skinObj.getChildByName('_defaultHeader'))
						var _edge:DisplayObject=skinObj.getChildByName('_edge')
						_edgeRect.left =_edge.x
						_edgeRect.right=bg.width-_edge.x-_edge.width
						initSkin()
						upSize()
					}catch (e:TypeError) {
						//trace(e)
						skin=new MAccordionSkin()
					}
			}else if (value == null){skin=new MAccordionSkin()}
		}
		/**
		 * 初始化数据
		 */
		private function initSkin():void {
			var i:int
			var obj:Object 
			var header:MCheckButton 
			for (i= 0; i < contentList.length; i++) 
			{
				// { name:name, box:box, header:header }
				obj = contentList[i];
				header = obj.header as MCheckButton
				header.skin=new _defaultHeader() as MovieClip
			}
		}
		/**
		 * 设置背景
		 */
		public function set bg(valeu:DisplayObject):void {
			if (_bg == valeu) return
			if (valeu==null&&bg && contains(bg) ) removeChild(bg)
			_bg = valeu
			addChildAt(bg, 0)
			upBgSize()
		}
		public function get bg():DisplayObject { return _bg; }
		/**
		 * 更新背景大小
		 */
		private function upBgSize():void {
			if (bg) {
				_bg.x=_bg.y=0
				bg.width = width
				bg.height=height
			}
		}
		/**
		 * 大小发生改变
		 */
		override public function upSize():void {
			upBgSize()
			contentBox.width = width
			contentBox.height=height
			upContentLocation()
		}
		/**
		 * 添加一个子容器
		 * @param	label
		 * @param	child 要添加显示对象
		 * @return  null添加不成功 成功就返回现在容器
		 */
		public function add(name:String, child:DisplayObject = null):ContainerBase {
			return addAt(name,child,contentList.length)
		}
		/**
		 * 添加一个子容器到指定位置
		 * @param	label
		 * @param	child
		 * @param	index 位置
		 */
		public function addAt(name:String, child:DisplayObject = null, index:int = 0):ContainerBase {
			if (ArrayUtil.inArrByProperty(contentList, name)) return null
			var box:ContainerBase = new ContainerBase()
			//box.percentWidth = 1
			if(child)box.addChild(child)
			var header:MCheckButton = new MCheckButton( { skin:new _defaultHeader() as MovieClip } );
			header.percentWidth=1
			header.label = name
			//{name:String,box:VBox,header:MCheckButton}
			var obj:Object = { name:name, box:box, header:header }
			header.data = obj
			headerManager.push(header)
			if(!headerManager.selected&&headerManager.dataArr.length>0)MCheckButton(headerManager.dataArr[0]).select=true
			if (index < 0) index = 0
			if(index>contentList.length)index=contentList.length
			contentList.splice(index,0,obj)
			upContentLocation()
			return box
		}
		/**
		 * 删除指定名称的容器
		 * @param	name
		 * @return
		 */
		public function remove(name:String):ContainerBase {
			if (!ArrayUtil.inArrByProperty(contentList,'name',name)) return null
			var obj:Object = ArrayUtil.searchByProperty(contentList, 'name', name, false) as Object
			return removeAt(contentList.indexOf(obj))
		}
		/**
		 * 删除指定位置容器
		 * @param	name
		 * @param	index
		 * @return
		 */
		public function removeAt(index:uint = 0):ContainerBase { 
			if (index > contentList.length - 1) index = contentList.length - 1
			var obj:Object = contentList[index];
			contentList.splice(index,1)
			var box:ContainerBase=obj.box as ContainerBase
			var header:MCheckButton = obj.header as MCheckButton
			headerManager.remove(header)
			if(header==headerManager.selected&&headerManager.dataArr.length>0)MCheckButton(headerManager.dataArr[0]).select=true
			if (contentBox.contains(box)) contentBox.removeChild(box)
			if (contentBox.contains(header)) contentBox.removeChild(header)
			if (selectedIndex == index) {
				selectedIndex=0
			}
			upContentLocation()
			return box
		}
		/**
		 * 容器排布位置
		 */
		private function upContentLocation():void {
			if(!contentBox)return
			if (!contentList || contentList.length < 1) return
			if (_selectedIndex == -1)_selectedIndex = 0
		
			var i:int
			var obj:Object 
			var box:ContainerBase
			var header:MCheckButton 
			//计算所有头部高度和
			var headH:Number = 0
			for (i= 0; i < contentList.length; i++) 
			{
				// { name:name, box:box, header:header }
				obj = contentList[i];
				box=obj.box as ContainerBase
				header = obj.header as MCheckButton
				if (!contentBox.contains(header)) contentBox.addChild(header)
				if (!contentBox.contains(box))contentBox.addChild(box)
				box.width = width - _edgeRect.left - _edgeRect.right
				box.x=_edgeRect.left
				headH+=header.height
			}
			//计算剩余显示区域大小
			var surplusH:Number = height - headH
			if(surplusH<0)surplusH=0
			obj = contentList[selectedIndex];
			box = obj.box as ContainerBase
			header = obj.header as MCheckButton
			var __Y:Number = 0
			var bool:Boolean = false
			for (i= 0; i < contentList.length; i++) 
			{
				obj = contentList[i];
				box = obj.box as ContainerBase
				header = obj.header as MCheckButton
				if (i == 0) {
					header.y = 0
					box.y=__Y+header.height
				}
				if (selectedIndex == i) {
					Tweener.addTween(header, {time:.5, y:__Y} )
					Tweener.addTween(box, { time:.5,y:__Y+header.height,height:surplusH } )
					__Y+=header.height+surplusH
				}
				else {
					Tweener.addTween(box, { time:.5,y:__Y+header.height,height:0 } )
					Tweener.addTween(header, { time:.5, y:__Y } )
					__Y+=header.height
				}
				
				
			}
			contentBox.setSize(width,height)
		}
		/**
		 * 是否拥有某标签
		 * @param	name
		 * @return
		 */
		public function nameInList(name:String):Boolean {
			for (var i:int= 0; i < contentList.length; i++) 
			{
				var obj:Object=contentList[0]
				if(obj.name==name) return true
			}
			return false
		}
		/**
		 * 容器名列表
		 */
		public function get nameList():Array { return null}
		/**
		 * 获取容器 标签
		 * @param	name
		 * @return
		 */
		public function getBoxByName(name:String):ContainerBase {
			if (contentList.length < 1) return null
			for (var i:int = 0; i <contentList.length ; i++) 
			{
				var obj:Object = contentList[i]
				if (obj.name == name) {
					var box:ContainerBase = obj.box as ContainerBase
					return box
				}
			}
			return null
		}
		/**
		 * 获取容器 靠位置
		 * @param	value
		 * @return
		 */
		public function getBoxByIndex(value:uint):ContainerBase {
			if (contentList.length < 1||value>contentList.length-1) return null
			var obj:Object = contentList[value]
			if (!obj) return null
			var box:ContainerBase = obj.box as ContainerBase
			return box 
		}
		/**
		 * 获取头部 靠名字
		 * @param	name
		 * @return
		 */
		public function getHeaderByName(name:String):MCheckButton {
			if (contentList.length < 1) return null
			var header:MCheckButton 
			var obj:Object
			for (var i:int = 0; i <contentList.length ; i++) 
			{
				obj = contentList[i]
				if (obj.name == name) {
					header= obj.header as MCheckButton
					return header
				}
			}
			return null
		}
		/**
		 * 获取头部 靠排列位置
		 * @param	value
		 * @return
		 */
		public function getHeaderByIndex(value:uint):MCheckButton {
			if (contentList.length < 1||value>contentList.length-1) return null
			var obj:Object = contentList[value]
			if (!obj) return null
			var header:MCheckButton = obj.header as MCheckButton
			return header 
		}
	}
}