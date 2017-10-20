/**
 * Created by user on 10/5/17.
 */
package resourceItem.money {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.animation.Tween;

import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;

import utils.AnimationsStock;

import utils.CTextField;
import utils.MCScaler;

public class DropMoneyItem {
    public var source:Sprite;
    private var _image:Image;
    private var _count:int;
    private var _txtCount:CTextField;
    private var _callback:Function;
    private var _type:int;

    private var g:Vars = Vars.getInstance();

    public function DropMoneyItem(x:int, y:int, count:int, type:int, callback:Function) {
        _count = count;
        _type = type;
        _callback = callback;
        source = new Sprite();
        source.touchable = false;
        if (_type == DataMoney.HARD_CURRENCY) _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins"));
            else _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins"));
        _image.alignPivot();
        MCScaler.scale(_image, 50, 50);
        source.addChild(_image);
        source.x = x;
        source.y = y;
        if (_count > 1) {
            _txtCount = new CTextField(50,30, '+' + String(count));
            _txtCount.setFormat(CTextField.BOLD18, 18, 0xff7a3f, Color.WHITE);
            _txtCount.alignH = Align.LEFT;
            _txtCount.x = 1;
            _txtCount.y = -5;
            source.addChild(_txtCount);
        }
        startFly();
    }

    private function startFly():void {
        var endX:int;
        var endY:int;
        var plusX:int;
        var plusY:int;
        if (Math.random() > .5) {
            endX = source.x + 30;
            plusX = source.x + 40;
        } else {
            endX = source.x - 30;
            plusX = source.x - 40
        }

        if (Math.random() <= .2) {
            endY = source.y - 90;
            plusY = endY + 115;
        } else if (Math.random() <= .4) {
            endY = source.y - 105;
            plusY = endY + 110;
        } else if (Math.random() <= .6) {
            endY = source.y - 120;
            plusY = endY + 115;
        } else if (Math.random() <= .8) {
            endY = source.y - 130;
            plusY = endY + 120;
        } else {
            endY = source.y - 115;
            plusY = endY + 120;
        }
        AnimationsStock.joggleItBaby(_image, 90, .3, 1);
        new TweenMax(source, .9, {bezier:[{x: source.x, y: source.y}, {x:endX, y:endY}, {x:plusX, y:plusY}], ease:Linear.easeOut, onComplete: flyItMoney, delay:.3});
    }

    private function flyItMoney():void {
        var endPoint:Point = new Point();
        if (_type == DataMoney.HARD_CURRENCY) endPoint = g.softHardCurrency.getHardCurrencyPoint();
            else endPoint = g.softHardCurrency.getSoftCurrencyPoint();

        var f1:Function = function():void {
            g.softHardCurrency.animationBuy(_type == DataMoney.HARD_CURRENCY);
            g.userInventory.updateMoneyTxt(_type);
            if (g.managerTips) g.managerTips.calculateAvailableTips();
            if (_callback != null) {
                _callback.apply();
            }
            deleteIt();
        };
        var tempX:int;
        source.x < endPoint.x ? tempX = source.x + 70 : tempX = source.x - 70;
        var tempY:int = source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((source.x - tempX)*(source.x - tempX) + (source.y - tempY)*(source.y - tempY)));
        dist += int(Math.sqrt((tempX - endPoint.x)*(tempX - endPoint.x) + (tempY - endPoint.y)*(tempY - endPoint.y)));
        var t:Number = dist/1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        new TweenMax(source, t, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], ease:Linear.easeOut ,onComplete: f1, delay:.3});
    }

    private function deleteIt():void {
        if (!source) return;
        source.removeChild(_image);
        TweenMax.killTweensOf(_image);
        _image.dispose();
        _image = null;
        if (_txtCount) {
            source.removeChild(_txtCount);
            _txtCount.deleteIt();
            _txtCount = null;
        }
        source.dispose();
    }

}
}
