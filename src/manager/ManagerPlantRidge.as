/**
 * Created by andy on 8/6/15.
 */
package manager {
import build.ridge.Ridge;
import com.junkbyte.console.Cc;
import flash.geom.Point;
import heroes.HeroCat;

import media.SoundConst;

import mouse.ToolsModifier;

import windows.WindowsManager;

public class ManagerPlantRidge {
    private var _arrRidge:Array; // список всех грядок юзера
    private var _movingRidgePlantId:int;
    private var _tempPoint:Point;

    private var g:Vars = Vars.getInstance();

    public function ManagerPlantRidge() {
        var arr:Array = g.townArea.cityObjects;
        _movingRidgePlantId = -1;
        _arrRidge = [];
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] is Ridge) {
                _arrRidge.push(arr[i]);
            }
        }
        _tempPoint = new Point();
    }

    public function onAddNewRidge(r:Ridge):void { _arrRidge.push(r); }
    public function onCraft(plantIdFromServer:String):void { g.server.craftPlantRidge(plantIdFromServer, null); }

    public function addPlant(ob:Object):void {
        var curRidge:Ridge;
        var i:int;
        for (i=0; i<_arrRidge.length; i++) {
            if (_arrRidge[i].dbBuildingId == int(ob.user_db_building_id)) {
                curRidge = _arrRidge[i];
                break;
            }
        }
        if (!curRidge) {
            Cc.error('no such Ridge with dbId: ' + ob.user_db_building_id);
            return;
        }
        curRidge.fillPlant(g.allData.getResourceById(int(ob.plant_id)), true, int(ob.time_work));
        if (curRidge.plant) {
            curRidge.plant.idFromServer = ob.id;
        } else {
            Cc.error('ManagerPlantRidge:: plant = null');
        }
    }

    public function checkFreeRidges():void {
        var b:Boolean = false;
        var i:int;
        for (i=0; i<_arrRidge.length; i++) {  // check if there are at least one HUNGRY ridge
            if (_arrRidge[i].stateRidge == Ridge.EMPTY) {
                b = true;
                break;
            }
        }
        g.bottomPanel.cancelBoolean(true);
        if (b) if (g.userInventory.getCountResourceById(g.toolsModifier.plantId) <= 0) b = false;  // check if there are at least one current resource for plant
        if (!b) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            g.bottomPanel.cancelBoolean(false);
            for (i=0; i<_arrRidge.length; i++) {
                _arrRidge[i].lastBuyResource = false;
            }
        }
    }

    public function onStartActivePlanting(isStart:Boolean):void {
        if (g.tuts.isTuts) return;
        if (isStart) g.gameDispatcher.addEnterFrame(checkForPlanting);
        else g.gameDispatcher.removeEnterFrame(checkForPlanting);
        g.cont.deleteDragPoint();
        g.townArea.onStartPlanting(isStart);
    }

    private function checkForPlanting():void {
        if (g.tuts.isTuts) return;
        _tempPoint.x = g.ownMouse.mouseX;
        _tempPoint.y = g.ownMouse.mouseY;
        _tempPoint = g.cont.contentCont.globalToLocal(_tempPoint);
        for (var i:int=0; i<_arrRidge.length; i++) {
            if ((_arrRidge[i] as Ridge).isFreeRidge) {
                if (isMouseUnderRidge(_tempPoint, _arrRidge[i] as Ridge)) {
                    (_arrRidge[i] as Ridge).plantThePlant();
                    break;
                }
            }
        }
    }

    public function onStartCraftPlanting(isStart:Boolean):void {
        if (g.tuts.isTuts) return;
        g.cont.contentCont.releaseContDrag = !isStart;
        g.cont.tailCont.releaseContDrag = !isStart;
        g.cont.deleteDragPoint();
        if (isStart) g.gameDispatcher.addEnterFrame(checkForCrafting);
        else g.gameDispatcher.removeEnterFrame(checkForCrafting);
    }

    private function checkForCrafting():void {
        _tempPoint.x = g.ownMouse.mouseX;
        _tempPoint.y = g.ownMouse.mouseY;
        _tempPoint = g.cont.contentCont.globalToLocal(_tempPoint);
        for (var i:int=0; i<_arrRidge.length; i++) {
            if ((_arrRidge[i] as Ridge).stateRidge == Ridge.GROWED) {
                if (isMouseUnderRidge(_tempPoint, _arrRidge[i] as Ridge)) {
                    (_arrRidge[i] as Ridge).craftThePlant();
                    break;
                }
            }
        }
    }

    private function isMouseUnderRidge(p:Point, r:Ridge):Boolean {
        var b:Boolean = r.hitArea.isTouchablePoint(p.x - r.source.x, p.y - r.source.y);
        return b;
    }

    public function checkGrowedRidges():void {
        var b:Boolean = false;
        var i:int;
        for (i=0; i<_arrRidge.length; i++) {  // check if there are at least one GROWED ridge
            if (_arrRidge[i].stateRidge == Ridge.GROWED) {
                b = true;
                break;
            }
        }

        if (!b) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
    }

    public function getRidgesForCraft():Array {
        var arr:Array = [];
        for (var i:int=0; i<_arrRidge.length; i++) {
            if (_arrRidge[i].stateRidge == Ridge.GROWED) {
                arr.push(_arrRidge[i]);
            }
        }
        return arr;
    }

    public function getEmptyRidges():Array {
        var arr:Array = [];
        for (var i:int=0; i<_arrRidge.length; i++) {
            if (_arrRidge[i].stateRidge == Ridge.EMPTY) {
                arr.push(_arrRidge[i]);
            }
        }
        return arr;
    }
}
}
