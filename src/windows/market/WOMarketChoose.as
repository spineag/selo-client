package windows.market {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.StructureDataBuilding;

import manager.ManagerFilters;
import manager.ManagerLanguage;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.filters.BlurFilter;
import starling.filters.DropShadowFilter;
import starling.text.TextField;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;

import windows.WOComponents.Birka;
import windows.WOComponents.WindowBackgroundNew;
import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.DefaultVerticalScrollSprite;
import utils.CButton;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOMarketChoose extends WindowMain {
    public static const AMBAR:int = 1;
    public static const SKLAD:int = 2;

    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _arrCells:Array;
    private var _callback:Function;
    private var _btnSell:CButton;
    private var _tabs:AmbarTabs;
    private var _isAmbar:Boolean;
    private var _mainSprite:Sprite;
    private var _type:int;
    private var _countResourceBlock:CountBlock;
    private var _countMoneyBlock:CountBlock;
    private var _curResourceId:int;
    private var booleanPlus:Boolean;
    private var booleanMinus:Boolean;
    private var _woBG:WindowBackgroundNew;
    private var _defaultY:int = -232;
    private var _activetedItem:MarketItem;
    private var _txtAmbar:CTextField;
    private var _txtSklad:CTextField;
    private var _imPapper:Image;
    private var _txtPapperBtn:CTextField;
    private var _btnPapper:CButton;
    private var _woMarket:WOMarket;
    private var _boolPapper:Boolean;
    private var _bigYellowBG:BackgroundYellowOut;
    private var _wb:WindowBackgroundNew;
    private var _wbYe:BackgroundYellowOut;

    public function WOMarketChoose() {
        super();
        _windowType = WindowsManager.WO_MARKET_CHOOSE;
        _woWidth = 624;
        _woHeight = 575;
        _wb = new WindowBackgroundNew(275,400,0);
        _wb.y = 20;
        _wb.x = 420;
        _source.addChild(_wb);
        _wbYe = new BackgroundYellowOut(240, 350);
        _wbYe.x = 300;
        _wbYe.y = -160;
        _source.addChild(_wbYe);
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,104);
        _source.addChild(_woBG);
        _bigYellowBG = new BackgroundYellowOut(579, 414);
        _bigYellowBG.y = -_woHeight / 3 + 7;
        _bigYellowBG.x = -_woWidth / 3 - 82;
        _source.addChild(_bigYellowBG);
        createExitButton(hideIt);
        booleanPlus = true;
        booleanMinus = true;
        createWOElements();
        _arrCells = [];
        _scrollSprite = new DefaultVerticalScrollSprite(520, 520, 130, 130);
        _scrollSprite.source.x = 55 - _woWidth/2;
        _scrollSprite.source.y = 127 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(423, 0, 303, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));

        _countResourceBlock = new CountBlock();
        _countResourceBlock.setWidth = 50;
        _countResourceBlock.source.x = 410;
        _countResourceBlock.source.y = -50;
        _countMoneyBlock = new CountBlock(true);
        _countMoneyBlock.setWidth = 50;
        _countMoneyBlock.source.x = 410;
        _countMoneyBlock.source.y = 40;
        _source.addChild(_countMoneyBlock.source);
        _source.addChild(_countResourceBlock.source);

        _btnSell = new CButton();
        _btnSell.addButtonTexture(145, CButton.BIG_HEIGHT, CButton.GREEN, true);
        _btnSell.addTextField(145, 40, 0, 0, String(g.managerLanguage.allTexts[407]));
        _btnSell.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btnSell.x = 425;
        _btnSell.y = 155;
        _source.addChild(_btnSell);
        _btnSell.clickCallback = onClickBtnSell;
        _callbackClickBG = onClickExit;
    }

    override public function showItParams(callback:Function, params:Array):void {
        _boolPapper = true;
        _callback = callback;
        _activetedItem = params[0];
        _woMarket = params[1];
        if (g.user.isAmbar) _isAmbar = true;
        else _isAmbar = false;
        checkTypes();
        fillItems();
        checkPapper();
        super.showIt();
    }

    private function checkPapper():void {
        var im:Image;
        if (g.userTimer.papperTimerAtMarket > 0) {
            _imPapper = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_window_del_clock'));
            _imPapper.x = -220;
            _imPapper.y = 205;
            _source.addChild(_imPapper);
            _btnPapper = new CButton();
            _btnPapper.addButtonTexture(70, 30, CButton.GREEN, true);
            _txtPapperBtn = new CTextField(70, 30, String(g.managerLanguage.allTexts[359] + ' 1   '));
            _txtPapperBtn.setFormat(CTextField.BOLD18, 15, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            _btnPapper.addChild(_txtPapperBtn);
            _txtPapperBtn.x = 2;
            _source.addChild(_btnPapper);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            MCScaler.scale(im, im.height/2, im.width/2);
            im.x = 35;
            im.y = 16;
            _btnPapper.addChild(im);
            _btnPapper.x = 55;
            _btnPapper.y = 225;
            _btnPapper.clickCallback = onClickRefresh;
            _boolPapper = false;
            g.gameDispatcher.addToTimer(timerPapper);
        }
    }

    private function onClickRefresh():void {
        if (g.user.hardCurrency < 1) {
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        } else {
            g.userInventory.addMoney(1,-1);
            g.userTimer.papperTimerAtMarket = 0;
            g.directServer.skipUserInPaper(null);
            g.gameDispatcher.removeFromTimer(timerPapper);
            _imPapper = null;
            _source.removeChild(_imPapper);
            _boolPapper = true;
            _btnPapper.visible = false;
        }
    }

    private function timerPapper():void {
            g.gameDispatcher.removeFromTimer(timerPapper);
            if (_source) {
                g.gameDispatcher.removeFromTimer(timerPapper);
                _imPapper = null;
                if (_imPapper) _source.removeChild(_imPapper);
                _boolPapper = true;
                _btnPapper.visible = false;
        }
    }

    private function onClickCheck():void {
//        if (_boolPapper) {
//            _imCheck.visible = false;
//            _boolPapper = false;
//        } else {
//            _imCheck.visible = true;
//            _boolPapper = true;
//        }
    }

    private function createWOElements():void {

        _tabs = new AmbarTabs(_bigYellowBG, onTabClick);
        _tabs.activate(_isAmbar);
        var fAmbar:Function = function():void {
            _type = AMBAR;
            updateItems();
            checkTypes();
            g.user.visitAmbar = true;
        };
        var hAmbar:Function = function():void {
//            _tabAmbar.y = _defaultY + 3;
        };
        var oAmbar:Function = function():void {
//            _tabAmbar.y = _defaultY + 10;
        };
        _mainSprite = new Sprite();
        _mainSprite.filter = ManagerFilters.SHADOW;
        _mainSprite.x = -_woWidth/2 + 43;
        _mainSprite.y = -_woHeight/2 + 96;

        _source.addChild(_mainSprite);

        _scrollSprite = new DefaultVerticalScrollSprite(520, 520, 130, 130);
        _scrollSprite.source.x = 55 - _woWidth/2;
        _scrollSprite.source.y = 107 - _woHeight/2;
        _source.addChild(_scrollSprite.source);
        _scrollSprite.createScoll(423, 0, 303, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
    }

    private function onTabClick():void {
        _isAmbar = !_isAmbar;
        g.user.isAmbar = _isAmbar;
        _tabs.activate(_isAmbar);
        updateCells();
        updateForUpdates();
    }

    public function updateCells():void {
        clearCells();
        fillItems();
    }

//    private function fillCells():void {
//        var cell:MarketCell;
//        var arr:Array;
//        if (_isAmbar) arr = g.userInventory.getResourcesForAmbar();
//        else arr = g.userInventory.getResourcesForSklad();
//        arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
//        for (var i:int = 0; i < arr.length; i++) {
//            cell = new MarketCell(arr[i]);
//            _arrCells.push(cell);
//            _scrollSprite.addNewCell(cell.source);
//        }
//    }

    private function clearCells():void {
        if (_scrollSprite)_scrollSprite.resetAll();
        for (var i:int = 0; i < _arrCells.length; i++) {
            (_arrCells[i] as MarketCell).deleteIt();
        }
        _arrCells.length = 0;
    }

    private function updateForUpdates():void {
        var b:StructureDataBuilding;
        if (_isAmbar) {
            b = g.allData.getBuildingById(12);
//            _uItem1.updateIt(b.upInstrumentId1, true);
//            _uItem2.updateIt(b.upInstrumentId2, true);
//            _uItem3.updateIt(b.upInstrumentId3, true);
        } else {
            b = g.allData.getBuildingById(13);
//            _uItem1.updateIt(b.upInstrumentId1, false);
//            _uItem2.updateIt(b.upInstrumentId2, false);
//            _uItem3.updateIt(b.upInstrumentId3, false);
        }
    }

    private function checkTypes():void {
//        _tabAmbar.filter = null;
//        _tabSklad.filter = null;
//        if (_source.contains(_tabAmbar)) _source.removeChild(_tabAmbar);
//        if (_mainSprite.contains(_tabAmbar)) _mainSprite.removeChild(_tabAmbar);
//        if (_source.contains(_tabSklad)) _source.removeChild(_tabSklad);
//        if (_mainSprite.contains(_tabSklad)) _mainSprite.removeChild(_tabSklad);
        switch (_type) {
            case AMBAR:
//                _mainSprite.addChild(_tabAmbar);
//                _tabAmbar.x = -205 - _mainSprite.x;
//                _tabAmbar.y = _defaultY - _mainSprite.y;
//                _tabAmbar.isTouchable = false;
//                _source.addChildAt(_tabSklad, _source.getChildIndex(_mainSprite)-1);
//                _tabSklad.x = -75;
//                _tabSklad.y = _defaultY + 10;
//                _tabSklad.isTouchable = true;
//                _tabSklad.filter = ManagerFilters.SHADOW;
//                _birka.updateText(String(g.managerLanguage.allTexts[132]));
                break;
            case SKLAD:
//                _mainSprite.addChild(_tabSklad);
//                _tabSklad.x = -75 - _mainSprite.x;
//                _tabSklad.y = _defaultY - _mainSprite.y;
//                _tabSklad.isTouchable = false;
//                _source.addChildAt(_tabAmbar, _source.getChildIndex(_mainSprite)-1);
//                _tabAmbar.x = -205;
//                _tabAmbar.y = _defaultY + 10;
//                _tabAmbar.isTouchable = true;
//                _tabAmbar.filter = ManagerFilters.SHADOW;
//                _birka.updateText(String(g.managerLanguage.allTexts[133]));
                break;
        }
    }

    private function fillItems():void {
        var cell:MarketCell;
        try {
            var arr:Array;
            if (_type == AMBAR) arr = g.userInventory.getResourcesForAmbar();
            else arr = g.userInventory.getResourcesForSklad();
            arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
            for (var i:int = 0; i < arr.length; i++) {
                cell = new MarketCell(arr[i]);
                cell.clickCallback = onCellClick;
                _arrCells.push(cell);
                _scrollSprite.addNewCell(cell.source);
            }
        } catch(e:Error) {
            Cc.error('WOAmbar fillItems:: error ' + e.errorID + ' - ' + e.message);
            g.windowsManager.uncasheWindow();
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woMarketChoose');
        }
    }

    private function unfillItems():void {
        _scrollSprite.resetAll();
        for (var i:int = 0; i < _arrCells.length; i++) {
            _arrCells[i].deleteIt();
        }
        _arrCells.length = 0;
    }

    private function updateItems():void {
        unfillItems();
        fillItems();
    }

    private function onClickExit(e:Event=null):void {
        if (_callback != null) {
            _callback.apply(null, [_activetedItem, 0]);
            _callback = null;
        }
        super.hideIt();
    }

    private function onCellClick(a:int):void {
        _curResourceId = a;
//        _btnSell.filter = null;
//        _countResourceBlock.btnNull();
        _countMoneyBlock.count = 0;
        _countResourceBlock.count = 0;
        booleanMinus = true;
        booleanPlus = true;
        _countResourceBlock._btnMinus.setEnabled = true;
        _countResourceBlock._btnPlus.setEnabled = true;
        _countMoneyBlock._btnPlus.setEnabled = true;
        _countMoneyBlock._btnMinus.setEnabled = true;
//        _countMoneyBlock.btnNull();
        for (var i:int = 0; i < _arrCells.length; i++) {
            _arrCells[i].activateIt(false);
        }
        var countRes:int = g.userInventory.getCountResourceById(a);
        var count:int = int(countRes/2 + .5);
        if (countRes > 20) {
            count = 10;
            countRes = 10;
        } else if (countRes > 10) {
            countRes = 10;
        }
        _countResourceBlock.maxValue = countRes;
        _countResourceBlock.minValue = 1;
        _countResourceBlock.count = count;
        _countResourceBlock.onChangeCallback = onChangeResourceCount;
        _countMoneyBlock.maxValue = count * g.allData.getResourceById(_curResourceId).costMax;
        _countMoneyBlock.minValue =  count * g.allData.getResourceById(_curResourceId).costDefault;
        _countResourceBlock.resourceChoose(_curResourceId);
        var def:int = ((count * g.allData.getResourceById(_curResourceId).costMax) - (count * g.allData.getResourceById(_curResourceId).costDefault)) /2 + count * g.allData.getResourceById(_curResourceId).costDefault;
        _countMoneyBlock.count =  def;
//        _countMoneyBlock._btnMinus.filter =  ManagerFilters.DISABLE_FILTER;
//        _countMoneyBlock._btnMinus.setEnabled = false;
        if (countRes == 1) {
//            _countResourceBlock._btnPlus.filter = ManagerFilters.DISABLE_FILTER;
//            _countResourceBlock._btnMinus.filter = ManagerFilters.DISABLE_FILTER;
            _countResourceBlock._btnMinus.setEnabled = false;
            _countResourceBlock._btnPlus.setEnabled = false;
        } else if (_countResourceBlock.count == 10) {
//            _countResourceBlock._btnPlus.filter = ManagerFilters.DISABLE_FILTER;
            _countResourceBlock._btnPlus.setEnabled = false;
        }
        if ( _countMoneyBlock.count <= 0){
            _countMoneyBlock.count = 1;
        }
    }

    private function onChangeResourceCount(onPlus:Boolean):void {
        var countRes:int = g.userInventory.getCountResourceById(_curResourceId);
        _countMoneyBlock.maxValue = _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costMax;
        _countMoneyBlock.minValue =  _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault;
//        var count:Boolean;
//        _countMoneyBlock.btnNull();
        if (onPlus) {
//            _countMoneyBlock.count = _countResourceBlock.count * g.dataResource.objectResources[_curResourceId].costDefault;
//            if (_countResourceBlock.count == 10 || _countResourceBlock.count == countRes) {
//
//            }
            booleanMinus = true;
//            _countMoneyBlock._btnPlus.filter = null;
            _countMoneyBlock._btnPlus.setEnabled = true;
            if (countRes == 1) {
//                _countResourceBlock.btnNull();
                _countResourceBlock._btnPlus.setEnabled = true;
                _countResourceBlock._btnMinus.setEnabled = true;
                return;
            }
            if (booleanPlus == false) return; else {
                if (_countResourceBlock.count == 10 || _countResourceBlock.count == countRes) {
                    booleanPlus = false;
                    _countMoneyBlock.count = _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault;
//                    _countResourceBlock._btnPlus.filter = ManagerFilters.DISABLE_FILTER;
                    _countResourceBlock._btnPlus.setEnabled = true;
                    if (_countMoneyBlock.count == _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault) {
//                        _countMoneyBlock._btnMinus.filter =  ManagerFilters.DISABLE_FILTER;
                        _countMoneyBlock._btnMinus.setEnabled = true;
                    }
                    return;
                } else _countResourceBlock._btnPlus.setEnabled = true; //_countResourceBlock._btnPlus.filter = null;
            }
            booleanPlus = true;
            _countMoneyBlock.count = _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault;
            if (_countMoneyBlock.count == _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault) {
//                _countMoneyBlock._btnMinus.filter =  ManagerFilters.DISABLE_FILTER;
                _countMoneyBlock._btnMinus.setEnabled = false;
            }
        } else {
            booleanPlus = true;
            if (_countMoneyBlock.count == _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costMax) {
//                _countMoneyBlock._btnPlus.filter = ManagerFilters.DISABLE_FILTER;
                _countMoneyBlock._btnPlus.setEnabled = false;
                return;
            }
            if (countRes == 1) {
//                _countResourceBlock.btnNull();
                _countResourceBlock._btnPlus.setEnabled = true;
                _countResourceBlock._btnMinus.setEnabled = true;
                return;
            }
            if (booleanMinus == false) return; else {
                if (_countResourceBlock.count == 1) {
                    booleanMinus = false;
                    if (_countMoneyBlock.count == 1 || 0 >= _countMoneyBlock.count - g.allData.getResourceById(_curResourceId).costDefault) {
                        _countMoneyBlock.count = _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault;
//                        _countResourceBlock._btnMinus.filter = ManagerFilters.DISABLE_FILTER;
                        _countResourceBlock._btnMinus.setEnabled = false;
                        if (_countMoneyBlock.count == _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault) {
//                            _countMoneyBlock._btnMinus.filter =  ManagerFilters.DISABLE_FILTER;
                            _countMoneyBlock._btnMinus.setEnabled = false;

                        }
                        return;
                    }
                    _countMoneyBlock.count = _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault;
//                    _countResourceBlock._btnMinus.filter = ManagerFilters.DISABLE_FILTER;
                    _countResourceBlock._btnMinus.setEnabled = false;
                    return;
                } else  _countResourceBlock._btnMinus.setEnabled = true; //_countResourceBlock._btnMinus.filter = null;
            }
            if (_countMoneyBlock.count == 1 || 0 >= _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault) {
                _countMoneyBlock.count = _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault;
                return;
            }
            booleanMinus = true;
            _countMoneyBlock.count = _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault;
            if (_countMoneyBlock.count == _countResourceBlock.count * g.allData.getResourceById(_curResourceId).costDefault) {
//                _countMoneyBlock._btnMinus.filter =  ManagerFilters.DISABLE_FILTER;
                _countMoneyBlock._btnMinus.setEnabled = false;
            }
        }
    }

    private function onClickBtnSell(last:Boolean = false):void {
        if (_curResourceId > 0) {
            if (!last) {
                if (g.allData.getResourceById(_curResourceId).buildType == BuildType.PLANT && _countResourceBlock.count == g.userInventory.getCountResourceById(_curResourceId) && !g.userInventory.checkLastResource(_curResourceId)) {
                    g.windowsManager.secondCashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, onClickBtnSell, {id: _curResourceId}, 'market');
                    return;
                }
            }
            var level:int = g.allData.getResourceById(_curResourceId).blockByLevel;
            if (!level || level < 1) level = 1;
            if (_callback != null) {
                _callback.apply(null, [_activetedItem, _curResourceId, level, _countResourceBlock.count, _countMoneyBlock.count,_boolPapper]);
                _callback = null;
            }
            if (isCashed) g.windowsManager.secondCashWindow = null;
            super.hideIt();

        }
    }

    override protected function deleteIt():void {
        if (!_scrollSprite) return;
        unfillItems();
        unfillItems();
        if (_txtAmbar) {
            _txtAmbar.deleteIt();
            _txtAmbar = null;
        }
        if (_txtSklad) {
            _txtSklad.deleteIt();
            _txtSklad = null;
        }
        _source.removeChild(_btnSell);
        _btnSell.deleteIt();
        _btnSell = null;
        _source.removeChild(_countMoneyBlock.source);
        _countMoneyBlock.deleteIt();
        _countMoneyBlock = null;
        _source.removeChild(_countResourceBlock.source);
        _countResourceBlock.deleteIt();
        _countResourceBlock = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _tabs.deleteIt();
        _tabs = null;
        _source.removeChild(_scrollSprite.source);
        _scrollSprite.deleteIt();
        _scrollSprite = null;
        super.deleteIt();
    }

}
}

import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import windows.WOComponents.BackgroundYellowOut;

internal class AmbarTabs {
    private var g:Vars = Vars.getInstance();
    private var _callback:Function;
    private var _imActiveAmbar:Image;
    private var _txtActiveAmbar:CTextField;
    private var _unactiveAmbar:CSprite;
    private var _txtUnactiveAmbar:CTextField;
    private var _imActiveSklad:Image;
    private var _txtActiveSklad:CTextField;
    private var _unactiveSklad:CSprite;
    private var _txtUnactiveSklad:CTextField;
    private var _bg:BackgroundYellowOut;

    public function AmbarTabs(bg:BackgroundYellowOut, f:Function) {
        _bg = bg;
        _callback = f;
        _imActiveAmbar = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_big'));
        _imActiveAmbar.pivotX = _imActiveAmbar.width/2;
        _imActiveAmbar.pivotY = _imActiveAmbar.height;
        _imActiveAmbar.x = 203;
        _imActiveAmbar.y = 10;
        bg.addChild(_imActiveAmbar);
        _txtActiveAmbar = new CTextField(154, 48, g.managerLanguage.allTexts[132]);
        _txtActiveAmbar.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtActiveAmbar.x = 127;
        _txtActiveAmbar.y = -50;
        bg.addChild(_txtActiveAmbar);

        _unactiveAmbar = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_small'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        _unactiveAmbar.addChild(im);
        _unactiveAmbar.x = 203;
        _unactiveAmbar.y = 10;
        bg.addChildAt(_unactiveAmbar, 0);
        _unactiveAmbar.endClickCallback = onClick;
        _txtUnactiveAmbar = new CTextField(154, 48, g.managerLanguage.allTexts[132]);
        _txtUnactiveAmbar.setFormat(CTextField.BOLD24, 24, ManagerFilters.BROWN_COLOR, Color.WHITE);
        _txtUnactiveAmbar.x = 127;
        _txtUnactiveAmbar.y = -42;
        bg.addChild(_txtUnactiveAmbar);

        _imActiveSklad = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_big'));
        _imActiveSklad.pivotX = _imActiveSklad.width/2;
        _imActiveSklad.pivotY = _imActiveSklad.height;
        _imActiveSklad.x = 367;
        _imActiveSklad.y = 10;
        bg.addChild(_imActiveSklad);
        _txtActiveSklad = new CTextField(154, 48, g.managerLanguage.allTexts[133]);
        _txtActiveSklad.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtActiveSklad.x = 287;
        _txtActiveSklad.y = -50;
        bg.addChild(_txtActiveSklad);

        _unactiveSklad = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('silo_panel_tab_small'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        _unactiveSklad.addChild(im);
        _unactiveSklad.x = 367;
        _unactiveSklad.y = 10;
        bg.addChildAt(_unactiveSklad, 0);
        _unactiveSklad.endClickCallback = onClick;
        _txtUnactiveSklad = new CTextField(154, 48, g.managerLanguage.allTexts[133]);
        _txtUnactiveSklad.setFormat(CTextField.BOLD24, 24, ManagerFilters.BROWN_COLOR, Color.WHITE);
        _txtUnactiveSklad.x = 287;
        _txtUnactiveSklad.y = -42;
        bg.addChild(_txtUnactiveSklad);
    }

    private function onClick():void { if (_callback!=null) _callback.apply(); }

    public function activate(isAmbar:Boolean):void {
        _imActiveAmbar.visible = _unactiveSklad.visible = isAmbar;
        _imActiveSklad.visible = _unactiveAmbar.visible = !isAmbar;
        _txtActiveAmbar.visible = _txtUnactiveSklad.visible = isAmbar;
        _txtActiveSklad.visible = _txtUnactiveAmbar.visible = !isAmbar;
    }

    public function deleteIt():void {
        _bg.removeChild(_txtActiveAmbar);
        _bg.removeChild(_txtActiveSklad);
        _bg.removeChild(_txtUnactiveSklad);
        _bg.removeChild(_txtUnactiveAmbar);
        _bg.removeChild(_imActiveAmbar);
        _bg.removeChild(_imActiveSklad);
        _bg.removeChild(_unactiveAmbar);
        _bg.removeChild(_unactiveSklad);
        _txtActiveAmbar.deleteIt();
        _txtActiveSklad.deleteIt();
        _txtUnactiveAmbar.deleteIt();
        _txtUnactiveSklad.deleteIt();
        _imActiveAmbar.dispose();
        _imActiveSklad.dispose();
        _unactiveAmbar.deleteIt();
        _unactiveSklad.deleteIt();
        _bg = null;
    }

}

