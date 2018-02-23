/**
 * Created by user on 12/28/16.
 */
package windows.starterPackWindow {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import flash.display.Bitmap;
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
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;

import windows.WindowMain;
import windows.WindowsManager;

public class WOStarterPack extends WindowMain{
    private var _data:Object;
    private var _decorSpr:Sprite;
    private var _arrCTex:Array;
    private var _txtName:CTextField;
    private var _btnBuy:CButton;
    private var _txtLastCost:CTextField;
    private var _txtNewCost:CTextField;
    private var _txtlabel:CTextField;
    private var _imLabel:Image;
    private var _txtTime:CTextField;
    private var _txtTimeLeft:CTextField;

    public function WOStarterPack() {
        super();
        _decorSpr = new Sprite();
        _arrCTex = [];
        if (g.managerResize.stageHeight < 750) _isBigWO = false;  else _isBigWO = true;
        if (!_isBigWO) _source.scale = .7;
        _woHeight = 460;
        _woWidth = 610;
        _windowType = WindowsManager.WO_STARTER_PACK;
        g.server.getStarterPack(callbackServer);
    }

    private function onLoad(bitmap:Bitmap):void {
        if (!_source) return;
            bitmap = g.pBitmaps[g.dataPath.getGraphicsPath() + 'qui/starter_pack_window.png'].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        var image:Image = new Image(tex);
        image.pivotX = image.width/2;
        image.pivotY = image.height/2;
        _source.addChildAt(image,0);
        createWindow();
    }

    private function onLoadLabel(bitmap:Bitmap):void {
        if (!_source) return;
            bitmap = g.pBitmaps[g.dataPath.getGraphicsPath() + 'qui/sale_lable.png'].create() as Bitmap;
        photoFromTextureLabel(Texture.fromBitmap(bitmap));
    }

    private function photoFromTextureLabel(tex:Texture):void {
        var image:Image = new Image(tex);
        image.x = 80;
        image.y = 130;
        _source.addChild(image);
        createExitButton(hideIt);
    }

    private function callbackServer(ob:Object):void {
        _data = ob;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/starter_pack_window.png', onLoad);
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/sale_lable.png', onLoadLabel);
    }

    private function createWindow():void {
        var txt:CTextField;
        var im:Image;
        if (g.user.language == ManagerLanguage.RUSSIAN) {
            _txtName = new CTextField(600, 100, String(g.managerLanguage.allTexts[324]));
            _txtName.setFormat(CTextField.BOLD72, 45, 0xcf302f, Color.WHITE);
            _txtName.alignH = Align.LEFT;
            _txtName.x = -255;
            _txtName.y = -235;
            _source.addChild(_txtName);
        } else {
            _txtName = new CTextField(350, 100, String(g.managerLanguage.allTexts[324]));
            _txtName.setFormat(CTextField.BOLD72, 70, 0xcf302f, Color.WHITE);
            _txtName.alignH = Align.LEFT;
            _txtName.x = -180;
            _txtName.y = -235;
            _source.addChild(_txtName);
        }

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bank_rubins_1'));
        im.x = -220;
        im.y = -75;
        _source.addChild(im);
        txt = new CTextField(220, 90, String(_data.hard_count) + ' ' + String(g.managerLanguage.allTexts[326]));
        txt.setFormat(CTextField.BOLD30, 28,  ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        txt.alignH = Align.LEFT;
        txt.x = -135 - txt.textBounds.width/2 ;
        txt.y = -5;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(220, 90, String(_data.object_count) + ' ' + String(g.managerLanguage.allTexts[327]));
        txt.setFormat(CTextField.BOLD30, 28,  ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        txt.x = 18;
        txt.y = -5;
        _source.addChild(txt);
        _arrCTex.push(txt);

        if (_data.object_type == BuildType.RESOURCE || _data.object_type == BuildType.INSTRUMENT || _data.object_type == BuildType.PLANT) {
            im = new Image(g.allData.atlas[g.allData.getResourceById(_data.object_id).url].getTexture(g.allData.getResourceById(_data.object_id).imageShop));
            _source.addChild(im);
        } else if (_data.object_type == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(_data.object_id).url + '_icon'));
            _source.addChild(_decorSpr);
            _decorSpr.addChild(im);
        } else if (_data.object_type == BuildType.DECOR) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(_data.object_id).image +'_icon'));
            _source.addChild(_decorSpr);
            _decorSpr.addChild(im);
        }
        MCScaler.scale(im,105,105);
        im.x = 85;
        im.y = -65;

        txt = new CTextField(200,100,String(_data.old_cost));
        txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        txt.x = -270;
        txt.y = 47;
        _source.addChild(txt);
        var myPattern:RegExp = /count/;
        var str:String =  String(g.managerLanguage.allTexts[1242]);
        var st:String;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) st = ' USD';
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) st = ' ОК';
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) st = ' ВК';
        _txtLastCost = new CTextField(250,100,String(g.managerLanguage.allTexts[1242]));
        _txtLastCost.text = String(str.replace(myPattern, st));
        _txtLastCost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtLastCost.alignH = Align.LEFT;
        _txtLastCost.x = -215;
        _txtLastCost.y = 50;
        _source.addChild(_txtLastCost);

        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            st = ' ' + String(g.managerLanguage.allTexts[328]);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            st = ' ' + String(g.managerLanguage.allTexts[330]);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID ) {
            st = ' USD';
        }

        txt = new CTextField(200,100,String(_data.new_cost) + st);
        txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.GREEN_COLOR, Color.WHITE);
        txt.x = -153;
        txt.y = 87;
        _source.addChild(txt);

        _txtNewCost = new CTextField(250,100,String(g.managerLanguage.allTexts[1243]));
        _txtNewCost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtNewCost.x = -298;
        _txtNewCost.y = 90;
        _source.addChild(_txtNewCost);

        var quad:Quad = new Quad(_txtLastCost.textBounds.width, 3, Color.RED);
        quad.x = -215;
        quad.y = 103;
        quad.alpha = .6;
        _source.addChild(quad);

//        _imLabel = new Image(g.allData.atlas['saleAtlas'].getTexture('sale_lable'));
//        _imLabel.x = 80;
//        _imLabel.y = 130;
//        _source.addChild(_imLabel);

        _txtlabel = new CTextField(150,60,String('-' + _data.profit) + '%');
        _txtlabel.setFormat(CTextField.BOLD72, 42, 0xf00f0f, Color.WHITE);
        _txtlabel.x = 87;
        _txtlabel.y = 180;
        _source.addChildAt(_txtlabel,2);

        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(140, CButton.HEIGHT_55, CButton.GREEN, true);
        _btnBuy.addTextField(140, 54, -2, -5, String(g.managerLanguage.allTexts[331]));
        _btnBuy.setTextFormat(CTextField.BOLD72, 45, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btnBuy);
        _btnBuy.x = -15;
        _btnBuy.y = 210;
        _btnBuy.clickCallback = onClick;

        _txtTime = new CTextField(200,90,'');
        _txtTime.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR);
        _txtTime.alignH = Align.LEFT;
        _txtTime.x = 120;
        _txtTime.y = 65;
        _source.addChild(_txtTime);

        _txtTimeLeft = new CTextField(200,90,String(g.managerLanguage.allTexts[357]));
        _txtTimeLeft.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtTimeLeft.alignH = Align.LEFT;
        _txtTimeLeft.x = 73;
        _txtTimeLeft.y = 34;
        _source.addChild(_txtTimeLeft);
        g.gameDispatcher.addToTimer(startTimer);
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    override public function hideIt():void {
//        if (g.user.level >= 5 && g.user.dayDailyGift == 0) g.server.getDailyGift(null);
//        else {
//            var todayDailyGift:Date = new Date(g.user.dayDailyGift * 1000);
//            var today:Date = new Date(g.user.day * 1000);
//            if (g.user.level >= 5 && todayDailyGift.date != today.date) {
//                g.server.getDailyGift(null);
//            } else {
////                g.managerCats.helloCats();
                if (g.managerParty.userParty && !g.managerParty.userParty.showWindow && g.managerParty.userParty.countResource >=g. managerParty.dataParty.countToGift[0] && (g.managerParty.dataParty.typeParty == 1 || g.managerParty.dataParty.typeParty == 2))
                    g.managerParty.endPartyWindow();
                else if (g.userTimer.partyToEndTimer > 0 && g.managerParty.eventOn && g.managerParty.levelToStart <= g.user.level && g.allData.atlas['partyAtlas']) {
                    g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
                } else if (g.userTimer.partyToEndTimer <= 0 && g.managerParty.userParty && !g.managerParty.userParty.showWindow &&
                        (g.managerParty.dataParty.typeParty == 3 || g.managerParty.dataParty.typeParty == 4)) g.managerParty.endPartyWindow();

//            }
//        }
     super.hideIt();
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
            g.socialNetwork.showOrderWindow({id: 13, price: int(_data.new_cost)});
            Cc.info('try to buy packId: ' + 13);
        }
    }

    private function orderWindowSuccessHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Seccuss for buy pack');
        onBuy();
    }

    private function orderWindowFailHandler(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_SUCCESS, orderWindowSuccessHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_CANCEL, orderWindowFailHandler);
        g.socialNetwork.removeEventListener(SocialNetworkEvent.ORDER_WINDOW_FAIL, orderWindowFailHandler);
        Cc.info('Fail for buy pack');
    }

    override protected function deleteIt():void {
        for (var i:int = 0; i < _arrCTex.length; i++) {
            if (_source && _arrCTex[i]) _source.removeChild(_arrCTex[i]);
            if (_arrCTex[i]) _arrCTex[i].deleteIt();
            _arrCTex[i] = null;
        }
        super.deleteIt();
    }

    private function onBuy():void {
        g.server.updateStarterPack(null);
        var p:Point = new Point(30, 30);
        p = _source.localToGlobal(p);
        var d:DropObject = new DropObject();
        d.addDropMoney(DataMoney.HARD_CURRENCY, _data.hard_count, p);
        if (_data.object_type == BuildType.RESOURCE || _data.object_type == BuildType.INSTRUMENT || _data.object_type == BuildType.PLANT)
            d.addDropItemNewByResourceId(_data.object_id, p, _data.object_count);
        else if (_data.object_type == BuildType.DECOR_ANIMATION || _data.object_type == BuildType.DECOR)
            d.addDropDecor(g.allData.getBuildingById(_data.object_id), p, 1);
        d.releaseIt(null, false);
        hideIt();
    }

    public function startTimer():void {
        if (g.userTimer.starterTimerToEnd > 0) {
            if (_txtTime) {
                _txtTime.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.starterTimerToEnd);
                _txtTime.x = 132 - _txtTime.textBounds.width/2;
            }
        } else {
            hideIt();
            g.gameDispatcher.removeFromTimer(startTimer);
        }
    }
}
}
