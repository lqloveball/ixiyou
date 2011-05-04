package 
{
	
	
	/**
	 * ...
	 * @author ...
	 */
	import com.ixiyou.speUI.containers.Application;
	import flash.display.DisplayObject;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class Main extends Application 
	{
		private var appBase:AppBase
		public function Main():void {super()}
		/**重写添加显示对象到层方法
		 * 实现只能加载一个显示对象
		 * */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject 
		{
			for ( var i:int= 0; i < numChildren; i++){	
				this.removeChild(getChildAt(i))
			}
			return super.addChildAt(child,index)
		}
		override public function initialize():void {
			//设置是否全屏模式
			this.displayState = true
			this.stageScaleMode=StageScaleMode.SHOW_ALL
			//初始化程序单例
			appBase = AppBase.getInstance()
			//单例绑定主场景
			appBase.root = this
			trace("[Main]")
			//设置程序开始运行
			appBase.control.AppStart()
		}
	}
	
}