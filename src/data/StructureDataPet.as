/**
 * Created by andy on 10/21/17.
 */
package data {
import manager.Vars;

import utils.Utils;

public class StructureDataPet {
    private var _id:int;
    private var _petType:int;
    private var _houseId:int;
    private var _eatId:int;
    private var _name:String;
    private var _name2:String;
    private var _costBlue:int;
    private var _costRed:int;
    private var _costGreen:int;
    private var _costYellow:int;
    private var _maxCount:int;
    private var _blockByLevel:Array;
    private var _costHard:int;
    private var _buildTime:int;
    private var _xp:int;
    private var _shopIcon:String;
    private var _currency:Array;
    private var _idCraft:int;
    private var _url:String;
    private var _image:String;
    private var g:Vars = Vars.getInstance();

    public function StructureDataPet(d:Object) {
        _id = int(d.id);
        _petType = int(d.pet_type);
        _houseId = int(d.id_house);
        _eatId = int(d.id_eat);
        _name = String(g.managerLanguage.allTexts[int(d.name)]);
        if (d.name2 == 'undefined' || d.name2 == '' || d.name2 == null || d.name2 == 'null') _name2 = '';
            else _name2 = d.name2;
        if (_name2 != '') _name2 = String(g.managerLanguage.allTexts[int(d.name2)]);
        var ar:Array = Utils.intArray(String(d.cost).split('&'));
        _costBlue = ar[0];
        _costRed = ar[1];
        _costGreen = ar[2];
        _costYellow = ar[3];
        _maxCount = int(d.cost_hard);
        _blockByLevel = Utils.intArray(String(d.block_by_level).split('&'));
        _costHard = int(d.cost_hard);
        _buildTime = int(d.build_time);
        _xp = int(d.xp);
        _shopIcon = d.shop_icon;
        _idCraft = int(d.id_craft);
        _url = d.url;
        _image = d.image;
        if (int(d.currency) > 2) {
            _currency = [];
            if (_costBlue) _currency.push(DataMoney.BLUE_COUPONE);
            if (_costRed) _currency.push(DataMoney.RED_COUPONE);
            if (_costGreen) _currency.push(DataMoney.GREEN_COUPONE);
            if (_costYellow) _currency.push(DataMoney.YELLOW_COUPONE);
        } else _currency = [int(d.currency)];
    }

    public function get id():int { return _id; }
    public function get petType():int { return _petType; }
    public function get houseId():int { return _houseId; }
    public function get eatId():int { return _eatId; }
    public function get craftId():int { return _idCraft; }
    public function get name():String { if (_name2 != '') return _name2; else return _name; }
    public function get nameGlobal():String { return _name; }
    public function get url():String { return _url; }
    public function get image():String { return _image; }
    public function get name2():String { return _name2; }
    public function get shopIcon():String { return _shopIcon; }
    public function get costBlue():int { return _costBlue; }
    public function get costRed():int { return _costRed; }
    public function get costGreen():int { return _costGreen; }
    public function get costYellow():int { return _costYellow; }
    public function get costHard():int { return _costHard; }
    public function get maxCount():int { return _maxCount; }
    public function get xp():int { return _xp; }
    public function get buildTime():int { return _buildTime; }
    public function get blockByLevel():Array { return _blockByLevel; }
    public function get buildType():int { return BuildType.PET; }  // means pet type
    public function get currency():Array { return _currency; }
}
}
