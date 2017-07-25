/**
 * Created by user on 9/23/15.
 */
package heroes {
import build.TownAreaBuildSprite;
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import flash.geom.Point;
import manager.Vars;
import utils.CSprite;
import utils.IsoUtils;
import utils.Point3D;

public class BasicCat {
    public static const MAN:int = 1;
    public static const WOMAN:int = 2;

    public static const WALK:int = 1;
    public static const WALK_IDLE:int = 2;
    public static const RUN:int = 3;
    public static const STOP:int = 4;

    protected var _posX:int;
    protected var _posY:int;
    protected var _depth:Number;
    protected var _source:TownAreaBuildSprite;
    protected var _speedWalk:int = 1;
    protected var _speedIdleWalk:int = 1;
    protected var _speedRun:int = 8;
    protected var _curSpeed:int;
    protected var _currentPath:Array;
    protected var _curTypeMoving:int;
    protected var _name:String;
    protected var g:Vars = Vars.getInstance();
    public var isOnMap:Boolean = false;
    public var walkCallback:Function;
    public var walkCallbackParams:Array;
    protected var _callbackOnWalking:Function;
    public var isAwayCat:Boolean = false; // for test

    public function BasicCat() {
        _name = 'Cat_'+String(int(Math.random()*10000));
    }

    public function setPosition(p:Point):void {
        _posX = p.x;
        _posY = p.y;
    }

    public function updatePosition():void {
        var p:Point = new Point(_posX, _posY);
        p = g.matrixGrid.getXYFromIndex(p);
        _source.x = p.x;
        _source.y = p.y;
    }

    public function addToMap():void {
        isOnMap = true;
        if (g.isAway) {
            g.townArea.addAwayHero(this);
        } else {
            g.townArea.addHero(this);
        }
    }

    public function removeFromMap():void {
        isOnMap = false;
        if (g.isAway) {
            g.townArea.removeAwayHero(this);
        } else {
            g.townArea.removeHero(this);
        }
    }

    public function get depth():Number {
        updateDepth();
        return _depth;
    }

    public function updateDepth():void {
        var point3d:Point3D = IsoUtils.screenToIso(new Point(_source.x, _source.y));
        point3d.x += g.matrixGrid.FACTOR/2;
        point3d.z += g.matrixGrid.FACTOR/2;
        _depth = point3d.x + point3d.z;
    }

    public function get posX():int {
        return _posX;
    }

    public function get posY():int {
        return _posY;
    }

    public function get source():TownAreaBuildSprite {
        return _source;
    }

    public function set visible(value:Boolean):void {
        if (value) {
            isOnMap = true;
            g.townArea.addHero(this);
        } else {
            isOnMap = false;
            g.townArea.removeHero(this);
        }
    }

    public function get visible():Boolean {
        return isOnMap;
    }

    public function walkAnimation():void {
        _curSpeed = _speedWalk;
        _curTypeMoving = WALK;
    }
    public function walkIdleAnimation():void {
        _curSpeed = _speedIdleWalk;
        _curTypeMoving = WALK_IDLE;
    }
    public function runAnimation():void {
        _curSpeed = _speedRun;
        _curTypeMoving = RUN;
    }
    public function stopAnimation():void {
        _curSpeed = 0;
        _curTypeMoving = STOP;
    }
    public function idleAnimation():void {}
    public function sleepAnimation():void {}
    public function goWithPath(arr:Array, callbackOnWalking:Function):void {
        _currentPath = arr;
        _callbackOnWalking = callbackOnWalking;
        if (_currentPath.length > 1) {
            _currentPath.shift(); // first element is that point, where we are now
            gotoPoint(_currentPath.shift(), _callbackOnWalking);
        } else {
            if (_currentPath.length) {
                gotoPoint(_currentPath.shift(), _callbackOnWalking);
            } else {
                if (_callbackOnWalking != null) {
                    _callbackOnWalking.apply();
                    _callbackOnWalking = null;
                }
            }
        }
    }
    
    public function get currentPath():Array {
        return _currentPath;
    }

    public function get endPathPoint():Point {
        if (_currentPath.length) {
            return _currentPath[_currentPath.length-1];
        } else {
            return new Point(posX, posY);
        }
    }
    
    public function showFront(v:Boolean):void {}
    public function flipIt(v:Boolean):void {}

    protected function gotoPoint(p:Point, callbackOnWalking:Function):void {
        if (_curSpeed <= 0) return;
        var koef:Number = 1;
        var pXY:Point = g.matrixGrid.getXYFromIndex(p);
        var f1:Function = function(callbackOnWalking:Function):void {
            _posX = p.x;
            _posY = p.y;
            if (g.isAway)
                g.townArea.zAwaySort();
            else
                g.townArea.zSort();

            if (_currentPath.length) {
                gotoPoint(_currentPath.shift(), callbackOnWalking);
            } else {
                idleAnimation();
                if (callbackOnWalking != null) {
                    callbackOnWalking.apply();
                    callbackOnWalking = null;
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
            Cc.error('BasicCat gotoPoint:: wrong front-back logic');
        }
//        checkForJump(p);
        new TweenMax(_source, koef/_curSpeed, {x:pXY.x, y:pXY.y, ease:Linear.easeNone ,onComplete: f1, onCompleteParams: [callbackOnWalking]});
    }

    public function goCatToXYPoint(p:Point, time:int, callbackOnWalking:Function):void {
        new TweenMax(_source, time, {x:p.x, y:p.y, ease:Linear.easeNone, onComplete: onGotCatToXYPoint, onCompleteParams:[callbackOnWalking]});
    }

    private function onGotCatToXYPoint(f:Function) :void {
        if (f != null) {
            f.apply(null, [this]);
        }
    }

    private function checkForJump(nextPoint:Point):void {

    }


    public function deleteIt():void {
        while (_source.numChildren) _source.removeChildAt(0);
        _currentPath = [];
        _source = null;
    }
}
}
