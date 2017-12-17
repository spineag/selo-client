/**
 * Created by andy on 1/19/16.
 */
package windows.dailyBonusWindow {

import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.greensock.easing.Linear;

import data.BuildType;
import data.DataMoney;
import data.StructureDataBuilding;

import flash.display.StageDisplayState;

import flash.geom.Point;
import manager.ManagerDailyBonus;
import manager.ManagerFilters;
import manager.Vars;

import resourceItem.CraftItem;
import resourceItem.SimpleFlyDecor;
import resourceItem.newDrop.DropObject;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

import utils.MCScaler;

public class WODailyBonusCraftItem {
    private var _source:Sprite;
    private var _data:Object;
    private var _parent:Sprite;
    private var _callback:Function;
    private var _particle:Sprite;
    private var txt:CTextField;
    private var g:Vars = Vars.getInstance();

    public function WODailyBonusCraftItem(obj:Object, parent:Sprite, f:Function) {
        _data = obj;
        _parent = parent;
        _callback = f;

        var im:Image;
        switch (_data.type) {
            case ManagerDailyBonus.RESOURCE:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(obj.id).imageShop));
                break;
            case ManagerDailyBonus.PLANT:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(obj.id).imageShop + '_icon'));
                break;
            case ManagerDailyBonus.SOFT_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                break;
            case ManagerDailyBonus.HARD_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                break;
            case ManagerDailyBonus.DECOR:
                im = new Image(g.allData.atlas['decorAtlas'].getTexture(g.allData.getBuildingById(obj.id).image));
                break;
            case ManagerDailyBonus.INSTRUMENT:
                im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(obj.id).imageShop));
                break;
        }
        MCScaler.scale(im, 100, 100);
        im.alignPivot();
        _source = new Sprite();
        _source.addChild(im);
        txt = new CTextField(80, 60, '+'+String(obj.count));
        txt.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.x = 0;
        txt.y = 5;
        _source.addChild(txt);
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
        if (_source && _particle) {
            if (_source.contains(_particle)) _source.removeChild(_particle);
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
        var p:Point = new Point(0, 0);
        p = _source.localToGlobal(p);
        var d:DropObject = new DropObject();
        switch (_data.type) {
            case ManagerDailyBonus.RESOURCE:
                d.addDropItemNewByResourceId(_data.id, p, _data.count);
                break;
            case ManagerDailyBonus.PLANT:
                d.addDropItemNewByResourceId(_data.id, p, _data.count);
                break;
            case ManagerDailyBonus.SOFT_MONEY:
                d.addDropMoney(DataMoney.SOFT_CURRENCY, _data.count, p);
                break;
            case ManagerDailyBonus.HARD_MONEY:
                d.addDropMoney(DataMoney.HARD_CURRENCY, _data.count, p);
                break;
            case ManagerDailyBonus.DECOR:
                d.addDropDecor(g.allData.getBuildingById(_data.id), p, _data.count);
                break;
            case ManagerDailyBonus.INSTRUMENT:
                d.addDropItemNewByResourceId(_data.id, p, _data.count);
                break;
        }
        d.releaseIt(null, false);
        deleteIt();
    }

    private function deleteIt():void {
        removeParticle();
        TweenMax.killTweensOf(_source);
        if (txt) {
            _source.removeChild(txt);
            txt.deleteIt();
            txt = null;
        }
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
