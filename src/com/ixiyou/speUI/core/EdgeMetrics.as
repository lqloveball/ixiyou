package  com.ixiyou.speUI.core
{
	
	/**
	 * 边界对象 拥有 上 下 左 右 边的距离
	* 
	* @author spe  
	*/
	import flash.display.DisplayObject
	import flash.events.Event;
	import flash.geom.Rectangle
	import flash.events.EventDispatcher
	public class EdgeMetrics extends EventDispatcher
	{
		private var _bottom:Number;

		private var _left:Number;

		private var _right:Number;
		
		private var _top:Number;
		//边界发生改变
		[Event(name="upEdgeMetrics", type="flash.events.Event")]
		public static const UPEDGEMETRICS:String="upEdgeMetrics"
		public function EdgeMetrics(left:Number = 0, top:Number = 0,
									right:Number = 0, bottom:Number = 0) 
		{
			this.left = left;
			this.top = top;
			this.right = right;
			this.bottom = bottom;
		}
		public function setEdgeMetrics(left1:Number = 0, top1:Number = 0,
									right1:Number = 0, bottom1:Number = 0):void 
		{
			var bool:Boolean=false
			if (_left != left1) {
				_left = left1;
				bool=true
			}
			if (_top != top1) {
				_top = top1;
				bool=true
			}
			if (_right != right1) {
				_right = right1;
				bool=true
			}
			if (_bottom != bottom1) {
				_bottom = bottom1;
				bool=true
			}
			if(bool)dispatchEvent(new Event(EdgeMetrics.UPEDGEMETRICS))
		}
		public function set left(value:Number):void 
		{
			if(_left==value)return
			_left = value
			this.dispatchEvent(new Event(EdgeMetrics.UPEDGEMETRICS))
		}
		public function get left():Number { return _left; }
		
		public function set right(value:Number):void 
		{
			if(_right==value)return
			_right = value
			this.dispatchEvent(new Event(EdgeMetrics.UPEDGEMETRICS))
		}
		public function get right():Number { return _right; }
		
		
		public function set top(value:Number):void 
		{
			if(_top==value)return
			_top=value
			this.dispatchEvent(new Event(EdgeMetrics.UPEDGEMETRICS))
		}
		public function get top():Number { return _top; }
		
		
		public function set bottom(value:Number):void 
		{
			if(_bottom==value)return
			_bottom = value
			this.dispatchEvent(new Event(EdgeMetrics.UPEDGEMETRICS))
		}
		public function get bottom():Number { return _bottom; }
		
		
		
		//复制一个边界定义
		public function clone():EdgeMetrics
		{
			return new EdgeMetrics(left, top, right, bottom);
		}
		
		//上下边界高度和
		public function get height():Number {
			return top+bottom
		}
		//左右边界高度和
		public function get width():Number {
			return left+right
		}
		/**
		 * 2个边界是否相等
		 * @param e
		 * @return 
		 * 
		 */		
		public function equals(value:EdgeMetrics):Boolean{
			if(value.left != this.left) return false;
			if(value.right != this.right) return false;
			if(value.top != this.top) return false;
			if(value.bottom != this.bottom) return false;
			return true;
		}
		//
		override public function toString():String{
			var result:String = 'EdgeMetrics#';
			result += "left:" + left;
			result += ",right:" + right;
			result += ",top:" + top;
			result += ",bottom:" + bottom;
			return result;
		}
	}
	
}