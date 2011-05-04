package  com.ixiyou.media
{
	
	/**
	* 对设想头操作
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import flash.events.EventDispatcher
	import flash.events.Event
	import flash.media.Camera
	public class MCamera extends EventDispatcher
	{
		private var _camera:Camera//摄像设备
		private var _status:String//工作状态
		private var _fps:uint=25//帧频率
		private var _width:uint=120//宽
		private var _height:uint=80//高
		private var _bandwidth:int=56384//输出输入最大带宽,字节数56384=56K
		private var _quality:int=100//画面质量 1-100
		public function MCamera() 
		{
			camera = Camera.getCamera();
			if(camera!=null){
				updateSize()
				_status="视频输入设备初始化"
			}
			else
			{
				_status="error:目前视频输入设备"
			}
		}
		/**输出输入最大带宽,字节数56384=56K
		 * 
		 * @param 
		 * @return 
		*/
		public function set bandwidth(value:int):void 
		{
			_bandwidth=value
			updateSize()
		}
		public function get bandwidth():int { return _bandwidth; }
		/**画面质量 1-100
		 * 
		 * @param 
		 * @return 
		*/
		public function set quality(value:int):void 
		{
			_quality=value
			updateSize()
		}
		public function get quality():int { return _quality; }
		/**
		 * 覆盖，指示组件的宽度
		 * @return 
		 */	
		 public function get width():Number{
			return _width;
		}
		
		public function set width(value:Number):void{
			if(_width != value){
				setSize(value,_height);
			}
		}
		/**
		 * 覆盖，指示组件的高
		 * @return 
		 */	
		 public function get height():Number{
			return _height;
		}
		 public function set height(value:Number):void{
			if(_height != value){
				setSize(_width,value);
			}
		}
		/**
		 * 设置组件大小
		 * @param width
		 * @param height
		 * 
		 */	
		public function setSize(w:uint, h:uint):void {
			if(w != _width || h != _height){
				if (w != _width)_width = w;
				if (h != _height)_height = h;
				updateSize();
				dispatchEvent(new Event("resize"))//大小变化事件
			}
			
		}
		/**更新组件大小
		 * 
		 */		
		public function updateSize():void {
			if (camera)
			{
				//更新设想头的宽，高，帧数，
				//trace(_fps)
				camera.setMode(width, height,_fps, true)
				camera.setQuality(_bandwidth,_quality) 
			}
		}
		public function set camera(value:Camera):void 
		{
			_camera=value
		} 
		public function get camera():Camera{return _camera}
		
	}
	
}