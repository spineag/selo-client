/**
 * Created by user on 4/18/18.
 */
package windows.cafe {
import manager.ManagerFilters;

import utils.CTextField;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOCafeRating extends WindowMain {
    private var _nameTxt:CTextField;

    public function WOCafeRating() {
        super();
        _windowType = WindowsManager.WO_CAFE_RATING;
        _woWidth = 625;
        _woHeight = 600;

        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 115);
        _source.addChild(_woBGNew);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        _nameTxt = new CTextField(300, 60, g.managerLanguage.allTexts[1279]);
        _nameTxt.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _nameTxt.x = -150;
        _nameTxt.y = -_woHeight/2 + 25;
        _source.addChild(_nameTxt);
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }

    override protected function deleteIt():void {
        if (_nameTxt) {
            _nameTxt.deleteIt();
            _nameTxt.dispose();
        }
        super.deleteIt();
    }
}
}
