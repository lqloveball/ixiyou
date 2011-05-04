package com.ixiyou.media
{
    
    
    /**
     * 视频数据 适合直播方案的
     * 案例 点播 
     *  var videoModel:VideoModel = new VideoModel()
     videoModel.video = video
     videoModel.linkPlay = true
     videoModel.connection=null
     videoModel.videoURL='Video.flv'
     videoModel.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler)
     videoModel.play()
     
     直播方案
     video = new VideoModel( { nc:fms.nc } )
     video.video = myVideo as Video
     video.videoURL = rtmp://127.0.0.1/live/cctv1
     video.connectStreamPlay()
     当连接上服务器后
     * @author 
     */
    import flash.events.*;
    import flash.media.SoundTransform;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.utils.clearInterval;
    import flash.utils.setInterval;
    import flash.utils.setTimeout;
    
    [Event(name = "playState_stop", type = "flash.events.Event")]
    [Event(name = "playState_play", type = "flash.events.Event")]
    [Event(name="playState_pause", type="flash.events.Event")]
    public class VideoModel2 extends EventDispatcher
    {
        //视频地址
        private var _videoURL:String = "Video.flv";
        //nc对象
        private var _connection:NetConnection;
        //sm对象
        private var _stream:NetStream;
        //视频输出对象
        private var _video:Video
        //是否连接上就播放
        private var _linkPlay:Boolean = false
        //视频模式 直播 点播
        public var videoModel:Boolean = true
        //视频信息对象
        private var _custom:CustomClient
        //播放状态
        private var _playState:String = 'playState_stop'
        //缓冲区
        private var _bufferTime:Number
        //总时间
        private var _duration:Number
        private var seekNum:int;
        private var seekInterval:int;
        private var intervalMonitorBufferLengthEverySecond:uint;
        public function VideoModel2(config:Object=null) 
        {
            if (config) {
                if (config.nc) connection = config.nc
                if (config.video) video = config.video
                if(config.linkPlay)linkPlay = config.linkPlay
            }
        }
        /**
         * 是否连接上就播放
         */
        public function set linkPlay(value:Boolean):void 
        {
            if (_linkPlay == value) return
                _linkPlay=value
        }
        public function get linkPlay():Boolean { return _linkPlay; }
        
        /**
         * 设置nc连接
         * @param	event
         */
        public function ncConnect(value:String):void {
            if(connection)connection.connect(value);  
        }
        /**
         * 设置nc对象
         */
        public function set connection(value:NetConnection):void 
        {
            if (value == null) {
                value = new NetConnection()
                value.connect(null)
            }
            if (_connection == value) return
            if (_connection) {
                _connection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                _connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            }
            _connection = value
            _connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            _connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            trace('设置nc')
            setStream(_connection)
        }
        public function get connection():NetConnection { return _connection; }
        /**
         * Video对象
         */
        public function set video(value:Video):void 
        {
            if (_video == value) return
                _video = value
            if(stream)video.attachNetStream(stream);
        }
        public function get video():Video { return _video; }
        /**
         * 设置流对象
         * @param	value
         */
        private function setStream(value:NetConnection):void 
        {
            if(!value.connected)return
            if (_stream) {
                _stream.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
                _stream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            }
            trace('设置stream')
            _stream = new NetStream(connection);
            _custom=new CustomClient(this)
            stream.client = _custom
            stream.bufferTime=bufferTime
            stream.maxPauseBufferTime = 0;
            stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
            stream.addEventListener(IOErrorEvent.IO_ERROR,function():void{})
            stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
            if(video)video.attachNetStream(stream);
        }
        public function monPlayback():void{
            DebugOutput.add("Buffer length: " + stream.bufferLength);
            if (stream.bufferLength >= (bufferTime + 1.5)) {
                var tempNum:Number = Math.ceil((stream.bufferLength - bufferTime) / 0.5);
				DebugOutput.add('超过延时秒数:'+ bufferTime +',要快进,快进次数:' + tempNum);
                seekInterval = setInterval(seekIntervalFun, 500, tempNum);
            }
        }
        private function seekIntervalFun(num:Number):void
        {
            if (seekNum >= num) {
				DebugOutput.add('延时快进完毕');
                clearInterval(seekInterval);
                seekNum = 0;
            } else {
                if (stream.bufferLength >= bufferTime) {
                    try {
						DebugOutput.add('延时快进了');
                        stream.seek(0.5);
                    } catch (e:Error){
                        
                    }
                }
                seekNum++;
            }
        }
        /**
         * NetStream 流对象
         */
        public function get stream():NetStream { return _stream; }
        /**
         * 设置连接的视频
         */
        public function set videoURL(value:String):void 
        {
            if (_videoURL == value) return
                _videoURL = value
            if(linkPlay)connectStreamPlay();
        }
        public function get videoURL():String { return _videoURL; }
        /**
         * 视频信息对象
         */
        public function get custom():CustomClient { return _custom; }
        /**
         * 指定在开始显示流之前需要多长时间将消息存入缓冲区。 
         */
        public function get bufferTime():Number { return _bufferTime; }
        
        public function set bufferTime(value:Number):void 
        {
            _bufferTime = value;
            if(stream)
            {
                stream.bufferTime = _bufferTime;
                stream.maxPauseBufferTime = 0;
            }
        }
        /**
         * 数据当前存在于缓冲区中的秒数。 
         */
        public function get bufferLength():Number { 
            if(stream) return stream.bufferLength
            else return 0;
        }
        /**
         * 声音流
         */
        public function get soundTransform():SoundTransform {
            if (stream) return stream.soundTransform
            else return null
        }
        /**
         * 音量
         */
        public function get soundValue():Number {
            if (stream) return stream.soundTransform.volume
            else return 0
        }
        public function set soundValue(value:Number):void 
        {
            if (stream) {
                
                var soundTransform:SoundTransform = stream.soundTransform
                soundTransform.volume=value
                stream.soundTransform=soundTransform
                //trace(value,stream.soundTransform.volume)
            }
        }
        
        private var soundVolume:Number = 0
        private var _soundBool:Boolean=true
        /**
         * 声音是否开启
         * @param	Bool
         */
        public function set soundBool(bool:Boolean):void {
            if (stream) {
                _soundBool=bool
                var soundTransform:SoundTransform = stream.soundTransform
                if (bool) {
                    if (soundVolume != 0) soundTransform.volume = soundVolume
                    else soundTransform.volume=1
                    stream.soundTransform=soundTransform
                }else {
                    soundVolume = soundTransform.volume
                    soundTransform.volume = 0
                    stream.soundTransform=soundTransform
                }
            }
            
        }
        public function get soundBool():Boolean {return _soundBool }
        /**
         * 加载进度
         */
        public function get progress():Number { 
            if (stream) {
                return stream.bytesLoaded/stream.bytesTotal
            }
            else return 0
        }
        /**
         * 每秒显示的帧的数目。 
         */
        public function get currentFPS():Number { 
            if (stream) return stream.currentFPS
            else return 0
        }
        
        /**
         * 播放状态 playState_stop playState_play playState_pause 
         */
        public function get playState():String { return _playState; }
        /**
         * 视频直播
         */
        public function connectStreamPlay():void {
            //trace('无NC无VIDEO不播放',connection,video,stream)
            //
            if (!connection||!video||!stream) return
            //trace('无连接不播放',connection.connected)
            //
            if (!connection.connected) return
                trace('播放:'+videoURL)
            video.attachNetStream(stream);
            stream.play(videoURL);
            killMonitorBuffer();
            intervalMonitorBufferLengthEverySecond = setInterval(monPlayback, 5000);
            _playState = 'playState_play';
            dispatchEvent(new Event(_playState))
        }
        private function killMonitorBuffer():void
        {
            if (intervalMonitorBufferLengthEverySecond > 0) {
                clearInterval(intervalMonitorBufferLengthEverySecond);
            }
        }
        /**
         * 视频播放
         */
        public function play():void {
            connectStreamPlay()
        }
        /**
         * 恢复回放暂停的视频流。
         */
        public function resume():void { if (stream) {
            stream.resume()
            _playState = 'playState_play';
            dispatchEvent(new Event(_playState))
        } }
        /**
         * 暂停视频流的回放。 
         */
        public function pause():void { if (stream) {
            stream.pause()
            _playState = 'playState_pause';
            dispatchEvent(new Event(_playState))
        }}
        /**
         * 关闭
         */
        public function close():void {
            killMonitorBuffer();
            if (stream) {
                stream.close()
                _playState = 'playState_stop';
                dispatchEvent(new Event(_playState))
            }
            if(connection){
                connection.close()
            }
        }
        /**
         * 暂停或恢复流的回放。 
         */
        public function togglePause():void {
            if (stream) {
                stream.togglePause()
                //trace('c:',_playState)
                if (_playState == 'playState_pause')_playState = 'playState_play';
                else if (_playState == 'playState_play')_playState = 'playState_pause';
                dispatchEvent(new Event(_playState))
            }
        }
        private var oldSeek:Number
        /**
         * 跳转
         * @param	value
         */
        public function seek(value:Number)  :void {
            if (stream) {
                oldSeek=time
                stream.seek(value)
            }
        }
        /**
         * 播放头的位置（以秒为单位）。
         */
        public function get time():Number {
            if (stream) return stream.time
            else return 0
        }
        /**
         * 时间百分比
         */
        public function get timeNum():Number{return time/duration}
        /**
         * 总时间
         */
        public function get duration():Number { return _duration; }
        
        public function set duration(value:Number):void 
        {
            _duration = value;
            dispatchEvent(new Event('upAllTime'))
        }
        /**
         * 总时间
         */
        public function get allTime():Number{return duration}
        /**
         * nc事件
         * @param	event
         */
        private function netStatusHandler(event:NetStatusEvent):void {
			DebugOutput.add('videoModel:' + event.info.code);
            switch ('视频连接情况',event.info.code) {
                case "NetConnection.Connect.Success":
                setStream(_connection)
                if (linkPlay) connectStreamPlay();
                break;
                case "NetStream.Play.StreamNotFound":
                duration=0
                //没有这个视频连接地址
                trace("没有这个视频连接地址: " + videoURL);
                break;
                case "NetStream.Seek.InvalidTime":
                //duration=0
                stream.seek(oldSeek)
                break;
                case 'NetStream.Buffer.Empty':
                    //pause();
                    break;
                case 'NetStream.Play.InsufficientBW':
                    break;
                case 'NetStream.Buffer.Full':
                    
                    break;
                case 'NetStream.Play.UnpublishNotify':
					DebugOutput.add('FME停止发布');
                    break;
                case 'NetStream.Play.PublishNotify':
					DebugOutput.add('FME开始发布');
                    stream.bufferTime = bufferTime;
                    stream.maxPauseBufferTime = 0;
                    pause();
                    setTimeout(resume, bufferTime);
                    break;
                case "NetStream.Play.Start":
                _playState = 'playState_play';
                dispatchEvent(new Event(_playState))
                break;
                case "NetStream.Play.Stop":
                killMonitorBuffer();
                _playState = 'playState_stop';
                //pause()
                if (playStateStopBool) {
                    //stream.seek(1)
                    //pause()
                }
                else playStateStopBool=true
                dispatchEvent(new Event(_playState))
                break;	
                default:
                //trace('videoModel:','default')
                break;
            }
            //return
            //dispatchEvent(event)
            //判断是视频流的事件，就发出
            if (String(event.info.code).split('.')[0] == 'NetStream') {
                //trace(event.info.code)
            }
        }
        
        private var playStateStopBool:Boolean=false
        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
        
        private function asyncErrorHandler(event:AsyncErrorEvent):void {
            //trace("asyncErrorHandler: " + event);
            // ignore AsyncErrorEvent events.
        }	
    }
}
import com.ixiyou.media.VideoModel2;
import flash.events.Event;

/**
 * 指定对其调用回调方法以处理流或 FLV 文件数据的对象。
 */ 
class CustomClient  {
    public var model:VideoModel2
    public var metaData:Object
    public var cuePoint:Object
    
    public function CustomClient(model:VideoModel2=null):void {
        this.model=model
    }
    public function onFI(info:Object):void{
        
    }
    public function onMetaData(info:Object):void {
        if (model) {
            metaData = info
            model.duration=info.duration
            model.dispatchEvent(new Event('MetaData'))
        }
        trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
        
    }
    public function onCuePoint(info:Object):void {
        if (model) {
            cuePoint = info
            model.dispatchEvent(new Event('CuePoint'))
        }
        trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
    }
    public function checkBandwidth():int
    {
        return 0;
    }
    public function onBWDone():int
    {
        return 0;
    }
}