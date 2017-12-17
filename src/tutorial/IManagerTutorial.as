package tutorial {
import analytic.AnalyticManager;
import build.WorldObject;
import build.tutorialPlace.TutorialPlace;
import com.junkbyte.console.Cc;

import heroes.HeroCat;
import heroes.TutorialCat;
import manager.Vars;
import particle.tuts.DustRectangle;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import utils.SimpleArrow;

public class IManagerTutorial {
    protected var TUTORIAL_ON:Boolean = true;
    protected const MAX_STEPS:uint = 100;
    protected var g:Vars = Vars.getInstance();
    protected var cutScene:CutScene;
    protected var _subStep:int;
    protected var texts:Object;
    protected var black:Sprite;
    protected var blackUnderInterface:Sprite;
    protected var _tutorialObjects:Array;
    protected var _action:int;
    protected var _tutorialResourceIDs:Array;
    protected var _dustRectangle:DustRectangle;
    protected var _tutorialCallback:Function;
    protected var _onShowWindowCallback:Function;
    protected var _arrow:SimpleArrow;
    protected var _cat:HeroCat;

    public function IManagerTutorial() {
        _tutorialObjects = [];
        _action = TutsAction.NONE;
        _tutorialResourceIDs = [];
    }

    public function checkTutsCallback():void {
        if (_tutorialCallback != null) {
            _tutorialCallback.apply();
        }
    }

    public function checkTutsCallbackOnShowWindow():void {
        if (_onShowWindowCallback != null) {
            _onShowWindowCallback.apply();
        }
    }

    public function onGameStart():void { initScenes(); }
    protected function initScenes():void {}
    public function get action():int { return _action; }
    public function currentActionNone():void { _action = TutsAction.NONE; }
    public function get subStep():int { return _subStep; }
    public function isTutsResource(id:int):Boolean { return _tutorialResourceIDs.indexOf(id) > -1; }
    public function get isTuts():Boolean { return TUTORIAL_ON && g.user.tutorialStep < MAX_STEPS; }
    public function checkDefaults():void {}
    public function onResize():void {}
    public function isTutsBuilding(wo:WorldObject):Boolean { return _tutorialObjects.indexOf(wo) > -1; }
    public function addTutsWorldObject(w:WorldObject):void {_tutorialObjects.push(w); }
    protected function emptyFunction(...params):void {}
    protected function clearAll():void { }

    protected function deleteCutScene():void {
        if (cutScene) {
            cutScene.deleteIt();
            cutScene = null;
        }
    }

    protected function addBlack():void {
        if (!black) {
            var q:Quad = new Quad(g.managerResize.stageWidth, g.managerResize.stageHeight, Color.BLACK);
            black = new Sprite();
            black.addChild(q);
            black.alpha = .6;
            g.cont.popupCont.addChildAt(black, 0);
        }
    }

    protected function addBlackUnderInterface():void {
        if (!blackUnderInterface) {
            var q:Quad = new Quad(g.managerResize.stageWidth, g.managerResize.stageHeight, Color.BLACK);
            blackUnderInterface = new Sprite();
            blackUnderInterface.addChild(q);
            blackUnderInterface.alpha = .6;
            g.cont.hintGameCont.addChildAt(blackUnderInterface, 0);
        }
    }

    protected function removeBlack():void {
        if (black) {
            if (g.cont.popupCont.contains(black)) g.cont.popupCont.removeChild(black);
            black.dispose();
            black = null;
        }
        if (blackUnderInterface) {
            if (g.cont.hintGameCont.contains(blackUnderInterface)) g.cont.hintGameCont.removeChild(blackUnderInterface);
            blackUnderInterface.dispose();
            blackUnderInterface = null;
        }
    }

    protected function updateTutorialStep():void {
        Cc.info('update tutorial step: ' + g.user.tutorialStep);
        g.server.updateUserTutorialStep(null);
        if (g.analyticManager)
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.ACTION_TUTORIAL, {id:g.user.tutorialStep});
    }

    protected function deleteArrowAndDust():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
    }

    protected function finishTutorial():void {
//        if (_cat) _cat.deleteIt();
        g.user.tutorialStep = MAX_STEPS;
        updateTutorialStep();
    }
}
}
