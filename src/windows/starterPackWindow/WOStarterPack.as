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

import loaders.PBitmap;

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
import starling.textures.TextureAtlas;
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
    private var _txtOldCost:CTextField;
    private var _txtValue:CTextField;
    private var _txtNewCost:CTextField;
    private var _txtlabel:CTextField;
    private var _imLabel:Image;
    private var _txtTime:CTextField;
    private var _txtTimeLeft:CTextField;
    private var _count:int = 0;

    public function WOStarterPack() {
        super();
        _decorSpr = new Sprite();
        _arrCTex = [];
        if (g.managerResize.stageHeight < 750) _isBigWO = false;  else _isBigWO = true;
        if (!_isBigWO) _source.scale = .8;
        _woHeight = 460;
        _woWidth = 610;
        _windowType = WindowsManager.WO_STARTER_PACK;
        g.server.getStarterPack(callbackServer);
        atlasLoad();
    }

    public function atlasLoad():void {
        if (!g.allData.atlas['bankAtlas']) {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas'), onLoadAtlas);
            g.load.loadXML(g.dataPath.getGraphicsPath() + 'bankAtlas.xml' + g.getVersion('bankAtlas'), onLoadAtlas);
        } else createAtlases();
    }

    private function onLoadAtlas(smth:*=null):void {
        _count++;
        if (_count >=2) createAtlases();
    }

    private function createAtlases():void {
        if (!g.allData.atlas['bankAtlas']) {
            if (g.pBitmaps[g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas')] && g.pXMLs[g.dataPath.getGraphicsPath() + 'bankAtlas.xml' + g.getVersion('bankAtlas')]) {
                g.allData.atlas['bankAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'bankAtlas.xml' + g.getVersion('bankAtlas')]);
                (g.pBitmaps[g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas')] as PBitmap).deleteIt();

                delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas')];
                delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'bankAtlas.xml' + g.getVersion('bankAtlas')];
                g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'bankAtlas.png' + g.getVersion('bankAtlas'));
                g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'bankAtlas.xml' + g.getVersion('bankAtlas'));
            }
        }
    }
    private function onLoad(bitmap:Bitmap):void {
        if (!_source) return;
            bitmap = g.pBitmaps[g.dataPath.getGraphicsPath() + 'qui/starter_pack_window_2.png'].create() as Bitmap;
        try {
            photoFromTexture(Texture.fromBitmap(bitmap));
        } catch(e:Error) {
            Cc.error('WOStarterPack onLoad:: error bitmap photoFromTexture');
            super.hideIt();
        }
    }

    private function photoFromTexture(tex:Texture):void {
        var image:Image = new Image(tex);
        image.pivotX = image.width/2;
        image.pivotY = image.height/2;
        _source.addChildAt(image,0);
        if (!g.allData.atlas['bankAtlas']) g.gameDispatcher.addEnterFrame(createWindow);
        else createWindow();
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
        _txtlabel = new CTextField(150,60,String('-' + _data.profit) + '%');
        _txtlabel.setFormat(CTextField.BOLD72, 42, 0xf00f0f, Color.WHITE);
        _txtlabel.x = 87;
        _txtlabel.y = 180;
        _source.addChild(_txtlabel);
        createExitButton(hideIt);
    }

    private function callbackServer(ob:Object):void {
        _data = ob;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/starter_pack_window_2.png', onLoad);
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/sale_lable.png', onLoadLabel);
    }

    private function createWindow():void {
        if (!g.allData.atlas['bankAtlas']) return;
        else g.gameDispatcher.removeEnterFrame(createWindow);
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

        im = new Image(g.allData.atlas['bankAtlas'].getTexture('bank_rubins_1'));
        MCScaler.scale(im, im.height-20, im.width-20);
        im.x = -60;
        im.y = -55;
        _source.addChild(im);
        txt = new CTextField(220, 90, String(_data.hard_count));
        txt.setFormat(CTextField.BOLD30, 28,  ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = - txt.textBounds.width/2 + 10;
        txt.y = -5;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(220, 90, String(g.managerLanguage.allTexts[326]));
        txt.setFormat(CTextField.BOLD30, 28,  ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        txt.alignH = Align.LEFT;
        txt.x =  -txt.textBounds.width/2 + 10;
        txt.y = -125;
        _source.addChild(txt);
        _arrCTex.push(txt);

        im = new Image(g.allData.atlas['bankAtlas'].getTexture('bank_coins_2'));
        MCScaler.scale(im, im.height-50, im.width-50);
        im.x = -236;
        im.y = -65;
        _source.addChild(im);
        txt = new CTextField(220, 90, String(_data.soft_count));
        txt.setFormat(CTextField.BOLD30, 28,  ManagerFilters.BLUE_COLOR);
        txt.alignH = Align.LEFT;
        txt.x = -190 - txt.textBounds.width/2 ;
        txt.y = -5;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(220, 90, String(g.managerLanguage.allTexts[325]));
        txt.setFormat(CTextField.BOLD30, 28,  ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        txt.alignH = Align.LEFT;
        txt.x = -190 - txt.textBounds.width/2 ;
        txt.y = -125;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(220, 90, String(_data.object_count));
        txt.setFormat(CTextField.BOLD30, 28,  ManagerFilters.BLUE_COLOR);
        txt.x = 94;
        txt.y = -5;
        _source.addChild(txt);
        _arrCTex.push(txt);

        txt = new CTextField(220, 90, String(g.managerLanguage.allTexts[327]));
        txt.setFormat(CTextField.BOLD30, 28,  ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        txt.x = 94;
        txt.y = -125;
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
        im.x = 160;
        im.y = -65;


//        var myPattern:RegExp = /count/;
//        var str:String =  String(g.managerLanguage.allTexts[1242]);
        var st:String;
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) st = ' USD';
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) st = ' ОК';
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) st = ' Голоса';
        _txtLastCost = new CTextField(250,100,String(g.managerLanguage.allTexts[1242]));
//        _txtLastCost.text = String(str.replace(myPattern, st));
        _txtLastCost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtLastCost.alignH = Align.LEFT;
        _txtLastCost.x = -230;
        _txtLastCost.y = 50;
        _source.addChild(_txtLastCost);

        _txtOldCost = new CTextField(200,100,String(_data.old_cost) + st);
        _txtOldCost.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtOldCost.alignH = Align.LEFT;
        _txtOldCost.x = _txtLastCost.x + _txtLastCost.textBounds.width;
        _txtOldCost.y = 47;
        _source.addChild(_txtOldCost);

        _txtValue = new CTextField(250,100,String(' ' +g.managerLanguage.allTexts[1293]));
        _txtValue.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtValue.alignH = Align.LEFT;
        _txtValue.x = _txtOldCost.x + _txtOldCost.textBounds.width;
        _txtValue.y = 50;
        _source.addChild(_txtValue);

        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) st = ' ' + String(g.managerLanguage.allTexts[328]);
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) st = ' Голос';
        else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID ) st = ' USD';

        _txtNewCost = new CTextField(250,100,String(g.managerLanguage.allTexts[1243]));
        _txtNewCost.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtNewCost.alignH = Align.LEFT;
        _txtNewCost.x = -228;
        _txtNewCost.y = 90;
        _source.addChild(_txtNewCost);

        txt = new CTextField(200,100,String(_data.new_cost) + st);
        txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.GREEN_COLOR, Color.WHITE);
        txt.alignH = Align.LEFT;
        txt.x = _txtNewCost.x + _txtNewCost.textBounds.width;
        txt.y = 87;
        _source.addChild(txt);
        var quad:Quad = new Quad(_txtLastCost.textBounds.width + _txtOldCost.textBounds.width + _txtValue.textBounds.width, 3, Color.RED);
        quad.x = -230;
        quad.y = 103;
        quad.alpha = .6;
        _source.addChild(quad);

//        _imLabel = new Image(g.allData.atlas['saleAtlas'].getTexture('sale_lable'));
//        _imLabel.x = 80;
//        _imLabel.y = 130;
//        _source.addChild(_imLabel);

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
        if (g.user.level >= 5 && g.user.dayDailyGift == 0) g.server.getDailyGift(null);
        else {
            var todayDailyGift:Date = new Date(g.user.dayDailyGift * 1000);
            var today:Date = new Date(g.user.day * 1000);
            if (g.user.level >= 5 && todayDailyGift.date != today.date) {
                g.server.getDailyGift(null);
            }
            else {
////                g.managerCats.helloCats();
//               if (g.userTimer.partyToEndTimer > 0 && g.managerParty.eventOn && g.managerParty.levelToStart <= g.user.level && g.allData.atlas['partyAtlas']) {
//                    g.windowsManager.openWindow(WindowsManager.WO_PARTY,null);
//                } else if (g.userTimer.partyToEndTimer <= 0 && g.managerParty.userParty && !g.managerParty.userParty.showWindow &&
//                        (g.managerParty.dataPartyNowUse.typeParty == 3 || g.managerParty.dataPartyNowUse.typeParty == 4)) g.managerParty.endPartyWindow();

                if (g.managerParty.showEndWindow) {
                    g.windowsManager.openWindow(WindowsManager.WO_PARTY_CLOSE,null);
                }
                else if (g.managerParty.eventOn) g.windowsManager.openWindow(WindowsManager.WO_PARTY, null);
            }
        }
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
            g.socialNetwork.showOrderWindow({id: 13, price: int(_data.new_cost), type:'item'});
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
        if (g.miniScenes.continueAfterNeighbor==2) {
            g.miniScenes.continueAfterNeighbor=3;
            g.server.getDailyGift(null);
        }
    }

    private function onBuy():void {
        g.managerStarterPack.onBuyStarterPack();
        var p:Point = new Point(30, 30);
        p = _source.localToGlobal(p);
        var d:DropObject = new DropObject();
        d.addDropMoney(DataMoney.HARD_CURRENCY, _data.hard_count, p);
        d.addDropMoney(DataMoney.SOFT_CURRENCY, _data.soft_count, p);
        if (_data.object_type == BuildType.RESOURCE || _data.object_type == BuildType.INSTRUMENT || _data.object_type == BuildType.PLANT)
            d.addDropItemNewByResourceId(_data.object_id, p, _data.object_count);
        else if (_data.object_type == BuildType.DECOR_ANIMATION || _data.object_type == BuildType.DECOR)
            d.addDropDecor(g.allData.getBuildingById(_data.object_id), p, 1, true);
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
