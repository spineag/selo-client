/**
 * Created by andy on 7/4/17.
 */
package utils {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class AnimationsStock {

    public static function joggleItBaby(sp:DisplayObject, count:int=3, deltaRotation:Number = .2, die:Number = .5, f:Function=null, firstLeft:Boolean = true, time:Number = .18):void {
        var defaultRotation:Number = sp.rotation;
        var finishF:Function = function():void {
            sp.rotation = defaultRotation;
            if (f!=null) f.apply(); 
        };
        try {
            var onEnd:Function = function ():void {
                if (!sp) return;
                count--;
                if (count <= 0 || defaultRotation < .01) TweenMax.to(sp, time, {rotation: defaultRotation, onComplete: finishF});
                else {
                    deltaRotation *= die;
                    f1();
                }
            };
            var f2:Function = function ():void {
                if (!sp) return;
                if (firstLeft) TweenMax.to(sp, time, {rotation: defaultRotation + deltaRotation, onComplete: onEnd});
                else TweenMax.to(sp, time, {rotation: defaultRotation - deltaRotation, onComplete: onEnd});
            };
            var f1:Function = function ():void {
                if (!sp) return;
                if (firstLeft) TweenMax.to(sp, time, {rotation: defaultRotation - deltaRotation, onComplete: f2});
                else TweenMax.to(sp, time, {rotation: defaultRotation + deltaRotation, onComplete: f2});
            };
            f1();
        } catch(e:Error) {
            finishF();
        }
    }

    public static function jumpSimple(sp:DisplayObject, count:int=3, f:Function=null, height:Number = 10, time:Number = .2):void {
        var defaultY:int = sp.y;
        var onFinish:Function = function():void {
            sp.y = defaultY;
            if (f!=null) f.apply();
        };
        
        try {
            var onEnd:Function = function ():void {
                count--;
                if (count <= 0) onFinish();
                else {
                    height *= .6;
                    time *= .7;
                    jumpUp();
                }
            };
            var jumpDown:Function = function ():void {
                TweenMax.to(sp, time, {y: defaultY, onComplete: onEnd});
            };
            var jumpUp:Function = function ():void {
                if (!sp) return;
                TweenMax.to(sp, time, {y: defaultY - height, onComplete: jumpDown});
            };
            jumpUp();
        } catch(e:Error) {
            onFinish();
        }
    }

    public static function tweenBezier(source:Sprite, endX:int, endY:int, callback:Function, scale:Number = 1, delay:Number = 0, ...callbackParams):void {
        var tempX:int = int(source.x/2 + endX/2 - 70 + Math.random()*140);
        var tempY:int = int(source.y/2 + endY/2 - 70 + Math.random()*140);
        var dist:int = int(Math.sqrt((source.x - tempX)*(source.x - tempX) + (source.y - tempY)*(source.y - tempY)));
        dist += int(Math.sqrt((tempX - endX)*(tempX - endX) + (tempY - endY)*(tempY - endY)));
        var t:Number = dist/1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        var f:Function = function():void { if (callback != null) callback.apply(null, callbackParams) };
        new TweenMax(source, t, {bezier:[{x:tempX, y:tempY}, {x:endX, y:endY}], scale:scale, delay:delay, ease:Linear.easeOut, onComplete: f});
    }

}
}
