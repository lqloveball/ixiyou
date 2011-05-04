package com.ixiyou.utils 
{
	/**
	 * 版本比较
	 * @author magic
	 */
	
	/**
	 * 版本比较	当版本1高于版本2时返回1，小于时返回-1，等于时返回0
	 * @example compareVersions("1.0.2","0.9.9")  //return 1
	 * @param	version1	版本1
	 * @param	version2	版本2
	 * @return	当版本1高于版本2时返回1，小于时返回-1，等于时返回0
	 */
	public function compareVersions(version1:String, version2:String):int {
		if (version1 == version2) return 0;
		var arrVersion1:Array = version1.match(/\d+/g);
		var arrVersion2:Array = version2.match(/\d+/g);
		while (arrVersion1.length > 0 || arrVersion2.length > 0) {
			var v1:int = int(arrVersion1.length > 0?arrVersion1.shift():0);
			var v2:int = int(arrVersion2.length > 0?arrVersion2.shift():0);
			if (v1 < v2) return -1;
			if (v1 > v2) return 1;
		}
		return 0;
	}
}