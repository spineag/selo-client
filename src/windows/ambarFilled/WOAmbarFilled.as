package windows.ambarFilled {
import manager.ManagerFilters;
import media.SoundConst;
import starling.display.Image;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import windows.WOComponents.ProgressBarComponent;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOAmbarFilled extends WindowMain {
    private var _btn:CButton;
    private var _woBG:WindowBackgroundNew;
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
        _btn.addButtonTexture(200, CButton.HEIGHT_55, CButton.GREEN, true);
        _btn.clickCallback = onClick;
        _txtBtn = new CTextField(200,50,"");
        _txtBtn.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btn.addChild(_txtBtn);
        _btn.y = 170;
        _source.addChild(_btn);
        
        _txtAmbarFilled = new CTextField(400,50,'');
        _txtAmbarFilled.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txtAmbarFilled.x = -210;
        _txtAmbarFilled.y = -190;
        _txtAmbarFilled.touchable = false;
        _source.addChild(_txtAmbarFilled);

        _txtWhatDo = new CTextField(450,150,"");
        _txtWhatDo.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW);
        _txtWhatDo.x = -230;
        _txtWhatDo.y = -140;
        _txtWhatDo.touchable = false;
        _source.addChild(_txtWhatDo);

        _txtCount = new CTextField(240,50,"");
        _txtCount.setFormat(CTextField.BOLD18, 17, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCount.x = -120;
        _txtCount.y = 16;
        _txtCount.touchable = false;
        _bar = new ProgressBarComponent(g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_l'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_c'),
             g.allData.atlas['interfaceAtlas'].getTexture('storage_window_prl_r'), 308);
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
            _txtWhatDo.text = String(g.managerLanguage.allTexts[1152]);
        } else {
            _txtCount.text = String(g.managerLanguage.allTexts[458]) + " " + String(g.userInventory.currentCountInSklad) + "/" + String(g.user.skladMaxCount);
            _txtAmbarFilled.text = String(g.managerLanguage.allTexts[461]);
            _txtBtn.text = String(g.managerLanguage.allTexts[460]);
            _imAmbarSklad = new Image(g.allData.atlas['iconAtlas'].getTexture('sklad_icon'));
            _txtWhatDo.text = String(g.managerLanguage.allTexts[1153]);
        }
        _bar.progress = 1;
        _imAmbarSklad.x = -_imAmbarSklad.width/2;
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