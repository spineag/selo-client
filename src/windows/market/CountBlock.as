/**
 * Created by user on 8/25/15.
 */
package windows.market {
import data.BuildType;
import data.StructureDataResource;

import manager.ManagerFilters;
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.filters.ColorMatrixFilter;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;

import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

public class CountBlock {
    public var source:Sprite;
    public var _btnMinus:CButton;
    public var _btnPlus:CButton;
//    private var _plawkaBg:Image;
    private var _txt:CTextField;
    private var _curCount:int;
    private var _max:int;
    private var _min:int;
    private var _callback:Function;
    private var _coinIm:Image;
    private var _imResource:Image;
    private var _coinBo:Boolean;

    private var g:Vars = Vars.getInstance();

    public function CountBlock(coin:Boolean = false) {
        var im:Image;
        _curCount = 0;
        source = new Sprite();
        _btnMinus = new CButton();

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_out_button'));
        MCScaler.scale(im, 50, 50);
        _btnMinus.addDisplayObject(im);

        _btnPlus = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_add_button'));
        MCScaler.scale(im, 50, 50);
        _btnPlus.addDisplayObject(im);
        _txt = new CTextField(80, 50, '0');
        _txt.setFormat(CTextField.BOLD24, 24, ManagerFilters.LIGHT_BLUE_COLOR);
        _txt.alignH = Align.LEFT;
//        _plawkaBg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka7'));
        _btnPlus.startClickCallback = onStartPlus;
        _btnPlus.clickCallback = onEndPlus;
        _btnMinus.startClickCallback = onStartMinus;
        _btnMinus.clickCallback = onEndMinus;
        _coinBo = coin;
        if (coin) {
            _coinIm = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_medium'));
            _coinIm.x = -33;
            _coinIm.y = -15;
            source.addChild(_coinIm);
        }
        btnFilter();
    }

    public function btnNull():void {
        _btnMinus.filter = null;
        _btnPlus.filter = null;
    }

    public function btnFilter():void {
        _btnMinus.filter = ManagerFilters.DISABLE_FILTER;
        _btnPlus.filter = ManagerFilters.DISABLE_FILTER;
    }
    
    public function updateTextField():void {
        
    }

    public function set setWidth(a:int):void {
//        if (!_coinBo) _txt.x = 30 - _txt.textBounds.width/2;
        _txt.x =  25 - _txt.textBounds.width/2;


        _txt.y = -_txt.height/2 + 3;
        source.addChild(_txt);
        _btnMinus.x = -41 - _btnMinus.width;
        _btnMinus.y = -_btnMinus.height/2 + 5;
        _btnPlus.x = 65;
        _btnPlus.y = -_btnPlus.height/2 + 5;
        source.addChild(_btnMinus);
        source.addChild(_btnPlus);
    }

    public function set maxValue(a:int):void {
        _max = a;
        if (_max < _curCount) {
            count = _max;
        }
    }

    public function set minValue(a:int):void {
        _min = a;
    }

    public function set count(a:int):void {
        _curCount = a;
        _txt.text = String(_curCount);
    }

    public function get count():int {
        return _curCount;
    }

    public function set onChangeCallback(f:Function):void {
        _callback = f;
    }

    private var delta:int;
    private var timer:int;
    private function onStartPlus():void {
        timer = 0;
        delta = 0;
        g.gameDispatcher.addEnterFrame(plusRender);
    }

    public function resourceChoose(id:int):void {
        var _data:StructureDataResource = g.allData.getResourceById(id);
        if (_imResource) {
            _imResource.dispose();
            _imResource = null;
        }
        if (_data) {
            if (_data.buildType == BuildType.PLANT) {
                _imResource = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
            } else {
                _imResource = new Image(g.allData.atlas[_data.url].getTexture(_data.imageShop));
            }
        }
        _imResource.x = -35;
        _imResource.y = -19;
        MCScaler.scale(_imResource,50,50);
        source.addChild(_imResource);
    }

    private function onEndPlus():void {
//        _btnMinus.filter = null;
        _btnMinus.setEnabled = true;
        g.gameDispatcher.removeEnterFrame(plusRender);
        if (timer <= 15 && _curCount < _max) {
            _curCount++;
            _txt.text = String(_curCount);
        }
        if (_callback != null) {
            _callback.apply(null, [true]);
        }
        checkPlusBtn();
    }

    private function plusRender():void {
        timer++;
        if (timer > 15 && _curCount < _max) {
            delta++;
            _curCount += delta;
            if (_curCount > _max) {
                _curCount = _max;
            }
            _txt.text = String(_curCount);
        }
    }

    private function onStartMinus():void {
        timer = 0;
        delta = 0;
        g.gameDispatcher.addEnterFrame(minusRender);
    }

    private function onEndMinus():void {
//        _btnPlus.filter = null;
        _btnPlus.setEnabled = true;
        g.gameDispatcher.removeEnterFrame(minusRender);
        if (timer <= 15 && _curCount > _min) {
            _curCount--;
            _txt.text = String(_curCount);
        }
        if (_callback != null) {
            _callback.apply(null, [false]);
        }
        checkMinusBtn();
    }

    private function minusRender():void {
        timer++;
        if (timer > 15 && _curCount > _min) {
            delta++;
            _curCount -= delta;
            if (_curCount < _min) {
                _curCount = _min;
            }
            _txt.text = String(_curCount);
        }
    }

    private function checkPlusBtn():void {
        if (_curCount >= _max) {
//            _btnPlus.filter = ManagerFilters.DISABLE_FILTER;
            _btnPlus.setEnabled = false;
        } else {
//            _btnPlus.filter = null;
            _btnPlus.setEnabled = true;
        }
    }

    private function checkMinusBtn():void {
        if (_curCount <= _min) {
//            _btnMinus.filter = ManagerFilters.DISABLE_FILTER;
            _btnMinus.setEnabled = false;
        } else {
//            _btnMinus.filter = null;
            _btnMinus.setEnabled = true;
        }
    }

    public function deleteIt():void {
//        btnNull();
        if (_txt) {
            source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        source.removeChild(_btnMinus);
        _btnMinus.deleteIt();
        _btnMinus = null;
        source.removeChild(_btnPlus);
        _btnPlus.deleteIt();
        _btnPlus = null;
        source.dispose();
        source = null;
    }

}
}
