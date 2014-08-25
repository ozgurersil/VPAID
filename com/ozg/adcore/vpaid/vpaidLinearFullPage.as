package com.ozg.adcore.vpaid
{
   import flash.display.Sprite;
   import flash.utils.Timer;
   import flash.external.ExternalInterface;
   import com.ozg.events.vpaidEvent;
   import flash.events.TimerEvent;
   import com.ozg.events.helperEvents;
   import flash.system.Security;
   import flash.net.navigateToURL;
   import flash.net.URLRequest;
   import flash.net.URLLoader;
   
   public class vpaidLinearFullPage extends Sprite implements IVPAID
   {
      
      public function vpaidLinearFullPage()
      {
         super();
         Security.allowDomain("*");
         mouseEnabled = false;
		 
      }
      
      private static const VPAID_VERSION:String = "1.1";
      
      protected var creativeLoadTimer:Timer;
      
      protected var creativeLoadTimeout:Number = 15;
      
      protected var creativePath:String;
      
      protected var clickUrl:String;
      
      protected var timeRemaining:Number;
      
      protected var adPlayerVolume:Number;
      
      protected var initWidth:Number;
      
      protected var initHeight:Number;
      
      private var viewMode:String;
      
      private var adContainerSprite:Sprite;
      
      protected var isLinearAd:Boolean = true;
	  
	  private var clickThru:String;
	  
	  private var impressionURL:String;
      
      public function getVPAID() : Object
      {
         return this;
      }
      
      public function get adLinear() : Boolean
      {
         return this.isLinearAd;
      }
      
      public function get adExpanded() : Boolean
      {
         return false;
      }
      
      public function get adRemainingTime() : Number
      {
         return this.timeRemaining;
      }
      
      public function get adVolume() : Number
      {
         return this.adPlayerVolume;
      }
      
      public function set adVolume(param1:Number) : void
      {
         this.adPlayerVolume = param1;
      }
      
      public function handshakeVersion(param1:String) : String
      {
         this.log("The player supports VPAID version " + param1 + " and the ad supports " + VPAID_VERSION);
         return VPAID_VERSION;
      }
      
      protected function log(param1:String) : void
      {
         
         var _loc2_:Object = {"message":param1};
         dispatchEvent(new vpaidEvent(vpaidEvent.AdLog,_loc2_));
      }
      
      public function initAd(param1:Number, param2:Number, param3:String, param4:Number, param5:String, param6:String) : void
      {
         this.handleData(param5);
         this.resizeAd(param1,param2,param3);
         this.loadAd();
      }
      
      protected function handleData(param1:String) : void
      {
         var xmlData:XML = null;
         var creativeData:String = param1;
         if(creativeData != null)
         {
            try
            {
               xmlData = new XML(creativeData);
               this.creativePath = xmlData.setting;
				this.creativeLoadTimeout = xmlData.duration;
				this.clickThru = xmlData.clickThru;
				this.impressionURL = xmlData.impressionURL;
				initWidth = xmlData.creativeWidth;
				initHeight = xmlData.creativeHeight;
				handleVpaidEvent('AdImpression');
				var s:SendAndLoadExample = new SendAndLoadExample();
				s.sendData(impressionURL,'no message');
				
            }
            catch(e:Error)
            {
               onError();
            }
         }
         else
         {
            this.onError();
         }
         if(creativeData != null)
         {
            return;
         }
      }
      
      protected function loadAd() : void
      {
         dispatchEvent(new vpaidEvent(vpaidEvent.AdLoaded));
      }
      
      public function startAd() : void
      {
         this.log("Beginning the display of the VPAID ad");
         dispatchEvent(new vpaidEvent(vpaidEvent.AdStarted));
         this.creativeLoadTimer = new Timer(1000,this.creativeLoadTimeout);
         this.creativeLoadTimer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.creativeLoadTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.timerComplete);
         this.creativeLoadTimer.start();
         this.addJsCallbacks();
         this.addEventListeners();
         this.adContainerSprite = new adContainer(this.initWidth,this.initHeight);
         addChild(this.adContainerSprite);
		
      }
      
      private function timerComplete(param1:TimerEvent) : void
      {
         this.stopAd();
      }
      
      private function addJsCallbacks() : void
      {
         ExternalInterface.addCallback("handleVpaidEvent",this.handleVpaidEvent);
         ExternalInterface.addCallback("getPlayerVolume",this.getAdPlayerVolume);
		 ExternalInterface.call("initVpaid",creativePath,this.initWidth,this.initHeight);
      }
      
      private function getAdPlayerVolume() : void
      {
         //js will come here
      }
	  
	  public function comingHTML() : void
      {
         ExternalInterface.call("console.log","i am talking with js");
      }
      
      private function addEventListeners() : void
      {
         addEventListener(vpaidEvent.AdUserClose,this.userClose);
      }
      
      private function userClose(param1:vpaidEvent) : void
      {
         this.stopAd();
      }
      
      protected function handleVpaidEvent(param1:String) : void
      {	
		// ExternalInterface.call('console.log','param : '+param1);
         switch(param1)
         {
            case "AdImpression":
               dispatchEvent(new vpaidEvent(vpaidEvent.AdImpression));
               break;
            case "AdVideoStart":
               dispatchEvent(new vpaidEvent(vpaidEvent.AdVideoStart));
               break;
            case "AdVideoFirstQuartile":
               dispatchEvent(new vpaidEvent(vpaidEvent.AdVideoFirstQuartile));
               break;
            case "AdVideoMidpoint":
               dispatchEvent(new vpaidEvent(vpaidEvent.AdVideoMidpoint));
               break;
            case "AdVideoThirdQuartile":
               dispatchEvent(new vpaidEvent(vpaidEvent.AdVideoThirdQuartile));
               break;
            case "AdVideoComplete":
               dispatchEvent(new vpaidEvent(vpaidEvent.AdVideoComplete));
               break;
            case "AdStopped":
               this.stopAd();
               break;
            case "AdUserClose":
               dispatchEvent(new vpaidEvent(vpaidEvent.AdUserClose));
               break;
            case "AdClickThru":
               this.onAdClick();
               break;
            case "AdError":
               this.onError();
               break;
            case "CreativeLoaded":
               this.onCreativeLoad();
               break;
         }
      }
      
      private function onCreativeLoad() : void
      {
         if(this.creativeLoadTimer)
         {
            this.creativeLoadTimer.stop();
            this.creativeLoadTimer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.creativeLoadTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.timerComplete);
            this.creativeLoadTimer = null;
         }
         this.adContainerSprite.dispatchEvent(new helperEvents(helperEvents.RemoveLoader));
      }
      
      private function onError() : void
      {
         dispatchEvent(new vpaidEvent(vpaidEvent.AdError));
         this.stopAd();
      }
      
      protected function onTimer(param1:TimerEvent) : void
      {
         this.timeRemaining--;
      }
      
     
	  public function onAdClick(event:Object = null) : void
	  {
		 var data:Object = { "playerHandles":true };
		 dispatchEvent(new vpaidEvent(vpaidEvent.AdClickThru, data));  
		 
		  ExternalInterface.call("function setWMWindow() {window.open('" + this.clickThru + "');}");
		 stopAd();
	
	   }

      
      public function stopAd() : void
      {
         if(this.creativeLoadTimer)
         {
            this.creativeLoadTimer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.creativeLoadTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.timerComplete);
            this.creativeLoadTimer = null;
         }
         this.log("Stopping the display of the VPAID Ad");
         ExternalInterface.call("closeVpaid");
         dispatchEvent(new vpaidEvent(vpaidEvent.AdStopped));
      }
      
      public function resizeAd(param1:Number, param2:Number, param3:String) : void
      {
         this.log("resizeAd() width=" + param1 + ", height=" + param2 + ", viewMode=" + param3);
        // this.initWidth = param1;
        // this.initHeight = param2;
         this.viewMode = param3;
      }
      
      public function pauseAd() : void
      {
      }
      
      public function resumeAd() : void
      {
      }
      
      public function expandAd() : void
      {
      }
      
      public function collapseAd() : void
      {
      }
      
      public function skipAd() : void
      {
      }
   }
}
