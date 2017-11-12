/**
 * Created by andy on 10/20/17.
 */
package additional.pets {
import build.petHouse.PetHouse;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import data.StructureDataPet;
import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;
import manager.Vars;

import server.ManagerPendingRequest;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

import utils.CSprite;
import utils.IsoUtils;
import utils.Point3D;
import utils.SimpleArrow;
import utils.TimeUtils;
import utils.Utils;

public class PetMain {
    protected var g:Vars = Vars.getInstance();
    protected var _source:Sprite;
    protected var _petImage:Sprite;
    protected var _petBackImage:Sprite;
    protected var _petData:StructureDataPet;
    protected var _petHouse:PetHouse;
    protected var _armature:Armature;
    protected var _armatureBack:Armature;
    protected var _arrow:SimpleArrow;
    protected var _currentPath:Array;
    protected var _depth:Number = 0;
    protected var _posX:int = 0;
    protected var _posY:int = 0;
    protected var _isBack:Boolean;
    protected var _callbackOnEndWalk:Function;
    protected var _dbId:int;
    protected var _timeEat:int;
    protected var _timeLeft:int; // to generate product
    protected var _state:int;
    protected var _hasNewEat:Boolean;
    public var walkCallback:Function;
    public var walkCallbackParams:Array;

    public function PetMain(d:StructureDataPet) {
        _petData = d;
        _isBack = false;
        _hasNewEat = false;
        _source = new Sprite();
        _petImage = new Sprite();
        _petBackImage = new Sprite();
        _source.addChild(_petImage);
        _source.addChild(_petBackImage);
        _petImage.visible = false;
        _petBackImage.visible = false;
        if (g.allData.factory[_petData.url]) createArmature();
            else  g.loadAnimation.load('animations_json/x1/' + _petData.url, _petData.url, createArmature);
    }

    private function createArmature():void {
        _armature = g.allData.factory[_petData.url].buildArmature(_petData.image);
        _armatureBack = g.allData.factory[_petData.url].buildArmature(_petData.image + "_back");
        _petImage.addChild(_armature.display as StarlingArmatureDisplay);
        _petBackImage.addChild(_armatureBack.display as StarlingArmatureDisplay);
        if (g.allData.atlas['customisationPetsAtlas']) releaseTexture();
            else g.load.loadAtlas('x1/customisationPetsAtlas', 'customisationPetsAtlas', releaseTexture);
    }

    public function goPetToXYPoint(p:Point, time:int, callbackOnWalking:Function):void {
        new TweenMax(_source, time, {
            x: p.x,
            y: p.y,
            ease: Linear.easeNone,
            onComplete: onGotPetToXYPoint,
            onCompleteParams: [callbackOnWalking]
        });
    }

    private function onGotPetToXYPoint(f:Function):void {
        if (f != null) {
            f.apply(null, [this]);
        }
    }

    public function get depth():Number {
        var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));
        point3d.x += g.matrixGrid.FACTOR / 2;
        point3d.z += g.matrixGrid.FACTOR / 2;
        _depth = point3d.x + point3d.z;
        return _depth;
    }

    public function flipIt(v:Boolean):void {
        if (v) {
            _petImage.scaleX = -1;
            _petBackImage.scaleX = 1;
        } else {
            _petImage.scaleX = 1;
            _petBackImage.scaleX = -1;
        }
    }

    public function get petData():StructureDataPet { return _petData; }
    public function get posX():int { return _posX; }
    public function get posY():int { return _posY; }
    public function set posX(a:int):void { _posX = a; }
    public function set posY(a:int):void { _posY = a; }
    public function get source():Sprite { return _source; }
    public function get armature():Armature { return _armature; }
//    public function get hitArea():OwnHitArea { return _hitArea; }
    public function set petHouse(h:PetHouse):void { _petHouse = h; }
    public function get petHouse():PetHouse { return _petHouse; }
    public function get dbId():int { return _dbId; }
    public function set dbId(dId:int):void { _dbId = dId; }
    public function get timeEat():int { return _timeEat; }
    public function get timeLeft():int { return _timeLeft; }
    public function set timeLeft(t:int):void { _timeLeft = t; }
    public function get state():int { return _state; }
    public function set state(s:int):void { _state = s; }
    public function get hasNewEat():Boolean { return _hasNewEat; }
    public function set hasNewEat(v:Boolean):void { _hasNewEat = v; }

    public function onGetCraft():void {
        if (_hasNewEat) {
            _state = ManagerPets.STATE_RAW_WALK;
            _hasNewEat = false;
            _timeLeft = _petData.buildTime;
            _timeEat = TimeUtils.currentSeconds;
            _petHouse.getMiskaForPet(this).showEat(false);
        } else {
            _state = ManagerPets.STATE_HUNGRY_WALK;
            _timeEat = 0;
            _timeLeft = 0;
        }
    }

    public function analyzeTimeEat(t:int):void {
        _timeEat = t;
        if (t > 0) {
            _timeLeft = _timeEat + _petData.buildTime - TimeUtils.currentSeconds;
            if (_timeLeft < 0) {
                _timeLeft = 0;
                _state = ManagerPets.STATE_WAIT_CRAFT_STOP_RUN;
                _petHouse.onPetCraftReady(this);
                _petHouse.getMiskaForPet(this).showEat(_hasNewEat);
            } else {
                _state = ManagerPets.STATE_RAW_WALK;
                g.managerPets.addPetToTimer(this);
                _petHouse.getMiskaForPet(this).showEat(_hasNewEat);
            }
        } else {
            _state = ManagerPets.STATE_HUNGRY_WALK;
            _timeLeft = 0;
            _timeEat = 0;
        }
    }

    public function updateTimeLeft():void {
        _timeLeft--;
        if (_timeLeft <= 0) {
            g.managerPets.onPetCraftReady(this);
            _state = ManagerPets.STATE_WAIT_CRAFT_STOP_RUN;
        }
    }

    public function goWithPath(arr:Array, callbackOn:Function):void {
        _currentPath = arr;
        _callbackOnEndWalk = callbackOn;
        if (_currentPath.length > 1) {
            _currentPath.shift(); // first element is that point, where we are now
            gotoPoint(_currentPath.shift(), _callbackOnEndWalk);
        } else {
            if (_currentPath.length) {
                gotoPoint(_currentPath.shift(), _callbackOnEndWalk);
            } else {
                if (_callbackOnEndWalk != null) {
                    _callbackOnEndWalk.apply();
                    _callbackOnEndWalk = null;
                }
            }
        }
    }

    protected function gotoPoint(p:Point, callback:Function):void {
        var koef:Number = 1;
        var pXY:Point = g.matrixGrid.getXYFromIndex(p);
        var isBack:Boolean = _isBack;
        var f1:Function = function (callback:Function):void {
            _posX = p.x;
            _posY = p.y;
            g.townArea.zSort();
            if (_currentPath.length) gotoPoint(_currentPath.shift(), callback);
            else {
                stopAnimation();
                if (callback != null) {
                    callback.apply();
                    callback = null;
                }
            }
        };

        if (Math.abs(_posX - p.x) + Math.abs(_posY - p.y) == 2) koef = 1.4;
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
        } else Cc.error('Pet gotoPoint:: wrong front-back logic');
        if (isBack != _isBack) walkAnimation();
        new TweenMax(_source, koef/4, { x: pXY.x, y: pXY.y, ease: Linear.easeNone, onComplete: f1, onCompleteParams: [callback]});
    }

    public function showArrow(t:Number = 0):void {
        hideArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
        _arrow.animateAtPosition(0, -30);
        if (t > 0) _arrow.activateTimer(t, hideArrow);
    }

    public function hideArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    protected function releaseTexture():void {
        // main part of this is in override functions
        _petImage.visible = false;
        _petBackImage.visible = false;
        g.managerPets.chooseRandomAct(this);
    }

    protected function changeTexture(oldName:String, newName:String, arma:Armature):void {
        return; // temp

        var im:Image = new Image(g.allData.atlas['customisationPetsAtlas'].getTexture(newName));
        var b:Slot = arma.getSlot(oldName);
        if (b && im) {
            b.displayList = null;
            b.display = im;
        }
    }

    public function showFront(v:Boolean):void {
        if (v) {
            _isBack = false;
            _petImage.visible = true;
            if (!WorldClock.clock.contains(_armature)) WorldClock.clock.add(_armature);
            _petBackImage.visible = false;
            if (WorldClock.clock.contains(_armatureBack)) WorldClock.clock.remove(_armatureBack);
        } else {
            _isBack = true;
            _petBackImage.visible = true;
            if (!WorldClock.clock.contains(_armatureBack)) WorldClock.clock.add(_armatureBack);
            _petImage.visible = false;
            if (WorldClock.clock.contains(_armature)) WorldClock.clock.remove(_armature);
        }
    }

    /////////////       ANIMATIONS
    /// idle01 - front run, idle02, idle03, idle04 - play; idle01 - back run
    
    public function walkAnimation():void {
        if (!_armature) return;
        if (!_isBack) _armature.animation.gotoAndPlayByFrame('Idle01');
            else _armatureBack.animation.gotoAndPlayByFrame('Idle01');
    }

    public function playPlayAnimation(callback:Function):void {  // callback == null  ===  loop == 1000000000
        if (!_armature) return;
        var n:int = int(Math.random()*3);
        var label:String;
        var pet:PetMain = this;
        switch (n) {
            case 0: label = 'Idle02'; break;
            case 1: label = 'Idle03'; break;
            case 2: label = 'Idle04'; break;
        }
        var fEnd:Function = function(e:Event=null):void {
            _armature.removeEventListener(EventObject.COMPLETE, fEnd);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEnd);
            stopAnimation();
            if (callback != null) callback.apply(null, [pet]);
                else playPlayAnimation(null);
            callback = null;
        };
        _armature.addEventListener(EventObject.COMPLETE, fEnd);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, fEnd);

//        _armature.animation.gotoAndPlayByFrame(label);  // - >> smth wrong with animation
        Utils.createDelay(4, function():void { fEnd(null); } );  // temp fix
    }

    public function stopAnimation():void {
        if (!_armature) return;
        _armature.animation.gotoAndStopByFrame('Idle01');
        _armatureBack.animation.gotoAndStopByFrame('Idle01');
    }
    
}
}
