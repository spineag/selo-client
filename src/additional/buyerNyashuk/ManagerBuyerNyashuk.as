/**
 * Created by user on 12/14/16.
 */
package additional.buyerNyashuk {
import additional.buyerNyashuk.tableNyashuk.TableNyashuk;

import com.junkbyte.console.Cc;

import data.StructureDataResource;

import dragonBones.Armature;

import flash.geom.Point;

import manager.*;

import additional.buyerNyashuk.BuyerNyashuk;

import manager.AStar.DirectWay;

import social.SocialNetworkSwitch;

import utils.TimeUtils;
import utils.Utils;

import windows.WindowsManager;

public class ManagerBuyerNyashuk {
    private var _arr:Array;
    private var g:Vars = Vars.getInstance();
    private var _arrayNya:Array;
    private var _timer:int;
    private var afterNewLvl:Boolean;
    private var _table1:TableNyashuk;
    private var _table2:TableNyashuk;

    public function ManagerBuyerNyashuk(first:Boolean = false) {
        afterNewLvl = first;
        _arrayNya = [];
        _arr = [];
        _table1 = new TableNyashuk();
        g.townArea.addTableNyashuk(_table1, 26, 25);
        _table2 = new TableNyashuk();
        g.townArea.addTableNyashuk(_table2,25, 27);
        g.loadAnimation.load('animations_json/x1/red_n', 'red_n', null);
        g.loadAnimation.load('animations_json/x1/blue_n', 'blue_n', null);
        if (!g.tuts.isTuts) g.server.getUserPapperBuy(null);
    }

    public function get arrNyashuk():Array { return _arrayNya; }

    public function fillBot(ar:Array):void {
        var ob:Object;
        var i:int;
        _arr = null;
        _arr = [];
        if (ar.length > 0) {
            for (i = 0; i < ar.length; i++) {
                if (ar[i].visible == true) {
                    if (int(ar[i].user_id == g.user.userId)) continue;
                    ob = {};
                    ob.buyerId = int(ar[i].buyer_id);
                    ob.resourceId = int(ar[i].resource_id);
                    ob.resourceCount = int(ar[i].resource_count);
                    ob.cost = int(ar[i].cost);
                    ob.xp = int(ar[i].xp);
                    ob.typeBuild = int(ar[i].type_resource);
                    ob.timeToNext = int(ar[i].time_to_new);
                    ob.isBuyed = false;
                    ob.isBotBuy = true;
                    ob.visible = Boolean(ar[i].visible);
                    _arr.push(ob);
            } else if (ar[i].visible == false && (ar[i].time_to_new - TimeUtils.currentSeconds) * (-1) >= 600) {
                    newBot(false,ar[i]);
                } else {
                    if (ar[i].buyer_id == 1) {
                        if (g.user.level >= 14) g.userTimer.buyerNyashukBlue(600 - (TimeUtils.currentSeconds - ar[i].time_to_new));
                        else g.userTimer.buyerNyashukBlue(g.managerOrder.delayBeforeNextOrder - (TimeUtils.currentSeconds - ar[i].time_to_new));
                        _table1.showTable(true,26, 25);
                    } else {
                        if (g.user.level >= 14) g.userTimer.buyerNyashukRed(600 - (TimeUtils.currentSeconds - ar[i].time_to_new));
                        else g.userTimer.buyerNyashukRed(g.managerOrder.delayBeforeNextOrder - (TimeUtils.currentSeconds - ar[i].time_to_new));
                        _table2.showTable(true, 25, 27);
                    }
                }
            }
        } else newBot(true);
        _timer = 0;
        g.gameDispatcher.addToTimer(timeToCreate);
    }

    private function timeToCreate():void {
        _timer++;
        if (_timer >= 5) {
            if (!afterNewLvl) {
                g.gameDispatcher.removeFromTimer(timeToCreate);
                _timer = 0;
                var k:int = 0;
                for (var i:int = 0; i < _arr.length; i++) {
                    var f2:Function = function ():void {
                        getNewNyaForOrder(null, _arr[k], _arr[k].buyerId);
                    };
                    if (_arr[i].buyerId == 1) getNewNyaForOrder(null, _arr[i], _arr[i].buyerId);
                    else {
                        k = i;
                        Utils.createDelay(2,f2);
                    }
                }
            } else {
            if (_arr.length > 0 && _timer == 5) getNewNyaForOrder(null, _arr[0], _arr[0].buyerId);
                if (_arr.length == 2) {
                    if (_timer >= 7) {
                        g.gameDispatcher.removeFromTimer(timeToCreate);
                        _timer = 0;
                        getNewNyaForOrder(null, _arr[1], _arr[1].buyerId);
                    }
                }
            }
        }
    }

    public function addNyashukOnStartGame():void {
        var leftSeconds:int;
        var r:int = 0;
        for (var i:int=0; i<_arrayNya.length; i++) {
            leftSeconds = _arr[i].startTime - TimeUtils.currentSeconds;
            if (leftSeconds <= 0) {
                if (_arrayNya[i].id == 1) _arrayNya[i].setTailPositions(26, 25);
                else _arrayNya[i].setTailPositions(25, 27);
                _arrayNya[i].walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
                _arrayNya[i].setPositionInQueue(r);
                g.townArea.addBuyerNyashukToCont(_arrayNya[i]);
                g.townArea.addBuyerNyashukToCityObjects(_arrayNya[i]);
                _arrayNya[i].idleFrontAnimation();
                r++;
            }
        }
    }

    public function addNyashuksOnTutorial(faste:Boolean = false):void {
        timeToNewNyashuk(faste, true);
        var f2:Function = function ():void {
            timeToNewNyashuk(faste, true)
        };
        Utils.createDelay(2,f2);
    }

    public function timeToNewNyashuk(faste:Boolean = false, tuttorial:Boolean = false, id:int = -1):void {
        var ob:Object = {};
        if (id == -1) {
            if (_arr.length == 0) ob.buyer_id = 1;
            else {
                if (_arr[0].buyerId == 1) ob.buyer_id = 2;
                else ob.buyer_id = 1;
            }
        } else ob.buyer_id = id;
        if (tuttorial) newBotTutorial(ob);
            else newBot(false,ob);
        if (faste) getNewNyaForOrderFaste(null,_arr[_arr.length-1],_arr[_arr.length-1].buyerId);
            else getNewNyaForOrder(null,_arr[_arr.length-1],_arr[_arr.length-1].buyerId);
    }

    private function newBotTutorial(objectNew:Object = null):void {
        var ob:Object;
        ob = {};
        ob.buyerId = objectNew.buyer_id;
        if (objectNew.buyer_id == 1) {
            ob.resourceId = 13; // Булка
            ob.resourceCount = 1;
        } else {
            ob.resourceId = 26; // Яйцо
            ob.resourceCount = 3;
        }

        ob.cost = g.allData.getResourceById(ob.resourceId).visitorPrice * ob.resourceCount;
        ob.xp = 5;
        ob.typeBuild = int(g.allData.getResourceById(ob.resourceId).buildType);
        ob.timeToNext = 0;
        ob.isBuyed = false;
        ob.isBotBuy = true;
        ob.visible = true;
        _arr.push(ob);
        g.server.updateUserPapperBuy(ob.buyerId, ob.resourceId, ob.resourceCount, ob.xp, ob.cost,1, ob.typeBuild);
    }

    private function newBot(firstBot:Boolean = false, objectNew:Object = null):void {
        var arrMin:Array = [];
        var arr:Array;
        var arrMax:Array = [];
        var ob:Object;
        var ra:int;
        var i:int;
        var r:StructureDataResource;
        if (firstBot) {
            arr = g.allData.resource;
            for (i = 0; i < arr.length; i++) {
                if (arr[i].blockByLevel <= g.user.level && !g.userInventory.getCountResourceById(arr[i].id) && (arr[i] as StructureDataResource).visitorPrice > 0) {
                    arrMin.push(arr[i]);
                }
            }
            arr = g.userInventory.getResourcesForAmbarAndSklad();
            arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
            for (i = 0; i < arr.length; i++) {
                if (arrMax.length >= 3) break;
                if (g.allData.getResourceById(arr[i].id).visitorPrice > 0) arrMax.push(arr[i]);
            }
            if (arrMin.length <= 0) {
                arr = g.userInventory.getResourcesForAmbarAndSklad();
                arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
                for (i = 0; i < arr.length; i++) {
                    if (g.allData.getResourceById(arr[i].id).visitorPrice > 0) arrMin.push(arr[i]);
                }
            }
            ra =  int(Math.random() * arrMin.length);
            if (_arr && _arr.length > 0) {
                if (arrMin[ra].id == _arr[0].resourceId)  ra =  int(Math.random() * arrMin.length);
            }

            ob = {};
            ob.buyerId = 1;
            ob.resourceId = arrMin[ra].id;
            ob.resourceCount = 1;
            ob.cost = arrMin[ra].visitorPrice * ob.resourceCount;
            ob.xp = 5;
            ob.typeBuild = int(arrMin[ra].buildType);
            ob.timeToNext = 0;
            ob.isBuyed = false;
            ob.isBotBuy = true;
            ob.visible = true;
            _arr.push(ob);

            ra = int(Math.random() * arrMax.length);
            if (_arr && _arr.length > 0) {
                if (arrMax.length > 0 && arrMax[ra].id == _arr[0].resourceId)  ra =  int(Math.random() * arrMax.length);
            }
            ob = {};
            ob.buyerId = 2;
            ob.resourceId = arrMax[ra].id;
            ob.resourceCount = int(Math.random()*arrMax[ra].count) + 1;
            ob.cost = g.allData.getResourceById(arrMax[ra].id).visitorPrice * ob.resourceCount;
            ob.xp = 5;
            ob.typeBuild = g.allData.getResourceById(arrMax[ra].id).buildType;
            ob.timeToNext = 0;
            ob.isBuyed = false;
            ob.isBotBuy = true;
            ob.visible = true;
            _arr.push(ob);
            for (i = 0; i < 2; i++) {
                g.server.addUserPapperBuy(_arr[i].buyerId, _arr[i].resourceId, _arr[i].resourceCount, _arr[i].xp, _arr[i].cost, 1);
            }
        } else  {
            if (objectNew.buyer_id == 1) {
                arr = g.allData.resource;
                for (i = 0; i < arr.length; i++) {
//                    if (arr[i].blockByLevel <= g.user.level && !g.userInventory.getCountResourceById(arr[i].id) && (arr[i] as StructureDataResource).visitorPrice > 0) {
                    if (arr[i].blockByLevel <= g.user.level && (arr[i] as StructureDataResource).visitorPrice > 0) {
                        arrMin.push(arr[i]);
                    }
                }
                ra = int(Math.random() * arrMin.length);
                ob = {};
                ob.buyerId = 1;
                ob.resourceId = arrMin[ra].id;
                ob.resourceCount = 1;
                ob.cost = arrMin[ra].visitorPrice * ob.resourceCount;
                ob.xp = 5;
                ob.type = arrMin[ra].buildType;
                ob.timeToNext = 0;
                ob.isBuyed = false;
                ob.isBotBuy = true;
                ob.visible = true;
            } else {
                arr = g.userInventory.getResourcesForAmbarAndSklad();
                arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
                ob = {};
                ob.buyerId = 2;
                ob.xp = 5;
                for (i = 0; i < arr.length; i++) {
                    if (arrMax.length >= 3) break;
                    r = g.allData.getResourceById(arr[i].id);
                    if (r.visitorPrice > 0) arrMax.push(arr[i]);
                }
                if (!arrMax.length) {
                    r = g.allData.getResourceById(31);
                    ob.resourceId = r.id;
                    ob.resourceCount = 5;
                    ob.cost = ob.resourceCount * r.visitorPrice;
                    ob.typeBuild = r.buildType;
                } else { 
                    ra = int(Math.random() * arrMax.length);
                    ob.resourceId = arrMax[ra].id;
                    ob.resourceCount = int(Math.random() * arrMax[ra].count) + 1;
                    ob.cost = g.allData.getResourceById(arrMax[ra].id).visitorPrice * ob.resourceCount;
                    ob.typeBuild = g.allData.getResourceById(arrMax[ra].id).buildType;
                }
                if (!_arr && _arr.length > 0) {
                    if (_arr[0].resourceId == ob.resourceId) {
                        newBot(firstBot, objectNew);
                        return;
                    }
                }
                ob.timeToNext = 0;
                ob.isBuyed = false;
                ob.isBotBuy = true;
                ob.visible = true;
            }
            _arr.push(ob);
            g.server.updateUserPapperBuy(ob.buyerId, ob.resourceId, ob.resourceCount, ob.xp, ob.cost,1, ob.typeBuild);
        }
    }

    public function isAnyNiash():Boolean { return Boolean(_arrayNya.length > 0); }
    public function addArrows(t:Number = 0):void {
        for (var i:int=0; i<_arrayNya.length; i++) {
            (_arrayNya[i] as BuyerNyashuk).addArrow(t);
        }
    }

    public function onGoAwayToUser(v:Boolean):void {
        for (var i:int=0; i<_arrayNya[i].length; i++) {
            if (v)
                (_arrayNya[i] as BuyerNyashuk).stopAnimation();
            else
            if ((_arrayNya[i] as BuyerNyashuk).walkPosition == BuyerNyashuk.STAY_IN_QUEUE) {
                (_arrayNya[i] as BuyerNyashuk).idleFrontAnimation();
            } else (_arrayNya[i] as BuyerNyashuk).walkAnimation();
        }
    }

    // ------- cat go away -----------
    public function onReleaseOrder(nya:BuyerNyashuk, isOrderSelled:Boolean):void {
        if (!nya) {
            Cc.error('ManagerBuyerNyashuk onReleaseOrder:: nya == null');
            return;
        }
        nya.noClick();
        var i:int = _arrayNya.indexOf(nya);
        if (i > -1) {
            _arrayNya.splice(i, 1);
            _arr.splice(i, 1);
        }

        nya.forceStopAnimation();
        if (nya.walkPosition == BuyerNyashuk.STAY_IN_QUEUE) {
            if (isOrderSelled) {
                nya.walkPackAnimation();
            } else {
                nya.walkAnimation();
            }
//            goNyaToPoint(nya, new Point(nya.posX + 1, nya.posY), goAwayPart1,true, nya );
            goAwayPart1(nya);
        } else {
            var onFinishArrive:Function = function():void {
                if (isOrderSelled) {
                    nya.walkPackAnimation();
                } else {
                    nya.walkAnimation();
                }
                if (nya.walkPosition == BuyerNyashuk.TILE_WALKING) {
                    nya.showFront(true);
                    goAwayPart1(nya);
                } else if (nya.walkPosition == BuyerNyashuk.SHORT_OUTTILE_WALKING) {
                    nya.flipIt(true);
                    nya.showFront(false);
                    goAwayPart2(nya);
                } else if (nya.walkPosition == BuyerNyashuk.LONG_OUTTILE_WALKING) {
                    var time:int = 20 * (3600*g.scaleFactor - nya.source.x)/(3600*g.scaleFactor - 1500*g.scaleFactor);
                    goAwayPart4(nya,time);
                }
            };
            nya.flipIt(false);
            nya.showFront(true);
        }
        if (nya.id == 1)_table1.showTable(true,26, 25);
            else _table2.showTable(true, 25, 27);
    }

    private function goAwayPart1(nya:BuyerNyashuk):void {
        var p:Point = new Point(31, 26);
        p = g.matrixGrid.getXYFromIndex(p);
        nya.flipIt(true);
        nya.walkPosition = BuyerNyashuk.SHORT_OUTTILE_WALKING;
        nya.walkAnimation();
        nya.goNyaToXYPoint(p, 2, goAwayPart2);
    }

    private function goAwayPart2(nya:BuyerNyashuk, id:int = 1):void {
        var p:Point = new Point(33, 0);
        nya.flipIt(false);
        nya.showFront(false);
        p = g.matrixGrid.getXYFromIndex(p);
        nya.walkAnimation();
        nya.goNyaToXYPoint(p,6, goAwayPart3);
    }

    private function goAwayPart3(nya:BuyerNyashuk, id:int = 1):void {
        nya.flipIt(true);
        nya.showFront(true);
        nya.goNyaToXYPoint(new Point(3600*g.scaleFactor, 1760*g.scaleFactor), 10, onGoAway);
    }

    private function goAwayPart4(nya:BuyerNyashuk, time:int = -1):void {
        if (time == -1) time = 28;
        nya.goNyaToXYPoint(new Point(3600*g.scaleFactor, 1760*g.scaleFactor), 28, onGoAway);
    }

    private function onGoAway(nya:BuyerNyashuk,id:int):void {
        nya.deleteIt();
        nya = null;
    }

    public function goNyaToPoint(nya:BuyerNyashuk, p:Point, callback:Function = null, goAway:Boolean = false, ...callbackParams):void {
        var f2:Function = function ():void {
            try {
                if (callback != null) {
                    callback.apply(null, callbackParams);
                }
            } catch (e:Error) {
                Cc.error('ManagerBuyerNyashuk goNyaToPoint f2 error: ' + e.errorID + ' - ' + e.message);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerBuyerNyashuk goNyaToPoint2');
            }
        };

        var f1:Function = function (arr:Array, goAway:Boolean):void {
            try {
            if (arr.length == 1 || !arr) {
                nya.forceStopAnimation();
                nya.idleFrontAnimation();
                nya.walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
                return;
            }
                nya.goWithPath(arr, f2, goAway);
            } catch (e:Error) {
                Cc.error('ManagerBuyerNyashuk goNyaToPoint f1 error: ' + e.errorID + ' - ' + e.message);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerBuyerNyashuk goNyaToPoint1');
            }
        };

        var arrPath:Array = DirectWay.getDirectXYWay(nya.posX, nya.posY, p.x, p.y);
        f1(arrPath, goAway);
    }


    // ------ new Nyashuk arrived --------
    public function getNewNyaForOrder(onArriveCallback:Function = null, ob:Object = null, id:int = 1):BuyerNyashuk{
//        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) return null;
        if (_arrayNya.length >= 2) return null;
        if (id == 1)_table1.showTable(false,26, 25);
        else _table2.showTable(false, 25, 27);
        var nya:BuyerNyashuk = new BuyerNyashuk(id, ob, afterNewLvl);
        nya.noClick();
        nya.nyashukGo = true;
        nya.arriveCallback = onArriveCallback;
        nya.setPositionInQueue(getFreeQueuePosition());
        _arrayNya.push(nya);
        arriveNewNyashik(nya);
//        quickArriveNyashuk(nya);
        return nya;
    }

    private function getFreeQueuePosition():int {
        if (!_arrayNya) return 0;
        else return _arrayNya.length - 1;
    }

    private function arriveNewNyashik(nya:BuyerNyashuk):void {
        nya.source.x = 3600*g.scaleFactor;
        nya.source.y = 1760*g.scaleFactor;
        g.townArea.addBuyerNyashukToCont(nya);
        g.townArea.addBuyerNyashukToCityObjects(nya);
        nya.flipIt(true);
        nya.showFront(false);
        nya.walkAnimation();
        nya.walkPosition = BuyerNyashuk.LONG_OUTTILE_WALKING;
        nya.goNyaToXYPoint(new Point(1500*g.scaleFactor, 676*g.scaleFactor), 8, arrivePart1);
    }

    private function arrivePart1(nya:BuyerNyashuk,id:int):void {
        var p:Point;
        if (id == 1)  p = new Point(31, 26);
        else p = new Point(31, 26);
        p = g.matrixGrid.getXYFromIndex(p);
        nya.walkPosition = BuyerNyashuk.SHORT_OUTTILE_WALKING;
        nya.flipIt(false);
        nya.showFront(true);
        if (g.tuts.isTuts) {
            nya.walkAnimation();
            nya.goNyaToXYPoint(p, 6, arrivePart2);
        } else {
            nya.walkAnimation();
            nya.goNyaToXYPoint(p, 6, arrivePart2);
        }
    }

    private function arrivePart2(nya:BuyerNyashuk,id:int):void {
        var p:Point;
        if (id == 1)  p = new Point(26, 25);
        else p = new Point(25, 27);
        p = g.matrixGrid.getXYFromIndex(p);
        nya.walkPosition = BuyerNyashuk.SHORT_OUTTILE_WALKING;
        nya.flipIt(true);
        nya.showFront(false);
        if (g.tuts.isTuts) {
            nya.walkAnimation();
            nya.goNyaToXYPoint(p, 6, arrivePart3);
        } else {
            nya.walkAnimation();
            nya.goNyaToXYPoint(p, 6, arrivePart3);
        }
    }

    private function arrivePart3(nya:BuyerNyashuk, id:int):void {
        if (id == 1) nya.setTailPositions(26, 25);
        else nya.setTailPositions(25, 27);
        nya.flipIt(false);
        nya.nyashukGo = false;
        nya.yesClick();
        nya.forceStopAnimation();
        nya.idleFrontAnimation();
        nya.walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
        if (g.isAway) nya.showForOptimisation(false);
    }

    public function visibleNya(b:Boolean):void {
        if (_arrayNya && _arrayNya.length > 0) {
            for (var i:int = 0; i <_arrayNya.length; i++) {
                _arrayNya[i].showForOptimisation(b);
            }
        }
    }

    public function getNewNyaForOrderFaste(onArriveCallback:Function = null, ob:Object = null, id:int = 1):BuyerNyashuk{
        if (id == 1)_table1.showTable(false,26, 25);
        else _table2.showTable(false, 25, 27);
        var nya:BuyerNyashuk = new BuyerNyashuk(id, ob, afterNewLvl);
        nya.noClick();
        nya.arriveCallback = onArriveCallback;
        nya.setPositionInQueue(getFreeQueuePositionFaste());
        _arrayNya.push(nya);
        quickArriveNyashuk(nya);
        return nya;
    }

    private function getFreeQueuePositionFaste():int {
        if (!_arrayNya) return 0;
        else return _arrayNya.length - 1;
    }

    private function quickArriveNyashuk(nya:BuyerNyashuk):void {
        if (nya.id == 1) nya.setTailPositions(26, 25);
        else nya.setTailPositions(25, 27);
        g.townArea.addBuyerNyashukToCont(nya);
        g.townArea.addBuyerNyashukToCityObjects(nya);
        nya.flipIt(false);
        nya.nyashukGo = false;
        nya.yesClick();
        nya.idleFrontAnimation();
        nya.walkPosition = BuyerNyashuk.STAY_IN_QUEUE;
        if (g.isAway) nya.showForOptimisation(false);
    }

}
}
