package  
{
	import com.ixiyou.managers.TabManager;
	import com.ixiyou.speUI.controls.MButton;
	import com.ixiyou.speUI.controls.MTextInput;
	import flash.display.Sprite;
	
	/**
	 * 测试TAB
	 * @author spe email:md9yue@qq.com
	 */
	public class TabManagerTest extends Sprite
	{
		
		public function TabManagerTest() 
		{
			TabManager.instance.stage = this.stage
			TabManager.instance.focusRect = true
			TabManager.instance.customRectBool = true
			//TabManager.instance.tabChildren = false
			var btn:MButton
			var tinput:MTextInput
			var tBox:Sprite = new Sprite()
			addChild(tBox)
			var btnBox:Sprite = new Sprite()
			addChild(btnBox)
			btnBox.x=100
			var i:int = 0
			for (i=0; i < 10; i++) 
			{
				btn = new MButton( {label:'btn_'+i, x:Math.random() * 100 >> 0, y:i*20 } )
				btnBox.addChild(btn)
				
			}
			btn.tabIndex=1
			for (i=0; i < 10; i++) 
			{
				tinput = new MTextInput( { label:'input_' + i, x:Math.random() * 100 >> 0, y:i*20} )
				tBox.addChild(tinput)
			}
			tinput.textField.tabIndex=0
		}
		
	}

}