/**
 * Created by user on 2/24/17.
 */
package data {
import manager.Vars;

public class StructureDataResource {
    private var _id:int = -1;
    private var _blockByLevel:int = 1;
    private var _priceHard:int = 10;
    private var _name:String = 'smth';
    private var _url:String;
    private var _imageShop:String;
    private var _currency:int;
    private var _costDefault:int;
    private var _costMax:int;
    private var _visitorPrice:int;
    private var _buildType:int;
    private var _placeBuild:int;
    private var _orderType:int;
    private var _opys:String;
    private var _priceSkipHard:int;
    private var _buildTime:int;
    private var _craftXP:int=0;
    private var _craftCoin:int=0;
    private var _craftRubin:int=0;
    private var _image:String;
    private var _orderCoinMin:int = 1;
    private var _orderCoinMax:int = 1;
    private var _orderXPMin:int = 1;
    private var _orderXPMax:int = 1;
    private var _energyCount:int = 1;
    private var _ingredientsId:Array;
    private var _ingredientsCount:Array;
    private var g:Vars = Vars.getInstance();

    public function StructureDataResource(ob:Object) {
        if (ob.id) _id = int(ob.id);
        if (ob.block_by_level) _blockByLevel = int(ob.block_by_level);
        if (ob.cost_hard) _priceHard = int(ob.cost_hard);
        if (ob.text_id_name) _name = String(g.managerLanguage.allTexts[int(ob.text_id_name)]);
        if (ob.text_id_description) _opys = g.managerLanguage.allTexts[ob.text_id_description];
        if (ob.url) _url = ob.url;
        if (ob.image_shop) _imageShop = ob.image_shop;
        if (ob.currency) _currency = int(ob.currency);
        if (ob.cost_default) _costDefault = int(ob.cost_default);
        if (ob.cost_max) _costMax = int(ob.cost_max);
        if (ob.visitor_price) _visitorPrice = int(ob.visitor_price);
        if (ob.resource_type) _buildType = int(ob.resource_type);
        if (ob.resource_place) _placeBuild = int(ob.resource_place);
        if (ob.order_type) _orderType = int(ob.order_type);
        if (ob.image) _image = ob.image;
        if (ob.cost_skip) _priceSkipHard = int(ob.cost_skip);
        if (ob.build_time) _buildTime = int(ob.build_time);
        if (ob.craft_xp) _craftXP = int(ob.craft_xp);
        if (ob.craft_coin) _craftCoin = int(ob.craft_coin);
        if (ob.craft_rubin) _craftRubin = int(ob.craft_rubin);
        if (ob.order_coin_min) _orderCoinMin = int(ob.order_coin_min);
        if (ob.order_coin_max) _orderCoinMax = int(ob.order_coin_max);
        if (ob.order_xp_min) _orderXPMin = int(ob.order_xp_min);
        if (ob.order_xp_max) _orderXPMax = int(ob.order_xp_max);
        if (ob.energy_count) {
            _energyCount = int(ob.energy_count);
        }
        if (ob.ingredients_id) {
            _ingredientsId = [];
            ob.ingrId = String(ob.ingredients_id).split('&');
            for (var k:int = 0; k < ob.ingrId.length; k++) _ingredientsId[k] = int(ob.ingrId[k]);
        }
        if (ob.ingredients_count) {
            _ingredientsCount = [];
            ob.ingrCou = String(ob.ingredients_count).split('&');
            for (var j:int = 0; j < ob.ingrCou.length; j++) _ingredientsCount[j] = int(ob.ingrCou[j]);
        }
    }

    public function get id():int {return _id;}
    public function get blockByLevel():int {return _blockByLevel;}
    public function get priceHard():int {return _priceHard;}
    public function get name():String {return _name;}
    public function get image():String {return _image;}
    public function get url():String {return _url;}
    public function get imageShop():String {return _imageShop;}
    public function get currency():int {return _currency;}
    public function get costDefault():int {return _costDefault;}
    public function get costMax():int {return _costMax;}
    public function get visitorPrice():int {return _visitorPrice;}
    public function get buildType():int {return _buildType;}
    public function get placeBuild():int {return _placeBuild;}
    public function get orderType():int {return _orderType;}
    public function get opys():String {return _opys;}
    public function get priceSkipHard():int {return _priceSkipHard;}
    public function get buildTime():int {return _buildTime;}
    public function get craftXP():int {return _craftXP;}
    public function get craftCoin():int {return _craftXP;}
    public function get craftRubin():int {return _craftXP;}
    public function get orderPriceMin():int { return _orderCoinMin; }
    public function get orderPriceMax():int { return _orderCoinMax; }
    public function get orderXPMin():int { return _orderXPMin; }
    public function get orderXPMax():int { return _orderXPMax; }
    public function get energyCount():int { return _energyCount; }
    public function get ingredientsId():Array { return _ingredientsId; }
    public function get ingredientsCount():Array { return _ingredientsCount; }

}
}
