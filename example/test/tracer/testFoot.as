package  
{
	import com.ixiyou.speUI.controls.MButton;
	import com.ixiyou.speUI.controls.MTextInput;
	import flash.display.Sprite;
	import com.ixiyou.effects.FooText
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author spe
	 */
	public class testFoot extends Sprite
	{
		private var text:FooText = new FooText()
		private var btn:MButton
		private var btn1:MButton
		private var input:MTextInput
		public function testFoot() 
		{
			btn = new MButton( { x:120, y:10, label:'生成' , parent:this } )
			btn1 = new MButton( { x:200, y:10, label:'清除' ,parent:this } )
			input=new MTextInput({ x:10, y:10, label:'Hello',parent:this })
			addChild(text)
			btn.addEventListener(MouseEvent.CLICK, function():void {
				text.startDraw(input.label)
			})
			btn1.addEventListener(MouseEvent.CLICK, function():void {
				text.clearDraw()
			})
			text.y=300
		}
		
	}

}