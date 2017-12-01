/**
 * Created by user on 2/5/16.
 */
package order {
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
import manager.Vars;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import utils.IsoUtils;
import utils.Point3D;
import utils.Utils;

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

    protected var _posX:int;
    protected var _posY:int;
    protected var _depth:Number;
    protected var _source:TownAreaBuildSprite;
    protected var _speedWalk:int = 2;
    protected var _speedRun:int = 8;
    private var _catImage:Sprite;
    private var _catBackImage:Sprite;
//    private var heroEyes:HeroEyesAnimation;
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

    private var _isWoman:Boolean;
    protected var g:Vars = Vars.getInstance();

    public function OrderCat(ob:Object) {
        _posX = _posY = -1;
        _catData = ob;
        _source = new TownAreaBuildSprite();
        _source.isTouchable = false;
        _catImage = new Sprite();
        _catBackImage = new Sprite();
        armature = g.allData.factory['cat_queue'].buildArmature("cat");
        armatureBack = g.allData.factory['cat_queue'].buildArmature("cat_back");
        _catImage.addChild(armature.display as StarlingArmatureDisplay);
        _catBackImage.addChild(armatureBack.display as StarlingArmatureDisplay);
        WorldClock.clock.add(armature);
        WorldClock.clock.add(armatureBack);
        bant = 0;
//        if (_typeCat != BLACK) {
            changeCatTexture();
//        } else {
//            heroEyes = new HeroEyesAnimation(g.allData.factory['cat_queue'], armature, 'heads/head', '_black', false);
//            var b:Bone = armature.getBone('bant');
//            b.visible = false;
//        }
        _source.addChild(_catImage);
        _source.addChild(_catBackImage);
        showFront(true);
        _rect = _source.getBounds(_source);

        addShadow();
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
    public function get typeCat():int { return _catData.color; }
//    public function get sexCat():Boolean { return _catData.isWoman; }
    public function get dataCat():Object { return _catData; }
    public function showForOptimisation(needShow:Boolean):void { if (_source) _source.visible = needShow; }
    public function get isMiniScene():Boolean { return _catData.isMiniScene; }

    public function checkArriveCallback():void {
        if (_arriveCallback != null) {
            _arriveCallback.apply(null, [this]);
            _arriveCallback = null;
        }
    }

    private function addShadow():void {
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_shadow'));
        im.scaleX = im.scaleY = g.scaleFactor;
        im.x = -44*g.scaleFactor;
        im.y = -28*g.scaleFactor;
        im.alpha = .5;
        _source.addChildAt(im, 0);
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

    private function changeCatTexture():void {
        var st:String;
        var lid:String;
        var st2:String;
        switch (_catData.color) {
            case BLACK_MAN:
                st = 'black_c_m';
                st2 = '_black';
                lid = 'black';
                break;
            case BLACK_WOMAN:
                st = 'black_c_w';
                st2 = '_black';
                lid = 'black';
                break;
            case BLUE_MAN:
                st = 'blue_c_m';
                st2 = '_blue';
                lid = 'blue';
                break;
            case BLUE_WOMAN:
                st = 'blue_c_w';
                st2 = '_blue';
                lid = 'blue';
                break;
            case GREEN_MAN:
                st = 'green_c_m';
                st2 = '_green';
                lid = 'green';
                break;
            case GREEN_WOMAN:
                st = 'green_c_w';
                st2 = '_green';
                lid = 'green';
                break;
            case BROWN_MAN:
                st = 'brown_c_m';
                st2 = '_brown';
                lid = 'brown';
                break;
            case BROWN_WOMAN:
                st = 'brown_c_w';
                st2 = '_brown';
                lid = 'brown';
                break;
            case ORANGE_MAN:
                st = 'orange_c_m';
                st2 = '_orange';
                lid = 'orange';
                break;
            case ORANGE_WOMAN:
                st = 'orange_c_w';
                st2 = '_orange';
                lid = 'orange';
                break;
            case PINK_MAN:
                st = 'pink_c_m';
                st2 = '_pink';
                lid = 'pink';
                break;
            case PINK_WOMAN:
                st = 'pink_c_w';
                st2 = '_pink';
                lid = 'pink';
                break;
            case WHITE_MAN:
                st = 'white_c_m';
                st2 = '_white';
                lid = 'white';
                break;
            case WHITE_WOMAN:
                st = 'white_c_w';
                st2 = '_white';
                lid = 'white';
                break;
        }
        var vii1:Slot = armature.getSlot('vii1');
        var vii2:Slot = armature.getSlot('vii2');
        if (_catData.isWoman) {
            if (vii1 && vii1.display) vii1.display.visible = true;
            if (vii2 && vii2.display) vii2.display.visible = true;
        } else {
            if (vii1 && vii1.display) {
                vii1.display.visible = false;
                armature.removeSlot(vii1);
            }
            if (vii2 && vii2.display) {
                vii2.display.visible = false;
                armature.removeSlot(vii2);
            }
        }
        releaseFrontTexture(st, lid);
        releaseBackTexture(st);
    }

    private function releaseFrontTexture(st:String, lid:String):void {
        changeTexture("head", st + "_head_front", armature);
        changeTexture("body", st + "_body_front", armature);
        changeTexture("handLeft", st + '_l_hand_front', armature);
        changeTexture("handLeft 2copy", st + '_l_hand_front', armature);
        changeTexture("legLeft", st + '_l_leg_front', armature);
        changeTexture("handRight", st + '_r_hand_front', armature);
        changeTexture("legRight", st + '_r_leg_front', armature);
        changeTexture("tail", st + '_tail_front', armature);
        changeTexture("lid_l", 'lid_l_' + lid, armature);
        changeTexture("lid_r", 'lid_r_' + lid, armature);
    }

    private function releaseBackTexture(st:String):void {
        changeTexture("head", st + "_head_back", armatureBack);
        changeTexture("body", st + "_body_back", armatureBack);
        changeTexture("handLeft", st + '_l_hand_back', armatureBack);
        changeTexture("legLeft", st + '_l_leg_back', armatureBack);
        changeTexture("handRight", st + '_r_hand_back', armatureBack);
        changeTexture("legRight", st + '_r_leg_back', armatureBack);
        changeTexture("tail", st + '_tail_front', armatureBack);
    }

    private function changeTexture(oldName:String, newName:String, arma:Armature):void {
        var b:Slot = arma.getSlot(oldName);
        var im:Image = new Image(g.allData.atlas['customisationAtlas'].getTexture(newName));
        b.displayList = null;
        b.display = im;
    }

    public function setTailPositions(posX:int, posY:int):void {
        _posX = posX;
        _posY = posY;
        var p:Point = new Point(_posX, _posY);
        p = g.matrixGrid.getXYFromIndex(p);
        _source.x = p.x;
        _source.y = p.y;
    }

    public function deleteIt():void {
        g.townArea.removeOrderCatFromCityObjects(this);
        g.townArea.removeOrderCatFromCont(this);
        forceStopAnimation();
//        if (heroEyes) {
//            heroEyes.stopAnimations();
//            heroEyes = null;
//        }
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

    //  ------------------ ANIMATIONS -----------------------

    private var count:int;
    public function idleFrontAnimation():void {
        var r:int = int(Math.random()*16);
//        if (r != 10) {
            armature.addEventListener(EventObject.COMPLETE, onFinishIdle);
            armature.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
//        }


        if (r > 11) {
            armature.animation.gotoAndPlayByFrame("breath");
        } else {
            switch (r) {
                case 0: armature.animation.gotoAndPlayByFrame("idle1"); break;
                case 1: armature.animation.gotoAndPlayByFrame("idle2"); break;
                case 2: armature.animation.gotoAndPlayByFrame("idle3"); break;
                case 3: armature.animation.gotoAndPlayByFrame("idle4"); break;
                case 4: armature.animation.gotoAndPlayByFrame("idle5"); break;
                case 5: armature.animation.gotoAndPlayByFrame("idle6"); break;
                case 6: armature.animation.gotoAndPlayByFrame("idle7"); break;
                case 7: armature.animation.gotoAndPlayByFrame("idle8"); break;
                case 8: armature.animation.gotoAndPlayByFrame("idle9"); break;
                case 9: releaseBackIdle(); break;
                case 11: armature.animation.gotoAndPlayByFrame("breath"); break;
                case 10:
//                    armature.addEventListener(EventObject.COMPLETE, onFinishIdle);
//                    armature.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
                    switch (_catData.id) {
                        case 6: armature.animation.gotoAndPlayByFrame("akril");  break;
                        case 7: armature.animation.gotoAndPlayByFrame("agur"); break;
                        case 11: armature.animation.gotoAndPlayByFrame("bulavka"); break;
                        case 12: armature.animation.gotoAndPlayByFrame("businka"); break;
                        case 8: armature.animation.gotoAndPlayByFrame("igolochka"); break;
                        case 4: armature.animation.gotoAndPlayByFrame("iris"); break;
                        case 3: armature.animation.gotoAndPlayByFrame("kruchek"); break;
                        case 9: armature.animation.gotoAndPlayByFrame("lentochka"); break;
                        case 5: armature.animation.gotoAndPlayByFrame("naperdstok"); break;
                        case 13: armature.animation.gotoAndPlayByFrame("petelka"); break;
                        case 10: armature.animation.gotoAndPlayByFrame("pryaga"); break;
                        case 14: armature.animation.gotoAndPlayByFrame("sintetika"); break;
                        case 2: armature.animation.gotoAndPlayByFrame("stegok"); break;
                        case 1: armature.animation.gotoAndPlayByFrame("uzelok"); break;
//                            var vii1:Slot = armature.getSlot('vii1');
//                            var vii2:Slot = armature.getSlot('vii2');
//                            if (_catData.isWoman) {
//                                if (vii1 && vii1.display) vii1.display.visible = true;
//                                if (vii2 && vii2.display) vii2.display.visible = true;
//                            } else {
//                                if (vii1 && vii1.display) vii1.display.visible = false;
//                                if (vii2 && vii2.display) vii2.display.visible = false;
//                            }
                    }
                    break;
            }
        }
    }

    private function onFinishIdle(e:Event=null):void {
        armature.removeEventListener(EventObject.COMPLETE, onFinishIdle);
        armature.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
        idleFrontAnimation();
    }

    private function releaseBackIdle():void {
        showFront(false);
        count = 3;
        armatureBack.addEventListener(EventObject.COMPLETE, onFinishIdleBack);
        armatureBack.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
        armatureBack.animation.gotoAndPlayByFrame("idle");
    }

    private function onFinishIdleBack(e:Event=null):void {
        count--;
        armatureBack.removeEventListener(EventObject.COMPLETE, onFinishIdleBack);
        armatureBack.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
        if (count > 0) {
            armatureBack.addEventListener(EventObject.COMPLETE, onFinishIdleBack);
            armatureBack.addEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
            armatureBack.animation.gotoAndPlayByFrame("idle");
        } else {
            showFront(true);
            idleFrontAnimation();
        }
    }

    public function stopAnimation():void {
        showFront(true);
        if (armature) armature.animation.gotoAndStopByFrame('idle1');
        if (armatureBack) armatureBack.animation.gotoAndStopByFrame('idle');
        if (armature.hasEventListener(EventObject.COMPLETE)) armature.removeEventListener(EventObject.COMPLETE, onFinishIdle);
        if (armature.hasEventListener(EventObject.LOOP_COMPLETE)) armature.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdle);
        if (armatureBack.hasEventListener(EventObject.COMPLETE)) armatureBack.removeEventListener(EventObject.COMPLETE, onFinishIdleBack);
        if (armatureBack.hasEventListener(EventObject.LOOP_COMPLETE)) armatureBack.removeEventListener(EventObject.LOOP_COMPLETE, onFinishIdleBack);
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
        armature.animation.gotoAndPlayByFrame("run");
        armatureBack.animation.gotoAndPlayByFrame("run");
    }

    public function sayHIAnimation(callback:Function, b:Boolean = false):void {
        _callbackHi= callback;
        if (b) {
            stopAnimation();
            showFront(true);
        }
        var onSayHI:Function = function(e:Event=null):void {
            if (armature.hasEventListener(EventObject.COMPLETE)) armature.removeEventListener(EventObject.COMPLETE, onSayHI);
            if (armature.hasEventListener(EventObject.LOOP_COMPLETE)) armature.removeEventListener(EventObject.LOOP_COMPLETE, onSayHI);
            if (_callbackHi != null) {
                _callbackHi.apply();
            }
        };
        var f1:Function = function ():void {
            armature.addEventListener(EventObject.COMPLETE, onSayHI);
            armature.addEventListener(EventObject.LOOP_COMPLETE, onSayHI);
            armature.animation.gotoAndPlayByFrame('idle2');
        };

        if (b) Utils.createDelay(int(Math.random() * 2) + 2,f1);
        else f1();
    }

    // --------------- WALKING --------------

    public function goWithPath(arr:Array, callbackOnWalking:Function, catGoAway:Boolean = false):void {
        _currentPath = arr;
        if (_currentPath.length) {
            _currentPath.shift(); // first element is that point, where we are now
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
        if (p.x == _posX + 1) {
            if (p.y == _posY) {
                showFront(true);
                flipIt(true);
            } else if (p.y == _posY - 1) {
                showFront(true);
                flipIt(true);
            } else if (p.y == _posY + 1) {
                showFront(true);
                flipIt(false);
            }
        } else if (p.x == _posX) {
            if (p.y == _posY) {
                showFront(true);
                flipIt(false);
            } else if (p.y == _posY - 1) {
                showFront(false);
                flipIt(false);
            } else if (p.y == _posY + 1) {
                showFront(true);
                flipIt(false);
            }
        } else if (p.x == _posX - 1) {
            if (p.y == _posY) {
                showFront(false);
                flipIt(true);
            } else if (p.y == _posY - 1) {
                showFront(false);
                flipIt(false);
            } else if (p.y == _posY + 1) {
                showFront(true);
                flipIt(false);
            }
        } else {
            showFront(true);
            _source.scaleX = 1;
            Cc.error('OrderCat gotoPoint:: wrong front-back logic');
        }
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
