package com.ixiyou.utils.display
{
	
	/**
	* 图片 2进 字符间转换
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	import flash.display.BitmapData;  
    import flash.geom.Rectangle;  
    import flash.utils.ByteArray;  
	import com.ixiyou.utils.data.Base64
	public class BitmapData2String 
	{
		/**
		 * 位图转64位后转 字符串 
		 * @param 
		 * @return 
		*/
		public static function encode64(img:BitmapData):String{
			//var a:uint = getTimer();
			var result:String = "";
			result=Base64.encodeByteArray(encodeByteArray(img))
			return result;
		}
		/**
		 * 64位字符串 转 位图
		 * @param bmp 显示的图片对象
		 * @return 
		*/
		public static function decode64(data:String):BitmapData{
			return decodeByteArray(Base64.decodeToByteArray(data));  
		}
		/**图片到字节
		* ...
		* @author 
		*/
		public static function encodeByteArray(data:BitmapData):ByteArray{  
            if(data == null){  
                throw new Error("data参数不能为空!");  
            }  
            var bytes:ByteArray = data.getPixels(data.rect);  
            bytes.writeShort(data.width);  
            bytes.writeShort(data.height);  
            bytes.writeBoolean(data.transparent);  
            bytes.compress();  
            return bytes;  
        }  
		/**字节到图片
		* ...
		* @author 
		*/
		public static function decodeByteArray(bytes:ByteArray):BitmapData{  
            if(bytes == null){  
                throw new Error("bytes参数不能为空!");  
            }  
            bytes.uncompress();  
            if(bytes.length <  6){  
                throw new Error("bytes参数为无效值!");  
            }             
            bytes.position = bytes.length - 1;  
            var transparent:Boolean = bytes.readBoolean();  
            bytes.position = bytes.length - 3;  
            var height:int = bytes.readShort();  
            bytes.position = bytes.length - 5;  
            var width:int = bytes.readShort();  
            bytes.position = 0;  
            var datas:ByteArray = new ByteArray();            
            bytes.readBytes(datas,0,bytes.length - 5);  
            var bmp:BitmapData = new BitmapData(width,height,transparent,0);  
            bmp.setPixels(new Rectangle(0,0,width,height),datas);  
            return bmp;  
        }	
	}
	
}