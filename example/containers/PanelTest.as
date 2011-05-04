package  
{
	/**
	 * 
	 * @author spe
	 */
	import com.ixiyou.managers.DragRectManager;
	import com.ixiyou.speUI.collections.BgShape;
	import com.ixiyou.speUI.containers.MPanelBase;
	import com.ixiyou.speUI.containers.MPanel;
	import com.ixiyou.speUI.core.SpeComponent;
	import flash.display.Shape;
	import flash.display.Sprite
	import flash.events.Event;
	public class PanelTest extends Sprite
	{
		
		public function PanelTest() 
		{
			x = 100
			y=100
			var p:MPanelBase = new MPanelBase( { title:'测试~~~~', dragBool:true, allDrag:true, topFloor:true,dragType:DragRectManager.DIRECT} )
			p.addEventListener(SpeComponent.AUTO_SIZE,function():void{trace('------')})
			addChild(p)
			var testC:Sprite = new Sprite()
			testC.graphics.beginFill(0x0)
			testC.graphics.drawRect(0, 0, 1000, 1000)
			p.add(testC)
			var c:MPanel= new MPanel({title:'测试~~~~',dragBool:true,allDrag:true,topFloor:true,dragType:DragRectManager.CLONERECT})
			addChild(c)
		}
		
	}

}