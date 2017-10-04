/**
 * Created by user on 7/17/15.
 */
package windows.buyCurrency {
import data.DataMoney;
import manager.ManagerFilters;
import media.SoundConst;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOBuyCurrency extends WindowMain {
    private var _isHard:Boolean = false;
    private var _arrItems:Array;
    private var _txtWindowName:CTextField;
    private var _tabs:MoneyTabs;
    private var _bigYellowBG:BackgroundYellowOut;

    public function WOBuyCurrency() {
        super();
        SOUND_OPEN = SoundConst.OPEN_CURRENCY_WINDOW;
        _windowType = WindowsManager.WO_BUY_CURRENCY;
        _woWidth = 856;
        _woHeight = 762;
        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 108);
        _source.addChild(_woBGNew);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;

        _txtWindowName = new CTextField(300, 50, g.managerLanguage.allTexts[453]);
        _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtWindowName.x = -150;
        _txtWindowName.y = -_woHeight/2 + 23;
        _source.addChild(_txtWindowName);

        _bigYellowBG = new BackgroundYellowOut(804, 558);
        _bigYellowBG.y = -_woHeight / 2 + 176;
        _bigYellowBG.x = -402;
        _bigYellowBG.source.touchable = true;
        _source.addChild(_bigYellowBG);
        _tabs = new MoneyTabs(_bigYellowBG, onTabClick);
    }

    private function createLists():void {
        var item:WOBuyCurrencyItem;
        var arrInfo:Array = [];
        var arr:Array = g.allData.dataBuyMoney;

        _arrItems = [];
        for (var i:int = 0; i<arr.length; i++) {
            if (_isHard && arr[i].typeMoney == DataMoney.HARD_CURRENCY) {
                arrInfo.push(arr[i]);
            } else if (!_isHard && arr[i].typeMoney == DataMoney.SOFT_CURRENCY) {
                arrInfo.push(arr[i]);
            }
        }
        arrInfo.sortOn('count', Array.NUMERIC);
        for (i=0; i< arrInfo.length; i++) {
            item = new WOBuyCurrencyItem(arrInfo[i].typeMoney, arrInfo[i].count, arrInfo[i].bonus, arrInfo[i].cost, arrInfo[i].id, arrInfo[i].sale);
            item.source.x = -_woWidth/2 + 57 + (i%3)*260;
            if (i<3) item.source.y = -_woHeight/2 + 204;
                else item.source.y = -_woHeight/2 + 468;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function onTabClick():void {
        _isHard = !_isHard;
        _tabs.activate(!_isHard);
        deleteLists();
        createLists();
    }

    private function deleteLists():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            _source.removeChild(_arrItems[i].source);
            (_arrItems[i] as WOBuyCurrencyItem).deleteIt();
        }
        _arrItems.length = 0;
    }

    override public function showItParams(callback:Function, params:Array):void {
        _isHard = params[0];
        _tabs.activate(!_isHard);
        createLists();
        super.showIt();
    }

    override protected function deleteIt():void {
        if (!_source) return;
        deleteLists();
        _source.removeChild(_txtWindowName);
        _txtWindowName.deleteIt();
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

internal class MoneyTabs {
    private var g:Vars = Vars.getInstance();
    private var _callback:Function;
    private var _imActiveSoft:Image;
    private var _txtActiveSoft:CTextField;
    private var _unactiveSoft:CSprite;
    private var _txtUnactiveSoft:CTextField;
    private var _imActiveHard:Image;
    private var _txtActiveHard:CTextField;
    private var _unactiveHard:CSprite;
    private var _txtUnactiveHard:CTextField;
    private var _bg:BackgroundYellowOut;

    public function MoneyTabs(bg:BackgroundYellowOut, f:Function) {
        _bg = bg;
        _callback = f;
        _imActiveSoft = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bank_panel_tab_big'));
        _imActiveSoft.pivotX = _imActiveSoft.width/2;
        _imActiveSoft.pivotY = _imActiveSoft.height;
        _imActiveSoft.x = 230;
        _imActiveSoft.y = 11;
        bg.addChild(_imActiveSoft);
        _txtActiveSoft = new CTextField(330, 48, g.managerLanguage.allTexts[325]);
        _txtActiveSoft.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtActiveSoft.x = 69;
        _txtActiveSoft.y = -50;
        bg.addChild(_txtActiveSoft);

        _unactiveSoft = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bank_panel_tab_small'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        _unactiveSoft.addChild(im);
        _unactiveSoft.x = 230;
        _unactiveSoft.y = 13;
        bg.addChildAt(_unactiveSoft, 0);
        _unactiveSoft.endClickCallback = onClick;
        _txtUnactiveSoft = new CTextField(330, 48, g.managerLanguage.allTexts[325]);
        _txtUnactiveSoft.setFormat(CTextField.BOLD24, 24, ManagerFilters.BROWN_COLOR, Color.WHITE);
        _txtUnactiveSoft.x = 69;
        _txtUnactiveSoft.y = -42;
        bg.addChild(_txtUnactiveSoft);

        _imActiveHard = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bank_panel_tab_big'));
        _imActiveHard.pivotX = _imActiveHard.width/2;
        _imActiveHard.pivotY = _imActiveHard.height;
        _imActiveHard.x = 578;
        _imActiveHard.y = 11;
        bg.addChild(_imActiveHard);
        _txtActiveHard = new CTextField(330, 48, g.managerLanguage.allTexts[326]);
        _txtActiveHard.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtActiveHard.x = 412;
        _txtActiveHard.y = -50;
        bg.addChild(_txtActiveHard);

        _unactiveHard = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bank_panel_tab_small'));
        im.pivotX = im.width/2;
        im.pivotY = im.height;
        _unactiveHard.addChild(im);
        _unactiveHard.x = 578;
        _unactiveHard.y = 13;
        bg.addChildAt(_unactiveHard, 0);
        _unactiveHard.endClickCallback = onClick;
        _txtUnactiveHard = new CTextField(330, 48, g.managerLanguage.allTexts[326]);
        _txtUnactiveHard.setFormat(CTextField.BOLD24, 24, ManagerFilters.BROWN_COLOR, Color.WHITE);
        _txtUnactiveHard.x = 412;
        _txtUnactiveHard.y = -42;
        bg.addChild(_txtUnactiveHard);
    }

    private function onClick():void { if (_callback!=null) _callback.apply(); }

    public function activate(isSoft:Boolean):void {
        _imActiveSoft.visible = _unactiveHard.visible = isSoft;
        _imActiveHard.visible = _unactiveSoft.visible = !isSoft;
        _txtActiveSoft.visible = _txtUnactiveHard.visible = isSoft;
        _txtActiveHard.visible = _txtUnactiveSoft.visible = !isSoft;
    }

    public function deleteIt():void {
        _bg.removeChild(_txtActiveSoft);
        _bg.removeChild(_txtActiveHard);
        _bg.removeChild(_txtUnactiveHard);
        _bg.removeChild(_txtUnactiveSoft);
        _bg.removeChild(_imActiveSoft);
        _bg.removeChild(_imActiveHard);
        _bg.removeChild(_unactiveSoft);
        _bg.removeChild(_unactiveHard);
        _txtActiveSoft.deleteIt();
        _txtActiveHard.deleteIt();
        _txtUnactiveSoft.deleteIt();
        _txtUnactiveHard.deleteIt();
        _imActiveSoft.dispose();
        _imActiveHard.dispose();
        _unactiveSoft.deleteIt();
        _unactiveHard.deleteIt();
        _bg = null;
    }

}

