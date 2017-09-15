/**
 * Created by andy on 9/1/17.
 */
package windows.shop_new {
import data.BuildType;

import manager.ManagerFilters;

import starling.utils.Color;

import utils.CTextField;
import utils.Utils;
import windows.WOComponents.WindowBackgroundNew;
import windows.WOComponents.YellowBackgroundOut;
import windows.WindowMain;
import windows.WindowsManager;

public class WOShopNew extends WindowMain {
    public static const VILLAGE:int=1;
    public static const ANIMAL:int=2;
    public static const FABRICA:int=3;
    public static const PLANT:int=4;
    public static const DECOR:int=5;
    
    private var _bigYellowBG:YellowBackgroundOut;
    private var _tabs:ShopNewTabs;
    private var _decorFilter:DecorShopNewFilter;
    private var _shopList:ShopNewList;
    private var _isBigShop:Boolean;
    private var _txtShopName:CTextField;
    
    public function WOShopNew() {
        super();
        _windowType = WindowsManager.WO_SHOP_NEW;
        if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) _isBigShop = false;
            else _isBigShop = true;
        if (_isBigShop) {
            _woWidth = 988;
            _woHeight = 676;
        } else {
            _woWidth = 830;
            _woHeight = 486;
        }
        if (_isBigShop) _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 154);
            else _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 124);
        _source.addChild(_woBGNew);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        if (_isBigShop) {
            _bigYellowBG = new YellowBackgroundOut(868, 486);
            _bigYellowBG.x = -434;
            _bigYellowBG.y = -185;
        } else {
            _bigYellowBG = new YellowBackgroundOut(810, 346);
            _bigYellowBG.x = -405;
            _bigYellowBG.y = -120;
        }
        _bigYellowBG.source.touchable = true;
        _source.addChild(_bigYellowBG);

        _tabs = new ShopNewTabs(_bigYellowBG, onChooseTab, _isBigShop);
        _decorFilter = new DecorShopNewFilter(this, _isBigShop);
        if (_isBigShop) {
            _decorFilter.source.x = -_woWidth / 2 + 81;
            _decorFilter.source.y = -_woHeight / 2 + 170;
        } else {
            _decorFilter.source.x = -_woWidth / 2 + 81;
            _decorFilter.source.y = -_woHeight / 2 + 142;
        }
        _source.addChild(_decorFilter.source);
        _decorFilter.source.visible = false;

        _shopList = new ShopNewList(_source, this, _isBigShop);
        
        _txtShopName = new CTextField(400,200, g.managerLanguage.allTexts[352]);
        _txtShopName.setFormat(CTextField.BOLD30, 60, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtShopName.x = -200;
        if (_isBigShop) _txtShopName.y = -_woHeight/2 - 55;
            else _txtShopName.y = -_woHeight/2 + 27;
        _source.addChild(_txtShopName);
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        if (params && params[0]) g.user.shopTab = params[0];
        _tabs.activateTab(g.user.shopTab);
        onChooseTab(g.user.shopTab);
        super.showIt();
    }

    public function onChooseTab(n:int):void {
        var arr:Array = [];
        var i:int;
        var arR:Array;

        g.user.shopTab = n;
        _decorFilter.source.visible = n == 5;

        switch (n) {
            case VILLAGE:
                arR = g.allData.building;
                for (i = 0; i < arR.length; i++) {
                    if (arR[i].buildType == BuildType.RIDGE || arR[i].buildType == BuildType.FARM) {
                        arr.push(Utils.objectFromStructureBuildToObject(arR[i]));
                    }
                }
                break;
            case ANIMAL:
                arR = g.allData.animal;
                for (i = 0; i < arR.length; i++) {
                    arr.push(Utils.objectFromStructureAnimaToObject(arR[i]));
                }
                break;
            case FABRICA:
                arR = g.allData.building;
                for (i = 0; i < arR.length; i++) {
                    if (arR[i].buildType == BuildType.FABRICA) {
                        arr.push(Utils.objectFromStructureBuildToObject(arR[i]));
                    }
                }
                break;
            case PLANT:
                arR = g.allData.building;
                for (i = 0; i < arR.length; i++) {
                    if (arR[i].buildType == BuildType.TREE) {
                        arr.push(Utils.objectFromStructureBuildToObject(arR[i]));
                    }
                }
                break;
            case DECOR:
                arR = g.allData.building;
                for (i = 0; i < arR.length; i++) {
                    if (arR[i].buildType == BuildType.DECOR || arR[i].buildType == BuildType.DECOR_ANIMATION || arR[i].buildType == BuildType.DECOR_FULL_FENСE ||
                            arR[i].buildType == BuildType.DECOR_POST_FENCE || arR[i].buildType == BuildType.DECOR_TAIL || arR[i].buildType == BuildType.DECOR_FENCE_GATE ||
                            arR[i].buildType == BuildType.DECOR_FENCE_ARKA || arR[i].buildType == BuildType.DECOR_POST_FENCE_ARKA) {
                        if (g.user.shopDecorFilter == DecorShopNewFilter.FILTER_ALL || g.user.shopDecorFilter == arR[i].filterType) {
                            if (arR[i].buildType == BuildType.DECOR || arR[i].buildType == BuildType.DECOR_ANIMATION || arR[i].buildType == BuildType.DECOR_TAIL) {
                                if (arR[i].group && !g.allData.isFirstInGroupDecor(arR[i].group, arR[i].id))
                                    continue;
                            }
                            arr.push(Utils.objectFromStructureBuildToObject(arR[i]));
                        }
                    }
                }
                break;
            default:

        }
        _shopList.updateList(arr);
    }

    public function openOnResource(_id:int):void { _shopList.openOnResource(_id); }
    public function getShopItemBounds(_id:int):Object { return _shopList.getShopItemBounds(_id); }
    public function addItemArrow(_id:int, t:int=0):void { _shopList.addItemArrow(_id, t); }
    public function addArrowAtPos(n:int, t:int=0):void { _shopList.addArrowAtPos(n, t); }
    public function deleteAllArrows():void { _shopList.deleteAllArrows(); }

    private function onClickExit():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts) return;
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (!_source) return;
        _source.removeChild(_txtShopName);
        _txtShopName.deleteIt();
        _source.removeChild(_bigYellowBG);
        _bigYellowBG.deleteIt();
        _tabs.deleteIt();
        _source.removeChild(_decorFilter.source);
        _decorFilter.deleteIt();
        _shopList.deleteIt();
        super.deleteIt();
    }



}
}
