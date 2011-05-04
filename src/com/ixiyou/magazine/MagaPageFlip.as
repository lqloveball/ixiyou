package com.ixiyou.magazine 
{
	
	import com.ixiyou.events.QueueLoadEvent;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.*;
	import com.ixiyou.utils.math.ArcMath;
	import com.ixiyou.speUI.collections.MSprite;
	import com.ixiyou.events.ResizeEvent
	import com.ixiyou.net.QueueLoad
	import caurina.transitions.Tweener
	/**
	 * 杂志基础
	 * @author spe
	 */
	//杂志XML加载错误
	[Event(name = "PageXml_ioError", type = "flash.events.Event")]
	//提供加载的XML文件非XML文件格式，或文件格式错误
	[Event(name = "PageXml_NoXml", type = "flash.events.Event")]
	//杂志翻书结束
	[Event(name = "upPage", type = "flash.events.Event")]
	//创建一般新的杂志
	[Event(name='newBook',type='flash.events.Event')]
	public class MagaPageFlip extends Sprite
	{
		//--------------
		//翻页效果容器
		private var renderBox:Sprite = new Sprite();
		//被翻页渲染
		private var render:Shape = new Shape();
		//被翻页面材质
		private var renderBmp:BitmapData = new BitmapData(10, 10)
		//翻页下一页材质
		private var renderNextBmp:BitmapData=new BitmapData(10,10)
		//被翻得页底层阴影
		private var shadow0:Shape = new Shape();
		private var shadow0Mask:Shape = new Shape();
		//卷角的阴影
		private var shadow1:Shape = new Shape();
		private var shadow1Mask:Shape = new Shape();
		//被翻页的卷角
		private var turnup:Shape = new Shape();
		//反光
		private var glisten:Shape = new Shape()
		private var glistenMask:Shape =new Shape()
		//卷角的材质
		private var turnupBmp:BitmapData=new BitmapData(10,10)
		//书
		private var _book:Sprite = new Sprite();
		private var _bookMask:Shape = new Shape();
		//寬
		protected var _width:Number;
		//高;
		protected var _height:Number;
		//翻的过程中
		private var turnBool:Boolean = false
		//鼠标是否按下
		private var mouseBool:Boolean = false
		//翻动的边角
		private var turnNum:int=0
		//被翻动的点
		private var turnPoint:Point;
		//杂志XML
		private var _pageXml:XML;
		private var _pageXmlLoader:URLLoader = new URLLoader();
		//杂志数据
		private var _bookData:Object
		//杂志名称
		private var _bookName:String = ''
		//加载队列
		private var  bookLoadQueue:QueueLoad = new QueueLoad()
		//下一页索引
		private var _nextIndex:int
		//当前页索引
		private var _pageIndex:int=0
		//杂志页面列表
		private var _bookPages:Array 
		
		public function MagaPageFlip(w:uint=500,h:uint=375) 
		{
			//书的容器
			drawRect(_bookMask.graphics)
			addChild(_book)
			addChild(_bookMask)
			_book.mask = _bookMask
			//翻书效果渲染
			renderBox.mouseEnabled = false
			renderBox.visible=false
			addChild(renderBox)
			
			renderBox.addChild(render)
			renderBox.addChild(shadow0)
			renderBox.addChild(shadow0Mask)
			shadow0.mask = shadow0Mask
			drawRect(shadow0Mask.graphics)
			
			renderBox.addChild(shadow1)
			renderBox.addChild(shadow1Mask)
			drawRect(shadow1Mask.graphics)
			shadow1.mask=shadow1Mask
			renderBox.addChild(shadow1)
			
			renderBox.addChild(turnup)
			renderBox.addChild(glisten)
			renderBox.addChild(glistenMask)
			glisten.mask=glistenMask
			//drawRect(glistenMask.graphics)
			//设置大小
			setSize(w,h)
			addEventListener(Event.ADDED_TO_STAGE, init);
			bookLoadQueue.addEventListener(QueueLoadEvent.LOADED, loaded)
			bookLoadQueue.addEventListener(IOErrorEvent.IO_ERROR, io_error)
			bookLoadQueue.addEventListener(QueueLoadEvent.PROGRESS, progress)
			bookLoadQueue.addEventListener(QueueLoadEvent.COMPLETE,complete)
		}
		/**
		 * 添加到场景上初始化
		 * @param	e
		 */
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, mouse_up);
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouse_move);
			addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
			addEventListener(Event.ENTER_FRAME, draw_FRAME)
		}
		
		/**
		 * 设置加载XML地址
		 * @param	value
		 */
		public function loadPageXml(value:String):void {
			//trace('loadPageXml')
			var url:URLRequest = new URLRequest(value)
			_pageXmlLoader.load(url)	
			//XML加载监听
			if(!_pageXmlLoader.hasEventListener(Event.COMPLETE))_pageXmlLoader.addEventListener(Event.COMPLETE,xmlCompleteHandler);
			if(!_pageXmlLoader.hasEventListener(IOErrorEvent.IO_ERROR))_pageXmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlIoErrorHandler);
		}
		/**
		 * XML加载错误
		 * @param	e
		 */
		private function xmlIoErrorHandler(e:IOErrorEvent):void {
			dispatchEvent(new Event('PageXml_ioError'))
		}
		/**
		 * XML加载完成
		 * @param	e
		 */
		private function xmlCompleteHandler(e:Event):void {
			try 
			{
				pageXml = new XML(_pageXmlLoader.data)
			}
			catch (e:TypeError) {
				dispatchEvent(new Event('PageXml_NoXml'))
			}
		}
		/**
		 * 杂志XML信息数据
		 */
		public function get pageXml():XML { return _pageXml; }
		/**
		 * 杂志XML信息数据
		 */
		public function set pageXml(value:XML):void 
		{
			if (_pageXml == value) return
			_pageXml = value;
			bookData=PageDataModel.dataProcessing(_pageXml)
		}
		
		/**
		 * 杂志名
		 */
		public function get bookName():String { return _bookName; }
		public function set bookName(value:String):void { _bookName = value; }
		/**
		 * 杂志加载队列完成
		 * @param	e
		 */
		private function complete(e:QueueLoadEvent):void 
		{
			dispatchEvent(e)
		}
		/**
		 * 队列加载中
		 * @param	e
		 */
		private function progress(e:QueueLoadEvent):void 
		{
			dispatchEvent(e)
		}
		/**
		 * 队列中出现加载错误
		 * @param	e
		 */
		private function io_error(e:IOErrorEvent):void 
		{
			dispatchEvent(e)
		}
		/**
		 * 队列加载完成一个文件时候
		 * @param	e
		 */
		private function loaded(e:QueueLoadEvent):void {
			if (e.info && e.info.id) {
				var id:uint = uint(e.info.id);
				var data:ByteArray = e.info.data as ByteArray;
				if (data && getPageByIndex(id)) getPageByIndex(id).setPageLoad(data);
				dispatchEvent(e)
			}
		}
		
		/**
		 * 程序内部通过 提供2进制数据组来生成杂志
		 * @param	name
		 * @param	width
		 * @param	height
		 * @param	data
		 */
		public function setBookDataByByteArray(name:String, width:uint, height:uint, data:Array):void {
			//if (_bookData == value||!value.pages) return;
			_bookData = new Object();
			var pages:Array =new Array()
			bookData.name = bookName = name
			bookData.width = width
			bookData.height=height
			setSize(bookData.width, bookData.height);
			bookData.pages=pages
			var tempLayout:PageLayout
			clearPages()
			_pageIndex = 0
			_nextIndex=0
			//队列清空队列
			bookLoadQueue.clear()
			_bookPages = new Array()
			var temp:Object
			for (var i:int = 0; i < data.length; i++) 
			{
				//+id:String 页面的ID
		 		//+src:String 页面的加载地址,或者页面数据（如加载的数据或者直接的现实对象，考虑到比如FLASH内部生产的显示对象）
				//+type:String 页面的数据形式
				temp = new Object()
				if (data[i].id) temp.id = data[i].id
				else temp.id = ''
				temp.src = ''
				if (data[i].type) temp.type = data[i].type
				else temp.type =''
				temp.index=i
				tempLayout = new PageLayout( {width:width,height:height,data:temp,index:i} )
				_bookPages.push(tempLayout)
				tempLayout.setPageLoad(data[i].src)

			}
			if (_bookPages[0])_book.addChild(_bookPages[0] as DisplayObject)
			pageIndex = 0
			dispatchEvent(new Event('newBook'))
		}
		/**
		 * 杂志数据 采用加载方式
		 * Object类型
		 * 	+width:uint 杂志宽
		 * 	+height:uint  杂志高
		 *  +name:String 杂志名称
		 * 	+pages:Array 杂志页面数据
		 *    obj:Object 记录每个单独页面数据
		 * 		+id:String 页面的ID
		 * 		+src:String 页面的加载地址,或者页面数据（如加载的数据或者直接的现实对象，考虑到比如FLASH内部生产的显示对象）
		 *		+type:String 页面的数据形式
		 *  +other:其他配置数据，可以考虑做声音等等
		 */
		public function get bookData():Object { return _bookData; }
		public function set bookData(value:Object):void 
		{
			
			if (_bookData == value||!value.pages) return;
			_bookData = value;
			if ( bookData.name) bookName = bookData.name;
			setSize(bookData.width, bookData.height);
			var pages:Array = bookData.pages as Array
			var temp:PageLayout
			clearPages()
			_pageIndex = 0
			_nextIndex=0
			//队列清空队列
			bookLoadQueue.clear()
			_bookPages = new Array()
			var data:Object
			for (var i:int = 0; i < pages.length; i++) 
			{
				data = pages[i];
				data.index=i
				temp = new PageLayout( {width:width,height:height,data:data,index:i} )
				_bookPages.push(temp)
				//外部加载方式，放到加载队列中
				if (data.type == '' || data.type == 'png' || data.type == 'jpg' || data.type == 'bmp' || data.type == 'swf') {
					bookLoadQueue.add(data.src,-1,{type:"binary",id:i.toString(),index:i.toString()})
				}
			}
			//队列加载开始
			bookLoadQueue.start()
			if (_bookPages[0])_book.addChild(_bookPages[0] as DisplayObject)
			pageIndex = 0
			dispatchEvent(new Event('newBook'))
		}
		/**
		 * 页面数据的Obj对象数组
		 */
		public function get bookDataArr():Array {
			if (bookPages && bookData.pages) return bookData.pages;
			else return null;
		}
		/**
		 * 页面的数据
		 * @param	value
		 */
		public function getPageDataByIndex(value:uint):Object {
			if (!bookDataArr||value >= bookDataArr.length) return null
			return bookDataArr[value]
		}
		/**
		 * 获取指定页面
		 * @param	value
		 * @return
		 */
		public function getPageByIndex(value:uint):PageLayout {
			if (!bookPages || value >= bookPages.length) return null
			return bookPages[value]
		}
		/**
		 * 设置跳转页面
		 * @param	value
		 */
		public function setPage(value:uint):void {
			if (!bookPages || bookPages.length <= 0) return
			//var _nextIndex
			value = Math.min(bookPages.length - 1, value)
			value = Math.max(0, value)
			if (_pageIndex == value) return	
			_nextIndex = value;
			turnBool = true
			if (_pageIndex < _nextIndex) {
				turnPage(new Point(1, 1))
				turnNum=-4
				setNextIndex(turnNum)
			}
			else {
				turnPage(new Point(0, 1))
				turnNum=-2
				setNextIndex(turnNum)
			}
			setTimeout(renderBoxShow,100)
		}
		/**
		 * 翻动的显示
		 */
		private function renderBoxShow():void {
			renderBox.visible = true
			//计算半页情况
			if (_nextIndex == 0) {
				_bookMask.x = width / 2
				_bookMask.width=width / 2
			}else if (_nextIndex==bookPages.length-1) {
				_bookMask.x =0
				_bookMask.width=width / 2
			}else {
				_bookMask.x = 0
				_bookMask.width=width
			}
		}
		/**
		 * 下一页
		 */
		public function nextPage():void {
			if(!bookDataArr)return
			if (pageIndex < bookPages.length - 1) setPage(pageIndex + 1)
			else setPage(bookPages.length - 1)
		}
		/**
		 * 上一页
		 */
		public function previousPage():void {
			if(!bookDataArr)return
			if (pageIndex > 0) setPage(pageIndex - 1)
			else setPage(0)
		}
		/**
		 * 设置当前页面
		 */
		public function set pageIndex(value:uint):void {setPage(value)}
		public function get pageIndex():uint { return _pageIndex; }
		/**
		 * 页面总数
		 */
		public function get pagesLength():uint {
			if(bookPages)return bookPages.length
			return 0;
		}
		/**
		 * 下一页的页码
		 */
		private function get nextIndex():int {	return _nextIndex}
		/**
		 * 根据翻动的脚位置算计算下一页页面,主要用于计算
		 * @param	turnNum
		 * @return
		 */
		private function setNextIndex(_turnNum:int):int {
			if (_turnNum == -3 || _turnNum == -4) {
				renderBox.x = width / 2
				shadow0Mask.x = -width / 2
			}else {
				renderBox.x = 0
				shadow0Mask.x=0
			}
			if (_turnNum == -1 || _turnNum == -2) {
				if (pageIndex > 0) _nextIndex= pageIndex - 1;
				else  _nextIndex=-1;
			}else {
				if (pageIndex < pagesLength - 1) _nextIndex= pageIndex+1
				else _nextIndex=-1
			}
			
			return _nextIndex
		}
		/**
		 * 杂志页面列表
		 */
		public function get bookPages():Array { return _bookPages; }
		/**
		 * 清空所有的杂志页面
		 */
		private function clearPages():void {
			if (!_bookPages) return
			_pageIndex = 0
			_nextIndex=0
			for (var i:int = 0; i < _bookPages.length; i++) 
			{
				var temp:PageLayout=_bookPages[i] as PageLayout
				temp.destory()
			}
			dispatchEvent(new Event('PagesClear'))
			
		}
		
		/**
		 * 鼠标移动
		 * @param	e
		 */
		private function mouse_up(e:MouseEvent):void {
			mouseBool=false
			if (!turnBool) return
			//右
			if (turnNum == -4 || turnNum == -3) {
				//需要翻页
				if (this.mouseX > this.width / 2) {
					if (turnNum == -4) turnPage(new Point(1, 1),false)
					if(turnNum == -3)turnPage(new Point(1,0),false)
				}else {
					if (turnNum == -4) turnPage(new Point(1, 1))
					if(turnNum == -3)turnPage(new Point(1,0))
				}
			}else {
				//左
				//需要翻页
				if (this.mouseX < this.width / 2) {
					if (turnNum == -1) turnPage(new Point(0, 0),false)
					if(turnNum == -2)turnPage(new Point(0,1),false)
				}else {
					if (turnNum == -1) turnPage(new Point(0, 0))
					if(turnNum == -2)turnPage(new Point(0,1))
				}
			}
		}
		/**
		 * 翻动页面 
		 * @param	pt 翻动的点
		 * @param	bool 翻动是翻过，还是返回
		 * @param   mousePt 翻动起始点
		 */
		private function turnPage(pt:Point, bool:Boolean = true, mousePt:Point = null):void {
			//trace(pt,bool,mousePt)
			var obj:Object
			var _w:Number
			var _h:Number
			if (pt.x == 0 && pt.y == 0) {
				if (bool)_w = width 
				else _w=0
				_h = 0
				if(pageIndex==0&&bool)return
			}else if (pt.x == 0 && pt.y == 1) {
				if (bool)_w = width
				else _w=0
				_h = height
				if(pageIndex==0&&bool)return
			}else if (pt.x == 1 && pt.y == 0) {
				if (bool)_w = -width / 2
				else _w=width / 2
				_h = 0
				if(pageIndex==bookPages.length-1&&bool)return
			}else if (pt.x == 1 && pt.y == 1) {
				if (bool)_w = -width / 2
				else _w=width / 2
				_h = height
				if(pageIndex==bookPages.length-1&&bool)return
			}
			if (mousePt == null) mousePt = new Point(renderBox.mouseX, renderBox.mouseY)
			//trace(pt,bool,mousePt)
			Tweener.addTween(mousePt,{ time:.3, x:_w, y:_h,
				onUpdate:function():void {
					obj = PageFlip.computeFlip(new Point(this.x, this.y), pt, width / 2, height, true, 1);
					drawBitmapBook(obj)
				},
				onComplete:function():void {
					renderBox.visible = false
					if (bool) {
						_pageIndex = nextIndex;
					}
					setPageIndex(pageIndex)
					turnBool = false
					_bookMask.x = 0
					_bookMask.width=width
					dispatchEvent(new Event('upPage'))
				}
			})
		}
		/**
		 * 设置第下显示页面
		 * @param	value
		 */
		private function setPageIndex(value:int = -1):void {
			var num:uint=_book.numChildren
			for (var i:int = 0; i <num; i++) _book.removeChildAt(0)
			if (value < 0)return
			if (bookPages && bookPages[value]) {
				_book.addChild(bookPages[value])
			}
		}
		/**
		 * 鼠标拖动移动
		 * @param	e
		 */
		private function mouse_move(e:MouseEvent):void {
			if (turnBool && mouseBool) {
				var obj:Object
				var dragPt:Point
				if (turnNum == -1) {
					dragPt = new Point(0, 0)
				}
				else if (turnNum == -2) {
					dragPt = new Point(0,1)
				}
				else if (turnNum == -3) {
					dragPt = new Point(1,0)
				}
				else {
					dragPt = new Point(1,1)
				}
				//设置页面1
				obj = PageFlip.computeFlip(new Point(render.mouseX, render.mouseY), dragPt, width / 2, height, true, 1);
				drawBitmapBook(obj)
			}
		}
		/**
		 * 渲染
		 * @param	e
		 */
		private function draw_FRAME(e:Event):void {
			if (turnBool) {
				//trace('---',pageIndex,nextIndex)
				var show1:DisplayObject=bookPages[pageIndex]
				var show2:DisplayObject
				if (nextIndex >= 0) show2 = bookPages[nextIndex]
				//trace(pageIndex,nextIndex)
				renderBmp.fillRect(new Rectangle(0, 0, width, height), 0x0)
				turnupBmp.fillRect(new Rectangle(0, 0, width, height), 0x0)
				renderNextBmp.fillRect(new Rectangle(0, 0, width, height), 0x0)
				if(show1)renderBmp.draw(show1)
				if(show2)turnupBmp.draw(show2)
				if(show2)renderNextBmp.draw(show2)
				if (turnNum == -4 || turnNum == -3) {
					if (show1)renderBmp.copyPixels(renderBmp, new Rectangle(width / 2, 0, width / 2, height), new Point(0, 0))
					if(show2)renderNextBmp.copyPixels(renderNextBmp,new Rectangle(width/2,0,width/2,height),new Point(0,0))
				}else {
					if (show2) turnupBmp.copyPixels(turnupBmp, new Rectangle(width / 2, 0, width / 2, height), new Point(0, 0))
					if(show2)renderNextBmp.copyPixels(renderNextBmp,new Rectangle(0,0,width/2,height),new Point(0,0))
				}
			}
		}
		/**
		 * 杂志绘制
		 */
		private function drawBitmapBook(obj:Object):void {
			var wid:Number=obj.width;
			var hei:Number=obj.height;
			var nb:Number;
			var ppts:Array=obj.pPoints;
			var cpts:Array = obj.cPoints;
			render.graphics.clear()
			render.graphics.beginBitmapFill(renderNextBmp, new Matrix(), false, true);
			render.graphics.drawRect(0,0,width/2,height)
			render.graphics.beginBitmapFill(renderBmp, new Matrix(), false, true);
			nb=ppts.length;
			render.graphics.moveTo(ppts[nb-1].x,ppts[nb-1].y);
			while (--nb>=0)render.graphics.lineTo(ppts[nb].x,ppts[nb].y);
			render.graphics.endFill();
			if (cpts == null) {
				shadow1.visible=false
				return;
			}else {
				shadow1.visible=true
			}
			//阴影
			var line:Number = Point.distance(new Point(), new Point(width, height))
			//卷角的阴影
			shadow1.rotation = obj.angle-180
			shadow1.x = cpts[cpts.length - 1].x
			shadow1.y = cpts[cpts.length - 1].y
			drawShadowRect(shadow1.graphics,obj.cLine / 2,line,0x0,1)
			shadow1.alpha = .7 * (1 - obj.cLine / width)
			//被翻得页底层阴影
			shadow0.rotation = obj.angle
			shadow0.x = cpts[cpts.length - 1].x
			shadow0.y = cpts[cpts.length - 1].y
			drawShadowRect(shadow0.graphics, obj.cLine / 2 , line, 0x0, .8)
			shadow0.alpha = .7 * (obj.cLine / width)
			
			//翻光
			glisten.rotation = obj.angle
			glisten.x = cpts[cpts.length - 1].x
			glisten.y = cpts[cpts.length - 1].y
			drawShadowRect(glisten.graphics, obj.cLine /5 , line, 0xffffff, .8)
			glisten.alpha=.5*(1-(obj.cLine/width))
			//被翻页的卷角
			turnup.graphics.clear()
			glistenMask.graphics.clear()
			glistenMask.graphics.beginFill(0x0)
			turnup.graphics.beginBitmapFill(turnupBmp,obj.matrix,false,true);
			nb=cpts.length;
			turnup.graphics.moveTo(cpts[nb - 1].x, cpts[nb - 1].y);
			glistenMask.graphics.moveTo(cpts[nb - 1].x, cpts[nb - 1].y);
			while (--nb >= 0) {
				turnup.graphics.lineTo(cpts[nb].x, cpts[nb].y);
				glistenMask.graphics.lineTo(cpts[nb].x, cpts[nb].y);
			}
			turnup.graphics.endFill();
			glistenMask.graphics.endFill();
			
		}
		/**
		 * 按下
		 * @param	e
		 */
		private function mouse_down(e:MouseEvent):void {
			if(turnBool||mouseBool)return
			turnNum = MouseFindArea(new Point(this.mouseX, this.mouseY))
			if (turnNum<0) {
				//trace('翻书')
				if ((turnNum == -1 || turnNum == -2 )&& pageIndex == 0) return
				if((turnNum==-3||turnNum==-4)&&pageIndex==bookPages.length-1)return
				turnBool = true
				mouseBool = true
				setNextIndex(turnNum)
				setTimeout(renderBoxShow,100)
			}
		}
		/**
		 * 计算点击区域
		 * @param	point
		 * @return 取下面的四个区域,返回数值:
		 *   --------------------
		 *  | -1|     |     | -3 |
		 *  |---      |      ----|
		 *  |     1   |   3      |
		 *  |---------|----------| 
		 *  |     2   |   4      |
		 *  |----     |      ----|
		 *  | -2 |    |     | -4 |
		 *   --------------------
		 */
		private function MouseFindArea(point:Point):int {
			var tmpn:Number;
			var minx:Number=0;
			var maxx:Number=width
			var miny:Number=0;
			var maxy:Number=height;
			var areaNum:Number=100;
			if (point.x>minx&&point.x<=maxx*0.5) {
				tmpn=(point.y>miny&&point.y<=(maxy*0.5))?1:(point.y>(maxy*0.5)&&point.y<maxy)?2:0;
				if (point.x<=(minx+areaNum)) {
					tmpn=(point.y>miny&&point.y<=(miny+areaNum))?-1:(point.y>(maxy-areaNum)&&point.y<maxy)?-2:tmpn;
				}
				return tmpn;
			} else if (point.x>(maxx*0.5)&&point.x<maxx) {
				tmpn=(point.y>miny&&point.y<=(maxy*0.5))?3:(point.y>(maxy*0.5)&&point.y<maxy)?4:0;
				if (point.x>=(maxx-areaNum)) {
					tmpn=(point.y>miny&&point.y<=(miny+areaNum))?-3:(point.y>(maxy-areaNum)&&point.y<maxy)?-4:tmpn;
				}
				return tmpn;
			}
			return 0;
		}
		/**设置高度*/
		override public function set height(value:Number):void {	setSize(_width,value);}
		override public function get height():Number{return _height;}
		/**设置宽度*/
		override public function set width(value:Number):void{setSize(value,_height);}
		override public function get width():Number { return _width; }		
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
		/**组件大小更新*/
		public function upSize():void {
			setObjSize(shadow0Mask, width, height)
			setObjSize(shadow1Mask, width/2, height)
			setObjSize(_bookMask, width, height)
			//setObjSize(glistenMask, width, height)
			//drawRect(graphics, width, height, 0x00ff00, 0)			
			renderBmp.dispose();
			renderBmp = new BitmapData(width , height);
			renderNextBmp.dispose()
			renderNextBmp=new BitmapData(width,height)
			turnupBmp.dispose();
			turnupBmp = new BitmapData(width , height);
		}
		/**
		 * 绘制
		 * @param	obj
		 * @param	w
		 * @param	h
		 * @param	color
		 */
		private function drawRect(obj:Graphics, w:uint=10, h:uint=10,color:uint=0x0,ap:Number=1):void {
			obj.clear()
			obj.beginFill(color)
			obj.drawRect(0,0,w,h)
		}
		/**
		 * 绘制阴影
		 * @param	obj
		 * @param	w
		 * @param	h
		 * @param	color
		 * @param	ap
		 */
		private function drawShadowRect(obj:Graphics, w:uint, h:uint, color:uint, ap:Number):void {
			obj.clear()
			var mtr:Matrix = new Matrix()
			mtr.createGradientBox(w,h,0 * Math.PI / 180); 
			obj.beginGradientFill("linear",[color,color],[ap,0],[0,255],mtr)
			obj.drawRect(0,-h,w,h*2); 
		}
		/**
		 * 设置显示对象大小
		 * @param	obj
		 * @param	w
		 * @param	h
		 */
		private function setObjSize(obj:DisplayObject, w:uint, h:uint):void {
			obj.width = w
			obj.height=h
		}
	}

}