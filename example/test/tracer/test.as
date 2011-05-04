package  
{
	import flash.display.Sprite;
	import flash.events.MouseEvent
	/**
	 * ...
	 * @author spe
	 */
	public class test extends Sprite
	{
		
		public function test() 
		{
			var fun:Function=function(value:int):Function {
				var f:Function = function():void { trace(value) }
				return f
			}
			for (var i:int = 0; i < 10000; i++) 
			{
				var temp:Sprite = new Sprite()
				addChild(temp)
				temp.graphics.beginFill(0x0)
				temp.graphics.drawRect(0, 0, 100, 30)
				temp.y = i * 31
				temp.addEventListener(MouseEvent.CLICK, fun(i))
			}
		}
		private function fun1(value:int):Function {
			var f:Function = function():void {trace(value) }
			return f
		}
		//好玩的写法：
			var connect:Function = function(xp:Number, yp:Number, col:uint=0):Function{
				graphics.lineStyle(0,col);
				graphics.moveTo(xp, yp);
				var line:Function = function(xp:Number, yp:Number):Function{
					graphics.lineTo(xp, yp);
					return line;
				}
				return line;
			}
			 
			// draw a triangle
			connect(200,100)(300,300)(100,300)(200, 100);
			 
			// draw a box
			connect(100,100, 0xFF0000)(150,100)(150,150)(100, 150)(100,100);
	}

}