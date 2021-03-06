/**
 * Created by user on 1/10/18.
 */
package windows.salePack.saleVauchers {
import com.junkbyte.console.Cc;

import data.BuildType;

import data.DataMoney;

import flash.display.Bitmap;
import flash.display.StageDisplayState;
import flash.geom.Point;

import manager.ManagerFilters;

import resourceItem.newDrop.DropObject;

import social.SocialNetworkEvent;

import social.SocialNetworkSwitch;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;
import utils.TimeUtils;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;
import windows.salePack.saleInstruments.WOSalePackItemInstrument;

public class WOSalePackVauchers  extends WindowMain{
    private var _txtTime:CTextField;
    private var _txtName:CTextField;
    private var _txtDescription:CTextField;
    private var _txtProfit:CTextField;
    private var _txtNewCost:CTextField;
    private var _txtOldCost:CTextField;
    private var _txtValue:CTextField;
    private var _sprItem:Sprite;
    private var _imPercent:Image;
    private var _btnBuy:CButton;
    private var _arrItem:Array;
    private var _txtTimeLeft:CTextField;
    private var _txtLastCost:CTextField;
    private var _boolOpen:Boolean = false;

    public function WOSalePackVauchers() {
        _windowType = WindowsManager.WO_SALE_PACK_VAUCHERS;
        _woHeight = 490;
        _woWidth = 565;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/vaucher_windows.png', onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'qui/vaucher_windows.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var im:Image;
        im = new Image(tex);
        im.x = -im.width/2;
        im.y = -im.height/2;
        if (_source) _source.addChildAt(im,0);
        else _source.addChild(im);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        _imPercent = new Image(g.allData.atlas['saleAtlas'].getTexture('sale_lable'));
        _imPercent.x = -280;
        _imPercent.y = 50;
        _source.addChild(_imPercent);
        _txtTime = new CTextField(200,90,'');
        _txtTime.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR);
        _txtTime.alignH = Align.LEFT;
        _txtTime.x = 550;
        _txtTime.y = 100;
        _source.addChild(_txtTime);

        _txtTimeLeft = new CTextField(200,90,String(g.managerLanguage.allTexts[357]));
        _txtTimeLeft.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtTimeLeft.alignH = Align.LEFT;
        _txtTimeLeft.x = -95;
        _txtTimeLeft.y = 102;
        _source.addChild(_txtTimeLeft);
        var _txt:CTextField;

        var st:String;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) st = 'USD';
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) st = 'ОК';
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) st = ' Голосов';
        if (g.managerSalePack.userSale.oldCost > 0) {
            _txtLastCost = new CTextField(250,100,String(g.managerLanguage.allTexts[1242]));
            _txtLastCost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
            _txtLastCost.alignH = Align.LEFT;
            _txtLastCost.x = -15;
            _txtLastCost.y = 23;
            _source.addChild(_txtLastCost);

            _txtOldCost = new CTextField(200,100, String(g.managerSalePack.userSale.oldCost) + st);
            _txtOldCost.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
            _txtOldCost.alignH = Align.LEFT;
            _txtOldCost.x = _txtLastCost.x + _txtLastCost.textBounds.width;
            _txtOldCost.y = 20;
            _source.addChild(_txtOldCost);

            _txtValue = new CTextField(250,100,String(g.managerLanguage.allTexts[1293]));
            _txtValue.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
            _txtValue.alignH = Align.LEFT;
            _txtValue.x = _txtOldCost.x + _txtOldCost.textBounds.width;
            _txtValue.y = 23;
            _source.addChild(_txtValue);

            var quad:Quad = new Quad(_txtLastCost.textBounds.width + _txtOldCost.textBounds.width + _txtValue.textBounds.width, 3, Color.RED);
            quad.x = -16;
            quad.y = 77;
            quad.alpha = .6;
            _source.addChild(quad);
        }

        _txtDescription = new CTextField(740,70,String(g.managerSalePack.userSale.description));
        _txtDescription.setFormat(CTextField.BOLD30, 26, 0xff8000, Color.WHITE);
        _txtDescription.x = -360;
        _txtDescription.y = 40;

        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            st = ' ' + String(g.managerLanguage.allTexts[328]);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            st = ' Голоса';
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID ) {
            st = ' USD';
        }

        _txtNewCost = new CTextField(250,100,String(g.managerLanguage.allTexts[1243]));
        _txtNewCost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtNewCost.alignH = Align.LEFT;
        _txtNewCost.x = -95;
        _txtNewCost.y = 40;
        _source.addChild(_txtNewCost);

        _txt = new CTextField(200,100, String(g.managerSalePack.userSale.newCost) + st);
        _txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.GREEN_COLOR, Color.WHITE);
        _txt.alignH = Align.LEFT;
        _txt.x = _txtNewCost.x + _txtNewCost.textBounds.width;
        _txt.y = 38;
        _source.addChild(_txt);

        _txtProfit = new CTextField(150,60,String('-' + g.managerSalePack.userSale.profit) + '%');
        if (g.managerSalePack.userSale.profit == 0) _txtProfit.text = 'SALE';
        _txtProfit.setFormat(CTextField.BOLD72, 42, 0xf00f0f, Color.WHITE);
        _txtProfit.x = -275;
        _txtProfit.y = 100;
        _source.addChild(_txtProfit);
        g.gameDispatcher.addToTimer(startTimer);

        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(140, CButton.HEIGHT_55, CButton.GREEN, true);
        _btnBuy.addTextField(140, 54, -2, -5, String(g.managerLanguage.allTexts[331]));
        _btnBuy.setTextFormat(CTextField.BOLD72, 45, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btnBuy);
        _btnBuy.x = -15;
        _btnBuy.y = 217;

        _txtName = new CTextField(400,100,String(g.managerLanguage.allTexts[276]));
        _txtName.setFormat(CTextField.BOLD72, 70, 0xcf302f, Color.WHITE);
        _txtName.x = -230;
        _txtName.y = -247;
        _source.addChild(_txtName);
    }

    override public function showItParams(callback:Function, params:Array):void {
        var item:WOSalePackVauchersItem;
        var ar:Array = g.managerSalePack.userSale.objectId;
        if (!ar) {
            onClickExit();
            return;
        }
        _sprItem = new Sprite();
        _source.addChild(_sprItem);
        _arrItem = [];
        for (var i:int = 0; i < ar.length; i++) {
            item = new WOSalePackVauchersItem(ar[i],g.managerSalePack.userSale.objectType[i],g.managerSalePack.userSale.objectCount[i]);
            item.source.x = 15 + 130 * i;
            _sprItem.addChild(item.source);
            _arrItem.push(item);
        }
        if (_arrItem.length == 1) {
            _sprItem.x = -80;
        } else if (_arrItem.length == 2) {
            _sprItem.x = -160;
        } else {
            _sprItem.x = -250;
        }
        _sprItem.y = -95;
        _boolOpen = params[0];
        super.showIt();
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
            g.socialNetwork.showOrderWindow({id: g.managerSalePack.userSale.saleId, price: int(g.managerSalePack.userSale.newCost), type:'sale_pack'});
            Cc.info('try to buy packId: ' + g.managerSalePack.userSale.saleId);
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
        g.server.updateUserSalePackBuy(1,g.managerSalePack.userSale.saleId,null);
        g.userTimer.saleToEnd(0);
        g.managerParty.userParty.buy = true;
        var p:Point = new Point(0, 0);
        p = _source.localToGlobal(p);
        var d:DropObject = new DropObject();
        for (var i:int = 0; i < g.managerSalePack.userSale.objectId.length; i++) {
            if (g.managerSalePack.userSale.objectId[i] == 5) d.addDropMoney(DataMoney.RED_COUPONE, g.managerSalePack.userSale.objectCount[i], p);
            else if (g.managerSalePack.userSale.objectId[i] == 6) d.addDropMoney(DataMoney.YELLOW_COUPONE, g.managerSalePack.userSale.objectCount[i], p);
            else if (g.managerSalePack.userSale.objectId[i] == 7)  d.addDropMoney(DataMoney.GREEN_COUPONE, g.managerSalePack.userSale.objectCount[i], p);
            else if (g.managerSalePack.userSale.objectId[i] == 8) d.addDropMoney(DataMoney.BLUE_COUPONE, g.managerSalePack.userSale.objectCount[i], p);
        }
        d.releaseIt(null, false);
        hideIt();
        g.salePanel.visiblePartyPanel(false);
    }

    public function startTimer():void {
        if (g.userTimer.saleTimerToEnd > 0) {
            if (_txtTime) {
                _txtTime.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.saleTimerToEnd);
                _txtTime.x = 90 - _txtTime.textBounds.width/2;
            }
        } else {
            onClickExit();
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }

    override protected function deleteIt():void {
        super.deleteIt();
    }

    private function onClickExit(e:Event=null):void {
        hideIt();
    }

    override public function hideIt():void {
        g.gameDispatcher.removeFromTimer(startTimer);
        if (_boolOpen) {
            if (g.user.level >= 5 && g.user.dayDailyGift == 0) g.server.getDailyGift(null);
            else {
                var todayDailyGift:Date = new Date(g.user.dayDailyGift * 1000);
                var today:Date = new Date(g.user.day * 1000);
                if (g.user.level >= 5 && todayDailyGift.date != today.date) {
                    g.server.getDailyGift(null);
                }
                else {
//                    if (g.managerParty.userParty && !g.managerParty.userParty.showWindow && g.managerParty.userParty.countResource >= g. managerParty.countToGift[0] && (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2)) {
//                        g.managerParty.endPartyWindow();
//                    } else if ( g.managerParty.eventOn && g.user.level >= g.managerParty.levelToStart && g.allData.atlas['partyAtlas']) {
//                        g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
//                    }
//                    else if (g.managerParty.userParty && g.userTimer.partyToEndTimer <= 0 && !g.managerParty.userParty.showWindow
//                            && (g.managerParty.typeParty == 3 || g.managerParty.typeParty == 4 || g.managerParty.typeParty == 5)) g.managerParty.endPartyWindow();
                    if (g.managerParty.showEndWindow) g.windowsManager.openWindow(WindowsManager.WO_PARTY_CLOSE,null);
                    else if (g.managerParty.eventOn) g.windowsManager.openWindow(WindowsManager.WO_PARTY, null);
                }
            }
        }
        super.hideIt();
    }
}
}
