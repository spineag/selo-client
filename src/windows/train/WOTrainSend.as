/**
 * Created by user on 1/26/16.
 */
package windows.train {
import build.train.Train;

import manager.ManagerFilters;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTrainSend extends WindowMain {
    private var _woBG:WindowBackgroundNew;
    private var _btnYes:CButton;
    private var _btnNo:CButton;
    private var _callback:Function;
    private var _build:Train;
    private var _txtA:CTextField;
    private var _txtB:CTextField;
    private var _txtYes:CTextField;
    private var _txtNo:CTextField;

    public function WOTrainSend() {
        super();
        _windowType = WindowsManager.WO_TRAIN_SEND;
        _woWidth = 460;
        _woHeight = 400;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight, 120);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _txtA = new CTextField(400,50,String(g.managerLanguage.allTexts[306]));
        _txtA.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txtA.x = -200;
        _txtA.y = -150;
        _source.addChild(_txtA);
        _txtB = new CTextField(400,100,String(g.managerLanguage.allTexts[307]));
        _txtB.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtB.x = -200;
        _txtB.y = -85;
        _source.addChild(_txtB);

        _btnYes = new CButton();
        _btnYes.addButtonTexture(80, CButton.HEIGHT_41, CButton.RED, true);
        _btnYes.addTextField(80, 38, 0, 0, String(g.managerLanguage.allTexts[308]));
        _btnYes.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.RED_COLOR);
        _source.addChild(_btnYes);
        _btnYes.clickCallback = onYes;

        _btnNo = new CButton();
        _btnNo.addButtonTexture(80, CButton.HEIGHT_41, CButton.GREEN, true);
        _btnNo.addTextField(80, 38, 0, 0, String(g.managerLanguage.allTexts[309]));
        _btnNo.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btnNo);
        _btnNo.clickCallback = onNo;

//        _btnNo = new CButton();
//        _btnNo.addButtonTexture(80, 40, CButton.GREEN, true);
//        _btnYes = new CButton();
//        _btnYes.addButtonTexture(80, 40, CButton.PINK, true);
//        _txtYes = new CTextField(50,50,String(g.managerLanguage.allTexts[308]));
//        _txtYes.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.RED_COLOR);
//        _txtYes.x = 15;
//        _txtYes.y = -5;
//        _btnYes.addChild(_txtYes);
//        _txtNo = new CTextField(50,50,String(g.managerLanguage.allTexts[309]));
//        _txtNo.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
//        _txtNo.x = 15;
//        _txtNo.y = -5;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('basket_big'));
        im.x = -65;
        im.y = 5;
        _source.addChild(im);
        _btnYes.x = -100;
        _btnYes.y = 150;
        _btnNo.x = 100;
        _btnNo.y = 150;
//        _btnNo.addChild(_txtNo);
//        _source.addChild(_btnYes);
//        _source.addChild(_btnNo);
//        _btnNo.clickCallback = onNo;
//        _btnYes.clickCallback = onYes;
//        _callbackClickBG = onNo;
    }

    override public function showItParams(f:Function, params:Array):void {
        _callback = f;
        _build = params[0];
        super.showIt();
    }

    private function onYes():void {
        if (_callback != null) {
            _callback.apply(null,[false,true]);
            _callback = null;
        }
//        (_build as Train).fullTrain(true);
//        g.windowsManager.uncasheWindow();
        super.hideIt();
    }

    private function onNo():void {
//        g.windowsManager.uncasheWindow();
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (_txtA) {
            _source.removeChild(_txtA);
            _txtA.deleteIt();
            _txtA = null;
        }
        if (_txtB) {
            _source.removeChild(_txtB);
            _txtB.deleteIt();
            _txtB = null;
        }
        if (_txtYes) {
            _btnYes.removeChild(_txtYes);
            _txtYes.deleteIt();
            _txtYes = null;
        }
        if (_txtNo) {
            _btnNo.removeChild(_txtNo);
            _txtNo.deleteIt();
            _txtNo = null;
        }
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _callback = null;
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
