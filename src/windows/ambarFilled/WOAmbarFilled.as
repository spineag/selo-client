/**
 * Created by user on 8/19/15.
 */
package windows.ambarFilled {
import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.ProgressBarComponent;
import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;
import windows.ambar.WOAmbars;

public class WOAmbarFilled extends WindowMain {

    private var _btn:CButton;
    private var _woBG:WindowBackgroundNew;
    private var _imageAmbar:Image;
    private var _txtBtn:CTextField;
    private var _txtAmbarFilled:CTextField;
    private var _txtWhatDo:CTextField;
    private var _txtCount:CTextField;
    private var _isAmbar:Boolean;
    private var _imAmbarSklad:Image;
    private var _bar:ProgressBarComponent;

    public function WOAmbarFilled() {
        super();
        _windowType = WindowsManager.WO_AMBAR_FILLED;
        _woWidth = 550;
        _woHeight = 450;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        SOUND_OPEN = SoundConst.WO_AHTUNG;


        _btn = new CButton();
        _btn.addButtonTexture(200, CButton.BIG_HEIGHT, CButton.GREEN, true);
//        _btn.addTextField(200, 40, 0, 0, String(g.managerLanguage.allTexts[308]));
        _btn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.LIGHT_GREEN_COLOR);
//        _source.addChild(_btn);


//        _btn = new CButton();
        _btn.clickCallback = onClick;
//        _btn.addButtonTexture(200, 40, CButton.RED, true);
        _txtBtn = new CTextField(200,50,"");
        _txtBtn.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _txtBtn.y = -5;
//        _txtBtn.touchable = true;
        _btn.addChild(_txtBtn);
        _btn.y = 170;
        _source.addChild(_btn);
        _imageAmbar = new Image(g.allData.atlas['interfaceAtlas'].getTexture("storage_window_pr"));
        _imageAmbar.x = -160;
        _imageAmbar.y = 60;
        _imageAmbar.touchable = false;
        MCScaler.scale(_imageAmbar,49,320);
//        _txtAmbarFilled = new CTextField(220,50,"");
//        _txtAmbarFilled.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtAmbarFilled = new CTextField(400,50,'');
        _txtAmbarFilled.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txtAmbarFilled.x = -210;
        _txtAmbarFilled.y = -190;
        _txtAmbarFilled.touchable = false;
        _source.addChild(_txtAmbarFilled);

        _txtWhatDo = new CTextField(400,50,'');
        _txtWhatDo.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW);
        _txtWhatDo.x = -210;
        _txtWhatDo.y = -110;
        _txtWhatDo.touchable = false;
        _source.addChild(_txtWhatDo);

        _txtCount = new CTextField(240,50,"");
        _txtCount.setFormat(CTextField.BOLD18, 17, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCount.x = -120;
        _txtCount.y = 16;
        _txtCount.touchable = false;
//        _source.addChild(_txtCount);
        _source.addChild(_imageAmbar);
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_l'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_c'),
                g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_r'), 308);
        _bar.x = _imageAmbar.x + 5;
        _bar.y = _imageAmbar.y + 9;
//        _source.addChild(_bar);
    }

    private function onClick():void {
        hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_AMBAR, null, _isAmbar, true);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _isAmbar = params[0];
        if (_isAmbar) {
            _txtCount.text = String(g.managerLanguage.allTexts[458]) + " " + String(g.userInventory.currentCountInAmbar) + "/" + String(g.user.ambarMaxCount);
            _txtAmbarFilled.text = String(g.managerLanguage.allTexts[457]);
            _txtBtn.text = String(g.managerLanguage.allTexts[459]);
            _imAmbarSklad = new Image(g.allData.atlas['iconAtlas'].getTexture('ambar_icon'));
            _txtWhatDo.text = String(g.managerLanguage.allTexts[457]);
        } else {
            _txtCount.text = String(g.managerLanguage.allTexts[458]) + " " + String(g.userInventory.currentCountInSklad) + "/" + String(g.user.skladMaxCount);
            _txtAmbarFilled.text = String(g.managerLanguage.allTexts[461]);
            _txtBtn.text = String(g.managerLanguage.allTexts[460]);
            _imAmbarSklad = new Image(g.allData.atlas['iconAtlas'].getTexture('sklad_icon'));
            _txtWhatDo.text = String(g.managerLanguage.allTexts[457]);
        }
        _bar.progress = 1;
//        MCScaler.scale(_imAmbarSklad, 60, 60);
        _imAmbarSklad.x = -_imAmbarSklad.width/2;
        _imAmbarSklad.y = _imageAmbar.y - 60;
        _source.addChild(_imAmbarSklad);
        super.showIt();
    }

    override protected function deleteIt():void {
        _txtAmbarFilled.deleteIt();
        _txtAmbarFilled = null;
        _txtBtn.deleteIt();
        _txtBtn = null;
        _txtCount.deleteIt();
        _txtCount = null;
        _source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_bar);
        _bar.deleteIt();
        _bar = null;
        super.deleteIt();
    }

}
}