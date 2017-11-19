/**
 * Created by user on 4/27/16.
 */
package manager {
import build.WorldObject;
import data.BuildType;
import flash.geom.Point;

import utils.Utils;

import utils.Utils;

import utils.Utils;

public class ManagerChest {
    public static const RESOURCE:int = 1;
    public static const PLANT:int = 2;
    public static const SOFT_MONEY:int = 3;
    public static const HARD_MONEY:int = 4;
    public static const INSTRUMENT:int = 6;
    public static const MAX_CHEST:int = 5;
    public static const COST_OPEN:int = 5;
    public static const XP:int = 6;
    public static const GREEN_VAU:int = 7;
    public static const BLUE_VAU:int = 7;
    public static const YELLOW_VAU:int = 7;
    public static const PUR_VAU:int = 7;

    private var _data:Object;
    private var _count:int;
    private var _chestBuildID:int = -1;
    private var g:Vars = Vars.getInstance();

    public function ManagerChest() {}

    private function findChestID():void {
        var arR:Array = g.allData.building;
        for (var i:int = 0; i < arR.length; i++) {
            if (arR[i].buildType == BuildType.CHEST) {
                _chestBuildID = arR[i].id;
                break;
            }
        }
    }

    public function fillFromServer(day:String, lastCount:int):void {
        var lastDayNumber:int = int(day);
        var curDayNumber:int = new Date(g.user.day * 1000).dateUTC;
        if (curDayNumber != lastDayNumber)
            _count = 0;
        else
            _count = int(lastCount);
    }

    private function generateChestItems():void {
        var obj:Object = {};
        var aR:Number = Math.random();
        var iR:Number = Math.random();
        if (g.user.level < 17) {
            if (aR <= .30) { // Instrument Upgrade
                if (iR < .08) obj.id = 2;
                else if (iR < .33) obj.id = 3;
                else if (iR < .50) obj.id = 4;
                else if (iR < .67) obj.id = 7;
                else if (iR < .75) obj.id = 8;
                else obj.id = 9;

                obj.count = 1;
                obj.type = INSTRUMENT;
            } else if (aR <= .60) { // Instrument Remove
                if (iR < .37) obj.id = 1;
                else if (iR < .45) obj.id = 5;
                else if (iR < .55) obj.id = 47;
                else if (iR < .95) obj.id = 124;
                else obj.id = 125;

                obj.type = INSTRUMENT;
                obj.count = 1;
            } else if (aR <= .90) { // Soft
                obj.count = g.managerDailyBonus.moneyCount / 2.5;
                obj.id = 0;
                obj.type = SOFT_MONEY;
            } else { //Hard
                if (_count) obj.count = 5 + int(Math.random() * 6);
                else obj.count = 3 + int(Math.random() * 3);
                obj.id = 0;
                obj.type = HARD_MONEY;
            }

        } else {
            if (aR <= .25) { // Instrument Upgrade
                if (iR < .25) obj.id = 2;
                else if (iR < .42) obj.id = 3;
                else if (iR < .50) obj.id = 4;
                else if (iR < .58) obj.id = 7;
                else if (iR < .83) obj.id = 8;
                else obj.id = 9;

                obj.count = 1;
                obj.type = INSTRUMENT;
            } else if (aR <= .55) { // Instrument Remove
                if (iR < .37) obj.id = 1;
                else if (iR < .47) obj.id = 5;
                else if (iR < .52) obj.id = 6;
                else if (iR < .62) obj.id = 47;
                else if (iR < .92) obj.id = 124;
                else obj.id = 125;

                obj.type = INSTRUMENT;
                obj.count = 1;
            } else if (aR <= .75) { // Soft
                obj.count = g.managerDailyBonus.moneyCount / 2.5;
                obj.id = 0;
                obj.type = SOFT_MONEY;
            } else if (aR <= .85) { //Hard
                if (_count) obj.count = 5 + int(Math.random() * 6);
                else obj.count = 3 + int(Math.random() * 3);
                obj.id = 0;
                obj.type = HARD_MONEY;
            } else { // Vaucher
                if (iR <= .35) obj.type = GREEN_VAU;
                else if (iR < .65) obj.type = BLUE_VAU;
                else if (iR < .85) obj.type = PUR_VAU;
                else obj.type = YELLOW_VAU;
                obj.id = 7;
                obj.count = 1;
            }
        }
        _data = obj;
    }

    public function createChest(away:Boolean = false):void {
        if (_count >= MAX_CHEST) return;
        if (g.user.level < 5) return;
        generateChestItems();
        if (_chestBuildID == -1) findChestID();
        var p:Point = g.townArea.getRandomFreeCell();
        if (away) {
            g.townArea.createAwayNewBuild(Utils.objectFromStructureBuildToObject(g.allData.getBuildingById(_chestBuildID)), p.x, p.y, 0);
        } else {
            p = g.matrixGrid.getXYFromIndex(p);
            var build:WorldObject = g.townArea.createNewBuild(Utils.objectFromStructureBuildToObject(g.allData.getBuildingById(_chestBuildID)), 0);
            g.townArea.pasteBuild(build, p.x, p.y, false);
        }
    }

    public function get dataPriseChest():Object {
        return _data;
    }

    public function get getCount():int {
        return _count;
    }

    public function set setCount(count:int):void {
        _count += count;
    }

    public function makeTutorialChest():WorldObject {
        var p:Point = new Point(33, 33);
        p = g.matrixGrid.getXYFromIndex(p);
        if (_chestBuildID == -1) findChestID();
        var build:WorldObject = g.townArea.createNewBuild(Utils.objectFromStructureBuildToObject(g.allData.getBuildingById(_chestBuildID)), 0);
        g.townArea.pasteBuild(build, p.x, p.y, false);
        return build;
    }
}
}
