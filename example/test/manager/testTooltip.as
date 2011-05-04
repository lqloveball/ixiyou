package  
{
	
	/**
	 * ...
	 * @author spe
	 */
	import flash.display.*;
	import com.ixiyou.managers.ToolTipManager;
	import com.ixiyou.speUI.controls.MButton;
	import com.ixiyou.speUI.controls.MToolTip;
	public class testTooltip extends Sprite
	{
		private var btn3:Sprite
		public function testTooltip() 
		{
			
			this.stage.scaleMode=StageScaleMode.NO_SCALE
			this.stage.align = StageAlign.TOP_LEFT;
			
			var btn1:Sprite = new Sprite()
			btn1.name='btn1'
			btn1.graphics.beginFill(0xff00ff)
			btn1.graphics.drawRect(0,0,100,20)
			addChild(btn1)
			var tool1:Shape=new Shape()
			tool1.graphics.beginFill(0x0)
			tool1.graphics.drawCircle(3, 3, 5);
			ToolTipManager.getInstance().push(btn1, tool1);
			/*
			var btn2:MButton = new MButton({x:100,y:100,toolTip:'dddd'})
			addChild(btn2)
			
			btn3=new Sprite()
			btn3.name='btn3'
			btn3.graphics.beginFill(0xff00ff)
			btn3.graphics.drawRect(0, 0, 100, 20)
			btn3.x = btn3.y = 200
			addChild(btn3)
			var tool3:MToolTip = new MToolTip({bg:0x00ff00, label:'哇哈哈3' } )
			ToolTipManager.getInstance().push(btn3, tool3)
			*/
		}
		
	}
	
}