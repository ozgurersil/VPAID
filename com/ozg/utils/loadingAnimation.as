package com.ozg.utils
{
   import flash.display.Sprite;
   import flash.utils.Timer;
   import flash.events.TimerEvent;
   import com.ozg.events.helperEvents;
   
   public class loadingAnimation extends Sprite
   {
      
      public function loadingAnimation(param1:Number = 16777215)
      {
         super();
         this.animationColor = param1;
         this.animation = new Sprite();
         addChild(this.animation);
         this.makeAnimation();
      }
      
      private var animation:Sprite;
      
      private var rotate:Number = 0;
      
      private var animationTimer:Timer;
      
      private var animationColor:Number;
      
      private var animationStopped:Boolean = false;
      
      public function stopAnimation() : void
      {
         if(this.animationStopped == false)
         {
            removeChild(this.animation);
            this.animationTimer.removeEventListener(TimerEvent.TIMER,this.rotateMe);
            this.animationTimer.stop();
            this.animationStopped = true;
         }
      }
      
      private function makeAnimation() : void
      {
         this.renderAnimation();
         addEventListener(helperEvents.RemoveLoader,this.removeLoaderHandler);
         this.animationTimer = new Timer(70);
         this.animationTimer.addEventListener(TimerEvent.TIMER,this.rotateMe);
         this.animationTimer.start();
      }
      
      private function removeLoaderHandler(param1:helperEvents) : void
      {
         this.stopAnimation();
      }
      
      private function rotateMe(param1:TimerEvent) : void
      {
         this.rotate = this.rotate + 30;
         if(this.rotate == 360)
         {
            this.rotate = 0;
         }
         this.renderAnimation(this.rotate);
      }
      
      private function renderAnimation(param1:Number = 0) : void
      {
         var _loc4_:Sprite = null;
         this.clearAnimation();
         var _loc2_:Sprite = new Sprite();
         var _loc3_:uint = 0;
         while(_loc3_ <= 12)
         {
            _loc4_ = this.getShape();
            _loc4_.rotation = _loc3_ * 30 + param1;
            _loc4_.alpha = 0 + 1 / 12 * _loc3_;
            _loc2_.addChild(_loc4_);
            _loc3_++;
         }
         this.animation.addChild(_loc2_);
      }
      
      private function clearAnimation() : void
      {
         if(this.animation.numChildren == 0)
         {
            return;
         }
         this.animation.removeChildAt(0);
      }
      
      private function getShape() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(this.animationColor,1);
         _loc1_.graphics.moveTo(-1,-12);
         _loc1_.graphics.lineTo(2,-12);
         _loc1_.graphics.lineTo(1,-5);
         _loc1_.graphics.lineTo(0,-5);
         _loc1_.graphics.lineTo(-1,-12);
         _loc1_.graphics.endFill();
         return _loc1_;
      }
   }
}
