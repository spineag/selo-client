/**
 * Created by user on 7/12/18.
 */
package windows.salePack.saleThreeOne {
import com.junkbyte.console.Cc;

import data.BuildType;

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
import starling.display.Quad;

import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.BackgroundYellowOut;

public class WOSaleThreeOneItem {
    public var source:Sprite;
    private var _btnBuy:CButton;
    private var _txtLastCost:CTextField;
    private var _txtOldCost:CTextField;
    private var _txtValue:CTextField;
    private var _txtNewCost:CTextField;
    private var _txt:CTextField;
    private var _bgYellow:BackgroundYellowOut;
    private var _bgImage:Image;
    private var _imItem:Image;
    private var _txtCount:CTextField;
    private var _dataSalePack:Object;

    private var g:Vars = Vars.getInstance();

    public function WOSaleThreeOneItem(salePackId:int) {
        for (var i:int = 0; g.managerSalePack.dataSale.length; i++) {
            if (g.managerSalePack.dataSale[i].id == salePackId) {
                _dataSalePack = g.managerSalePack.dataSale[i];
                break;
            }
        }
        source = new Sprite();
        _bgYellow = new BackgroundYellowOut(250,350);
        source.addChild(_bgYellow);

        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(140, CButton.HEIGHT_55, CButton.GREEN, true);
        _btnBuy.addTextField(140, 54, -2, -5, String(g.managerLanguage.allTexts[331]));
        _btnBuy.setTextFormat(CTextField.BOLD72, 45, Color.WHITE, ManagerFilters.GREEN_COLOR);
        source.addChild(_btnBuy);
        _btnBuy.x = 125;
        _btnBuy.y = 315;
        _btnBuy.clickCallback = onClick;
        _bgImage = new Image(g.allData.atlas['bankAtlas'].getTexture('bank_panel_cell'));
        _bgImage.x = 8;
        _bgImage.y = 5;
        source.addChild(_bgImage);
        addIcon();
        var st:String;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            st = ' ' + String(g.managerLanguage.allTexts[328]);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            st = ' Голоса';
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID ) {
            st = ' USD';
        }
        _txtLastCost = new CTextField(250,100,String(g.managerLanguage.allTexts[1242]));
        _txtLastCost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtLastCost.alignH = Align.LEFT;
        _txtLastCost.x = 10;
        _txtLastCost.y = 175;
        source.addChild(_txtLastCost);
        _txtOldCost = new CTextField(200, 100, String(_dataSalePack.oldCost) + st);
        _txtOldCost.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtOldCost.alignH = Align.LEFT;
        _txtOldCost.x = _txtLastCost.x + _txtLastCost.textBounds.width;
        _txtOldCost.y = 173;
        source.addChild(_txtOldCost);

        _txtValue = new CTextField(200,100,String(g.managerLanguage.allTexts[1293]));
        _txtValue.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtValue.alignH = Align.LEFT;
        _txtValue.x = _txtOldCost.x + _txtOldCost.textBounds.width;
        _txtValue.y = 175;
        source.addChild(_txtValue);
        var quad:Quad = new Quad(_txtLastCost.textBounds.width + _txtOldCost.textBounds.width + _txtValue.textBounds.width, 3, Color.RED);
        quad.x = 8;
        quad.y = 228;
        quad.alpha = .6;
        source.addChild(quad);

        _txtNewCost = new CTextField(250,100,String(g.managerLanguage.allTexts[1243]));
        _txtNewCost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtNewCost.alignH = Align.LEFT;
        _txtNewCost.x = 5;
        _txtNewCost.y = 214;
        source.addChild(_txtNewCost);

        _txt = new CTextField(200,100,String(_dataSalePack.newCost) + st);
        _txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.GREEN_COLOR, Color.WHITE);
        _txt.alignH = Align.LEFT;
        _txt.x = _txtNewCost.x + _txtNewCost.textBounds.width;
        _txt.y = 211;
        source.addChild(_txt);

        _txtCount = new CTextField(200,100,String(_dataSalePack.objectCount[0]));
        _txtCount.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCount.alignH = Align.LEFT;
        _txtCount.x = 100;
        _txtCount.y = -25;
        source.addChild(_txtCount);
    }

    private function addIcon():void {
        var st:String;
        var top:Boolean = false;
        var bestPrice:Boolean = false;
        switch (_dataSalePack.objectCount[0]) {
            case 40: st = 'bank_rubins_1'; break;
            case 120: st = 'bank_rubins_2'; break;
            case 250:
                st = 'bank_rubins_3';
                top = true;
                break;
            case 520:
                st = 'bank_rubins_4';
                bestPrice = true;
                break;
            case 1120: st = 'bank_rubins_5'; break;
            case 3000: st = 'bank_rubins_6'; break;
        }
        var im:Image = new Image(g.allData.atlas['bankAtlas'].getTexture(st));
        im.alignPivot();
        im.x = 125;
        im.y = 135;
        source.addChild(im);
        if (top) {
            if (g.user.language ==  ManagerLanguage.ENGLISH)im = new Image(g.allData.atlas['bankAtlas'].getTexture('top_red_eng'));
            else im = new Image(g.allData.atlas['bankAtlas'].getTexture('top_red_rus'));
            MCScaler.scale(im,im.height/1.4, im.width/1.4);
            im.alignPivot();
            im.x = 205;
            im.y = 35;
            source.addChild(im);
        }
        if (bestPrice) {
            if (g.user.language ==  ManagerLanguage.ENGLISH) im = new Image(g.allData.atlas['bankAtlas'].getTexture('best_price_purple_eng'));
            else im = new Image(g.allData.atlas['bankAtlas'].getTexture('best_price_purple_rus'));
            MCScaler.scale(im,im.height/1.4, im.width/1.4);
            im.alignPivot();
            im.x = 205;
            im.y = 35;
            source.addChild(im);
        }
    }

    private function onClick():void {
        if (g.isDebug) {
            onBuy();
        } else {
            if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
                g.optionPanel.makeFullScreen();
            }
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
            g.socialNetwork.addEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
            g.socialNetwork.showOrderWindow({id: _dataSalePack.id, price: int(_dataSalePack.newCost), type:'sale_pack'});
            Cc.info('try to buy packId: ' + _dataSalePack.id);
        }
    }

    private function orderWindowSuccessHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Success for buy pack');
        onBuy();
    }

    private function orderWindowFailHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Fail for buy pack');
    }

    private function onBuy():void {
        g.server.updateUserSalePackBuy(1,_dataSalePack.id,null);
        g.server.updateUserSalePackBuy(1,g.managerSalePack.userSale.saleId,null);
        g.userTimer.saleToEnd(0);
        g.managerParty.userParty.buy = true;
        var p:Point = new Point(0, 0);
        p = source.localToGlobal(p);
        var d:DropObject = new DropObject();
        for (var i:int = 0; i < _dataSalePack.objectId.length; i++) {
            if (_dataSalePack.objectId[i] == 1 && _dataSalePack.objectType[i]  == 1)
                d.addDropMoney(DataMoney.HARD_CURRENCY, _dataSalePack.objectCount[i], p);
            else if (_dataSalePack.objectType[i] == BuildType.INSTRUMENT)
                d.addDropItemNewByResourceId(_dataSalePack.objectId[i], p, _dataSalePack.objectCount[i]);
        }
        d.releaseIt(null, false);
        g.windowsManager.closeAllWindows();
        g.salePanel.visiblePartyPanel(false);
    }
}
}
