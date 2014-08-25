package com.ozg.adcore.vpaid
{
   public interface IVPAID
   {
      
      function get adLinear() : Boolean;
      
      function get adExpanded() : Boolean;
      
      function get adRemainingTime() : Number;
      
      function get adVolume() : Number;
      
      function set adVolume(param1:Number) : void;
      
      function handshakeVersion(param1:String) : String;
      
      function initAd(param1:Number, param2:Number, param3:String, param4:Number, param5:String, param6:String) : void;
      
      function resizeAd(param1:Number, param2:Number, param3:String) : void;
      
      function startAd() : void;
      
      function stopAd() : void;
      
      function pauseAd() : void;
      
      function resumeAd() : void;
      
      function expandAd() : void;
      
      function collapseAd() : void;
   }
}
