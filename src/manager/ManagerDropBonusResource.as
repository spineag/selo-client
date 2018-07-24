/**
 * Created by andy on 7/7/15.
 */
package manager {
import data.DataMoney;

import flash.geom.Point;

import resourceItem.ResourceItem;
import resourceItem.newDrop.DropObject;

public class ManagerDropBonusResource {
    public static const DROP_VARIATY:int = 2; // == 3 %
    public static const DROP_VARIATY_5:int = 2; // == 5 %

    private var g:Vars = Vars.getInstance();
    private var _countBonus:int;

    public function ManagerDropBonusResource() {
        _countBonus = 0;
    }

    public function checkDrop():Boolean {
        _countBonus++;
        if (g.user.level <= 7 && !g.tuts.isTuts) return int(Math.random() * 100) < DROP_VARIATY_5 + 1;
        else if (_countBonus == 2) {
            _countBonus = 0;
            return int(Math.random() * 100) < DROP_VARIATY + 1;
        } else return false;
    }

    public function createDrop(_x:int, _y:int, dropObject:DropObject):void {
//        if (g.user.level <= 10 && !g.tuts.isTuts) makeDropForUpdateAmbar(dropObject, _x, _y);
//            else makeDrop(dropObject, _x, _y);

        makeDrop(dropObject, _x, _y);
    }

    public function makeDropForUpdateAmbar(dropObject:DropObject, _x:int, _y:int):void {
        var id:int = 0;
        if ((g.userInventory.getCountResourceById(2) >= 1 && g.userInventory.getCountResourceById(3) >= 1 && g.userInventory.getCountResourceById(7) >= 1) || g.user.ambarLevel >= 2) {
            if ((g.userInventory.getCountResourceById(4) >= 1 && g.userInventory.getCountResourceById(8) >= 1 && g.userInventory.getCountResourceById(9) >= 1) || g.user.skladLevel >= 2 && g.user.level > 10) {
                makeDrop(dropObject, _x, _y);
                return;
            } else if (g.userInventory.getCountResourceById(4) < 1) id = 4;
            else if (g.userInventory.getCountResourceById(8) < 1) id = 8;
            else if (g.userInventory.getCountResourceById(9) < 1) id = 9;
        } else if (g.userInventory.getCountResourceById(2) < 1) id = 2;
        else if (g.userInventory.getCountResourceById(3) < 1) id = 3;
        else if (g.userInventory.getCountResourceById(7) < 1) id = 7;
        if (id == 0) id = 124;
        var rItem:ResourceItem = new ResourceItem();
        rItem.fillIt(g.allData.getResourceById(id));
        dropObject.addDropItemNew(rItem, new Point(_x, _y));
    }

    public function makeDrop(dropObject:DropObject, _x:int, _y:int):void {
        var id:int = 0;
        var aR:Number = Math.random();
        var iR:Number = Math.random();
        if (g.user.level < 17) {
            if (aR <= .2) { // Instrument Upgrade
                if (iR < .25) id = 2;
                else if (iR < .42) id = 3;
                else if (iR < .50) id = 7;
                else if (iR < .75) id = 8;
                else if (iR < .92) id = 9;
                else id = 4;
            } else { // Instrument Remove
                if (iR < .37) id = 1;
                else if (iR < .45) id = 5;
                else if (iR < .55) id = 47;
                else if (iR < .95) id = 124;
                else id = 125;
            }
        } else {
            if (aR <= .2) { // Instrument Upgrade
                if (iR < .08) id = 2;
                else if (iR < .33) id = 3;
                else if (iR < .50) id = 7;
                else if (iR < .58) id = 8;
                else if (iR < .83) id = 9;
                else id = 4;
            } else if (aR <= .6) { // Instrument Remove
                if (iR < .37) id = 1;
                else if (iR < .47) id = 5;
                else if (iR < .52) id = 6;
                else if (iR < .62) id = 47;
                else if (iR < .92) id = 124;
                else id = 125;
            } else { // Vaucher
                if (iR <= .40) id = DataMoney.GREEN_COUPONE;
                else if (iR < .70) id = DataMoney.BLUE_COUPONE;
                else if (iR < .90) id = DataMoney.RED_COUPONE;
                else id = DataMoney.YELLOW_COUPONE;
                dropObject.addDropMoney(id, 1, new Point(_x, _y));
                return;
            }
        }
        var rItem:ResourceItem = new ResourceItem();
        rItem.fillIt(g.allData.getResourceById(id));
        dropObject.addDropItemNew(rItem, new Point(_x, _y));
    }
}
}
