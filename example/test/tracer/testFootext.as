package  
{
	import flash.display.*;
	import com.ixiyou.effects.*
	import flash.events.*;
	/**
	 * ...
	 * @author spe
	 */
	public class testFootext extends Sprite
	{
		[Embed(source = '../../../lib/test/pic/ScrollBarTest.png')]
		private var ddd:Class
		private var pDist:PerlinDistort
		public function testFootext() 
		{
			
			init()
		}
		private function init():void{
			var targetClip:Bitmap = new ddd();
			addChild(targetClip);
			targetClip.x = 70;
			targetClip.y = 155;
			//targetClip.buttonMode = true;
			pDist = new PerlinDistort(targetClip,100,100);
			addChild(pDist);
			stage.addEventListener(MouseEvent.MOUSE_UP,doTransition);
			pDist.addEventListener("NOISE_ON_COMPLETE",transitionComplete);
			pDist.addEventListener("NOISE_OFF_COMPLETE", restartTransition);
		}
		private function doTransition(e:MouseEvent):void {
			removeEventListener(MouseEvent.MOUSE_UP,doTransition);
			pDist.start_noise();
		};
		private function transitionComplete(e:Event):void {
			pDist.end_noise();
		};
		
		private function restartTransition(e:Event):void {
			addEventListener(MouseEvent.MOUSE_UP,doTransition);
			pDist.noise_reset();
		};
		
	}

}