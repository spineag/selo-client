/**
 * Created by user on 9/23/15.
 */
package heroes {
import build.fabrica.Fabrica;
import build.farm.Farm;
import build.ridge.Ridge;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import manager.AStar.AStar;
import manager.Vars;
import manager.ownError.ErrorConst;
import utils.Utils;
import windows.WindowsManager;

public class ManagerCats {
    protected var _townMatrix:Array;
    private var _matrixLength:int;
    protected var _townAwayMatrix:Array;
    private var _catsArray:Array;
    private var _catsAwayArray:Array;
    private var _catInfo:Object;
    private var _arrRidge:Array;
    private var _arrFabrica:Array;
    private var _arrFarm:Array;

    private var g:Vars = Vars.getInstance();

    public function ManagerCats() {
        _arrFabrica = [];
        _arrFarm = [];
        _arrRidge = [];
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

    public function addAllHeroCats():void {
        addHeroCat(1);
        addHeroCat(2);
    }

    private function addHeroCat(type:int):void {
        var cat:HeroCat = new HeroCat(type);
        _catsArray.push(cat);
    }

    public function timerRandomWorkMan():void {
        var delay:int = 30 + int(Math.random()*60);
        Utils.createDelay(delay, function():void {chooseRandomWork(_catsArray[0])});
    }

    public function timerRandomWorkWoman():void {
        var delay:int = 30 + int(Math.random()*60);
        Utils.createDelay(delay,  function():void {chooseRandomWork(_catsArray[1])});
    }

    private function chooseRandomWork(cat:HeroCat):void {
        if (!cat.isFree) return;
        if (cat.isWorkRandom) return;
        var t:int = _arrFabrica.length + _arrFarm.length + _arrRidge.length;
        if (t>0) {
            cat.workRandom = true;
            t = int(t*Math.random());
            if (t < _arrFabrica.length)  cat.activeRandomWorkBuild = _arrFabrica[t];
            else if (t < _arrFabrica.length + _arrFarm.length) cat.activeRandomWorkBuild = _arrFarm[t - _arrFabrica.length];
            else cat.activeRandomWorkBuild = _arrRidge[t - _arrFabrica.length - _arrFarm.length];
            goCatToPoint(cat, new Point(cat.activeRandomWorkBuild.posX, cat.activeRandomWorkBuild.posY), onArrivedForRandomWork, cat);
        }
    }

    private function onArrivedForRandomWork(cat:HeroCat):void {
        if (cat.activeRandomWorkBuild is Farm) cat.onArrivedCatToFarm();
        else if (cat.activeRandomWorkBuild is Ridge) cat.onArrivedCatToRidge();
        else cat.onArrivedCatToFabrica();
    }

    public function arrayCat():void {
        for (var  i:int = 0; i < _catsArray.length; i++) {
            if ((_catsArray[i] as HeroCat).decorAnimation != null) {
                (_catsArray[i] as HeroCat).decorAnimation.forceStopDecorAnimation();
                break;
            }
        }
    }

    public function onStartRidge(r:Ridge):void {
        if (_arrRidge.indexOf(r) > -1) return;
        _arrRidge.push(r);
    }

    public function onFinishRidge(r:Ridge):void {
        if (_arrRidge.indexOf(r) == -1) return;
        _arrRidge.removeAt(_arrRidge.indexOf(r));
    }

    public function onStartFabrica(f:Fabrica):void {
        if (_arrFabrica.indexOf(f) > -1) return;
        _arrFabrica.push(f);
    }

    public function onFinishFabrica(f:Fabrica):void {
        if (_arrFabrica.indexOf(f) == -1) return;
        _arrFabrica.removeAt(_arrFabrica.indexOf(f));
    }

    public function onStartFarm(f:Farm):void {
        if (_arrFarm.indexOf(f) > -1) return;
        _arrFarm.push(f);
    }

    public function onFinishFarm(f:Farm):void {
        if (_arrFarm.indexOf(f) == -1) return;
        _arrFarm.removeAt(_arrFarm.indexOf(f));
    }

    public function onGoAway(v:Boolean):void {
        for (var i:int=0; i<_catsArray.length; i++) {
            (_catsArray[i] as HeroCat).pauseIt(v);
        }
        g.managerAnimal.onGoAwayCats(v);
        g.managerFabricaRecipe.onGoAwayCats(v);
    }

    public function setAllCatsToRandomPositionsAtStartGame():void {
        for (var i:int=0; i<_catsArray.length; i++) {
            (_catsArray[i] as BasicCat).setPosition(g.townArea.getRandomFreeCell());
            (_catsArray[i] as BasicCat).addToMap();
            (_catsArray[i] as HeroCat).makeFreeCatIdle();
        }
    }

    public function goCatToPoint(cat:BasicCat, p:Point, callback:Function = null, ...callbackParams):void {
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
            if (cat is HeroCat) (cat as HeroCat).killAllAnimations();
            if (cat.posX == p.x && cat.posY == p.y) {
                cat.flipIt(false);
                cat.showFront(true);
                cat.idleAnimation();
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


    public function getFreeCatDecor():HeroCat {
        for (var i:int=0; i<_catsArray.length; i++) {
            if ((_catsArray[i] as HeroCat).isFree && (_catsArray[i] as HeroCat).isFree) {
                (_catsArray[i] as HeroCat).killAllAnimations();
                return _catsArray[i];
            }
        }
        return null;
    }

    public function get isFreeCat():Boolean {
        for (var i:int=0; i<_catsArray.length; i++) {
            if ((_catsArray[i] as HeroCat).isFree && (_catsArray[i] as HeroCat).isFree) {
               return true;
            }
        }
        return false;
    }

    public function makeAwayCats():void {
        _townAwayMatrix = g.townArea.townAwayMatrix;
        _catsAwayArray = [];
        var cat:HeroCat;
        cat = new HeroCat(1);
        _catsAwayArray.push(cat);
        cat.setPosition(g.townArea.getRandomFreeCell());
        cat.addToMap();
        cat.makeFreeCatIdle();
        cat.isAwayCat = true;

        cat = new HeroCat(2);
        _catsAwayArray.push(cat);
        cat.setPosition(g.townArea.getRandomFreeCell());
        cat.addToMap();
        cat.makeFreeCatIdle();
        cat.isAwayCat = true;
    }

    public function removeAwayCats():void {
        if (!_catsAwayArray.length) return;
        for (var i:int=0; i<2; i++) {
            (_catsAwayArray[i] as HeroCat).deleteIt();
        }
        _catsAwayArray = [];
    }

    public function checkAllCatsAfterPasteBuilding(buildPosX:int, buildPosY:int, buildWidth:int, buildHeight:int):void {
        // check if any cat is under new building (or after removing) or his way is under building
        for (var i:int=0; i<_catsArray.length; i++) {
            if (_catsArray[i] && _catsArray[i] is HeroCat && (_catsArray[i] as HeroCat).visible) {  // means that cat is not on any fabrica
                checkCatAfterPasteBuilding(_catsArray[i] as HeroCat, buildPosX, buildPosY, buildWidth, buildHeight);
            }
        }
    }

    private function checkCatAfterPasteBuilding(cat:HeroCat, buildPosX:int, buildPosY:int, buildWidth:int, buildHeight:int):void {
        if (g.isAway) return;
        if (cat.isFree) {
            if (cat.isIdleGoNow) { // mean cat is walking now
                if (isCrossedPathAndSquare(cat.currentPath, buildPosX, buildPosY, buildWidth, buildHeight)) {
                    cat.killAllAnimations();
                    if (cat.posX > buildPosX && cat.posX < buildPosX + buildWidth && cat.posY > buildPosY && cat.posY < buildPosY + buildHeight) {
                        var afterRunFree:Function = function (_cat:HeroCat):void {
                            _cat.makeFreeCatIdle();
                        };
                        forceRunToXYPoint(cat, buildPosX + buildWidth + 1, buildPosY + 1, afterRunFree);
                    } else cat.makeFreeCatIdle();
                }
            } else {
                if (cat.posX > buildPosX && cat.posX < buildPosX + buildWidth && cat.posY > buildPosY && cat.posY < buildPosY + buildHeight) {
                    var afterRunFree2:Function = function (_cat:HeroCat):void {
                        _cat.makeFreeCatIdle();
                    };
                    cat.killAllAnimations();
                    forceRunToXYPoint(cat, buildPosX + buildWidth, buildPosY, afterRunFree2);
                }
            }
        } else {
            var endPoint:Point = cat.endPathPoint;
            if (cat.posX > buildPosX && cat.posX < buildPosX+buildWidth && cat.posY > buildPosY && cat.posY < buildPosY+buildHeight) {
                var afterRun:Function = function (_cat:HeroCat):void {
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

    private function forceRunToXYPoint(cat:HeroCat, posX:int, posY:int, callback:Function):void {
        cat.runAnimation();
        var p:Point = new Point(posX, posY);
        p = g.matrixGrid.getXYFromIndex(p);
        cat.goCatToXYPoint(p, 1, callback);
    }

    public function jumpCatsFunny(f:Function = null):void {
        for (var i:int = 0; i < _catsArray.length; i++) {
            if (_catsArray[i].isFree) {
                _catsArray[i].jumpCat();
            }
        }
        if (f != null) {
            f.apply();
            f = null;
        }

    }

    public function helloCats(f:Function = null):void {
        for (var i:int = 0; i < _catsArray.length; i++) {
            if (_catsArray[i].isFree) {
                _catsArray[i].helloCat();
            }
        }
//            var arr:Array = g.managerOrderCats.arrCats;
//            for (i = 0; i < arr.length; i++) {
//                arr[i].sayHIAnimation(null,true);
//            }

//        Utils.createDelay(int(Math.random() * 2) + 2,f1);
        if (f != null) {
            f.apply();
            f = null;
        }
    }
    
    
}
}
