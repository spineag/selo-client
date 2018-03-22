/**
 * Created by user on 3/20/18.
 */
package tutorial.miniScenes {
import build.orders.Order;

import data.BuildType;

import flash.geom.Point;

import heroes.HeroCat;

import manager.Vars;

import windows.WindowsManager;

public class MiniSceneOpenOrder {
    private var _cat:HeroCat;
    protected var g:Vars = Vars.getInstance();

    public function MiniSceneOpenOrder() {
        catGoTOORder();
    }

    private function catGoTOORder():void {
        _cat = g.managerCats.getFreeCatDecor();
        if (_cat.isOnMap) _cat.addToMap();
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.ORDER);
        g.managerCats.goCatToPoint(_cat, new Point(30, 23),catComingToOrder);
    }

    private function catComingToOrder():void {
        _cat.showFront(true);
        _cat.showBubble(String(g.managerLanguage.allTexts[1304]));
        _cat.idleAnimation();
    }

    public function deleteCat():void {
        if(_cat) {
            _cat.stopAnimation();
            _cat.makeFreeCatIdle();
            _cat.hideBubble();
            g.gameDispatcher.addToTimer(g.managerCats.timerRandomWorkMan);
        }
    }
}
}
