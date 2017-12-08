/**
 * Created by andy on 8/10/17.
 */
package windows.tutorial {
import manager.ManagerFilters;

import starling.display.Image;

import starling.utils.Color;

import utils.CButton;

import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTutorial extends WindowMain {
    private var _woBG:WindowBackgroundNew;
    private var _callback:Function;
    private var _txt:CTextField;
    private var _numberImage:int;
    private var _btn:CButton;
    private var _image:Image;

    public function WOTutorial() {
        super();
        _windowType = WindowsManager.WO_SERVER_ERROR;
        _woWidth = 500;
        _woHeight = 480;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,115);
        _source.addChild(_woBG);
        _callbackClickBG = closeWindow;

        _txt = new CTextField(400,90,'');
        _txt.setFormat(CTextField.BOLD72, 62, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txt.x = -200;
        _txt.y = -230;
        _source.addChild(_txt);

        _btn = new CButton();
        _btn.addButtonTexture(120, CButton.HEIGHT_41, CButton.GREEN, true);
        _btn.addTextField(120, 40, 0, -5, String(g.managerLanguage.allTexts[532]));
        _btn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btn);
        _btn.clickCallback = closeWindow;
        _btn.y = _woHeight/2 - 33;
    }

    override public function showItParams(callback:Function, params:Array):void {
        _callback = callback;
        _txt.text = String(params[0]);
        _numberImage = int(params[1]);
        if (g.allData.atlas['tutorialAtlas']) {
            if (_image) {
                _source.removeChild(_image);
                _image.dispose();
                _image = null;
            }
            if (int(params[1]) == 1) {
                _image = new Image(g.allData.atlas['tutorialAtlas'].getTexture('harwest_art_1'));

            } else if (int(params[1]) == 2) {
                _image = new Image(g.allData.atlas['tutorialAtlas'].getTexture('crop_art_1'));

            } else if (int(params[1]) == 2) {
                _image = new Image(g.allData.atlas['tutorialAtlas'].getTexture('bakery_art_1'));
            } else {
                _image = new Image(g.allData.atlas['tutorialAtlas'].getTexture('bakery_art_1'));
            }

            _image.x = -_image.width / 2;
            _image.y = -_image.height / 2 + 35;
            _source.addChild(_image);
        } else {
            g.gameDispatcher.addEnterFrame(afterAtlas);
        }
        super.showIt();
    }

    private function afterAtlas():void {
        if (g.allData.atlas['tutorialAtlas']) {
            g.gameDispatcher.removeEnterFrame(afterAtlas);
            if (_image) {
                _source.removeChild(_image);
                _image.dispose();
                _image = null;
            }
            if (_numberImage == 1) {
                _image = new Image(g.allData.atlas['tutorialAtlas'].getTexture('harwest_art_1'));

            } else if (_numberImage == 2) {
                _image = new Image(g.allData.atlas['tutorialAtlas'].getTexture('crop_art_1'));

            } else {
                _image = new Image(g.allData.atlas['tutorialAtlas'].getTexture('bakery_art_1'));
            }

            _image.x = -_image.width / 2;
            _image.y = -_image.height / 2 + 35;
            _source.addChild(_image);
        }
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
