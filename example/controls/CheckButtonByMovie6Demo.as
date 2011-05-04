package  
{
	/**
	 * ...
	 * @author spe
	 */
	import com.ixiyou.managers.CheckManager;
	import flash.display.Sprite
	import flash.events.*
	import com.ixiyou.speUI.controls.MCheckButtonByMovie6
	public class CheckButtonByMovie6Demo extends Sprite
	{
		
		public function CheckButtonByMovie6Demo() 
		{
			var btner:CheckManager=new CheckManager(false)
			var btn:MCheckButtonByMovie6 = new MCheckButtonByMovie6({width:100,height:30,x:100,y:100,label:'label'})
			addChild(btn)
			btner.push(btn)
			btn = new MCheckButtonByMovie6({width:100,height:30,x:100,y:150,label:'label'})
			addChild(btn)
			btner.push(btn)
			btn = new MCheckButtonByMovie6( { width:100, height:30, x:100, y:200, label:'label' } )
			addChild(btn)
			btner.push(btn)
			btn = new MCheckButtonByMovie6({width:100,height:30,x:100,y:250,label:'label'})
			addChild(btn)
			btner.push(btn)
			
		}
		
	}

}