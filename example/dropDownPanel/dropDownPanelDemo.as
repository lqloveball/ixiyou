package  
{
	import com.ixiyou.speUI.controls.MButton;
	import com.ixiyou.speUI.controls.MTextInput;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import lib.dropDownPanelSkin;
	
	/**
	 * 测试 这个相当于文档类
	 * @author spe
	 */
	public class dropDownPanelDemo extends Sprite
	{
		//创建一个组件
		private var panel:dropDownPanel
		public function dropDownPanelDemo() 
		{
			//创建过程中，给构造函数内传入皮肤文件的实例
			panel = new dropDownPanel(new dropDownPanelSkin())
			//添加到场景
			addChild(panel)
			//刚开机的第一次编译会比较慢
			var input:MTextInput=new MTextInput({parent:this,label:'输入内容',x:panel.width+10})
			var btn:MButton = new MButton( { parent:this, label:'添加文本', x:panel.width + 10,y:input.height+10 } )
			btn.addEventListener(MouseEvent.CLICK, function():void {
				//trace(input.text)
				panel.info += '\n' + input.text
				input.text = '';
				}
			)
			btn= new MButton( { parent:this, label:'清空', x:btn.x+btn.width + 10,y:input.height+10 } )
			btn.addEventListener(MouseEvent.CLICK, function():void {
				//trace(input.text)
				panel.info = ''
				input.text = '';
				panel.selectShow(false)
				}
			)
		}
		
	}

}