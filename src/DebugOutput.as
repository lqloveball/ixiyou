package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;

	/**
	 * debug输出
	 * @author spe email:md9yue@@q.com
	 */
	public class DebugOutput
	{
		/**
		 * 日志字典
		 */
		private static var dic:Dictionary = new Dictionary();
		/**
		 * debug 界面
		 */
		public static var ui:DebugOutputUI
		/**
		 *
		 */
		private static var stage:Stage
		public function DebugOutput()
		{

		}
		/**
		 * 日志字典
		 * @return
		 */
		public static function getDic():Dictionary {return dic}
		/**
		 * 添加日志
		 * @param	value
		 */
		public static function add(...value):void {
			//trace(value.join("") + "\n")
			if (value.length > 1) push('default', value)
			else push('default',value[0])
		}
		public static function pushXML(type:String, obj:*):void {
			//if (!dic[type]) {
				//dic[type] = new Array()
				//if(ui)ui.upType()
			//}
			//var arr:Array = dic[type]
			//var date:Date = new Date()
			//var str:String ='<FONT size="12" COLOR="#ff0000">'+date.fullYear + '/'+(date.monthUTC+1) + '/' +date.dateUTC + '/'+  date.hours + '/' + date.minutes + '/' + date.seconds + '/' + date.milliseconds + '</FONT>:\n'
			var str:String=''
			var xml:String = XML(obj).toXMLString() + "\n";
			trace(xml)
			xml=xml.replace(/[<]+/g,'&lt;')
			xml=xml.replace(/[>]+/g,'&gt;')
			str += xml

			push(type,str)

		}
		/**
		 * 添加到指定日志
		 * @param	type
		 * @param	obj
		 */
		public static function push(type:String,obj:*):void {
			if (!dic[type]) {
				dic[type] = new Array()
				if(ui)ui.upType()
			}
			var arr:Array = dic[type]
			var date:Date = new Date()
			var str:String ='<FONT size="12" COLOR="#ff0000">'+date.fullYear + '/'+(date.monthUTC+1) + '/' +date.dateUTC + '/'+  date.hours + '/' + date.minutes + '/' + date.seconds + '/' + date.milliseconds + '</FONT>:\n'
			//var str:String ='<<'+date.fullYear + '/'+(date.monthUTC+1) + '/' +date.dateUTC + '/'+ date.hours + '/' + date.minutes + '/' + date.seconds + '/' + date.milliseconds + '>> :'
			if (obj is Array) {
				str += (obj as Array).join(",") + "\n"
				trace(str.slice(str.indexOf(':')+1))
			}else {
				str += obj.toString() + "\n";
				trace(str.slice(str.indexOf(':')+1))
			}
			/*
			else if (obj is XML) {
				//trace('xml----------------------------------------')
				var xml:String = XML(obj).toXMLString() + "\n";
				trace(xml)
				xml=xml.replace(/[<]+/g,'&lt;')
				xml=xml.replace(/[>]+/g,'&gt;')
				str += xml
			}
			*/

			//trace(obj is XML)

			if (arr.length > pageLenght) {
				dic[type] = new Array()
				arr= dic[type]
			}
			if (arr[0] == null) arr[0] = new Array()
			if ((arr[arr.length - 1] as Array).length > 20) {	arr.push(new Array())}
			(arr[arr.length - 1] as Array).push(str)
			if(ui)ui.upData()
		}
		/**
		 * 清空某类型日志
		 * @param	value
		 */
		public static function clearType(value:String):void {
			if (!dic[value]) return
			dic[value] = new Array()
			var arr:Array = dic[value];
			arr[0] = new Array()
			if(ui)ui.upData()
		}
		/**
		 * 清空日志
		 */
	    public static function clear():void {
			if (dic) dic = null
			dic=new Dictionary()
		}
		private static var pageLenght:uint = 10

		/**
		 * 最多多少页
		 * @param	value
		 */
		public static function setLength(value:uint):void {
			pageLenght=value
		}
		/**
		 * 最多多少页
		 */
		public static function getLength():uint {
			return pageLenght
		}
		//
		private static var key:uint = 113
		/**
		 * 设置默认值
		 * @param	value
		 */
		public static function setKeyCode(value:uint):void {
			key=value
		}
		/**
		 * 设置场景
		 * @param	_stage
		 */
		public static function setStage(_stage:Stage):void {
			if (stage)return
			stage = _stage
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown)
		}
		private static var ctrlKey:Boolean=false
		static private function mouseDown(e:MouseEvent):void
		{
			if (ctrlKey&&new Rectangle(0,0,10,10).contains(e.stageX,e.stageY)) {
				if (!ui) show()
				else {
					if (stage.contains(ui)) hit()
					else show()
				}
			}
		}

		static private function onFocusOut(e:FocusEvent):void
		{
			ctrlKey=false
		}

		static private function onKeyDown(e:KeyboardEvent):void
		{

			if(!stage)return
			if (e.keyCode == key && e.ctrlKey == true) {
				if (!ui) show()
				else {
					if (stage.contains(ui)) hit()
					else show()
				}
			}
			else if (e.keyCode == 114 && e.ctrlKey == true) {
				//大小
				if (ui) {
					ui.windowMaxMin()
				}

			}
			if ( e.ctrlKey == true) {
				ctrlKey=true
			}else {
				ctrlKey=false
			}
		}

		static private function onKeyUp(e:KeyboardEvent):void
		{
			ctrlKey=false
		}
		/**
		 * 显示
		 */
		public  static function show():void {
			if (!stage) return
			if (!ui) {
				ui = new DebugOutputUI()
				ui.upType()
				ui.upData()
			}
			stage.addChild(ui)
			ui.x = 0
			ui.y=0
		}
		/**
		 * 隐藏
		 */
		public static function hit():void {
			if (!stage||!ui) return
			stage.removeChild(ui)
		}
	}

}


import flash.display.*;
import flash.events.*;
import flash.geom.Rectangle;
import flash.text.*;
import flash.utils.Dictionary;

class DebugOutputUI extends Sprite {
	private var typeArr:Array
	private var typeBtnArr:Array
	private var type:String
	//头部
	private var top:Sprite = new Sprite()
	private var topBg:Sprite=new Sprite()
	private var _width:Number=250;
	private var _height:Number = 200;
	private var titleText:TextField
	//
	private var nav:Sprite = new Sprite()

	//
	private var window:Sprite = new Sprite()
	private var wtext:TextField
	private var htext:TextField

	private var bottom:Sprite = new Sprite()
	private var bottomBtn:MovieClip


	//
	private var pageNum:int = 0
	//private var dataDic:Dictionary
	private var dataArr:Array
	private var pageText:TextField
	private var infoTxt:TextField
	private var infoScrollBar:Sprite = new Sprite()
	private var infoScrollSlider:Sprite = new Sprite()
	private var infoScrollBg:Sprite=new Sprite()
	private var infoPanel:Sprite = new Sprite()

	//
	private var bg:Sprite=new Sprite()
	public function DebugOutputUI() {
		addChild(bg)
		initTop()
		initNav()
		initWindow()
		initBottom()
		initInfoPanel()
		upSize()
	}
	private function initInfoPanel():void {
		addChild(infoPanel)
		var btn:MovieClip

		btn= foundBtn('<<', 16,16)
		btn.addEventListener(MouseEvent.CLICK, ppBtn)
		infoPanel.addChild(btn)

		btn = foundBtn('<',16,16)
		btn.x=18
		btn.addEventListener(MouseEvent.CLICK, ppBtn)
		infoPanel.addChild(btn)

		btn= foundBtn('>', 16,16)
		btn.addEventListener(MouseEvent.CLICK, ppBtn)
		btn.x=115
		infoPanel.addChild(btn)

		btn = foundBtn('>>', 16,16)
		btn.x=133
		btn.addEventListener(MouseEvent.CLICK, ppBtn)
		infoPanel.addChild(btn)

		btn = foundBtn('clear', 30,16)
		btn.x=152
		btn.addEventListener(MouseEvent.CLICK, clearFun)
		infoPanel.addChild(btn)
		fixedBool=true
		btn = foundBtn('▼', 16,16)
		btn.x=187
		btn.addEventListener(MouseEvent.CLICK, fixedFun)
		infoPanel.addChild(btn)

		pageText = foundText('--/--', 80, 10, false, false, 16		)
		pageText.x = 42
		pageText.autoSize=TextFieldAutoSize.CENTER
		infoPanel.addChild(pageText)

		infoTxt = foundText('....', 100, 12, true, true, 16)
		infoTxt.border = true
		infoTxt.borderColor = 0x0
		infoTxt.wordWrap=true
		addChild(infoTxt)
		addChild(infoScrollBar)
		infoScrollBar.addChild(infoScrollBg)
		infoScrollBg.graphics.beginFill(0x0, .5)
		infoScrollBg.graphics.drawRect(0, 0, 12, 100)

		infoScrollBar.addChild(infoScrollSlider)
		infoScrollSlider.graphics.beginFill(0x0, .5)
		infoScrollSlider.graphics.drawRect(0, 0, 10, 30)
		infoScrollSlider.x = 1
		infoScrollSlider.addEventListener(MouseEvent.MOUSE_DOWN,sliderDown)
		infoScrollSlider.buttonMode=true
	}

	private function sliderDown(e:MouseEvent):void
	{
		stage.addEventListener(MouseEvent.MOUSE_UP, sliderUp)
		stage.addEventListener(MouseEvent.MOUSE_MOVE,sliderMovie)
		infoScrollSlider.startDrag(false,new Rectangle(1,0,0,infoScrollBg.height-infoScrollSlider.height))
	}

	private function sliderMovie(e:MouseEvent):void
	{
		upSliderToTextShow()
	}
	private function upTextToSliderShow():void {
		var all:Number = infoScrollBg.height - infoScrollSlider.height
		var v:Number = infoTxt.scrollV / infoTxt.maxScrollV
		if (v < .95) infoScrollSlider.y = v * all >> 0
		else infoScrollSlider.y=all
	}
	private function upSliderToTextShow():void {
		var all:Number = infoScrollBg.height - infoScrollSlider.height
		var v:Number = infoScrollSlider.y
		if (v / all < .95) infoTxt.scrollV = infoTxt.maxScrollV * v / all
		else  infoTxt.scrollV = infoTxt.maxScrollV
	}
	private function sliderUp(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP, sliderUp)
		stage.removeEventListener(MouseEvent.MOUSE_MOVE,sliderMovie)
		infoScrollSlider.stopDrag()
	}

	private var fixedBool:Boolean=true
	/**
	 * 固定
	 * @param	e
	 */
	private function fixedFun(e:MouseEvent):void
	{
		var btn:MovieClip = e.target as MovieClip
		var text:TextField=btn.text as TextField
		if (fixedBool) {
			fixedBool=false
			text.text='▲'
		}else {
			fixedBool=true
			text.text='▼'
		}
	}


	private function initBottom():void
	{
		addChild(bottom)
		bottomBtn = foundBtn('>', 16, 16)
		bottomBtn.addEventListener(MouseEvent.MOUSE_DOWN, startDragWindowSize)
		bottomBtn.text.x=2
		addChild(bottomBtn)
	}

	private function startDragWindowSize(e:MouseEvent):void
	{
		if (windowMaxMinBool) return
		stage.addEventListener(MouseEvent.MOUSE_UP, stopDragWindow)
			stage.addEventListener(MouseEvent.MOUSE_MOVE, moveWindow)
		bottomBtn.startDrag(false,new Rectangle(250-16,200-16,stage.stageWidth,stage.stageHeight))
	}

	private function moveWindow(e:MouseEvent):void
	{

		graphics.clear()
		graphics.beginFill(0, 0)
		graphics.lineStyle(.1, 0x0, .5)
		graphics.drawRect(0,0,bottomBtn.x+16,bottomBtn.y+16)
	}

	private function stopDragWindow(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP, stopDragWindow)
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveWindow)
		graphics.clear()
		//graphics.beginFill(0, 0)
		//graphics.lineStyle(.1, 0x0, .5)
		//graphics.drawRect(0,0,bottomBtn.x+16,bottomBtn.y+16)
		bottomBtn.stopDrag()
		var w:int=bottomBtn.x+16
		var h:int = bottomBtn.y + 16

		setSize(w,h)
	}
	private function initTop():void {
		addChild(top)
		top.alpha = .8

		topBg.graphics.beginFill(0xffffff,.6)
		topBg.graphics.lineStyle(.1,0x515151)
		topBg.graphics.drawRect(0,0,100,22)
		top.addChild(topBg)
		topBg.addEventListener(MouseEvent.MOUSE_DOWN, stratDargFun)
		//topBg.buttonMode=true
		titleText= foundText('debug', 40, 10, false)
		titleText.x=titleText.y=3
		top.addChild(titleText)
	}
	private function initNav():void {
		nav.x=100
		addChild(nav)
	}

	private function initWindow():void {
		window.y=3
		addChild(window)
		var text:TextField
		var btn:MovieClip
		text = foundText('w', 12, 10, false, false)
		text.x=0
		window.addChild(text)

		wtext = foundText('100', 35, 10, true, true)
		wtext.type = TextFieldType.INPUT
		wtext.x = 14
		wtext.height=16
		wtext.background = true
		wtext.backgroundColor = 0xEAEAEA
		wtext.border = true
		wtext.borderColor = 0x454545
		window.addChild(wtext)

		text = foundText('h', 12, 10, false, false)
		text.x=53
		window.addChild(text)

		htext = foundText('100', 35, 10, true, true)
		htext.type = TextFieldType.INPUT
		htext.x = 66
		htext.height=16
		htext.background = true
		htext.backgroundColor = 0xEAEAEA
		htext.border = true
		htext.borderColor = 0x454545
		window.addChild(htext)

		btn = foundBtn('r', 15, 15, 'r')
		btn.text.y = -2
		btn.text.x=3
		btn.x=104
		window.addChild(btn)
		btn.addEventListener(MouseEvent.CLICK,reSize)

		btn = foundBtn('m', 15, 15, 'r')
		btn.text.y = -2
		btn.text.x=3
		btn.x = 121
		btn.bool=false
		window.addChild(btn)
		btn.addEventListener(MouseEvent.CLICK,function():void{windowMaxMin()})

		btn = foundBtn('x', 15, 15, 'r')
		btn.text.y = -2
		btn.text.x=3
		btn.x=137
		window.addChild(btn)
		btn.addEventListener(MouseEvent.CLICK,function():void{hit()})

	}

	private function reSize(e:MouseEvent):void
	{
		setSize(Number(wtext.text),Number(htext.text))
	}
	private function stratDargFun(e:MouseEvent):void
	{
		if(windowMaxMinBool)return
		stage.addEventListener(MouseEvent.MOUSE_UP,stopDargFun)
		this.startDrag()
	}

	private function stopDargFun(e:MouseEvent):void
	{
		stage.removeEventListener(MouseEvent.MOUSE_UP, stopDargFun)
		this.stopDrag()
	}
	private function foundText(value:String,w:Number=100,size:int=10,mouse:Boolean=true,select:Boolean=false,h:Number=16):TextField {
		var text:TextField = new TextField()
		text.setTextFormat(new TextFormat(null, size))
		text.selectable=select
		text.mouseEnabled = mouse;
		text.width = w
		text.height=h
		text.text=value
		return text
	}
	private function foundBtn(value:String='',w:int=100,h:int=16,data:*=null):MovieClip {
		var btn:MovieClip=new MovieClip()
		var text:TextField = foundText(value, w, 10, false, false, h)
		btn.addChild(text)
		btn.text = text
		btn.data = data
		btn.value=value
		btn.mouseChildren = false
		btn.buttonMode = true
		btn.graphics.beginFill(0xcccccc)
		btn.graphics.lineStyle(0.1,0x515151)
		btn.graphics.drawRect(0,0,w,h)
		return btn
	}

	public function show():void {
		DebugOutput.show()
		setSize(stage.stageWidth,stage.height)
	}
	public function hit():void {
		DebugOutput.hit()
	}
	/**
	 * 更新数据
	 */
	public function upData():void {
		if(!dataDic)return
		dataArr=dataDic[type] as Array
		upPage()
	}
	public function upPage():void {
		if (!dataArr||dataArr.length==0) return
		if (pageNum >= dataArr.length) { pageNum = dataArr.length - 1 }
		if (fixedBool) {
			pageNum = dataArr.length - 1
		}
		pageText.text = pageNum + 1 + '/' + dataArr.length
		infoTxt.htmlText = (dataArr[pageNum] as Array).join("")
		if (fixedBool) {
			infoTxt.scrollV = infoTxt.maxScrollV
			upTextToSliderShow()
		}
	}
	private function ppBtn(e:MouseEvent):void
	{
		var btn:MovieClip =e.target as MovieClip
		var text:String = btn.text.text
		if (text == '<<') pageNum = 0
		else if (text == '<') pageNum = pageNum - 1 >= 0?pageNum - 1:0
		else if (text == '>') pageNum = pageNum + 1 < dataArr.length?pageNum + 1:dataArr.length - 1
		else if (text == '>>') pageNum = dataArr.length - 1
		upData()
	}
	/**
	 * 更新日志内如
	 */
	public function upType():void {
		while (nav.numChildren > 0) nav.removeChildAt(0)
		var text:TextField
		//trace('---------------')
		var _x:uint = 0
		typeArr = new Array()
		var btn:MovieClip
		var oldx:int = 0

		for (var i:* in DebugOutput.getDic())
		{
			var lenght:int=String(i).length
			btn = foundBtn(String(i), lenght*8+3, 16, i)
			typeArr.push(btn)
			btn.x = oldx
			btn.text.x=1
			oldx+=(lenght *8+4)
			nav.addChild(btn)
			btn.addEventListener(MouseEvent.CLICK,btnClick)
		}
		if (typeArr && typeArr[0] != null) {
			btn = typeArr[0]
			selectType(btn.data as String)
		}

	}

	private function btnClick(e:MouseEvent):void
	{
		var btn:MovieClip=e.target as MovieClip
		selectType(btn.data as String)
	}

	public function selectType(value:String):void {
		if (titleText) titleText.text = value
		type=value
		//dataDic = DebugOutput.getDic()
		pageNum = 0
		upData()
	}
	public function get dataDic():Dictionary{return DebugOutput.getDic()}
	//private var type:String
	/**
	 * 清空当前类型
	 * @param	e
	 */
	private function clearFun(e:MouseEvent):void
	{
		DebugOutput.clearType(type)
	}
	private var windowMaxMinBool:Boolean=false
	/**
	 * 窗口最大化最小化
	 */
	public function windowMaxMin():void {
		if (!windowMaxMinBool) {
			if (stage) {
				setSize(stage.stageWidth, stage.stageHeight)
				x=y=0
			}
			windowMaxMinBool=true
		}else {
			setSize(250, 100)
			windowMaxMinBool=false
		}
	}

	/**设置大小*/
	public function setSize(w:Number, h:Number):void {
		if (w != _width || h != _height) {

			if (w != _width) {
				if(w<250)w=250
				_width = w;
			}
			if (h != _height) {
				if(h<200)h=200
				_height = h;
			}
			upSize();
		}
	}
	/**设置高度*/
	override public function set height(value:Number):void {
		if (value < 0) return
		setSize(_width,value);
	}
	override public function get height():Number{return _height;}
	/**设置宽度*/
	override public function set width(value:Number):void{
		if (value < 0) return
		setSize(value,_height);
	}
	override public function get width():Number { return _width; }

	/**
	 * 更新大小
	 */
	public function upSize():void {
		//trace(width,height)
		topBg.width = width
		window.x = width - 160
		wtext.text = width + ''
		htext.text = height + ''
		bottom.y = height - 16
		bottomBtn.x = width - 16
		bottomBtn.y=height - 16
		bg.graphics.clear()
		bg.graphics.lineStyle(.1,0x0,.5)
		bg.graphics.beginFill(0xffffff, .6)
		bg.graphics.drawRect(0, 0, width, height)
		bg.graphics.beginFill(0, 0)
		bg.graphics.drawRect(0,height - 16, width, 16)
		infoPanel.y = 24
		infoPanel.x=width - 220
		infoTxt.y = 43
		infoTxt.width = width - 20
		infoTxt.x = 5

		infoTxt.height = height - (infoTxt.y + 16 + 4)
		infoScrollBg.height = infoTxt.height
		infoScrollBar.x = infoTxt.x + infoTxt.width+2
		infoScrollBar.y=infoTxt.y
		nav.x = 5
		nav.y = height - 16
		upTextToSliderShow()
	}
}