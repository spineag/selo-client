/**
 * Created by andy on 10/15/17.
 */
package windows.miniSceneOrderCat {
import manager.ManagerFilters;
import manager.ManagerLanguage;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOMiniSceneOrderCat extends WindowMain{
    private var _txt:CTextField;
    private var _txtName:CTextField;
    private var _dataCat:Object;
    private var _callback:Function;
    private var _btn:CButton;

    public function WOMiniSceneOrderCat() {
        super();
        _windowType = WindowsManager.WO_ORDER_CAT_MINI;
        _woWidth = 500;
        _woHeight = 400;
        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 130);
        _source.addChild(_woBGNew);
        _callbackClickBG = onClickExit;
        _txtName = new CTextField(300, 70, g.managerLanguage.allTexts[352]);
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtName.x = -150;
        _txtName.y = -_woHeight/2 + 20;
        _source.addChild(_txtName);

        _txt = new CTextField(400, 100, '');
        _txt.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR);
        _txt.x = -200;
        _txt.y = -50;
        _source.addChild(_txt);

        _btn = new CButton();
        _btn.addButtonTexture(144, CButton.HEIGHT_41, CButton.GREEN, true);
        _btn.y = 145;
        _btn.addTextField(144, 35, 0, 0, g.managerLanguage.allTexts[328]);
        _btn.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.clickCallback = onClickExit;
        _source.addChild(_btn);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _dataCat = params[0];
        _callback = callback;
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
