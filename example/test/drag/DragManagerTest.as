package  
{
	import com.ixiyou.managers.DragManager;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author magic
	 */
	public class DragManagerTest extends Sprite
	{
		
		public function DragManagerTest() 
		{
			var con:Sprite = new Sprite();
			con.x = 400;
			con.y = 200;
			addChild(con);
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0);
			sp.graphics.drawRect(0, 0, 100, 100);
			con.addChild(sp);
			var dm:DragManager = new DragManager(sp);
			dm.register();
			var stopHandler:Function = function(dm:DragManager):void {
				var pt:Point = con.globalToLocal(new Point(dm.dragIcon.x, dm.dragIcon.y));
				sp.x = pt.x
				sp.y = pt.y;
			}
			DragManager.startDrag(sp, DragManager.DIRECT,null,false);
			DragManager.register(sp, "icon", null, true,0.5,null, stopHandler);
			
			var spa:Sprite = new Sprite();
			spa.graphics.beginFill(0xff0000);
			spa.graphics.drawCircle(0, 0, 50);
			spa.x = spa.y = 300;
			var icon:Shape = new Shape();
			icon.graphics.beginFill(0x330000, 0.3);
			icon.graphics.drawCircle(0, 0, 30);
			addChild(spa);
			stopHandler = function(dm:DragManager):void {
				dm.target.x = dm.dragIcon.x;
				dm.target.y = dm.dragIcon.y;
			}
			DragManager.register(spa, "icon", icon, true, 0.5,new Rectangle(200,200,300,300), stopHandler);
			
			var spb:Sprite = new Sprite();
			spb.graphics.beginFill(0xff00);
			spb.graphics.drawCircle(0, 0, 50);
			addChild(spb);

			var moveHandler:Function = function(dm:DragManager):void {
				//trace(drag.x, drag.y);
			}
			var startHandler:Function = function(dm:DragManager):void {
				trace("start drag");
			}
			DragManager.register(spb, DragManager.DIRECT, null, false, 0.1,null, stopHandler, startHandler, moveHandler);
		}
	}
}