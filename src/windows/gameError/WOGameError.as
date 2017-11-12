/**
 * Created by user on 9/29/15.
 */
package windows.gameError {
import flash.events.Event;
import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOGameError extends WindowMain {
    private var _txtError:CTextField;
    private var _b:CButton;
    private var _woBG:WindowBackgroundNew;
    private var _txt:CTextField;

    public function WOGameError() {
        super();
        _windowType = WindowsManager.WO_GAME_ERROR;
        _woWidth = 460;
        _woHeight = 430;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,115);
        _source.addChild(_woBG);
        _txt = new CTextField(460,100,String(g.managerLanguage.allTexts[289]));
        _txt.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW);
        _txt.autoScale = true;
        _txt.x = -230;
        _txt.y = -110;
        _txt.touchable = false;
        _source.addChild(_txt);
        _txtError = new CTextField(300,70,String(g.managerLanguage.allTexts[283]));
        _txtError.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtError.x = -160;
        _txtError.y = -185;
        _source.addChild(_txtError);
        _txtError.touchable = false;
        _b = new CButton();
        _b.addButtonTexture(210, CButton.HEIGHT_41, CButton.BLUE, true);
        _b.addTextField(210, 40, 0, -5, String(g.managerLanguage.allTexts[281]));
        _b.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _source.addChild(_b);
        _b.clickCallback = onClick;
        _b.y = 175;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_blue'));
        im.x = -35;
        im.y = -5;
        _source.addChild(im);
//        _b.clickCallback = onClick;
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
//        _txtError.text = params[0];
        super.showIt();
    }

    private function onClick():void {
        if (g.isDebug) hideIt();
        else g.socialNetwork.reloadGame();
    }

    override protected function deleteIt():void {
        if (_txt) {
            _source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        if (_txtError) {
            _source.removeChild(_txtError);
            _txtError.deleteIt();
            _txtError = null;
        }
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _source.removeChild(_b);
        _b.deleteIt();
        _b = null;
        super.deleteIt();
    }
}
}
