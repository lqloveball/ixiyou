package  
{
	
	/**
	 * ...
	 * @author spe
	 */
	import flash.display.*;
	import com.ixiyou.managers.MouseManager
	import flash.events.Event;
	public class MouseManagerc extends Sprite
	{
		
		public function MouseManagerc() 
		{
			var m:Shape = new Shape();
			m.graphics.beginFill(0xff0000);
			m.graphics.drawCircle(3, 3, 3);
			var v:Shape = new Shape();
			v.graphics.beginFill(0xff00ff);
			v.graphics.drawCircle(3, 3, 3);
			//移动开后鼠标样式
			
			//MouseManager.getInstance().dmouseStyle = c
			MouseManager.getInstance().setDefaultStyle(this.stage,m)
			//MouseManager.getInstance().push(this.stage,m,false)
			//按钮
			var btn:Sprite = new Sprite();
			btn.graphics.beginFill(0x00ff00)
			btn.graphics.drawRect(0, 0, 100, 100)
			addChild(btn)
			//按钮鼠标样式
			var d:Shape = new Shape();
			d.graphics.beginFill(0x0);
			d.graphics.drawCircle(3, 3, 3);
			//添加到鼠标样式控制器中
			MouseManager.getInstance().push(btn, d)
			MouseManager.getInstance().push(btn, v)
			
			btn.addEventListener(MouseManager.MOUSESTYLEOUT, fun)
			btn.addEventListener(MouseManager.MOUSESTYLEOVER, fun)
			
			//按钮
			var btn1:Sprite = new Sprite();
			
			btn1.graphics.beginFill(0x00ffff)
			btn1.graphics.drawRect(0, 0, 100, 100)
			btn1.x=50
			btn.addChild(btn1)
			var c:Shape = new Shape();
			c.graphics.beginFill(0xffffff);
			c.graphics.drawCircle(3, 3, 3);
			//添加到鼠标样式控制器中
			MouseManager.getInstance().push(btn1,c)
			btn1.addEventListener(MouseManager.MOUSESTYLEOUT, fun)
			btn1.addEventListener(MouseManager.MOUSESTYLEOVER,fun)
			
		}
		private function fun(e:Event):void {
			trace(e.type,e.target['name']+":鼠标样式")
		}
	}
	
}