/**
 * Created by user on 12/28/16.
 */
package windows.chestYellowWindow {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import data.BuildType;
import data.DataMoney;

import flash.geom.Point;

import manager.ManagerChest;
import manager.ManagerFilters;
import manager.Vars;

import resourceItem.newDrop.DropObject;

import starling.display.Image;

import starling.display.Sprite;
import starling.utils.Color;

import utils.CTextField;
import utils.MCScaler;

public class WOChestYellowItem {
    public  var source:Sprite;
    private var _data:Object;
    private var _parent:Sprite;
    private var _callback:Function;
    private var _particle:Sprite;
    private var _txt:CTextField;
    private var g:Vars = Vars.getInstance();

    public function WOChestYellowItem(obj:Object, parent:Sprite, f:Function) {
        _data = obj;
        _parent = parent;
        _callback = f;

        var im:Image;
        switch (_data.types) {
            case ManagerChest.RESOURCE:
                    if (g.allData.getResourceById(_data.resource_id).buildType == BuildType.PLANT) {
                        im = new Image(g.allData.atlas[g.allData.getResourceById(_data.resource_id).url].getTexture(g.allData.getResourceById(_data.resource_id).imageShop + '_icon'));
                    } else {
                        im = new Image(g.allData.atlas[g.allData.getResourceById(_data.resource_id).url].getTexture(g.allData.getResourceById(_data.resource_id).imageShop));
                    }
                _txt = new CTextField(80, 60, '+' + String(_data.resource_count));
                _txt.setFormat(CTextField.BOLD30, 26, Color.WHITE, ManagerFilters.BROWN_COLOR);
                break;

            case ManagerChest.SOFT_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                _txt = new CTextField(80, 60, '+' + String(_data.money_count));
                _txt.setFormat(CTextField.BOLD30, 26, Color.WHITE, ManagerFilters.BROWN_COLOR);
                break;

            case ManagerChest.XP:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('xp_icon'));
                _txt = new CTextField(80, 60, '+' + String(_data.xp_count));
                _txt.setFormat(CTextField.BOLD30, 26, Color.WHITE, ManagerFilters.BROWN_COLOR);
                break;
        }
        MCScaler.scale(im, 80, 80);
        im.x = -im.width / 2;
        im.y = -im.height / 2;
        source = new Sprite();
        source.addChild(im);
        _txt.x = -12;
        _txt.y = 15;
        source.addChild(_txt);
        _parent.addChild(source);
        showIt();
    }

    private function addParticle():void {
        _particle = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('product_particle'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -im.width / 2;
        im.y = -im.height / 2;
        _particle.addChild(im);
        source.addChildAt(_particle, 0);
        _particle.touchable = false;
        new TweenMax(_particle, .3, {
            scaleX: g.scaleFactor * 4,
            scaleY: g.scaleFactor * 4,
            ease: Linear.easeIn,
            onComplete: makeTweenParticle
        });
    }

    private function makeTweenParticle():void {
        new TweenMax(_particle, 4, {rotation: -Math.PI * 4, ease: Linear.easeNone});
    }

    private function hideParticle(delay:Number):void {
        new TweenMax(_particle, .4, {
            scaleX: .1,
            scaleY: .1,
            onComplete: removeParticle,
            ease: Linear.easeNone,
            delay: delay
        });
    }

    private function removeParticle():void {
        if (_particle && source) {
            if (source.contains(_particle))source.removeChild(_particle);
            TweenMax.killTweensOf(_particle);
            _particle.dispose();
            _particle = null;
        }
    }

    private function showIt():void {
        source.scaleX = source.scaleY = .5;
        new TweenMax(source, .1, {scaleX: 1.5, scaleY: 1, ease: Linear.easeIn, onComplete: showIt1});
    }

    private function showIt1():void {
        addParticle();
        new TweenMax(source, .1, {scaleX: 1, scaleY: 1.5, ease: Linear.easeIn, onComplete: showIt2});
    }

    private function showIt2():void {
        new TweenMax(source, .1, {scaleX: 1.3, scaleY: 1.3, ease: Linear.easeIn, onComplete: delayBeforeFly});

    }

    private function delayBeforeFly():void {
        new TweenMax(source, .1, {scaleX: 1.3, scaleY: 1.3, onComplete: flyIt, delay: 1.5});
    }

    private function flyIt():void {
        hideParticle(0);
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        var d:DropObject = new DropObject();
        switch (int(_data.types)) {
            case ManagerChest.RESOURCE:
                d.addDropItemNewByResourceId(_data.resource_id, p, _data.resource_count);
                break;
            case ManagerChest.SOFT_MONEY:
                d.addDropMoney(DataMoney.HARD_CURRENCY, _data.money_count, p);
                break;
            case ManagerChest.XP:
                d.addDropXP(_data.xp_count, p);
                break;
        }
        d.releaseIt(null, false);
//        d.releaseIt();
        deleteIt();
    }

    private function deleteIt():void {
        TweenMax.killTweensOf(source);
        _parent.removeChild(source);
        if (_txt) {
            source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        source.dispose();
        source = null;
        _parent = null;
        if (_data.resource_id) {
            if (_callback != null) {
                _callback.apply();
                _callback = null;
            }
        }
        _data = null;
    }
}
}