/**
 * Created by user on 7/15/15.
 */
package windows.buyCoupone {
import com.junkbyte.console.Cc;

import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CButton;

import utils.CSprite;
import utils.CTextField;

import utils.MCScaler;
import utils.SensibleBlock;

import windows.WOComponents.BackgroundYellowOut;
import windows.WindowsManager;

public class WOBuyCouponeItem {
    public var source:Sprite;
    private var _carton:BackgroundYellowOut;
    private var _cost:int;
    private var _count:int;
    private var _imageCoupone:Image;
    private var _btn:CButton;
    private var _txtCount:CTextField;
    private var _txtPlusOne:CTextField;
    private var _txtBtn:CTextField;
    private var _type:int;
    private var g:Vars = Vars.getInstance();

    public function WOBuyCouponeItem(imageCopone:String, txtItemCoupone:int, txtCostCoupone:int,type:int) {
        try {
            _type = type;
//            _carton = new BackgroundYellowOut(100, 150);
            _cost = txtCostCoupone;
            _count = txtItemCoupone;
//            _carton.filter = ManagerFilters.SHADOW_LIGHT;
            source = new Sprite();
//            source.addChild(_carton);
            _btn = new CButton();
            _btn.addButtonTexture(100, CButton.MEDIUM_HEIGHT, CButton.GREEN, true);
            _btn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, CButton.GREEN);
//            _btn = new CButton();
//            _btn.addButtonTexture(80, 50, CButton.GREEN, true);
            _txtBtn = new CTextField(100,100,'+' + String(_cost));
            _txtBtn.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
//            txt.x = 5;
//            _btn.addChild(_txtBtn);
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            im.alignPivot();
            var sens:SensibleBlock = new SensibleBlock();
            sens.textAndImage(_txtBtn,im,100);
            _btn.addSensBlock(sens,0,18);
            source.addChild(_btn);

            _btn.clickCallback = onClick;
            _btn.x = 50;
            _btn.y = 120;
            _imageCoupone = new Image(g.allData.atlas['interfaceAtlas'].getTexture(imageCopone));
//            _imageCoupone.x = 30;
            _imageCoupone.y = -60;
            source.addChild(_imageCoupone);
            _txtCount = new CTextField(50,50,String(_count));
            _txtCount.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW,Color.WHITE);
            _txtCount.x = 60;
//            _txtCount.y = -20;
            source.addChild(_txtCount);
            _txtPlusOne = new CTextField(50,50,'+1');
            _txtPlusOne.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW);
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
//            g.windowsManager.hideWindow(WindowsManager.WO_BUY_COUPONE);
            g.windowsManager.closeAllWindows();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(1, -_cost);
        _count++;
        _txtCount.text = String(_count);
        var obj:Object;
        obj = {};
        obj.count = 1;
        var p:Point = new Point(_imageCoupone.x, _imageCoupone.y);
        p = _imageCoupone.localToGlobal(p);
        obj.id = _type;
        new DropItem(p.x, p.y, obj);
    }

    public function deleteIt():void {
        source.removeChild(_btn);
        _btn.deleteIt();
        _btn = null;
        _txtBtn.deleteIt();
        _txtBtn = null;
        source.removeChild(_imageCoupone);
        _imageCoupone.dispose();
        _imageCoupone = null;
        source.removeChild(_txtCount);
        _txtCount.dispose();
        _txtCount = null;
        source.removeChild(_txtPlusOne);
        _txtPlusOne.dispose();
        _txtPlusOne = null;
//        source.removeChild(_carton);
//        _carton.deleteIt();
//        _carton = null;
    }
}
}
