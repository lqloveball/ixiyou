package com.ixiyou.speUI.util 
{
	/**
	 * 按钮皮肤的创建
	 * @author spe
	 */
	import flash.display.*
	import flash.events.*
	import flash.geom.Rectangle
	import com.ixiyou.speUI.collections.ScaleBitmap;
	import com.ixiyou.utils.display.BitmapData2String;
	import com.ixiyou.utils.display.BitmapSpeUtil;
	public class MButtonSkinsUtil
	{
		
		/**
		 * BitmapData 方式生产ButtonSkin或MCheckButtonSkin者皮肤,如果是CheckBtn一定要有select
		 * @param	up
		 * @param	down
		 * @param	over
		 * @param	pd
		 * @param	select null时候不创建select=null不能给CheckButton当皮肤
		 * @param	rect 
		 * @param	box
		 * @return
		 */
		public static function getButtonSkinByBitmapData(up:BitmapData, down:BitmapData, over:BitmapData, pd:BitmapData,select:BitmapData=null,
													rect:Rectangle=null,box:Sprite=null):Sprite {
			if (!box) box = new Sprite()
			var _temp:ScaleBitmap 
			_temp= new ScaleBitmap(up);
			if(rect)_temp.scale9Grid = rect
			_temp.name = '_upState';
			box.addChild(_temp)
			
			_temp= new ScaleBitmap(over);
			if(rect)_temp.scale9Grid = rect
			_temp.name = '_overState';
			box.addChild(_temp)
			//_temp.y=30
			
			_temp= new ScaleBitmap(down);
			if(rect)_temp.scale9Grid = rect
			_temp.name = '_downState';
			box.addChild(_temp)
			//_temp.y=60
				
			_temp= new ScaleBitmap(pd);
			if(rect)_temp.scale9Grid = rect
			_temp.name = '_pdState';
			box.addChild(_temp)	
			
			if (select) {
				_temp = new ScaleBitmap(select);
				if(rect)_temp.scale9Grid = rect
				_temp.name = '_selectState';
				box.addChild(_temp)
			}
			return box
		}
		/**
		 *  DisplayObject 方式生产ButtonSkin或MCheckButtonSkin者皮肤,如果是CheckBtn一定要有select
		 * @param	upState
		 * @param	downState
		 * @param	overState
		 * @param	pdState
		 * @param	selectState null时候不创建select=null不能给CheckButton当皮肤
		 */
		public static function getButtonSkinByDisplayObject( upState:DisplayObject, 
										downState:DisplayObject, overState:DisplayObject, pdState:DisplayObject,selectState:DisplayObject=null,
										box:Sprite=null):Sprite {
			if (!box) box = new Sprite()
			upState.name = '_upState';
			box.addChild(upState)
			
			overState.name = '_overState';
			box.addChild(overState)	

			
			downState.name = '_downState';
			box.addChild(downState)

			pdState.name = '_pdState';
			box.addChild(pdState)
			
			if (selectState) {
				selectState.name = '_selectState';
				box.addChild(pdState)
			}
			return box
		}
		/**
		 * 通过图片字符转译 方式生产ButtonSkin或MCheckButtonSkin者皮肤,如果是CheckBtn一定要有select
		 * @param	_upStr
		 * @param	_overStr
		 * @param	_downStr
		 * @param	_pdStr
		 * @param	selectStr
		 * @param	rect
		 * @param	box
		 */
		public static function getButtonSkinByString(_upStr:String, _overStr:String, _downStr:String, 
												_pdStr:String, selectStr:String = null , rect:Rectangle = null,
												box:Sprite=null
												):Sprite {	
			if (!box) box = new Sprite()
			var _temp:ScaleBitmap 
			_temp= new ScaleBitmap(BitmapData2String.decode64(_upStr));
			if(rect)_temp.scale9Grid = rect
			_temp.name = '_upState';
			box.addChild(_temp)
			
			_temp= new ScaleBitmap(BitmapData2String.decode64(_overStr));
			if(rect)_temp.scale9Grid = rect
			_temp.name = '_overState';
			box.addChild(_temp)

			
			_temp= new ScaleBitmap(BitmapData2String.decode64(_downStr));
			if(rect)_temp.scale9Grid = rect
			_temp.name = '_downState';
			box.addChild(_temp)

				
			_temp= new ScaleBitmap(BitmapData2String.decode64(_pdStr));
			if(rect)_temp.scale9Grid = rect
			_temp.name = '_pdState';
			box.addChild(_temp)
			if (selectStr) {
				_temp= new ScaleBitmap(BitmapData2String.decode64(_pdStr));
				if(rect)_temp.scale9Grid = rect
				_temp.name = '_selectState';
				box.addChild(_temp)
			}
			return box
		}
		
	}

}