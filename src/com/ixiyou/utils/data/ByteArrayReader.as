package com.ixiyou.utils.data
{
	import flash.utils.ByteArray;

	/**
	 * ByteArray读取器
	 * 
	 * @author 
	 * 
	 */
	public class ByteArrayReader
	{
		public var data:ByteArray;
		
		private var bitPos:int = 0;//在一个Byte型里从左到右的位的坐标
		/**
		 * 开始读取时的位置
		 */
		public var startPosition:int;
		
		public function ByteArrayReader(data:ByteArray)
		{
			this.data = data;
			startPosition = data.position;
		}
		
		/**
		 * 目前已读取的数据量
		 * @return 
		 * 
		 */
		public function get bytesReaded():int
		{
			return data.position - startPosition;
		}
		
	
		
		/**
		 * 读取一个ByteArray
		 * 
		 * @param size	大小
		 * @return 
		 * 
		 */
		public function readByteArray(size:int):ByteArray
		{
			var newBytes:ByteArray = new ByteArray();
			data.readBytes(newBytes,0,size);
			return newBytes;
		}
		
		/**
		 * 读取一个对象。如果读取失败，则将position移回原值
		 * 
		 * @return 
		 * 
		 */
		public function readObject():Object
		{
			var oldPosition:int;
			oldPosition = data.position;
			try
			{
				var o:Object = data.readObject();
			}
			catch (e:Error)
			{
				data.position = oldPosition;
			};
			
			return o;
		}
	}
}