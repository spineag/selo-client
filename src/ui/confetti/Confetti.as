/**
 * Created by user on 2/15/18.
 */
package ui.confetti {
import manager.Vars;

import starling.display.Sprite;

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
            if (Math.random()<= .3) confetti.item.y = int(Math.random() * g.managerResize.stageHeight);
            _source.addChild(confetti.item);
            confetti.flyIt(confetti.item.x);
        }
        g.gameDispatcher.addEnterFrame(createNewItem);
    }

    private function createNewItem():void {
        _countEnterFrame ++;
        _countAll++;
        if (_countAll >= 140) {
            g.gameDispatcher.removeEnterFrame(createNewItem);
            deleteIt();
            return;
        }
        if (_countEnterFrame >= int(Math.random()* 5)) {
            g.gameDispatcher.removeEnterFrame(createNewItem);
            _countEnterFrame = -1;
            for (var i:int = 0; i < 2; i++) {
                confetti = new ConfettiItem();
                confetti.item.x = int(Math.random() * g.managerResize.stageWidth);
                if (Math.random()<= .3) confetti.item.y = int(Math.random() * g.managerResize.stageHeight);
                confetti.flyIt(confetti.item.x);
                _source.addChild(confetti.item);
            }
            g.gameDispatcher.addEnterFrame(createNewItem);
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

    public function ConfettiItem() {
        item = new Sprite();
        itemIm = new Image(g.allData.atlas['interfaceAtlas'].getTexture(_arrParticleImages[int(Math.random()*12)]));
        item.addChild(itemIm);
        if (Math.random()<= .3) item.scale = 2;
        else if (Math.random()<= .4) item.scale = 3;
        else item.scale = 1.5;

        if (Math.random() <= .1) item.alpha = .4;
        else if (Math.random() <= .2)item.alpha = .7;

        if (Math.random() <= .3) itemIm.filter = ManagerFilters.BUILDING_HOVER_FILTER;
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