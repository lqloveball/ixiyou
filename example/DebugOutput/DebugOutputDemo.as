package  
{
	import flash.display.*;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.utils.getTimer;
	import flash.utils.setInterval
	/**
	 * ...
	 * @author spe email:md9yue@@q.com
	 */
	public class DebugOutputDemo extends Sprite 
	{
		//[Embed(source = '../../lib/test/pic/ScrollBarTest.png')]
		//private var img:Class
		//private var bmp:Bitmap
		public function DebugOutputDemo() 
		{
			//bmp = new img() as Bitmap
		
			//addChild(bmp)
			DebugOutput.add('sdfsdfsdfsdfsdfasdfa/n\nsdfsfs\n\fsfasdfs\n', ['dsfsdfsd', 1, 5, 6, .59],new Sprite(),'sdfasdfsadfsad')
			DebugOutput.add('1', ['dsfsdfsd', 1, 5, 6, .59])
			DebugOutput.add('2', ['dsfsdfsd', 1, 5, 6, .59])
			DebugOutput.push('log', ['dsfsdfsd', 1, 5, 6, .59])
			DebugOutput.push('error', ['dsfsdfsd', 1, 5, 6, .59])
			DebugOutput.setStage(stage)
			DebugOutput.show()
			for (var i:int = 0; i < 100; i++) 
			{
				DebugOutput.push('log',[i,'中文', 1, 5, 6, .59])
			}
			setInterval(function():void {
				var xml:XML=<data><page>1</page><page>2</page></data>
				DebugOutput.add( xml)
				DebugOutput.push('log', [getTimer(), 1, 5, 6, .59])
				DebugOutput.push('Eroor', [getTimer(), 1, 5, 6, .59])
				DebugOutput.push('Data', [getTimer(), 1, 5, 6, .59])
				DebugOutput.push('Game', [getTimer(), 1, 5, 6, .59])
			},500)
		}
		
	}

}