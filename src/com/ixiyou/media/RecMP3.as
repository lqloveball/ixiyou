package com.ixiyou.media 
{
	import flash.events.*;
	import flash.utils.*;
	import flash.net.*
	import flash.media.*;
	import flash.utils.*;
	import com.adobe.audio.format.WAVWriter; 
	import fr.kikko.lab.ShineMP3Encoder
	//编译错误
	[Event(name = 'RecMP3_Encode_Error', type = "flash.events.Event")]
	//开始录制
	[Event(name = 'RecMP3_StartRecord', type = "flash.events.Event")]
	//录制中
	[Event(name = 'RecMP3_Record', type = "flash.events.Event")]
	//停止录制
	[Event(name = 'RecMP3_StopRecord', type = "flash.events.Event")]
	//开始编译
	[Event(name = 'RecMP3_StartEncode', type = "flash.events.Event")]
	// 编译完成
	[Event(name = 'RecMP3_EncodeEnd', type = "flash.events.Event")]
	//编译过程
	[Event(name = 'RecMP3_Progress', type = "flash.events.ProgressEvent")]
	//编译错误
	[Event(name = 'RecMP3_Encode_Error', type = "flash.events.ErrorEvent")]
	
	
	/**
	 * 录音 MP3
	 * @author spe email:md9yue@qq.com
	 */
	public class RecMP3 extends EventDispatcher
	{
		private var _mic:Microphone;
		private var _voice:ByteArray;
		private var _mp3Encoder:ShineMP3Encoder;
		
		private var _state:String= 'pre-recording';
		private var _timer:int;
		private var _wavWriteTime:uint;
		private var _wavBytesAvailable:uint;
		private var _encodedTime:uint;
		public function RecMP3() 
		{
			
		}
		/**
		 * 开启麦克风
		 * @return
		 */
		public function setupMicrophone():Boolean
		{
			_mic = Microphone.getMicrophone();
			if (!_mic) {
				_state = 'no_Microphone!'
				return false;
			}
			_mic.rate = 44;
			_mic.gain=100
			_mic.setSilenceLevel(0, 4000);
			_mic.setLoopBack(false);
			_mic.setUseEchoSuppression(true);
			return true;
		}
		/**
		 * 初始话录制状态
		 */
		public function initRecord():void {
			
		}
		/**
		 * 开始录制声音
		 * @param	e
		 */
		public function startRecording():void 
		{
			if (state != 'pre-recording' && state != 'encoded') return;
			_state = 'recording';
			_voice = new ByteArray();
			_mic.addEventListener(SampleDataEvent.SAMPLE_DATA, onRecord);
			dispatchEvent(new Event('RecMP3_StartRecord'))
		}
		/**
		 * 获取麦克风数据 写入声音数据
		 * @param	e
		 */
		private function onRecord(e:SampleDataEvent):void 
		{
			_voice.writeBytes(e.data);
			dispatchEvent(new Event('RecMP3_Record'))
		}
		
		/**
		 * 停止录制
		 * @param	e
		 */
		public function stopRecording():void 
		{
			if (_state != 'recording') return;
			_state = 'pre-encoding';
			_mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, onRecord);
			_voice.position = 0;
			dispatchEvent(new Event('RecMP3_StopRecord'))
			
		}
		/**
		 * 转换成MP3
		 */
		public function convertToMP3():void 
		{
			if(state!='pre-encoding')return
			var wavWrite:WAVWriter = new WAVWriter();
			wavWrite.numOfChannels = 1;
			wavWrite.sampleBitRate = 16;
			wavWrite.samplingRate = 44100;
			
			var wav:ByteArray = new ByteArray();
			dispatchEvent(new Event('RecMP3_wavWriteStart'))
			_timer = getTimer();
			wavWrite.processSamples(wav, _voice, 44100, 1);
			wav.position = 0;
			//trace('convert to a WAV used: ' + (getTimer() - _timer) + 'ms');
			//trace('WAV size:' + wav.bytesAvailable + ' bytes');
			//trace('Asynchronous convert to MP3 now');
			_wavWriteTime = (getTimer() - _timer)
			_wavBytesAvailable=wav.bytesAvailable
			dispatchEvent(new Event('RecMP3_wavWriteEnd'))
			
			_state='encoding'
			_timer = getTimer();
			_mp3Encoder = new ShineMP3Encoder( wav );
			_mp3Encoder.addEventListener(Event.COMPLETE, onEncoded);
			_mp3Encoder.addEventListener(ProgressEvent.PROGRESS, onEncoding);
			_mp3Encoder.addEventListener(ErrorEvent.ERROR, onEncodeError);
			_mp3Encoder.start();
			dispatchEvent(new Event('RecMP3_StartEncode'))
		}
		/**
		 * 生成MP3文件完成
		 * @param	e
		 */
		private function onEncoded(e:Event):void 
		{
			_state = 'encoded';
			_encodedTime=(getTimer() - _timer)
			//trace('encode MP3 complete used: ' + (getTimer() - _timer) + 'ms');
			_mp3Encoder.mp3Data.position = 0;
			dispatchEvent(new Event('RecMP3_EncodeEnd'))
			//trace('MP3 size:' + _mp3Encoder.mp3Data.bytesAvailable + ' bytes');
		}
		/**
		 * 生成MP3进度
		 * @param	e
		 */
		private function onEncoding(e:ProgressEvent):void 
		{
			_state = 'encoding';
			//stateText.label = 'encoding MP3... ' + Number(e.bytesLoaded / e.bytesTotal * 100).toFixed(2) + '%';
			dispatchEvent(new ProgressEvent('RecMP3_Progress',false,false,e.bytesLoaded,e.bytesTotal))
		}
		/**
		 * 生成MP3文件错误
		 * @param	e
		 */
		private function onEncodeError(e:ErrorEvent):void 
		{
			_state = 'pre-recording';
			dispatchEvent(new Event('RecMP3_Encode_Error'))
		}
		
		/**
		 * 保存MP3
		 * @param	value 保存成MP3
		 */
		public function saveMP3(value:String=''):void 
		{
			if (state != 'encoded') return;
			var saveData:FileReference = new FileReference()
			saveData.save(_mp3Encoder.mp3Data,value+'.mp3')
			//_mp3Encoder.saveAs();
			_state = 'pre-recording';
		}
		/**
		 * 录制状态
		 * no_Microphone 没有麦克风
		 * pre-recording 准备录制
		 * recording 录制中
		 * pre-encoding 停止录音等待编译
		 * encoding 编译中
		 * encoded  编译完成
		 */
		public function get state():String { return _state; }
		/**
		 * 麦克风对象
		 */
		public function get mic():Microphone { return _mic; }
		/**
		 * 声音大小
		 */
		public function get activityLevel():Number{return mic.activityLevel}
		/**
		 * 写wav消耗时间
		 */
		public function get wavWriteTime():uint { return _wavWriteTime; }
		/**
		 * 写wav 大小 bytesAvailable
		 */
		public function get wavBytesAvailable():uint { return _wavBytesAvailable; }
		/**
		 * 编译时间
		 */
		public function get encodedTime():uint{return _encodedTime}
		/**
		 * mp3加密器
		 */
		public function get mp3Encoder():ShineMP3Encoder { return _mp3Encoder; }
		
		/**
		 * mp3 2进制文件
		 */
		public function get mp3Data():ByteArray { return _mp3Encoder.mp3Data; }
	}

}