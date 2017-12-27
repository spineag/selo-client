/**
 * Created by andy on 7/4/17.
 */
package utils {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;

import flash.geom.Point;

import starling.display.DisplayObject;
import starling.display.Sprite;

public class AnimationsStock {

    public static function joggleItBaby(sp:DisplayObject, count:int=3, deltaRotation:Number = .2, die:Number = .5, f:Function=null, firstLeft:Boolean = true, time:Number = .18):void {
        var defaultRotation:Number = sp.rotation;
        var finishF:Function = function():void {
            sp.rotation = defaultRotation;
            Cc.error('End joggleItBaby');
            if (f!=null) f.apply(); 
        };
        try {
            var onEnd:Function = function ():void {
                if (!sp) return;
                count--;
                if (count <= 0 || deltaRotation < .01)
                    TweenMax.to(sp, time, {rotation: defaultRotation, onComplete: finishF});
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
            Cc.error('Error with joggleItBaby');
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
        var tempP:Point = getTempPointForBezierV1(source.x, source.y, endX, endY);
        var dist:int = int(Math.sqrt((source.x - tempP.x)*(source.x - tempP.x) + (source.y - tempP.y)*(source.y - tempP.y)));
        dist += int(Math.sqrt((tempP.x - endX)*(tempP.x - endX) + (tempP.y - endY)*(tempP.y - endY)));
        var t:Number = dist/1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        var f:Function = function():void { if (callback != null) callback.apply(null, callbackParams) };
        new TweenMax(source, t, {bezier:{type:"soft", values:[{x:tempP.x, y:tempP.y}, {x:endX, y:endY}]}, scale:scale, delay:delay, ease:Linear.easeOut, onComplete: f});
    }

    private static function getTempPointForBezierV1(x1:int, y1:int, x2:int, y2:int):Point {
        var xc:int = (x1 + x2)/2;
        var yc:int = (y1 + y2)/2;
        var l:Number = Math.sqrt((x2-x1)*(x2-x1) + (y2-y1)*(y2-y1));
        var koef:Number = 0.2 + Math.random()*0.2;
        if (y1==y2) y2++;
        var b1:Number = (x1-x2)/(y2-y1);
        var b2:Number = yc - xc*(x2-x1)/(y1-y2);
        var znak:int;
        Math.random() > .5 ? znak = 1: znak = -1;
        var p:Point = new Point();
        p.x = (2*(xc + b1*yc - b1*b2) + znak*Math.sqrt(4*(xc + b1*yc - b1*b2)*(xc + b1*yc - b1*b2) - 4*(1 + b1*b1)*(xc*xc + b2*b2 - 2*b2*yc + yc*yc - koef*koef*l*l)))/(2*(1+b1*b1));
        p.y = p.x*b1 + b2;
        return p;
    }

}
}
