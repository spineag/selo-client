/**
 * Created by user on 2/15/17.
 */
package windows.salePack.saleInstruments {
import flash.display.Bitmap;

import starling.textures.Texture;

import windows.salePack.*;

import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.display.StageDisplayState;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.ManagerLanguage;
import resourceItem.newDrop.DropObject;
import social.SocialNetworkEvent;
import social.SocialNetworkSwitch;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.TimeUtils;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOSalePackInstrument extends WindowMain{
    private var _woBG:WindowBackground;
    private var _txtTime:CTextField;
    private var _txtName:CTextField;
    private var _imName:Image;
    private var _txtDescription:CTextField;
    private var _txtBtn:CTextField;
    private var _txtProfit:CTextField;
    private var _txtNewCost:CTextField;
    private var _sprItem:Sprite;
    private var _imPercent:Image;
    private var _btnBuy:CButton;
    private var _arrItem:Array;
    private var _txtTimeLeft:CTextField;
    private var _txtLastCost:CTextField;
    private var _boolOpen:Boolean = false;

    public function WOSalePackInstrument() {
        _woHeight = 550;
        _woWidth = 340;
        _windowType = WindowsManager.WO_SALE_PACK_INSTRUMENTS;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/coins_windows.png', onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + 'qui/coins_windows.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var im:Image;
        im = new Image(tex);
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source.addChildAt(im,0);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        _imPercent = new Image(g.allData.atlas['saleAtlas'].getTexture('sale_lable'));
        _imPercent.x = -405;
        _imPercent.y = -210;
        _source.addChild(_imPercent);
        _txtTime = new CTextField(200,90,'');
        _txtTime.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR);
        _txtTime.alignH = Align.LEFT;
        _txtTime.x = 100;
        _txtTime.y = 80;
        _source.addChild(_txtTime);

        _txtTimeLeft = new CTextField(200,90,String(g.managerLanguage.allTexts[357]));
        _txtTimeLeft.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtTimeLeft.alignH = Align.LEFT;
        _txtTimeLeft.x = -30;
        _txtTimeLeft.y = 82;
        _source.addChild(_txtTimeLeft);
        var _txt:CTextField;

        _txt = new CTextField(200,100,String(g.managerSalePack.dataSale.oldCost));
        _txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txt.x = -320;
        _txt.y = 58;
        _source.addChild(_txt);

        var myPattern:RegExp = /count/;
        var str:String =  String(g.managerLanguage.allTexts[1242]);
        var st:String;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) st = 'USD';
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) st = 'ОК';
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) st = 'ВК';
        _txtLastCost = new CTextField(250,100,String(g.managerLanguage.allTexts[1242]));
        _txtLastCost.text = String(str.replace(myPattern, st));
        _txtLastCost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtLastCost.alignH = Align.LEFT;
        _txtLastCost.x = -265;
        _txtLastCost.y = 60;
        _source.addChild(_txtLastCost);

        var quad:Quad = new Quad(_txtLastCost.textBounds.width, 3, Color.RED);
        quad.x = -267;
        quad.y = 113;
        quad.alpha = .6;
        _source.addChild(quad);

        _txtDescription = new CTextField(740,70,String(g.managerSalePack.dataSale.description));
        _txtDescription.setFormat(CTextField.BOLD30, 26, 0xff8000, Color.WHITE);
        _txtDescription.x = -360;
        _txtDescription.y = 40;

        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            st = ' ' + String(g.managerLanguage.allTexts[328]);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            st = ' ' + String(g.managerLanguage.allTexts[330]);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID ) {
            st = ' USD';
        }

        _txt = new CTextField(200,100,String(g.managerSalePack.dataSale.newCost) + st);
        _txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.GREEN_COLOR, Color.WHITE);
        _txt.x = -210;
        _txt.y = 97;
        _source.addChild(_txt);

        _txtNewCost = new CTextField(250,100,String(g.managerLanguage.allTexts[1243]));
        _txtNewCost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtNewCost.x = -350;
        _txtNewCost.y = 100;
        _source.addChild(_txtNewCost);

        _txtProfit = new CTextField(150,60,String('-' + g.managerSalePack.dataSale.profit) + '%');
        _txtProfit.setFormat(CTextField.BOLD72, 42, 0xf00f0f, Color.WHITE);
        _txtProfit.x = -398;
        _txtProfit.y = -160;
        _source.addChild(_txtProfit);
        g.gameDispatcher.addToTimer(startTimer);

        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(140, CButton.HEIGHT_55, CButton.GREEN, true);
        _btnBuy.addTextField(140, 54, -2, -5, String(g.managerLanguage.allTexts[331]));
        _btnBuy.setTextFormat(CTextField.BOLD72, 45, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btnBuy);
        _btnBuy.x = -15;
        _btnBuy.y = 200;

        _txtName = new CTextField(400,100,String(g.managerLanguage.allTexts[276]));
        _txtName.setFormat(CTextField.BOLD72, 70, 0xcf302f, Color.WHITE);
        _txtName.x = -235;
        _txtName.y = -230;
        _source.addChild(_txtName);
    }

    override public function showItParams(callback:Function, params:Array):void {
        var item:WOSalePackItemInstrument;
        _sprItem = new Sprite();
        _source.addChild(_sprItem);
        _arrItem = [];
        for (var i:int = 0; i < g.managerSalePack.dataSale.objectId.length; i++) {
            item = new WOSalePackItemInstrument(g.managerSalePack.dataSale.objectId[i],g.managerSalePack.dataSale.objectType[i],g.managerSalePack.dataSale.objectCount[i]);
            item.source.x = 140 * i;
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
        _sprItem.y = -75;
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
            g.socialNetwork.showOrderWindow({id: 14, price: int(g.managerSalePack.dataSale.newCost)});
            Cc.info('try to buy packId: ' + 14);
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
        g.server.updateUserSalePack(null);
        var p:Point = new Point(0, 0);
        p = _source.localToGlobal(p);
        var d:DropObject = new DropObject();
        for (var i:int = 0; i < g.managerSalePack.dataSale.objectId.length; i++) {
            if (g.managerSalePack.dataSale.objectId[i] == 1 && g.managerSalePack.dataSale.objectType[i]  == 1)
                d.addDropMoney(DataMoney.HARD_CURRENCY, g.managerSalePack.dataSale.objectCount[i], p);
            else if (g.managerSalePack.dataSale.objectType[i] == BuildType.INSTRUMENT)
                d.addDropItemNewByResourceId(g.managerSalePack.dataSale.objectId[i], p, g.managerSalePack.dataSale.objectCount[i]);
        }
        d.releaseIt(null, false);
        hideIt();
        g.salePanel.visiblePartyPanel(false);
    }

    public function startTimer():void {
        if (g.userTimer.saleTimerToEnd > 0) {
            if (_txtTime) {
                _txtTime.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.saleTimerToEnd);
                _txtTime.x = 150 - _txtTime.textBounds.width/2;
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
                } else {
//                    g.managerCats.helloCats();
                    if (g.managerParty.userParty && !g.managerParty.userParty.showWindow && g.managerParty.userParty.countResource >= g. managerParty.countToGift[0] && (g.managerParty.typeParty == 1 || g.managerParty.typeParty == 2)) {
                        g.managerParty.endPartyWindow();
                    } else if ( g.managerParty.eventOn && g.user.level >= g.managerParty.levelToStart && g.allData.atlas['partyAtlas']) {
                        g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
                    }
                    else if (g.managerParty.userParty && g.userTimer.partyToEndTimer <= 0 && !g.managerParty.userParty.showWindow
                            && (g.managerParty.typeParty == 3 || g.managerParty.typeParty == 4 || g.managerParty.typeParty == 5)) g.managerParty.endPartyWindow();
                }
            }
        }
        super.hideIt();
    }
}
}