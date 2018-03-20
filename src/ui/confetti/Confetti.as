/**
 * Created by user on 2/15/18.
 */
package ui.confetti {
import manager.Vars;

import starling.display.Sprite;

import utils.Utils;

public class Confetti {
    private var _source:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _countEnterFrame:int;
    private var _countAll:int;
    private var confetti:ConfettiItem;

    public function Confetti() {
        _source = new Sprite();
        g.cont.hintCont.addChild(_source);
    }

    public function showIt():void {
        _countEnterFrame = 0;
        _countAll = 0;
        for (var i:int = 0; i < 30; i++) {
            confetti = new ConfettiItem();
            confetti.item.x = int(Math.random() * g.managerResize.stageWidth);
            if (Math.random()<= .3) confetti.item.y = int(Math.random() * g.managerResize.stageHeight) - 5;
            _source.addChild(confetti.item);
            confetti.flyIt(confetti.item.x);
        }
        g.gameDispatcher.addEnterFrame(createNewItem);
    }

    private function createNewItem():void {
        _countEnterFrame ++;
        _countAll++;
        if (_countAll >= 130) {
            g.gameDispatcher.removeEnterFrame(createNewItem);
            var f1:Function = function ():void {
                deleteIt();
            };
            Utils.createDelay(2,f1);
            return;
        }
        if (_countEnterFrame >= int(Math.random()* 5)) {
            g.gameDispatcher.removeEnterFrame(createNewItem);
            _countEnterFrame = -1;
            for (var i:int = 0; i < 2; i++) {
                confetti = new ConfettiItem();
                confetti.item.x = int(Math.random() * g.managerResize.stageWidth);
                if (Math.random()<= .3) confetti.item.y = int(Math.random() * g.managerResize.stageHeight) - 5;
                confetti.flyIt(confetti.item.x);
                _source.addChild(confetti.item);
            }
            g.gameDispatcher.addEnterFrame(createNewItem);
        }
    }

    public function hideIt():void {
        if (_countAll >= 130) return;
        else {
            g.gameDispatcher.removeEnterFrame(createNewItem);
            var f1:Function = function ():void {
                deleteIt();
            };
            Utils.createDelay(2,f1);
        }
    }

    private function deleteIt():void {
        g.cont.hintCont.removeChild(_source);
        _source.dispose();
        _source = null;
        confetti = null;
    }
}
}

import com.greensock.TweenMax;
import com.greensock.easing.Linear;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;

import utils.AnimationsStock;

import utils.MCScaler;

internal class ConfettiItem {
    private var g:Vars = Vars.getInstance();
    public var item:Sprite;
    private var itemIm:Image;
    private var _arrParticleImages:Array = ['p_1', 'p_2', 'p_3', 'p_4', 'p_5', 'p_6', 'p_7', 'p_8', 'p_9', 'p_10', 'p_11', 'p_12'];
    private var _arrParticleImagesNew:Array = ['pn_1', 'pn_2', 'pn_3', 'pn_4', 'pn_5', 'pn_6', 'pn_7', 'pn_8', 'pn_9'];

    public function ConfettiItem() {
        item = new Sprite();
        var l:Number = Math.random();
        if (l <= .5) itemIm = new Image(g.allData.atlas['interfaceAtlas'].getTexture(_arrParticleImages[int(Math.random()*12)]));
        else itemIm = new Image(g.allData.atlas['interfaceAtlas'].getTexture(_arrParticleImagesNew[int(Math.random()*9)]));
        item.addChild(itemIm);
        if (l <= .5) {
            if (Math.random() <= .3) item.scale = 2;
            else if (Math.random() <= .4) item.scale = 3;
            else item.scale = 1.5;

            if (Math.random() <= .1) item.alpha = .4;
            else if (Math.random() <= .2)item.alpha = .7;

            if (Math.random() <= .3) itemIm.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        } else {
            if (Math.random() <= .3) item.scale = 0.8;
            else if (Math.random() <= .4) item.scale = 1.5;
            else item.scale = 1;
        }

//        flyIt();
    }

    public function flyIt(x:int):void {
//         AnimationsStock.joggleItBaby(item, 6, .2, 1);
        var f1:Function = function():void {
            deleteIt();
        };
        AnimationsStock.tweenBezier(item, x, g.managerResize.stageHeight, f1, item.scale, Math.random() * .5);
    }

    private function deleteIt():void {
        item.dispose();
        item = null;
        itemIm.dispose();
        itemIm = null;
    }

}