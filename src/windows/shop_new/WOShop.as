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
import windows.WOComponents.BackgroundYellowOut;
import windows.WindowMain;
import windows.WindowsManager;

public class WOShop extends WindowMain {
    public static const VILLAGE:int=1;
    public static const ANIMAL:int=2;
    public static const FABRICA:int=3;
    public static const PLANT:int=4;
    public static const DECOR:int=5;
    
    private var _bigYellowBG:BackgroundYellowOut;
    private var _tabs:ShopTabs;
    private var _decorFilter:DecorShopFilter;
    private var _shopList:ShopList;
    private var _txtWindowName:CTextField;
    private var _txtDecorInventory:CTextField;

    public function WOShop() {
        super();
        _windowType = WindowsManager.WO_SHOP;
        if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) _isBigWO = false;
            else _isBigWO = true;
        if (_isBigWO) {
            _woWidth = 988;
            _woHeight = 676;
        } else {
            _woWidth = 830;
            _woHeight = 486;
        }
        if (_isBigWO) _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 154);
            else _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 144);
        _source.addChild(_woBGNew);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        if (_isBigWO) {
            _bigYellowBG = new BackgroundYellowOut(868, 486);
            _bigYellowBG.x = -434;
            _bigYellowBG.y = -185;
        } else {
            _bigYellowBG = new BackgroundYellowOut(810, 326);
            _bigYellowBG.x = -405;
            _bigYellowBG.y = -100;
        }
        _bigYellowBG.source.touchable = true;
        _source.addChild(_bigYellowBG);

        _tabs = new ShopTabs(_bigYellowBG, onChooseTab, _isBigWO);
        _decorFilter = new DecorShopFilter(this, _isBigWO);
        if (_isBigWO) {
            _decorFilter.source.x = -_woWidth / 2 + 81;
            _decorFilter.source.y = -_woHeight / 2 + 170;
        } else {
            _decorFilter.source.x = -_woWidth / 2 + 81;
            _decorFilter.source.y = -_woHeight / 2 + 162;
        }
        _source.addChild(_decorFilter.source);
        _decorFilter.source.visible = false;

        _shopList = new ShopList(_source, this, _isBigWO);
        
        _txtWindowName = new CTextField(300, 70, g.managerLanguage.allTexts[352]);
        _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtWindowName.x = -150;
        if (_isBigWO) _txtWindowName.y = -_woHeight/2 + 20;
            else _txtWindowName.y = -_woHeight/2 + 10;
        _source.addChild(_txtWindowName);
        _txtDecorInventory = new CTextField(300, 70, g.managerLanguage.allTexts[1235]);
        _txtDecorInventory.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtDecorInventory.x = -70;
        _source.addChild(_txtDecorInventory);
        _txtDecorInventory.visible = false;
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        if (g.tuts.isTuts) {
            _tabs.activateTab(params[0]);
            onChooseTab(params[0]);
        } else {
            _tabs.activateTab(g.user.shopTab);
            onChooseTab(g.user.shopTab);
        }
        super.showIt();
    }

    public function onChooseTab(n:int):void {
        var arr:Array = [];
        var i:int;
        var arR:Array;

        g.user.shopTab = n;
        _decorFilter.source.visible = n == 5;
        _txtDecorInventory.visible = false;
        _shopList.booleanPage(true);
        if (n < 0) n = 1;
        switch (n) {
            case VILLAGE:
                arR = g.allData.building;
                for (i = 0; i < arR.length; i++) {
                    if (arR[i].buildType == BuildType.RIDGE || arR[i].buildType == BuildType.FARM || arR[i].buildType == BuildType.PET_HOUSE) {
                        arr.push(Utils.objectFromStructureBuildToObject(arR[i]));
                    }
                }
                break;
            case ANIMAL:
                arR = g.allData.animal;
                for (i = 0; i < arR.length; i++) {
                    arr.push(Utils.objectFromStructureAnimaToObject(arR[i],g.allData.getBuildingById(arR[i].buildId).blockByLevel[0]));
                }
                arR = g.allData.pet;
                for (i = 0; i < arR.length; i++) {
                    arr.push(Utils.objectFromStructurePetToObject(arR[i]));
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
                        if (g.user.shopDecorFilter == DecorShopFilter.FILTER_ALL || g.user.shopDecorFilter == arR[i].filterType || g.user.shopDecorFilter == arR[i].beforInventroy) {
                            if (arR[i].buildType == BuildType.DECOR || arR[i].buildType == BuildType.DECOR_ANIMATION || arR[i].buildType == BuildType.DECOR_TAIL) {
                                if (arR[i].group && !g.allData.isFirstInGroupDecor(arR[i].group, arR[i].id))
                                    continue;
                            }
                            if (arR[i].visibleAction) arr.push(Utils.objectFromStructureBuildToObject(arR[i]));
                            else if (g.userInventory.decorInventory[arR[i].id]) arr.push(Utils.objectFromStructureBuildToObject(arR[i]));
                        }
                    }
                }
                    if (arr.length == 0) {
                        _txtDecorInventory.visible = true;
                        _shopList.booleanPage(false);
                    }
                break;
        }
        _shopList.updateList(arr);
    }

    public function openOnResource(_id:int, buildType:int=BuildType.UNKNOWN_TYPE):void { _shopList.openOnResource(_id, buildType); }
    public function getShopItemBounds(_id:int):Object { return _shopList.getShopItemBounds(_id); }
    public function addItemArrow(_id:int, t:int=0, buildType:int=BuildType.UNKNOWN_TYPE):void { _shopList.addItemArrow(_id, t, buildType); }
    public function addArrowAtPos(n:int, t:int=0):void { _shopList.addArrowAtPos(n, t); }
    public function deleteAllArrows():void { _shopList.deleteAllArrows(); }

    private function onClickExit():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts) return;
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (!_source) return;
        _source.removeChild(_txtWindowName);
        _txtWindowName.deleteIt();
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
