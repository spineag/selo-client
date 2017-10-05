/**
 * Created by andy on 8/10/17.
 */
package windows.tutorial {
import manager.ManagerFilters;

import starling.utils.Color;

import utils.CButton;

import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTutorial extends WindowMain {
    private var _woBG:WindowBackground;
    private var _callback:Function;
    private var _txt:CTextField;
    private var _btn:CButton;

    public function WOTutorial() {
        super();
        _windowType = WindowsManager.WO_SERVER_ERROR;
        _woWidth = 500;
        _woHeight = 420;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        _callbackClickBG = closeWindow;

        _txt = new CTextField(300,100,'');
        _txt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -150;
        _txt.y = -210;
        _source.addChild(_txt);

        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.GREEN, true);
        _btn.y = _woHeight/2 - 10;
        _source.addChild(_btn);
        _btn.clickCallback = closeWindow;
        var t:CTextField = new CTextField(120, 38, 'Далее');
        t.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btn.addChild(t);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _callback = callback;
        _txt.text = String(params[0]);
        super.showIt();
    }

    private function closeWindow():void {
        if (_callback != null) _callback.apply();
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (!_source) return;
        if (_txt) {
            _source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        if (_btn) {
            _source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        super.deleteIt();
    }
}
}
