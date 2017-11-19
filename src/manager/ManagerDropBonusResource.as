/**
 * Created by andy on 7/7/15.
 */
package manager {
import com.junkbyte.console.Cc;

import data.DataMoney;

import resourceItem.DropItem;
import resourceItem.ResourceItem;

import social.SocialNetworkSwitch;

import temp.DropResourceVariaty;

public class ManagerDropBonusResource {
    public static const DROP_VARIATY:int = 2; // == 3 %
    public static const DROP_VARIATY_5:int = 5; // == 5 %

    private var _makeDrop:MakeDrop;
//    private var arr:Array;
    private var g:Vars = Vars.getInstance();
    private var _countBonus:int;

    public function ManagerDropBonusResource() {
        _countBonus =0;
    }

    public function checkDrop():Boolean {
        _countBonus ++ ;
            if (g.user.level <= 7 && !g.tuts.isTuts) return int(Math.random()*100) < DROP_VARIATY_5 + 1;
             else if (_countBonus == 2) {
                _countBonus = 0;
                return int(Math.random()*100) < DROP_VARIATY + 1;
            } else  return false;
    }
    public function createDrop(_x:int, _y:int):void {
        _makeDrop = new MakeDrop(_x, _y);
    }
}
}

import data.DataMoney;

import manager.Vars;

import resourceItem.DropItem;

internal class MakeDrop {
    public static const DROP_TYPE_RESOURSE:String = 'resource';
    public static const DROP_TYPE_MONEY:String = 'money';
    private var g:Vars = Vars.getInstance();
    public function MakeDrop(_x:int, _y:int):void {
        if (g.user.level <= 10 && !g.tuts.isTuts) makeDropForUpdateAmbar(_x, _y);
        else makeDrop(_x, _y);
    }

    public function makeDropForUpdateAmbar(_x:int, _y:int):void {
        var obj:Object = {};
        if ((g.userInventory.getCountResourceById(2) >= 1 && g.userInventory.getCountResourceById(3) >= 1 && g.userInventory.getCountResourceById(7) >= 1) || g.user.ambarLevel >= 2) {
            makeDropForUpdateSklad(_x,_y);
            return;
        } else if (g.userInventory.getCountResourceById(2) < 1) {
            obj.id = 2;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (g.userInventory.getCountResourceById(3) < 1) {
            obj.id = 3;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (g.userInventory.getCountResourceById(7) < 1) {
            obj.id = 7;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        }
        if (!obj.id) {
            obj.id = 124;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        }
        new DropItem(_x, _y, obj);
    }

    public function makeDropForUpdateSklad(_x:int, _y:int):void {
        var obj:Object = {};
        if ((g.userInventory.getCountResourceById(4) >= 1 && g.userInventory.getCountResourceById(8) >= 1 && g.userInventory.getCountResourceById(9) >= 1) || g.user.skladLevel >= 2) {
            makeDrop(_x,_y);
            return;
        } else if (g.userInventory.getCountResourceById(4) < 1) {
            obj.id = 4;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (g.userInventory.getCountResourceById(8) < 1) {
            obj.id = 8;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        } else if (g.userInventory.getCountResourceById(9) < 1) {
            obj.id = 9;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        }
        if (!obj.id) {
            obj.id = 124;
            obj.count = 1;
            obj.variaty = 1;
            obj.type = DROP_TYPE_RESOURSE;
        }
        new DropItem(_x, _y, obj);
    }

    public function makeDrop(_x:int, _y:int):void {
        var obj:Object = {};
        var aR:Number = Math.random();
        var iR:Number = Math.random();
        if (g.user.level < 17) {
            if (aR <= .2) { // Instrument Upgrade
                if (iR < .25) obj.id = 2;
                else if (iR < .42) obj.id = 3;
                else if (iR < .50) obj.id = 7;
                else if (iR < .75) obj.id = 8;
                else if (iR < .92) obj.id = 9;
                else obj.id = 4;
                obj.count = 1;
                obj.type = DROP_TYPE_RESOURSE;
            } else { // Instrument Remove
                if (iR < .37) obj.id = 1;
                else if (iR < .45) obj.id = 5;
                else if (iR < .55) obj.id = 47;
                else if (iR < .95) obj.id = 124;
                else obj.id = 125;
                obj.type = DROP_TYPE_RESOURSE;
                obj.count = 1;
            }
            obj.variaty = 1;
        } else {
            if (aR <= .2) { // Instrument Upgrade
                if (iR < .08) obj.id = 2;
                else if (iR < .33) obj.id = 3;
                else if (iR < .50) obj.id = 7;
                else if (iR < .58) obj.id = 8;
                else if (iR < .83) obj.id = 9;
                else obj.id = 4;
                obj.count = 1;
                obj.type = DROP_TYPE_RESOURSE;
            } else if (aR <= .6) { // Instrument Remove
                if (iR < .37) obj.id = 1;
                else if (iR < .47) obj.id = 5;
                else if (iR < .52) obj.id = 6;
                else if (iR < .62) obj.id = 47;
                else if (iR < .92) obj.id = 124;
                else obj.id = 125;
                obj.type = DROP_TYPE_RESOURSE;
                obj.count = 1;
            } else { // Vaucher
                if (iR <= .40) obj.id = DataMoney.GREEN_COUPONE;
                else if (iR < .70) obj.id =  DataMoney.BLUE_COUPONE;
                else if (iR < .90) obj.id = DataMoney.RED_COUPONE;
                else obj.id =  DataMoney.YELLOW_COUPONE;
                obj.type = DROP_TYPE_MONEY;
                obj.count = 1;
            }
            obj.variaty = 1;
        }
        var prise:Object = obj;
        new DropItem(_x, _y, prise);
    }

}
