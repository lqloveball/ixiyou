package  
{
	import com.ixiyou.events.ListEvent;
	import com.ixiyou.speUI.controls.MComboBox;
	import flash.display.Sprite;
	/**
	 * 下拉框控件
	 * @author spe
	 */
	public class MComboBoxDemo extends Sprite
	{
		private var comboBox:MComboBox
		public function MComboBoxDemo() 
		{
			var dataArr:Array = new Array()
			for (var i:int = 0; i <1000; i++) 
			{
				dataArr.push({label:'我的spe:'+i, data:i})
			}
			//comboBox = new MComboBox( { listDirection:8, x:100, y:100 } )
			comboBox = new MComboBox( )
			comboBox.data=dataArr
			addChild(comboBox)
			graphics.beginFill(0)
			comboBox.addEventListener(ListEvent.UPSELECT,listUp)
			//trace(comboBox.data)
		}
		private function listUp(e:ListEvent):void {
			trace(e.data.label,e.data.data)
		}
	}

}