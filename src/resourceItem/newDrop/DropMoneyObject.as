/**
 * Created by andy on 12/1/17.
 */
package resourceItem.newDrop {
import data.DataMoney;
import flash.geom.Point;
import starling.display.Image;

public class DropMoneyObject extends DropObjectInterface{
    private var _type:int;
    private var _count:int;

    public function DropMoneyObject() {
        super();
    }

    public function fillIt(type:int, count:int, p:Point):void {
        _type = type;
        _count = count;
        switch (_type) {
            case DataMoney.HARD_CURRENCY:  _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("rubins")); break;
            case DataMoney.SOFT_CURRENCY:  _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("coins")); break;
            case DataMoney.BLUE_COUPONE:   _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone')); break;
            case DataMoney.GREEN_COUPONE:  _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone')); break;
            case DataMoney.RED_COUPONE:    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone')); break;
            case DataMoney.YELLOW_COUPONE: _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone')); break;
        }
        onCreateImage();
        setStartPoint(p);
    }
    
    override public function flyIt(p:Point = null, needJoggle:Boolean = false):void {
        var d:DropMoneyObject = this;
        if (_type == DataMoney.HARD_CURRENCY) p = g.softHardCurrency.getHardCurrencyPoint();
            else if (_type == DataMoney.SOFT_CURRENCY) p = g.softHardCurrency.getSoftCurrencyPoint();
            else p = g.couponePanel.getPoint();
        var f:Function = _flyCallback;
        _flyCallback = function():void {
            g.userInventory.addMoney(_type, _count);
            if (_type == DataMoney.HARD_CURRENCY) g.softHardCurrency.animationBuy(true);
            else if (_type == DataMoney.SOFT_CURRENCY)  g.softHardCurrency.animationBuy(false);
            else g.couponePanel.animationBuy();
            g.userInventory.updateMoneyTxt(_type);
            if (g.managerTips) g.managerTips.calculateAvailableTips();
            if (f!=null) f.apply(null, [d]);
        };
        super.flyIt(p);
    }

}
}
