/**
 * Created by andy on 1/19/16.
 */
package windows.chestWindow {

import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Linear;

import data.BuildType;

import flash.display.StageDisplayState;

import flash.geom.Point;

import manager.ManagerChest;
import manager.ManagerDailyBonus;
import manager.ManagerFilters;
import manager.Vars;

import resourceItem.CraftItem;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

import utils.MCScaler;

public class WOChestItem {
    private var _source:Sprite;
    private var _data:Object;
    private var _parent:Sprite;
    private var _callback:Function;
    private var _particle:Sprite;
    private var _txt:CTextField;
    private var g:Vars = Vars.getInstance();

    public function WOChestItem(obj:Object, parent:Sprite, f:Function) {
        _data = obj;
        _parent = parent;
        _callback = f;

        var im:Image;
        switch (_data.type) {
            case ManagerChest.RESOURCE:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(obj.id).imageShop));
                break;
            case ManagerChest.PLANT:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(obj.id).imageShop + '_icon'));
                break;
            case ManagerChest.SOFT_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                break;
            case ManagerChest.HARD_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                break;
            case ManagerChest.INSTRUMENT:
                im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(obj.id).imageShop));
                break;
        }
        MCScaler.scale(im, 100, 100);
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source = new Sprite();
        _source.addChild(im);
        _txt = new CTextField(80, 60, '+'+String(obj.count));
        _txt.setFormat(CTextField.MEDIUM30, 30, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txt.x = 0;
        _txt.y = 5;
        _source.addChild(_txt);
        _parent.addChild(_source);
        showIt();
    }

    private function addParticle():void {
        _particle = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('product_particle'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -im.width/2;
        im.y = -im.height/2;
        _particle.addChild(im);
        _source.addChildAt(_particle, 0);
        _particle.touchable = false;
        new TweenMax(_particle, .3, {scaleX:g.scaleFactor*4, scaleY:g.scaleFactor*4, ease:Linear.easeIn, onComplete: makeTweenParticle});
    }

    private function makeTweenParticle():void {
        new TweenMax(_particle, 4, {rotation:-Math.PI*4, ease:Linear.easeNone});
    }

    private function hideParticle(delay:Number):void {
        new TweenMax(_particle, .4, {scaleX:.1, scaleY:.1, onComplete: removeParticle, ease:Linear.easeNone, delay:delay});
    }

    private function removeParticle():void {
        if (_particle) {
            if (_source.contains(_particle))_source.removeChild(_particle);
            TweenMax.killTweensOf(_particle);
            _particle.dispose();
            _particle = null;
        }
    }

    private function showIt():void {
        _source.scaleX = _source.scaleY = .5;
        new TweenMax(_source, .1, {scaleX:1.5, scaleY:1, ease:Linear.easeIn, onComplete:showIt1});
    }

    private function showIt1():void {
        addParticle();
        new TweenMax(_source, .1, {scaleX:1, scaleY:1.5, ease:Linear.easeIn, onComplete:showIt2});
    }

    private function showIt2():void {
        new TweenMax(_source, .1, {scaleX:1.3, scaleY:1.3, ease:Linear.easeIn, onComplete:delayBeforeFly});

    }

    private function delayBeforeFly():void {
        new TweenMax(_source, .1, {scaleX:1.3, scaleY:1.3, onComplete:flyIt, delay:1.5});
    }

    private function flyIt():void {
        hideParticle(0);
        switch (_data.type) {
            case ManagerChest.RESOURCE:
                flyItResource();
                break;
            case ManagerChest.PLANT:
                flyItResource();
                break;
            case ManagerChest.SOFT_MONEY:
                flyItMoney(true);
                break;
            case ManagerChest.HARD_MONEY:
                flyItMoney(false);
                break;
            case ManagerChest.INSTRUMENT:
                flyItResource();
                break;
        }
    }

    private function flyItMoney(isSoft:Boolean):void {
        var endPoint:Point;

        var f1:Function = function():void {
            if (isSoft) {
                g.userInventory.addMoney(2, _data.count);
            } else {
                g.userInventory.addMoney(1, _data.count);
            }
            deleteIt();
        };

        endPoint = new Point();
        endPoint.x = _source.x;
        endPoint.y = _source.y;
        endPoint = _parent.localToGlobal(endPoint);
        _parent.removeChild(_source);
        _parent = g.cont.animationsResourceCont;
        _source.x = endPoint.x;
        _source.y = endPoint.y;
        _parent.addChild(_source);
        if (isSoft) {
            endPoint = g.softHardCurrency.getSoftCurrencyPoint();
        } else {
            endPoint = g.softHardCurrency.getHardCurrencyPoint();
        }
        var tempX:int = _source.x - 70;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - tempX)*(_source.x - tempX) + (_source.y - tempY)*(_source.y - tempY)));
        dist += int(Math.sqrt((tempX - endPoint.x)*(tempX - endPoint.x) + (tempY - endPoint.y)*(tempY - endPoint.y)));
        var t:Number = dist/1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        new TweenMax(_source, t, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], scaleX:.5, scaleY:.5, ease:Linear.easeOut ,onComplete: f1});
    }

    private function flyItResource():void {
        var endPoint:Point;

        var f1:Function = function():void {
            g.craftPanel.afterFlyWithId(_data.id);
            deleteIt();
        };
        g.userInventory.addResource(_data.id, _data.count);
        endPoint = new Point();
        endPoint.x = _source.x;
        endPoint.y = _source.y;
        endPoint = _parent.localToGlobal(endPoint);
        _parent.removeChild(_source);
        _parent = g.cont.animationsResourceCont;
        _source.x = endPoint.x;
        _source.y = endPoint.y;
        _parent.addChild(_source);
        if (g.allData.getResourceById(_data.id).placeBuild == BuildType.PLACE_SKLAD) {
            g.craftPanel.showIt(BuildType.PLACE_SKLAD);
        } else {
            g.craftPanel.showIt(BuildType.PLACE_AMBAR);
        }
        endPoint = g.craftPanel.pointXY();
        var tempX:int = _source.x - 70;
        var tempY:int = _source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((_source.x - tempX)*(_source.x - tempX) + (_source.y - tempY)*(_source.y - tempY)));
        dist += int(Math.sqrt((tempX - endPoint.x)*(tempX - endPoint.x) + (tempY - endPoint.y)*(tempY - endPoint.y)));
        var t:Number = dist/1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        new TweenMax(_source, t, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], scaleX:.5, scaleY:.5, ease:Linear.easeOut ,onComplete: f1});
    }

    private function deleteIt():void {
        if (_txt) {
            _source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        TweenMax.killTweensOf(_source);
        _parent.removeChild(_source);
        _source.dispose();
        _source = null;
        _parent = null;

        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
        _data = null;
    }

}
}
