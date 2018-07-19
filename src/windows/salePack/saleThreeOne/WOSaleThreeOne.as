/**
 * Created by user on 7/12/18.
 */
package windows.salePack.saleThreeOne {
import flash.display.Bitmap;

import loaders.PBitmap;

import manager.ManagerFilters;

import starling.textures.Texture;

import starling.textures.TextureAtlas;

import starling.utils.Align;
import starling.utils.Color;

import utils.CTextField;
import utils.TimeUtils;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOSaleThreeOne extends WindowMain{
    private var _txtName:CTextField;
    private var _txtDescription:CTextField;
    private var _txtTimeLeft:CTextField;
    private var _txtTime:CTextField;
    private var _count:int = 0;
    private var _boolOpen:Boolean = false;

    public function WOSaleThreeOne() {
        super();
        _windowType = WindowsManager.WO_THREE_ONE;
        _woWidth = 800;
        _woHeight = 600;
        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBGNew);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        _txtName = new CTextField(400,100,String(g.managerLanguage.allTexts[276]));
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txtName.x = -210;
        _txtName.y = -295;
        _source.addChild(_txtName);

        _txtDescription = new CTextField(755, 200,String(g.managerSalePack.userSale.profit) +'%');
        _txtDescription.setFormat(CTextField.BOLD72, 45, 0xcf302f, Color.WHITE);
        _txtDescription.alignH = Align.LEFT;
//        _txtDescription.x = -100;
        _txtDescription.y = -255;
        _source.addChild(_txtDescription);
        var strSimval:String = '';
        for (var i:int = 0; i < _txtDescription.textBounds.width/10; i++) {
            strSimval += ' ';
        }
        var myPattern:RegExp = /count/;
        var str:String =  String(g.managerLanguage.allTexts[1686]);
        var txt:CTextField = new CTextField(755, 200,' ');
        txt.setFormat(CTextField.BOLD30, 30,  ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        txt.text = String(str.replace(myPattern,strSimval));
        txt.alignH = Align.LEFT;
        txt.x = -370;
        txt.y = -245;
        _source.addChild(txt);

        _txtTime = new CTextField(200,90,'');
        _txtTime.setFormat(CTextField.BOLD72, 36, ManagerFilters.BLUE_COLOR);
        _txtTime.alignH = Align.LEFT;
//        _txtTime.x = 20;
        _txtTime.y = -150;
        _source.addChild(_txtTime);

        _txtTimeLeft = new CTextField(200,90,String(g.managerLanguage.allTexts[357]));
        _txtTimeLeft.setFormat(CTextField.BOLD24, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtTimeLeft.alignH = Align.LEFT;
        _txtTimeLeft.x = -130;
        _txtTimeLeft.y = -148;
        _source.addChild(_txtTimeLeft);
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

    override public function showItParams(callback:Function, params:Array):void {
        _boolOpen = params[0];
        if (!g.allData.atlas['bankAtlas']) {
            g.gameDispatcher.addEnterFrame(showWindow);
            return;
        }
        var saleThreeOneItem:WOSaleThreeOneItem;
        g.gameDispatcher.addToTimer(startTimer);
        for (var i:int = 0; i < 3; i++) {
            saleThreeOneItem = new WOSaleThreeOneItem(g.managerSalePack.userSale.objectId[i]);
            saleThreeOneItem.source.x = -380 + (i* 255);
            saleThreeOneItem.source.y = -70;
            _source.addChild(saleThreeOneItem.source);
        }
            super.showIt();
    }

    private function showWindow():void {
        if (!g.allData.atlas['bankAtlas']) return;
        g.gameDispatcher.removeEnterFrame(showWindow);
        g.gameDispatcher.addToTimer(startTimer);
        var saleThreeOneItem:WOSaleThreeOneItem;
        for (var i:int = 0; i < 3; i++) {
            saleThreeOneItem = new WOSaleThreeOneItem(g.managerSalePack.userSale.objectId[i]);
            saleThreeOneItem.source.x = -380 + (i* 255);
            saleThreeOneItem.source.y = -70;
            _source.addChild(saleThreeOneItem.source);
        }
        super.showIt();
    }

    public function startTimer():void {
        if (g.userTimer.saleTimerToEnd > 0) {
            if (_txtTime) {
                _txtTime.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.saleTimerToEnd);
                _txtTime.x = 20;
            }
        } else {
            g.gameDispatcher.removeFromTimer(startTimer);
            hideIt();
        }
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
