/**
 * Created by andy on 1/18/16.
 */
package manager {
import build.WorldObject;
import build.dailyBonus.DailyBonus;

import data.BuildType;
import data.StructureDataResource;

public class ManagerDailyBonus {
    public static const RESOURCE:int = 1;
    public static const PLANT:int = 2;
    public static const SOFT_MONEY:int = 3;
    public static const HARD_MONEY:int = 4;
    public static const DECOR:int = 5;
    public static const INSTRUMENT:int = 6;
    public static const GREEN_VOU:int = 7;
    public static const BLUE_VOU:int = 8;
    public static const YELLOW_VOU:int = 9;
    public static const PURP_VOU:int = 10;

    private var _arrItems:Array;
    private var _count:int;
    private var g:Vars = Vars.getInstance();

    public function ManagerDailyBonus() {
        super();
    }

    public function fillFromServer(day:String, lastCount:int):void {
        var lastDayNumber:int = int(day);
        var curDayNumber:int = new Date(g.user.day * 1000).dateUTC;
        if (curDayNumber != lastDayNumber)
            _count = 0;
        else
            _count = int(lastCount);
    }

    public function updateCount():void {
        _count++;
        checkDailyBonusStateBuilding();
    }

    public function get count():int {
        return _count;
    }

    public function get moneyCount():int {
        var i:int;
        if (g.user.level <= 3) i = 300;
        else if (g.user.level <= 10) i = 400;
        else if (g.user.level <= 15) i = 500;
        else if (g.user.level <= 19) i = 600;
        else if (g.user.level <= 22) i = 800;
        else if (g.user.level <= 25) i = 900;
        else if (g.user.level <= 27) i = 1000;
        else if (g.user.level <= 29) i = 1200;
        else if (g.user.level <= 31) i = 1300;
        else if (g.user.level <= 33) i = 1500;
        else if (g.user.level <= 35) i = 1700;
        else if (g.user.level <= 37) i = 1900;
        else if (g.user.level <= 39) i = 2100;
        else if (g.user.level <= 41) i = 2300;
        else if (g.user.level <= 43) i = 2500;
        else if (g.user.level <= 45) i = 2600;
        else if (g.user.level <= 47) i = 2800;
        else if (g.user.level <= 49) i = 3000;
        else if (g.user.level <= 50) i = 3200;
        else if (g.user.level <= 51) i = 3350;
        else if (g.user.level <= 52) i = 3500;
        else if (g.user.level <= 53) i = 3650;
        else if (g.user.level <= 54) i = 3800;
        else if (g.user.level <= 55) i = 3950;
        else if (g.user.level <= 56) i = 4100;
        else if (g.user.level <= 57) i = 4250;
        else if (g.user.level <= 58) i = 4400;
        else if (g.user.level <= 59) i = 4500;
        else i = 4500;
        return i;
    }

    public function generateDailyBonusItems():void {
        _arrItems = [];
        var arr:Array = [];
        var i:int;
        var arAllResource:Array = g.allData.resource;
        var arCS:Array = [];
        var arCR:Array = [];
        var arP:Array = [];
        var arR:Array = [];
        var arD:Array = [];
        var arID:Array = [];
        var arIU:Array = [];
        var k:int;
        var random:int;
        var obj:Object;
        var r:StructureDataResource;

        obj = {};
        obj.count = moneyCount;
        obj.id = 0;
        obj.type = SOFT_MONEY;
        _arrItems.push(obj);

        for (i = 0; i < arAllResource.length; i++) {
            if (arAllResource[i].blockByLevel <= g.user.level && arAllResource[i].buildType == BuildType.PLANT) arP.push(arAllResource[i]);
            else if (arAllResource[i].blockByLevel <= g.user.level && arAllResource[i].buildType == BuildType.RESOURCE) {
                if (arAllResource[i].id == 71 || arAllResource[i].id == 72 || arAllResource[i].id == 73 || arAllResource[i].id == 74) arCS.push(arAllResource[i]);
                else if (arAllResource[i].id == 126 || arAllResource[i].id == 127 || arAllResource[i].id == 128 || arAllResource[i].id == 129) arCR.push(arAllResource[i]);
                else arR.push(arAllResource[i]);
            } else if (arAllResource[i].blockByLevel <= g.user.level && arAllResource[i].buildType == BuildType.INSTRUMENT) {
                if (arAllResource[i].id == 124 || arAllResource[i].id == 1 || arAllResource[i].id == 47 || arAllResource[i].id == 5 || arAllResource[i].id == 125 || arAllResource[i].id == 6) arIU.push(arAllResource[i]);
                else if (arAllResource[i].id == 2 || arAllResource[i].id == 3 || arAllResource[i].id == 4 || arAllResource[i].id == 7 || arAllResource[i].id == 8 || arAllResource[i].id == 9) arID.push(arAllResource[i]);
            }
        }

        obj = {};
        arr = [];
        arD = g.allData.building;
        for (i = 0; i < arD.length; i++) {
            if (arD[i].buildType == BuildType.DECOR && arD[i].blockByLevel && arD[i].blockByLevel[0] <= g.user.level && arD[i].dailyBonus) {
                arr.push(arD[i].id);
            }
        }
//        if (arr.length > 0) {
//            obj.id = arr[int(Math.random() * arr.length)];
//            obj.count = 1;
//            obj.type = DECOR;
//            _arrItems.push(obj);
//        }
        random = 3 + int(Math.random() * 3);
        for (i = 0; i < random; i++) {
            k = int(Math.random() * arR.length);
            obj = {};
            obj.id = arR[k].id;
            arR.splice(k, 1);
            obj.count = 1;
            obj.type = RESOURCE;
            _arrItems.push(obj);
        }

        if (0.1 < Math.random()) {
            random = 1 + int(Math.random() * 3);
            for (i = 0; i <  random; i++) {
                k = int(Math.random() * arIU.length);
                obj = {};
                obj.id = arIU[k].id;
                arIU.splice(k, 1);
                obj.count = 1;
                obj.type = INSTRUMENT;
                _arrItems.push(obj);
            }
        }
        if (_arrItems.length == 10) return;
        if (_arrItems.length <= 9) {
            if (_arrItems.length == 9) {
                if (0.2 < Math.random()) {
                    k = int(Math.random() * arID.length);
                    obj = {};
                    obj.id = arID[k].id;
                    arID.splice(k, 1);
                    obj.count = 1;
                    obj.type = INSTRUMENT;
                    _arrItems.push(obj);
                }
            } else {
                if (0.2 < Math.random()) {
                    random = 1 + int(Math.random() * 2);
                    for (i = 0; i < random; i++) {
                        if (_arrItems.length >= 10) return;
                        k = int(Math.random() * arID.length);
                        obj = {};
                        obj.id = arID[k].id;
                        arID.splice(k, 1);
                        obj.count = 1;
                        obj.type = INSTRUMENT;
                        _arrItems.push(obj);
                    }
                }
            }
        }
        if (_arrItems.length < 10) {
            if (g.user.level >= 17) {
                if (0.4 < Math.random()) {
                    random = 1 + int(Math.random() * 3);
                    for (i = 0; i < random; i++) {
                        if (_arrItems.length >= 10) return;
                        k = int(Math.random() * arP.length);
                        obj = {};
                        obj.id = arP[k].id;
                        arP.splice(k, 1);
                        obj.count = 1;
                        obj.type = PLANT;
                        _arrItems.push(obj);
                    }
                }
            } else {
                random = 10 - _arrItems.length;
                for (i = 0; i < random; i++) {
                    if (_arrItems.length >= 10) return;
                    k = int(Math.random() * arP.length);
                    obj = {};
                    obj.id = arP[k].id;
                    arP.splice(k, 1);
                    obj.count = 1;
                    obj.type = PLANT;
                    _arrItems.push(obj);
                }
            }
        }
        if (_arrItems.length < 10 && g.user.level >= 17 && g.user.level < 24) {
            obj = {};
            obj.id = 0;
            obj.count = 1;
            obj.type = 7 + int(Math.random() * 4);
        } else if (_arrItems.length < 10 && g.user.level >= 25) {
            if ((10 - _arrItems.length) <= 2) {
                obj = {};
                obj.id = 50;
                obj.count = 1;
                obj.type = 7 + int(Math.random() * 4);
            } else if (0.2 < Math.random()) {
                    obj = {};
                    obj.id = 50;
                    obj.count = 1;
                    obj.type = 7 + int(Math.random() * 4);
                }
            }
        if (_arrItems.length < 10 && g.user.level >= 25) {
            if (0.3 < Math.random()) {
                obj = {};
                obj.id = int(Math.random() * arCS.length);
                obj.count = 1;
                obj.type = RESOURCE;
            } else {
                obj = {};
                obj.id = int(Math.random() * arCR.length);
                obj.count = 1;
                obj.type = RESOURCE;
            }
        }
        if (_arrItems.length != 10) {
            generateDailyBonusItems();
            return;
        }
        _arrItems.sortOn('id', Array.NUMERIC);
    }

    public function get dailyBonusItems():Array {
        return _arrItems.slice();
    }

    public function checkDailyBonusStateBuilding():void {
        var b:WorldObject = g.townArea.getCityObjectsByType(BuildType.DAILY_BONUS)[0];
        if (b) {
            if (_count <= 0) {
                (b as DailyBonus).showLights();
            } else {
                (b as DailyBonus).hideLights();
            }
        }
    }
}
}
