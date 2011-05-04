package  
{
	
	/**
	 * 简单选择按钮
	 * @author spe
	 */
	import flash.display.Sprite
	import flash.events.*
	import com.ixiyou.speUI.controls.MCheckButton
	//import lib.CheckButtonSkin1;
	public class CheckButtonDemo extends Sprite 
	{
		
		public function CheckButtonDemo() {
			var btn1:MCheckButton = new MCheckButton({label:'ddddddddddddd'})
			btn1.select=true
			btn1.enabled = false
			btn1.enabled = true
			//btn1.setSize(100, 50)
			//btn1.labelText.textSize=18
			var btn3:MCheckButton = new MCheckButton( { x:200, y:200 } )
			btn3.setSize(200,200)
			var btn2:MCheckButton = new MCheckButton({select:true,x:100})
			addChild(btn1)
			addChild(btn2)
			addChild(btn3)
			btn3.selectLock=true
			btn3.select = true
			btn3.selectLock = false
			btn3.select = true
		}
		
	}
	
}