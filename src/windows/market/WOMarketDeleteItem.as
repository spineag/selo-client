/**
 * Created by user on 5/5/16.
 */
package windows.market {
import data.BuildType;

import manager.ManagerFabricaRecipe;
import manager.ManagerFilters;

import starling.display.Image;

import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;

import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import starling.events.Event;

import windows.WindowsManager;

public class WOMarketDeleteItem extends WindowMain{
    private var _woBG:WindowBackgroundNew;
    private var _b:CButton;
    private var _callback:Function;
    private var _data:Object;
    private var _count:int;
    private var _cost:int;
    private var _txt:CTextField;
    private var _txtInfo:CTextField;
    private var _txtBtn:CTextField;

    public function WOMarketDeleteItem() {
        _windowType = WindowsManager.WO_MARKET_DELETE_ITEM;
        _woWidth = 750;
        _woHeight = 520;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,115);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _txtInfo = new CTextField(800, 150,String(g.managerLanguage.allTexts[408]));
        _txtInfo.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
        _txtInfo.x = -395;
        _txtInfo.y = -190;
        _source.addChild(_txtInfo);
        _txt = new CTextField(800,50,String(g.managerLanguage.allTexts[409]));
        _txt.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txt.x = -410;
        _txt.y = -230;
        _source.addChild(_txt);
        _callbackClickBG = onClickExit;
        _b = new CButton();
        _b.addButtonTexture(265, CButton.BIG_HEIGHT, CButton.GREEN, true);
        _b.setTextFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_b);
        _txtBtn = new CTextField(200, 34, String(g.managerLanguage.allTexts[410]));
        _txtBtn.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.GREEN_COLOR);
//        _b.addChild(_txtBtn);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
//        im.x = 150;
//        im.y = 1;
//        MCScaler.scale(im,30,30);
        var sensi:SensibleBlock = new SensibleBlock();
        sensi.textAndImage(_txtBtn,im,265);
        _b.addSensBlock(sensi,0,25);
//        _b.addChild(im);
        _b.y = 190;
        _b.clickCallback = onClick;
//        _b.addChild(_txtBtn);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_blue_cell_big'));
        im.x = -im.width/2;
        im.y = -im.height/4 - 10;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_blue_cell_big_white'));
        im.x = -im.width/2;
        im.y = 70;
        _source.addChild(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        im.x = 20;
        im.y = 94;
        _source.addChild(im);

    }

    private function onClickExit(e:Event=null):void {
        if (g.tuts.isTuts) return;
        super.hideIt();
    }

    override public function showItParams(f:Function, params:Array):void {
        super.showIt();
        _callback = f;
        _data = params[0];
        _count = params[1];
        _cost = params[2];
        var im:Image;
        if (_data.buildType == BuildType.PLANT) {
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
        } else im = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop));
        im.x = -im.width/2;
        im.y = -im.height/7- 10;
        _source.addChild(im);
        var txt:CTextField = new CTextField(333, 100,String(_count));
        txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -272;
        txt.y = 10;
        txt.alignH = Align.RIGHT;
        _source.addChild(txt);
        txt = new CTextField(333, 100,String(_cost));
        txt.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        txt.alignH = Align.LEFT;
        txt.x = - 5 - txt.textBounds.width/2;
        txt.y = 58;
        _source.addChild(txt);
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.user.hardCurrency < 1) {
            g.windowsManager.closeAllWindows();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        if (_callback != null) {
            _callback.apply(null,[]);
        }
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (_txtInfo) {
            _source.removeChild(_txtInfo);
            _txtInfo.deleteIt();
            _txtInfo = null;
        }
        if (_txt) {
            _source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        if (_txtBtn) {
            _b.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_b);
        _b.deleteIt();
        _b = null;
        _callback = null;
        super.deleteIt();
    }
}
}
