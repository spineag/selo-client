/**
 * Created by andy on 11/14/15.
 */
package order {
import manager.*;

import build.orders.Order;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.StructureDataResource;

import social.SocialNetworkSwitch;
import tutorial.TutorialAction;
import utils.Utils;

public class ManagerOrder {
    public static const TIME_FIRST_DELAY:int = 3 * 60;
    public static const TIME_SECOND_DELAY:int = 5 * 60;
    public static const TIME_THIRD_DELAY:int = 10 * 60;
    public static const TIME_FOURTH_DELAY:int = 15 * 60;
    public static const TIME_FIFTH_DELAY:int = 20 * 60;

    public static const TIME_DELAY:int = 15 * 60;

    public static const COST_FIRST_SKIP_WAIT:int = 2;
    public static const COST_SECOND_SKIP_WAIT:int = 3;
    public static const COST_THIRD_SKIP_WAIT:int = 5;
    public static const COST_FOURTH_SKIP_WAIT:int = 6;
    public static const COST_FIFTH_SKIP_WAIT:int = 8;

    public static const COST_SKIP_WAIT:int = 8;

    private var _countCellOnLevel:Array;
    private var _countResourceOnLevelAtCell:Array;
    private var _arrOrders:Array;
    private var _curMaxCountOrders:int;
    private var _curMaxCountResoureAtOrder:int;
    private var _orderBuilding:Order;
    private var _lastActiveCatId:int;

    private var g:Vars = Vars.getInstance();

    public function ManagerOrder() {
        _countCellOnLevel = [
            {level: 1, count: 0},
            {level: 2, count: 1},
            {level: 3, count: 2},
            {level: 6, count: 3},
            {level: 7, count: 4},
            {level: 8, count: 5},
            {level: 9, count: 6},
            {level: 10, count: 7},
            {level: 22, count: 8},
            {level: 32, count: 9}];
        _countResourceOnLevelAtCell = [
            {level: 1, count: 1},
            {level: 2, count: 2},
            {level: 6, count: 3},
            {level: 8, count: 4},
            {level: 17, count: 5}
        ];
        _arrOrders = [];
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.ORDER);
        if (arr.length) _orderBuilding = arr[0];
//        _arrNames = ['Булавка', 'Петелька', 'Шпилька', 'Ниточка', 'Иголочка', 'Пряжа', 'Ленточка', 'Ирис', 'Наперсток', 'Кристик', 'Акрил', 'Стежок', 'Шнурочек', 'Ажур'];
    }

    public function checkOrders():void {
        updateMaxCounts();
        if (g.user.level < 3) return;
        var f1:Function = function():void {
            addNewOrders(_curMaxCountOrders - _arrOrders.length,0,null,-1);
            checkForNewCats();
        };

        if (_arrOrders.length < _curMaxCountOrders) {
            Utils.createDelay(3,f1);
        }
    }

    public function addOrderForMiniScenes(onArriveCallback:Function = null):void {
        _arrOrders.length = 0;
        updateMaxCounts();
        if (_arrOrders.length < _curMaxCountOrders) {
            addNewMiniScenesOrder();
            checkForNewCats(onArriveCallback);
        }
        checkOrders();
    }

    private function checkForNewCats(onArriveCallback:Function = null):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (!_arrOrders[i].cat) {
                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(onArriveCallback, _arrOrders[i].catOb, i);
            }
        }
    }

    public function get arrOrders():Array { return _arrOrders; }
    public function get countOrders():int { return _arrOrders.length; }
    public function get maxCountOrders():int { return _curMaxCountOrders; }

    public function addFromServer(ob:Object):void {
        if (_arrOrders.length >= _curMaxCountOrders) return;
        var or:ManagerOrderItem = new ManagerOrderItem();
        or.dbId = ob.id;
        or.resourceIds = ob.ids.split('&');
        or.resourceCounts = ob.counts.split('&');
        if (ob.cat_id == '0') or.catOb = getFreeCatObj();  else or.catOb = DataOrderCat.getObjById(int(ob.cat_id));
        or.coins = int(ob.coins);
        or.xp = int(ob.xp);
        or.addCoupone = ob.add_coupone == '1';
        or.startTime = int(ob.start_time) || 0;
        or.placeNumber = int(ob.place);
        or.fasterBuy = Boolean(int(ob.faster_buyer));
        if (or.startTime - int(new Date().getTime()/1000) > 0 ) or.delOb = true;
        Utils.intArray(or.resourceCounts);
        Utils.intArray(or.resourceIds);
        _arrOrders.push(or);
        _arrOrders.sortOn('placeNumber', Array.NUMERIC);
    }

    public function updateMaxCounts():void {
        _curMaxCountOrders = 1;
        _curMaxCountResoureAtOrder = 1;
        for (var i:int=0; i<_countCellOnLevel.length; i++) {
            if (_countCellOnLevel[i].level <= g.user.level) {
                _curMaxCountOrders = _countCellOnLevel[i].count;
            } else {
                break;
            }
        }
        for (i=0; i<_countResourceOnLevelAtCell.length; i++) {
            if (_countResourceOnLevelAtCell[i].level <= g.user.level) {
                _curMaxCountResoureAtOrder = _countResourceOnLevelAtCell[i].count;
            } else {
                break;
            }
        }
    }

    public function getMaxCountForLevel(l:int):int {
        var c:int = 1;
        for (var i:int=0; i<_countCellOnLevel.length; i++) {
            if (_countCellOnLevel[i].level <= l) {
                c = _countCellOnLevel[i].count;
            } else {
                break;
            }
        }
        return c;
    }

    private function addNewFaserOrders():Object {
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FABRICA);
        var i:int = 0;
        var j:int = 0;
        var time:int = 0;
        var ob:Object;
        var arrResource:Array = g.userInventory.getResourceforTypetoOrder(BuildType.RESOURCE);
        var resource:Boolean = false;
        if (arrResource == null || arrResource.length <= 0) {
            if (g.user.level <= 5) time = 60;
            else if (g.user.level <= 6) time = 120;
            else time = 240;
            for (i = 0; i < arr.length; i++) {
                if (arr[i].arrList.length > 0) {
                    for (j = 0; j < arr[i].arrList.length; j++) {
                        if (arr[i].arrList[j].resourceID != 21 && arr[i].arrList[j].resourceID != 25 && arr[i].arrList[j].resourceID != 27 && arr[i].arrList[j].resourceID != 29 && arr[i].arrList[j].leftTime <= time) {
                            ob = {};
                            ob.id = arr[i].arrList[j].resourceID;
                            ob.count = 1;
                            resource = true;
                            trace ('Ресурс готовится на фабрике но при этом подходит по времени для ордера ' + "id " + ob.id + ' count ' + ob.count);
                            break;
                        }
                    }
                } else if (arr[i].arrCrafted.length > 0) {
                    for (j = 0; j < arr[i].arrCrafted.length; j++) {
                        if (arr[i].arrCrafted[j].resourceId != 21 && arr[i].arrCrafted[j].resourceId != 25 && arr[i].arrCrafted[j].resourceId != 27 && arr[i].arrCrafted[j].resourceId != 29) {
                            ob = {};
                            ob.id = arr[i].arrCrafted[j].resourceId;
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
                        for (j = 0; j < arr[i].arrAnimals.length; j++) {
                            if (arr[i].arrAnimals[j].state > 1 && arr[i].arrAnimals[j].timeToEnd <= time) {
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
    // 1 - usual resource fromFabrica
    // 2 - resources made from resources from cave
    // 3 - resource plants
    private function addNewOrders(n:int, delay:int = 0, f:Function = null, place:int = -1,del:Boolean = false):void {
        var or:ManagerOrderItem;
        var arrOrderType1:Array = new Array(); //products
        var arrOrderType2:Array = new Array(); //cave res
        var arrOrderType3:Array = new Array(); // plants
        var arr:Array = new Array();
        var countResources:int;
        var k:Number;
        var i:int;
        var j:int;
        var level:int = g.user.level;
        var countFastBuyer:int = 0;
        var r:StructureDataResource;

        for (i = 0; i < n; i++) {
            if (_arrOrders && !g.tuts.isTutorial && _arrOrders.length > 0) {
                for (i = 0; i < _arrOrders.length; i++) {
                    if (_arrOrders[i].fasterBuy == true) {
                        countFastBuyer++;
                    }
                }
            } else countFastBuyer = 1;
            if (countFastBuyer == 0 && g.user.level < 10) {
                or = new ManagerOrderItem();
                or.resourceIds = [];
                or.resourceCounts = [];
                or.addCoupone = false;
                var ob:Object = addNewFaserOrders();
                or.resourceIds.push(ob.id);
                or.resourceCounts.push(ob.count);
                or.fasterBuy = true;
            } else {
                var arR:Array = g.allData.resource;
                for (i = 0; i < arR.length; i++) {
                    if (arR[i].blockByLevel <= g.user.level) {
                        if (arR[i].orderType == 1) {
                            arrOrderType1.push(arR[i].id);
                        } else if (arR[i].orderType == 2) {
                            arrOrderType2.push(arR[i].id);
                        } else if (arR[i].orderType == 3) {
                            arrOrderType3.push(arR[i].id);
                        }
                    }
                }

                or = new ManagerOrderItem();
                or.resourceIds = [];
                or.resourceCounts = [];
                if (Math.random() < .2 && arrOrderType2.length) {
                    or.addCoupone = true;
                    countResources = int(Math.random() * 3) + 1;
                    if (countResources > arrOrderType2.length) countResources = arrOrderType2.length;
                    switch (countResources) {
                        case 1:
                            or.resourceIds.push(arrOrderType2[int(Math.random() * arrOrderType2.length)]);
                            or.resourceCounts.push(int(Math.random() * 2) + 5);
                            break;
                        case 2:
                            arr = arrOrderType2.slice();
                            k = int(Math.random() * arr.length);
                            or.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            or.resourceCounts.push(int(Math.random() * 2) + 2);
                            k = int(Math.random() * arr.length);
                            or.resourceIds.push(arr[k]);
                            or.resourceCounts.push(int(Math.random() * 2) + 2);
                            break;
                        case 3:
                            arr = arrOrderType2.slice();
                            k = int(Math.random() * arr.length);
                            or.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            or.resourceCounts.push(2);
                            k = int(Math.random() * arr.length);
                            or.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            or.resourceCounts.push(2);
                            k = int(Math.random() * arr.length);
                            or.resourceIds.push(arr[k]);
                            or.resourceCounts.push(2);
                            break;
                    }
                } else {
                    or.addCoupone = false;
                    countResources = int(Math.random() * _curMaxCountResoureAtOrder) + 1;
                    switch (countResources) {
                        case 1:
                            if (level <= 4) {
                                if (Math.random() < .6) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 4) + 4);
                                }
                            } else if (level == 5) {
                                if (Math.random() < .6) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 6) + 4);
                                }
                            } else if (level == 6) {
                                if (Math.random() < .6) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 6);
                                }
                            } else if (level == 7) {
                                if (Math.random() < .6) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 7) + 6);
                                }
                            } else if (level == 8) {
                                if (Math.random() < .6) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 3) + 2);
                                } else {
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 12) + 6);
                                }
                            } else if (level == 9) {
                                if (Math.random() < .6) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 3) + 2);
                                } else {
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 13) + 7);
                                }
                            } else if (level == 10) {
                                if (Math.random() < .6) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 4) + 2);
                                } else {
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 13) + 7);
                                }
                            } else if (level == 11) {
                                if (Math.random() < .6) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 4) + 2);
                                } else {
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 14) + 7);
                                }
                            } else {
                                if (Math.random() < .6) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 4) + 2);
                                } else {
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 18) + 7);
                                }
                            }
                            break;
                        case 2:
                            k = Math.random();
                            if (level <= 4) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 3) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 3) + 2);
                                }
                            } else if (level <= 5) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 3);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 5) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 2);
                                }
                            } else if (level <= 6) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 7) + 3);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            } else if (level <= 7) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 7) + 3);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 6) + 4);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 6) + 4);
                                }
                            } else if (level <= 8) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 7) + 3);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 5) + 6);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 6);
                                }
                            } else if (level <= 9) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 7) + 3);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 5) + 6);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 6);
                                }
                            } else if (level <= 10) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 7) + 6);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 9) + 7);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 9) + 7);
                                }
                            } else if (level <= 11) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 12) + 7);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 12) + 7);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 12) + 7);
                                }
                            } else {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 12) + 7);
                                } else {
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 12) + 7);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 12) + 7);
                                }
                            }
                            break;
                        case 3:
                            k = Math.random();
                            if (level == 6) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                } else {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            } else if (level == 7) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                } else {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            } else if (level == 8) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 6) + 3);
                                } else {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 6) + 3);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 6) + 3);
                                }
                            } else if (level == 9) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 6) + 3);
                                } else {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 6) + 3);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 6) + 3);
                                }
                            } else if (level == 10) {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 8) + 4);
                                } else {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 8) + 4);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 8) + 4);
                                }
                            } else {
                                if (k > .5) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else if (Math.random() < .3) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 8) + 5);
                                } else {
                                    or.resourceIds.push(arrOrderType1[int(Math.random() * arrOrderType1.length)]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    arr = arrOrderType3.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 8) + 5);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 8) + 5);
                                }
                            }
                            break;
                        case 4:
                            k = Math.random();
                            if (level == 8) {
                                if (k < .7) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            } else if (level == 9) {
                                if (k < .7) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                } else {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            } else {
                                if (k < .7) {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 2);
                                } else {
                                    arr = arrOrderType1.slice();
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    arr.splice(k, 1);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    k = int(Math.random() * arr.length);
                                    or.resourceIds.push(arr[k]);
                                    or.resourceCounts.push(int(Math.random() * 2) + 1);
                                    or.resourceIds.push(arrOrderType3[int(Math.random() * arrOrderType3.length)]);
                                    or.resourceCounts.push(int(Math.random() * 5) + 3);
                                }
                            }
                            break;
                        case 5:
                            arr = arrOrderType1.slice();
                            k = int(Math.random() * arr.length);
                            or.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            or.resourceCounts.push(1);
                            k = int(Math.random() * arr.length);
                            or.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            or.resourceCounts.push(1);
                            k = int(Math.random() * arr.length);
                            or.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            or.resourceCounts.push(1);
                            k = int(Math.random() * arr.length);
                            or.resourceIds.push(arr[k]);
                            arr.splice(k, 1);
                            or.resourceCounts.push(1);
                            k = int(Math.random() * arr.length);
                            or.resourceIds.push(arr[k]);
                            or.resourceCounts.push(1);
                            break;
                    }
                }
            }
            var caveIt:int = 0;
            for (i = 0; i < or.resourceIds.length; i++) {
                r = g.allData.getResourceById(or.resourceIds[i]);
                if (r.orderType == 2) {
                    for (k = 0; k < _arrOrders.length; k++) {
                        for (j = 0; j < _arrOrders[k].resourceIds.length; j++) {
                            if (_arrOrders[k].resourceIds[j]) {
                                r = g.allData.getResourceById(_arrOrders[k].resourceIds[j]);
                                if (r.orderType == 2) caveIt++;
                                if (caveIt >= 2) break;
                            }
                        }
                    }
                    if (caveIt >=2) break;
                }
            }
            if (caveIt >= 2) {
                addNewOrders(n, delay, f, place,del);
                return;
            }
            or.catOb = getFreeCatObj();
            or.coins = 0;
            or.xp = 0;
            for (k = 0; k < or.resourceIds.length; k++) {
                if (or.resourceIds[k]) {
                    r = g.allData.getResourceById(or.resourceIds[k]);
                    if (r) {
                        or.coins += r.orderPrice * or.resourceCounts[k];
                        or.xp += r.orderXP * or.resourceCounts[k];
                    } else {
                        Cc.error('ManagerOrder::::::: no resource with id: ' + or.resourceCounts[k]);
                    }
                }
            }
            if (or.xp == 0) or.xp = or.resourceCounts[0] * 2;
            if (or.xp == 0) {
                or.resourceCounts[0] = 4;
                or.xp = 0;
            }
            or.startTime = int(new Date().getTime() / 1000);
            if (place == -1) {
                or.placeNumber = getFreePlace();
            } else {
                or.placeNumber = place;
            }
            or.delOb = del;
            _arrOrders.push(or);
            _arrOrders.sortOn('placeNumber', Array.NUMERIC);
            g.directServer.addUserOrder(or, delay, or.catOb.id, f);
        }
    }

     private function addNewMiniScenesOrder():void {
        updateMaxCounts();

        var or:ManagerOrderItem = new ManagerOrderItem();
        or.resourceIds = [13];
        or.resourceCounts = [1];
        or.addCoupone = false;
        or.catOb = getFreeCatObj();
        or.coins = g.allData.getResourceById(or.resourceIds[0]).orderPrice * or.resourceCounts[0];
        or.xp = g.allData.getResourceById(or.resourceIds[0]).orderXP * or.resourceCounts[0];
        or.startTime = int(new Date().getTime()/1000);
        or.placeNumber = 1;
        _arrOrders.push(or);
        g.directServer.addUserOrder(or, 0, or.catOb.id, null);

        or = new ManagerOrderItem();
        or.resourceIds = [26];
        or.resourceCounts = [2];
        or.addCoupone = false;
        or.catOb = getFreeCatObj();
        or.coins = g.allData.getResourceById(or.resourceIds[0]).orderPrice * or.resourceCounts[0];
        or.xp = g.allData.getResourceById(or.resourceIds[0]).orderXP * or.resourceCounts[0];
        or.startTime = int(new Date().getTime()/1000);
        or.placeNumber = 2;
        _arrOrders.push(or);
        g.directServer.addUserOrder(or, 0, or.catOb.id, null);
    }

    public function getFreeCatObj():Object {
        var arAllCats:Array = DataOrderCat.getArrByLevel(g.user.level);
        var arIdsNotFree:Array = [];
        for (var i:int=0; i<_arrOrders.length; i++) {
            arIdsNotFree.push((_arrOrders[i] as ManagerOrderItem).cat.dataCatId);
        }
        if (_lastActiveCatId) arIdsNotFree.push(_lastActiveCatId);
        _lastActiveCatId = 0;
        var d:Object;
        for (i=0; i<arAllCats.length; i++) {
            if (arIdsNotFree.indexOf(arAllCats[i].id) == -1) {
                d = arAllCats[i];
                break;
            }
        }
        if (!d) d = DataOrderCat.arr[1];
        return d;
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

    public function deleteOrder(or:ManagerOrderItem, f:Function):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == or.dbId) {
                g.managerOrderCats.onReleaseOrder(_arrOrders[i].cat, false);
                _lastActiveCatId = _arrOrders[i].cat.dataCatId;
                _arrOrders[i].cat = null;
                _arrOrders.splice(i, 1);
                break;
            }
        }
        if (i == _arrOrders.length) Cc.error('ManagerOrder deleteOrder:: no order');
//        var pl:int = order.placeNumber;
        g.directServer.deleteUserOrder(or.dbId, null);

        if (g.user.level <= 6) addNewOrders(1, TIME_FIRST_DELAY, f, or.placeNumber,true);
        else if (g.user.level <= 9) addNewOrders(1, TIME_SECOND_DELAY, f, or.placeNumber,true);
        else if (g.user.level <= 15) addNewOrders(1, TIME_THIRD_DELAY, f, or.placeNumber,true);
        else if (g.user.level <= 19) addNewOrders(1, TIME_FOURTH_DELAY, f, or.placeNumber,true);
        else if (g.user.level >= 20) addNewOrders(1, TIME_FIFTH_DELAY, f, or.placeNumber,true);
    }

    public function deleteOrderParty(dbId:String, placeNumber:int = 0):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == dbId) {
                _arrOrders.splice(i, 1);
                break;
            }
        }
        g.directServer.deleteUserOrder(dbId, null);
        if (g.user.level <= 6) addNewOrders(1, 1, null, placeNumber,true);
        else if (g.user.level <= 9) addNewOrders(1, 1, null, placeNumber,true);
        else if (g.user.level <= 15) addNewOrders(1, 1, null, placeNumber,true);
        else if (g.user.level <= 19) addNewOrders(1, 1, null, placeNumber,true);
        else if (g.user.level >= 20) addNewOrders(1, 1, null, placeNumber,true);
    }

    public function sellOrder(or:ManagerOrderItem, f:Function):void {
        for (var i:int=0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].dbId == or.dbId) {
                g.managerOrderCats.onReleaseOrder(_arrOrders[i].cat, true);
                _arrOrders[i].cat = null;
                _arrOrders.splice(i, 1);
                break;
            }
        }
        g.directServer.deleteUserOrder(or.dbId,null);
        var pl:int = or.placeNumber;
        or = null;
        addNewOrders(1, 0, f, pl);
        for (i = 0; i < _arrOrders.length; i++) {
            if (!_arrOrders[i].cat) {
                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(null,_arrOrders[i].catOb);
                break;
            }
        }
    }

    public function checkIsAnyFullOrder():Boolean {  // check if there any order that already can be fulled
        var b:Boolean = false;
        var k:int;
        var or:ManagerOrderItem;

        if (!_arrOrders.length) return false;
        for (var i:int=0; i<_arrOrders.length; i++) {
           or = _arrOrders[i];
            if (!or || !or.resourceIds || !or.resourceIds.length) continue;
            b = true;
        if (or.cat != null && or.startTime - int(new Date().getTime() / 1000) <= 0) {
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

//        if (!_arrOrders.length) return false;
//        for (var i:int=0; i<_arrOrders.length; i++) {
//            order = _arrOrders[i];
//            if (!order || !order.resourceIds || !order.resourceIds.length) continue;
//            if (order.cat != null && order.startTime - int(new Date().getTime() / 1000) <= 0) {
//                for (k = 0; k < order.resourceIds.length; k++) {
//                    if (g.userInventory.getCountResourceById(order.resourceIds[k]) < order.resourceCounts[k]) {
//                        b = true;
////                        break;
//                    }
//                }
//            }
//            if (b)return true;
//        }
//        return false;
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
        if (_orderBuilding) _orderBuilding.animateSmallHero(false);
    }
    
    public function showSmallHeroAtOrder(v:Boolean):void {
        if (_orderBuilding) _orderBuilding.showSmallHero(v);
        if (v) checkForFullOrder();
    }

    public function onSkipTimer(or:ManagerOrderItem):void {
        g.directServer.skipOrderTimer(or.dbId, null);
        var pl:int = or.placeNumber;
        var orderDbId:String = or.dbId;
        for (var i:int = 0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].placeNumber == pl) {
                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(null,_arrOrders[i].catOb);
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