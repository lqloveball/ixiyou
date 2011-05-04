package com.ixiyou.speUI.collections 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	/**
	 * 我的影片剪辑模拟实现方式，组要考虑到组件中使用到皮肤时候用这样方式很适合很方便
	 * 添加进显示列表方法，每次只允许一个显示对象
	 * @author spe
	 */
	public class SMovieClipBase extends Sprite
	{
		//帧标签
		protected var _frames:Array = new Array()
		//字典
		protected var _MovieDic:Dictionary=new Dictionary()
		//当前帧
		protected var _currentFrame:int = -1;
		//总帧数
		protected var _automaticLabel:uint = 0
		//添加给帧的显示对象是否初始化
		public var addFrameInitBool:Boolean=true
		public function SMovieClipBase(){}
		/**
		 *  总帧数
		 */
		public function get totalFrames():uint { return _frames.length; }
		/**
		 * 当前帧，如果是-1那就说当前没显示对象帧
		 */
		public function get currentFrame():int { return _currentFrame; }
		/**
		 * 帧列表
		 */
		public function get frames():Array { return _frames; }
		/**
		 * 当前标签
		 */
		public function get nowLabel():String {
			var obj:Object = getIndexObj(currentFrame)
			if(obj)return obj.label
			return null;
		}
		/**
		 * 替换指定标签帧 有指定标签存在，使用替换,没有指定标签存在就创建一个
		 * @param	label 
		 */
		public function replaceLabel(label:String,value:*):void {
			var obj:Object
			var temp:DisplayObject
			if (hasLabel(label)) {
				obj = getLabelObj(label)
				temp=obj.value
				obj.value = value
				if (contains(temp)) {
					removeChild(temp)
					temp = obj.value
					addChild(temp)
				}
			}else {
				
				addFrame(value,label)
			}
		}
		/**
		 * 添加帧
		 * @param	value
		 */
		public function addFrame(value:*,label:String=null,index:int=-1):Object {
			if (index < 0||index>totalFrames) index = totalFrames
			//不是显示对象退出
			if (!(value is DisplayObject)) return null
			//已经有标签存在
			if(!label&&hasLabel(label))return getLabelObj(label)
			//显示对象归位0.0
			if (addFrameInitBool)DisplayObject(value).y=DisplayObject(value).x=0
			//提供自动命名
			if (label == null) {
				label = String(this.name + _automaticLabel)
				_automaticLabel+=1
			}
			var obj:Object={label:label,value:value}
			_frames.splice(index, 0, obj)
			if (currentFrame == -1) {
				gotoAndStop(0)
			}
			return obj
		}
		/**
		 * 删除指定帧
		 * @param	index
		 * @return
		 */
		public function removeIndex(index:int = -1):Object {
			if(totalFrames==0)return null
			if (index < 0||index>=totalFrames) index = totalFrames-1
			var obj:Object = frames[index]
			var temp:DisplayObject = obj.value
			if(this.contains(temp))removeChild(temp)
			return obj
		}
		/**
		 * 删除指定帧
		 * @param	index
		 * @return
		 */
		public function removeLabel(label:String):Object {
			var obj:Object = getLabelObj(label)
			if(!obj)return null
			var temp:DisplayObject = obj.value as DisplayObject
			if(this.contains(temp))removeChild(temp)
			return obj
		}
		/**
		 *  批量添加帧
		 * @param	arr {label:label,value:value}
		 */
		public function addAllFrame(arr:Array):void {
			clearFrame()
			if (!arr) return
			var obj:Object
			for (var i:int = 0; i <arr.length ; i++) 
			{
				obj = arr[i] as Object;
				if (obj.value && obj.value is DisplayObject) {
					if (obj.label) addFrame(obj.value, obj.label)
					else addFrame(obj.value)
				}
			}
		}
		/**
		 * 清楚所有帧
		 */
		public function clearFrame():void {
			if (numChildren > 0) {
				var num:uint=this.numChildren 
				for ( var i:int = 0; i < num; i++) {
					if(getChildAt(0))this.removeChild(getChildAt(0))
				}
			}
			_frames=new Array()
			_currentFrame=-1
		}
		/**
         * 是否存在某个标签
         * 
         * @param labelName
         * @return 
         * 
         */
        public function hasLabel(label:String):Boolean {
			return getLabelIndex(label) != -1;
		}
		/**
         * 获得标签的序号
         *  
         * @param labelName
         * @return 
         * 
         */
        public function getLabelIndex(label:String):int
        {
        	for (var i:int = 0;i<frames.length;i++)
        	{
        		if (frames[i].label == label)return i;
        	}
        	return -1;
        }
		
		/**
		 * 指定帧的标签
		 * @param	index
		 * @return
		 */
		public function getIndexLabel(index:uint):String {
			if(frames[index])return frames[index].label
			return null
		}
		/**
		 * 指定标签的对象
		 * @param	value
		 */
		public function getIndexObj(index:uint):Object {
			if(frames[index])return frames[index]
			return null
		}
		/**
		 * 根据标签获取对象
		 * @param	label
		 * @return
		 */
		public function getLabelObj(label:String):Object {
			var num:int = getLabelIndex(label)
			
			if (num == -1) return null
			return frames[num]
		}
		/**
		 * 跳转停止
		 * @param	value可以试帧数也可以帧标签，注意这里的帧开始位置为0开始不是FLASH的1
		 */
		public function gotoAndStop(value:*):void {
			var temp:DisplayObject
			var index:int = -1
			var obj:Object
			if (value is uint) {
				obj = getIndexObj(value)
				if (obj && obj.value) {
					temp = obj.value as DisplayObject
					//trace(temp)
					add(temp)
					//trace(this.numChildren)
					index=value
				}
				_currentFrame=index
			}else if (value is String) {
				
				obj = getLabelObj(value)
				if (obj && obj.value) {
					temp = obj.value as DisplayObject
					add(temp)
					index=getLabelIndex(value)
				}
				_currentFrame=index
			}
		}
		/**
		 * 要求当前只能添加一个显示对象的方法
		 * @param	child
		 * @return
		 */
		public function add(child:DisplayObject):DisplayObject {return adAt(child, numChildren);}
		/**
		 * 要求当前只能添加一个显示对象的方法层方法
		 * @param	child
		 * @param	index
		 * @return
		 */
		public function adAt(child:DisplayObject, index:int):DisplayObject {
			if (numChildren > 0) {
				var num:uint=this.numChildren 
				for ( var i:int = 0; i < num; i++) {
					if(getChildAt(0))this.removeChild(getChildAt(0))
				}
			}
			return addChildAt(child,0)
		}
		/**
		 * 设置所有帧上显示对象都统一固定的宽高
		 * @param	w
		 * @param	h
		 */
		public function setAllMovieSize(w:uint, h:uint):void {
			var temp:DisplayObject
			var obj:Object
			for (var i:int = 0; i < frames.length; i++) 
			{
				obj = frames[i];
				if (obj && obj.value) {
					temp = obj.value as DisplayObject
					temp.width = w
					temp.height=h
				}
			}
		}
	}

}