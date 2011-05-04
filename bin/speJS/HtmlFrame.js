/**
对应于
com.ixiyou.geom.HtmlFrame.as

*/
function FlashIFrame(objectID,id,width,height,urll){
	this.id=id
	this.width=width
	this.height=height
	this.objectID=objectID
	this.urll=urll
	this.flash=this.flashMovie(objectID)
	this.iframe=document.createElement('iframe')
	this.iframe.id='FlashIFrame_'+id
	this.iframe.style.position='absolute'
	this.iframe.frameBorder="border"
	this.iframe.width='100%'
	this.iframe.height='100%'
	if(this.urll)this.iframe.src=this.urll
	this.div=document.createElement('div')
	this.div.id='FlashIFrame_Div_'+id
	this.div.style.width=width
	this.div.style.height=height
	this.div.style.position='absolute'
	this.div.style.background='#98AB6F'
	this.div.appendChild(this.iframe);
	document.getElementsByTagName('body')[0].appendChild(this.div);
	this.setMove(100,100)
	//document.getElementById('FlashIFrame_Div_'+id).appendChild(iframe);
	//document.getElementsByTagName('body')[0].appendChild(flashIframe);
	//document.write('<table><tr><td width="100" height="100" bgcolor="0x0"></td></tr></table>');	
	//document.getElementById("newBox").innerHTML ='<table><tr><td width="100" height="100" bgcolor="0x0"></td></tr></table>'
}
FlashIFrame.prototype.setMove=function (x,y,bool) { 
	if(!bool){	
		this.div.style.left=x; 
		this.div.style.top=y; 
	}else{
		this.div.style.left=x; 
		this.div.style.top=y; 
	}
} 
FlashIFrame.prototype.setSize=function (w,h) {  
	this.div.style.width=w;
	this.div.style.width=h;
}
FlashIFrame.prototype.getShow=function () {  
	if(this.div.style.display='block'){
		return true
	}
	else{
		return false
	}
}
FlashIFrame.prototype.setShow=function (value) {  
	if(value){
		this.div.style.display='block'
	}else{
		this.div.style.display='none'
	}
	
}
FlashIFrame.prototype.flashMovie=function (movieName) {
	if (navigator.appName.indexOf("Microsoft") != -1) {
		return window[movieName]
	}else{
		return document[movieName]
	}
}
var htmlFrameJS = function() {
	var arr=new Array()
	var loaded=false
	var swfWaitArr=new Array()
	/**
	获取指定的ID的SWF
	*/
	function flashMovie(movieName) {
		if (navigator.appName.indexOf("Microsoft") != -1) {
			return window[movieName]
		}else{
			return document[movieName]
		}
	}
	return {
		/*
			创建对象
		*/
		found:function(objectID,id,width,height,urll){
			//document.getElementsByTagName('body')[0]
			if (!objectID||!id || !width || !height) {
				return;
			}
			var flash=flashMovie(objectID)
			var bool=false
			for(var i=0;i<arr.length;i++){
				if(arr[i].id=id){
					bool=true
					break
				}
			}
			if(!bool){
				arr.push(new FlashIFrame(objectID,id,width,height,urll))
				if(flash)flash.js_foundEnd('true:成功创建')
			}
			else{
				if(this.flash)this.flash.js_foundEnd('false:已经存在一个同名FlashIFrame')
				if(flash)flash.js_Error('found:已经存在一个同名FlashIFrame')
			}
		},
		getShow:function(id){
		
			var bool=false
			for(var i=0;i<arr.length;i++){
				if(arr[i].id=id){
					bool=true
					break
				}
			}
			alert(id+','+bool)
			if(!bool){
				//alert(id+','+arr[id])
				//if(flash)flash.js_Error('getShow:没有指定的FlashIFrame存在')
				return 'getShow:没有指定的FlashIFrame存在'
			}else{
				//if(flash)flash.js_getShow()
				return arr[id].getShow()
			}
			return 'getShow无执行'
		}
		
	}
}();