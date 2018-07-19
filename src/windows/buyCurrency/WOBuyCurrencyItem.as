/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import analytic.AnalyticManager;
import com.junkbyte.console.Cc;
import data.DataMoney;
import flash.display.StageDisplayState;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.ManagerLanguage;
import manager.Vars;
import resourceItem.newDrop.DropObject;
import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

public class WOBuyCurrencyItem {
    public var source:Sprite;
    private var _btn:CButton;
    private var _txtCount:CTextField;
//    private var _action:Sprite;
    private var _currency:int;
    private var _countGameMoney:int;
    private var _packId:int;
    private var g:Vars = Vars.getInstance();
    private var _isActiveClick:Boolean;
    private var _callbackBuy:Function;

    public function WOBuyCurrencyItem(currency:int, count:int, bonus:Array, cost:Number, packId:int, sale:int, callback:Function) {
        _isActiveClick = false;
        _callbackBuy = callback;
        _currency = currency;
        _packId = packId;
        _countGameMoney = count;
        source = new Sprite();
        var im:Image = new Image(g.allData.atlas['bankAtlas'].getTexture('bank_panel_cell'));
        im.x = -2;
        im.y = -1;
        source.addChild(im);
        _btn = new CButton();
        _btn.addButtonTexture(230, CButton.HEIGHT_32, CButton.GREEN, true);
        _btn.x = 116;
        _btn.y = 240;
        source.addChild(_btn);
        var valuta:String;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) valuta = ' '+ String(g.managerLanguage.allTexts[330]);
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID)  valuta = ' ' + String(g.managerLanguage.allTexts[328]);
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID ) valuta = ' USD';
        _btn.addTextField(230, 31, 0, 0, String(cost) + ' ' + valuta);
        _btn.setTextFormat(CTextField.BOLD30, 26, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);

        _txtCount = new CTextField(230, 38, String(count));
        if (sale > 0 && g.userTimer.stockTimerToEnd > 0) _txtCount.text = String(count - sale);
        _txtCount.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);
        source.addChild(_txtCount);
        if (bonus[0] > 0) {
            if (g.user.language == ManagerLanguage.RUSSIAN) im = new Image(g.allData.atlas['bankAtlas'].getTexture('best_price_purple_rus'));
            else im = new Image(g.allData.atlas['bankAtlas'].getTexture('best_price_purple_eng'));
            im.x = 163;
            if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) {
                MCScaler.scale(im,im.height/1.6, im.width/1.6);
                im.x = 155;
            } else {
                MCScaler.scale(im,im.height/1.4, im.width/1.4);
                im.y = -9;
            }
            source.addChild(im);
        }

        if (bonus[1] > 0) {
            if (g.user.language == ManagerLanguage.RUSSIAN) im = new Image(g.allData.atlas['bankAtlas'].getTexture('top_red_rus'));
            else im = new Image(g.allData.atlas['bankAtlas'].getTexture('top_red_eng'));
            im.x = 163;
            if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) {
                MCScaler.scale(im,im.height/1.6, im.width/1.6);
                im.x = 155;
            } else {
                MCScaler.scale(im,im.height/1.4, im.width/1.4);
                im.y = -9;
            }
            source.addChild(im);
        }
        _btn.clickCallback = onClick;
        addIcon();
    }

    private function addIcon():void {
        var st:String;
        switch (_packId) {
            case 1: st = 'bank_rubins_1'; break;
            case 2: st = 'bank_rubins_2'; break;
            case 3: st = 'bank_rubins_3'; break;
            case 4: st = 'bank_rubins_4'; break;
            case 5: st = 'bank_rubins_5'; break;
            case 6: st = 'bank_rubins_6'; break;
            case 7: st = 'bank_coins_1'; break;
            case 8: st = 'bank_coins_2'; break;
            case 9: st = 'bank_coins_3'; break;
            case 10: st = 'bank_coins_4'; break;
            case 11: st = 'bank_coins_5'; break;
            case 12: st = 'bank_coins_6'; break;
        }
        var im:Image = new Image(g.allData.atlas['bankAtlas'].getTexture(st));
        im.alignPivot();
        im.x = 117;
        im.y = 135;
        source.addChild(im);
    }

    private function onClick():void {
        if (_isActiveClick) return;
        _isActiveClick = true;
        if (g.isDebug) {
            onBuy();
            g.socialNetwork.showOrderWindow({id: _packId, type:'item'});
        } else {
            if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) g.optionPanel.makeFullScreen();
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
            g.socialNetwork.showOrderWindow({id: _packId, type:'item'});
            Cc.info('try to buy packId: ' + _packId);
        }
    }

    private function orderWindowSuccessHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Seccuss for buy pack');
        if (_currency == DataMoney.HARD_CURRENCY) {
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_HARD_FOR_REAL, {id: _packId});
        } else {
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_SOFT_FOR_REAL, {id: _packId});
        }
        _isActiveClick = false;
        onBuy();
    }

    private function orderWindowFailHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Fail for buy pack');
        _isActiveClick = false;
    }

    private function onBuy():void {
        if (_callbackBuy != null) {
            _callbackBuy.apply();
        }
        var p:Point = new Point(120, 150);
        p = source.localToGlobal(p);
        p.x += 30;
        p.y += 30;
        var d:DropObject = new DropObject();
        d.addDropMoney(_currency, _countGameMoney, p);
        d.releaseIt(null, false);
    }

    public function deleteIt():void {
        if (!source) return;
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        source.removeChild(_btn);
        _btn.deleteIt();
        source.removeChild(_txtCount);
        _txtCount.deleteIt();
//        while (_action.numChildren) {
//            _action.removeChildAt(0);
//        }
//        _action.dispose();
//        _action = null;
        g = null;
        source.dispose();
        source = null;
    }
}
}
