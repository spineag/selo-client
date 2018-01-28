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
import flash.geom.Point;
import manager.Vars;
import starling.display.Sprite;
import utils.IsoUtils;
import utils.Point3D;
import utils.SimpleArrow;
import utils.TimeUtils;

public class PetMain {
    protected var g:Vars = Vars.getInstance();
    protected var _source:Sprite;
    protected var _petData:StructureDataPet;
    protected var _petHouse:PetHouse;
    protected var _animation:AnimationPet;
    protected var _arrow:SimpleArrow;
    protected var _currentPath:Array;
    protected var _depth:Number = 0;
    protected var _posX:int = 0;
    protected var _posY:int = 0;
    protected var _callbackOnEndWalk:Function;
    protected var _dbId:int;
    protected var _timeEat:int;
    protected var _timeLeft:int; // to generate product
    protected var _state:int;
    protected var _hasNewEat:Boolean;
    protected var _innerPosX1:int;
    protected var _innerPosY1:int;
    protected var _innerPosX2:int;
    protected var _innerPosY2:int;
    protected var _innerPosX3:int;
    protected var _innerPosY3:int;
    protected var _positionAtHouse:int;
    public var walkCallback:Function;
    public var walkCallbackParams:Array;

    public function PetMain(d:StructureDataPet) {
        _petData = d;
        _hasNewEat = false;
        _source = new Sprite();
        _animation = new AnimationPet(_source, this);
        if (g.allData.factory[_petData.url]) createArmature();
            else g.loadAnimation.load('animations_json/x1/' + _petData.url, _petData.url, createArmature);
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

    private function createArmature():void { _animation.fillArmatures(_petData); }
    protected function releaseTexture():void {}
    public function get petData():StructureDataPet { return _petData; }
    public function get posX():int { return _posX; }
    public function get posY():int { return _posY; }
    public function set posX(a:int):void { _posX = a; }
    public function set posY(a:int):void { _posY = a; }
    public function get source():Sprite { return _source; }
    public function get armature():Armature { return _animation.armature; }
    public function get animation():AnimationPet { return _animation; }
    public function set petHouse(h:PetHouse):void { _petHouse = h; }
    public function get petHouse():PetHouse { return _petHouse; }
    public function get dbId():int { return _dbId; }
    public function set dbId(dId:int):void { _dbId = dId; }
    public function get timeEat():int { return _timeEat; }
    public function get timeLeft():int { return _timeLeft; }
    public function set timeLeft(t:int):void { _timeLeft = t; }
    public function get state():int { return _state; }
    public function set state(s:int):void { _state = s; }
    public function get currentPath():Array { return _currentPath; } 
    public function get hasNewEat():Boolean { return _hasNewEat; }
    public function set hasNewEat(v:Boolean):void { _hasNewEat = v; }
    public function get innerPosX1():int { return _innerPosX1; }
    public function get innerPosX2():int { return _innerPosX2; }
    public function get innerPosX3():int { return _innerPosX3; }
    public function get innerPosY1():int { return _innerPosY1; }
    public function get innerPosY2():int { return _innerPosY2; }
    public function get innerPosY3():int { return _innerPosY3; }
    public function set positionAtHouse(v:int):void { _positionAtHouse = v; }
    public function get positionAtHouse():int { return _positionAtHouse; }
    public function removePath():void { _currentPath.length = 0; }

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
                _state = ManagerPets.STATE_SLEEP;
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
            _state = ManagerPets.STATE_SLEEP;
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
        var koef:Number = 2;
        var pXY:Point = g.matrixGrid.getXYFromIndex(p);
        var isBack:Boolean = _animation.isBack;
        var f1:Function = function (callback:Function):void {
            _posX = p.x;
            _posY = p.y;
            g.townArea.zSort();
            if (_currentPath.length) gotoPoint(_currentPath.shift(), callback);
            else {
                _animation.stopAnimation();
                if (callback != null) {
                    callback.apply();
                    callback = null;
                }
            }
        };

        if (p.x == _posX + 1) {
            if (p.y == _posY) {
                _animation.showFront(true);
                _animation.flipIt(true);
            } else if (p.y == _posY - 1) {
                _animation.showFront(true);
                _animation.flipIt(true);
            } else if (p.y == _posY + 1) {
                _animation.showFront(true);
                _animation.flipIt(false);
            }
        } else if (p.x == _posX) {
            if (p.y == _posY) {
                _animation.showFront(true);
                _animation.flipIt(false);
            } else if (p.y == _posY - 1) {
                _animation.showFront(false);
                _animation.flipIt(false);
            } else if (p.y == _posY + 1) {
                _animation.showFront(true);
                _animation.flipIt(false);
            }
        } else if (p.x == _posX - 1) {
            if (p.y == _posY) {
                _animation.showFront(false);
                _animation.flipIt(true);
            } else if (p.y == _posY - 1) {
                _animation.showFront(false);
                _animation.flipIt(false);
            } else if (p.y == _posY + 1) {
                _animation.showFront(true);
                _animation.flipIt(false);
            }
        } else Cc.error('Pet gotoPoint:: wrong front-back logic');
        if (isBack != _animation.isBack) {
            if (_animation.isWalking) _animation.walkAnimation();
                else _animation.runAnimation();
        }
        if (_animation.isBack || !_animation.isWalking) koef = .5; // for run
        new TweenMax(_source, koef, { x: pXY.x, y: pXY.y, ease: Linear.easeNone, onComplete: f1, onCompleteParams: [callback]});
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
   
    public function deleteIt():void {
        if (!_source) return;
        _animation.deleteIt();
        _source.dispose();
        _source = null;
    }
    
}
}
