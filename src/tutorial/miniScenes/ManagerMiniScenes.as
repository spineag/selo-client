/**
 * Created by user on 12/5/16.
 */
package tutorial.miniScenes {
import build.WorldObject;
import build.market.Market;
import build.orders.Order;
import build.tree.Tree;

import com.junkbyte.console.Cc;
import data.BuildType;
import order.OrderCat;
import manager.Vars;
import particle.tuts.DustRectangle;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import tutorial.AirTextBubble;
import tutorial.CutScene;
import utils.SimpleArrow;
import utils.Utils;
import windows.WindowsManager;
import windows.market.WOMarket;
import windows.shop_new.WOShop;

public class ManagerMiniScenes {
    public static const OPEN_ORDER:int = 1;  // use after getting new level
    public static const BUY_ORDER:int = 2;  // use after ending prev miniSCene
    public static const ON_GO_NEIGHBOR:int = 3;
    public static const GO_NEIGHBOR:int = 4;
    public static const BUY_BUILD:int = 5;
    public static const BUY_INSTRUMENT:int = 6;
    public static const NEW_ORDER_CAT:int = 7;
    public static const ORDER_INSTRUMENT:int = 8;
    public static const DEAD_TREE:int = 9;

    private var g:Vars = Vars.getInstance();
    private var _properties:Array;
    private var _curMiniScenePropertie:Object;
    private var _cutScene:CutScene;
    private var _airBubble:AirTextBubble;
    private var _arrow:SimpleArrow;
    private var _dustRectangle:DustRectangle;
    private var _black:Sprite;
    private var _miniSceneResourceIDs:Array;
    private var _miniSceneBuildings:Array;
    private var _miniSceneCallback:Function;
    public var isMiniScene:Boolean = false;
    public var isMiniSceneOrder:Boolean = false;
    private var _onShowWindowCallback:Function;
    private var _onHideWindowCallback:Function;
    private var _counter:int;
    private var _oCat:MiniSceneOrderCat;
    private var _mOrderOpenCat:MiniSceneOpenOrder;
    public var continueAfterNeighbor:int=-1;

    public function ManagerMiniScenes() {
        _properties = (new MiniSceneProps()).properties;
        _miniSceneBuildings = [];
        _miniSceneResourceIDs = [];
        _oCat = new MiniSceneOrderCat();
    }

    public function isReason(reason:int):Boolean {
        if (_curMiniScenePropertie) {
            return _curMiniScenePropertie.reason == reason;
        } else return false;
    }

    public function startOrderOpenMiniScene():void {
        isMiniSceneOrder = true;
        _mOrderOpenCat = new MiniSceneOpenOrder();
    }

    public function closeOrderOpenMiniScene():void {
        isMiniSceneOrder = false;
        if(_mOrderOpenCat) _mOrderOpenCat.deleteCat();
    }

    public function deleteArrowAndDust():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function checkMiniCutSceneCallbackOnShowWindow():void { if (_onShowWindowCallback != null) { _onShowWindowCallback.apply(); } }
    public function checkMiniCutSceneCallbackOnHideWindow():void { if (_onHideWindowCallback != null) { _onHideWindowCallback.apply(); } }
    private function saveUserMiniScenesData():void {  g.server.updateUserMiniScenesData(); }
    public function isMiniSceneResource(id:int):Boolean { return _miniSceneResourceIDs.indexOf(id) > -1; }
    public function get oCat():MiniSceneOrderCat { return _oCat; }

    public function releaseMiniSceneForOrderCat(cat:OrderCat):void {
        isMiniScene = true;
        _curMiniScenePropertie = {};
        _curMiniScenePropertie.reason = NEW_ORDER_CAT;
        _oCat.releaseMiniSceneForCat(cat);
    }
    
    public function onEndMiniSceneForOrderCat():void {
        isMiniScene = false;
        _curMiniScenePropertie = {};
        //letsGoToNeighbor();
    }

    public function checkMiniSceneCallback():void {
        if (_miniSceneCallback != null) {
            _miniSceneCallback.apply();
        }
    }

    public function isMiniSceneBuilding(wo:WorldObject):Boolean {
        if(_miniSceneBuildings.length)  return _miniSceneBuildings.indexOf(wo) > -1;
        else return false;
    }

    private function addBlack():void {
        if (!_black) {
            var q:Quad = new Quad(g.managerResize.stageWidth, g.managerResize.stageHeight, Color.BLACK);
            _black = new Sprite();
            _black.addChild(q);
            _black.alpha = .3;
            g.cont.popupCont.addChildAt(_black, 0);
        }
    }

    private function removeBlack():void {
        if (_black) {
            if (g.cont.popupCont.contains(_black)) g.cont.popupCont.removeChild(_black);
            _black.dispose();
            _black = null;
        }
    }

    private function deleteCutScene():void {
        if (_cutScene) {
            _cutScene.deleteIt();
            _cutScene = null;
        }
    }

    public function updateMiniScenesLengthOnGameStart():void {
        var countActions:int = _properties.length;
        var l:int;
        var needUpdate:Boolean = false;
        if (g.user.miniScenes.length < countActions) {
            l = countActions - g.user.miniScenes.length;
            while (l>0) {
                needUpdate = true;
                g.user.miniScenes.push(0);
                l--;
            }
        }
        checkForAvailableLevels(needUpdate);
    }

    private function checkForAvailableLevels(needUpdate:Boolean = false):void {
        var countActions:int = _properties.length;
        var l:int;
        for (l=0; l<countActions; l++) {
            if (_properties[l].level < g.user.level) {
                g.user.miniScenes[l] = 1;
                needUpdate = true;
            }
        }
        if (needUpdate) saveUserMiniScenesData();
    }
    
    public function checkDeleteMiniScene():void {
        if (isMiniScene) {
            isMiniScene = false;
            removeBlack();
            if (_cutScene) _cutScene.hideIt(deleteCutScene);
            deleteArrowAndDust();
            if (_airBubble) _airBubble.hideIt();
            _airBubble = null;
            _miniSceneBuildings = [];
            _miniSceneCallback = null;
            _miniSceneResourceIDs = [];
            _onHideWindowCallback = null;
            _onHideWindowCallback = null;
        }
    }

    public function checkAvailableMiniScenesOnNewLevel():void {
        return;

        
        if (g.user.level > 3) {
            checkForAvailableLevels();
        } else if (g.user.level == 3) {
            checkForAvailableLevels();
            if (g.isAway) return;
            var countActions:int = _properties.length;
            var l:int;
            for (l = 0; l < countActions; l++) {
                if (g.user.miniScenes[l] == 0) { // if == 1 - its mean, that miniScene was showed
                    if (_properties[l].level == g.user.level) {
                        _curMiniScenePropertie = _properties[l];
                        forReleaseMini();
                        return;
                    }
                }
            }
        }
    }

    private function forReleaseMini():void {
        return;
        
        
        if (!_curMiniScenePropertie) return;
        switch (_curMiniScenePropertie.id) {
            case 1: openOrderBuilding(); break;
            case 2: firstOrderBuyer(); break;
            case 3: buildBulo4na(); break;
        }
    }

    private function openOrderBuilding():void {
        return;
        
        
        if (g.isAway) return;
        if (g.user.level > _properties.level) {
            order_2();
            return;
        }
        if (!g.allData.factory['tutorialCatBig']) {
            var st:String;
            if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) st = 'animations_json/cat_tutorial_small';
            else st = 'animations_json/cat_tutorial';
            g.loadAnimation.load(st, 'tutorialCatBig', openOrderBuilding);
            return;
        }
        isMiniScene = true;
        _curMiniScenePropertie = _properties[0];
        _miniSceneBuildings = g.townArea.getCityObjectsByType(BuildType.ORDER);
        if ((_miniSceneBuildings[0] as Order).stateBuild == WorldObject.STATE_UNACTIVE) {
            if (!_cutScene) _cutScene = new CutScene();
            addBlack();
            _cutScene.showIt(_curMiniScenePropertie.text, String(g.managerLanguage.allTexts[532]), order_1);
        } else {
            order_2();
        }
    }

    private function order_1():void {
        _cutScene.hideIt(deleteCutScene);
        removeBlack();
        g.cont.moveCenterToPos(_miniSceneBuildings[0].posX - 3, _miniSceneBuildings[0].posY - 3);
        (_miniSceneBuildings[0] as Order).showArrow();
        _miniSceneCallback = order_2;
    }

    private function order_2():void {
        _miniSceneCallback = null;
        g.user.miniScenes[0] = 1;
        saveUserMiniScenesData();
        _counter = 0;
        if (!g.managerOrder.countOrders) {
            _counter = 2;
//            g.managerOrder.addOrderForMiniScenes(firstOrderBuyer);
            Utils.createDelay(1, order_3);
        } else firstOrderBuyer();
    }

    private function order_3():void {
        g.cont.moveCenterToPos(40, 1, false, 2);
        Utils.createDelay(5, order_4);
    }

    private function order_4():void {
        g.cont.moveCenterToPos(31, 26, false, 3);
    }

    private function firstOrderBuyer(c:OrderCat=null):void {
        return;
        
        
        _counter--;
        if (_counter > 0) return;
        if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
        _curMiniScenePropertie = _properties[1];
        if (g.user.level > _properties.level) {
            buyer_15();
            return;
        }
        if (!g.allData.factory['tutorialCatBig']) {
            var st:String;
            if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) st = 'animations_json/cat_tutorial_small';
            else st = 'animations_json/cat_tutorial';
            g.loadAnimation.load(st, 'tutorialCatBig', firstOrderBuyer);
            return;
        }
        if (!g.managerOrder.countOrders) {
//            g.managerOrder.addOrderForMiniScenes(firstOrderBuyer);
            return;
        }
        isMiniScene = true;
        if (!_miniSceneBuildings.length) {
            _miniSceneBuildings = g.townArea.getCityObjectsByType(BuildType.ORDER);
        }
        g.cont.moveCenterToPos(_miniSceneBuildings[0].posX - 3, _miniSceneBuildings[0].posY - 3);
        (_miniSceneBuildings[0] as Order).showArrow();
        if (!_cutScene) _cutScene = new CutScene();
        addBlack();
        _cutScene.showIt(_curMiniScenePropertie.text, String(g.managerLanguage.allTexts[532]), buyer_1);
    }

    private function buyer_1():void {
        _cutScene.hideIt(deleteCutScene);
        removeBlack();
        _miniSceneCallback = buyer_2;
    }

    private function buyer_2():void {
        _miniSceneCallback = null;
        _onShowWindowCallback = buyer_3;
    }

    private function buyer_3():void {
        _onShowWindowCallback = null;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_ORDERS) {
//            (g.windowsManager.currentWindow as WOOrder).setTextForCustomer(String(g.managerLanguage.allTexts[533]));
//            var ob:Object = (g.windowsManager.currentWindow as WOOrder).getSellBtnProperties();
//            _arrow = new SimpleArrow(SimpleArrow.POSITION_LEFT, g.cont.popupCont);
//            _arrow.scaleIt(.5);
//            _arrow.animateAtPosition(ob.x, ob.y + 25);
//            _arrow.activateTimer(100, buyer_4);
        } else {
            Cc.error('wo_order is not opened');
        }
    }

    private function buyer_4():void {
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_ORDERS) {
//            (g.windowsManager.currentWindow as WOOrder).setTextForCustomer('');
        }
        _miniSceneCallback = null;
        deleteArrowAndDust();

    }

    public function onHideOrder():void {
        return;
        
        
        deleteArrowAndDust();
        if (isMiniScene && _curMiniScenePropertie && _curMiniScenePropertie.reason == BUY_ORDER) {
            isMiniScene = false;
        }
    }

    public function onBuyOrder():void {
        deleteArrowAndDust();
        if (g.user.miniScenes[1] == 0) {
            _miniSceneCallback = null;
            g.user.miniScenes[1] = 1;
            saveUserMiniScenesData();
            if (g.user.level == 3) {
                isMiniScene = true;
                _onHideWindowCallback = buyer_6;
            } else {
                isMiniScene = false;
            }
        }
    }

    private function buyer_6():void {
        _onHideWindowCallback = null;
        buyer_15();
    }

    private function buyer_15():void {
        if (g.user.miniScenes[1] == 0) {
            _miniSceneCallback = null;
            g.user.miniScenes[1] = 1;
            saveUserMiniScenesData();
        }
        isMiniScene = false;
        buildBulo4na();
    }

    private function buildBulo4na():void {
        return;
        
        
        deleteArrowAndDust();
        var ar:Array = g.townArea.getCityObjectsById(1);
        if (ar.length) {
            onPasteFabrica();
            return;
        }
        if (!g.allData.factory['tutorialCatBig']) {
            var st:String;
            if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) st = 'animations_json/cat_tutorial_small';
            else st = 'animations_json/cat_tutorial';
            g.loadAnimation.load(st, 'tutorialCatBig', buildBulo4na);
            return;
        }
        isMiniScene = true;
        _curMiniScenePropertie = _properties[2];
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curMiniScenePropertie.text, String(g.managerLanguage.allTexts[532]), bulo4na_1);
        addBlack();
    }

    private function bulo4na_1():void {
        removeBlack();
        _cutScene.hideIt(deleteCutScene);
        _miniSceneResourceIDs = [1];
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        g.bottomPanel.addArrow('shop');
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        _onShowWindowCallback = bulo4na_2;
    }

    private function bulo4na_2():void {
        deleteArrowAndDust();
        _onShowWindowCallback = null;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemBounds(_miniSceneResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height - 15);
            _arrow.activateTimer(3, deleteArrowAndDust);
        } else {
            Cc.error('miniScene:: wo_SHOP is not opened');
        }
    }

    public function onPasteFabrica(buildId:int=0):void {
        return;

        deleteArrowAndDust();
        _miniSceneResourceIDs = [];
        if (g.user.miniScenes[2] == 0) {
            g.user.miniScenes[2] = 1;
            saveUserMiniScenesData();
            isMiniScene = false;
        }
    }



    public function letsGoToNeighbor():void {
        if (g.user.level < 5) return;
        if (g.user.miniScenes[3] > 0) return;
        g.friendPanel.showIt();
        g.bottomPanel.friendBtnVisible(true);
        if (!g.allData.factory['tutorialCatBig']) {
            var st:String;
            if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) st = 'animations_json/cat_tutorial_small';
            else st = 'animations_json/cat_tutorial';
            g.loadAnimation.load(st, 'tutorialCatBig', letsGoToNeighbor);
            return;
        }
        isMiniScene = true;
        _curMiniScenePropertie = _properties[3];
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curMiniScenePropertie.text, String(g.managerLanguage.allTexts[532]), letGo_1);
        addBlack();
    }
    private function letGo_1():void {
        _cutScene.hideIt(deleteCutScene);
        removeBlack();
        var ob:Object = g.friendPanel.getNeighborItemProperties();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, g.cont.popupCont);
        _arrow.scaleIt(.8);
        _arrow.animateAtPosition(ob.x, ob.y);
        g.user.miniScenes[3] = 1;
        _miniSceneCallback = letGo_2;
        saveUserMiniScenesData();
    }
    private function letGo_2():void {
        deleteArrowAndDust();
        isMiniScene = false;
        _curMiniScenePropertie = null;
        _miniSceneCallback = null;
        g.server.getUserNeighborMarket(null);
    }

    public function onGoAwayToNeighbor():void {
        if (g.user.miniScenes[4] == 0 && g.isAway && g.user.level == 5) atNeighbor();
    }
    
    private function atNeighbor():void {
        if (!g.allData.factory['tutorialCatBig']) {
            var st:String;
            if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) st = 'animations_json/cat_tutorial_small';
            else st = 'animations_json/cat_tutorial';
            g.loadAnimation.load(st, 'tutorialCatBig', atNeighbor);
            return;
        }
        isMiniScene = true;
        _curMiniScenePropertie = _properties[4];
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curMiniScenePropertie.text, String(g.managerLanguage.allTexts[532]), atN_1);
        addBlack();
    }

    private function atN_1():void {
        _cutScene.hideIt(deleteCutScene);
        removeBlack();
        _miniSceneBuildings = g.townArea.getAwayCityObjectsById(44);
        (_miniSceneBuildings[0] as WorldObject).showArrow();
        g.cont.moveCenterToXY((_miniSceneBuildings[0] as Market).source.x-100, (_miniSceneBuildings[0] as Market).source.y, false, 1.5);
        g.user.miniScenes[4] = 1;
        isMiniScene = false;
        saveUserMiniScenesData();
    }

    public function atNeighborBuyInstrument():void {
        if (!g.isAway) return;
        Utils.createDelay(1,ins_0);
    }

    private function ins_0():void {
        if (g.user.miniScenes[5] == 0) {
            isMiniScene = true;
            _curMiniScenePropertie = _properties[5];
            if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_MARKET) {
                (g.windowsManager.currentWindow as WOMarket).babbleMiniScene(_curMiniScenePropertie.text);
                var ob:Object = (g.windowsManager.currentWindow as WOMarket).getItemPropertiesWithFirstInstrument();
                if (ob) {
                    ob.width += 50;
                    ob.height += 50;
                    _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
                    _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
                    _arrow.scaleIt(.5);
                    _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height);
                    _miniSceneCallback = ins_1;
                    _onHideWindowCallback = ins_2;
                } else {
                    Cc.error('atNeighborBuyInstrument:: wo_market is not opened');
                }
            } else {
                Cc.error('atNeighborBuyInstrument:: no MarketItem with INSTRUMENT');
                ins_2();
            }
        } else {
            ins_2();
        }
    }
    private function ins_1():void {
        deleteArrowAndDust();
        (g.windowsManager.currentWindow as WOMarket).removeBabbleMiniScene();
        (g.windowsManager.currentWindow as WOMarket).babbleMiniScene(_curMiniScenePropertie.text2);
    }

    private function ins_2():void {
        if (_airBubble) _airBubble.hideIt();
        removeBlack();
        _airBubble = null;
        g.user.miniScenes[3] = 1;
        g.user.miniScenes[4] = 1;
        g.user.miniScenes[5] = 1;
        isMiniScene = false;
        saveUserMiniScenesData();
        deleteArrowAndDust();
        isMiniScene = false;
        _miniSceneCallback = null;
        g.bottomPanel.addArrow('home');
        continueAfterNeighbor = 1;
    }

    public function finishLetGoToNeighbor():void {
        deleteArrowAndDust();
        isMiniScene = false;
        _curMiniScenePropertie = null;
        _miniSceneCallback = null;
    }

    public function onOrderGetFirstInstrument():void {
        if (g.user.miniScenes[6]>0) return;
        g.user.miniScenes[6] = 1;
        saveUserMiniScenesData();
        g.windowsManager.openWindow(WindowsManager.WO_ORDER_INSTRUMENT_INFO,null);
    }

    public function onDeadTree(tr:Tree):void {
        if (g.user.miniScenes[7] > 0) return;
        if (!g.allData.factory['tutorialCatBig']) {
            var st:String;
            if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) st = 'animations_json/cat_tutorial_small';
            else st = 'animations_json/cat_tutorial';
            g.loadAnimation.load(st, 'tutorialCatBig', onDeadTree, tr);
            return;
        }
        isMiniScene = true;
        _miniSceneBuildings = [tr];
        g.cont.moveCenterToPos((_miniSceneBuildings[0] as Tree).posX, (_miniSceneBuildings[0] as Tree).posY, false, .5, deadTree_1);
        _curMiniScenePropertie = _properties[7];
    }

    private function deadTree_1():void {
        if (!_cutScene) _cutScene = new CutScene();
        _cutScene.showIt(_curMiniScenePropertie.text, String(g.managerLanguage.allTexts[532]), deadTree_2);
        addBlack();
    }
    private function deadTree_2():void {
        _cutScene.hideIt(deleteCutScene);
        removeBlack();
        g.user.miniScenes[7] = 1;
        saveUserMiniScenesData();
        (_miniSceneBuildings[0] as Tree).showHintForDead();
        _miniSceneBuildings=[];
        _curMiniScenePropertie = null;
    }
}
}
