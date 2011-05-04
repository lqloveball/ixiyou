package com.ixiyou.FMS
{
	import com.ixiyou.FMS.FMSBase;
	import com.ixiyou.FMS.IFMSClient;
	import com.ixiyou.FMS.events.FmsEvent;
	import com.ixiyou.utils.ObjectUtil;
	
	import flash.events.EventDispatcher;

	/**
	 * 客户端
	 * @author spe
	 */
	public class FmsClient extends EventDispatcher implements IFMSClient
	{
		private var _fms:FMSBase
		public function FmsClient() {}
		public function set fmsBase(value:FMSBase):void {if(_fms==null)_fms=value}
		public function get fmsBase():FMSBase { return _fms }
		public function fmsCall(obj:Object):void {
			if (obj == null && obj.type == null) return
			if(obj.type!='dummyChipIn')DebugOutput.add('fms ---> [ '+obj.type+' ]'+' data:'+obj.data)
			dispatchEvent(new FmsEvent(obj.type,obj.data))
		}
		/**
		 * 关闭FMS连接
		 */
		public function close():void {
			if (_fms) {
				trace('fmsClient断开')
				_fms.close()
			}
		}
	}

}