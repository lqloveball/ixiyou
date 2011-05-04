package com.ixiyou.pv3d 
{
	
	/**
	*  使用Papervision3D_2.0_beta_1_src
	* http://papervision2.com/tutorial-list/
	* 教材来自
	* http://bogey.cn/?cat=50&paged=2
	* 
	* @author spe
	*/
	//导入所需的类 
	import flash.display.Sprite; // To extend this class.PaperBase  
	import flash.events.Event; // To work out when a frame is entered. 
	//创建papervison3d程序必须的类 
	import org.papervision3d.view.Viewport3D; // We need a viewport.viewPort 
	//导入所有的摄像机  
	import org.papervision3d.cameras.*; // Import all types of camera 
	//papervision3d程序需要至少1个Scene3D对象 
	import org.papervision3d.scenes.Scene3D; // We'll need at least one scene 
	//创建papervison3d程序必须的类 
	import org.papervision3d.render.BasicRenderEngine; // And we need a renderer 
	public class Pager3DBase  extends Sprite {
		//viewport
		public var viewport:Viewport3D;
		//渲染引擎 
		public var renderer:BasicRenderEngine; 
		// -- 场景 -- //  
		public var default_scene:Scene3D; // A Scene 
		// -- 摄像机 --// 
		public var default_camera:Camera3D; // A Camera 
		/**
		 * 构造函数
		 */
		public function Pager3DBase() 
		{
		}
		/**
		 * 初始化引擎
		 * @param	vpWidth 传递给initPapervision
		 * @param	vpHeight 传递给initPapervision
		 * @param	resizeBool 传递给initPapervision
		 */
		public function init(vpWidth:Number = 800, vpHeight:Number = 600,resizeBool:Boolean=false):void { 
			//初始化papervision 
			initPapervision(vpWidth, vpHeight,resizeBool); // Initialise papervision 
			//初始化3d物体  
			init3d(); // Initialise the 3d stuff.. 
			//初始化2d物体   
			init2d(); // Initialise the interface.. 
			//添加任何你所需要的监听器 
			initEvents(); // Set up any event listeners.. 
		} 
		/**
		 * 这里开始初始化我们所需要的任何对象 
		 * @param	vpWidth
		 * @param	vpHeight
		 * @param	resizeBool
		 */
		protected function initPapervision(vpWidth:Number, vpHeight:Number,resizeBool:Boolean=false):void { 
			//这里开始初始化我们所需要的任何对象 
			//渲染papervision场景 
			viewport = new Viewport3D(vpWidth, vpHeight,resizeBool); 
			//viewport作为一个对象被添加到flash的场景中 
			//当viewport被添加到flash舞台中时，你可以通过viewport来显示你的papervision 场景
			//添加viewport到flash舞台 
			addChild(viewport);
			//初始化渲染引擎 
			renderer = new BasicRenderEngine(); 
			//初始化papervision 场景 
			default_scene = new Scene3D(); 
			//初始化摄像机 
			//也可以传递参数给摄像机进行初始化
			//摄像机表示的是视角，作者传递是场景对象(不填参数默认是这个?) 
			//所以摄像机始终是再场景的正中间。 
			default_camera = new Camera3D(); 	
			default_camera.z=-500
		} 
		/**
		 * 3D场景的宽
		* @param 
		* @return 
		*/
		public function set viewportWidth(vpWidth:Number):void {
			if(!viewport.autoScaleToStage)viewport.viewportWidth=vpWidth
		}
		public function get viewportWidth():Number { return viewport.viewportWidth; }
		/**
		 * 修改3D场景的高
		* @param 
		* @return 
		*/
		public function set viewportHeight(vpHeight:Number):void {
			if(!viewport.autoScaleToStage)viewport.viewportHeight=vpHeight
		}
		public function get viewportHeight():Number { return viewport.viewportHeight; }
		/**
		 * 这个方法初始化所有舞台所需要的东西 ,比如模型，材质，摄像机，等等 
		  * @param 
		  * @return 
		*/ 
		protected function init3d():void { 
			
		} 
		/**
		 * 这个方法创建所有的2d对象，这些2d对象将出现再你的papervision物体的上一层 ,比如用户界面等等 
		 * @param 
		 * @return 
		*/
		protected function init2d():void {
		} 
		/**
		 * 这个方法添加呢监听器ENTER_FRAME,当然一些其他的监听也可以加再这里，比如键盘事件等 
		 * @param 
		 * @return 
		*/
		protected function initEvents():void { 
			addEventListener(Event.ENTER_FRAME, onEnterFrame); 
		} 
		/**
		 * 这个方法可以添加所有运动和动画的处理代码 
		 * @param 
		 * @return 
		*/
		protected function processFrame():void { 
			
		} 
		  
		protected function onEnterFrame(ThisEvent:Event ):void { 
			//渲染场景和更新 
			processFrame(); 
			renderer.renderScene(default_scene, default_camera, viewport); 
		} 
		
	}
	
}