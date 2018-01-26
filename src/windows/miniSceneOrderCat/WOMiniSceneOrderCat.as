/**
 * Created by andy on 10/15/17.
 */
package windows.miniSceneOrderCat {
import flash.display.Bitmap;

import manager.ManagerFilters;
import manager.ManagerLanguage;

import starling.display.Image;

import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowMain;
import windows.WindowsManager;
import windows.WindowsManager;

public class WOMiniSceneOrderCat extends WindowMain{
    private var _txt:CTextField;
    private var _txtName:CTextField;
    private var _dataCat:Object;
    private var _callback:Function;
    private var _btn:CButton;
    private var _imCat:Image;
    private var _imBabble:Image;
    private var _isBigShop:Boolean;
    private var _stPNG:String;

    public function WOMiniSceneOrderCat() {
        super();
        _windowType = WindowsManager.WO_ORDER_CAT_MINI;
        _woWidth = 500;
        _woHeight = 400;
//        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 130);
//        _source.addChild(_woBGNew);
        _callbackClickBG = onClickExit;
        if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) _isBigShop = false;
        else _isBigShop = true;
        if (_isBigShop) _stPNG = 'qui/grey_cat_tutorial_babble.png';
        else _stPNG = 'qui/babble_cat_window.png';

        if (_isBigShop) {
            _txtName = new CTextField(300, 70, '');
            _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
            _txtName.x = 120;
            _txtName.y = -_woHeight / 2 - 135;

            _txt = new CTextField(520, 140, '');
            _txt.setFormat(CTextField.BOLD30, 26, ManagerFilters.BLUE_COLOR);
            _txt.x = 5;
            _txt.y = -255;

            _btn = new CButton();
            _btn.addButtonTexture(144, CButton.HEIGHT_41, CButton.GREEN, true);
            _btn.y = -80;
            _btn.x = 280;
            _btn.addTextField(144, 35, 0, 0, g.managerLanguage.allTexts[328]);
            _btn.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            _btn.clickCallback = onClickExit;
        } else {
            _txtName = new CTextField(300, 70, '');
            _txtName.setFormat(CTextField.BOLD72, 50, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
//            _txtName.x = 20;
            _txtName.y = -_woHeight / 2 - 60;

            _txt = new CTextField(360, 140, '');
            _txt.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR);
            _txt.x = -30;
            _txt.y = -200;

            _btn = new CButton();
            _btn.addButtonTexture(120, CButton.HEIGHT_32, CButton.GREEN, true);
            _btn.x = 160;
            _btn.y = -35;
            _btn.addTextField(120, 28, -2, 0, g.managerLanguage.allTexts[328]);
            _btn.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            _btn.clickCallback = onClickExit;
        }

        g.load.loadImage(g.dataPath.getGraphicsPath() + _stPNG, onLoadBabble);
    }

    private function onLoadBabble(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + _stPNG].create() as Bitmap;
        photoFromTextureBabble(Texture.fromBitmap(bitmap));
    }

    private function photoFromTextureBabble(tex:Texture):void {
        _imBabble = new Image(tex);
        _source.addChild(_imBabble);
        _imBabble.x = -90;
        _imBabble.y = -_imBabble.height - 20;
        _source.addChild(_txtName);
        _source.addChild(_txt);
        _source.addChild(_btn);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _dataCat = params[0];
        _callback = callback;
        g.load.loadImage(g.dataPath.getGraphicsPath() + _dataCat.namePng, onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + _dataCat.namePng].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        _imCat = new Image(tex);
        _source.addChild(_imCat);
        _imCat.x = -_imCat.width + 70;
        _imCat.y = -_imCat.height/2-50;
        _txt.text = g.managerLanguage.allTexts[_dataCat.txtMiniScene];
        if (g.user.language == ManagerLanguage.ENGLISH) _txtName.text = _dataCat.nameENG;
        else _txtName.text = _dataCat.nameRU;
        super.showIt();
    }

    private function onClickExit():void {
        if (_callback != null) {
            _callback.apply(null, [_dataCat]);
        }
        super.hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_ORDERS,null,_dataCat);
    }

    override protected function deleteIt():void {
        if (!_source) return;
        _source.removeChild(_txtName);
        _txtName.deleteIt();
        _source.removeChild(_txt);
        _txt.deleteIt();
        _source.removeChild(_btn);
        _btn.deleteIt();
        super.deleteIt();
    }
}
}
