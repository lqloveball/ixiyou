package 
{
	
	/**
	 * 测试列表组件
	 * @author spe
	 */
	import com.ixiyou.speUI.controls.MButton;
	import com.ixiyou.speUI.controls.MVList;
	import flash.display.Sprite;
	import flash.events.Event
	import flash.events.MouseEvent;
	public class MVList_test  extends Sprite
	{
		private var removeNum:uint=0
		public function MVList_test() 
		{
			var dataArr:Array = new Array()
			for (var i:int = 0; i <122000; i++) 
			{
				dataArr.push({label:'spe:'+i, data:i})
			}
			var list:MVList = new MVList({x:100,y:100,data:dataArr,height:200})
			addChild(list)
			var btn:MButton = new MButton( {width:50, x:100, y:300, label:'清空' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK, function():void { list.data = null } )
			btn = new MButton( {width:50, x:160, y:300, label:'添加' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK, function():void { list.add( { label:'spe:' + list.data.length, data:list.data.length } ) } )
			btn = new MButton( {width:80, x:220, y:300, label:'添加指定位置' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK, function():void { list.addAt( { label:'spe:' + list.data.length, data:list.data.length }, 1) } )
			btn= new MButton( {width:80, x:100, y:340, label:'删除指定位置' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK, function():void { list.removeAt(0) } )
			
			btn= new MButton( {width:100, x:200, y:340, label:'删除指定属性值' } )
			addChild(btn)
			btn.addEventListener(MouseEvent.CLICK, function():void {
				removeNum+=1
				list.removeByProperty('data',removeNum) })
		}
		
	}
	
}