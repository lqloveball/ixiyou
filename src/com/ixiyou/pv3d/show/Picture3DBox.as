package com.ixiyou.pv3d.show
{
	
	/**
	 * 3D展示盒子-(3D 墙)
	 * 
	 * 
	   //------------------------------------
		<?xml version="1.0" encoding="utf-8" ?>
		<root> 
			<!--allEntry记录条数  entry每也记录数 nowPage当前页码-->
			<list allEntry="30" entry="6" nowPage="1"/> 
			<data>
				<entry id="1" image="img/1.png" caption="2009年第1周" />
				<entry id="2" image="img/2.png" caption="2009年第2周" />
				<entry id="5" image="img/3.png"caption="2009年第3周" />
				<entry id="6" image="img/4.png" caption="2009年第4周" />
				<entry id="8" image="img/5.png" caption="2009年第5周" />
				<entry id="9" image="img/6.png" caption="2009年第6周" />
			</data>
		</root>
		//------------------------------------

		stage.align = StageAlign.TOP_LEFT;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		
		//创建展示盒子
		_picBox = new Picture3DBox()
		addChild(_picBox)
		_picBox.init(640, 480, false)
		_picBox.addEventListener(Picture3DBox.PREVIOUS, previousClick)
		_picBox.addEventListener(Picture3DBox.NEXT, nextClick)
	 * @author spe
	 */
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.*;
	import flash.net.URLLoader
	import flash.net.URLRequest
	import org.papervision3d.materials.BitmapMaterial;
	
	//3D类 
	import com.ixiyou.pv3d.Pager3DBase;
	import com.ixiyou.pv3d.show.objects.PicLoadObj;
	import org.papervision3d.events.InteractiveScene3DEvent
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.objects.primitives.Plane;
	//
	import com.ixiyou.utils.display.BitmapData2String;
	import caurina.transitions.Tweener;
	
	
	public class Picture3DBox extends Pager3DBase 
	{
		//加载数据的对象
		private var _loader:URLLoader = new URLLoader()
		//数据的XML对象
		private var _dataXml:XML
		
		//界面元素数组
		private var _dataArr:Array
		//
		private var _dataObjArr:Array
		//图像界面大小
		private var _picw:uint = 118
		private var _pich:uint = 157
		///图像间隔啊
		private var _picg:uint = 20
		//一行的个数
		private var lineNum:uint=3
		//事件类型
		//数据开始加载
		public static var DATASTARTLOAD:String = 'dataStartLoad';
		//数据加载完成
		public static var DATALOADEND:String = 'dataLoadend';
		//设置数据完成
		public static var SETDATA:String = 'setData';
		//
		public static var PREVIOUS:String = 'previous';
		//
		public static var CLICKDATE:String = 'clickDate';
		//
		public static var NEXT:String = 'next';
		//按钮
		//按钮bitmapData的String数据形势
		private var _btnStr2:String = 'eNrVnF9kXEEUxk+VUkIppZRSlhJCKXkqpZRSSmiUUEqIJpLdvfsUQggllBBKKKWUpVJCCSGEEkopIfqwREN0K3F3L0tZQkjne+lD5c/e7+E7cy/nce1vZ84358w3c3fUkswK8GSWtO9b0oqds2O1LA2sN0LEznkc4mvgvGTDP2LnRCxZrV0ETsRIpLn6P2c3zP+AJQexcyJ2AusVG/sZOydiNTL9n8aJmI2oBpzFeRQ4H1mSxs6JQL26ZZMHsXMivod11bsG9MKJeOe8rvbKiRh11FUezsMw/3et3IqdE7EXxvSaTe2rObeDno9zsq6HXL1ow8tKzn6byv4QrPMO9eqpVbO8nIjHVpXXgIWgkbycyO2SuF4h3zYJVuT3ZUt+KVmv20S6T+Rq3SFX71k5PSTGteJQA/CdeTnx2/Ab1ax1Yv6RM8gdJSe0wdSAL+Ez6hpw2yqtDrGuLjjsr4eIMUWgdqhZ5wlW1GLUZHUNQO+Rl7XhsL9GL7dHrFcrDjUAPTJTA6YdWMetmnv+sb/28FjfWy03q4fHihqwRawBHh4rvIeMYPXwWOHpHBFrwAuryllnCU54rHfEexbUgDVi/ndDXBXvA/B9u0QP4OGxYh67xLh6eKzQB1MDPDzWJaKuenisWMe/Eb3VlsP++qaVf6dErqIeq+f/oVXaTA1An6NmnSbG1MtjXSFYPTxW7DsaBfJYuwXxWEeItQox5MC6SLDC54DfoeQskf3qa+GY9tlEyvhVm+KzwM9E3VevT6zvo7xXwegcOfxEqJ3BMCax+yfwFJgziQ9CRtaHQN+q1DbTezTDZ5TaniN0o74z9cwqaew1HL0t0xPNCD0caLsZ+XkjtM3sL/EZ5f7yI7GON8We7QzhfyCHlfu0Ipx/sZ7XnPAsATWD0fYnISPrHeF+nlLbdbJuK7XNeDDI4UEhI3prZp+ovDuOPoa5L/ZK6BFC28z5gPKMGNouwr2rIpy11oiza+wrldrGHURG28+FfjW0zdwDUvqU0PYOsf7AN1L5vtD2BsEIbfcJ76m9JRihbZwTqRgnybMT9d1ERjce9xE6EXvQLOeqw53JvJzbzu+idXrUdsn5falOD9qO4b3e8zjHHM6Z83IuRvTO6Wmca47a7pWzUYD3TLMItH0eJ7T9wKEm5uUcj0TbZ3G+KcD/CWxEpu2THnhpsWn7pCf2/4/49/Tbywt/Adnrorc=';
		private var _btnStr1:String = 'eNrVnH9k1VEYxt9ERMSIGBEjRkT0V0REjDGaGBFjKtv99dcYY8SIMWJERFyyuIwxYsSIMcb0x5giLXfuuowxxqjzpMM1d9v9PpfnvPdw/vza5573Pc95z3POmZn/NmzFunfGe1bcrVvxt2fG7sBXC33PSm7H84INfv0SGP8ERs+cc1b6x+iZcyjkZGT0ynnTijsH/+PtlfOyjXzbOsbokXOxCaM3zsmg5c0YPXE+tGLtyDnndRvdqZ8Qby+c0PK1Bp30yvn2mE565Bw+JR+9cN623O5hC/FOyXnFxqo/MoxlCs7zNjj/qcWcbOwb4vpz+gz9adb3wze9NiYbzz4r1LIyoj+ygoyxJ6w3ewTjTJhrKsaLVvy5QcR7JTAin1WcZYKxGr65ai9qKsZ8Rv1Bh67etZyMEX8ri5bHnhfu1RGzKhHvslAnkfufCUbMNcw5FecMEWto1g3L76oYocmMlg8I4421bZ+I97SQEfvZTYIRNYlSyysEI2o71HgqxnGCEbqKWlnpTR4Ra85zK8gYozeZlfGdlWSMjd5klr4u1vI5QsvhJcBTUDE+tUJmRuQwvBkV462wdzgg4j0prIG6Ql59J9bEpfC7lFq+SIwjfleXcN5MEhqJ/ECeePEmT+qYb568yWZ9TryfXScYV8NainVAxYn1LSsj1tFrlvulYkSdwGj5A8vL4p3Vm4x9XFiXM94kekW8n2W8Sew3sO/w7E0eiL3JAYIRHee6Kkbs7xlvclbIiPaKGEtoUI+wnox7iBVCh+AHXRJ6lO3o0YJwHY8N9wi8+y6x9Yc5xdRwQ+I51Y6/cSfBuL4nvf9uMSs0YJVYQ9U+QtSAbWJcKwni3+wuUSt9KsG8Ytf+x5avqVknCK8GcVB6nLEx53/bCTQA85jRAHyj1gCMDaMBHxLUAcg5RgMmhP5IbJ1wnhXbFJGram8sto8EK/JbeW4UNWCN2AuoPah2NKCcIFdRezIaMJ6AdYjIVewd+oXn7rG9JLxI7MlQl6lZK+R5QwoNYO9VpdAA72e0jRrA+L0l4Zl3bE9I/7wvwdrK+KrwD9UaAJ96gYj/VoI6AL4eowHL4Ru1BuBcidGANwnWVvYO42gCVuY+RKp7/lm99lSc0IAs9w5Svu/A2VirGpD6vQzOTFrRAA/vpHD37SwN8PLubOSMOsDTO77ZU/YtnjihAUsd8C4yasBmB7wzjRpQd/5uN7b7YW097ID32miNd2k8c6K97oB3+lEDlp3/34NGDVhL4JuzfoD12rNzfwFYg6K3';
		//按钮图片
		private var _btn1:Plane
		private var _btn2:Plane
		//[Embed(source = '../../../../lib/btn-2.png')]
		//private var tBmp:Class
		public var nowDate:Object
		/**
		 * 构造函数
		 */
		public function Picture3DBox() {
			//var d:BitmapData = (new tBmp() as Bitmap).bitmapData
			//trace(BitmapData2String.encode64(d))
			_loader.addEventListener(Event.COMPLETE, completeHandler);
            _loader.addEventListener(Event.OPEN, openHandler);
            _loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            _loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            _loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            _loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		//加载指定列表
		public function loadXml(value:String):void {
			if(_loader.data)_loader.close()
			_loader.load(new URLRequest(value))
		}
		/**
		 * 加载完成
		 * @param	e
		 */
		private function completeHandler(e:Event):void {
			//trace('结束加载')
			var loader:URLLoader = URLLoader(e.target);
			dataXml=new XML(loader.data)
			dispatchEvent(new Event(Picture3DBox.DATALOADEND))
		}
		/**
		 * 开始加载
		 * @param	e
		 */
		private function openHandler(e:Event):void {
			//trace('开始加载')
			dispatchEvent(new Event(Picture3DBox.DATASTARTLOAD))
		}
		/**
		 * 加载中
		 * @param	e
		 */
		private function progressHandler(e:ProgressEvent):void { 
			//trace('加载...')
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,e.bytesLoaded,e.bytesTotal))
		}
		//加载的其他监听
		private function securityErrorHandler(e:SecurityErrorEvent):void { }
		private function httpStatusHandler(e:HTTPStatusEvent):void { }
		private function ioErrorHandler(e:IOErrorEvent):void { }
	
		/**
		 * 设置数据
		 * @param	value
		 */
		public function set dataXml(value:XML):void {
			_dataXml = value;
            //trace(dataXml);
			_dataArr = new Array();
			var temp:PicLoadObj;
			var obj:Object;
			//处理数据
			for (var i:int = 0; i <_dataXml.data.entry.length() ; i++) 
			{
				//解析出数据
				obj = { id:_dataXml.data.entry.@id[i], image:_dataXml.data.entry.@image[i], lable:_dataXml.data.entry.@caption[i] }
				_dataArr.push(obj)
			}
			//创建数据
			createData();
			dispatchEvent(new Event(Picture3DBox.SETDATA))
		}
		public function get dataXml():XML { return _dataXml; }
		/**
		 * 创建数据
		 */
		private function createData():void {
			var temp:PicLoadObj;
			var obj:Object;
			var i:int 
			//计算布局情况
			var bx:Number = -(_picw+_picg)*(lineNum/2)+(_picw+_picg)/2
			var by:Number = (_pich + 30 + _picg) * (lineNum / 2) - _pich - 60
			//如果有原始数据需要对原数据进行处理删除
			if (_dataObjArr) {
				for (i= 0; i <_dataObjArr.length ; i++) 
				{
					temp = _dataObjArr[i] as PicLoadObj
					temp.removeEventListener(PicLoadObj.ONCLICK, onClick)
					default_scene.removeChild(temp);
					//Tweener.addTween(temp, { time:.3,z: -100,onComplete:function():void {default_scene.removeChild(this);}				})
				}
			}
			//创建数据
			_dataObjArr = new Array()
			for (i= 0; i <_dataArr.length ; i++) 
			{
				obj = _dataArr[i]
				//创建对象
				temp = new PicLoadObj(_picw, _pich, obj);
				//添加对象
				default_scene.addChild(temp);
				//排版布局
				//trace((i / 3 >> 0) + " : " + (i % 3))
				temp.x=bx+_picw*Math.random()
				temp.y = by+_pich*Math.random()
				temp.alpha = 0
				//temp.scale = .1
				temp.z=500*Math.random()
				Tweener.addTween(temp,{time:1,alpha:1,z:0,x:bx+(_picw+_picg)*(i % 3),y:by - (_pich + 30 + _picg) * (i / 3 >> 0)})
				_dataObjArr.push(temp)
				temp.addEventListener(PicLoadObj.ONCLICK,onClick)
			}
		}
		/**
		 * 点击事件
		 * @param	e
		 */
		private function onClick(e:Event):void {
			var temp:PicLoadObj = PicLoadObj(e.target)
			//trace(temp.data.lable)
			nowDate = temp.data
			dispatchEvent(new Event(Picture3DBox.CLICKDATE))
		}
		
		/**
		 * 这里开始初始化我们所需要的任何对象
		 * @param	vpWidth
		 * @param	vpHeight
		 * @param	resizeBool
		 */
		override protected function initPapervision(vpWidth:Number, vpHeight:Number,resizeBool:Boolean=false):void { 
			super.initPapervision(vpWidth, vpHeight, resizeBool)
			//交互开启
			viewport.interactive=true
			//
			initCamera(250)
			//设置渲染的场景对象
			//renderer.renderScene(default_scene, default_camera, viewport)
			
		} 
		/**
		 * 初始化摄像机
		 */
		protected function initCamera(radial:Number):void {
			default_camera.focus = 300;
			default_camera.zoom = 1;
			default_camera.x = 0
			default_camera.y  = 0;
			//计算出相机半径
			var _cameraRadial:Number=(default_camera.focus * default_camera.zoom)+radial
			default_camera.z = -(default_camera.focus * default_camera.zoom)
			default_camera.rotationX=0
		}
		 /**
		 * 这个方法初始化所有舞台所需要的东西 ,比如模型，材质，摄像机，等等 
		  * @param 
		  * @return 
		*/ 
		override protected function init3d():void { 
			initObj() 
		} 
		/**
		 * 初始化模型
		 */
		protected function initObj():void {
			var tempMaterial:BitmapMaterial
			var tempBmp:BitmapData
			//创建按钮1
			tempBmp=BitmapData2String.decode64(_btnStr1)
			tempMaterial = new BitmapMaterial(tempBmp)
			tempMaterial.interactive = true;
			tempMaterial.smooth = true;
			_btn1 = new Plane(tempMaterial, tempBmp.width, tempBmp.height)
			default_scene.addChild(_btn1)
			//创建按钮2
			tempBmp=BitmapData2String.decode64(_btnStr2)
			tempMaterial = new BitmapMaterial(tempBmp)
			tempMaterial.interactive = true;
			tempMaterial.smooth = true;
			_btn2 = new Plane(tempMaterial, tempBmp.width, tempBmp.height)
			default_scene.addChild(_btn2)
			//安排按钮
			//计算布局情况
			var bx:Number = -(_picw+_picg)*(lineNum/2)+(_picw+_picg)/2
			var by:Number = (_pich + 30 + _picg) * (lineNum / 2) - _pich - 60
			
			_btn1.x = bx - tempBmp.width * 2 - _picg
			_btn2.x = -bx + tempBmp.width * 2 + _picg
			//按钮事件
			_btn1.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, btnClick);
			_btn2.addEventListener(InteractiveScene3DEvent.OBJECT_CLICK, btnClick);
		}
		private function btnClick(e:InteractiveScene3DEvent):void {
			//trace(e.target is Plane)
			if ( _btn1==e.target) {
				//trace("_btn1")
				dispatchEvent(new Event(Picture3DBox.PREVIOUS))
			}else {
				//trace("_btn2")	
				dispatchEvent(new Event(Picture3DBox.NEXT))
			}
		}
		/**
		 * 这个方法可以添加所有运动和动画的处理代码 
		 * @param 
		 * @return 
		*/
		override protected function processFrame():void { 
			if (stage) {
				default_camera.rotationY = 15 * ((stage.mouseX - stage.stageWidth / 2) / stage.stageWidth / 2)
				default_camera.rotationX=30*((stage.mouseY-stage.stageHeight/2)/stage.stageHeight/2)
			}
		} 
	}
	
}