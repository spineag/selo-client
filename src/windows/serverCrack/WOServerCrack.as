/**
 * Created by user on 7/14/16.
 */
package windows.serverCrack {
import com.junkbyte.console.Cc;

import manager.ManagerFilters;

import media.SoundConst;

import starling.display.Image;

import starling.text.TextField;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOServerCrack  extends WindowMain {
    private var _txtError:CTextField;
    private var _woBG:WindowBackground;
    private var _b:CButton;
    private var txt:CTextField;
    private var txt2:CTextField;

    public function WOServerCrack() {
        super();
        _windowType = WindowsManager.WO_SERVER_CRACK;
        _woWidth = 460;
        _woHeight = 340;
        _woBG = new WindowBackground(_woWidth, _woHeight);
        _source.addChild(_woBG);
        txt = new CTextField(420,80,String(g.managerLanguage.allTexts[290]));
        txt.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        txt.x = -210;
        txt.y = -130;
        _source.addChild(txt);
        _txtError = new CTextField(340,100,String(g.managerLanguage.allTexts[282]));
        _txtError.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtError.x = -170;
        _txtError.y = -170;
        _source.addChild(_txtError);
        _txtError.touchable = false;
        _b = new CButton();
        _b.addButtonTexture(210, 34, CButton.GREEN, true);
        _b.y = 120;
        _source.addChild(_b);
        txt2 = new CTextField(200, 34, String(g.managerLanguage.allTexts[281]));
        txt2.setFormat(CTextField.MEDIUM18, 16, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _b.addChild(txt2);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cat_blue'));
        im.x = -35;
        im.y = -65;
        _source.addChild(im);
        _b.clickCallback = onClick;
        SOUND_OPEN = SoundConst.WO_AHTUNG;
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();

        if (params[0]) {
            _txtError.text = String(g.managerLanguage.allTexts[282]) + ' ' + String(params[0]);
            Cc.error('WOServerCrack: status=' + params[0]);
        }
    }

    private function onClick():void {
        g.socialNetwork.reloadGame();
    }

    override protected function deleteIt():void {
        if (txt) {
            _source.removeChild(txt);
            txt.deleteIt();
            txt = null;
        }
        if (_txtError) {
            _source.removeChild(_txtError);
            _txtError.deleteIt();
            _txtError = null;
        }
        if (txt2) {
            _b.removeChild(_txtError);
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
