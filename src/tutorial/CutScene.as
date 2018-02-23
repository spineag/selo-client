/**
 * Created by yusjanja on 05.03.2016.
 */
package tutorial {
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;

import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import manager.Vars;
import starling.core.Starling;
import starling.display.Sprite;
import starling.events.Event;

import windows.WindowsManager;

public class CutScene {
    private var _source:Sprite;
    private var _sourceBubble:Sprite;
    private var _armature:Armature;
    private var g:Vars = Vars.getInstance();
    private var _bubble:CutSceneTextBubble;
    private var _cont:Sprite;
    private var _xStart:int;
    private var _xEnd:int;
    private var _isBigShop:Boolean;
    public function CutScene() {
        _cont = g.cont.popupCont;
        _source = new Sprite();
        _sourceBubble = new Sprite();
        _source.addChild(_sourceBubble);
        _xStart = -95;
        _xEnd = 125;
        if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) _isBigShop = false;
        else _isBigShop = true;
//        _isBigShop = false;////AHTUNG
        _armature = g.allData.factory['tutorialCatBig'].buildArmature('cat');
       if (_isBigShop) {
            (_armature.display as StarlingArmatureDisplay).x = 430;
            (_armature.display as StarlingArmatureDisplay).y = -115;
       } else {
           (_armature.display as StarlingArmatureDisplay).pivotX = (_armature.display as StarlingArmatureDisplay).width/2;
           (_armature.display as StarlingArmatureDisplay).pivotY = (_armature.display as StarlingArmatureDisplay).height/2;
           (_armature.display as StarlingArmatureDisplay).x = g.managerResize.stageWidth/2 -100;
           (_armature.display as StarlingArmatureDisplay).y = g.managerResize.stageHeight/2;
       }
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        onResize();
    }

    public function showIt(st:String, stBtn:String='', callback:Function=null, delay:Number=0, stURL:String = '', btnUrl:String = '', type:int = 0):void {
        _cont.addChild(_source);
        _source.x = _xStart;
        TweenMax.to(_source, .5, {x:_xEnd, onComplete:showBubble, onCompleteParams: [st, stBtn, callback, null, stURL, btnUrl, null, type], delay:delay});
        WorldClock.clock.add(_armature);
        animateCat();
    }

    private function showBubble(st:String, stBtn:String, callback:Function, callbackNo:Function=null, stURL:String='', btnUrl:String = '', startClick:Function = null, type:int = 0):void {
//        try {
            if (!st) {
                st = '';
                Cc.error('no text for CutScene');
            }
            if (type > 0) _bubble = new CutSceneTextBubble(_sourceBubble, type, stURL, btnUrl);
            else {
                if (st.length > 100 || stURL != '' || btnUrl != '') {
                    _bubble = new CutSceneTextBubble(_sourceBubble, CutSceneTextBubble.BIG, stURL, btnUrl);
                } else {
                    _bubble = new CutSceneTextBubble(_sourceBubble, CutSceneTextBubble.MIDDLE, '', '');
                }
            }
            _bubble.showBubble(st, stBtn, callback, callbackNo, startClick);
        if (_isBigShop) {
            _sourceBubble.x = 530;
            _sourceBubble.y = -420;
        } else {
            _sourceBubble.x = 420;
            _sourceBubble.y = -420;
        }
//        } catch (e:Error) {
//            Cc.error('CutScene showBubble: error ' + e.message);
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'cutScene showBubble');
//        }
    }

    public function reChangeBubble(st:String, stBtn:String='', callback:Function=null, callbackNo:Function = null, startClick:Function=null, btnUrl:String=''):void {
        var f:Function = function():void {
            showBubble(st, stBtn, callback, callbackNo, '', btnUrl, startClick);
        };
        if (_bubble) {
            _bubble.hideBubble(f, null);
            _bubble = null;
        }
    }

    public function hideIt(f:Function, f2:Function = null):void {
        if (_bubble) {
            _bubble.hideBubble(f, f2);
            _bubble = null;
        }
        TweenMax.to(_source, .3, {x:_xStart});

    }

    private var label:String;
    private var d:Number;
    private function animateCat(e:Event=null):void {
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, animateCat);
        if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, animateCat);

        d = Math.random();
        if (d < .25) label = 'idle';
            else if (d < .5) label = 'talk1';
            else if (d < .75) label = 'talk2';
            else label = 'talk3';
        _armature.addEventListener(EventObject.COMPLETE, animateCat);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, animateCat);
        _armature.animation.gotoAndPlayByFrame(label);
    }

    public function onResize():void {
        _source.y = g.managerResize.stageHeight - 25;
        if (_bubble) _bubble.onResize();
    }

    public function deleteIt():void {
        _bubble = null;
        if (_source) {
            _cont.removeChild(_source);
            _source.removeChild(_armature.display as Sprite);
            if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, animateCat);
            if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, animateCat);
            WorldClock.clock.remove(_armature);
            _armature.dispose();
            _armature = null;
            _source = null;
            _cont = null;
        }
    }
}
}
