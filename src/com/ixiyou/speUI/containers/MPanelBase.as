package com.ixiyou.speUI.containers 
{
	/**
	 * 基础面板
	 * @author spe
	 */
	
	import com.ixiyou.managers.DragRectManager;
	import flash.display.*
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.ixiyou.geom.DragEdge;
	import com.ixiyou.speUI.containers.skins.PanelSkin;
	import com.ixiyou.speUI.core.ISkinComponent;
	import com.ixiyou.speUI.core.SpeComponent;
	import com.ixiyou.speUI.collections.ScaleBitmap
	import com.ixiyou.speUI.containers.Canvas
	import com.ixiyou.speUI.core.EdgeMetrics;
	import com.ixiyou.utils.display.BitmapSpeUtil;
	import com.ixiyou.utils.display.BitmapData2String
	
	
	public class MPanelBase extends SpeComponent implements ISkinComponent
	{
		//边界 主要用来区分 title 与 info块
		protected var _contentEdge:EdgeMetrics = new EdgeMetrics(5, 30, 5, 5)
		//拖动类型
		protected var _dragType:String=DragRectManager.DIRECT
		//是否拖动
		public var dragBool:Boolean = false
		//是否全部都允许拖动
		public var allDrag:Boolean = false
		//是否拖动时候，到最顶层
		public var topFloor:Boolean = false
		//标题文本
		protected var _titleText:TextField
		protected var _title:String='label'
		//内容容器
		protected var _box:Canvas
		//背景
		protected var _bg:DisplayObject
		//皮肤
		protected var _skin:*
		public function MPanelBase(config:*=null) 
		{
			
			_box=new Canvas()
			addChild(_box)
			super(config)
			if (config) {
				if (config.skin) skin = config.skin
				if (config.dragBool) dragBool = config.dragBool
				if (config.allDrag) allDrag = config.allDrag
				if (config.title) title = config.title
				if (config.topFloor) topFloor = config.topFloor
				if (config.dragType) dragType = config.dragType
			}
			if(skin==null )skin=null
			if (width <= 0) this.width = 200
			if (height <= 0) this.height = 100
			//_box.addEventListener(MouseEvent.MOUSE_DOWN, MOUSE_DOWN)
			initMouse()
			
		}
		public function initMouse():void 
		{
			addEventListener(MouseEvent.MOUSE_DOWN, MOUSE_DOWN)
			addEventListener(MouseEvent.MOUSE_OVER, MOUSE_OVER)
			addEventListener(MouseEvent.MOUSE_MOVE, MOUSE_MOVE)
		}
		/**
		 * 拖动模式
		 */
		public function set dragType(value:String):void 
		{
			if (value==DragRectManager.DIRECT||value==DragRectManager.CLONERECT) {
				_dragType = value
			}
			else _dragType = DragRectManager.DIRECT
		}
		public function get dragType():String { return _dragType; }
		/**
		 * 设置标题
		 */
		public function set title(value:String):void 
		{
			if (_title == value) return
			_title = value
			if(_titleText)_titleText.text=_title
		}
		public function get title():String { return _title; }
		/**组件皮肤*/
		public function get skin():*{return _skin}
		public function set skin(value:*):void {
			if (value is Sprite) {
				_skin = value;	
					try {
						if (_bg && contains(_bg)) removeChild(_bg)
						_bg = Sprite(_skin).getChildByName('_bg')
						addChildAt(_bg, 0)
						if(_bg is Sprite)Sprite(_bg).mouseEnabled=false
						if(_titleText && contains(_titleText))removeChild(_titleText)
						if (Sprite(_skin).getChildByName('_title'))_titleText = Sprite(_skin).getChildByName('_title') as TextField
						else _titleText = null
						addChild(_titleText)
						if (_titleText)_titleText.text = _title
						_titleText.mouseEnabled=false
						var temp:DisplayObject = Sprite(_skin).getChildByName('_info')
						_contentEdge.left = temp.x
						_contentEdge.top = temp.y
						//trace(_bg.width - temp.x - temp.width)
						_contentEdge.right = _bg.width - temp.x - temp.width
						_contentEdge.bottom = _bg.height - temp.y - temp.height
						upSize()
					}catch (e:TypeError) {
						skin=new PanelSkin()
					}
			}else if (value == null){skin=new PanelSkin()}
		}
		/**
		 * 添加内容
		 * @param	child
		 */
		public function add(child:DisplayObject):void {
			_box.addChild(child)
		}
		/**
		 * 删除内容
		 * @param	child
		 */
		public function remove(child:DisplayObject):void {
			_box.removeChild(child)
		}
		/**
		 * 鼠标按下
		 * @param	e
		 */
		protected function MOUSE_DOWN(e:MouseEvent):void {
			//trace(e.target)
			if (e.target != this) return
			if (!dragBool) return
			//显示对象要移动到顶层
			if(topFloor&&parent)parent.setChildIndex(this,parent.numChildren-1)
			if (!allDrag) {
				var rect:Rectangle = new Rectangle(0, 0, width, contentEdge.top)
				if (rect.contains(mouseX, mouseY)) DragRectManager.getInstance().startDrag(this, dragType)
			}else {
				DragRectManager.getInstance().startDrag(this,dragType)
			}
			
		}
		/**
		 * 鼠标放开
		 * @param	e
		 */
		protected function MOUSE_UP(e:MouseEvent):void {
			
		}
		/**
		 * 鼠标移除
		 * @param	e
		 */
		protected function MOUSE_OVER(e:MouseEvent):void {
			if (e.target != this)return
		}
		/**
		 * 鼠标移除
		 * @param	e
		 */
		protected function MOUSE_MOVE(e:MouseEvent):void {
			if (e.target != this)return
		}
		
		
		
		/**
		 * 边界 主要用来区分 title 与 info块
		 */
		public function get contentEdge():EdgeMetrics 
		{
			return _contentEdge
			
		}
		/**
		 * 内部装使用的盒子
		 */
		public function get box():Canvas { return _box; }
		override public function upSize():void {
			
			if (_bg) {
				_bg.width = width
				_bg.height=height
			}
			_box.x =contentEdge.left
			_box.y = contentEdge.top
			
			_box.width = width - contentEdge.width
			_box.height=height-contentEdge.height
			//haulEdge.upRect()
		}
		override public function destory():void {
			super.destory()
			removeEventListener(MouseEvent.MOUSE_MOVE, MOUSE_MOVE)
			removeEventListener(MouseEvent.MOUSE_DOWN, MOUSE_DOWN)
			removeEventListener(MouseEvent.MOUSE_OVER, MOUSE_OVER)
			if(stage)stage.removeEventListener(MouseEvent.MOUSE_UP,MOUSE_UP)
		}
	}

}