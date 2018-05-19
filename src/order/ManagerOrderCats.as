/**
 * Created by user on 2/5/16.
 */
package order {
import build.WorldObject;


import com.junkbyte.console.Cc;

import data.DataMoney;

import flash.geom.Point;
import manager.AStar.DirectWay;
import manager.ManagerPartyNew;
import manager.Vars;
import manager.ownError.ErrorConst;

import order.OrderCat;

import resourceItem.newDrop.DropObject;

import starling.display.Quad;
import starling.utils.Color;

import utils.TimeUtils;
import utils.Utils;

import windows.WindowsManager;

public class ManagerOrderCats {
    [ArrayElementType('order.OrderCat')]
//    private var _arrCats:Array;
//    private var _arrAwayCats:Array;
    private var g:Vars = Vars.getInstance();
    private var _catMoto:OrderCat;
    private var _catMotoAway:OrderCat;
    private var _timer:int;
    private var _move:Boolean;
    private var _or:OrderItemStructure;

    public function ManagerOrderCats() {
    }

    public function addCatsOnStartGame():void {
        if (g.managerOrder.stateOrderBuild != WorldObject.STATE_ACTIVE) return;
        var arr:Array = g.managerOrder.arrOrders;
        var leftSeconds:int;
        _move = false;
        arr.sortOn('placeNumber', Array.NUMERIC);
        for (var i:int=0; i<arr.length; i++) {
            leftSeconds = arr[i].startTime - TimeUtils.currentSeconds;
            if (leftSeconds <= 0) {
                _catMoto = new OrderCat(arr[0].catOb);
                _catMoto.walkPosition = OrderCat.STAY_IN_QUEUE;
                _catMoto.setPositionInQueue(1);
                g.townArea.addOrderCatToCont(_catMoto);
                g.townArea.addOrderCatToCityObjects(_catMoto);
                _catMoto.setTailPositions(30, 15);
                _catMoto.idleFrontAnimation();
                g.server.getUserOrderGift(null);
                break;
            }
        }
    }

    public function addCatonFirstTime():void {
        showCat1();
        getNewCatForOrder()
    }

    private function showCat1():void { g.cont.moveCenterToXY(3300*g.scaleFactor, 1850*g.scaleFactor, false, 2, showCat2); }
    private function showCat2():void { g.windowsManager.closeAllWindows(); g.cont.moveCenterToXY(1500*g.scaleFactor, 676*g.scaleFactor, false, 5, showCat3); }
    private function showCat3():void {
        var p:Point = new Point(30, 0);
        p = g.matrixGrid.getXYFromIndex(p);
        g.cont.moveCenterToXY(p.x,p.y, false, 1, showCat4);
    }

    private function showCat4():void {
        var p:Point = new Point(30, 18);
        p = g.matrixGrid.getXYFromIndex(p);
        g.cont.moveCenterToXY(p.x,p.y, false, 3);
    }

    private function showBabble():void {
        _catMoto.showBable();
    }

    public function get moveBoolean():Boolean { return _move; }
    public function get stateBox():int { return _catMoto.stateBox; }
    public function get catMoto():OrderCat { return _catMoto; }

    public function onGoAwayToUser(v:Boolean):void {
        (_catMoto as OrderCat).stopAnimation();
        if ((_catMoto as OrderCat).walkPosition == OrderCat.STAY_IN_QUEUE) {
            (_catMoto as OrderCat).idleFrontAnimation();
        } else (_catMoto as OrderCat).runAnimation();
    }

    public function rawOrderMoto(or:OrderItemStructure):void {
        _or = or;
        (_catMoto as OrderCat).rawMotto(or);
    }

    public function get orderTtStr():OrderItemStructure { return _or; }
    public function  deleteOrderStr():void { _or = null; }

   // ------- cat go away -----------
    public function onReleaseOrder(isOrderSold:Boolean):void {
        moveQueue(_catMoto);

        // cat go away
        _catMoto.forceStopAnimation();
        if (_catMoto.walkPosition == OrderCat.STAY_IN_QUEUE) {
            if (isOrderSold) {
                _catMoto.walkPackAnimation();
            } else {
                _catMoto.walkAnimation();
            }
            goCatToPoint(_catMoto, new Point(_catMoto.posX, _catMoto.posY), goAwayPart1,true, _catMoto );
        } else {

            var onFinishArrive:Function = function():void {
                if (isOrderSold) {
                    _catMoto.walkPackAnimation();
                } else {
                    _catMoto.walkAnimation();
                }
                if (_catMoto.walkPosition == OrderCat.TILE_WALKING) {
                    _catMoto.showFront(false);
                    goAwayPart1(_catMoto);
                } else if (_catMoto.walkPosition == OrderCat.SHORT_OUTTILE_WALKING) {
                    _catMoto.flipIt(true);
                    _catMoto.showFront(true);
                    goAwayPart2(_catMoto);
                } else if (_catMoto.walkPosition == OrderCat.LONG_OUTTILE_WALKING) {
                    var time:int = 20 * (3600*g.scaleFactor - _catMoto.source.x)/(3600*g.scaleFactor - 1500*g.scaleFactor);
                    goAwayPart3(_catMoto,time);
                }
            };
            _catMoto.flipIt(false);
            _catMoto.showFront(true);
            onFinishArrive();
        }
    }

    private function moveQueue(cat:OrderCat):void {
        _catMoto.forceStopAnimation();
        _catMoto.walkAnimation();
        goCatToPoint(_catMoto, new Point(_catMoto.posX, _catMoto.posY), afterMoveQueue,true, _catMoto );
    }

    private function afterMoveQueue(cat:OrderCat):void {
        _catMoto.forceStopAnimation();
        _catMoto.idleFrontAnimation();
    }

    private function goAwayPart1(cat:OrderCat):void {
        _move = true;
        _catMoto.flipIt(true);
        _catMoto.showFront(false);
        goCatToPoint(_catMoto, new Point(_catMoto.posX, 0), goAwayPart2,true, _catMoto);

    }

    private function goAwayPart2(cat:OrderCat):void {
        _catMoto.flipIt(true);
        _catMoto.showFront(true);
        _catMoto.goCatToXYPoint(new Point(1460*g.scaleFactor, 616*g.scaleFactor), 1, goAwayPart3, 0);
    }

    private function goAwayPart3(cat:OrderCat, time:int = -1):void {
        if (time == -1) time = 10;
        _catMoto.goCatToXYPoint(new Point(3750*g.scaleFactor, 1760*g.scaleFactor), time, onGoAway, 0);
    }

    private function onGoAway(cat:OrderCat):void {
        _timer = 40;
        g.gameDispatcher.addEnterFrame(timer);
    }


    private function timer():void {
        _timer--;
        if (_timer <= 0) {
            if (!g.isAway) {
                g.gameDispatcher.removeEnterFrame(timer);
                getNewCatForOrder();
            }
        }
    }

    public function goCatToPoint(cat:OrderCat, p:Point, callback:Function = null, goAway:Boolean = false, ...callbackParams):void {
        var f2:Function = function ():void {
//            try {
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
//            } catch (e:Error) {
//                Cc.error('ManagerOrderCats goCatToPoint f2 error: ' + e.errorID + ' - ' + e.message);
//                g.errorManager.onGetError(ErrorConst.ManagerOrderCats2, true);
//                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerOrderCats goCatToPoint2');
//            }
        };

        var f1:Function = function (arr:Array, goAway:Boolean):void {
//            try {
                _catMoto.goWithPath(arr, f2, goAway);
//            } catch (e:Error) {
//                Cc.error('ManagerOrderCats goCatToPoint f1 error: ' + e.errorID + ' - ' + e.message);
//                g.errorManager.onGetError(ErrorConst.ManagerOrderCats1, true);
//                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerOrderCats goCatToPoint1');
//            }
        };

//        try {
//            var a:AStar = new AStar();
//            a.getPath(cat.posX, cat.posY, p.x, p.y, f1);
//        } catch (e:Error) {
//            Cc.error('ManagerOrderCats goCatToPoint error: ' + e.errorID + ' - ' + e.message);
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerOrderCats goCatToPoint cat == null');
//        }
        
        //new variant without astar
        var arrPath:Array = DirectWay.getDirectXYWay(_catMoto.posX, _catMoto.posY, p.x, p.y);
        f1(arrPath, goAway);
    }

    // ------ new Cat arrived --------
    public function getNewCatForOrder(onArriveCallback:Function = null,ob:Object = null, delay:int=0):OrderCat{
        _move = true;

        if (!_catMoto) {
            _catMoto = new OrderCat(ob);
            _catMoto.checkBoxState(OrderCat.STATE_EMPTY);
        } else {
            _catMoto.checkBoxState(OrderCat.STATE_COIN);

        }
        _catMoto.arriveCallback = onArriveCallback;
        arriveNewCat(_catMoto, delay);
        return _catMoto;
    }

    private function arriveNewCat(cat:OrderCat, delay:int):void {
        _catMoto.source.x = 3750*g.scaleFactor;
        _catMoto.source.y = 1760*g.scaleFactor;
        g.townArea.addOrderCatToCont(_catMoto);
        g.townArea.addOrderCatToCityObjects(_catMoto);
        _catMoto.flipIt(false);
        _catMoto.showFront(false);
        _catMoto.runAnimation();
        _catMoto.walkPosition = OrderCat.LONG_OUTTILE_WALKING;
        _catMoto.goCatToXYPoint(new Point(1460*g.scaleFactor, 616*g.scaleFactor), 10, arrivePart1, delay);
    }

    public function addFromServerGift(ob:Object):void {
        _or = new OrderItemStructure();
        _or.dbId = String(ob.id);
        _or.resourceIds = ob.ids.split('&');
        _or.resourceCounts = ob.counts.split('&');
        _or.coins = int(ob.coins);
        _or.xp = int(ob.xp);
        _or.addCoupone = ob.add_coupone == '1';
        _or.startTime = int(ob.start_time) || 0;
        _or.placeNumber = int(ob.place);
        _or.fasterBuy = Boolean(int(ob.faster_buyer));
        if (_or.startTime - TimeUtils.currentSeconds > 0 ) _or.delOb = true;
        Utils.intArray(_or.resourceCounts);
        Utils.intArray(_or.resourceIds);
        _catMoto.checkBoxState(OrderCat.STATE_COIN);
    }

    private function arrivePart1(cat:OrderCat):void {
        _catMoto.flipIt(false);
        _catMoto.showFront(true);
        var p:Point = new Point(30, 0);
        p = g.matrixGrid.getXYFromIndex(p);
        _catMoto.walkPosition = OrderCat.SHORT_OUTTILE_WALKING;
        _catMoto.runAnimation();
        _catMoto.goCatToXYPoint(p, 1, arrivePart2, 0);
    }

    private function arrivePart2(cat:OrderCat):void {
        _catMoto.setTailPositions(30, 0);
        _catMoto.walkPosition = OrderCat.TILE_WALKING;
        goCatToPoint(_catMoto, new Point(30, 15), afterArrive, false, _catMoto);
    }

    private function afterArrive(cat:OrderCat):void {
        if (_catMoto.posY != 15) {
            goCatToPoint(_catMoto, new Point(30, 15 ), afterArrive, false, _catMoto);
        } else {
            _catMoto.walkPosition = OrderCat.STAY_IN_QUEUE;
            _catMoto.checkArriveCallback();
            _catMoto.forceStopAnimation();
            _catMoto.idleFrontAnimation();
        }
        if (_catMoto.stateBox == OrderCat.STATE_EMPTY) {
            showBabble();
        }
        _move = false;
    }

    public function addAwayCats():void {
        if (!g.isAway) return;
        if (!g.visitedUser) return;
        try {
            var ob:Object;
            var l:int = g.managerOrder.getMaxCountForLevel(g.visitedUser.level);
//            if (l > 5) l = 5;
            _catMotoAway = new OrderCat(null);
            _catMotoAway.setTailPositions(30, 15);
            _catMotoAway.walkPosition = OrderCat.STAY_IN_QUEUE;
            _catMotoAway.setPositionInQueue(0);
            g.townArea.addOrderCatToCont(_catMotoAway);
            g.townArea.addOrderCatToAwayCityObjects(_catMotoAway);
            _catMotoAway.idleFrontAnimation();
        } catch (e:Error) {
            Cc.error('ManagerOrderCats addAWayCats:: error ' + e.errorID);
        }
    }

    public function removeAwayCats():void {
            g.townArea.addOrderCatToCont(_catMotoAway);
            g.townArea.addOrderCatToAwayCityObjects(_catMotoAway);
            (_catMotoAway as OrderCat).deleteIt();
    }
}
}
