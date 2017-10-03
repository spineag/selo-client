/**
 * Created by user on 2/14/17.
 */
package windows.fabricaWindow {
import data.BuildType;

import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;

import starling.utils.Color;

import utils.CButton;
import utils.CTextField;
import utils.SensibleBlock;

import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOFabricDeleteItem extends WindowMain{
    private var _woBG:WindowBackgroundNew;
    private var _b:CButton;
    private var _txt:CTextField;
    private var _txtInfo:CTextField;
    private var _txtBtn:CTextField;
    private var _callback:Function;
    private var _data:Object;

    public function WOFabricDeleteItem() {
        _windowType = WindowsManager.WO_FABRIC_DELETE_ITEM;
        _woWidth = 600;
        _woHeight = 350;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,115);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _txtInfo = new CTextField(600,50,String(g.managerLanguage.allTexts[436]));
        _txtInfo.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW);
        _txtInfo.x = -300;
        _txtInfo.y = -65;
        _source.addChild(_txtInfo);
        _txt = new CTextField(600,50,String(g.managerLanguage.allTexts[435]));
        _txt.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txt.x = -300;
        _txt.y = -130;
        _source.addChild(_txt);
        _callbackClickBG = onClickExit;
        _b = new CButton();
        _b.addButtonTexture(210, CButton.BIG_HEIGHT, CButton.GREEN, true);
        _b.setTextFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_b);
        _b.y = 125;
        _txtBtn = new CTextField(210, 34, String(g.managerLanguage.allTexts[410]));
        _txtBtn.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.GREEN_COLOR);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        var sensi:SensibleBlock = new SensibleBlock();
        sensi.textAndImage(_txtBtn,im,210);
        _b.addSensBlock(sensi,0,20);
        _b.clickCallback = onClick;
    }

    private function onClickExit(e:Event=null):void {
        if (g.tuts.isTuts) return;
        super.hideIt();
    }

    override public function showItParams(f:Function, params:Array):void {
        _callback = f;
        _data = params[0];
        if (_data.buildType == BuildType.PLANT) {
            var im:Image = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop + '_icon'));
        } else im = new Image(g.allData.atlas['resourceAtlas'].getTexture(_data.imageShop));
        im.x = -im.width/2;
        im.y = -im.height/7- 10;
        _source.addChild(im);
        super.showIt();
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
        super.hideIt();
    }

}
}
