/**
 * Created by user on 7/2/18.
 */
package windows.buyEnergy {
import com.junkbyte.console.Cc;

import flash.geom.Point;

import manager.ManagerFilters;
import manager.Vars;

import resourceItem.newDrop.DropObject;

import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;
import utils.SensibleBlock;

import windows.WOComponents.BackgroundYellowOut;

import windows.WindowsManager;

public class WOBuyEnergyItem {
    public var source:Sprite;
    private var _cost:int;
    private var _count:int;
    private var _imageCoupone:Image;
    private var _btn:CButton;
    private var _txtCount:CTextField;
    private var _txtPlusOne:CTextField;
    private var _txtBtn:CTextField;
    private var _type:int;
    private var _bgYellow:BackgroundYellowOut;

    private var g:Vars = Vars.getInstance();

    public function WOBuyEnergyItem(txtItemCoupone:int, txtCostCoupone:int,type:int) {
        try {
            _type = type;
            _cost = txtCostCoupone;
            _count = txtItemCoupone;
            source = new Sprite();
            _bgYellow = new BackgroundYellowOut(100,160);
            _bgYellow.y = -120;
            source.addChild(_bgYellow);
            _btn = new CButton();
            _btn.addButtonTexture(100, CButton.HEIGHT_41, CButton.GREEN, true);
            _btn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, CButton.GREEN);
            _txtBtn = new CTextField(100, 100, String(_cost));
            _txtBtn.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            var sens:SensibleBlock = new SensibleBlock();
            sens.textAndImage(_txtBtn, im, 100);
            _btn.addSensBlock(sens, 0, 18);
            source.addChild(_btn);

            _btn.clickCallback = onClick;
            _btn.x = 50;
            _btn.y = 120;
//            _imageCoupone = new Image(g.allData.atlas['interfaceAtlas'].getTexture(imageCopone));
//            _imageCoupone.y = -60;
//            source.addChild(_imageCoupone);
//            _txtCount = new CTextField(50, 50, String(_count));
//            _txtCount.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
//            _txtCount.x = 60;
//            source.addChild(_txtCount);
            _txtPlusOne = new CTextField(50, 50, '+1');
            _txtPlusOne.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW,  Color.WHITE);
            _txtPlusOne.y = 50;
            _txtPlusOne.x = 20;
            source.addChild(_txtPlusOne);
        } catch (e:Error) {
            Cc.error('WOBuyCouponeItem error: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'buyCoupone');
        }
    }

    private function onClick():void {
        if (g.user.hardCurrency < _cost) {
            g.windowsManager.closeAllWindows();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(1, -_cost);
        _count++;
        _txtCount.text = String(_count);
        var d:DropObject = new DropObject();
        var p:Point = new Point(_imageCoupone.x, _imageCoupone.y);
        p = _imageCoupone.localToGlobal(p);
        d.addDropMoney(_type, 1, p);
        d.releaseIt(null, false);
    }

    public function deleteIt():void {
        source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        _txtBtn.deleteIt();
        _txtBtn = null;
//        source.removeChild(_imageCoupone);
//        _imageCoupone.dispose();
//        _imageCoupone = null;
//        source.removeChild(_txtCount);
//        _txtCount.dispose();
//        _txtCount = null;
        source.removeChild(_txtPlusOne);
        _txtPlusOne.dispose();
        _txtPlusOne = null;
    }
}
}
