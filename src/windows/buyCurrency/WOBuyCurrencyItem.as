/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import analytic.AnalyticManager;

import com.junkbyte.console.Cc;

import data.DataMoney;

import flash.display.StageDisplayState;
import flash.geom.Point;
import flash.geom.Rectangle;

import manager.ManagerFilters;
import manager.ManagerLanguage;
import manager.Vars;
import resourceItem.DropItem;

import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WindowsManager;

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

    public function WOBuyCurrencyItem(currency:int, count:int, bonus:Array, cost:Number, packId:int, sale:int) {
        _isActiveClick = false;
        _currency = currency;
        _packId = packId;
        _countGameMoney = count;
        source = new Sprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bank_panel_cell'));
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
        _btn.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);

        _txtCount = new CTextField(230, 38, String(count));
        if (sale > 0 && g.userTimer.stockTimerToEnd > 0) _txtCount.text = String(count - sale);
        _txtCount.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        source.addChild(_txtCount);
//        var txt:CTextField;
//        if (sale > 0 && g.userTimer.stockTimerToEnd > 0) {
//            txt = new CTextField(135, 52, '+ ' + String(sale));
//            txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.RED_COLOR);
//            txt.alignH = Align.LEFT;
//            txt.x = 70 + _txtCount.textBounds.width + 5;
//            txt.y = 4;
//            source.addChild(txt);
//            _arrCTex.push(txt);
//        }

//        _action = new Sprite();
//        var im:Image;
//        if (sale > 0 && g.userTimer.stockTimerToEnd > 0) {
//            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('sale_icon'));
//            _action.addChild(im);
//            txt = new CTextField(60, 30, String(g.managerLanguage.allTexts[454]));
//            txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.PINK_COLOR);
//            txt.y = 12;
//            _action.addChild(txt);
//            _arrCTex.push(txt);
//            source.addChild(_action);
//            _action.x = 350;
//        } else {
//            if (bonus[0] == 1) {
//                if (g.user.language == ManagerLanguage.RUSSIAN) im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('best_price'));
//                else im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('best_price_eng'));
//                im.x = 280;
//                source.addChild(im);
//            } else if (bonus[0] == 2) {
//                if (g.user.language == ManagerLanguage.RUSSIAN) im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('top_sells'));
//                else im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('top_eng'));
//                im.x = 280;
//                source.addChild(im);
//            }
//            if (bonus[1] > 0) {
//                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bonus'));
//                _action.addChild(im);
//                txt = new CTextField(60, 30, bonus[1] + '%');
//                txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.ORANGE_COLOR);
//                txt.y = 5;
//                _action.addChild(txt);
//                txt = new CTextField(60, 30, String(g.managerLanguage.allTexts[354]));
//                txt.y = 20;
//                txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.ORANGE_COLOR);
//                _arrCTex.push(txt);
//                _action.addChild(txt);
//                source.addChild(_action);
//                _action.x = 350;
//            }
//        }
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
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture(st));
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
            g.socialNetwork.showOrderWindow({id: _packId});
        } else {
            if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) g.optionPanel.makeFullScreen();
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
            g.socialNetwork.showOrderWindow({id: _packId});
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
        var obj:Object;
        obj = {};
        obj.count = _countGameMoney;
        var p:Point = new Point(120, 150);
        p = source.localToGlobal(p);
        obj.id =  _currency;
        new DropItem(p.x + 30, p.y + 30, obj);
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
