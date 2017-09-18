/**
 * Created by user on 7/13/15.
 */
package windows.ambar {
import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;
import manager.Vars;

import resourceItem.DropItem;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;

import temp.DropResourceVariaty;

import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.WhiteBackgroundIn;
import windows.WindowsManager;

public class UpgradeItem {
    public var source:Sprite;
    private var _contImage:CSprite;
    private var _resourceId:int;
    private var _btn:CButton;
    private var _btnTxt:CTextField;
    private var _imGalo4ka:Image;
    private var _txtCount:CTextField;
    private var _isAmbarItem:Boolean;
    private var _buyCallback:Function;
    private var _countForBuy:int;
    private var _resourceImage:Image;
    private var _wo:WOAmbars;
    private var _rubinsSmall:Image;
    private var _onHover:Boolean;
    private var g:Vars = Vars.getInstance();

    public function UpgradeItem(wo:WOAmbars, f:Function, x:int, y:int) {
        _buyCallback = f;
        _wo = wo;
        source = new Sprite();
        source.x = x;
        source.y = y;
        _contImage = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_yellow_cell'));
        im.alignPivot();
        _contImage.addChild(im);
        source.addChild(_contImage);
        _contImage.hoverCallback = onHover;
        _contImage.outCallback = onOut;

        _txtCount = new CTextField(80,40,'');
        _txtCount.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_LIGHT_NEW);
        _txtCount.alignH = Align.RIGHT;
        _txtCount.x = -25;
        _txtCount.y = 23;
        source.addChild(_txtCount);

        _btn = new CButton();
        _btn.addButtonTexture(100, 40, CButton.GREEN, true);
        _btn.y = 90;
        source.addChild(_btn);
        _btn.clickCallback = onBuy;

        _btnTxt = new CTextField(50,20,'50');
        _btnTxt.setFormat(CTextField.MEDIUM18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btnTxt.x = 11;
        _btnTxt.y = 8;
        _btn.addChild(_btnTxt);

        _rubinsSmall = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        _rubinsSmall.x = 57;
        _rubinsSmall.y = 4;
        _btn.addChild(_rubinsSmall);
        _rubinsSmall.filter = ManagerFilters.SHADOW_TINY;

        _imGalo4ka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
        _imGalo4ka.alignPivot();
        _imGalo4ka.y = 85;
        source.addChild(_imGalo4ka);
        _imGalo4ka.filter = ManagerFilters.SHADOW_TINY;
        _onHover = false;
    }

    public function updateIt(id:int, isAmbar:Boolean = true):void {
        var needCountForUpdate:int;
        _resourceId = id;
        _isAmbarItem = isAmbar;
        var curCount:int = g.userInventory.getCountResourceById(_resourceId);
        if (_isAmbarItem) {
            needCountForUpdate = g.allData.getBuildingById(12).startCountInstrumets + g.allData.getBuildingById(12).deltaCountAfterUpgrade * (g.user.ambarLevel-1);
            _txtCount.text = String(curCount) + '/' + String(needCountForUpdate);
            if (curCount >= needCountForUpdate) {
                _imGalo4ka.visible = true;
                _btn.visible = false;
            } else {
                _imGalo4ka.visible = false;
                _btn.visible = true;
                _countForBuy = needCountForUpdate - curCount;
                _btnTxt.text = String(_countForBuy * g.allData.getResourceById(_resourceId).priceHard);
            }
        } else {
            needCountForUpdate = g.allData.getBuildingById(13).startCountInstrumets + g.allData.getBuildingById(13).deltaCountAfterUpgrade * (g.user.skladLevel-1);
            _txtCount.text = String(curCount) + '/' + String(needCountForUpdate);
            if (curCount >= needCountForUpdate) {
                _imGalo4ka.visible = true;
                _btn.visible = false;
            } else {
                _imGalo4ka.visible = false;
                _btn.visible = true;
                _countForBuy = needCountForUpdate - curCount;
                _btnTxt.text = String(_countForBuy * g.allData.getResourceById(_resourceId).priceHard);
            }
        }
        if (_resourceImage) {
            _contImage.removeChild(_resourceImage);
            _resourceImage.dispose();
            _resourceImage = null;
        }
        _resourceImage = new Image(g.allData.atlas[g.allData.getResourceById(_resourceId).url].getTexture(g.allData.getResourceById(_resourceId).imageShop));
        MCScaler.scale(_resourceImage, 100, 100);
        _resourceImage.alignPivot();
        _contImage.addChild(_resourceImage);
    }

    public function get isFull():Boolean { return _imGalo4ka.visible; }

    private function onBuy():void {
        if (g.user.hardCurrency >= _countForBuy * g.allData.getResourceById(_resourceId).priceHard) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countForBuy * g.allData.getResourceById(_resourceId).priceHard);
            var prise:Object = {};
            prise.id = _resourceId;
            prise.type = DropResourceVariaty.DROP_TYPE_RESOURSE;
            prise.count = _countForBuy;
            new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2, prise);
            updateIt(_resourceId, _isAmbarItem);
            if (!_isAmbarItem) _wo.updateCells();
            if (_buyCallback != null) _buyCallback.apply();
        } else {
            _wo.isCashed = false;
            _wo.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
        }
    }

    private function onHover():void {
        if(_onHover) return;
        _onHover = true;
        if (!g.resourceHint.isShowed)  g.resourceHint.showIt(_resourceId, source.x - 60, source.y - 60, source, true);
    }

    private function onOut():void {
        _onHover = false;
        g.resourceHint.hideIt();
    }

    public function deleteIt():void {
        if (!source) return;
        _wo = null;
        _imGalo4ka.filter = null;
        _rubinsSmall.filter = null;
        source.removeChild(_btn);
        _txtCount.deleteIt();
        _txtCount = null;
        _btnTxt.deleteIt();
        _btnTxt = null;
        _btn.deleteIt();
        _btn = null;
        source.dispose();
        source = null;
    }
}
}
