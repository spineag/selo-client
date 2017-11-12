/**
 * Created by user on 10/22/15.
 */
package windows.buyForHardCurrency {
import manager.ManagerFilters;
import manager.ManagerLanguage;

import starling.display.Image;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyForHardCurrency extends WindowMain {
    private var _btnYes:CButton;
    private var _btnNo:CButton;
    private var _txt:CTextField;
    private var _txt2:CTextField;
    private var _id:int;
    private var _count:int;
    private var _woBG:WindowBackgroundNew;
    private var _callback:Function;

    public function WOBuyForHardCurrency() {
        super();
        _windowType = WindowsManager.WO_BUY_FOR_HARD;
        _woWidth = 460;
        _woHeight = 400;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        _btnYes = new CButton();
        _btnYes.addButtonTexture(100, CButton.HEIGHT_41, CButton.GREEN, true);
        _btnYes.addTextField(100, 40, 0, -5, String(g.managerLanguage.allTexts[308]));
        _btnYes.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btnYes);

        _btnNo = new CButton();
        _btnNo.addButtonTexture(100, CButton.HEIGHT_41, CButton.RED, true);
        _btnNo.addTextField(100, 40, 0, -5, String(g.managerLanguage.allTexts[309]));
        _btnNo.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.RED_COLOR);
        _source.addChild(_btnNo);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("currency_buy_window"));
        _source.addChild(im);
        im.x = -50;
        im.y = -20;
        _txt = new CTextField(400,50,String(g.managerLanguage.allTexts[446]));
        _txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
        _txt.x = -202;
        _txt.y = -80;
        _source.addChild(_txt);
        _txt2 = new CTextField(500,70,String(g.managerLanguage.allTexts[326]));
        _txt2.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txt2.x = -250;
        if (g.user.language == ManagerLanguage.RUSSIAN) _txt2.y = -175;
            else _txt2.y = -175;
        _source.addChild(_txt2);
        _btnNo.clickCallback = onClickExit;
        _btnYes.x = 100;
        _btnYes.y = 150;
        _btnNo.x = -100;
        _btnNo.y = 150;

        _source.addChild(_btnYes);
        _source.addChild(_btnNo);
    }

    private function lockedLand():void {
        if (g.user.hardCurrency < _count * g.allData.getResourceById(_id).priceHard) {
            g.windowsManager.uncasheWindow();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            super.hideIt();
            return;
        }
        _btnYes.clickCallback = null;
        g.userInventory.addMoney(1,-_count * g.allData.getResourceById(_id).priceHard);
        g.userInventory.addResource(_id,_count);
        super.hideIt();
    }

    private function marketPapper():void {
        super.hideIt();
        if (_callback != null) {
            _callback.apply(null);
            _callback = null;
        }

    }

    private function onClickExit():void {
        g.windowsManager.uncasheWindow();
        super.hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        switch (params[0]) {
            case 'lockedLand':
                _id = params[1];
                _count = params[2] - g.userInventory.getCountResourceById(_id);
                _btnYes.clickCallback = lockedLand;
                break;
            case 'market':
                _callback = callback;
                _btnYes.clickCallback =  marketPapper;
                break;
        }
        super.showIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_btnNo);
        _btnNo.deleteIt();
        _btnNo = null;
        _source.removeChild(_btnYes);
        _btnYes.deleteIt();
        _btnYes = null;
        super.deleteIt();
    }
}
}
