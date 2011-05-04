package com.ixiyou.air.utils 
{
	import flash.events.Event
	import flash.filesystem.*;
	import flash.utils.ByteArray;
	/**
	 * 文件处理类
	 * @author spe
	 */
	public class AIRFileUtil
	{
		private static var oldOpenDirectory:File
		/**
		 * 指向用户的主目录
		 * @param	value 
		 * @return 您可以将 File 对象指向用户的主目录。
		 *  在 Windows 中，主目录是“My Documents”目录（例如，“C:\Documents and Settings\userName\My Documents”）的父级。
		 *  在 Mac OS 中，它是 Users/userName 目录。在 Linux 中为 /home/userName 目录。
		 */
		public static function userDirectory(value:String=''):File {
			return (value == '')?File.userDirectory: File.userDirectory.resolvePath(value); 
		}
		/**
		 * 指向用户的文档目录
		 * @param	value 
		 * @return 默认位置为“我的文档”目录（例如“C:\Documents and Settings\userName\My Documents”）。
		 * 在 Mac OS 中，默认位置为 Users/userName/Documents 目录。
		 * 在 Linux 中，默认位置为 /home/userName/Documents 目录。以下代码设置 File 对象以指向文档目录中的 AIR Test 子目录
		 */
		public static function documentsDirectory(value:String=''):File {
			return (value == '')?File.documentsDirectory: File.documentsDirectory.resolvePath(value); 
		}
		/**
		 * 指向桌面目录
		 * @param	value 
		 * @return 
		 */
		public static function desktopDirectory(value:String=''):File {
			return (value == '')?File.desktopDirectory: File.desktopDirectory.resolvePath(value); 
		}
		
		/**
		 * 每个已安装的 AIR 应用程序独有的存储目录文件夹
		 * @param	value 
		 * @return 应用程序存储目录的位置由用户名、应用程序 ID 和发布者 ID 共同确定：
		 * 
		 * 在 Mac OS 中，位于：
		 * /Users/用户名/Library/Preferences/应用程序 ID.发行商 ID/Local Store/
		 * 
		 * 在 Windows 中，位于 Documents and Settings 目录下的以下位置：
		 * 用户名/Application Data/应用程序 ID.发行商 ID/Local Store/
		 * 
		 * 在 Linux 中位于：
		 * /home/用户名/.appdata/应用程序 ID.发行商 ID/Local Store/
		 * 
		 * trace(dir.url); // app-storage:/preferences
		 */
		public static function applicationStorageDirectory(value:String=''):File {
			return (value == '')?File.applicationStorageDirectory:File.applicationStorageDirectory.resolvePath(value); 
		}
		/**
		 * 指向应用程序的安装目录，即应用程序目录。
		 * @param	value
		 * @return 应用程序的安装目录
		 * trace(dir.url); // app:/images
		 */
		public static function applicationDirectory(value:String=''):File {
			return (value == '')?File.applicationDirectory:File.applicationDirectory.resolvePath(value); 
		}
		/**
		 * 指向明确的目录
		 * @param	value "C:\\AIR Test\";
		 * @return
		 */
		public static function nativePath(value:String):File {
			var file:File = new File(); 
			file.nativePath = value
			return file
		}
		/**
		 * 指向明确的目录
		 * @param	value "file:///C:/AIR Test/"; 
		 * @return
		 */
		public static function getFileByUrl(value:String):File {
			var file:File = new File() 
			file.url = value; 
			return file
		}
		/**
		 * 让用户浏览以选择目录
		 * @param	title
		 * @param	selectFun
		 * @param	cancelFun
		 * @return
		 */
		public static function getDirectoryBySelect(title:String = '请选择', selectFun:Function = null,cancelFun:Function=null):File {
			var file:File = new File() 
			var select:Function= function(e:Event):void {
				if(selectFun!=null)selectFun(file)
			}
			var cancel:Function= function(e:Event):void {
				if(cancelFun!=null)cancelFun(file)
			}
			if(selectFun!=null)file.addEventListener(Event.SELECT, select); 
			if(cancelFun!=null)file.addEventListener(Event.CANCEL, cancel)
			try {
				file.browseForDirectory(title); 
			}catch (e:Error) {
				return null
			}
			return file
		}
		/**
		 * 选择文件
		 * @param	title
		 * @param	typeFilter
		 * @param	selectFun
		 * @param	cancelFun
		 * @return
		 */
		public static function getFileBySelect(title:String = '请选择',typeFilter:Array=null, selectFun:Function = null, cancelFun:Function = null):File {
			var file:File = new File() 
			var select:Function= function(e:Event):void {
				if(selectFun!=null)selectFun(file)
			}
			var cancel:Function= function(e:Event):void {
				if(cancelFun!=null)cancelFun(file)
			}
			if(selectFun!=null)file.addEventListener(Event.SELECT, select); 
			if(cancelFun!=null)file.addEventListener(Event.CANCEL, cancel)
			try {
				file.browseForOpen(title,typeFilter); 
			}catch (e:Error) {
				return null
			}
			return file
		}
		/**
		 * 列出子文件夹
		 * @return
		 */
		public static function getDirectoryList(file:File):Array {
			var contents:Array = file.getDirectoryListing(); 
			var arr:Array=new Array()
			for (var i:uint = 0; i < contents.length; i++)  
			{ 
				if(File(contents[i]).isDirectory)arr.push(contents[i])
			} 
			return arr
		}
		/**
		 * 列出子文件(不包括文件夹)
		 * @param	file
		 * @return
		 */
		public static function getFileList(file:File):Array {
			var contents:Array = file.getDirectoryListing(); 
			var arr:Array=new Array()
			for (var i:uint = 0; i < contents.length; i++)  
			{ 
				if (!File(contents[i]).isDirectory) {
					arr.push(contents[i])
					//trace(File(contents[i]).extension)
				}
			} 
			return arr
		}
		/**
		 * 列出文件列表 指定文件
		 * @param	file
		 * @param	extendsion
		 * @return
		 */
		public static function getFileListByExtension(file:File,extendsion:String='*'):Array {
			var contents:Array = file.getDirectoryListing(); 
			var arr:Array=new Array()
			for (var i:uint = 0; i < contents.length; i++)  
			{ 
				if (!File(contents[i]).isDirectory) {
					if(extendsion==''||extendsion=='*'||extendsion==File(contents[i]).extension)arr.push(contents[i])
				}
			} 
			return arr
		}
		/**
		 * 读取文件
		 * @param	file
		 */
		public static function readFileStreamAsync(file:File,complete:Function=null):FileStream  {
			var myFileStream:FileStream = new FileStream(); 
			var bytes:ByteArray = new ByteArray(); 
			var completeHandler:Function=function(e:Event):void  
			{ 
				//trace('异步',myFileStream.bytesAvailable)
				myFileStream.readBytes(bytes, 0, myFileStream.bytesAvailable);
				if (complete != null) complete(bytes)
				myFileStream.close()
			} 
			myFileStream.addEventListener(Event.COMPLETE, completeHandler); 
			try {
				myFileStream.openAsync(file, FileMode.READ);
			}catch (e:Error) {
				return null
			}
			return myFileStream
		}
		/**
		 * 读取文件
		 * @param	file
		 * @return
		 */
		public static function readFileStream(file:File):ByteArray {
			var myFileStream:FileStream = new FileStream(); 
			var bytes:ByteArray = new ByteArray(); 
			try {
				myFileStream.open(file, FileMode.READ);
				//trace('非异步',myFileStream.bytesAvailable)
				myFileStream.readBytes(bytes, 0, myFileStream.bytesAvailable);
			}catch (e:Error) {
				return null
			}
			return bytes
		}
		/**
		 * 写文件 直接写无提示框
		 * @param	file 文件地址
		 * @param	bytes 数据
		 * @param	append 是否是追加
		 * @return
		 */
		public static function saveFileStream(file:File,bytes:ByteArray,append:Boolean=false):Boolean {
			var myFileStream:FileStream = new FileStream(); 
			try {
				if (!append) myFileStream.open(file, FileMode.WRITE);
				else myFileStream.open(file, FileMode.APPEND);
				//trace('非异步',myFileStream.bytesAvailable)
				myFileStream.writeBytes(bytes, 0, bytes.length); 
				myFileStream.close()
				
			}catch (e:Error) {
				return false
			}
			return true
		}
		/**
		 * 打开位置 保存
		 * @param	bytes 数据
		 * @param	type 后缀名
		 * @param	title 保存框标题
		 * @param	overlay 是否覆盖
		 * @param	file 初始打开位置 默认文件夹
		 * @return
		 */
		public static function saveFileStreamBySelect(bytes:ByteArray,type:String='', title:String = 'Save',overlay:Boolean=false,file:File = null):Boolean {
		
			if (file == null) {
				if (oldOpenDirectory && oldOpenDirectory.exists && oldOpenDirectory.isDirectory) file = oldOpenDirectory;
				else file = File.documentsDirectory;
			}
			var newFile:File 
			var saveData:Function=function(event:Event):void 
			{
				newFile= event.target as File;
				//trace('wenj:',newFile.extension)
				if (newFile.extension == null) {
					if (type != null) newFile = new File( newFile.nativePath + '.' +	type);
				}else {
					//后缀名不同，
					if (type != null && newFile.extension != type) {
						//不覆盖，文件类型不同，不做任何操作
						//return 
						//用文件名重写创建
						//var str:String=newFile.nativePath.split('.')[0]
						//newFile= new File(str +'.' +	type)
					}
				}
				//newFile.nativePath.lastIndexOf('\/')
				//trace('存在:', newFile.exists)
				var stream:FileStream = new FileStream();
				if (!newFile.exists)
				{
					stream.open(newFile, FileMode.WRITE);
					stream.writeBytes(bytes);
					stream.close();
				}else {
					if(!overlay)return
					stream.open(newFile, FileMode.WRITE);
					stream.writeBytes(bytes);
					stream.close();
				}
			}
			try
			{
				file.browseForSave(title);
				file.addEventListener(Event.SELECT, saveData);
			}
			catch (error:Error)
			{
				return false
			}
			return true
		}
		/**
		 * string写入文件 直接写无提示框
		 * @param	file 文件地址
		 * @param	bytes 数据
		 * @param	append 是否是追加
		 * @return
		 */
		public static function saveString(file:File,value:String,append:Boolean=false):Boolean {
			var myFileStream:FileStream = new FileStream(); 
			try {
				if (!append) myFileStream.open(file, FileMode.WRITE);
				else myFileStream.open(file, FileMode.APPEND);
				//trace('非异步',myFileStream.bytesAvailable)
				myFileStream.writeUTFBytes(value); 
				myFileStream.close()
			}catch (e:Error) {
				return false
			}
			return true
		}
		/**
		 * 打开位置 保存
		 * @param	bytes 数据
		 * @param	type 后缀名
		 * @param	title 保存框标题
		 * @param	overlay 是否覆盖
		 * @param	file 初始打开位置 默认文件夹
		 * @return
		 */
		public static function saveStringBySelect(value:String,type:String='', title:String = 'Save',overlay:Boolean=false,file:File = null):Boolean {
			if (file == null) {
				if (oldOpenDirectory && oldOpenDirectory.exists && oldOpenDirectory.isDirectory) file = oldOpenDirectory;
				else file = File.documentsDirectory;
			}
			var saveData:Function=function(event:Event):void 
			{
				var newFile:File = event.target as File;
				//trace('wenj:',newFile.extension)
				if (newFile.extension == null) {
					if (type != null) newFile = new File( newFile.nativePath + '.' +	type);
				}else {
					//后缀名不同，
					if (type != null && newFile.extension != type) {
						//不覆盖，文件类型不同，不做任何操作
						//return 
						//用文件名重写创建
						//var str:String=newFile.nativePath.split('.')[0]
						//newFile= new File(str +'.' +	type)
					}
				}
				//trace('存在:', newFile.exists)
				var stream:FileStream = new FileStream();
				if (!newFile.exists)
				{
					stream.open(newFile, FileMode.WRITE);
					stream.writeUTFBytes(value);
					stream.close();
				}else {
					if(!overlay)return
					stream.open(newFile, FileMode.WRITE);
					stream.writeUTFBytes(value);
					stream.close();
				}
			}
			try
			{
				file.browseForSave(title);
				file.addEventListener(Event.SELECT, saveData);
			}
			catch (error:Error)
			{
				return false
			}
			return true
		}
	}

}