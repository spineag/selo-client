/**
 * Created by user on 2/27/17.
 */
package data {
import manager.Vars;

import social.SocialNetworkSwitch;

import utils.Utils;

import utils.Utils;

import utils.Utils;


public class StructureDataBuilding {
    private var _blockByLevel:Array;
    private var _buildTime:Array;
    private var _buildType:int;
    private var _catNeed:Boolean;
    private var _color:String;
    private var _ratingCount:int;
    private var _cost:Array;
    private var _costSeparate:Array;
    private var _currency:Array;
    private var _deltaCost:int;
    private var _filterType:int;
    private var _group:int;
    private var _height:int;
    private var _id:int;
    private var _image:String;
    private var _innerX:*;
    private var _innerY:*;
    private var _maxAnimalsCount:int;
    private var _name:String;
    private var _priceSkipHard:int;
    private var _startCountCell:int;
    private var _url:String;
    private var _visibleAction:Boolean;
    private var _visibleTester:Boolean;
    private var _width:int;
    private var _xpForBuild:int;
    private var _countUnblock:int;
    private var _craftIdResource:int;
    private var _countCraftResource:Array;
    private var _removeByResourceId:int;
    private var _startCountResources:int;
    private var _deltaCountResources:int;
    private var _startCountInstrumets:int;
    private var _deltaCountAfterUpgrade: int;
    private var _upInstrumentId1:int;
    private var _upInstrumentId2:int;
    private var _upInstrumentId3:int;
    private var _imageActive:String;
    private var _idResource:Array;
    private var _idResourceRaw:Array;
    private var _variaty:Array;
    private var g:Vars = Vars.getInstance();
    private var _dailyBonus:Boolean;
    private var _beforeInventory:int = 0;

    public function StructureDataBuilding(ob:Object) {
        var obj:Object = {};
        var k:int;
        _innerX =[];
        _innerY =[];
        _id = int(ob.id);
        _width = int(ob.width);
        _height = int(ob.height);
        if (ob.inner_x) {
            obj.innerX = Utils.intArray(String(ob.inner_x).split('&'));
            if (obj.innerX.length == 1) {
                obj.innerX = int(obj.innerX[0]) * g.scaleFactor;
            } else if (obj.innerX.length) {
                for (k = 0; k < obj.innerX.length; k++) {
                    obj.innerX[k] = int(obj.innerX[k]) * g.scaleFactor;
                }
            }
            obj.innerY = Utils.intArray(String(ob.inner_y).split('&'));
            if (obj.innerY.length == 1) {
                obj.innerY = int(obj.innerY[0]) * g.scaleFactor;
            } else if (obj.innerY.length) {
                for (k = 0; k < obj.innerY.length; k++) {
                    obj.innerY[k] = int(obj.innerY[k]) * g.scaleFactor;
                }
            }
        }

        _name = String(g.managerLanguage.allTexts[int(ob.text_id)]);
        _url = ob.url;
        _image = ob.image;
        _xpForBuild = int(ob.xp_for_build);
        _buildType = int(ob.build_type);

        if (_id == 75) {
            _buildType = BuildType.DECOR_FENCE_GATE;
            obj.innerX = [];
            obj.innerY = [];
            obj.innerX.push(-50 * g.scaleFactor); obj.innerY.push(-35 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-5 * g.scaleFactor); obj.innerY.push(-21 * g.scaleFactor); // second part of gate
            obj.innerX.push(-45 * g.scaleFactor); obj.innerY.push(0 * g.scaleFactor); // second part for shop view
            obj.innerX.push(45 * g.scaleFactor);  obj.innerY.push(-34 * g.scaleFactor); // line for main part
            obj.innerX.push(-36 * g.scaleFactor); obj.innerY.push(10 * g.scaleFactor); // line for second part
            // main part if is open
            // second part if is open
        }
        if (_id == 77) {
            _buildType = BuildType.DECOR_FENCE_GATE;
            obj.innerX = [];
            obj.innerY = [];
            obj.innerX.push(-46 * g.scaleFactor); obj.innerY.push(-26 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-16 * g.scaleFactor); obj.innerY.push(-19 * g.scaleFactor); // second part of gate
            obj.innerX.push(-59 * g.scaleFactor); obj.innerY.push(1 * g.scaleFactor); // second part for shop view
            obj.innerX.push(42 * g.scaleFactor);  obj.innerY.push(-34 * g.scaleFactor); // line for main part
            obj.innerX.push(-43 * g.scaleFactor); obj.innerY.push(11 * g.scaleFactor); // line for second part
            // main part if is open
            // second part if is open
        }
        if (_id == 76) {
            _buildType = BuildType.DECOR_FENCE_GATE;
            obj.innerX = [];
            obj.innerY = [];
            obj.innerX.push(-42 * g.scaleFactor); obj.innerY.push(-26 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-17 * g.scaleFactor); obj.innerY.push(-11 * g.scaleFactor); // second part of gate
            obj.innerX.push(-60 * g.scaleFactor); obj.innerY.push(9 * g.scaleFactor); // second part for shop view
            obj.innerX.push(51 * g.scaleFactor);  obj.innerY.push(-34 * g.scaleFactor); // line for main part
            obj.innerX.push(-36 * g.scaleFactor); obj.innerY.push(13 * g.scaleFactor); // line for second part
            // main part if is open
            // second part if is open
        }
        if (_id == 78) {
            _buildType = BuildType.DECOR_FENCE_GATE;
            obj.innerX = [];
            obj.innerY = [];
            obj.innerX.push(-58 * g.scaleFactor); obj.innerY.push(-37 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-15 * g.scaleFactor); obj.innerY.push(-37 * g.scaleFactor); // second part of gate
            obj.innerX.push(-57 * g.scaleFactor); obj.innerY.push(-17 * g.scaleFactor); // second part for shop view
            obj.innerX.push(48 * g.scaleFactor);  obj.innerY.push(-41 * g.scaleFactor); // line for main part
            obj.innerX.push(-40 * g.scaleFactor); obj.innerY.push(2 * g.scaleFactor); // line for second part
            // main part if is open
            // second part if is open
        }
        if (_id == 74) {
            _buildType = BuildType.DECOR_POST_FENCE_ARKA;
            obj.innerX = [];
            obj.innerY = [];
            obj.innerX.push(-150 * g.scaleFactor); obj.innerY.push(-141 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-61 * g.scaleFactor); obj.innerY.push(-185 * g.scaleFactor); // second part of gate
            obj.innerX.push(-147 * g.scaleFactor); obj.innerY.push(-143 * g.scaleFactor); // second part for shop view
            obj.innerX.push(47 * g.scaleFactor); obj.innerY.push(-47 * g.scaleFactor); // line for main part
            obj.innerX.push(-81 * g.scaleFactor); obj.innerY.push(17 * g.scaleFactor); // line for second part
        }
        if (_id == 205) {
            _buildType = BuildType.DECOR_POST_FENCE_ARKA;
            obj.innerX = [];
            obj.innerY = [];
            obj.innerX.push(-52 * g.scaleFactor); obj.innerY.push(-174 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-71 * g.scaleFactor); obj.innerY.push(-189 * g.scaleFactor); // second part of gate
            obj.innerX.push(-156 * g.scaleFactor); obj.innerY.push(-147 * g.scaleFactor); // second part for shop view
            obj.innerX.push(47 * g.scaleFactor); obj.innerY.push(-47 * g.scaleFactor); // line for main part
            obj.innerX.push(-83 * g.scaleFactor); obj.innerY.push(17 * g.scaleFactor); // line for second part
        }
        if (_id == 73) {
            _buildType = BuildType.DECOR_POST_FENCE_ARKA;
            obj.innerX = [];
            obj.innerY = [];
            obj.innerX.push(-46 * g.scaleFactor); obj.innerY.push(-116 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-58 * g.scaleFactor); obj.innerY.push(-163 * g.scaleFactor); // second part of gate
            obj.innerX.push(-142 * g.scaleFactor); obj.innerY.push(-120 * g.scaleFactor); // second part for shop view
            obj.innerX.push(49 * g.scaleFactor); obj.innerY.push(-34 * g.scaleFactor); // line for main part
            obj.innerX.push(-76 * g.scaleFactor); obj.innerY.push(28 * g.scaleFactor); // line for second part
        }
        if (_id == 72) {
            _buildType = BuildType.DECOR_POST_FENCE_ARKA;
            obj.innerX = [];
            obj.innerY = [];
            obj.innerX.push(-9 * g.scaleFactor); obj.innerY.push(-167 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-57 * g.scaleFactor); obj.innerY.push(-228 * g.scaleFactor); // second part of gate
            obj.innerX.push(-140 * g.scaleFactor); obj.innerY.push(-186 * g.scaleFactor); // second part for shop view
            obj.innerX.push(43 * g.scaleFactor); obj.innerY.push(-36 * g.scaleFactor); // line for main part
            obj.innerX.push(-83 * g.scaleFactor); obj.innerY.push(26 * g.scaleFactor); // line for second part
        }
        if (_id == 71) {
            _buildType = BuildType.DECOR_POST_FENCE_ARKA;
            obj.innerX = [];
            obj.innerY = [];
            obj.innerX.push(-150 * g.scaleFactor); obj.innerY.push(-204 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-66*g.scaleFactor); obj.innerY.push(-243 * g.scaleFactor); // second part of gate
            obj.innerX.push(-150 * g.scaleFactor); obj.innerY.push(-200 * g.scaleFactor); // second part for shop view
            obj.innerX.push(42 * g.scaleFactor); obj.innerY.push(-34 * g.scaleFactor); // line for main part
            obj.innerX.push(-85 * g.scaleFactor); obj.innerY.push(29 * g.scaleFactor); // line for second part
        }

        if (_id == 92) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-57 * g.scaleFactor); obj.innerY.push(-192 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-76 * g.scaleFactor); obj.innerY.push(-235 * g.scaleFactor); // second part of gate
            obj.innerX.push(-160 * g.scaleFactor); obj.innerY.push(-192 * g.scaleFactor); // second part for shop view
        }
        if (_id == 94) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-48 * g.scaleFactor); obj.innerY.push(-147 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-69 * g.scaleFactor); obj.innerY.push(-194 * g.scaleFactor); // second part of gate
            obj.innerX.push(-151 * g.scaleFactor); obj.innerY.push(-151 * g.scaleFactor); // second part for shop view
        }
        if (_id == 96) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-58 * g.scaleFactor); obj.innerY.push(-159 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-70 * g.scaleFactor); obj.innerY.push(-198 * g.scaleFactor); // second part of gate
            obj.innerX.push(-155 * g.scaleFactor); obj.innerY.push(-156 * g.scaleFactor); // second part for shop view
        }
        if (_id == 98) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-55 * g.scaleFactor); obj.innerY.push(-155 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-65 * g.scaleFactor); obj.innerY.push(-189 * g.scaleFactor); // second part of gate
            obj.innerX.push(-148 * g.scaleFactor); obj.innerY.push(-148 * g.scaleFactor); // second part for shop view
        }
        if (_id == 176) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-25 * g.scaleFactor); obj.innerY.push(-143 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-58 * g.scaleFactor); obj.innerY.push(-198 * g.scaleFactor); // second part of gate
            obj.innerX.push(-145 * g.scaleFactor); obj.innerY.push(-155 * g.scaleFactor); // second part for shop view
        }
        if (_id == 210) {
            _buildType = BuildType.DECOR_FENCE_ARKA;
            obj.innerX = []; obj.innerY = [];
            obj.innerX.push(-56 * g.scaleFactor); obj.innerY.push(-152 * g.scaleFactor); // main (top) part of gate
            obj.innerX.push(-62 * g.scaleFactor); obj.innerY.push(-190 * g.scaleFactor); // second part of gate
            obj.innerX.push(-148 * g.scaleFactor); obj.innerY.push(-147 * g.scaleFactor); // second part for shop view
        }

        _innerX = obj.innerX;
        _innerY = obj.innerY;

        if (ob.count_cell) _startCountCell = int(ob.count_cell);
        if (ob.currency) _currency = Utils.intArray(String(ob.currency).split('&'));
        if (ob.cost) _cost = Utils.intArray(String(ob.cost).split('&'));
        if (ob.delta_cost) _deltaCost = int(ob.delta_cost);
        if (ob.block_by_level) _blockByLevel = Utils.intArray(String(ob.block_by_level).split('&'));
        if (ob.cost_skip) _priceSkipHard = int(ob.cost_skip);
        if (ob.filter) {
            _filterType = int(ob.filter);
            _beforeInventory = _filterType;
        }
        if (ob.build_time) _buildTime = Utils.intArray(String(ob.build_time).split('&'));
        if (ob.count_unblock) _countUnblock = int(ob.count_unblock);
        if (ob.craft_resource_id) _craftIdResource = int(ob.craft_resource_id);
        if (ob.count_craft_resource) _countCraftResource = Utils.intArray(String(ob.count_craft_resource).split('&'));
        if (ob.instrument_id) _removeByResourceId = int(ob.instrument_id);
        if (ob.start_count_resources) _startCountResources = int(ob.start_count_resources);
        if (ob.delta_count_resources) _deltaCountResources = int(ob.delta_count_resources);
        if (ob.start_count_instruments) _startCountInstrumets = int(ob.start_count_instruments);
        if (ob.delta_count_instruments) _deltaCountAfterUpgrade = int(ob.delta_count_instruments);
        if (ob.up_instrument_id_1) _upInstrumentId1 = int(ob.up_instrument_id_1);
        if (ob.up_instrument_id_2) _upInstrumentId2 = int(ob.up_instrument_id_2);
        if (ob.up_instrument_id_3) _upInstrumentId3 = int(ob.up_instrument_id_3);
        if (ob.max_count) _maxAnimalsCount = int(ob.max_count);
        if (ob.image_active) _imageActive = ob.image_active;
        if (ob.cat_need) _catNeed = Boolean(ob.cat_need == '0');  // '0' - is need, '1' - not need
        if (ob.resource_id) _idResource = Utils.intArray(String(ob.resource_id).split('&'));
        if (ob.raw_resource_id) _idResourceRaw = Utils.intArray(String(ob.raw_resource_id).split('&'));
        if (ob.variaty) _variaty = Utils.intArray(String(ob.variaty).split('&'));
        if (ob.visible) _visibleTester = Boolean(int(ob.visible));
        if (ob.color && ob.color != 'default') _color = String(ob.color);
        if (ob.rating_count) _ratingCount = int(ob.rating_count);
        if (ob.cost_separate) _costSeparate = Utils.intArray(String(ob.cost_separate).split('&'));

        if (ob.group) {
            if (int(ob.group) > 0) {
                _group = int(ob.group);
                g.allData.addToDecorGroup(this);
            }
        }
        if (ob.visibleAction || g.user.isTester) _visibleAction = true;
            else _visibleAction = false;
        if (ob.daily_bonus) _dailyBonus = Boolean(int(ob.daily_bonus));
    }
    
    public function isNewAtLevel(l:int):Boolean {
        if (!_blockByLevel) return false;
        if (_blockByLevel.indexOf(l) > -1) return true;
            else return false;
    }

    public function get blockByLevel():Array{ return _blockByLevel;}
    public function get buildTime():Array{ return _buildTime;}
    public function get buildType():int{ return _buildType;}
    public function get catNeed():Boolean{ return _catNeed;}
    public function get color():String{ return _color;}
    public function get ratingCount():int{ return _ratingCount;}
    public function get cost():Array{ return _cost;}
    public function get costSeparate():Array{ return _costSeparate;}
    public function get currency():Array{ return _currency;}
    public function get deltaCost():int{ return _deltaCost;}
    public function get filterType():int{ return _filterType;}
    public function get group():int{ return _group;}
    public function set sfilter(gr:int):void {_filterType = gr;}
    public function get height():int {return _height;}
    public function get id():int {return _id;}
    public function get image():String{ return _image;}
    public function get innerX():*{ return _innerX;}
    public function get innerY():*{ return _innerY;}
    public function get maxAnimalsCount():int{ return _maxAnimalsCount;}
    public function get name():String {return _name;}
    public function get priceSkipHard():int {return _priceSkipHard;}
    public function get startCountCell():int {return _startCountCell;}
    public function get url():String {return _url;}
    public function get visibleAction():Boolean {return _visibleAction;}
    public function get visibleTester():Boolean {return _visibleTester;}
    public function get width():int {return _width;}
    public function get xpForBuild():int {return _xpForBuild;}
    public function get countUnblock():int {return _countUnblock;}
    public function get craftIdResource():int {return _craftIdResource;}
    public function get countCraftResource():Array {return _countCraftResource;}
    public function get removeByResourceId():int {return _removeByResourceId;}
    public function get startCountResources():int{ return _startCountResources;}
    public function get deltaCountResources():int {return _deltaCountResources;}
    public function get startCountInstrumets():int {return _startCountInstrumets;}
    public function get deltaCountAfterUpgrade():int {return _deltaCountAfterUpgrade;}
    public function get upInstrumentId1():int {return _upInstrumentId1;}
    public function get upInstrumentId2():int{ return _upInstrumentId2;}
    public function get upInstrumentId3():int {return _upInstrumentId3;}
    public function get imageActive():String {return _imageActive;}
    public function get idResource():Array {return _idResource;}
    public function get idResourceRaw():Array {return _idResourceRaw;}
    public function get beforInventroy():int {return _beforeInventory;}
    public function get variaty():Array {return _variaty;}
    public function get dailyBonus():Boolean {return _dailyBonus;}
    
    public function isDecor():Boolean {
        if (_buildType == BuildType.DECOR || _buildType == BuildType.DECOR_FULL_FENСE || _buildType == BuildType.DECOR_POST_FENCE || _buildType == BuildType.DECOR_TAIL
          || _buildType == BuildType.DECOR_ANIMATION || _buildType == BuildType.DECOR_FENCE_GATE || _buildType == BuildType.DECOR_FENCE_ARKA || _buildType == BuildType.DECOR_POST_FENCE_ARKA)
            return true;
        else return false;
    }
}
}
