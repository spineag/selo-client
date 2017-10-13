/**
 * Created by user on 6/24/15.
 */
package resourceItem.money {
import data.DataMoney;
import manager.Vars;
import starling.display.Sprite;
import utils.Utils;

public class DropMoney {

    private var _source:Sprite;
    private var _count:int;
    private var _countIn:int;
    private var g:Vars = Vars.getInstance();

    public function DropMoney(_x:int, _y:int, count:int, type:int) {
        _source = new Sprite();
        _source.touchable = false;
        _count = count;
        _countIn = 0;
        g.userInventory.dropItemMoney(type, count);
        if (type == DataMoney.SOFT_CURRENCY) g.managerAchievement.achievementCountSoft(g.user.softCurrencyCount + count);
        var item:DropMoneyItem;
        var i:int;
        if (_count > 5) {
            var c:int = _count%5;
            var cd:int = int(_count/5);
            for (i = 0; i < 5; i++) {
                var f1:Function = function (k:int):void {
                    if (c>0) {
                        c--;
                        item = new DropMoneyItem(_x, _y, cd + 1, type, endFly);
                    } else item = new DropMoneyItem(_x, _y, cd, type, endFly);
                    _source.addChild(item.source);
                };
                Utils.createDelay(Math.random(), function():void { f1(i); });
            }
        } else if (_count <= 5) {
            for (i = 0; i < _count; i++ ) {
                var f2:Function = function ():void {
                    item = new DropMoneyItem(_x, _y, 1, type, endFly);
                    _source.addChild(item.source);
                };
                Utils.createDelay(Math.random(), f2);
            }
        }
        g.cont.animationsResourceCont.addChild(_source);
    }

    private function endFly():void {
        _countIn++;
        if (_count > 5 && _countIn == 5) {
            _countIn = 0;
            g.cont.animationsResourceCont.removeChild(_source);
        } else if (_count <= 5 && _countIn == _count){
            _countIn = 0;
            g.cont.animationsResourceCont.removeChild(_source);
        }
    }
}
}
