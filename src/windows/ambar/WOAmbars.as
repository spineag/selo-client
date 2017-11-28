/**
 * Created by user on 11/24/15.
 */
package windows.ambar {
import data.StructureDataBuilding;
import manager.ManagerFilters;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import windows.WOComponents.DefaultVerticalScrollSprite;
import windows.WOComponents.WindowBackgroundNew;
import windows.WOComponents.BackgroundYellowOut;
import windows.WindowMain;
import windows.WindowsManager;

public class WOAmbars extends WindowMain {
    private var _isAmbar:Boolean;
    private var _isBigShop:Boolean = true;
    private var _txtWindowName:CTextField;
    private var _bigYellowBG:BackgroundYellowOut;
    private var _tabs:AmbarTabs;
    private var _progress:AmbarProgress;
    private var _arrCells:Array;
    private var _mainPart:Sprite;
    private var _upgradePart:Sprite;
    private var _scrollSprite:DefaultVerticalScrollSprite;
    private var _btnUpgrade:CButton;
    private var _btnBack:CButton;
    private var _txtCount:CTextField;
    private var _uItem1:UpgradeItem;
    private var _uItem2:UpgradeItem;
    private var _uItem3:UpgradeItem;
    private var _btnMakeUpgrade:CButton;
    private var _txtNeed:CTextField;

    public function WOAmbars() {
        super();
        _windowType = WindowsManager.WO_AMBAR;
        if (g.managerResize.stageHeight < 700) _isBigShop = false;
        else _isBigShop = true;
        _woWidth = 625;
        if (_isBigShop) _woHeight = 640;
            else _woHeight = 560;
        _arrCells = [];

        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 133);
        _source.addChild(_woBGNew);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        if (_isBigShop) {
            _bigYellowBG = new BackgroundYellowOut(578, 414);
            _bigYellowBG.y = -_woHeight / 2 + 133;
        } else {
            _bigYellowBG = new BackgroundYellowOut(578, 334);
            _bigYellowBG.y = -_woHeight / 2 + 133;
        }
        _bigYellowBG.x = -_woWidth / 2 + 24;
        _bigYellowBG.source.touchable = true;
        _source.addChild(_bigYellowBG);
        _tabs = new AmbarTabs(_bigYellowBG, onTabClick);

        createMainPart();
        createUpgradePart();

        _txtWindowName = new CTextField(300, 50, g.managerLanguage.allTexts[132]);
        _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtWindowName.x = -150;
        _txtWindowName.y = -_woHeight/2 + 15;
        _source.addChild(_txtWindowName);

        _progress = new AmbarProgress();
        _progress.source.x = -_woWidth/2 + 242;
        if (_isBigShop) _progress.source.y = -_woHeight/2 + 580;
            else _progress.source.y = -_woHeight/2 + 500;
        _source.addChild(_progress.source);
        _progress.showAmbarIcon(true);

        _txtCount = new CTextField(200, 32, '');
        _txtCount.setFormat(CTextField.BOLD24, 24, ManagerFilters.BROWN_COLOR);
        _txtCount.alignH = Align.LEFT;
        _txtCount.x = -_woWidth/2 + 22;
        if (_isBigShop) _txtCount.y = -_woHeight/2 + 595;
            else _txtCount.y = -_woHeight/2 + 515;
        _source.addChild(_txtCount);
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (params && params[0]) _isAmbar = params[0];
            else _isAmbar = g.user.isAmbar;
        _tabs.activate(_isAmbar);
        fillCells();
        updateProgress();
        if (params[1]) { // if params[1] exist - its mean show upgradePart
            _mainPart.visible = false;
            _upgradePart.visible = true;
            updateForUpdates();
            checkUpdateBtn();
        }
        super.showIt();
    }

    private function createMainPart():void {
        _mainPart = new Sprite();
        _source.addChild(_mainPart);

        if (_isBigShop) {
            _scrollSprite = new DefaultVerticalScrollSprite(480, 370, 121, 121);
            _scrollSprite.source.y = 159 - _woHeight / 2;
            _scrollSprite.createScoll(530, 0, 368, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        } else {
            _scrollSprite = new DefaultVerticalScrollSprite(480, 290, 121, 121);
            _scrollSprite.source.y = 159 - _woHeight / 2;
            _scrollSprite.createScoll(530, 0, 288, g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_line'), g.allData.atlas['interfaceAtlas'].getTexture('storage_window_scr_c'));
        }
        _scrollSprite.source.x = 49 - _woWidth / 2;
        _mainPart.addChild(_scrollSprite.source);

        _btnUpgrade = new CButton();
        _btnUpgrade.addButtonTexture(110, CButton.HEIGHT_41, CButton.GREEN, true);
        _btnUpgrade.addTextField(110, 37, 0, 0, g.managerLanguage.allTexts[463]);
        _btnUpgrade.setTextFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btnUpgrade.x = -_woWidth/2 + 548;
        if (_isBigShop) _btnUpgrade.y = -_woHeight/2 + 580;
            else _btnUpgrade.y = -_woHeight/2 + 510;
        _mainPart.addChild(_btnUpgrade);
        _btnUpgrade.clickCallback = function():void {
            _mainPart.visible = false;
            _upgradePart.visible = true;
            updateForUpdates();
            checkUpdateBtn();
        };
    }

    private function createUpgradePart():void {
        _upgradePart = new Sprite();
        _source.addChild(_upgradePart);
        _upgradePart.visible = false;

        _btnBack = new CButton();
        _btnBack.addButtonTexture(110, CButton.HEIGHT_41, CButton.BLUE, true);
        _btnBack.addTextField(110, 37, 0, 0, g.managerLanguage.allTexts[464]);
        _btnBack.setTextFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _btnBack.x = -_woWidth/2 + 548;
        if (_isBigShop) _btnBack.y = -_woHeight/2 + 580;
            else _btnBack.y = -_woHeight/2 + 510;
        _upgradePart.addChild(_btnBack);
        _btnBack.clickCallback = function():void {
            _mainPart.visible = true;
            _upgradePart.visible = false;
        };

        _uItem1 = new UpgradeItem(this, checkUpdateBtn, -150, -30);
        _uItem2 = new UpgradeItem(this, checkUpdateBtn, 0, -30);
        _uItem3 = new UpgradeItem(this, checkUpdateBtn, 150, -30);
        _upgradePart.addChild(_uItem1.source);
        _upgradePart.addChild(_uItem2.source);
        _upgradePart.addChild(_uItem3.source);

        _btnMakeUpgrade = new CButton();
        _btnMakeUpgrade.addButtonTexture(138, CButton.HEIGHT_55, CButton.GREEN, true);
        _btnMakeUpgrade.addTextField(138, 50, 0, 0, g.managerLanguage.allTexts[463]);
        _btnMakeUpgrade.setTextFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        if (_isBigShop) _btnMakeUpgrade.y = 150;
            else _btnMakeUpgrade.y = 140;
        _upgradePart.addChild(_btnMakeUpgrade);
        _btnMakeUpgrade.clickCallback = onUpdate;

        _txtNeed = new CTextField(350,55,String(g.managerLanguage.allTexts[465]));
        _txtNeed.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtNeed.x = -175;
        if (_isBigShop) _txtNeed.y = -160;
            else _txtNeed.y = -140;
        _upgradePart.addChild(_txtNeed);
    }

    private function checkUpdateBtn():void {
        if (_uItem1.isFull && _uItem2.isFull && _uItem3.isFull) _btnMakeUpgrade.setEnabled = true;
            else _btnMakeUpgrade.setEnabled = false;
    }

    private function onTabClick():void {
        _isAmbar = !_isAmbar;
        g.user.isAmbar = _isAmbar;
        _tabs.activate(_isAmbar);
        if (_isAmbar) _txtWindowName.text = g.managerLanguage.allTexts[132];
            else _txtWindowName.text = g.managerLanguage.allTexts[133];
        updateCells();
        updateForUpdates();
    }

    private function fillCells():void {
        var cell:AmbarCell;
        var arr:Array;
        if (_isAmbar) arr = g.userInventory.getResourcesForAmbar();
            else arr = g.userInventory.getResourcesForSklad();
        arr.sortOn("count", Array.DESCENDING | Array.NUMERIC);
        for (var i:int = 0; i < arr.length; i++) {
            cell = new AmbarCell(arr[i]);
            _arrCells.push(cell);
            _scrollSprite.addNewCell(cell.source);
        }
    }

    private function clearCells():void {
        if (_scrollSprite)_scrollSprite.resetAll();
        for (var i:int = 0; i < _arrCells.length; i++) {
            (_arrCells[i] as AmbarCell).deleteIt();
        }
        _arrCells.length = 0;
    }

    public function updateCells():void {
        clearCells();
        fillCells();
        updateProgress();
    }
    
    private function updateForUpdates():void {
        var b:StructureDataBuilding;
        if (_isAmbar) {
            b = g.allData.getBuildingById(12);
            _uItem1.updateIt(b.upInstrumentId1, true);
            _uItem2.updateIt(b.upInstrumentId2, true);
            _uItem3.updateIt(b.upInstrumentId3, true);
        } else {
            b = g.allData.getBuildingById(13);
            _uItem1.updateIt(b.upInstrumentId1, false);
            _uItem2.updateIt(b.upInstrumentId2, false);
            _uItem3.updateIt(b.upInstrumentId3, false);
        }
    }

    private function onUpdate():void { // DO Upgrade Ambar/Sklad
        var needCountForUpdate:int;
        var st:String;
        var b:StructureDataBuilding;

        if (_isAmbar) {
            b = g.allData.getBuildingById(12);
            if (!g.userValidates.checkInfo('ambarLevel', g.user.ambarLevel)) return;
            needCountForUpdate = b.startCountInstrumets + b.deltaCountAfterUpgrade * (g.user.ambarLevel - 1);
            g.userInventory.addResource(b.upInstrumentId1, -needCountForUpdate);
            g.userInventory.addResource(b.upInstrumentId2, -needCountForUpdate);
            g.userInventory.addResource(b.upInstrumentId3, -needCountForUpdate);
            g.user.ambarLevel++;
            g.user.ambarMaxCount += b.deltaCountResources;
            g.userValidates.updateInfo('ambarLevel', g.user.ambarLevel);
            st = String(g.managerLanguage.allTexts[458])+ ' ' + g.userInventory.currentCountInAmbar + '/' + g.user.ambarMaxCount;
            _progress.setProgress(g.userInventory.currentCountInAmbar / g.user.ambarMaxCount);
            g.server.updateUserAmbar(1, g.user.ambarLevel, null);
        } else {
            b = g.allData.getBuildingById(13);
            if (!g.userValidates.checkInfo('skladLevel', g.user.skladLevel)) return;
            needCountForUpdate = b.startCountInstrumets + b.deltaCountAfterUpgrade * (g.user.skladLevel - 1);
            g.userInventory.addResource(b.upInstrumentId1, -needCountForUpdate);
            g.userInventory.addResource(b.upInstrumentId2, -needCountForUpdate);
            g.userInventory.addResource(b.upInstrumentId3, -needCountForUpdate);
            g.user.skladLevel++;
            g.user.skladMaxCount += b.deltaCountResources;
            g.userValidates.updateInfo('skladLevel', g.user.skladLevel);
            st = String(g.managerLanguage.allTexts[458])+ ' ' + g.userInventory.currentCountInSklad + '/' + g.user.skladMaxCount;
            _progress.setProgress(g.userInventory.currentCountInSklad / g.user.skladMaxCount);
            g.server.updateUserAmbar(2, g.user.skladLevel, null);
        }
        _txtCount.text = st;
        updateForUpdates();
        updateCells();
        if (_uItem1.isFull && _uItem2.isFull && _uItem3.isFull) _btnMakeUpgrade.setEnabled = true;
        else _btnMakeUpgrade.setEnabled = false;
        if (_isAmbar) g.updateAmbarIndicator();
    }

    public function updateProgress():void {
        var a:int;
        _progress.showAmbarIcon(_isAmbar);
        if (_isAmbar) {
            a = g.userInventory.currentCountInAmbar;
            _progress.setProgress(a / g.user.ambarMaxCount);
            _txtCount.text = String(g.managerLanguage.allTexts[462]) + ' ' + String(a) + '/' + String(g.user.ambarMaxCount);
        } else {
            a = g.userInventory.currentCountInSklad;
            _progress.setProgress(a/g.user.skladMaxCount);
            _txtCount.text = String(g.managerLanguage.allTexts[462]) + ' ' + String(a) + '/' + String(g.user.skladMaxCount);
        }
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        if (!_source) return;
        clearCells();
        _source.removeChild(_progress.source);
        _progress.deleteIt();
        _mainPart.removeChild(_scrollSprite.source);
        _scrollSprite.deleteIt();
        _mainPart.removeChild(_btnUpgrade);
        _btnUpgrade.deleteIt();
        _upgradePart.removeChild(_uItem1.source);
        _upgradePart.removeChild(_uItem2.source);
        _upgradePart.removeChild(_uItem3.source);
        _uItem1.deleteIt();
        _uItem2.deleteIt();
        _uItem3.deleteIt();
        _upgradePart.removeChild(_btnBack);
        _btnBack.deleteIt();
        _upgradePart.removeChild(_btnMakeUpgrade);
        _btnMakeUpgrade.deleteIt();
        _source.removeChild(_txtWindowName);
        _txtWindowName.deleteIt();
        _source.removeChild(_txtCount);
        _txtCount.deleteIt();
        _upgradePart.removeChild(_txtNeed);
        _txtNeed.deleteIt();
        _tabs.deleteIt();
        _source.removeChild(_bigYellowBG);
        _bigYellowBG.deleteIt();
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
