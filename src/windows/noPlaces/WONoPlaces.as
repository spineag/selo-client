package windows.noPlaces {
import data.DataMoney;
import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;
import starling.events.Event;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;

import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WONoPlaces extends WindowMain {
    private var _btn:CButton;
    private var _txtName:CTextField;
    private var _txtText:CTextField;
    private var _txtCost:CTextField;
    private var _txtAdd:CTextField;
    private var _woBG:WindowBackgroundNew;
    private var _price:int;
    private var _cost:int;
    private var _buyCallback:Function;
    private var _exitCallback:Function;
    private var _imageItem:Image;
    private var _last:Boolean;
    private var _txtIcon:CTextField;

    public function WONoPlaces() {
        super();
        _windowType = WindowsManager.WO_NO_PLACES;
        _woWidth = 450;
        _woHeight = 400;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,115);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        SOUND_OPEN = SoundConst.WO_AHTUNG;

        _txtName = new CTextField(350,70,String(g.managerLanguage.allTexts[376]));
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtName.x = -180;
        _txtName.y = -160;
        _source.addChild(_txtName);
        _txtText = new CTextField(320,70,"");
        _txtText.setFormat(CTextField.BOLD24, 24,  ManagerFilters.BLUE_LIGHT_NEW);
        _txtText.x = -160;
        _txtText.y = -80;
        _source.addChild(_txtText);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("plants_factory_y_cell_s"));
        im.x = -50;
        im.y = -5;
        _source.addChild(im);

        _btn = new CButton();
        _btn.addButtonTexture(280, CButton.HEIGHT_41, CButton.GREEN, true);
        _btn.setTextFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btn);
        _txtCost = new CTextField(240, 38, '');
        _txtCost.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btn.y = 160;
        _btn.clickCallback = onClick;

        _source.addChild(im);
        _txtAdd = new CTextField(100,100,"");
        _txtAdd.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _last = false;
        _txtIcon = new CTextField(80,200,String(g.managerLanguage.allTexts[377]));
        _txtIcon.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR);
        _txtIcon.x = -37;
        _txtIcon.y = -57;
        _source.addChild(_txtIcon);
        _txtIcon.visible = false;
    }

    private function onClickExit(e:Event=null):void {
        if (_exitCallback != null) {
            _exitCallback.apply();
            _exitCallback = null;
        }
        super.hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _price = params[0];
        _buyCallback = callback;
        _exitCallback = params[2];
        _last = params[3];
        if (_last) {
            _txtText.text = String(g.managerLanguage.allTexts[378]);
            _imageItem = new Image(g.allData.atlas[g.allData.getResourceById(params[1]).url].getTexture(g.allData.getResourceById(params[1]).imageShop));
            MCScaler.scale(_imageItem,80,80);
            _imageItem.x = -35;
            _imageItem.y = 10;
            _source.addChild(_imageItem);
            _source.addChild(_txtAdd);
            _last = true;
            _cost = params[0];
            _txtCost.text = String(String(g.managerLanguage.allTexts[379]) + " " + String(g.managerLanguage.allTexts[329]) + '  ' + _price);
            _txtAdd.text = String(g.managerLanguage.allTexts[379]);
            _txtAdd.x = -47;
            _txtAdd.y = 30;
            _txtIcon.visible = false;
//            _txtButton.text = 'Ускорить за '
        } else {
            _txtText.text = String(g.managerLanguage.allTexts[380]);
            _btn.visible = true;
            _txtCost.text = String(String(g.managerLanguage.allTexts[381]) + " " + String(g.managerLanguage.allTexts[329]) + ' ' + _price);
            _txtAdd.x = -47;
            _txtAdd.y = -50;
            _txtAdd.text = String(g.managerLanguage.allTexts[381]);
//            _txtButton.text = 'Добавить ячейку за '
            _txtIcon.visible = true;
        }
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_medium'));
        MCScaler.scale(im,32,32);
        im.alignPivot();
        im.x = 260;
        im.y = 20;
        _btn.addChild(im);
        _txtCost.x = 2;
        _btn.addChild(_txtCost);
        super.showIt();
    }

    private function onClick():void {
        if (_last && g.user.hardCurrency >= _price) {
            if (_buyCallback != null) {
                _buyCallback.apply();
                _buyCallback = null;
            }
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_price);
            onClickExit();
            return;
        }
        if (g.user.hardCurrency >= _price) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_price);
            if (_buyCallback != null) {
                _buyCallback.apply();
                _buyCallback = null;
            }
        } else {
            _buyCallback = null;
            g.windowsManager.uncasheWindow();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
        }
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (!_source) return;
        if (_txtName) {
            _source.removeChild(_txtName);
            _txtName.deleteIt();
            _txtName = null;
        }
        if (_txtText) {
            _source.removeChild(_txtText);
            _txtText.deleteIt();
            _txtText = null;
        }
        if (_txtCost) {
            _btn.removeChild(_txtCost);
            _txtCost.deleteIt();
            _txtCost = null;
        }
        if (_txtAdd) {
            _source.removeChild(_txtAdd);
            _txtAdd.deleteIt();
            _txtAdd = null;
        }
        if (_txtIcon) {
            _source.removeChild(_txtIcon);
            _txtIcon.deleteIt();
            _txtIcon = null;
        }
        _source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _buyCallback = null;
        _exitCallback = null;
        super.deleteIt();
    }
}
}
