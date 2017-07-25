/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.filters.BlurFilter;
import starling.filters.DropShadowFilter;
import starling.text.TextField;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.CartonBackground;

public class ShopTabBtn {
    private var _source:CSprite;
    private var _shopSprite:Sprite;
    private var _shopSource:Sprite;
    private var _defaultX:int;
    private var _defaultY:int;
    private var _bg:CartonBackground;
    private var _imNotification:Image;
    private var _txtNotification:CTextField;
    private var _txtTabName:CTextField;
    private var _type:int;
    private var g:Vars = Vars.getInstance();

    public function ShopTabBtn(type:int, f:Function, shopSprite:Sprite, shopSource:Sprite) {
        _shopSprite = shopSprite;
        _shopSource = shopSource;
        _source = new CSprite();
        _type = type;
        _bg = new CartonBackground(123, 100);
        _bg.touchable = true;
        _source.addChild(_bg);
        _txtTabName = new CTextField(123, 100, '');
        _txtTabName.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtTabName.y = 10;
        var f1:Function = function():void {
            if (g.managerCutScenes.isCutScene) return;
            if (g.managerTutorial.isTutorial) return;
            if (f!=null) f.apply();
        };
        _source.endClickCallback = f1;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;

        var im:Image;
        switch (type) {
            case WOShop.VILLAGE:
                _txtTabName.text = String(g.managerLanguage.allTexts[347]);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_court'));
                if (g.user.villageNotification > 0) addNotification(g.user.villageNotification);
                break;
            case WOShop.ANIMAL:
                _txtTabName.text = String(g.managerLanguage.allTexts[348]);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_animals'));
                break;
            case WOShop.FABRICA:
                _txtTabName.text = String(g.managerLanguage.allTexts[349]);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_fabric'));
                if (g.user.fabricaNotification > 0) addNotification(g.user.fabricaNotification);
                break;
            case WOShop.PLANT:
                _txtTabName.text = String(g.managerLanguage.allTexts[350]);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_plants'));
                if (g.user.plantNotification > 0) addNotification(g.user.plantNotification);
                break;
            case WOShop.DECOR:
                _txtTabName.text = String(g.managerLanguage.allTexts[351]);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_decor'));
                if (g.user.decorNotification > 0) addNotification(g.user.decorNotification);
                break;
        }
        im.x = 62 - im.width/2;
        im.y = 38 - im.height/2;
        _source.addChild(im);
        _source.addChild(_txtTabName);
        _txtTabName.touchable = true;
    }

    private function addNotification(count:int):void {
        _imNotification = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_m_big'));
        MCScaler.scale(_imNotification,25,25);
        _imNotification.x = 100;
        _imNotification.y = -5;
        _source.addChild(_imNotification);
        _txtNotification = new CTextField(30, 20, String(count));
        _txtNotification.setFormat(CTextField.BOLD18, 14, Color.WHITE);
        _txtNotification.x = 98;
        _txtNotification.y = -4;
        _source.addChild(_txtNotification);
    }

    public function activateIt(value:Boolean):void {
        if (value) {
            _source.filter = null;
            if (_shopSource.contains(_source)) _shopSource.removeChild(_source);
            if (!_shopSprite.contains(_source)) _shopSprite.addChild(_source);
            _source.x = _defaultX;
            _source.y = _defaultY;
            _source.isTouchable = false;
        } else {
            if (_shopSprite.contains(_source)) _shopSprite.removeChild(_source);
            if (!_shopSource.contains(_source)) _shopSource.addChild(_source);
            _source.filter = ManagerFilters.SHADOW;
            _shopSource.setChildIndex(_source, _shopSource.getChildIndex(_shopSprite));
            _source.x = _defaultX + _shopSprite.x;
            _source.y = _defaultY +_shopSprite.y + 10;
            _source.isTouchable = true;
        }
    }

    public function setPosition(x:int, y:int):void {
        _defaultX = x;
        _defaultY = y;
    }

    public function closeNotification():void {
        switch (_type) {
            case WOShop.VILLAGE:
                if (g.user.villageNotification > 0) {
                    g.user.allNotification = g.user.allNotification - g.user.villageNotification;
                    g.user.villageNotification = 0;
                    _imNotification.visible = false;
                    _txtNotification.visible = false;
                }
                break;
            case WOShop.ANIMAL:
                break;
            case WOShop.FABRICA:
                if (g.user.fabricaNotification > 0) {
                    g.user.allNotification = g.user.allNotification - g.user.fabricaNotification;
                    g.user.fabricaNotification = 0;
                    _imNotification.visible = false;
                    _txtNotification.visible = false;
                }
                break;
            case WOShop.PLANT:
                if (g.user.plantNotification > 0) {
                    g.user.allNotification = g.user.allNotification - g.user.plantNotification;
                    g.user.plantNotification = 0;
                    _imNotification.visible = false;
                    _txtNotification.visible = false;
                }
                break;
            case WOShop.DECOR:
                if (g.user.decorNotification > 0) {
                    g.user.allNotification = g.user.allNotification - g.user.decorNotification;
                    g.user.decorNotification = 0;
                    _imNotification.visible = false;
                    _txtNotification.visible = false;
                }
                break;
        }

    }

    private function onOut():void {
        _source.y = _defaultY + _shopSprite.y + 10;
    }

    private function onHover():void {
        _source.y = _defaultY + _shopSprite.y + 3;
    }

    public function deleteIt():void {
        if (_shopSource.contains(_source)) _shopSource.removeChild(_source);
        if (_shopSprite.contains(_source)) _shopSprite.removeChild(_source);
        _source.removeChild(_bg);
        _bg.deleteIt();
        _bg = null;
        _imNotification = null;
        if (_txtTabName) {
            _source.removeChild(_txtTabName);
            _txtTabName.deleteIt();
            _txtTabName = null;
        }
        if (_txtNotification) {
            _source.removeChild(_txtNotification);
            _txtNotification.deleteIt();
            _txtNotification = null;
        }
        _shopSource = null;
        _shopSprite = null;
        _source.deleteIt();
        _source = null;
    }
}
}
