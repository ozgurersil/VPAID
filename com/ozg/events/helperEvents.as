package com.ozg.events
{
   import flash.events.Event;
   
   public class helperEvents extends Event
   {
      
      public function helperEvents(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._data = param2;
      }
      
      public static const VideoCompleted:String = "VideoCompleted";
      
      public static const UserClosedAd:String = "UserClosedAd";
      
      public static const UserClickThru:String = "UserClickThru";
      
      public static const StartVideo:String = "StartVideo";
      
      public static const PlayCreative:String = "PlayCreative";
      
      public static const PauseCreative:String = "PauseCreative";
      
      public static const RemoveLoader:String = "RemoveLoader";
      
      public static const ActivateCloseButton:String = "ActivateCloseButton";
      
      public static const ThrowVpaidEvent:String = "ThrowVpaidEvent";
      
      private var _data:Object;
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}
