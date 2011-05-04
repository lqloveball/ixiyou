package  
{
	import com.ixiyou.speUI.controls.MVListPanel;
	import flash.display.Sprite;
	
	/**
	 * 带背景列表组件
	 * @author spe
	 */
	
	public class MVListPlanelDemo extends Sprite
	{
		private var list:MVListPanel=new MVListPanel()
		public function MVListPlanelDemo() 
		{
			var dataArr:Array = new Array()
			for (var i:int = 0; i <1000; i++) 
			{
				dataArr.push({label:'spe:'+i, data:i})
			}
			list = new MVListPanel({ x:50, y:50, data:dataArr, height:200 })
			addChild(list)
			list.width=350
		}
		
	}

}