/**
 * Created by user on 9/23/15.
 */
package heroes {
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.farm.Farm;
import build.ridge.Ridge;

import com.greensock.TweenMax;

import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import manager.AStar.AStar;
import manager.Vars;
import manager.ownError.ErrorConst;

import order.DataOrderCat;

import utils.Utils;
import windows.WindowsManager;

public class ManagerQuestCats {
    protected var _townMatrix:Array;
    private var _matrixLength:int;
    protected var _townAwayMatrix:Array;
    private var _catsArray:Array;
    private var _catsAwayArray:Array;
    private var _catInfo:Object;
    private var _catMoveAway:QuestHero;
    private var _bCheckNeedNewShow:Boolean;

    private var g:Vars = Vars.getInstance();

    public function ManagerQuestCats() {
        _bCheckNeedNewShow = false;
        _townMatrix = g.townArea.townMatrix;
        _matrixLength = g.matrixGrid.getLengthMatrix();
        _catsArray = [];
        _catInfo = new Object();
        _catInfo.name = String(g.managerLanguage.allTexts[602]);
        _catInfo.url = 'cat';
        _catInfo.image = 'cat';
        _catInfo.image2 = 'cat_woman';
        _catInfo.cost = 0;
        _catInfo.currency = DataMoney.SOFT_CURRENCY;
        _catInfo.buildType = BuildType.CAT;
    }

    public function addAllHeroCats(cats:int, isNew:Boolean = false):void {
        addHeroCat(cats, isNew);
    }

    public function get catsArray():Array { return _catsArray;}

    private function addHeroCat(type:int, isNew:Boolean = false):void {
        var cat:QuestHero = new QuestHero(type);
        _catsArray.push(cat);
        setAllCatsToRandomPositionsAtStartGame(cat, isNew);
    }

    public function onGoAway(v:Boolean):void {
        for (var i:int=0; i<_catsArray.length; i++) {
            (_catsArray[i] as QuestHero).pauseIt(v);
        }
        g.managerAnimal.onGoAwayCats(v);
        g.managerFabricaRecipe.onGoAwayCats();
    }

    public function setAllCatsToRandomPositionsAtStartGame(cat:QuestHero, isNew:Boolean = false):void {
        if (!isNew) {
//            for (var i:int = 0; i < _catsArray.length; i++) {
                (cat as BasicCat).setPosition(g.townArea.getRandomFreeCell());
                (cat as BasicCat).addToMap();
                (cat as QuestHero).makeFreeCatIdle();
//            }
        } else {
            (cat as BasicCat).addToMap();
            (cat as BasicCat).setPosition(new Point(80, 0));
            (cat as QuestHero).makeFreeCatIdle();
            if (g.miniScenes.oCat.checkNeedNewShow(cat.idMan)) {
                g.miniScenes.oCat.showCat1();
                g.miniScenes.oCat.setCurrentCatObject = DataOrderCat.getCatObjById(cat.idMan);
                _bCheckNeedNewShow = true;
            }
            newCatArrived1();
        }
    }

    private function newCatArrived1():void {
        goCatToPoint(_catsArray[_catsArray.length-1] as BasicCat, new Point(32, 0), newCatArrived2);
    }

    private function newCatArrived2():void {
        goCatToPoint(_catsArray[_catsArray.length-1] as BasicCat, new Point(32, 26), newCatArrived3);
    }

    private function newCatArrived3():void {
        if (_bCheckNeedNewShow) {
            _bCheckNeedNewShow = false;
            g.miniScenes.oCat.onArriveToOrder();
        }
        (_catsArray[_catsArray.length - 1] as QuestHero).killAllAnimations();
        (_catsArray[_catsArray.length - 1] as QuestHero).makeFreeCatIdle();
    }

    public function goCatToPoint(cat:BasicCat, p:Point, callback:Function = null, ...callbackParams):void {
        var f2:Function = function ():void {
            cat.flipIt(false);
            cat.showFront(true);
            var fT:Function = cat.walkCallback;
            var arrT:Array = cat.walkCallbackParams;
            cat.walkCallback = null;
            cat.walkCallbackParams = [];
            if (fT != null) {
                fT.apply(null, arrT);
            }
        };

        var f1:Function = function (arr:Array):void {
            try {
                cat.showFront(true);
                if (arr.length > 5) {
                    cat.runAnimation();
                } else {
                    cat.walkAnimation()
                }
                cat.goWithPath(arr, f2);
            } catch (e:Error) {
                Cc.error('ManagerCats goCatToPoint f1 error: ' + e.errorID + ' - ' + e.message);
                Cc.stackch('error', 'ManagerCats goCatToPoint f1', 10);
                g.errorManager.onGetError(ErrorConst.ManagerCats1, true);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerCats goCat1');
            }
        };

        try {
            if (!cat) {
                Cc.error('ManagerCats goCatToPoint error: cat == null');
                g.errorManager.onGetError(ErrorConst.ManagerCats2, true);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerCats goCatToPoint cat == null');
                return;
            }
            if (cat is QuestHero) (cat as QuestHero).killAllAnimations();
            if (cat.posX == p.x && cat.posY == p.y) {
                cat.flipIt(false);
                cat.showFront(true);
//                cat.idleAnimation();
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
                return;
            }
            cat.walkCallback = callback;
            cat.walkCallbackParams = callbackParams;
            var a:AStar = new AStar();
            a.getPath(cat.posX, cat.posY, p.x, p.y, f1);
        } catch (e:Error) {
            Cc.error('ManagerCats goCatToPoint error: ' + e.errorID + ' - ' + e.message);
            Cc.stackch('error', 'ManagerCats goCatToPoint', 10);
            g.errorManager.onGetError(ErrorConst.ManagerCats3, true);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerCats goCatToPoint');
        }
    }

    public function goIdleCatToPoint(cat:BasicCat, p:Point, callback:Function = null, ...callbackParams):void {
        try {
            if (cat.posX == p.x && cat.posY == p.y) {
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
                return;
            }

            var f2:Function = function ():void {
                cat.flipIt(false);
                cat.showFront(true);
                cat.idleAnimation();
                var fT:Function = cat.walkCallback;
                var arrT:Array = cat.walkCallbackParams;
                cat.walkCallback = null;
                cat.walkCallbackParams = [];
                if (fT != null) {
                    fT.apply(null, arrT);
                }
            };
            var f1:Function = function (arr:Array):void {
                cat.walkIdleAnimation();
                cat.goWithPath(arr, f2);
            };
            cat.walkCallback = callback;
            cat.walkCallbackParams = callbackParams;
            var a:AStar = new AStar();
            a.getPath(cat.posX, cat.posY, p.x, p.y, f1);
        } catch (e:Error) {
            Cc.error('ManagerCats goIdleCatToPoint error: ' + e.errorID + ' - ' + e.message);
            Cc.stackch('error', 'ManagerCats goIdleCatToPoint', 10);
            g.errorManager.onGetError(ErrorConst.ManagerCats4, true);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerCats goIdleCatToPoint');
        }
    }

    public function goCatToXYPoint(cat:QuestHero,p:Point, time:int, callbackOnWalking:Function, delay:int):void {
        new TweenMax(cat.source, time, {x:p.x, y:p.y, ease:Linear.easeNone, onComplete: f2, delay: delay, onCompleteParams:[callbackOnWalking]});
    }

    private function f2(f:Function) :void {
        if (f != null) {
            f.apply(null);
        }
    }

    public function get isFreeCat():Boolean {
        for (var i:int=0; i<_catsArray.length; i++) {
            if ((_catsArray[i] as QuestHero).isFree && (_catsArray[i] as QuestHero).isFree) {
                return true;
            }
        }
        return false;
    }

    public function makeAwayCats():void {
        _townAwayMatrix = g.townArea.townAwayMatrix;
        _catsAwayArray = [];
        var cat:QuestHero;
        cat = new QuestHero(1);
        _catsAwayArray.push(cat);
        cat.setPosition(g.townArea.getRandomFreeCell());
        cat.addToMap();
        cat.makeFreeCatIdle();
        cat.isAwayCat = true;

        cat = new QuestHero(2);
        _catsAwayArray.push(cat);
        cat.setPosition(g.townArea.getRandomFreeCell());
        cat.addToMap();
        cat.makeFreeCatIdle();
        cat.isAwayCat = true;
    }

    public function removeAwayCats():void {
        if (!_catsAwayArray.length) return;
        for (var i:int=0; i<2; i++) {
            (_catsAwayArray[i] as QuestHero).deleteIt();
        }
        _catsAwayArray = [];
    }

    public function checkAllCatsAfterPasteBuilding(buildPosX:int, buildPosY:int, buildWidth:int, buildHeight:int):void {
        // check if any cat is under new building (or after removing) or his way is under building
        for (var i:int=0; i<_catsArray.length; i++) {
            if (_catsArray[i] && _catsArray[i] is QuestHero && (_catsArray[i] as QuestHero).visible) {  // means that cat is not on any fabrica
                checkCatAfterPasteBuilding(_catsArray[i] as QuestHero, buildPosX, buildPosY, buildWidth, buildHeight);
            }
        }
    }

    private function checkCatAfterPasteBuilding(cat:QuestHero, buildPosX:int, buildPosY:int, buildWidth:int, buildHeight:int):void {
        if (g.isAway) return;
        if (cat.isFree) {
            if (cat.isIdleGoNow) { // mean cat is walking now
                if (isCrossedPathAndSquare(cat.currentPath, buildPosX, buildPosY, buildWidth, buildHeight)) {
                    cat.killAllAnimations();
                    if (cat.posX > buildPosX && cat.posX < buildPosX + buildWidth && cat.posY > buildPosY && cat.posY < buildPosY + buildHeight) {
                        var afterRunFree:Function = function (_cat:QuestHero):void {
                            _cat.makeFreeCatIdle();
                        };
                        forceRunToXYPoint(cat, buildPosX + buildWidth + 1, buildPosY + 1, afterRunFree);
                    } else cat.makeFreeCatIdle();
                }
            } else {
                if (cat.posX > buildPosX && cat.posX < buildPosX + buildWidth && cat.posY > buildPosY && cat.posY < buildPosY + buildHeight) {
                    var afterRunFree2:Function = function (_cat:QuestHero):void {
                        _cat.makeFreeCatIdle();
                    };
                    cat.killAllAnimations();
                    forceRunToXYPoint(cat, buildPosX + buildWidth, buildPosY, afterRunFree2);
                }
            }
        } else {
            var endPoint:Point = cat.endPathPoint;
            if (cat.posX > buildPosX && cat.posX < buildPosX+buildWidth && cat.posY > buildPosY && cat.posY < buildPosY+buildHeight) {
                var afterRun:Function = function (_cat:QuestHero):void {
                    goCatToPoint.apply(null, [_cat, endPoint, _cat.walkCallback].concat(_cat.walkCallbackParams));
                };
                cat.killAllAnimations();
                forceRunToXYPoint(cat, buildPosX+buildWidth + 1, buildPosY + 1, afterRun);
            } else if (isCrossedPathAndSquare(cat.currentPath, buildPosX, buildPosY, buildWidth, buildHeight)) {
                cat.killAllAnimations();
                goCatToPoint.apply(null, [cat, endPoint, cat.walkCallback].concat(cat.walkCallbackParams));
            }
        }
    }

    private function isCrossedPathAndSquare(path:Array, buildPosX:int, buildPosY:int, buildWidth:int, buildHeight:int):Boolean {
        var isCrossed:Boolean = false;
        if (!path || !path.length) return false;
        var p:Point;
        for (var i:int=0; i<path.length; i++) {
            p = path[i];
            if (p.x > buildPosX && p.x < buildPosX+buildWidth && p.y > buildPosY && p.y < buildPosY+buildHeight) {
                isCrossed = true;
                break;
            }
        }
        return isCrossed;
    }

    private function forceRunToXYPoint(cat:QuestHero, posX:int, posY:int, callback:Function):void {
        cat.runAnimation();
        var p:Point = new Point(posX, posY);
        p = g.matrixGrid.getXYFromIndex(p);
        cat.goCatToXYPoint(p, 1, callback);
    }

    public function getCatAway(catId:int):void {
        for (var i:int = 0; i < _catsArray.length; i++) {
            if (_catsArray[i].idMan == catId) {
                _catMoveAway = _catsArray[i];
                _catsArray.removeAt(i);
                break;
            }
        }
        goCatToPoint(_catMoveAway,new Point(48, 0),away1);
    }

    private function away1():void {
        _catMoveAway.flipIt(true);
        goCatToXYPoint(_catMoveAway, new Point(3600*g.scaleFactor, 1760*g.scaleFactor), 8, away2, 0);
    }

    private function away2():void {
        if (!_catMoveAway) return;
        _catMoveAway.deleteIt();
        _catMoveAway = null;
    }
}
}
