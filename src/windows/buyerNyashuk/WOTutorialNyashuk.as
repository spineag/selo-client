/**
 * Created by user on 12/12/17.
 */
package windows.buyerNyashuk {
import additional.buyerNyashuk.BuyerNyashuk;

import manager.ManagerFilters;

import starling.display.Image;
import starling.events.Event;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;

import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTutorialNyashuk extends WindowMain{
    private var _txtNyashuk:CTextField;
    private var _txtName:CTextField;
    private var _woBG:WindowBackgroundNew;
    private var _imBlueNya:Image;
    private var _imRedNya:Image;
    private var _btn:CButton;
    private var _buyerId:int;
    private var _data:Object;
    private var _nyashuk:BuyerNyashuk;

    public function WOTutorialNyashuk() {
        _windowType = WindowsManager.WO_TUTORIAL_NYASHUK;
        _woWidth = 500;
        _woHeight = 400;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,100);
        _source.addChild(_woBG);
//        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _btn = new CButton();
        _btn.addButtonTexture(180, CButton.HEIGHT_55, CButton.GREEN, true);
        _btn.addTextField(180, 40, 0, 0, String(g.managerLanguage.allTexts[532]));
        _btn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btn);
        _btn.y = _woHeight / 2 - 40;
        _btn.clickCallback = onClickExit;
        _imBlueNya = new Image(g.allData.atlas['interfaceAtlas'].getTexture('nyash_blue'));
        _imBlueNya.scaleX = -1;
        _imBlueNya.x = -70;
        _imBlueNya.y = 10;
        _source.addChild(_imBlueNya);

        _imRedNya = new Image(g.allData.atlas['interfaceAtlas'].getTexture('nyash_red'));
        _imRedNya.x = 75;
        _imRedNya.y = 10;
        _source.addChild(_imRedNya);
        _txtNyashuk = new CTextField(400,250,String(g.managerLanguage.allTexts[564]));
        _txtNyashuk.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtNyashuk.x = -200;
        _txtNyashuk.y = -140;
        _source.addChild(_txtNyashuk);

        _txtName =  new CTextField(_woWidth,_woHeight,String(g.managerLanguage.allTexts[450]));
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txtName.x = -_woWidth/2;
        _txtName.y = -_woHeight+50;
        _source.addChild(_txtName);
    }

    private function onClickExit(e:Event=null):void {
        g.windowsManager.openWindow(WindowsManager.WO_BUYER_NYASHUK, null, _buyerId, _data, _nyashuk);
        super.hideIt();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _buyerId = params[0];
        _data = params[1];
        _nyashuk = params[2];
        super.showIt();
    }

    override protected function deleteIt():void {

        super.deleteIt();
    }

}
}
