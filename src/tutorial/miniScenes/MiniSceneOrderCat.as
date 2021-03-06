/**
 * Created by andy on 10/15/17.
 */
package tutorial.miniScenes {
import flash.geom.Point;
import manager.Vars;
import order.DataOrderCat;
import order.OrderCat;
import windows.WindowsManager;

public class MiniSceneOrderCat {
    private var g:Vars = Vars.getInstance();
    private var _arrCats:Array;
    private var _currentCatObject:Object;
    private var _currentCat:OrderCat;
    private var _nextCats:Array;

    public function MiniSceneOrderCat() {
        _nextCats = [];
        _arrCats = DataOrderCat.arr;
    }

    public function getNewOrderCatData():Object {
        if (!_arrCats || !_arrCats.length) _arrCats = DataOrderCat.arr;
        for (var i:int=0; i<_arrCats.length; i++) {
            if (g.user.miniScenesOrderCats[i] == 0 && _arrCats[i].level <= g.user.level && !_arrCats[i].isMiniScene)  {
                g.user.miniScenesOrderCats[i] = 1;
                return _arrCats[i];
            }
        }
        return null;
    }

    public function checkNeedNewShow(catId:int):Boolean {
        catId --;
//        for (var i:int =0; i<g.user.miniScenesOrderCats.length; i++) {
        if (g.user.miniScenesOrderCats[catId] && int(g.user.miniScenesOrderCats[catId]) == 0)  {
            g.user.miniScenesOrderCats[catId] = 1;
            return true;
        } else if (!g.user.miniScenesOrderCats[catId]) {
            g.user.miniScenesOrderCats[catId] = 1;
            return true;
        }
        return false;
    }
    
    public function releaseMiniSceneForCat(cat:OrderCat):void {
        if (_currentCat) {
            _nextCats.push(cat.dataCat);
        } else {
            g.windowsManager.closeAllWindows();
            _currentCat = cat;
            _currentCatObject = cat.dataCat;
        }
    }

    public function set setCurrentCatObject(currentCatObject:Object):void {
        _currentCatObject = currentCatObject;
    }

    public function get isCatFree():Boolean { if (_currentCat) return false; else return true; }
    public function showCat1():void { g.cont.moveCenterToXY(3300*g.scaleFactor, 1850*g.scaleFactor, false, 2, showCat2); }
    public function showCat2():void { g.windowsManager.closeAllWindows(); g.cont.moveCenterToXY(1500*g.scaleFactor, 676*g.scaleFactor, false, 5, showCat3); }
    public function showCat3():void {
        var p:Point = new Point(30, 0);
        p = g.matrixGrid.getXYFromIndex(p);
        g.cont.moveCenterToXY(p.x,p.y, false, 1, showCat4); 
    }
    public function showCat4():void {
        var p:Point = new Point(30, 25);
        p = g.matrixGrid.getXYFromIndex(p);
        g.cont.moveCenterToXY(p.x,p.y, false, 3);
    }
    
    public function onArriveToOrder():void { g.windowsManager.openWindow(WindowsManager.WO_ORDER_CAT_MINI, onHideWO, _currentCatObject); }
    private function onHideWO(d:Object):void { 
        _currentCat = null;
        _currentCatObject = null;
        if (d) {
            d.isMiniScene = false;
            g.user.miniScenesOrderCats[d.id - 1] = 1;
            g.server.updateOrderCatMiniScenesData(g.user.miniScenesOrderCats.join(''));
        }
        if (_nextCats.length) g.windowsManager.openWindow(WindowsManager.WO_ORDER_CAT_MINI, onHideWO, _nextCats.shift());
            else g.miniScenes.onEndMiniSceneForOrderCat();
    }
}
}
