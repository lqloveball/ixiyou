package com.ixiyou.speUI.util
{
	/**
	 * 用于开始创建按钮工具
	 * @author spe
	 */
	import flash.display.*
	import flash.events.*
	import flash.geom.Rectangle
	import com.ixiyou.speUI.mcontrols.MovieToCheck2
	import com.ixiyou.speUI.mcontrols.MovieToCheck6
	import com.ixiyou.speUI.mcontrols.MovieToBtn3
	import com.ixiyou.speUI.controls.MButtonBase
	import com.ixiyou.speUI.controls.MButton
	import com.ixiyou.speUI.controls.MCheckButton
	public class MButtonUtils
	{
		
		
		/**
		 * 快速创建 SimpleButton 按钮
		 * @param	upState 
		 * @param	overState
		 * @param	downState
		 * @param	hitTestState
		 * @return
		 */
		public static function fillSimpleButton(upState:DisplayObject,overState:DisplayObject=null,downState:DisplayObject=null,hitTestState:DisplayObject=null):SimpleButton {
			var btn:SimpleButton = new SimpleButton()
			if ( hitTestState == null) btn.hitTestState = upState;
			else btn.hitTestState = hitTestState;
			if (overState == null && downState == null) {
				btn.upState = upState;
				btn.overState = upState;
				btn.downState = upState;
			}
			else if (downState == null) {
				btn.upState = upState;
				btn.overState = overState;
				btn.downState = overState;
			}
			else if (overState == null) {
				btn.upState = upState;
				btn.overState = upState;
				btn.downState = downState;
			}
			return btn;
		}
		/** 
		 * 创建双向按钮 开 关
		 * @param	value 一个2帧的影片对象
		 */
		public static function fillCheckBox2Frames(value:MovieClip,bool:Boolean=true):MovieToCheck2 {
			if (value.totalFrames == 2) {
				var _x:Number = value.x
				var _y:Number=value.y
				var temp:MovieToCheck2 = new MovieToCheck2(value)
				if (bool) {
					temp.x = _x
					temp.y=_y
				}
				return temp
			}
			else throw new Error("MButtonUtils:创建CheckBox使用的MovieClip不符合规格,帧数应为2");
		}
		/** 
		 * 创建单选或复选按钮 
		 * @param	value 一个6帧的影片对象
		 */
		public static function fillCheckBox6Frames(value:MovieClip,bool:Boolean=true):MovieToCheck6 {
			if (value.totalFrames == 6) {
				var _x:Number = value.x
				var _y:Number=value.y
				var temp:MovieToCheck6 = new MovieToCheck6(value)
				if (bool) {
					temp.x = _x
					temp.y=_y
				}
				return temp
			}
			else throw new Error("MButtonUtils:创建CheckBox使用的MovieClip不符合规格,帧数应为6");
		}
		/** 
		 * 创建按钮，带禁止使用功能
		 * @param	value 一个3帧的影片对象
		 */
		public static function fillBtn3Frames(value:MovieClip,bool:Boolean=true):MovieToBtn3 {
			if (value.totalFrames == 3) {
				var _x:Number = value.x
				var _y:Number=value.y
				var temp:MovieToBtn3 = new MovieToBtn3(value)
				if (bool) {
					temp.x = _x
					temp.y=_y
				}
				return temp
			}
			else throw new Error("MButtonUtils:创建MovieToBtn3使用的MovieClip不符合规格,帧数应为3");
		}
	}

}