/**
 * Created by user on 6/24/15.
 */
package resourceItem {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import resourceItem.money.DropMoney;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;
import temp.DropResourceVariaty;
import utils.CTextField;
import utils.MCScaler;
import windows.WindowsManager;

public class DropItem {
    private var _source:Sprite;
    private var _image:Image;
    private var g:Vars = Vars.getInstance();

    public function DropItem(_x:int, _y:int, prise:Object, delay:Number = .3, startSize:int = 50) {
        var endPoint:Point;
        if (!prise) {
            Cc.error('DropItem:: prise == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'dropItem');
            return;
        }

        _source = new Sprite();
        if (prise.type == DropResourceVariaty.DROP_TYPE_DECOR_ANIMATION || prise.type == DropResourceVariaty.DROP_TYPE_DECOR) { // better use DropDecor
            new DropDecor(_x, _y, g.allData.getBuildingById(prise.id), 100, 100, prise.count);
            return;
        } else if (prise.type == DropResourceVariaty.DROP_TYPE_RESOURSE) {
            _image = new Image(g.allData.atlas[g.allData.getResourceById(prise.id).url].getTexture(g.allData.getResourceById(prise.id).imageShop));
            g.craftPanel.showIt(BuildType.PLACE_SKLAD);
            endPoint = g.craftPanel.pointXY();
            g.updateAmbarIndicator();
            g.userInventory.addResource(prise.id, prise.count);
        } else {
            switch (prise.id) {
                case DataMoney.HARD_CURRENCY:
                    new DropMoney(_x, _y, prise.count, DataMoney.HARD_CURRENCY);
                    return;
                case DataMoney.SOFT_CURRENCY:
                    new DropMoney(_x, _y, prise.count, DataMoney.SOFT_CURRENCY);
                    return;
                case DataMoney.BLUE_COUPONE:
                    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone'));
                    endPoint = g.couponePanel.getPoint();
                    break;
                case DataMoney.GREEN_COUPONE:
                    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone'));
                    endPoint = g.couponePanel.getPoint();
                    break;
                case DataMoney.RED_COUPONE:
                    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone'));
                    endPoint = g.couponePanel.getPoint();
                    break;
                case DataMoney.YELLOW_COUPONE:
                    _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone'));
                    endPoint = g.couponePanel.getPoint();
                    break;
            }
            g.userInventory.dropItemMoney(prise.id, prise.count);
        }
        if (!_image) {
            Cc.error('DropItem:: no image for type: ' + prise.id + ' ' + prise.type);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'dropItem');
            return;
        }
        MCScaler.scale(_image, startSize, startSize);
        var txt:CTextField = new CTextField(70,30,'+' + String(prise.count));
        txt.setFormat(CTextField.BOLD18, int(18*startSize/50), Color.WHITE, ManagerFilters.BROWN_COLOR);
        txt.x = -15;
        txt.y = _image.height - 5;
        _source.addChild(_image);
        _source.pivotX = _source.width / 2;
        _source.pivotY = _source.height / 2;
        _source.addChild(txt);
        _source.x = _x;
        _source.y = _y;
        g.cont.animationsResourceCont.addChild(_source);

        var f1:Function = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source = null;
            if (prise.type == DropResourceVariaty.DROP_TYPE_RESOURSE) {
                var item:ResourceItem = new ResourceItem();
                item.fillIt(g.allData.getResourceById(prise.id));
                g.craftPanel.afterFly(item);
            } else {
                switch (prise.id) {
                    case DataMoney.BLUE_COUPONE:
                        g.couponePanel.animationBuy();
                        break;
                    case DataMoney.GREEN_COUPONE:
                        g.couponePanel.animationBuy();
                        break;
                    case DataMoney.RED_COUPONE:
                        g.couponePanel.animationBuy();
                        break;
                    case DataMoney.YELLOW_COUPONE:
                        g.couponePanel.animationBuy();
                        break;
                }
                g.userInventory.updateMoneyTxt(prise.id);
                if (g.managerTips) g.managerTips.calculateAvailableTips();
            }
        };
        var tempX:int = _source.x - 140 + int(Math.random()*140);
        var tempY:int = _source.y - 40 + int(Math.random()*140);
        var dist:int = int(Math.sqrt((_source.x - tempX)*(_source.x - tempX) + (_source.y - tempY)*(_source.y - tempY)));
        dist += int(Math.sqrt((tempX - endPoint.x)*(tempX - endPoint.x) + (tempY - endPoint.y)*(tempY - endPoint.y)));
        var t:Number = dist/1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        if (startSize != 50) {
            var scale:Number = _image.scaleX / (startSize/50);
            new TweenMax(_source, t, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], scaleX:scale, scaleY:scale, ease:Linear.easeOut ,onComplete: f1, delay: delay});
        } else new TweenMax(_source, t, {bezier:[{x:tempX, y:tempY}, {x:endPoint.x, y:endPoint.y}], ease:Linear.easeOut ,onComplete: f1, delay: delay});
    }
}
}
