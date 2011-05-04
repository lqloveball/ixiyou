package com.ixiyou.media 
{
	import flash.events.EventDispatcher;
	import flash.events.*;
	import flash.media.ID3Info;
    import flash.media.Sound;
	import flash.media.SoundTransform;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
	import flash.media.SoundLoaderContext;
	[Event(name = "play", type = "flash.events.Event")]
	[Event(name = "stop", type = "flash.events.Event")]
	[Event(name = "complete", type = "flash.events.Event")]
	[Event(name = "progress", type = "flash.events.ProgressEvent")]
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	/**
	 * 对加载的声音控制 加载 播放 
	 * @author spe
	 */
	public class Sounder extends EventDispatcher implements IMedia
	{
		//---------------添加播放时候再加载功能-----------------
		//是否加载完成
		private var _soundLoadBool:Boolean = false
		//加载完成播放
		private var _soundLoadPlayBool:Boolean = true
		//加载状态
		private var _soundLoadState:String = 'noLoad'
		//预备加载的声音
		private var _soundLoadPlayUrl:String=''
		//---------------添加播放时候再加载功能---------------------
		//声音路径
		private var _url:String = '';
		//声音控制器
		private var _song:SoundChannel;
		//声音对象
		private var _sound:Sound
		//是否加载时候就进行播放
		public var autoPlay:Boolean = true
		//播放完是否重播
		public var _loop:Boolean=false
		//加载缓冲设置
		public var soundLoader:SoundLoaderContext = new SoundLoaderContext()
		//当前播放时间位置
		private var _time:Number = 0;
		//播放中
		private var _playBool:Boolean=false
		//事件
		public static var STOP:String = 'stop'
		public static var STARTLINK:String = 'start_link'
		public static var PLAY:String = 'play'
		public static var PAUSE:String='pause'
		/**
		 * 构造函数
		 * @param	value
		 */
		public function Sounder(value:Sound = null, _autoPlay:Boolean = true) { 
			autoPlay=_autoPlay
			if (value != null)sound = value;
			else  sound= new Sound();
		}
		public function get playBool():Boolean { return _playBool; }
		/**
		 * 加载
		 * @param	value 加载路径 就添加默认下载路径
		 * @param	bufferTime 缓冲区时间
		 * @param	checkPolicyFile 是否加载策略文件
		 */
		public function load(value:String, bufferTime:Number = 1000, checkPolicyFile:Boolean = false):void {
			if (!sound) return
			if(value!=_url)_url=value
			var request:URLRequest = new URLRequest(value);
			soundLoader.checkPolicyFile = checkPolicyFile
			this.bufferTime = bufferTime
			stop()
			close();
			sound = new Sound()
			//sound.addEventListener(Event.COMPLETE, soundLoadEnd)
			//sound.addEventListener(ProgressEvent.PROGRESS, soundLoading)
			//sound.addEventListener(IOErrorEvent.IO_ERROR,soundLoadError)
			sound.load(request, soundLoader);
			//sound.play()
			if (autoPlay) play()
			else {
				if(soundLoadPlayBool)play()
			}
		}
		/**
		 * 加载错误
		 * @param	e
		 */
		private function soundLoadError(e:IOErrorEvent):void 
		{
			dispatchEvent(e.clone())
		}
		/**
		 * 加载进度
		 * @param	e
		 */
		private function soundLoading(e:ProgressEvent):void 
		{
			dispatchEvent(e.clone())
		}
		
		/**
		 * 加载完成
		 * @param	e
		 */
		private function soundLoadEnd(e:Event):void 
		{
			dispatchEvent(new Event(Event.COMPLETE))
		}
		/**
		 * 缓冲时间
		 */
		public function set bufferTime(value:Number):void {soundLoader.bufferTime = value}
		public function get bufferTime():Number{return soundLoader.bufferTime}
		/**
		 * 播放
		 */
		public function play(value:Number = 0):void {
			if (soundLoadState == 'noLoad' && soundLoadPlayUrl != '' && soundLoadBool == false) {
				_soundLoadState='waitLoad'
				load(soundLoadPlayUrl)
			}else {
				sounderPlay(value)
			}
		}
		/**
		 * 声音专用播放
		 * @param	startTime 开始播放时间
		 * @param	loops  定义在声道停止回放之前，声音循环回 startTime 值的次数。 
		 * @param	soundTransform 声音初始化声音设置
		 */
		public function sounderPlay(startTime:Number=0,loops:uint=0,soundTransform:SoundTransform=null):void {
			if (!sound) return
			if (_song)_song.removeEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			if (soundTransform == null) {
				if(_song!=null&&_song.soundTransform)soundTransform=_song.soundTransform
			}
			try {
				if(_song)_song.stop()
				_song = sound.play(startTime, loops, soundTransform)
				dispatchEvent(new Event(Sounder.PLAY))
				_playBool = true
				_song.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
			}catch (e:Error) {}
		}
		/**
		 * 停止在该声道中播放声音。
		 */
		public function stop():void {
			if (song) {
				_time = 0
				song.stop()
				_playBool = false
				_song=null
				dispatchEvent(new Event(Sounder.STOP))
			}
			
		}
		/**
		 * 暂停
		 */
		public function pause():void {
			if (song) {
				_time = song.position
				song.stop()				
				//trace(time)
				_playBool = false
				dispatchEvent(new Event(PAUSE))
			}
		}
		/**
		 * 播放/暂停
		 */
		public function togglePause():void {
			//trace(_playBool,_time)
			if (!_playBool) {
				play(_time);
			}else {
				pause();
			}
		}
		/**
		 * 关闭该流，从而停止所有数据的下载。 
		 */
		public function close():void {
			if (!sound) return
			try {
				sound.close()
				_time=0
			}catch (e:Error) {
				
			}
		}
		
		/*
		 * 是否循环播放
		 */
		public function get loop():Boolean {return _loop}
		public function set loop(value:Boolean):void {
			if(_loop==value)return
			_loop=value
		}
		/**
		 * 从 0（无）至 1（全部）的值，指定了左输入在左扬声器里播放的量。
		 */
		public function set leftToLeft(value: Number):void 
		{
			if (!soundTransform) return
			soundTransform.leftToLeft = value
			soundTransform=soundTransform
		}
		public function get leftToLeft(): Number {
			if (!soundTransform)return 0
			else return soundTransform.leftToLeft;
		}
		/**
		 * 从 0（无）至 1（全部）的值，指定了右输入在右扬声器里播放的量。
		 */
		public function set rightToRight(value: Number):void 
		{
			if (!soundTransform) return
			soundTransform.rightToRight = value
			soundTransform=soundTransform
		}
		public function get rightToRight(): Number {
			if (!soundTransform)return 0
			else return soundTransform.rightToRight;
		}
		/**
		 * 从 0（无）至 1（全部）的值，指定了左输入在右扬声器里播放的量。
		 */
		public function set leftToRight(value: Number):void 
		{
			if (!soundTransform) return
			soundTransform.leftToRight = value
			soundTransform=soundTransform
		}
		public function get leftToRight(): Number {
			if (!soundTransform)return 0
			else return soundTransform.leftToRight;
		}
		/**
		 * 从 0（无）至 1（全部）的值，指定了右输入在左扬声器里播放的量。
		 */
		public function set rightToLeft(value: Number):void 
		{
			if (!soundTransform) return
			soundTransform.rightToLeft = value
			soundTransform=soundTransform
		}
		public function get rightToLeft(): Number {
			if (!soundTransform)return 0
			else return soundTransform.rightToLeft;
		}
		/**
		 * 声音从左到右的平移，范围从 -1（左侧最大平移）至 1（右侧最大平移）。
		 */
		public function set pan(value: Number):void 
		{
			if (!soundTransform) return
			soundTransform.pan = value
			soundTransform=soundTransform
		}
		public function get pan(): Number {
			if (!soundTransform)return 0
			else return soundTransform.pan;
		}
		/**
		 * 音量范围从 0（静音）至 1（最大音量）。
		 */
		public function set volume(value: Number):void 
		{
			if (!soundTransform) return
			soundTransform.volume = value
			soundTransform=soundTransform
		}
		public function get volume(): Number {
			if (!soundTransform)return 0
			else return soundTransform.volume;
		}
	
		/**
		 * [只读 (read-only)] 左声道的当前幅度（音量），范围从 0（静音）至 1（最大幅度）。
		 */
		public function get leftPeak():Number {
			if (song) return song.leftPeak;
			else return 0
		}
		/**
		 *[只读 (read-only)] 右声道的当前幅度（音量），范围从 0（静音）至 1（最大幅度）。
		 */
		public function get rightPeak():Number {
			if (song) return song.rightPeak;
			else return 0
		}
		/**
		 * 分配给该声道的 SoundTransform 对象。 
		 */
		public function set soundTransform(value:SoundTransform):void { 
			if (_song) {
				_song.soundTransform=value
			}
		}
		public function get soundTransform():SoundTransform {
			if (_song) return _song.soundTransform; 
			else return null
		}
		/**
		 * [只读 (read-only)] 返回外部 MP3 文件的缓冲状态。 
		 */
		public function get isBuffering():Boolean { return sound.isBuffering; }
		/**
		 * 加载进度
		 */
		public function get loadProgress():Number {
			if (sound)	return sound.bytesLoaded / sound.bytesTotal;
			else return 0
		}
		/**
		 * 音频时间总长
		 */
		public function get duration():Number {
			return length/loadProgress
		}
		/**
		 * [只读 (read-only)] 当前声音的长度（以毫秒为单位）。
		 */
		public function get length():Number { return sound.length; }
		/**
		 * 当前播放时间
		 */
		public function get time():Number {
			if (song) return _time=song.position;
			else return 0
		}
		/**
		 * [只读 (read-only)] 返回此声音对象中当前可用的字节数。 
		 */
		public function get bytesLoaded():int { return sound.bytesLoaded; }
		/**
		 * [只读 (read-only)] 返回此声音对象中总的字节数。
		 */
		public function get bytesTotal():int { return sound.bytesTotal; }
		/**
		 * [只读 (read-only)] 提供对作为 MP3 文件一部分的元数据的访问。
		 */
		public function get id3():ID3Info { return sound.id3; }
		/**
		 * 声音源处理对象
		 */
		public function set sound(value:Sound):void 
		{
			if (_sound == value) return
			if (_sound) {
				stop()
				close()
				_sound.removeEventListener(Event.OPEN, soundOpen)
				_sound.removeEventListener(Event.COMPLETE, completeHandler);
				_sound.removeEventListener(Event.ID3, id3Handler);
				_sound.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_sound.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			}
			_sound = value
			_sound.addEventListener(Event.OPEN, soundOpen)
			if(_sound.bytesTotal>0)_sound.dispatchEvent(new Event(Event.OPEN))
			_sound.addEventListener(Event.COMPLETE, completeHandler);
            _sound.addEventListener(Event.ID3, id3Handler);
            _sound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            _sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			if(autoPlay)play()
		} 
	
		public function get sound():Sound  { return _sound; }
		/**
		 * 播放的声音控制对象
		 */
		public function get song():SoundChannel { return _song; }
		
		/**
		 * 声音的链接地址
		 */
		public function set url(value:String):void {
			if (url&&url == value) return
			load(value)
		}
		public function get url():String { return sound.url; }
		/**
		 * 声音文件是否加载完成
		 */
		public function get soundLoadBool():Boolean { return _soundLoadBool; }
		/**
		 * 设置声音播放前，还未加载 却执行了play，那play会开始执行的下载歌曲地址
		 */
		public function get soundLoadPlayUrl():String { return _soundLoadPlayUrl; }
		
		public function set soundLoadPlayUrl(value:String):void 
		{
			_soundLoadPlayUrl = value;
		}
		/**
		 * 加载状态
		 *  noLoad 默认状态还未开始加载 
		 *  waitLoad准备加载
		 * openLoad开始加载 
		 * loading加载中 loadEnd加载完成 loadError加载错误
		 */
		public function get soundLoadState():String { return _soundLoadState; }
		/**
		 * 预设加载完成就可以播放
		 */
		public function get soundLoadPlayBool():Boolean { return _soundLoadPlayBool; }
		
		public function set soundLoadPlayBool(value:Boolean):void 
		{
			_soundLoadPlayBool= value;
		}
		/*
		public function set soundLoadState(value:String):void 
		{
			_soundLoadState = value;
		}
		*/
		/**
		 * 声音播放结束
		 * @param	e
		 */
		private function soundCompleteHandler(e:Event):void {
			if (loop) {
				play();
			}else {
				dispatchEvent(new Event(STOP));
			}
			dispatchEvent(e)
		}
		/**
		 * 开始加载
		 * @param	e
		 */
		private function soundOpen(e:Event):void {
			_soundLoadState='openLoad'
			_soundLoadBool=false
			//trace(e)
			dispatchEvent(e)
		}
		/**
		 * 加载完成
		 * @param	e
		 */
		private function completeHandler(e:Event):void {
			_soundLoadState='loadEnd'
			_soundLoadBool=true
			dispatchEvent(e)
		}
		/**
		 * MP3格式
		 * @param	e
		 */
		private function id3Handler(e:Event):void {
			//trace(e)
			dispatchEvent(e)
		}
		/**
		 * 加载错误
		 * @param	e
		 */
		private function ioErrorHandler(e:IOErrorEvent):void {
			//trace(e)
			_soundLoadState='loadError'
			_soundLoadBool=false
			dispatchEvent(e)
		}
		/**
		 * 加载进度
		 * @param	e
		 */
		private function progressHandler(e:ProgressEvent):void {
				_soundLoadState='loading'
			_soundLoadBool=false
			//trace(e.bytesLoaded/e.bytesTotal,time/length)
			dispatchEvent(e)
		}
	}

}