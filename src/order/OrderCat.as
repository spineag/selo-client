/**
 * Created by user on 2/5/16.
 */
package order {
import data.BuildType;
import data.DataMoney;
import data.StructureDataResource;

import dragonBones.Bone;

import heroes.*;
import build.TownAreaBuildSprite;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;
import flash.geom.Point;
import flash.geom.Rectangle;

import manager.ManagerFilters;

import manager.ManagerPartyNew;
import manager.Vars;

import resourceItem.RawItem;
import resourceItem.newDrop.DropObject;

import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.utils.Color;

import tutorial.TutorialTextBubble;

import utils.CSprite;
import utils.CTextField;

import utils.IsoUtils;
import utils.Point3D;
import utils.Utils;

import windows.WindowsManager;

public class OrderCat {
    public static var BLACK_MAN:int = 1;
    public static var BLACK_WOMAN:int = 2;
    public static var BLUE_MAN:int = 3;
    public static var BLUE_WOMAN:int = 4;
    public static var GREEN_MAN:int = 5;
    public static var GREEN_WOMAN:int = 6;
    public static var ORANGE_MAN:int = 7;
    public static var ORANGE_WOMAN:int = 8;
    public static var PINK_MAN:int = 9;
    public static var PINK_WOMAN:int = 10;
    public static var WHITE_MAN:int = 11;
    public static var WHITE_WOMAN:int = 12;
    public static var BROWN_MAN:int = 13;
    public static var BROWN_WOMAN:int = 14;

    public static var LONG_OUTTILE_WALKING:int=1;
    public static var SHORT_OUTTILE_WALKING:int=2;
    public static var TILE_WALKING:int = 3;
    public static var STAY_IN_QUEUE:int = 4;

    public static var STATE_EMPTY:int = 1;
    public static var STATE_FULL:int = 2;
    public static var STATE_COIN:int = 3;

    protected var _posX:int;
    protected var _posY:int;
    protected var _depth:Number;
    protected var _source:TownAreaBuildSprite;
    protected var _speedWalk:int = 2;
    protected var _speedRun:int = 8;
    private var _catImage:CSprite;
    private var _catBackImage:CSprite;
    private var armature:Armature;
    private var armatureBack:Armature;
    private var _queuePosition:int;
    private var _currentPath:Array;
    public var walkPosition:int;
    public var bant:int;
    private var _arriveCallback:Function;
    private var _callbackHi:Function;
    private var _catData:Object;
    private var _rect:Rectangle;
    private var _timerForNewCat:int;
    private var _position:int;
    private var _stateBox:int;
    private var _bubble:TutorialTextBubble;
    private var _timer:int;

    protected var g:Vars = Vars.getInstance();

    public function OrderCat(ob:Object, del:Boolean = false, timeToNew:int = 0, position:int = 0) {
        _stateBox = 0;
        if (del) {
            _timerForNewCat = timeToNew;
            _position = position;
            g.gameDispatcher.addToTimer(delTimer);
        } else {
            _posX = _posY = -1;
            _catData = ob;
            _source = new TownAreaBuildSprite();
//            _source.isTouchable = false;
            _catImage = new CSprite();
            _catBackImage = new CSprite();
            armature = g.allData.factory['cat_moto'].buildArmature("cat_moto_front");
            armatureBack = g.allData.factory['cat_moto'].buildArmature("cat_moto_back");
            _catImage.addChild(armature.display as StarlingArmatureDisplay);
            _catBackImage.addChild(armatureBack.display as StarlingArmatureDisplay);
            _catImage.endClickCallback = onClick;
            WorldClock.clock.add(armature);
            WorldClock.clock.add(armatureBack);
            bant = 0;
            _source.addChild(_catImage);
            _source.addChild(_catBackImage);
            showFront(true);
            checkBoxState();
            _rect = _source.getBounds(_source);
        }
    }

    private function delTimer():void {
        _timerForNewCat --;
        if (_timerForNewCat <= 16) {
            _timerForNewCat = 0;
            g.gameDispatcher.removeFromTimer(delTimer);
            g.userTimer.newCatOrder(_position);
        }
    }

    public function get rect():Rectangle { return _rect; }
    public function setPositionInQueue(i:int):void { _queuePosition = i; }
    public function get queuePosition():int { return _queuePosition; }
    public function get source():Sprite { return _source; }
    public function get posX():int { return _posX; }
    public function get posY():int { return _posY; }
    public function flipIt(v:Boolean):void { v ? _source.scaleX = -1: _source.scaleX = 1; }
    public function set arriveCallback(f:Function):void { _arriveCallback = f; }
    public function get dataCatId():int { return _catData.id; }
    public function get dataCat():Object { return _catData; }
    public function showForOptimisation(needShow:Boolean):void { if (_source) _source.visible = needShow; }
    public function get stateBox():int { return _stateBox; }
//    public function get isMiniScene():Boolean { return _catData.isMiniScene; }

    public function checkArriveCallback():void {
        if (_arriveCallback != null) {
            _arriveCallback.apply(null, [this]);
            _arriveCallback = null;
        }
    }

    public function showBable():void {
        _timer = 0;
        _bubble = new TutorialTextBubble(g.cont.animationsCont);
        _bubble.showBubble( String(g.managerLanguage.allTexts[1370]), true, TutorialTextBubble.SMALL);
        _bubble.setXY(5 + _source.x, -25 + _source.y);
        g.gameDispatcher.addToTimer(checkBubble);
    }

    private function checkBubble():void {
        _timer++;
        if (_timer >= 10) {
            g.gameDispatcher.removeFromTimer(checkBubble);
            hideBubble();
        }
    }

    public function hideBubble():void {
        if (_bubble) {
            _bubble.clearIt();
        }
    }

    public function get depth():Number {
        var p:Point = new Point(_source.x, _source.y);
        p = g.matrixGrid.getIndexFromXY(p);
        _posX = p.x;
        _posY = p.y;
        if (_posX < 0 || _posY < 0) {
            _depth = _source.y - 150;
        } else {
            p.x = _source.x;
            p.y = _source.y;
            var point3d:Point3D = IsoUtils.screenToIso(p);
            point3d.x += g.matrixGrid.FACTOR/2;
            point3d.z += g.matrixGrid.FACTOR/2;
            _depth = point3d.x + point3d.z;
        }
        return _depth;
    }

    public function showFront(v:Boolean):void {
        _catImage.visible = v;
        _catBackImage.visible = !v;
    }

    public function setTailPositions(posX:int, posY:int):void {
        _posX = int(posX);
        _posY = int(posY);
        var p:Point = new Point(posX, posY);
        p = g.matrixGrid.getXYFromIndex(p);
        _source.x = p.x;
        _source.y = p.y;
    }

    public function deleteIt():void {
        g.townArea.removeOrderCatFromCityObjects(this);
        g.townArea.removeOrderCatFromCont(this);
        forceStopAnimation();
        WorldClock.clock.remove(armature);
        WorldClock.clock.remove(armatureBack);
        TweenMax.killTweensOf(_source);
        while (_source.numChildren) _source.removeChildAt(0);
        if (armature) {
            armature.dispose();
            armature = null;
        }
        if (armatureBack) {
            armatureBack.dispose();
            armatureBack = null;
        }
        _catImage = null;
        _catBackImage = null;
        _source.dispose();
        _currentPath = [];
    }

    public function giftAdd():void {
        var p1:Point = new Point(0,-10);
        p1 = _source.localToGlobal(p1);
        var d:DropObject = new DropObject();
        if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_XP_ORDER) {
            g.managerParty.addUserPartyCount(1);
            d.addDropXP(g.managerOrderCats.orderTtStr.xp * g.managerParty.coefficient, p1);
        } else d.addDropXP(g.managerOrderCats.orderTtStr.xp, p1);
//        var p1:Point = new Point(0,-10);
//        p1 = _source.localToGlobal(p1);
        if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_ORDER) {
            g.managerParty.addUserPartyCount(1);
            d.addDropMoney(DataMoney.SOFT_CURRENCY, g.managerOrderCats.orderTtStr.coins * g.managerParty.coefficient, p1);
        } else d.addDropMoney(DataMoney.SOFT_CURRENCY, g.managerOrderCats.orderTtStr.coins, p1);
        d.releaseIt();
        g.managerOrderCats.deleteOrderStr();
    }

    //  ------------------ ANIMATIONS -----------------------

    private var count:int;
    public function idleFrontAnimation():void {
        var r:int = int(Math.random()*10);
        armature.addEventListener(EventObject.COMPLETE, onFinishIdle);
        armature.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);

        if (r >= 4) {
            armature.animation.gotoAndPlayByFrame("idle2");
        } else {
            switch (r) {
                case 0: armature.animation.gotoAndPlayByFrame("idle"); break;
                case 1: armature.animation.gotoAndPlayByFrame("idle3"); break;
                case 2: armature.animation.gotoAndPlayByFrame("idle4"); break;
                case 3: armature.animation.gotoAndPlayByFrame("idle5"); break;
            }
        }
    }

    public function onClick():void {
        if (!g.managerOrderCats.moveBoolean && _stateBox == STATE_COIN) {
            checkBoxState(STATE_EMPTY);
            giftAdd();
            g.server.deleteUserOrderGift(null);
        } else if (!g.managerOrderCats.moveBoolean && _stateBox == STATE_EMPTY) g.windowsManager.openWindow(WindowsManager.WO_ORDERS, null);
    }

    private function onFinishIdle(e:Event=null):void {
        armature.removeEventListener(EventObject.COMPLETE, onFinishIdle);
        armature.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
        idleFrontAnimation();
    }

    public function rawMotto(or:OrderItemStructure):void {
        var p:Point = new Point(0,-10);
        p = _source.localToGlobal(p);
        var obj:Object;
        var texture:Texture;
        for (var i:int = 0; i < or.resourceIds.length; i++) {
            if (or.resourceIds[i]) {
                obj = g.allData.getResourceById(int(or.resourceIds[i]));
                if (obj.buildType == BuildType.PLANT)  texture = g.allData.atlas['resourceAtlas'].getTexture(obj.imageShop + '_icon');
                else texture = g.allData.atlas[obj.url].getTexture(obj.imageShop);
                new RawItem(p, texture, int(or.resourceCounts[i]), i * .1);
            }
        }
        checkBoxState(STATE_FULL);
        g.managerOrderCats.onReleaseOrder(true);
    }

    public function checkBoxState(state:int = 1):void {
        _stateBox = state;
        var emptyFront:Slot = armature.getSlot('back_empty');
        var fullFront:Slot = armature.getSlot('back_product');
        var coinsFront:Slot = armature.getSlot('back_coin');

        var emptyBack:Slot = armatureBack.getSlot('back_empty');
        var fullBack:Slot = armatureBack.getSlot('back_product');
        var coinsBack:Slot = armatureBack.getSlot('back_coin');
        if (_stateBox == STATE_EMPTY) {
            if (fullFront && fullFront.display) fullFront.display.visible = false;
            if (coinsFront && coinsFront.display) coinsFront.display.visible = false;
            if (fullBack && fullBack.display) fullBack.display.visible = false;
            if (coinsBack && coinsBack.display) coinsBack.display.visible = false;
            if (emptyFront && emptyFront.display) emptyFront.display.visible = true;
            if (emptyBack && emptyBack.display) emptyBack.display.visible = true;
        } else if (_stateBox == STATE_COIN) {
            if (fullFront && fullFront.display) fullFront.display.visible = false;
            if (coinsFront && coinsFront.display) coinsFront.display.visible = true;
            if (fullBack && fullBack.display) fullBack.display.visible = false;
            if (coinsBack && coinsBack.display) coinsBack.display.visible = true;
            if (emptyFront && emptyFront.display) emptyFront.display.visible = false;
            if (emptyBack && emptyBack.display) emptyBack.display.visible = false;
        } else if (_stateBox == STATE_FULL) {
            if (fullFront && fullFront.display) fullFront.display.visible = true;
            if (coinsFront && coinsFront.display) coinsFront.display.visible = false;
            if (fullBack && fullBack.display) fullBack.display.visible = true;
            if (coinsBack && coinsBack.display) coinsBack.display.visible = false;
            if (emptyFront && emptyFront.display) emptyFront.display.visible = false;
            if (emptyBack && emptyBack.display) emptyBack.display.visible = false;
        }
    }

    public function stopAnimation():void {
        showFront(true);
        if (armature) armature.animation.gotoAndStopByFrame('idle1');
        if (armatureBack) armatureBack.animation.gotoAndStopByFrame('idle');
        if (armature.hasEventListener(EventObject.COMPLETE)) armature.removeEventListener(EventObject.COMPLETE, onFinishIdle);
        if (armature.hasEventListener(EventObject.LOOP_COMPLETE)) armature.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
    }

    public function forceStopAnimation():void {
        if (_callbackHi != null) _callbackHi = null;
        stopAnimation();
        TweenMax.killTweensOf(_source);
    }

    public function walkAnimation():void {
        armature.animation.gotoAndPlayByFrame("walk");
        armatureBack.animation.gotoAndPlayByFrame("walk");
    }

    public function walkPackAnimation():void {
        armature.animation.gotoAndPlayByFrame("walk_pack");
        armatureBack.animation.gotoAndPlayByFrame("walk_pack");
    }

    public function runAnimation():void {
        armature.animation.gotoAndPlayByFrame("walk");
        armatureBack.animation.gotoAndPlayByFrame("walk");
    }

    // --------------- WALKING --------------

    public function goWithPath(arr:Array, callbackOnWalking:Function, catGoAway:Boolean = false):void {
        _currentPath = arr;
        if (_currentPath.length) {
//            _currentPath.shift(); // first element is that point, where we are now
            gotoPoint(_currentPath.shift(), callbackOnWalking, catGoAway);
        }
    }

    private function gotoPoint(p:Point, callbackOnWalking:Function, catGoAway:Boolean = false):void {
        var koef:Number = 1;
        var pXY:Point = g.matrixGrid.getXYFromIndex(p);
        var f1:Function = function(callbackOnWalking:Function):void {
            _posX = p.x;
            _posY = p.y;
            g.townArea.zSort();
            if (_currentPath.length) {
                gotoPoint(_currentPath.shift(), callbackOnWalking,catGoAway);
            } else {
                if (callbackOnWalking != null) {
                    callbackOnWalking.apply();
                }
            }
        };

        if (Math.abs(_posX - p.x) + Math.abs(_posY - p.y) == 2) {
            koef = 1.4;
        } else {
            koef = 1;
        }
//        if (p.x == _posX + 1) {
//            if (p.y == _posY) {
//                showFront(true);
//                flipIt(true);
//            } else if (p.y == _posY - 1) {
//                showFront(true);
//                flipIt(true);
//            } else if (p.y == _posY + 1) {
//                showFront(true);
//                flipIt(false);
//            }
//        } else if (p.x == _posX) {
//            if (p.y == _posY) {
//                showFront(true);
//                flipIt(false);
//            } else if (p.y == _posY - 1) {
//                showFront(false);
//                flipIt(false);
//            } else if (p.y == _posY + 1) {
//                showFront(true);
//                flipIt(false);
//            }
//        } else if (p.x == _posX - 1) {
//            if (p.y == _posY) {
//                showFront(false);
//                flipIt(true);
//            } else if (p.y == _posY - 1) {
//                showFront(false);
//                flipIt(false);
//            } else if (p.y == _posY + 1) {
//                showFront(true);
//                flipIt(false);
//            }
//        } else {
//            showFront(true);
//            _source.scaleX = 1;
//            Cc.error('OrderCat gotoPoint:: wrong front-back logic');
//        }
        if (g.tuts.isTuts) {
            new TweenMax(_source, koef/_speedRun, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
        } else {
            if (catGoAway) new TweenMax(_source, koef/_speedWalk, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
            else new TweenMax(_source, koef/_speedRun, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
        }
    }

    public function goCatToXYPoint(p:Point, time:int, callbackOnWalking:Function, delay:int):void {
        new TweenMax(_source, time, {x:p.x, y:p.y, ease:Linear.easeNone, onComplete: f2, delay: delay, onCompleteParams:[callbackOnWalking]});
    }

    private function f2(f:Function) :void {
        if (f != null) {
            f.apply(null, [this]);
        }
    }

}
}
