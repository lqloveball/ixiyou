package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import caurina.transitions.Tweener
	import flash.events.Event;
	/**
	 * ...
	 * @author spe email:md9yue@qq.com
	 */
	public class testDarwLine extends Sprite
	{
		private var obj:Shape = new Shape()
		private var px:uint=0
		private var py:uint=0
		public function testDarwLine() 
		{
			draw(Math.random() * 100, Math.random() * 100, Math.random() * 400, Math.random() * 400)
			
		}
		
		
		
		
		public function draw(px:uint,py:uint,_x:uint,_y:uint):void {
			obj.x=this.px = px
			obj.y=this.py = py
			Tweener.addTween(obj, { time:1, x:_x,y:_y,onUpdate:upLine,onComplete:onComplete } )
		}
		
		private function onComplete():void
		{
			trace('end----',px,py,obj.x,obj.y)
			draw(obj.x,obj.y,Math.random()*400,Math.random()*400)
		}
		
		private function upLine():void {
			this.graphics.clear()
			trace(px,py,obj.x,obj.y)
			this.graphics.lineStyle(1,0x0)
			this.graphics.moveTo(px, py)
			this.graphics.lineTo(obj.x,obj.y)
		}
	}

}