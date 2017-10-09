/**
 * Created by user on 10/1/15.
 */
package windows.lockedLand {
import build.lockedLand.LockedLand;
import com.junkbyte.console.Cc;
import manager.ManagerFilters;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOLockedLand extends WindowMain {
    private var _dataLand:Object;
    private var _land:LockedLand;
    private var _arrItems:Array;
    private var _btnOpen:CButton;
    private var _woBG:WindowBackgroundNew;
    private var _bgC:BackgroundYellowOut;
    private var _txtInfo:CTextField;
    private var _txtBtn:CTextField;
    private var _txtName:CTextField;

    public function WOLockedLand() {
        super();
        _windowType = WindowsManager.WO_LOCKED_LAND;
        _arrItems = [];
        _woWidth = 550;
        _woHeight = 460;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,115);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        _bgC = new BackgroundYellowOut(510, 320);
        _bgC.x = -_woWidth/2 + 20;
        _bgC.y = -_woHeight/2 + 115;
        _source.addChild(_bgC);

        _txtName = new CTextField(400, 70, g.managerLanguage.allTexts[1156]);
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtName.x = -205;
        _txtName.y = -_woHeight / 2 + 25;
        _source.addChild(_txtName);

        _btnOpen = new CButton();
        _btnOpen.addButtonTexture(158, CButton.HEIGHT_41, CButton.GREEN, true);
        _btnOpen.addTextField(158, 38, 0, 0, String(g.managerLanguage.allTexts[418]));
        _btnOpen.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btnOpen.y = 175;
        _source.addChild(_btnOpen);
        _txtInfo = new CTextField(500,97,String(g.managerLanguage.allTexts[419]));
        _txtInfo.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtInfo.x = -255;
        _txtInfo.y = -125;
        _source.addChild(_txtInfo);
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        _dataLand = params[0];
        _land = params[1];

        if (!_dataLand || !_land) {
            Cc.error('WOLockedLand showIt:: bad _dataLand or _land');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woLockedLand');
            return;
        }

        var item:LockedLandItem;
        if (_dataLand.friendsCount > 0) {
            item = new LockedLandItem();
            item.fillWithCurrency(_dataLand.currencyCount);
            item.source.x = -_woWidth/2 + 64;
            item.source.y = -_woHeight/2 + 175;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithResource(_dataLand.resourceId, _dataLand.resourceCount);
            item.source.x = -_woWidth/2 + 190;
            item.source.y = -_woHeight/2 + 175;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithFriends(_dataLand.friendsCount);
            item.source.x = -_woWidth/2 + 320;
            item.source.y = -_woHeight/2 + 175;
            _source.addChild(item.source);
            _arrItems.push(item);
        } else {
            item = new LockedLandItem();
            item.fillWithCurrency(_dataLand.currencyCount);
            item.source.x = -_woWidth/2 + 150;
            item.source.y = -_woHeight/2 + 240;
            _source.addChild(item.source);
            _arrItems.push(item);

            item = new LockedLandItem();
            item.fillWithResource(_dataLand.resourceId, _dataLand.resourceCount);
            item.source.x = -_woWidth/2 + 350;
            item.source.y = -_woHeight/2 + 240;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
        checkBtn();
        super.showIt();
    }

    private function checkBtn():void {
        var b:Boolean = true;
        for (var i:int=0; i<_arrItems.length; i++) {
            if (!_arrItems[i].isGood) {
                b = false;
                break;
            }
        }
        if (b) {
            _btnOpen.setEnabled = true;
            _btnOpen.clickCallback = onBtnOpen;
        } else {
            _btnOpen.clickCallback = null;
            _btnOpen.setEnabled = false;
        }
    }

    private function onBtnOpen():void {
        _land.showBoom();
        _land = null;
        g.managerAchievement.addAll(20,1);
        hideIt();
    }

    override protected function deleteIt():void {
        if (_txtInfo) {
            _txtInfo.deleteIt();
            _txtInfo = null;
        }
        if (_txtBtn) {
            _btnOpen.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        for (var i:int=0; i<_arrItems.length; i++) {
            _source.removeChild(_arrItems[i].source);
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        if (_btnOpen) {
            _source.removeChild(_btnOpen);
            _btnOpen.deleteIt();
            _btnOpen = null;
        }
        _source.removeChild(_bgC);
        _bgC.deleteIt();
        _bgC = null;
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        super.deleteIt();
    }
}
}
