package com.ozg.adcore.vpaid
{
   import flash.display.Sprite;
   import com.ozg.events.helperEvents;
   import com.ozg.utils.loadingAnimation;
   
   public class adContainer extends Sprite
   {
      
      public function adContainer(param1:Number = 640, param2:Number = 360)
      {
         super();
         this.mouseEnabled = true;
         this.adWidth = param1;
         this.adHeight = param2;
         this.arrangeLayers();
         addEventListener(helperEvents.RemoveLoader,this.removeLoaderHandler);
      }
      
      private var background:Sprite;
      
      private var loadingAnim:Sprite;
      
      private var adWidth:Number;
      
      private var adHeight:Number;
      
      private function removeLoaderHandler(param1:helperEvents) : void
      {
         this.loadingAnim.dispatchEvent(new helperEvents(helperEvents.RemoveLoader));
      }
      
      private function arrangeLayers() : void
      {
         this.loadingAnim.width = this.loadingAnim.height = 45;
         this.loadingAnim.x = this.adWidth / 2 + 5;
         this.loadingAnim.y = this.adHeight / 2 + 5;
      }
   }
}
