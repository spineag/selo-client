/**
 * Created by andy on 9/4/17.
 */
package windows.shop_new {
import manager.Vars;
import starling.display.Sprite;
import windows.WOComponents.WhiteBackgroundIn;

public class DecorShopNewFilter {
    public static const FILTER_OTHER:int = 0;
    public static const FILTER_HOLIDAY:int = 6;
    public static const FILTER_TREES:int = 2;
    public static const FILTER_FENCE:int = 3;
    public static const FILTER_TAIL:int = 4;
    public static const FILTER_SPECIAL:int = 5;
    public static const FILTER_ALL:int = 1;

    private var g:Vars = Vars.getInstance();
    private var _wo:WOShopNew;
    private var _source:Sprite;
    private var _bg:WhiteBackgroundIn;
    private var _arrBtns:Array;
    private var _activeBtn:FilterButtonItem;

    public function DecorShopNewFilter(w:WOShopNew) {
        _wo = w;
        _source = new Sprite();
        _bg = new WhiteBackgroundIn(160, 450);
        _source.addChild(_bg);
        _arrBtns = [];
        createBtns();
    }

    public function get source():Sprite { return _source; }

    private function createBtns():void {
        var arr:Array = [FILTER_ALL, FILTER_FENCE, FILTER_TAIL, FILTER_TREES,  FILTER_OTHER, FILTER_SPECIAL];
        if (g.managerParty.filterOn && g.managerParty.eventOn && g.managerParty.levelToStart <= g.user.level) arr.insertAt(0, FILTER_HOLIDAY);
        var item:FilterButtonItem;
        for (var i:int=0; i<arr.length; i++) {
            item = new FilterButtonItem(arr[i], onClick);
            item.btnSource.x = 84;
            item.btnSource.y = 45 + 55*i;
            _source.addChild(item.btnSource);
            if (arr[i] == g.user.shopDecorFilter) {
                item.setActive(true);
                _activeBtn = item;
            } else item.setActive(false);
            _arrBtns.push(item);
        }

    }
    
    private function onClick(id:int):void {
        for (var i:int=0; i<_arrBtns.length; i++) {
            (_arrBtns[i] as FilterButtonItem).setActive(false);
        }
        _activeBtn = getItemByID(id);
        _activeBtn.setActive(true);
        g.user.shopDecorFilter = id;
        g.user.decorShiftShop = 0;
        _wo.onChooseTab(WOShopNew.DECOR);
    }

    private function getItemByID(id:int):FilterButtonItem {
        for (var i:int=0; _arrBtns.length; i++) {
            if ((_arrBtns[i] as FilterButtonItem).filterID == id) return _arrBtns[i];
        }
        return null;
    }

    public function deleteIt():void {
        if (!_source) return;
        for (var i:int=0; i<_arrBtns.length; i++) {
            _source.removeChild((_arrBtns[i] as FilterButtonItem).btnSource);
            (_arrBtns[i] as FilterButtonItem).deleteIt();
        }
        _arrBtns.length = 0;
        _source.removeChild(_bg);
        _bg.deleteIt();
        _source.dispose();
        _source = null;
        _wo = null;
        _activeBtn = null;
    }

}
}

import manager.ManagerFilters;
import manager.Vars;
import utils.CButton;
import utils.CTextField;
import windows.shop_new.DecorShopNewFilter;

internal class FilterButtonItem {
    private var g:Vars = Vars.getInstance();
    private var _btn:CButton;
    private var _txt:CTextField;
    private var _filterID:int;

    public function FilterButtonItem(id:int, f:Function) {
        _filterID = id;
        _btn = new CButton();
        _btn.addButtonTexture(120, 45, CButton.YELLOW, true);
        _btn.clickCallback = function():void {
            if (f!=null) f.apply(null, [_filterID]);
        };
        _txt = new CTextField(120, 40, '');
        _txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BROWN_COLOR);
        _btn.addChild(_txt);
        switch (_filterID) {
            case DecorShopNewFilter.FILTER_ALL: _txt.text = String(g.managerLanguage.allTexts[332]); break;
            case DecorShopNewFilter.FILTER_OTHER: _txt.text = String(g.managerLanguage.allTexts[333]); break;
            case DecorShopNewFilter.FILTER_FENCE: _txt.text = String(g.managerLanguage.allTexts[334]); break;
            case DecorShopNewFilter.FILTER_TAIL: _txt.text = String(g.managerLanguage.allTexts[335]); break;
            case DecorShopNewFilter.FILTER_TREES: _txt.text = String(g.managerLanguage.allTexts[336]); break;
            case DecorShopNewFilter.FILTER_SPECIAL: _txt.text = String(g.managerLanguage.allTexts[337]); break;
            case DecorShopNewFilter.FILTER_HOLIDAY: _txt.text = String(g.managerLanguage.allTexts[338]); break;
        }
    }

    public function get btnSource():CButton { return _btn; }
    public function get filterID():int { return _filterID; }

    public function setActive(v:Boolean):void {
        if (v) {
            _btn.colorBGFilter = null;
            _btn.isTouchable = false;
        } else {
            _btn.colorBGFilter = ManagerFilters.SMALL_DISABLE_FILTER;
            _btn.isTouchable = true;
        }
    }

    public function deleteIt():void {
        _btn.removeChild(_txt);
        _txt.deleteIt();
        _btn.deleteIt();
    }
}
