package com.ixiyou.speUI.containers 
{
	
	/**
	 * 程序文档类
	 * @author ...
	 */
	import flash.display.StageScaleMode
	import flash.display.StageAlign
	import flash.display.StageDisplayState
	public class Application extends Canvas
	{
		private var _stageAlign:String
		private var _stageScaleMode:String
		public function Application(config:*=null) 
		{
			super(config)
			this.autoSize=true
		}
		/**
		 * 初始化
		 * @param 
		 * @return 
		*/
		override public function initialize():void
		{
			super.initialize()
			stageScaleMode = StageScaleMode.NO_SCALE;
			stageAlign= StageAlign.TOP_LEFT;
		}
		/**
		 * 场景全屏
		 * */
		public function set displayState(value:Boolean):void {
			if (!stage) return
			if (value) this.stage.displayState = StageDisplayState.FULL_SCREEN
			else this.stage.displayState = StageDisplayState.NORMAL
		}
		public function get displayState():Boolean {
			if (this.stage.displayState == StageDisplayState.FULL_SCREEN ) return true
			else return false
		}
		/**
		 * 场景对齐方式
		 * */
		public function set stageAlign(value:String):void 
		{
			if(value==stageAlign)return
			if (value == StageAlign.TOP_LEFT || value == StageAlign.BOTTOM || value == StageAlign.BOTTOM_LEFT||
			value == StageAlign.LEFT || value == StageAlign.RIGHT || value == StageAlign.TOP ||
			value == StageAlign.TOP_RIGHT) {
				if(stage)stage.align = value
			}
		}
		public function get stageAlign():String { return stage.align; }
		/**
		 * 场景模式
		 */
		public function set stageScaleMode(value:String):void 
		{
			if (stageScaleMode == value) return
			if (value == StageScaleMode.EXACT_FIT || value == StageScaleMode.NO_BORDER||
			value ==StageScaleMode.NO_SCALE||value ==StageScaleMode.SHOW_ALL) {

				if(stage)stage.scaleMode = value
			}
			
		}
		public function get stageScaleMode():String { return _stageScaleMode; }
	}
	
}