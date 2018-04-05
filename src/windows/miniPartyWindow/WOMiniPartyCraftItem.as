/**
 * Created by user on 4/4/18.
 */
package windows.miniPartyWindow {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.BuildType;
import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import resourceItem.newDrop.DropObject;

import starling.display.Image;

import starling.display.Sprite;
import starling.utils.Color;

import utils.CTextField;
import utils.MCScaler;

public class WOMiniPartyCraftItem {
    private var _source:Sprite;
    private var _id:int;
    private var _type:int;
    private var _count:int;
    private var _parent:Sprite;
    private var _callback:Function;
    private var _particle:Sprite;
    private var txt:CTextField;
    private var g:Vars = Vars.getInstance();

    public function WOMiniPartyCraftItem(id:int, type:int, count:int, parent:Sprite, f:Function) {
        _id = id;
        _type = type;
        _count = count;
        _parent = parent;
        _callback = f;

        var im:Image;
        switch (_type) {
            case BuildType.RESOURCE:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_id).imageShop));
                break;
            case BuildType.PLANT:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(_id).imageShop + '_icon'));
                break;
            case 2:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                break;
            case 1:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                break;
            case BuildType.DECOR:
                im = new Image(g.allData.atlas['decorAtlas'].getTexture(g.allData.getBuildingById(_id).image));
                break;
            case BuildType.INSTRUMENT:
                im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(_id).imageShop));
                break;
        }
        MCScaler.scale(im, 100, 100);
        im.alignPivot();
        _source = new Sprite();
        _source.addChild(im);
        txt = new CTextField(80, 60, '+'+String(_count));
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
        switch (_type) {
            case BuildType.RESOURCE:
                d.addDropItemNewByResourceId(_id, p, _count);
                break;
            case BuildType.PLANT:
                d.addDropItemNewByResourceId(_id, p, _count);
                break;
            case 2:
                d.addDropMoney(DataMoney.SOFT_CURRENCY, _count, p);
                break;
            case 1:
                d.addDropMoney(DataMoney.HARD_CURRENCY, _count, p);
                break;
            case BuildType.DECOR:
                d.addDropDecor(g.allData.getBuildingById(_id), p, _count, true);
                break;
            case BuildType.INSTRUMENT:
                d.addDropItemNewByResourceId(_id, p, _count);
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
    }
}
}
