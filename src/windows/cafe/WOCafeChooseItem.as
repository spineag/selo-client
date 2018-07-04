/**
 * Created by user on 6/26/18.
 */
package windows.cafe {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;

import windows.WOComponents.BackgroundWhiteIn;

import windows.WOComponents.BackgroundYellowOut;

public class WOCafeChooseItem {
    public var source:Sprite;
    private var _smallBg:BackgroundWhiteIn;
    private var _imResource:Image;
    private var _bigBg:BackgroundWhiteIn;
    private var _txtName:CTextField;
    private var _imItem1:Image;
    private var _txtItem1:CTextField;
    private var _txtItem1_1:CTextField;
    private var _imItem2:Image;
    private var _txtItem2:CTextField;
    private var _txtItem2_2:CTextField;
    private var _imItem3:Image;
    private var _btnExit:CButton;
    private var _btnBuy:CButton;
    private var _imPlus:Image;
    private var _imEqually:Image;
    private var _callbackBuy:Function;
    private var _data:Object;

    private var g:Vars = Vars.getInstance();

    public function WOCafeChooseItem(data:Object, callbackExit:Function, callbackBuy:Function) {
        _data = data;
        _callbackBuy = callbackBuy;
        source = new Sprite();
        _smallBg = new BackgroundWhiteIn(120,120);
        _smallBg.x = -335;
        _smallBg.y = -195;
        source.addChild(_smallBg);

        _imResource = new Image(g.allData.atlas['resourceAtlas'].getTexture(data.imageShop));
        _imResource.x = -325;
        _imResource.y = -185;
        source.addChild(_imResource);

        _bigBg = new BackgroundWhiteIn(400,250);
        _bigBg.x = -335;
        _bigBg.y = -70;
        source.addChild(_bigBg);

        _imItem1 = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(data.ingredientsId[0]).imageShop));
        _imItem1.x = -340;
        _imItem1.y = -10;
        source.addChild(_imItem1);

        _imItem2 = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(data.ingredientsId[1]).imageShop));
        _imItem2.x = -200;
        _imItem2.y = -10;
        source.addChild(_imItem2);

        _imItem3 = new Image(g.allData.atlas['resourceAtlas'].getTexture(data.imageShop));
        _imItem3.x = -60;
        _imItem3.y = -10;
        source.addChild(_imItem3);

        _btnExit = new CButton();
        _btnExit.addDisplayObject(new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_close')));
        _btnExit.setPivots();
        _btnExit.x = 50;
        _btnExit.y = -65;
        _btnExit.createHitArea('bt_close');
        source.addChild(_btnExit);
        _btnExit.clickCallback = callbackExit;

        _txtName = new CTextField(120,60, data.name);
        _txtName.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
        _txtName.x = -200;
        _txtName.y = -80;
        source.addChild(_txtName);

        _txtItem1 = new CTextField(120,60, '/'+data.ingredientsCount[0]);
        _txtItem1.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
        _txtItem1.alignH = Align.LEFT;
        _txtItem1.x = -300;
        _txtItem1.y = 60;
        source.addChild(_txtItem1);
        if (g.userInventory.getCountResourceById(data.ingredientsId[0]) >= data.ingredientsCount[0]) _txtItem1.text = String(g.userInventory.getCountResourceById(data.ingredientsId[0])) + '/' + data.ingredientsCount[0];
        else {
            _txtItem1_1 = new CTextField(120, 60, String(g.userInventory.getCountResourceById(data.ingredientsId[0])));
            _txtItem1_1.setFormat(CTextField.BOLD30, 30, ManagerFilters.RED_TXT_NEW);
            _txtItem1_1.alignH = Align.LEFT;
            _txtItem1_1.x = _txtItem1.x - _txtItem1_1.textBounds.width;
            _txtItem1_1.y = 60;
            source.addChild(_txtItem1_1);
        }
        _txtItem2 = new CTextField(120,60, '/'+data.ingredientsCount[1]);
        _txtItem2.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
        _txtItem2.alignH = Align.LEFT;
        _txtItem2.x = -155;
        _txtItem2.y = 60;
        source.addChild(_txtItem2);
        if (g.userInventory.getCountResourceById(data.ingredientsId[1]) >= data.ingredientsCount[1]) _txtItem2.text = String(g.userInventory.getCountResourceById(data.ingredientsId[1])) + '/' + data.ingredientsCount[1];
        else {
            _txtItem2_2 = new CTextField(120, 60, String(g.userInventory.getCountResourceById(data.ingredientsId[0])));
            _txtItem2_2.setFormat(CTextField.BOLD30, 30, ManagerFilters.RED_TXT_NEW);
            _txtItem2_2.alignH = Align.LEFT;
            _txtItem2_2.x = _txtItem2.x - _txtItem2_2.textBounds.width;
            _txtItem2_2.y = 60;
            source.addChild(_txtItem2_2);
        }
        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(100, CButton.HEIGHT_41, CButton.GREEN, true);
        _btnBuy.addTextField(100, 40, 0, 0, String(g.managerLanguage.allTexts[308]));
        _btnBuy.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btnBuy.x = -10;
        _btnBuy.y = 140;
        source.addChild(_btnBuy);
        if (g.userInventory.getCountResourceById(data.ingredientsId[0]) < data.ingredientsCount[0] || g.userInventory.getCountResourceById(data.ingredientsId[1]) < data.ingredientsCount[1]) _btnBuy.setEnabled = false;
        else _btnBuy.setEnabled = true;
        _btnBuy.clickCallback = onClickBuy;

        _imPlus = new Image(g.allData.atlas['interfaceAtlas'].getTexture('caffee_window_plus'));
        _imPlus.x = -247;
        _imPlus.y = 25;
        source.addChild(_imPlus);

        _imEqually = new Image(g.allData.atlas['interfaceAtlas'].getTexture('caffee_window_equals'));
        _imEqually.x = -107;
        _imEqually.y = 25;
        source.addChild(_imEqually);
    }

    private function onClickBuy():void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null,[_data]);
        }
    }

    public function deleteIt():void {
        _smallBg.dispose();
        source.removeChild(_smallBg);
        _imResource.dispose();
        source.removeChild(_imResource);
        _bigBg.dispose();
        source.removeChild(_bigBg);
        _imItem1.dispose();
        source.removeChild(_imItem1);
        _imItem2.dispose();
        source.removeChild(_imItem2);
        _btnExit.dispose();
        source.removeChild(_btnExit);
    }
}
}
