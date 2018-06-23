/**
 * Created by andy on 11/14/15.
 */
package order {
import build.WorldObject;
import build.fabrica.Fabrica;

import manager.*;

import build.orders.Order;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.StructureDataResource;

import resourceItem.CraftItem;

import resourceItem.ResourceItem;

import social.SocialNetworkSwitch;
import tutorial.TutsAction;

import utils.TimeUtils;
import utils.Utils;

import windows.WindowMain;
import windows.WindowsManager;

public class ManagerOrder {
    public static const COST_SKIP_WAIT:int = 3;

    private var _countTimeDelay:Array;
    private var _countCellAtLevel:Array;
    private var _arrTxtId:Array;
    private var _countDifferentResourcesAtCellAtLevel:Array;
    private var _arrOrders:Array;
    private var _curMaxCountOrders:int;
    private var _curMaxCountResoureAtOrder:int;
    private var _orderBuilding:Order;
    private var _lastActiveCatId:int;

    private var g:Vars = Vars.getInstance();

    public function ManagerOrder() {
        _countCellAtLevel = [
            {level: 1, count: 0},
            {level: 4, count: 1},
            {level: 5, count: 2},
            {level: 6, count: 3},
            {level: 7, count: 4},
            {level: 8, count: 5},
            {level: 9, count: 6},
            {level: 10, count: 7},
            {level: 22, count: 8},
            {level: 32, count: 9}];
        _countDifferentResourcesAtCellAtLevel = [
            {level: 1, count: 0},
            {level: 4, count: 2},
            {level: 6, count: 3},
            {level: 8, count: 4},
            {level: 16, count: 5}
        ];
        _countTimeDelay = [
            {level: 1, delay: 0},
            {level: 4, delay: 30},
            {level: 6, delay: 60},
            {level: 7, delay: 2*60},
            {level: 8, delay: 3*60},
            {level: 9, delay: 4*60},
            {level: 10, delay: 5*60},
            {level: 11, delay: 6*60},
            {level: 12, delay: 7*60},
            {level: 14, delay: 8*60},
            {level: 15, delay: 9*60},
            {level: 16, delay: 10*60},
            {level: 17, delay: 11*60},
            {level: 18, delay: 12*60},
            {level: 19, delay: 13*60},
            {level: 20, delay: 14*60},
            {level: 21, delay: 15*60},
            {level: 22, delay: 16*60},
            {level: 23, delay: 17*60},
            {level: 24, delay: 18*60},
            {level: 25, delay: 19*60},
            {level: 26, delay: 20*60},
            {level: 27, delay: 21*60},
            {level: 28, delay: 22*60},
            {level: 29, delay: 23*60},
            {level: 30, delay: 24*60},
            {level: 31, delay: 25*60},
            {level: 32, delay: 26*60},
            {level: 33, delay: 27*60},
            {level: 34, delay: 28*60}
        ];
        _arrTxtId = [1244,1245,1246,1247,1248,1249,1250,1251,1252,1253,1254,1255];
        _arrOrders = [];
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.ORDER);
        if (arr.length) _orderBuilding = arr[0];
    }

    public function checkOrders():void {
        updateMaxCounts();
        if (g.user.level < 4 || g.managerOrder.stateOrderBuild != WorldObject.STATE_ACTIVE) return;
        var f1:Function = function():void {
            addNewOrders(_curMaxCountOrders - _arrOrders.length, 0, null, -1);
//            checkForNewCats();
        };
//        var f2:Function = function ():void {
//            if (!g.managerCutScenes.isCutScene && !g.miniScenes.isMiniScene && g.user.level == 5 && g.user.cutScenes[8] != 1) g.managerCutScenes.goToNeighbor(); // check for miniScene for visit neighbor
//        };
        if (_arrOrders.length < _curMaxCountOrders) Utils.createDelay(3, f1);
//        else Utils.createDelay(2, f2);
    }

    public function countCellAtLevel(r:int):int {
        for (var i:int = 0; i < _countCellAtLevel.length; i++) {
            if (_countCellAtLevel[i].count == r) {
                return _countCellAtLevel[i].level;
            }
        }
        return 0;
    }

//    private function checkForNewCats(onArriveCallback:Function = null):void {
//        for (var i:int=0; i<_arrOrders.length; i++) {
//            if (!_arrOrders[i].cat && !_arrOrders[i].delOb) {
//                checkCatId();
//                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(onArriveCallback, _arrOrders[i].catOb, i);
//            }
//        }
//    }

    public function get arrOrders():Array { return _arrOrders; }
    public function get countOrders():int { return _arrOrders.length; }
    public function get maxCountOrders():int { return _curMaxCountOrders; }

    public function addFromServer(ob:Object):void {
        if (_arrOrders.length >= _curMaxCountOrders) return;
        var or:OrderItemStructure = new OrderItemStructure();
        or.dbId = String(ob.id);
        or.resourceIds = ob.ids.split('&');
        or.resourceCounts = ob.counts.split('&');
        or.coins = int(ob.coins);
        or.xp = int(ob.xp);
        or.txtId = int(ob.txt_id);
        or.addCoupone = ob.add_coupone == '1';
        or.startTime = int(ob.start_time) || 0;
        or.placeNumber = int(ob.place);
        or.fasterBuy = Boolean(int(ob.faster_buyer));
        if (ob.txt_id) or.txtId = int(ob.txt_id);
        else or.txtId = checkTxtId();
        if (or.startTime - TimeUtils.currentSeconds > 0 ) or.delOb = true;
        Utils.intArray(or.resourceCounts);
        Utils.intArray(or.resourceIds);
        _arrOrders.push(or);
        _arrOrders.sortOn('placeNumber', Array.NUMERIC);
    }

    public function updateMaxCounts():void {
        _curMaxCountOrders = 1;
        _curMaxCountResoureAtOrder = 1;
        for (var i:int=0; i<_countCellAtLevel.length; i++) {
            if (_countCellAtLevel[i].level <= g.user.level) {
                _curMaxCountOrders = _countCellAtLevel[i].count;
            } else {
                break;
            }
        }
        for (i=0; i<_countDifferentResourcesAtCellAtLevel.length; i++) {
            if (_countDifferentResourcesAtCellAtLevel[i].level <= g.user.level) {
                _curMaxCountResoureAtOrder = _countDifferentResourcesAtCellAtLevel[i].count;
            } else {
                break;
            }
        }
    }

    public function getMaxCountForLevel(l:int):int {
        var c:int = 1;
        for (var i:int=0; i<_countCellAtLevel.length; i++) {
            if (_countCellAtLevel[i].level <= l) {
                c = _countCellAtLevel[i].count;
            } else {
                break;
            }
        }
        return c;
    }

    public function get delayBeforeNextOrder():int {
        var l:int=1;
        for (var i:int=0; i<_countTimeDelay.length; i++) {
            if (_countTimeDelay[i].level <= g.user.level) {
                l = _countTimeDelay[i].delay;
            } else {
                break;
            }
        }
        return l;
    }

    private function addNewFastOrder():Object {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FABRICA);
        var arrTemp:Array;
        var i:int = 0;
        var j:int = 0;
        var time:int = 0;
        var ob:Object;
        var arrResource:Array = g.userInventory.getResourceforTypetoOrder(BuildType.RESOURCE);
        var resource:Boolean = false;
        var r:StructureDataResource;
        var ri:ResourceItem;
        if (arrResource == null || arrResource.length <= 0) {
            if (g.user.level <= 5) time = 60;
            else if (g.user.level == 6) time = 120;
            else time = 240;
            for (i = 0; i < arr.length; i++) {
                arrTemp = (arr[i] as Fabrica).arrList;
                if (arrTemp.length > 0) {
                    for (j = 0; j < arrTemp.length; j++) {
                        ri = arrTemp[j];
                        r = g.allData.getResourceById(ri.resourceID);
                        if (r.orderType == 1 && ri.leftTime <= time) {
                            ob = {};
                            ob.id = ri.resourceID;
                            ob.count = 1;
                            resource = true;
                            trace ('Ресурс готовится на фабрике но при этом подходит по времени для ордера ' + "id " + ob.id + ' count ' + ob.count);
                            break;
                        }
                    }
                } else if (arr[i].arrCrafted.length > 0) {
                    arrTemp = (arr[i] as Fabrica).arrCrafted;
                    for (j = 0; j < arrTemp.length; j++) {
                        r = g.allData.getResourceById((arrTemp[j] as CraftItem).resourceId);
                        if (r.orderType > 0) {
                            ob = {};
                            ob.id = arrTemp[j].resourceId;
                            ob.count = 1;
                            resource = true;
                            trace ('Ресурс приготовлен но не забарн из фабрике ' + "id " + ob.id + ' count ' + ob.count);
                            break;
                        }
                    }
                }
            }
            if (!resource) {
                arr = g.townArea.getCityObjectsByType(BuildType.FARM);
                var countAnimalWhoAccept:int = 0;
                for (i = 0; i < arr.length; i++) {
                    if (arr[i].arrAnimals.length > 0) {
                        arrTemp = arr[i].arrAnimals;
                        for (j = 0; j < arrTemp.length; j++) {
                            if (arrTemp[j].state > 1 && arrTemp[j].timeToEnd <= time) {
                                countAnimalWhoAccept ++;
                            }
                        }
                        if (countAnimalWhoAccept > 1) {
                            ob = {};
                            ob.id = arr[i].dataAnimal.idResource;
                            ob.count = countAnimalWhoAccept;
                            trace ('Ресурс готовится на ферме но при этом подходит по времени для ордера ' + "id " + ob.id + ' count ' + ob.count);
                            resource = true;
                            break;
                        }
                    }
                }
            }
        } else {
            arrResource.sortOn("count", Array.DESCENDING | Array.NUMERIC);
            resource = true;
            ob ={};
            ob.id = arrResource[0].id;
            ob.count = arrResource[0].count;
            trace ('Есть ресурсы на складе ' + "id " + ob.id + ' count ' + ob.count);
        }
        if (!resource) {
            arr = g.townArea.getCityObjectsByType(BuildType.RIDGE);
            if (arr && arr.length > 0) {
                arrResource = [];
                for (i = 0; i < arr.length; i++) {
                    if (arr[i].stateRidge >= 3) {
                        ob = {};
                        ob.id = arr[i].plant.dataPlant.id;
                        ob.count = 1;
                        if (arrResource != null && arrResource.length > 0) {
                            for (j = 0; j < arrResource.length; j++) {
                                if (arrResource[j].id == ob.id) {
                                    arrResource[j].count++;
                                    resource = true;
                                    break;
                                }
                            }
                        }
                        if (!resource) arrResource.push(ob);
                    }
                }
                if(arrResource.length > 0) {
                    arrResource.sortOn("count", Array.DESCENDING | Array.NUMERIC);
                    ob = {};
                    ob.id = arrResource[0].id;
                    ob.count = arrResource[0].count;
                    trace('ищет самое большое количество ростений которые растут на грядке и отдает его ' + "id " + ob.id + ' count ' + ob.count);
                }
            }
            if (!resource) {
                arrResource = g.userInventory.getResourceforTypetoOrder(BuildType.PLANT);
                if (arrResource && arrResource.length > 0) {
                    arrResource.sortOn("count", Array.DESCENDING | Array.NUMERIC);
                    ob = {};
                    ob.id = arrResource[0].id;
                    ob.count = int(arrResource[0].count/2);
                    if (ob.count <= 0 || ob.count == 1)  {
                        ob.id = 31;
                        ob.count = 4;
                        trace('ЛАст истанция ' + "id " + ob.id + ' count ' + ob.count);
                    }
                    trace('ищет самое большое количество ростений в амбаре ' + "id " + ob.id + ' count ' + ob.count);
                }
            }
        }
        if (!ob) {
            ob = {};
            ob.id = 31;// Пшеница
            ob.count = 4;
            trace('ЛАст истанция ' + "id " + ob.id + ' count ' + ob.count);
        }
        return ob;
    }


    //types for order:
    // 1 - usual resource from Fabrica
    // 2 - resources made from resources from cave
    // 3 - resource plants
    private function addNewOrders(n:int, delay:int = 0, f:Function = null, place:int = -1,del:Boolean = false):void {
        var or:OrderItemStructure;
        var arrOrderType1:Array = new Array(); //products + cave
        var arrOrderType3:Array = new Array(); // plants
        var k:Number;
        var i:int;
        var userLevel:int = g.user.level;
        var countFastBuyer:int = 0;
        var r:StructureDataResource;

        for (var ik:int = 0; ik < n; ik++) {
//            if (_arrOrders && !g.tuts.isTuts && _arrOrders.length > 0) {
//                for (i = 0; i < _arrOrders.length; i++) {
//                    if ((_arrOrders[i] as OrderItemStructure).fasterBuy == true) {
//                        countFastBuyer++;
//                    }
//                }
//            } else countFastBuyer = 1;
            countFastBuyer = 1; // OFF FASTER BUYER
            if (countFastBuyer == 0 && userLevel < 10) {
                or = new OrderItemStructure();
                or.addCoupone = false;
                var ob:Object = addNewFastOrder();
                or.resourceIds = [ob.id];
                or.resourceCounts = [ob.count];
                or.fasterBuy = true;
            } else {
                var arR:Array = g.allData.resource;
                for (i = 0; i < arR.length; i++) {
                    r = arR[i] as StructureDataResource;
                    if (r.blockByLevel <= userLevel) {
                        if (r.orderType == 1 || r.orderType == 2) {
                            var arTTT:Array = [21, 25, 27, 29, 47, 124, 125, 126, 127, 128, 129, 135];
                            var zxc:int = arTTT.indexOf(r.id);
                            if (r.id<10 || zxc >= 0) {
                                trace('Hnia!!!');
                            }
                            arrOrderType1.push(r.id);
                        } else if (r.orderType == 3) {
                            arrOrderType3.push(r.id);
                        }
                    }
                }

                or = new OrderItemStructure();
                or.resourceIds = [];
                or.resourceCounts = [];

                var needs:Array = [false, false, false, false, false];
                k = Math.random();
                switch (userLevel) {
                    case 4:
                        if (k < .33) needs[0] = true;
                        else needs[1] = true;
                        break;
                    case 5:
                        if (k < .5) needs[0] = true;
                        else needs[1] = true;
                        break;
                    case 6:
                        if (k < .29) needs[0] = true;
                        else if (k < .53) needs[1] = true;
                        else needs[2] = true;
                        break;
                    case 7:
                        if (k < .35) needs[0] = true;
                        else if (k < .55) needs[1] = true;
                        else needs[2] = true;
                        break;
                    case 8:
                        if (k < .35) needs[0] = true;
                        else if (k < .7) needs[1] = true;
                        else needs[2] = true;
                        break;
                    case 9:
                        if (k < .27) needs[0] = true;
                        else if (k < .62) needs[1] = true;
                        else needs[2] = true;
                        break;
                    case 10:
                        if (k < .37) needs[0] = true;
                        else if (k < .74) needs[1] = true;
                        else needs[2] = true;
                        break;
                    case 11:
                        if (k < .32) needs[0] = true;
                        else if (k < .56) needs[1] = true;
                        else if (k < .84) needs[2] = true;
                        else needs[3] = true;
                        break;
                    case 12:
                        if (k < .22) needs[0] = true;
                        else if (k < .42) needs[1] = true;
                        else if (k < .67) needs[2] = true;
                        else needs[3] = true;
                        break;
                    case 13:
                        if (k < .22) needs[0] = true;
                        else if (k < .42) needs[1] = true;
                        else if (k < .67) needs[2] = true;
                        else needs[3] = true;
                        break;
                    case 14:
                        if (k < .22) needs[0] = true;
                        else if (k < .42) needs[1] = true;
                        else if (k < .67) needs[2] = true;
                        else needs[3] = true;
                        break;
                    case 15:
                        if (k < .22) needs[0] = true;
                        else if (k < .42) needs[1] = true;
                        else if (k < .67) needs[2] = true;
                        else needs[3] = true;
                        break;
                    case 16:
                        if (k < .21) needs[0] = true;
                        else if (k < .41) needs[1] = true;
                        else if (k < .65) needs[2] = true;
                        else if (k < .87) needs[3] = true;
                        else needs[4] = true;
                        break;
                    case 17:
                        if (k < .21) needs[0] = true;
                        else if (k < .41) needs[1] = true;
                        else if (k < .65) needs[2] = true;
                        else if (k < .87) needs[3] = true;
                        else needs[4] = true;
                        break;
                    default:
                        if (userLevel > 17) {
                            if (k < .21) needs[0] = true;
                            else if (k < .41) needs[1] = true;
                            else if (k < .65) needs[2] = true;
                            else if (k < .87) needs[3] = true;
                            else needs[4] = true;
                        }
                }

                if (needs[0]) add_1_Item(or, arrOrderType1, arrOrderType3, userLevel);
                else if (needs[1]) add_2_Item(or, arrOrderType1, arrOrderType3, userLevel);
                else if (needs[2]) add_3_Item(or, arrOrderType1, arrOrderType3, userLevel);
                else if (needs[3]) add_4_Item(or, arrOrderType1, arrOrderType3, userLevel);
                else if (needs[4]) add_5_Item(or, arrOrderType1, arrOrderType3, userLevel);
                for (i = 0; i<or.resourceCounts.length; i++) {
                    if (or.resourceCounts[i] <= 0) or.resourceCounts[i] = 1;
                }
            }

//            var caveIt:int = 0;
//            for (i = 0; i < or.resourceIds.length; i++) {
//                r = g.allData.getResourceById(or.resourceIds[i]);
//                if (r.orderType == 2) {
//                    for (k = 0; k < _arrOrders.length; k++) {
//                        for (j = 0; j < _arrOrders[k].resourceIds.length; j++) {
//                            if (_arrOrders[k].resourceIds[j]) {
//                                r = g.allData.getResourceById(_arrOrders[k].resourceIds[j]);
//                                if (r.orderType == 2) caveIt++;
//                                if (caveIt >= 2) break;
//                            }
//                        }
//                    }
//                    if (caveIt >=2) break;
//                }
//            }
//            if (caveIt >= 2) {
//                addNewOrders(n, delay, f, place,del);
//                return;
//            }
//            or.catOb = getFreeCatObj();
//            or.catOb = getFreeCatObj();
            or.coins = 0;
            or.xp = 0;
            for (k = 0; k < or.resourceIds.length; k++) {
                if (or.resourceIds[k]) {
                    r = g.allData.getResourceById(or.resourceIds[k]);
                    if (r) {
                        if (r.orderType == 2) or.addCoupone = true;
                        i = r.orderPriceMin + int(Math.random()*(r.orderPriceMax - r.orderPriceMin));
                        or.coins += i * or.resourceCounts[k];
                        i = r.orderXPMin + int(Math.random()*(r.orderXPMax - r.orderXPMin));
                        or.xp += i * or.resourceCounts[k];
                    } else {
                        Cc.error('ManagerOrder::::::: no resource with id: ' + or.resourceCounts[k]);
                    }
                }
            }
            if (or.xp == 0) or.xp = or.resourceCounts[0] * 2;
            or.startTime = TimeUtils.currentSeconds;
            if (place == -1) or.placeNumber = getFreePlace();
                else or.placeNumber = place;
            or.delOb = del;
            or.txtId = checkTxtId();
            _arrOrders.push(or);
            _arrOrders.sortOn('placeNumber', Array.NUMERIC);
            g.server.addUserOrder(or, delay, 1, or.txtId, null);

            var f1:Function = function ():void {
                if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_ORDERS) {
                    if (f != null) f.apply(null, [or]);
                }
            };
            Utils.createDelay(1,f1);
        }
    }

    public function simulate(n:int = 10000):void {  // use only to test generate orders process
        var or:OrderItemStructure;
        var arrOrderType1:Array = new Array(); //products + cave
        var arrOrderType3:Array = new Array(); // plants
        var k:Number;
        var i:int;
        var userLevel:int = g.user.level;
        var r:StructureDataResource;
        var arTTT:Array;

        for (var ik:int = 0; ik < n; ik++) {
            var arR:Array = g.allData.resource;
            for (i = 0; i < arR.length; i++) {
                r = arR[i] as StructureDataResource;
                if (r.blockByLevel <= userLevel) {
                    if (r.orderType == 1 || r.orderType == 2) {
                        arTTT = [21, 25, 27, 29, 47, 124, 125, 126, 127, 128, 129, 135];
                        var zxc:int = arTTT.indexOf(r.id);
                        if (r.id<10 || zxc >= 0)
                            trace('Hnia!!!');  // add checkpoint here
                        if (arrOrderType1.indexOf(r.id) == -1) arrOrderType1.push(r.id);
                    } else if (r.orderType == 3) {
                        if (arrOrderType3.indexOf(r.id) == -1) arrOrderType3.push(r.id);
                    }
                }
            }

            or = new OrderItemStructure();
            or.resourceIds = [];
            or.resourceCounts = [];

            var needs:Array = [false, false, false, false, false];
            k = Math.random();
            switch (userLevel) {
                case 4:
                    if (k < .33) needs[0] = true;
                    else needs[1] = true;
                    break;
                case 5:
                    if (k < .5) needs[0] = true;
                    else needs[1] = true;
                    break;
                case 6:
                    if (k < .29) needs[0] = true;
                    else if (k < .53) needs[1] = true;
                    else needs[2] = true;
                    break;
                case 7:
                    if (k < .35) needs[0] = true;
                    else if (k < .55) needs[1] = true;
                    else needs[2] = true;
                    break;
                case 8:
                    if (k < .35) needs[0] = true;
                    else if (k < .7) needs[1] = true;
                    else needs[2] = true;
                    break;
                case 9:
                    if (k < .27) needs[0] = true;
                    else if (k < .62) needs[1] = true;
                    else needs[2] = true;
                    break;
                case 10:
                    if (k < .37) needs[0] = true;
                    else if (k < .74) needs[1] = true;
                    else needs[2] = true;
                    break;
                case 11:
                    if (k < .32) needs[0] = true;
                    else if (k < .56) needs[1] = true;
                    else if (k < .84) needs[2] = true;
                    else needs[3] = true;
                    break;
                case 12:
                    if (k < .22) needs[0] = true;
                    else if (k < .42) needs[1] = true;
                    else if (k < .67) needs[2] = true;
                    else needs[3] = true;
                    break;
                case 13:
                    if (k < .22) needs[0] = true;
                    else if (k < .42) needs[1] = true;
                    else if (k < .67) needs[2] = true;
                    else needs[3] = true;
                    break;
                case 14:
                    if (k < .22) needs[0] = true;
                    else if (k < .42) needs[1] = true;
                    else if (k < .67) needs[2] = true;
                    else needs[3] = true;
                    break;
                case 15:
                    if (k < .22) needs[0] = true;
                    else if (k < .42) needs[1] = true;
                    else if (k < .67) needs[2] = true;
                    else needs[3] = true;
                    break;
                case 16:
                    if (k < .21) needs[0] = true;
                    else if (k < .41) needs[1] = true;
                    else if (k < .65) needs[2] = true;
                    else if (k < .87) needs[3] = true;
                    else needs[4] = true;
                    break;
                case 17:
                    if (k < .21) needs[0] = true;
                    else if (k < .41) needs[1] = true;
                    else if (k < .65) needs[2] = true;
                    else if (k < .87) needs[3] = true;
                    else needs[4] = true;
                    break;
                default:
                    if (userLevel > 17) {
                        if (k < .21) needs[0] = true;
                        else if (k < .41) needs[1] = true;
                        else if (k < .65) needs[2] = true;
                        else if (k < .87) needs[3] = true;
                        else needs[4] = true;
                    }
            }

            if (needs[0]) add_1_Item(or, arrOrderType1, arrOrderType3, userLevel);
            else if (needs[1]) add_2_Item(or, arrOrderType1, arrOrderType3, userLevel);
            else if (needs[2]) add_3_Item(or, arrOrderType1, arrOrderType3, userLevel);
            else if (needs[3]) add_4_Item(or, arrOrderType1, arrOrderType3, userLevel);
            else if (needs[4]) add_5_Item(or, arrOrderType1, arrOrderType3, userLevel);
            for (i = 0; i<or.resourceCounts.length; i++) {
                if (or.resourceCounts[i] <= 0)
                    or.resourceCounts[i] = 1;  // add checkpoint here
            }
            arTTT = or.resourceIds.slice();
            while (arTTT.length) {
                k = arTTT.shift();
                if (arTTT.indexOf(k) > -1)
                    trace('hnia 2'); // add checkpoint here
            }
        }
        trace('finish simulate: ' + ik);
    }

    private function checkTxtId():int {
        var b:Boolean = true;
        for (var i:int = 0; i < _arrTxtId.length; i++) {
            b = true;
            for (var j:int = 0; j < _arrOrders.length; j++) {
                if (_arrTxtId[i] == _arrOrders[j].txtId) {
                    b = false;
                    break;
                }
            }
            if (b) {
                return _arrTxtId[i];
            }
        }
        return _arrTxtId[int(Math.random() * _arrTxtId.length)];
    }

    private function getRandomIntElementFromArray(ar:Array):int {
        if (!ar.length) {
            Cc.error('ManagerOrder getRandomIntElementFromArray:: empty array');
            return 31;
        }
        var wasFind:Boolean = false;
        var id:int;
        var index:int;
        while (!wasFind) {
            index = int(Math.random() * ar.length);
            if (ar[index]) {
                id = ar[index];
                wasFind = true;
            }
        }
        return id;
    }
    private function getRandomIntBetween(aMin:int, aMax:int):int { return aMin + int(Math.random()* (aMax+1-aMin)); }

    private function getRandomElementsFromIntArray(ar:Array, n:int):Array {
        var arr:Array = [];
        var arr2:Array = ar.slice();
        var place:int;
        for (var i:int=0; i<n; i++) {
            place = int(Math.random()*arr2.length);
            if (arr2[place]) {
                arr.push(arr2[place]);
                arr2.removeAt(place);
            } else --i;
            if (!arr2.length) arr2 = ar.slice();
        }
        return arr;
    }
    
    private function add_1_Item(or:OrderItemStructure, arProducts:Array, arPlants:Array, userLevel:int):void {
        var randNumber:Number = Math.random();
        if (userLevel == 4) {
            if (randNumber < .35) {
                or.resourceIds.push( getRandomIntElementFromArray(arPlants) );
                or.resourceCounts.push( getRandomIntBetween(1,4) );
            } else {
                or.resourceIds.push( getRandomIntElementFromArray(arProducts) );
                or.resourceCounts.push( getRandomIntBetween(1,2) );
            }
        } else if (userLevel == 5) {
            if (randNumber < .55) {
                or.resourceIds.push( getRandomIntElementFromArray(arPlants) );
                or.resourceCounts.push( getRandomIntBetween(4,9) );
            } else {
                or.resourceIds.push( getRandomIntElementFromArray(arProducts) );
                or.resourceCounts.push( getRandomIntBetween(1,5) );
            }
        } else if (userLevel == 6) {
            if (randNumber < .35) {
                or.resourceIds.push( getRandomIntElementFromArray(arPlants) );
                or.resourceCounts.push( getRandomIntBetween(7,20) );
            } else {
                or.resourceIds.push( getRandomIntElementFromArray(arProducts) );
                or.resourceCounts.push( getRandomIntBetween(1,4) );
            }
        } else if (userLevel == 7) {
            if (randNumber < .35) {
                or.resourceIds.push( getRandomIntElementFromArray(arPlants) );
                or.resourceCounts.push( getRandomIntBetween(8,17) );
            } else {
                or.resourceIds.push( getRandomIntElementFromArray(arProducts) );
                or.resourceCounts.push( getRandomIntBetween(2,6) );
            }
        } else if (userLevel == 8) {
            if (randNumber < .45) {
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceCounts.push(getRandomIntBetween(6, 17));
            } else {
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts.push(getRandomIntBetween(2, 5));
            }
        } else if (userLevel == 9) {
            if (randNumber < .28) {
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceCounts.push(getRandomIntBetween(5, 25));
            } else {
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts.push(getRandomIntBetween(2, 5));
            }
        } else if (userLevel == 10) {
            if (randNumber < .22) {
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceCounts.push(getRandomIntBetween(6, 19));
            } else {
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts.push(getRandomIntBetween(2, 5));
            }
        } else if (userLevel == 11) {
            if (randNumber < .47) {
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceCounts.push(getRandomIntBetween(6, 19));
            } else {
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts.push(getRandomIntBetween(2, 6));
            }
        } else if (userLevel >= 12) {
            if (randNumber < .4) {
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceCounts.push(getRandomIntBetween(6, 19));
            } else {
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts.push(getRandomIntBetween(2, 6));
            }
        }
    }

    private function add_2_Item(or:OrderItemStructure, arProducts:Array, arPlants:Array, userLevel:int):void {
        var randNumber:Number = Math.random();
        var count:int;
        if (userLevel == 4) {
            if (randNumber < .4) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count];
            } else if (randNumber < .6) {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                count = getRandomIntBetween(1, 3);
                or.resourceCounts = [count, count];
            } else {
                count = getRandomIntBetween(1, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts = [count, count];
            }
        } else if (userLevel == 5) {
            if (randNumber < .1) {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                or.resourceIds = [getRandomIntBetween(2, 7)];
            } else {
                count = getRandomIntBetween(1, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts = [count, count];
            }
        } else if (userLevel == 6) {
            if (randNumber < .4) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count];
            } else if (randNumber < .6) {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                count = getRandomIntBetween(2, 7);
                or.resourceCounts = [count, count];
            } else {
                count = getRandomIntBetween(1, 4);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts = [count, count];
            }
        } else if (userLevel == 7) {
            if (randNumber < .3) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count];
            } else if (randNumber < .4) {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                count = getRandomIntBetween(2, 5);
                or.resourceCounts = [count, count];
            } else {
                count = getRandomIntBetween(1, 4);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts = [count, count];
            }
        } else if (userLevel == 8) {
            if (randNumber < .6) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count];
            } else if (randNumber < .7) {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                count = getRandomIntBetween(4, 8);
                or.resourceCounts = [count, count];
            } else {
                count = getRandomIntBetween(1, 3);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts = [count, count];
            }
        } else if (userLevel == 9) {
            if (randNumber < .6) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count];
            } else if (randNumber < .7) {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                count = getRandomIntBetween(5, 8);
                or.resourceCounts = [count, count];
            } else {
                count = getRandomIntBetween(1, 5);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts = [count, count];
            }
        } else if (userLevel == 10) {
            if (randNumber < .3) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count];
            } else if (randNumber < .4) {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                count = getRandomIntBetween(7, 11);
                or.resourceCounts = [count, count];
            } else {
                count = getRandomIntBetween(1, 5);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts = [count, count];
            }
        } else if (userLevel == 11) {
            if (randNumber < .35) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count];
            } else if (randNumber < .5) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                count = getRandomIntBetween(5, 9);
                or.resourceCounts = [count, count];
            } else {
                count = getRandomIntBetween(1, 5);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts = [count, count];
            }
        } else if (userLevel >= 12) {
            if (randNumber < .46) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count];
            } else if (randNumber < .54) {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                count = getRandomIntBetween(5, 8);
                or.resourceCounts = [count, count];
            } else {
                count = getRandomIntBetween(1, 5);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                or.resourceCounts = [count, count];
            }
        }
    }

    private function add_3_Item(or:OrderItemStructure, arProducts:Array, arPlants:Array, userLevel:int):void {
        var randNumber:Number = Math.random();
        var count:int;
        if (userLevel == 6) {
            if (randNumber < .6) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                count = getRandomIntBetween(1, 3);
                or.resourceCounts = [count, count, count];
            } else {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                count = getRandomIntBetween(1, 4);
                or.resourceCounts = [count, count, count];
            }
        } else if (userLevel == 7) {
            if (randNumber < .18) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 3);
                or.resourceCounts = [1, 1, 1];
            } else if (randNumber < .7) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count, count];
            } else {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                count = getRandomIntBetween(1, 3);
                or.resourceCounts = [count, count, count];
            }
        } else if (userLevel == 8) {
            if (randNumber < .2) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 3);
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count, count];
            } else if (randNumber < .65) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count, count];
            } else {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                count = getRandomIntBetween(1, 3);
                or.resourceCounts = [count, count, count];
            }
        } else if (userLevel == 9) {
            if (randNumber < .2) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 3);
                or.resourceCounts = [1, 1, 1];
            } else if (randNumber < .65) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count, count];
            } else {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                count = getRandomIntBetween(1, 3);
                or.resourceCounts = [count, count, count];
            }
        } else if (userLevel == 10) {
            if (randNumber < .24) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 3);
                or.resourceCounts = [1, 1, 1];
            } else if (randNumber < .62) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count, count];
            } else {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                count = getRandomIntBetween(1, 3);
                or.resourceCounts = [count, count, count];
            }
        } else if (userLevel == 11) {
            if (randNumber < .24) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 3);
                or.resourceCounts = [1, 1, 1];
            } else if (randNumber < .62) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count, count];
            } else {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                count = getRandomIntBetween(1, 3);
                or.resourceCounts = [count, count, count];
            }
        } else if (userLevel >= 12) {
            if (randNumber < .5) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 3);
                or.resourceCounts = [1, 1, 1];
            } else if (randNumber < .9) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count, count];
            } else {
                or.resourceIds = getRandomElementsFromIntArray(arPlants, 2);
                or.resourceIds.push(getRandomIntElementFromArray(arProducts));
                count = getRandomIntBetween(1, 3);
                or.resourceCounts = [count, count, count];
            }
        }
    }

    private function add_4_Item(or:OrderItemStructure, arProducts:Array, arPlants:Array, userLevel:int):void {
        var randNumber:Number = Math.random();
        var arrTemp:Array;
        var count:int;
        if (userLevel == 11) {
            if (randNumber < .22) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 4);
                or.resourceCounts = [1, 1, 1, 1];
            } else if (randNumber < .88) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 3);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                or.resourceCounts = [1, 1, 1, 1];
            } else {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                arrTemp = getRandomElementsFromIntArray(arPlants, 2);
                or.resourceIds.push(arrTemp[0]);
                or.resourceIds.push(arrTemp[1]);
                or.resourceCounts = [1, 1, 1, 1];
            }
        } else {
            if (randNumber < .35) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 4);
                or.resourceCounts = [1, 1, 1, 1];
            } else if (randNumber < .55) {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 3);
                or.resourceIds.push(getRandomIntElementFromArray(arPlants));
                count = getRandomIntBetween(1, 2);
                or.resourceCounts = [count, count, count, count];
            } else {
                or.resourceIds = getRandomElementsFromIntArray(arProducts, 2);
                arrTemp = getRandomElementsFromIntArray(arPlants, 2);
                or.resourceIds.push(arrTemp[0]);
                or.resourceIds.push(arrTemp[1]);
                count = getRandomIntBetween(1, 3);
                or.resourceCounts = [count, count, count, count];
            }
        }
        if (!or.resourceIds || !or.resourceIds[0] || or.resourceIds[0] == 0) add_4_Item(or, arProducts, arPlants, userLevel);
    }

    private function add_5_Item(or:OrderItemStructure, arProducts:Array, arPlants:Array, userLevel:int):void {
        var randNumber:Number = Math.random();
        var arrTemp:Array;
        if (randNumber < .35) {
            or.resourceIds = getRandomElementsFromIntArray(arProducts, 5);
            or.resourceCounts = [1, 1, 1, 1, 1];
        } else if (randNumber < .55) {
            or.resourceIds = getRandomElementsFromIntArray(arProducts, 4);
            or.resourceIds.push(getRandomIntElementFromArray(arPlants));
            or.resourceCounts = [1, 1, 1, 1, 1];
        } else {
            or.resourceIds = getRandomElementsFromIntArray(arProducts, 3);
            arrTemp = getRandomElementsFromIntArray(arPlants, 2);
            or.resourceIds.push(arrTemp[0]);
            or.resourceIds.push(arrTemp[1]);
            or.resourceCounts = [1, 1, 1, 1, 1];
        }
        if (!or.resourceIds || !or.resourceIds[0] || or.resourceIds[0] == 0) add_5_Item(or, arProducts, arPlants, userLevel);
    }

    private function getFreePlace():int {
        var k:int;
        var find:Boolean;
        var count:int = _curMaxCountOrders +1;
        for (var i:int=1; i < count; i++) {
            find = true;
            for (k=0; k<_arrOrders.length; k++) {
                if (_arrOrders[k].placeNumber == i) {
                    find = false;
                    break;
                }
            }
            if (find) return i;
        }
        return -1;
    }

    public function deleteOrder(or:OrderItemStructure, f:Function):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == or.dbId) {
                _arrOrders.splice(i, 1);
                break;
            }
        }
        if (i == _arrOrders.length) Cc.error('ManagerOrder deleteOrder:: no order');
        g.server.deleteUserOrder(or.dbId, null);
        addNewOrders(1, delayBeforeNextOrder, f, or.placeNumber,true);
    }

    public function deleteOrderParty(dbId:String, placeNumber:int = 0):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == dbId) {
                _arrOrders.splice(i, 1);
                break;
            }
        }
        g.server.deleteUserOrder(dbId, null);
        if (g.user.level <= 6) addNewOrders(1, 1, null, placeNumber,true);
        else if (g.user.level <= 9) addNewOrders(1, 1, null, placeNumber,true);
        else if (g.user.level <= 15) addNewOrders(1, 1, null, placeNumber,true);
        else if (g.user.level <= 19) addNewOrders(1, 1, null, placeNumber,true);
        else if (g.user.level >= 20) addNewOrders(1, 1, null, placeNumber,true);
    }

    public function sellOrder(or:OrderItemStructure, f:Function):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == or.dbId) {
                _arrOrders.splice(i, 1);
                break;
            }
        }
        g.server.deleteUserOrder(or.dbId,null);
        var pl:int = or.placeNumber;
        or = null;
        addNewOrders(1, 0, f, pl);
    }

    public function checkIsAnyFullOrder():Boolean {  // check if there any order that already can be fulled
        var b:Boolean = false;
        var k:int;
        var or:OrderItemStructure;

        if (!_arrOrders.length) return false;
        for (var i:int=0; i<_arrOrders.length; i++) {
           or = _arrOrders[i];
            if (!or || !or.resourceIds || !or.resourceIds.length) continue;
            b = true;
        if (or.startTime - TimeUtils.currentSeconds <= 0) {
            for (k = 0; k < or.resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(or.resourceIds[k]) < or.resourceCounts[k]) {
                    b = false;
                    break;
                }
            }
        } else b = false;
            if (b) return true;
        }

        return false;
    }
    
    public function checkForFullOrder():void {
        if (checkIsAnyFullOrder()) {
            g.bottomPanel.onFullOrder(true);
            if (_orderBuilding) _orderBuilding.animateSmallHero(true);
        } else {
            g.bottomPanel.onFullOrder(false);
            if (_orderBuilding) _orderBuilding.animateSmallHero(false);
        }
    }

    public function cancelAnimateSmallHero():void {
        g.bottomPanel.onFullOrder(false);
        if (_orderBuilding) checkForFullOrder();
    }

    public function get stateOrderBuild():int {
       return _orderBuilding.stateBuild;
    }
    
    public function  showSmallHeroAtOrder(v:Boolean):void {
//        if (_orderBuilding) _orderBuilding.showSmallHero(v);
        if (v) checkForFullOrder();
    }

    public function onSkipTimer(or:OrderItemStructure):void { // ПОПРАВИТЬ ЧТО БЫ НЕ ПРИЕЗЖАЛО
        g.server.skipOrderTimer(or.dbId, null);
        var pl:int = or.placeNumber;
        var orderDbId:String = or.dbId;
        for (var i:int = 0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].placeNumber == pl) {
                _arrOrders[i].delOb = false;
                g.managerOrder.checkForFullOrder();
                break;
            }
        }
        for (i = 0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == orderDbId) {
//                if (g.user.level <= 6) _arrOrders[i].startTime -= 2* TIME_FIRST_DELAY;
//                else if (g.user.level <= 9) _arrOrders[i].startTime -= 2*  TIME_SECOND_DELAY;
//                else if (g.user.level <= 15) _arrOrders[i].startTime -= 2* TIME_THIRD_DELAY;
//                else if (g.user.level <= 19) _arrOrders[i].startTime -= 2* TIME_FOURTH_DELAY;
//                else if (g.user.level >= 20) _arrOrders[i].startTime -= 2* TIME_FIFTH_DELAY;
                break;
            }
        }
        if (i == _arrOrders.length) Cc.error('ManagerOrder onSkipTimer:: no order');
    }
}
}