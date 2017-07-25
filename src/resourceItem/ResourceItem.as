/**
 * Created by user on 6/10/15.
 */
package resourceItem {
import data.BuildType;
import data.DataMoney;
import data.StructureDataResource;

public class ResourceItem {
    private var _data:Object;
    private var _id:int;
    private var _name:String;
    private var _url:String;
    private var _imageShop:String;
    private var _currency:int;
    private var _costMax:int;
    private var _costMin:int;
    private var _priceHard:int; 
    private var _priceSkipHard:int;
    private var _blockByLevel:int;
    private var _buildTime:int;
    private var _buildType:int;
    public var craftXP:int;
    public var leftTime:int;
    public var delayTime:int;
    public var staticDelayTime:int;
    public var currentRecipeID:int;
    public var placeBuild:int;
    public var idFromServer:String; // в табличке user_recipe_fabrica
    public function ResourceItem() {}

    public function fillIt(dataResource:StructureDataResource):void {
        _data = dataResource;

        dataResource.id ?_id = dataResource.id : _id = -1;
        dataResource.name ?_name = dataResource.name : _name = 'noName';
        dataResource.url ? _url = dataResource.url : _url = '';
        dataResource.imageShop ? _imageShop = dataResource.imageShop : _imageShop = '';
        dataResource.currency ? _currency = dataResource.currency : _currency = DataMoney.HARD_CURRENCY;
        dataResource.costMax ? _costMax = dataResource.costMax : _costMax = 0;
        dataResource.priceHard ? _priceHard = dataResource.priceHard : _priceHard = 10000;
        dataResource.priceSkipHard ? _priceSkipHard = dataResource.priceSkipHard : _priceSkipHard = 10000;
        dataResource.blockByLevel ? _blockByLevel = dataResource.blockByLevel : _blockByLevel = 1;
        dataResource.buildTime ? _buildTime = int(dataResource.buildTime) : _buildTime = 30;
        dataResource.buildType ? _buildType = dataResource.buildType : _buildType = 0;
        dataResource.craftXP ? craftXP = dataResource.craftXP : craftXP = 1;
        dataResource.placeBuild ? placeBuild = dataResource.placeBuild : BuildType.PLACE_NONE;
        leftTime = _buildTime;
        currentRecipeID= 0;
        delayTime = 0;
        staticDelayTime = 0;
    }

    public function get resourceID():int { return _id}
    public function get name():String { return _name}
    public function get url():String { return _url}
    public function get imageShop():String { return _imageShop}
    public function get currency():int { return _currency}
    public function get costMax():int { return _costMax}
    public function get priceHard():int { return _priceHard}
    public function get priceSkipHard():int { return _priceSkipHard}
    public function get blockByLevel():int { return _blockByLevel}
    public function get buildType():int { return _buildType}
    public function get buildTime():int { return _buildTime}
}
}
