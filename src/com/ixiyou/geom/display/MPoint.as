package com.ixiyou.geom.display
{
	
	/**
	* mPoint
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher
	import flash.geom.Point
	
	public class MPoint extends EventDispatcher
	{
		private var _x:Number;
		private var _y:Number;
		private var _upFrameDataBool:Boolean
		private var disObj:DisplayObject
		public function MPoint(_x:Number = 0,_y:Number = 0) 
		{
			this._x = _x
			this._y = _y
		}
		/**
		 * 返回该点距0点的距离
		 * @param 
		 * @return 
		*/
		public function get length():Number{
			updata();
			var num:Number = Math.sqrt(Math.pow(_x,2) + Math.pow(_y,2));
			return num;
		}
		/**
		 * 计算该点与另外一点的距离
		 * @param 
		 * @return 
		*/
		public function getToPoint(_mPoint:MPoint,isQuadrant:Boolean = false):Number{
		  updata();
		  var num:Number = Math.sqrt(Math.pow(_mPoint.x - _x, 2) + Math.pow(_mPoint.y - _y, 2));
		  //非负
		  if(!isQuadrant) num = Math.abs(num);
		  return num;
		}
		/**
		 * 计算该点与另外一点所形成的线段与水平线的夹角,按顺时间计算
		 * @param 
		 * @return 
		*/
		public function angle2(_mPoint:MPoint,isRadian:Boolean = false):Number{
		  updata();
		  var numx:Number = _mPoint.x - _x;
		  var numy:Number = _mPoint.y - _y;
		  var num:Number = Math.atan(numy/numx);
		  if(!isRadian) num = num * 180 / Math.PI;
		  return num;
		}

		/**
		 * 计算该点与另外一点所形成角,按顺时间计算
		 * @param isRadian 是否转弧度
		 * @return 
		*/
		public function angle(_mPoint:MPoint,isRadian:Boolean = false):Number{
			updata();
			var numx:Number = _mPoint.x - _x;
			var numy:Number = _mPoint.y - _y;
			var num:Number = Math.atan(numy/numx);
			if (!isRadian) {
				num = Math.abs(num) * 180 / Math.PI;// 弧度转角度
				var temp:int=quadrant(_mPoint)
				if (num == 0 &&temp==0&&_x>_mPoint.x) {
					num=0
				}
				else if(num == 0 &&temp==0&&_x<_mPoint.x) {
					num=180
				}
				else if(num == 90 &&temp==0&&_y>_mPoint.y) {
					num=270
				}else if (temp == 2) {
					num=180-num
				}
				else if (temp == 3) {
					num=180+num
				}
				else if (temp == 4) {
					num=360-num
				}
				//上面按数学顺时针计算，这里要倒过来下
				if(num!=0)num=360-num
				return num
			}
			else {
				return num
			}
		
		}
		/**
		 * 返回当前点处在另外一点的哪个象限中 或 返回另外一点处在当前点的哪个象限中,0为在坐标线上
		 * 21
		 * 34
		 * @param isMaster 反转象限
		 * @return 
		*/
		public function quadrant(_mPoint:MPoint,isMaster:Boolean = false):int{
		  updata();
		  if(_x == _mPoint.x || _y == _mPoint.y){
			return 0;
		  }
		  var num:int;
		  var p1:Boolean = (_x - _mPoint.x) > 0;
		  var p2:Boolean = (_y - _mPoint.y) > 0;
		  num = isMaster ? (p1 ? (p2 ? 2 : 3) : (p2 ? 1 : 4)) : (p1 ? (p2 ? 4 : 1) : (p2 ? 3 : 2));
		  return num;
		}
		/**
		 * 是否实时更新对象的X 与 Y 坐标
		 * @param 
		 * @return 
		*/
		public function set upFrameDataBool(value:Boolean):void 
		{
			if (value != _upFrameDataBool) {
				_upFrameDataBool = value
				if (disObj&&_upFrameDataBool) {
					disObj.addEventListener("enterFrame",enterFrameFun);
				}
				else {
					disObj.removeEventListener("enterFrame",enterFrameFun);
				}
			}
		}
		public function get upFrameDataBool():Boolean { return _upFrameDataBool; }
		/**
		 * 帧频繁事件
		 * @param 
		 * @return 
		*/	
		private function enterFrameFun(e:Object):void{
		  if(_x != disObj.x) x = disObj.x;
		  if(_y != disObj.y) y = disObj.y;
		}
		/**
		 * 清除显示对象
		 * @param 
		 * @return 
		*/
		public function clearDisObj():void{
		  disObj = null;
		  disObj.removeEventListener("enterFrame",enterFrameFun)
		}
		/**绑定显示对象
		 * 
		 * @param 
		 * @return 
		*/
		public function bindDisObj(disObj:DisplayObject,upFrameDataBool_:Boolean=false):void {
			this.disObj = disObj
			this.upFrameDataBool=upFrameDataBool_
		}
		/**
		 * 如果捆绑了显示对象更新xy数据
		 * @param 
		 * @return 
		*/
		public function updata():void{
		  if(disObj != null){
			_x = disObj.x;
			_y = disObj.y;
		  }
		}

		/**
		 * X坐标
		 * @param 
		 * @return 
		*/		
		public function set x(num:Number):void{
			_x = num;
			if(disObj != null) disObj.x = num;
			dispatchEvent(new Event("upData"));
			dispatchEvent(new Event("upData_x"));
		}
		public function get x():Number{
		  updata();
		  return _x;
		}
		/**
		 * Y坐标
		 * @param 
		 * @return 
		*/
		public function set y(num:Number):void{
			_y = num;
			if (disObj != null) disObj.y = num;
			dispatchEvent(new Event("upData"));
			dispatchEvent(new Event("upData_y"));
		}
		public function get y():Number{
		  updata();
		  return _y;
		}
		
	}
	
}