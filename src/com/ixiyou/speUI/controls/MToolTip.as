package com.ixiyou.speUI.controls 
{
	
	/**
	 * 提示框组件
	 * @author spe
	 */
	import com.ixiyou.speUI.core.IBackground
	import flash.display.BitmapData;
	import com.ixiyou.utils.display.MFilters
	public class MToolTip extends MLabel implements IBackground
	{
		private var _bg:Object
		public function MToolTip(config:*=null) 
		{
			this.mouseChildren = false
			this.mouseEnabled=false
			_bg=0xffffff
			super(config)
			truncateToFit=false
			if (config) {
				if (config.bg != null) bg = config.bg
				if(config.label!=null)text=config.label
			}
		}
		public function set bg(value:*):void {
			if(value==_bg)return
			if (value == null || value is uint || value is BitmapData) { 
				if(value==null)value=0xffffff
				_bg = value				
				drawBg()
			}
		}
		public function get bg():*{return _bg}
		public function drawBg():void {
			this.graphics.clear()
			if(bg==null)return
			if (bg is uint) {
				this.graphics.beginFill(bg as uint)
			}
			else if(bg is BitmapData){
				this.graphics.beginBitmapFill(bg as BitmapData)
			}
			this.graphics.drawRoundRect(0, 0, this.width, this.height,5,5)
			this.filters=[MFilters.getShadowFilter()]
		}
		/**
		 * 计算大小
		 */
		override protected function dealSize():void {
			//无切断
			var _w:Number
			var _h:Number
			if (!truncateToFit) {
				_w = _label.textWidth + 4 + this._ico.width
				if(_ico.width>0)_w+=_icoGap
			}
			else _w = this.width - this._ico.width
			if ( _label.textHeight + 4 > _ico.height)_h = _label.textHeight + 4
			else _h = _ico.height+4
			setSize(_w,_h)
		}
		/**组件大小更新*/
		override public function upSize():void {
			_label.width = this.width - ico.width			
			_label.height = this.height
			_label.x = ico.width
			if (ico.width > 0) {
				_label.width -= _icoGap
				_label.x+=_icoGap
			}
			ico.y = (this.height - ico.height) / 2
			drawBg()
			
			
		}
	}
	
}