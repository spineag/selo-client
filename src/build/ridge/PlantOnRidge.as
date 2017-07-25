/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.starling.StarlingArmatureDisplay;

import manager.Vars;
import mouse.ToolsModifier;
import starling.display.Sprite;

public class PlantOnRidge {
    private var _source:Sprite;
    private var _ridge:Ridge;
    private var _data:Object;
    public var _timeToEndState:int;
    public var idFromServer:String; // в табличке user_plant_ridge
    private var armature:Armature;
//    private var particles:PlantParticle;
    private var _timerAnimationGrowed:int;
    public var isHover:Boolean;
    private var g:Vars = Vars.getInstance();
    private var _dataTime:Object;

    public function PlantOnRidge(ridge:Ridge, data:Object) {
        if (!data) {
            Cc.error('no data for PlantOnRidge');
            ridge.onOut();
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            return;
        }
        _dataTime ={};
        _ridge = ridge;
        _data = data;
        isHover = false;
        _source = new Sprite();
        _ridge.addChildPlant(_source);
        armature = g.allData.factory[_data.url].buildArmature(_data.imageShop);
        _source.addChild(armature.display as StarlingArmatureDisplay);
        WorldClock.clock.add(armature);
        _source.y = 35 * g.scaleFactor;
        _dataTime.timeToGrow2 = _dataTime.timeToGrow3 = int(_data.buildTime/3);
        _dataTime.timeToStateGwoned = _data.buildTime -  _dataTime.timeToGrow2 -  _dataTime.timeToGrow3;
    }

    public function get dataPlant():Object {
        return _data;
    }

    public function activateRender():void {
        g.gameDispatcher.addToTimer(render);
    }

    public function checkStateRidge(needSetTimer:Boolean = true):void {
        switch (_ridge.stateRidge) {
            case Ridge.EMPTY:
                _ridge.checkBuildRect(true);
                while (_source.numChildren) {
                    _source.removeChildAt(0);
                }
                return;

            case Ridge.GROW1:
                armature.animation.gotoAndStopByFrame("state1");
                _ridge.checkBuildRect(false);
                if (needSetTimer) _timeToEndState = _dataTime.timeToGrow2;
                break;
            case Ridge.GROW2:
                armature.animation.gotoAndStopByFrame("state2");
                _ridge.checkBuildRect(false);
                if (needSetTimer) _timeToEndState = _dataTime.timeToGrow3;
                break;
            case Ridge.GROW3:
                armature.animation.gotoAndStopByFrame("state3");
                _ridge.checkBuildRect(false);
                if (needSetTimer) _timeToEndState = _dataTime.timeToStateGwoned;
                break;
            case Ridge.GROWED:
                armature.animation.gotoAndStopByFrame("state4");
                _ridge.checkBuildRect(false);
//                animateEndState(); !!!
//                addParticles();
                growedAnimation();
                break;
        }
    }
    private function growedAnimation():void {
        _timerAnimationGrowed = 7*Math.random();
        g.gameDispatcher.addToTimer(timerAnimation);
    }

    private function timerAnimation():void {
        _timerAnimationGrowed --;
        if (_timerAnimationGrowed <=0) {
            if (armature == null) return;
            armature.animation.gotoAndPlayByFrame('state4',0);
            g.gameDispatcher.removeFromTimer(timerAnimation);
            growedAnimation();
        }
    }

    public function render():void {
        _timeToEndState--;
        if (_timeToEndState <=0) {
            _ridge.stateRidge = _ridge.stateRidge + 1;
            checkStateRidge();
            if (_ridge.stateRidge == Ridge.GROWED) {
                g.gameDispatcher.removeFromTimer(render);
            }
        }
    }

    public function renderSkip():void {
        g.gameDispatcher.removeFromTimer(render);
        _ridge.stateRidge = Ridge.GROWED;
        checkStateRidge();
    }

    public function getTimeToGrowed():int {
        var n:int;
      switch  (_ridge.stateRidge) {
            case Ridge.GROW1:
                n = _timeToEndState + _dataTime.timeToGrow3 + _dataTime.timeToStateGwoned;
                break;
            case Ridge.GROW2:
                n = _timeToEndState + _dataTime.timeToStateGwoned;
                break;
            case Ridge.GROW3:
                n = _timeToEndState;
                break;
        }
        return n;
    }

    public function checkTimeGrowing(timeWork:int):void {
        if (_data.buildTime - timeWork < _dataTime.timeToStateGwoned) {
            _timeToEndState = _data.buildTime - timeWork;
            _ridge.stateRidge = Ridge.GROW3;
        } else if (timeWork < _dataTime.timeToGrow2) {
            _timeToEndState = _dataTime.timeToGrow2 - timeWork;
            _ridge.stateRidge = Ridge.GROW1;
        } else if (timeWork > _data.buildTime) {
            _timeToEndState = 0;
            _ridge.stateRidge = Ridge.GROWED;
        } else {
            _timeToEndState = _dataTime.timeToGrow3 - (timeWork - _dataTime.timeToGrow2);
            _ridge.stateRidge = Ridge.GROW2;
        }
    }

    public function clearIt():void {
        _ridge = null;
        _data = null;
        TweenMax.killTweensOf(_source);
        WorldClock.clock.remove(armature);
        armature.dispose();
        armature = null;
        g.gameDispatcher.removeFromTimer(render);
        while (_source.numChildren) _source.removeChildAt(0);
        _source = null;
    }

    private function animateEndState():void {
        var fToLeft:Function = function (d:Number = 0):void {
            TweenMax.to(_source, 2, {rotation:-Math.PI/100, ease:Linear.easeIn, onComplete: fToRight, delay:d});
        };
        var fToRight:Function = function ():void {
            TweenMax.to(_source, 2, {rotation:Math.PI/100, ease:Linear.easeIn, onComplete: fToLeft});
        };
        fToLeft(5*Math.random());
    }

//    private function addParticles():void {
//        particles = new PlantParticle(_source.height);
//        _source.addChildAt(particles.source, 0);
//    }

    public function onCraftPlant():void {
        TweenMax.killTweensOf(_source);
        _source.rotation = 0;
//        _source.removeChild(particles.source);
        _timerAnimationGrowed = 0;
        g.gameDispatcher.removeFromTimer(timerAnimation);
//        particles.clearIt();
//        particles = null;
    }

    public function hoverGrowed():void {
        armature.animation.gotoAndPlayByFrame('state4',0);
    }
}
}
