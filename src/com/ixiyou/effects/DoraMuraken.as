
package com.ixiyou.effects  {
	/**
	 * 电视麻花效果
	 * 使用例子:
		[Embed(source = 'lib/img/img0.png')]
			var tempc:Class
			[Embed(source = 'lib/img/img1.png')]
			var temp2:Class
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE
			this.stage.align=StageAlign.TOP_LEFT
			
			var d:DoraMuraken = new DoraMuraken()
			d.autoSize=true
			this.stage.addChild(d)
			d.sorce = new tempc() as DisplayObject;
			d.sorce = new temp2() as DisplayObject;
	 */
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BitmapDataChannel;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.media.Camera;
    import flash.media.Video;
	import com.ixiyou.speUI.core.SpeComponent
   
    public class DoraMuraken extends SpeComponent
	{
        private var bmp:Bitmap= new Bitmap();;
        private var BMD_WIDTH:Number = 300;
        private var BMD_HEIGHT:Number = 300;
        private var baseColor:uint = 0x000000;
        private var baseBmd:BitmapData;
        private var editBmd:BitmapData;
        private var noiseBmd:BitmapData;
        private var sandstormBmd:BitmapData;
        private var _sorce:DisplayObject;
        private var baseMatrix:Matrix;
        private var pointArray:Array;
        private var randArray1:Array;
        private var randArray2:Array;
        private var randNum1:Number;
        private var bmdUpNum:Number;
        private var video:Video;
        private var _bmp:Bitmap;
        private var camera_width:int;
        private var camera_height:int;
		private var _keyCnt:Number = 0;
		private var _Bool:Boolean=true
        public function DoraMuraken(config:*=null):void {
			super(config)
			if (config) {
				if (config.sorce != null) sorce = config.sorce 
				if (config.Bool != null)Bool=config.Bool 
			}
			if (width <= 0) this.width = 100
			if (height <= 0) this.height = 100
			
			bmp.visible = Bool;
            addChild(bmp);
			BMD_WIDTH = this.width
			BMD_HEIGHT = this.height
            baseBmd = new BitmapData(BMD_WIDTH, BMD_HEIGHT, false, baseColor);
            editBmd = baseBmd.clone();
            noiseBmd = baseBmd.clone();
            sandstormBmd = baseBmd.clone();
            baseMatrix = new Matrix();
            pointArray = new Array(new Point(0, 0), new Point(0, 0), new Point(0, 0));
            randArray1 = new Array(Math.random() + 1, Math.random() + 1, Math.random() + 1);
            randArray2 = new Array(0, 0, 0);
            randNum1 =0.5
            bmdUpNum = 0;
            bmp.bitmapData = noiseBmd;
            bmp.smoothing = true;
            bmp.visible = false;
            addEventListener(Event.ENTER_FRAME, upDate);
            
			
			
        }
		public function get Bool():Boolean { return _Bool; }
		public function set Bool(value:Boolean):void 
		{
			if (_Bool == value) return
			_Bool = value
		}
		/**
		 * 输入对象
		 */
		public function set sorce(value:DisplayObject):void { 
			if (_sorce == value) return
			_sorce = value
			_sorce.visible = false;
		}
		public function get sorce():DisplayObject { return _sorce; }
		
		/**组件大小更新*/
		override public function upSize():void {
			//var W:Number = this.width
            //var H:Number = this.height
            baseMatrix = new Matrix();
			if (baseBmd) {
				baseBmd.dispose()
				baseBmd=null
				BMD_WIDTH = this.width
				BMD_HEIGHT = this.height
				baseBmd = new BitmapData(BMD_WIDTH, BMD_HEIGHT, false, baseColor);
				editBmd = baseBmd.clone();
				noiseBmd = baseBmd.clone();
				sandstormBmd = baseBmd.clone();
				baseMatrix = new Matrix();
				pointArray = new Array(new Point(0, 0), new Point(0, 0), new Point(0, 0));
				randArray1 = new Array(Math.random() + 1, Math.random() + 1, Math.random() + 1);
				randArray2 = new Array(0, 0, 0);
				randNum1 =0.5
				bmdUpNum = 0;
				bmp.bitmapData = noiseBmd;
			}
            bmp.x = bmp.y = 0;
		}
        
        private function upDate(e:Event):void {
			if (!Bool) {
				bmp.visible = false
				return
			}else {
				bmp.visible=true
			}
            var copy_bmd:BitmapData = baseBmd.clone();
            copy_bmd.draw(sorce, baseMatrix);
            editBmd = copy_bmd.clone();
            for (var i:int = 0; i < 3; i++) {
                if (randArray1[i] >= 1){
                    --randArray1[i];
                    randArray2[i] = Math.random() / 4 + 0.03;
                } 
                randArray1[i] = randArray1[i] + randArray2[i];
                _keyCnt += (48-_keyCnt) / 4;
                pointArray[i].x = Math.ceil(Math.sin(randArray1[i] * Math.PI * 2) * randArray2[i] * _keyCnt*2);
                pointArray[i].y = 0;
            }
            
            var keyNum:Number = 1*(Math.abs(pointArray[0].x) + Math.abs(pointArray[1].x) + Math.abs(pointArray[2].x) + 8) / 4;

            i = BMD_HEIGHT;
            while (i--){
                var offset:Number = Math.sin(i / BMD_HEIGHT * (Math.random() / 8 + 1) * randNum1 * Math.PI * 2)* 0.8 * keyNum * keyNum;
                editBmd.copyPixels(copy_bmd, new Rectangle(offset, i, BMD_WIDTH - offset, 1), new Point(0, i));
            }
            sandstormBmd.noise(int(Math.random() * 1000), 0, 255, 7, false);
            var sandNum:Number = 40;
            editBmd.merge(sandstormBmd, editBmd.rect, new Point(0,0), sandNum, sandNum, sandNum, 0);
            noiseBmd.copyChannel(editBmd, noiseBmd.rect, pointArray[0], BitmapDataChannel.RED, BitmapDataChannel.RED);
            noiseBmd.copyChannel(editBmd, noiseBmd.rect, pointArray[1], BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
            noiseBmd.copyChannel(editBmd, noiseBmd.rect, pointArray[2], BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
        }
    }
}