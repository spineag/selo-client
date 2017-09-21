/**
 * Created by andy on 9/4/17.
 */
package windows.shop_new {

import windows.WOComponents.BackgroundYellowOut;

public class ShopNewTabs {
    private var _shopBGSource:BackgroundYellowOut;
    private var _callback:Function;
    private var _activeTabNumber:int;
    private var _btn1:TabButton;
    private var _btn2:TabButton;
    private var _btn3:TabButton;
    private var _btn4:TabButton;
    private var _btn5:TabButton;
    private var _activeTabButton:TabButton;
    private var _isBigShop:Boolean;

    public function ShopNewTabs(bg:BackgroundYellowOut, f:Function, isBigShop:Boolean) {
        _shopBGSource = bg;
        _callback = f;
        _isBigShop = isBigShop;
        _btn1 = new TabButton(WOShopNew.VILLAGE, onTab, _shopBGSource);
        _btn2 = new TabButton(WOShopNew.ANIMAL, onTab, _shopBGSource);
        _btn3 = new TabButton(WOShopNew.FABRICA, onTab, _shopBGSource);
        _btn4 = new TabButton(WOShopNew.PLANT, onTab, _shopBGSource);
        _btn5 = new TabButton(WOShopNew.DECOR, onTab, _shopBGSource);
        activateTab(WOShopNew.VILLAGE);
    }

    public function activateTab(n:int):void {
        _activeTabNumber = n;
        switch (n) {
            case 1:
                _activeTabButton = _btn1;
                _btn1.setPosition(0, 44 + 172/2, true, _isBigShop);
                _btn2.setPosition(44 + 172 + 152/2, 0, false, _isBigShop);
                _btn3.setPosition(44 + 172 + 152 + 152/2, 0, false, _isBigShop);
                _btn4.setPosition(44 + 172 + 2*152 + 152/2, 0, false, _isBigShop);
                _btn5.setPosition(44 + 172 + 3*152 + 152/2, 0, false, _isBigShop);
                break;
            case 2:
                _activeTabButton = _btn2;
                _btn1.setPosition(44 + 152/2, 0,false, _isBigShop);
                _btn2.setPosition(0, 44 + 152 + 172/2, true, _isBigShop);
                _btn3.setPosition(44 + 152 + 172 + 152/2, 0, false, _isBigShop);
                _btn4.setPosition(44 + 2*152 + 172 + 152/2, 0, false, _isBigShop);
                _btn5.setPosition(44 + 3*152 + 172 + 152/2, 0, false, _isBigShop);
                break;
            case 3:
                _activeTabButton = _btn3;
                _btn1.setPosition(44 + 152/2, 0, false, _isBigShop);
                _btn2.setPosition(44 + 152 + 152/2, 0, false, _isBigShop);
                _btn3.setPosition(0, 44 + 2*152 + 172/2, true,  _isBigShop);
                _btn4.setPosition(44 + 2*152 + 172 + 152/2, 0, false, _isBigShop);
                _btn5.setPosition(44 + 3*152 + 172 + 152/2, 0, false, _isBigShop);
                break;
            case 4:
                _activeTabButton = _btn4;
                _btn1.setPosition(44 + 152/2, 0, false, _isBigShop);
                _btn2.setPosition(44 + 152 + 152/2, 0, false, _isBigShop);
                _btn3.setPosition(44 + 2*152 + 152/2, 0, false, _isBigShop);
                _btn4.setPosition(0, 44 + 3*152 + 172/2, true, _isBigShop);
                _btn5.setPosition(44 + 3*152 + 172 + 152/2, 0, false, _isBigShop);
                break;
            case 5:
                _activeTabButton = _btn5;
                _btn1.setPosition(44 + 152/2, 0, false, _isBigShop);
                _btn2.setPosition(44 + 152 + 152/2, 0, false, _isBigShop);
                _btn3.setPosition(44 + 2*152 + 152/2, 0, false, _isBigShop);
                _btn4.setPosition(44 + 3*152 + 152/2, 0, false, _isBigShop);
                _btn5.setPosition(0, 44 + 4*152 + 172/2, true, _isBigShop);
                break;

        }
    }

    private function onTab(n:int):void {
        _callback.apply(null, [n]);
        activateTab(n);
    }

    public function deleteIt():void {
        _btn1.deleteIt();
        _btn2.deleteIt();
        _btn3.deleteIt();
        _btn4.deleteIt();
        _btn5.deleteIt();
        _shopBGSource = null;
    }
}
}


import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import windows.WOComponents.BackgroundYellowOut;

internal class TabButton {
    private var g:Vars = Vars.getInstance();
    private var _tabActive:Sprite;
    private var _tabUnactive:CSprite;
    private var _numberTab:int;
    private var _txtNameActive:CTextField;
    private var _txtNameUnactive:CTextField;
    private var _callback:Function;
    private var _notif:Sprite;
    private var _notifCount:CTextField;
    private var _shopBGSource:BackgroundYellowOut;

    public function TabButton(n:int, f:Function, bg:BackgroundYellowOut) {
        _numberTab = n;
        _callback = f;
        _shopBGSource = bg;

        _tabUnactive = new CSprite();
        var im:Image =  new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_panel_tab_small'));
        im.x = -im.width/2;
        im.y = -im.height;
        _tabUnactive.addChild(im);
        _tabUnactive.y = 7;
        _shopBGSource.source.addChildAt(_tabUnactive,0);
        _tabUnactive.endClickCallback = function():void { _callback.apply(null, [_numberTab]); };

        _tabActive = new Sprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_panel_tab_big'));
        im.x = -im.width/2;
        im.y = -im.height;
        _tabActive.addChild(im);
        _tabActive.y = 9;
        _shopBGSource.source.addChild(_tabActive);

        _txtNameActive = new CTextField(126, 40, '');
        _txtNameActive.setFormat(CTextField.BOLD24, 24, ManagerFilters.BROWN_COLOR, Color.WHITE);
        _txtNameActive.x = -63;
        _txtNameActive.y = -55;
        _tabActive.addChild(_txtNameActive);
        _txtNameUnactive = new CTextField(136, 40, '');
        _txtNameUnactive.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtNameUnactive.x = -68;
        _txtNameUnactive.y = -45;
        _tabUnactive.addChild(_txtNameUnactive);

        switch (n) {
            case 1: _txtNameActive.text = _txtNameUnactive.text = String(g.managerLanguage.allTexts[347]); break;
            case 2: _txtNameActive.text = _txtNameUnactive.text = String(g.managerLanguage.allTexts[348]); break;
            case 3: _txtNameActive.text = _txtNameUnactive.text = String(g.managerLanguage.allTexts[349]); break;
            case 4: _txtNameActive.text = _txtNameUnactive.text = String(g.managerLanguage.allTexts[350]); break;
            case 5: _txtNameActive.text = _txtNameUnactive.text = String(g.managerLanguage.allTexts[351]); break;
        }
    }

    public function setPosition(xU:int, xA:int, isActive:Boolean, isBigShop:Boolean):void {
        var delta:int = 0;
        if (!isBigShop) delta = 28;
        _tabUnactive.x = xU - delta;
        _tabActive.x = xA - delta;
        _tabActive.visible = isActive;
        _tabUnactive.visible = !isActive;
    }

    public function updateNotifCount(n:int):void {

    }

    public function deleteIt():void {
        if (_tabActive) {
            _tabActive.removeChild(_txtNameActive);
            _txtNameActive.deleteIt();
            _shopBGSource.removeChild(_tabActive);
            _tabActive.dispose();
            _tabActive = null;
        }
        if (_tabUnactive) {
            _tabUnactive.removeChild(_txtNameUnactive);
            _txtNameUnactive.deleteIt();
            _shopBGSource.removeChild(_tabUnactive);
            _tabUnactive.deleteIt();
            _tabUnactive = null;
        }
    }

}