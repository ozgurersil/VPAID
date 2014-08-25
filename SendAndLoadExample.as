package
{

	import flash.events.*;
	import flash.net.*;
	import flash.display.Loader;
	import flash.external.ExternalInterface;

	public class SendAndLoadExample
	{
		private var _url:String;
		private var lastSendedUrl:String = "";
		
		public function SendAndLoadExample()
		{
			
		}
		
		public function sendData(url:String,msg:String):void
		{
			_url = url;
			if(lastSendedUrl != _url){
				var src = encodeURI(_url);
				var request:URLRequest = new URLRequest(src);
				var loader:Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.load(request);
				lastSendedUrl = _url;
			}
		}
		private function handleComplete(event:Event):void
		{
			var loadedContent = event.target;
		}
		private function onIOError(event:IOErrorEvent):void
		{
		//	ExternalInterface.call('console.log','url error');
		}
	}
}
