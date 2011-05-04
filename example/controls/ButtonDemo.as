package 
{
	
	/**
	 * 按钮
	 * @author spe
	 */
	import flash.display.Shape;
	import flash.display.Sprite;
	import com.ixiyou.speUI.controls.MButtonBase
	import com.ixiyou.speUI.controls.MButton
	import flash.events.MouseEvent;
	public class ButtonDemo  extends Sprite
	{
		
		public function ButtonDemo() 
		{
			var spe:Shape = new Shape()
			spe.graphics.beginFill(0x0)
			spe.graphics.drawCircle(3,3,3)
			var b:MButtonBase = new MButtonBase({x:200,y:10,toolTip:'dddd'})
			addChild(b)
			b.addEventListener(MouseEvent.MOUSE_DOWN, function():void { b.startDrag() } )
			stage.addEventListener(MouseEvent.MOUSE_UP,function():void{b.stopDrag()})
			b.setSize(200,100)
			
			var a:MButton = new MButton( { label:'按钮dddddd', x:100, y:100, toolTip:spe } )
			addChild(a)
			//a.startDrag()
			a.label = "按钮dddddd"
			//trace("d")
			//a.enabled=false
			a.setLocation(100, 100)
			a.setSize(300,200)
		}
		
	}
	
}