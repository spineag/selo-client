/**
 * Created by user on 7/13/15.
 */
package windows.ambar {
import data.DataMoney;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;
import windows.WindowsManager;

public class UpgradeItem {
    public var source:Sprite;
    private var _contImage:CSprite;
    private var _resourceId:int;
    private var _btn:CButton;
    private var _btnTxt:CTextField;
    private var _imGalo4ka:Image;
    private var _txtCountAll:CTextField;
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

        _txtCountAll = new CTextField(80,40,'');
        _txtCountAll.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountAll.alignH = Align.RIGHT;
        _txtCountAll.x = -25;
        _txtCountAll.y = 23;
        source.addChild(_txtCountAll);

        _txtCount = new CTextField(80,40,'');
        _txtCount.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCount.alignH = Align.RIGHT;
        _txtCount.x = -5;
        _txtCount.y = 23;
        source.addChild(_txtCount);

        _btn = new CButton();
        _btn.addButtonTexture(100, CButton.HEIGHT_41, CButton.GREEN, true);
        _btn.y = 90;
        source.addChild(_btn);
        _btn.clickCallback = onBuy;

        _btnTxt = new CTextField(90,50,'50');
        _btnTxt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _rubinsSmall = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        var sens:SensibleBlock = new SensibleBlock();
        sens.textAndImage(_btnTxt,_rubinsSmall,100);
        _btn.addSensBlock(sens,0,20);

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
            if (needCountForUpdate > curCount) {
                _txtCount.changeTextColor = ManagerFilters.RED_TXT_NEW;
                _txtCount.text = String(curCount);
                _txtCountAll.text = '/' + String(needCountForUpdate);
            } else {
                _txtCount.changeTextColor = Color.WHITE;
                _txtCount.text = String(curCount);
                _txtCountAll.text = '/' + String(needCountForUpdate);
            }
            _txtCount.x = _txtCountAll.x - _txtCountAll.textBounds.width + 3;
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
            if (needCountForUpdate > curCount) {
                _txtCount.changeTextColor = ManagerFilters.RED_TXT_NEW;
                _txtCount.text = String(curCount);
                _txtCountAll.text = '/' + String(needCountForUpdate);
            } else {
                _txtCount.changeTextColor = Color.WHITE;
                _txtCount.text = String(curCount);
                _txtCountAll.text = '/' + String(needCountForUpdate);
            }
            _txtCount.x = _txtCountAll.x - _txtCountAll.textBounds.width + 3;
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
            var d:DropObject = new DropObject();
            var p:Point =new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
            d.addDropItemNewByResourceId(_resourceId, p, _countForBuy);
            d.releaseIt(null, false);
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
        if (!g.resourceHint.isShowed) g.resourceHint.showIt(_resourceId, source.x - 60, source.y - 60, source, true);
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
        _txtCountAll.deleteIt();
        _txtCountAll = null;
        _btnTxt.deleteIt();
        _btnTxt = null;
        _btn.deleteIt();
        _btn = null;
        source.dispose();
        source = null;
    }
}
}
