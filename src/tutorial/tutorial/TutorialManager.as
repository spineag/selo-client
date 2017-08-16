/**
 * Created by andy on 8/9/17.
 */
package tutorial.tutorial {
import additional.buyerNyashuk.BuyerNyashuk;
import additional.buyerNyashuk.ManagerBuyerNyashuk;

import build.WorldObject;
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.farm.Farm;
import build.ridge.Ridge;
import com.junkbyte.console.Cc;
import data.BuildType;
import flash.geom.Point;
import heroes.TutorialCat;
import mouse.ToolsModifier;
import particle.tuts.DustRectangle;
import tutorial.CutScene;
import tutorial.IManagerTutorial;
import tutorial.TutorialAction;
import utils.SimpleArrow;
import utils.Utils;
import windows.WindowsManager;
import windows.fabricaWindow.WOFabrica;
import windows.shop.WOShop;

public class TutorialManager extends IManagerTutorial{
    public function TutorialManager() {  super(); }

    override protected function initScenes():void {
        var curFunc:Function;
        _subStep = 0;
        _currentAction = TutorialAction.NONE;
//        try {
            Cc.info('init tutorial scene for step: ' + g.user.tutorialStep);
            switch (g.user.tutorialStep) {
                case 1: curFunc = initScene_1; break;
                case 2: curFunc = initScene_2; break;
                case 3: curFunc = initScene_3; break;
                case 4: curFunc = initScene_4; break;
                case 5: curFunc = initScene_5; break;
                case 6: curFunc = initScene_6; break;
                case 7: curFunc = initScene_7; break;
                case 8: curFunc = initScene_8; break;
                case 9: curFunc = initScene_9; break;
                case 10: curFunc = initScene_10; break;
                case 11: curFunc = initScene_11; break;
                case 12: curFunc = initScene_12; break;
                case 13: curFunc = initScene_13; break;
                case 14: curFunc = initScene_14; break;
                case 15: curFunc = initScene_15; break;
                case 16: curFunc = initScene_16; break;
                case 17: curFunc = initScene_17; break;

                default: Cc.error('unknown tuts step');
                    break;
            }
            if (curFunc != null) {
                curFunc.apply();
            }
            g.friendPanel.hideIt(true);
//        } catch (err:Error) {
//            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'tutorial');
//            Cc.error("Tutorial crashed at step #" + String(g.user.tutorialStep) + " and subStep #" + String(_subStep) + " with error message " + err.message);
//        }
    }

    private function initScene_1():void { // for mult or smth like that
        _subStep = 0;
        g.startPreloader.hideIt();
        g.startPreloader = null;
        g.user.tutorialStep = 2;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_2():void {
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TextsTutorial()).objText;
        var st:String = texts[g.user.tutorialStep][_subStep];
        if (g.user.name) {
            st = st.replace('user_name', g.user.name);
        } else {
            st = st.replace(' user_name', '');
        }
        cutScene.showIt(st, texts['next'], subStep2_1, .5);
        addBlack();
    }

    private function subStep2_1():void {
        _subStep = 2;
        cutScene.hideIt(deleteCutScene, initScenes);
        removeBlack();
        g.user.tutorialStep = 3;
        updateTutorialStep();
    }
    
    private function initScene_3():void {
        _subStep = 0;
        if (!texts) texts = (new TextsTutorial()).objText;
        if (!_cat) _cat = new TutorialCat();
        _tutorialObjects = [];
        var ar:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int=0; i<ar.length; i++) {
            if ((ar[i] as Ridge).isFreeRidge) continue;
            if ((ar[i] as Ridge).plant.dataPlant.id == 31) {
                _tutorialObjects.push(ar[i]);
            }
        }
        if (!_tutorialObjects.length) {
            subStep3_4();
            return;
        }
        g.windowsManager.openWindow(WindowsManager.WO_TUTORIAL, subStep3_1, texts[g.user.tutorialStep][_subStep]);
    }

    private function subStep3_1():void {
        _subStep = 1;
        _currentAction = TutorialAction.CRAFT_RIDGE;
        _cat.setPosition(new Point((_tutorialObjects[0] as Ridge).posX-2, (_tutorialObjects[0] as Ridge).posY+2));
        _cat.addToMap();
        _cat.flipIt(false);
        _cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        _cat.idleAnimation();
        subStep3_2();
    }

    private function subStep3_2():void {
        _subStep = 2;
        if (_tutorialObjects.length) {
            var r:Ridge = _tutorialObjects[0] as Ridge;
            g.cont.moveCenterToPos(r.posX, r.posY, false, .5);
            r.showArrow();
            r.tutorialCallback = subStep3_3;
        } else subStep3_4();
    }

    private function subStep3_3(r:Ridge):void {
        _tutorialObjects.removeAt(0);
        subStep3_2();
    }
    
    private function subStep3_4():void {
        _subStep = 4;
        _cat.hideBubble();
        _tutorialObjects = [];
        g.user.tutorialStep = 4;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_4():void {
        _subStep = 0;
        if (!texts) texts = (new TextsTutorial()).objText;
        if (!_cat) {
            _cat = new TutorialCat();
            _cat.addToMap();
        }
        _tutorialObjects = [];
        _tutorialResourceIDs = [31];
        _currentAction = TutorialAction.PLANT_RIDGE;
        var ar:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int=0; i<ar.length; i++) {
            if ((ar[i] as Ridge).isFreeRidge) {
                _tutorialObjects.push(ar[i]);
            }
        }
        if (!_tutorialObjects.length) {
            subStep4_4();
            return;
        }
        g.windowsManager.openWindow(WindowsManager.WO_TUTORIAL, subStep4_1, texts[g.user.tutorialStep][_subStep]);
    }

    private function subStep4_1():void {
        _subStep = 1;
        Utils.createDelay(.5, subStep4_2);
    }

    private function subStep4_2():void {
        if (_subStep == 1) {
            _cat.flipIt(false);
            _cat.showBubble(texts[g.user.tutorialStep][_subStep]);
            _cat.idleAnimation();
        }
        _subStep = 2;
        var r:Ridge = _tutorialObjects[0] as Ridge;
        g.cont.moveCenterToPos(r.posX, r.posY, false, .5);
        r.showArrow();
        r.tutorialCallback = subStep4_3;
    }

    private function subStep4_3(r:Ridge):void {
        r.hideArrow();
        _tutorialObjects.removeAt(0);
        if (_tutorialObjects.length) subStep4_2();
        else subStep4_4();
    }

    private function subStep4_4():void {
        _subStep = 4;
        _cat.hideBubble();
        _cat.flipIt(false);
        _tutorialObjects = [];
        g.user.tutorialStep = 5;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_5():void {
        _subStep = 0;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TextsTutorial()).objText;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['next'], subStep5_1, 0, 'tutorial_nyam');
        addBlack();
    }

    private function subStep5_1():void {
        removeBlack();
        _subStep = 1;
        g.user.tutorialStep = 6;
        updateTutorialStep();
        cutScene.hideIt(deleteCutScene, initScenes);
    }
    
    private function initScene_6():void {
        _subStep = 0;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TextsTutorial()).objText;
        _tutorialObjects = g.townArea.getCityObjectsByType(BuildType.FARM);
        g.cont.moveCenterToPos((_tutorialObjects[0] as Farm).posX, (_tutorialObjects[0] as Farm).posY, false, .5);
        if (!_cat) {
            _cat = new TutorialCat(initScene6_1);
            _cat.setPosition(new Point((_tutorialObjects[0] as Farm).posX + 5, (_tutorialObjects[0] as Farm).posY-1));
            _cat.addToMap();
        } else g.managerCats.goCatToPoint(_cat, new Point((_tutorialObjects[0] as Farm).posX + 5, (_tutorialObjects[0] as Farm).posY-1), initScene6_1);
    }

    private function initScene6_1():void {
        _subStep = 1;
        _cat.idleAnimation();
        _currentAction = TutorialAction.BUY_ANIMAL;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], 'Далее', subStep6_2, 0, '', 'main_panel_bt_shop');
        g.bottomPanel.tutorialCallback = subStep6_2;
        addBlackUnderInterface();
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
    }

    private function subStep6_2(fromShop:Boolean = false):void {
        _subStep = 2;
        deleteArrowAndDust();
        g.bottomPanel.tutorialCallback = null;
        cutScene.hideIt(deleteCutScene);
        _tutorialResourceIDs = [1];
        removeBlack();
        _onShowWindowCallback = subStep6_3;
        if (!fromShop) g.windowsManager.openWindow(WindowsManager.WO_SHOP, null, WOShop.ANIMAL);
    }

    private function subStep6_3():void {
        _subStep = 3;
        _onShowWindowCallback = null;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height - 15);
            _tutorialCallback = subStep6_4;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
    }

    private function subStep6_4():void {
        _subStep = 4;
        _tutorialCallback = null;
        _currentAction = TutorialAction.NONE;
        deleteArrowAndDust();
        Utils.createDelay(2, subStep6_5);
    }

    private function subStep6_5():void {
        _subStep = 5;
        g.user.tutorialStep = 7;
        _tutorialObjects = [];
        updateTutorialStep();
        initScenes();
    }

    private function initScene_7():void {
        _subStep = 0;
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
        arr = (arr[0] as Farm).arrAnimals;
        for (var i:int = 0; i<arr.length; i++) {
            if ((arr[i] as Animal).state == Animal.HUNGRY) {
                _tutorialObjects = [arr[i]];
            }
        }
        if (_tutorialObjects.length > 3) _tutorialObjects.length = 3;
        if (_tutorialObjects.length) {
            if (!_cat) {
                _cat = new TutorialCat( function ():void { _cat.idleAnimation(); });
                _cat.setPosition(new Point((_tutorialObjects[0] as Farm).posX + 4, (_tutorialObjects[0] as Farm).posY - 1));
                _cat.addToMap();
            }
            if (!cutScene) cutScene = new CutScene();
            if (!texts) texts = (new TextsTutorial()).objText;
            addBlack();
            cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['next'], subStep7_1);
        } else subStep7_4();
    }

    private function subStep7_1():void {
        _subStep = 1;
        _currentAction = TutorialAction.ANIMAL_FEED;
        cutScene.hideIt(deleteCutScene);
        removeBlack();
        subStep7_2();
    }

    private function subStep7_2():void {
        _subStep = 2;
        if (_tutorialObjects.length) {
            var an:Animal = (_tutorialObjects[0] as Animal);
            an.playDirectIdle();
            an.addArrow();
            an.tutorialCallback = subStep7_3;
        } else subStep7_4();
    }

    private function subStep7_3(chick:Animal):void {
        _subStep=3;
        chick.removeArrow();
        chick.tutorialCallback = null;
        _tutorialObjects.removeAt(0);
        subStep7_2();
    }

    private function subStep7_4():void {
        _subStep = 4;
        g.user.tutorialStep = 8;
        _tutorialObjects = [];
        updateTutorialStep();
        initScenes();
    }

    private function initScene_8():void {
        _subStep = 0;
        var arr:Array = g.townArea.getCityObjectsByType(BuildType.FARM);
        arr = (arr[0] as Farm).arrAnimals;
        for (var i:int = 0; i<arr.length; i++) {
            if ((arr[i] as Animal).state == Animal.WORK) {
                _tutorialObjects = [arr[i]];
            }
        }
        if (_tutorialObjects.length > 3) _tutorialObjects.length = 3;
        if (_tutorialObjects.length) {
            if (!_cat) {
                _cat = new TutorialCat(function ():void { _cat.idleAnimation(); });
                _cat.setPosition(new Point((_tutorialObjects[0] as Farm).posX + 4, (_tutorialObjects[0] as Farm).posY - 1));
                _cat.addToMap();
            }
            if (!cutScene) cutScene = new CutScene();
            if (!texts) texts = (new TextsTutorial()).objText;
            addBlack();
            cutScene.showIt(texts[g.user.tutorialStep][_subStep], texts['next'], subStep8_1);
        } else subStep8_4();
    }

    private function subStep8_1():void {
        _subStep = 1;
        removeBlack();
        cutScene.hideIt(deleteCutScene);
        subStep8_2();
    }

    private function subStep8_2():void {
        if (_tutorialObjects.length) {
            _currentAction = TutorialAction.ANIMAL_SKIP;
            var an:Animal = _tutorialObjects[0] as Animal;
            an.playDirectIdle();
            an.addArrow();
            an.tutorialCallback = subStep8_3;
        } else subStep8_4();
    }

    private function subStep8_3(ch:Animal):void {
        _currentAction = TutorialAction.NONE;
        if (g.timerHint) g.timerHint.managerHide();
        _subStep = 3;
        ch.removeArrow();
        ch.tutorialCallback = null;
        _tutorialObjects.removeAt(0);
        subStep8_2();
    }

    private function subStep8_4():void {
        _subStep = 4;
        g.user.tutorialStep = 9;
        _tutorialObjects = [];
        updateTutorialStep();
        initScenes();
    }
    
    private function initScene_9():void {
        _subStep = 0;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TextsTutorial()).objText;
        _tutorialResourceIDs = [1];
        _tutorialObjects = g.townArea.getCityObjectsById(_tutorialResourceIDs[0]);
        if (_tutorialObjects.length) {
            subStep9_4();
        } else {
            _currentAction = TutorialAction.BUY_FABRICA;
            addBlackUnderInterface();
            cutScene.showIt(texts[g.user.tutorialStep][_subStep], String(g.managerLanguage.allTexts[532]), subStep9_1, 0, '', 'main_panel_bt_shop');
            g.bottomPanel.tutorialCallback = subStep9_1;
            var ob:Object = g.bottomPanel.getShopButtonProperties();
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        }
    }

    private function subStep9_1(fromShop:Boolean = false):void {
        _subStep = 1;
        cutScene.hideIt(deleteCutScene);
        deleteArrowAndDust();
        g.bottomPanel.tutorialCallback = null;
        removeBlack();
        _subStep = 1;
        _onShowWindowCallback = subStep9_2;
        if (!fromShop) g.windowsManager.openWindow(WindowsManager.WO_SHOP, null, WOShop.FABRICA);
    }

    private function subStep9_2():void {
        _subStep = 2;
        _onShowWindowCallback = null;
        _currentAction = TutorialAction.BUY_FABRICA;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height - 15);
            _tutorialCallback = subStep9_3;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
    }

    private function subStep9_3():void {
        _subStep = 3;
        deleteArrowAndDust();
        _currentAction = TutorialAction.PUT_FABRICA;
        _tutorialCallback = subStep9_4;
    }

    private function subStep9_4():void {
        _subStep = 4;
        g.user.tutorialStep = 10;
        _tutorialObjects = [];
        updateTutorialStep();
        initScenes();
    }

    private function initScene_10():void {
        _subStep = 0;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TextsTutorial()).objText;
        _tutorialResourceIDs = [1];
        _tutorialObjects = g.townArea.getCityObjectsById(_tutorialResourceIDs[0]);
        if ((_tutorialObjects[0] as Fabrica).stateBuild == WorldObject.STATE_BUILD) {
            g.cont.moveCenterToPos((_tutorialObjects[0] as Fabrica).posX, (_tutorialObjects[0] as Fabrica).posY, false, 1);
            if (!_cat) {
                _cat = new TutorialCat(subStep10_1);
                _cat.setPosition(new Point((_tutorialObjects[0] as Fabrica).posX - 1, (_tutorialObjects[0] as Fabrica).posY + 4));
                _cat.addToMap();
            } else g.managerCats.goCatToPoint(_cat, new Point((_tutorialObjects[0] as Fabrica).posX + 4, (_tutorialObjects[0] as Fabrica).posY - 1), subStep10_1);
        } else subStep10_4();
    }

    private function subStep10_1():void {
        _subStep = 1;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], String(g.managerLanguage.allTexts[532]), subStep10_2);
    }

    private function subStep10_2():void {
        _subStep = 2;
        removeBlack();
        cutScene.hideIt(deleteCutScene);
        _currentAction = TutorialAction.FABRICA_SKIP_FOUNDATION;
        (_tutorialObjects[0] as Fabrica).showArrow();
        _tutorialCallback = subStep10_3;
    }

    private function subStep10_3():void {
        _subStep = 3;
        (_tutorialObjects[0] as Fabrica).hideArrow();
        _tutorialCallback = subStep10_4;
    }

    private function subStep10_4():void {
        _currentAction = TutorialAction.NONE;
        _subStep = 4;
        g.user.tutorialStep = 11;
        _tutorialObjects = [];
        updateTutorialStep();
        initScenes();
    }

    private function initScene_11():void {
        _subStep = 0;
        if (!texts) texts = (new TextsTutorial()).objText;
        _tutorialResourceIDs = [1];
        _tutorialObjects = g.townArea.getCityObjectsById(_tutorialResourceIDs[0]);
        if ((_tutorialObjects[0] as Fabrica).stateBuild == WorldObject.STATE_WAIT_ACTIVATE) {
            g.cont.moveCenterToPos((_tutorialObjects[0] as Fabrica).posX, (_tutorialObjects[0] as Fabrica).posY, false, 1);
            if (!_cat) {
                _cat = new TutorialCat(subStep11_1);
                _cat.setPosition(new Point((_tutorialObjects[0] as Fabrica).posX - 1, (_tutorialObjects[0] as Fabrica).posY + 4));
                _cat.addToMap();
            } else subStep11_1();
        } else subStep11_3();
    }

    private function subStep11_1():void {
        _subStep = 1;
        _currentAction = TutorialAction.PUT_FABRICA;
        g.cont.moveCenterToPos((_tutorialObjects[0] as Fabrica).posX, (_tutorialObjects[0] as Fabrica).posY, false, 1);
        _cat.flipIt(false);
        _cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        (_tutorialObjects[0] as Fabrica).showArrow();
        _tutorialCallback = subStep11_2;
    }

    private function subStep11_2():void {
        (_tutorialObjects[0] as Fabrica).hideArrow();
        _cat.hideBubble();
        subStep11_3();
    }

    private function subStep11_3():void {
        _currentAction = TutorialAction.NONE;
        _subStep = 4;
        g.user.tutorialStep = 12;
        _tutorialObjects = [];
        updateTutorialStep();
        initScenes();
    }

    private function initScene_12():void {
        _subStep = 0;
        _tutorialResourceIDs = [1];
        _tutorialObjects = g.townArea.getCityObjectsById(_tutorialResourceIDs[0]);
        if ((_tutorialObjects[0] as Fabrica).isAnyCrafted) {
            subStep12_4();
        } else {
            if (!cutScene) cutScene = new CutScene();
            if (!texts) texts = (new TextsTutorial()).objText;
            addBlack();
            cutScene.showIt(texts[g.user.tutorialStep][_subStep], String(g.managerLanguage.allTexts[532]), subStep12_1);
            if (!_cat) {
                _cat = new TutorialCat();
                _cat.setPosition(new Point((_tutorialObjects[0] as Fabrica).posX - 1, (_tutorialObjects[0] as Fabrica).posY + 4));
                _cat.addToMap();
            }
        }
    }

    private function subStep12_1():void {
        _subStep = 1;
        removeBlack();
        cutScene.hideIt(deleteCutScene);
        _cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        _currentAction = TutorialAction.RAW_RECIPE;
        _tutorialResourceIDs = [6]; // recipeId
        g.cont.moveCenterToPos((_tutorialObjects[0] as Fabrica).posX, (_tutorialObjects[0] as Fabrica).posY, false, 1);
        (_tutorialObjects[0] as Fabrica).showArrow();
        _tutorialCallback = subStep12_2;
    }

    private function subStep12_2():void {
        _subStep = 2;
        (_tutorialObjects[0] as Fabrica).hideArrow();
        _cat.hideBubble();
        _tutorialCallback = subStep12_3;
    }

    private function subStep12_3():void {
        _subStep = 3;
        _currentAction = TutorialAction.FABRICA_SKIP_RECIPE;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_FABRICA) {
            var ob:Object = (g.windowsManager.currentWindow as WOFabrica).getSkipBtnProperties();
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_LEFT, g.cont.popupCont);
            _arrow.scaleIt(.8);
            _arrow.animateAtPosition(ob.x, ob.y + ob.height/2);
            _tutorialCallback = function ():void { Utils.createDelay(.7, subStep12_4); };
        } else {
            Cc.error('tuts:: WO_fabrica is not opened');
        }
    }

    private function subStep12_4():void {
        deleteArrowAndDust();
        g.windowsManager.closeAllWindows();
        _currentAction = TutorialAction.NONE;
        _subStep = 4;
        g.user.tutorialStep = 13;
        _tutorialObjects = [];
        updateTutorialStep();
        initScenes();
    }

    private function initScene_13():void {
        _subStep = 0;
        g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TextsTutorial()).objText;
        _tutorialResourceIDs = [3];
        _tutorialObjects = g.townArea.getCityObjectsById(_tutorialResourceIDs[0]);
        if (_tutorialObjects.length) {
            subStep13_4();
        } else {
            _currentAction = TutorialAction.BUY_FABRICA;
            addBlackUnderInterface();
            cutScene.showIt(texts[g.user.tutorialStep][_subStep], String(g.managerLanguage.allTexts[532]), subStep9_1, 0, '', 'main_panel_bt_shop');
            g.bottomPanel.tutorialCallback = subStep13_1;
            var ob:Object = g.bottomPanel.getShopButtonProperties();
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        }
    }

    private function subStep13_1(fromShop:Boolean = false):void {
        _subStep = 1;
        cutScene.hideIt(deleteCutScene);
        deleteArrowAndDust();
        g.bottomPanel.tutorialCallback = null;
        removeBlack();
        _subStep = 1;
        _onShowWindowCallback = subStep13_2;
        if (!fromShop) g.windowsManager.openWindow(WindowsManager.WO_SHOP, null, WOShop.FABRICA);
    }

    private function subStep13_2():void {
        _subStep = 2;
        _onShowWindowCallback = null;
        _currentAction = TutorialAction.BUY_FABRICA;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height - 15);
            _tutorialCallback = subStep13_3;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
    }

    private function subStep13_3():void {
        _subStep = 3;
        deleteArrowAndDust();
        _tutorialCallback = subStep9_4;
    }

    private function subStep13_4():void {
        _subStep = 4;
        g.user.tutorialStep = 14;
        _tutorialObjects = [];
        updateTutorialStep();
        initScenes();
    }

    private function initScene_14():void {
        _subStep=0;
        _currentAction = TutorialAction.NEW_RIDGE;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TextsTutorial()).objText;
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], String(g.managerLanguage.allTexts[532]), subStep14_2, 0, '', 'main_panel_bt_shop');
        addBlackUnderInterface();
        var ob:Object = g.bottomPanel.getShopButtonProperties();
        _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
        g.bottomPanel.tutorialCallback = subStep14_2;
    }

    private function subStep14_2(fromShop:Boolean = false):void {
        _subStep = 2; //  need for shop == 2
        g.bottomPanel.tutorialCallback = null;
        cutScene.hideIt(deleteCutScene);
        deleteArrowAndDust();
        _tutorialResourceIDs = [11];
        removeBlack();
        _onShowWindowCallback = subStep14_3;
        if (!fromShop) g.windowsManager.openWindow(WindowsManager.WO_SHOP, null, WOShop.VILLAGE);
    }

    private function subStep14_3():void {
        _subStep = 3;
        _onShowWindowCallback = null;
        _tutorialObjects.length = 0;
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_SHOP) {
            var ob:Object = (g.windowsManager.currentWindow as WOShop).getShopItemProperties(_tutorialResourceIDs[0]);
            _dustRectangle = new DustRectangle(g.cont.popupCont, ob.width, ob.height, ob.x, ob.y);
            _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, g.cont.popupCont);
            _arrow.scaleIt(.7);
            _arrow.animateAtPosition(ob.x + ob.width/2, ob.y + ob.height - 15);
            _tutorialCallback = subStep14_4;
        } else {
            Cc.error('wo_SHOP is not opened');
        }
    }

    private function subStep14_4():void {
        _subStep = 4;
        deleteArrowAndDust();
        _tutorialCallback = subStep14_5;
    }

    private function subStep14_5():void {
        _subStep = 5;
        var ar:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        if (ar.length >= 9) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            subStep14_6();
        }
    }

    private function subStep14_6():void {
        _subStep = 6;
        g.user.tutorialStep = 15;
        _tutorialObjects = [];
        updateTutorialStep();
        initScenes();
    }

    private function initScene_15():void {
        _subStep = 0;
        if (!texts) texts = (new TextsTutorial()).objText;
        if (!_cat) {
            _cat = new TutorialCat();
            _cat.addToMap();
        }
        _tutorialObjects = [];
        var ar:Array = g.townArea.getCityObjectsByType(BuildType.RIDGE);
        for (var i:int=ar.length-1; i<=0; i--) {
            if ((ar[i] as Ridge).isFreeRidge) {
                _tutorialObjects.push(ar[i]);
            }
        }
        if (!_tutorialObjects.length) {
            subStep15_4();
            return;
        }
        if (_tutorialObjects.length > 3) _tutorialObjects.length = 3;
        g.windowsManager.openWindow(WindowsManager.WO_TUTORIAL, subStep15_1, texts[g.user.tutorialStep][_subStep]);
    }

    private function subStep15_1():void {
        _subStep = 1;
        _currentAction = TutorialAction.PLANT_RIDGE;
        Utils.createDelay(1, subStep15_2);
    }

    private function subStep15_2():void {
        if (_tutorialObjects.length) {
            _subStep = 2;
            var r:Ridge = _tutorialObjects[0] as Ridge;
            g.cont.moveCenterToPos(r.posX, r.posY, false, .5);
            r.showArrow();
            r.tutorialCallback = subStep15_3;
        }
    }

    private function subStep15_3(r:Ridge):void {
        r.hideArrow();
        _tutorialObjects.removeAt(0);
        subStep15_4();
    }

    private function subStep15_4():void {
        _subStep = 4;
        _cat.hideBubble();
        _cat.flipIt(false);
        _tutorialObjects = [];
        g.user.tutorialStep = 16;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_16():void {
        _subStep = 0;
        if (!g.managerBuyerNyashuk) g.managerBuyerNyashuk = new ManagerBuyerNyashuk();
        g.managerBuyerNyashuk.addNyashuksOnTutorial();
        Utils.createDelay(1, subStep16_1);
    }

    private function subStep16_1():void {
        if (!texts) texts = (new TextsTutorial()).objText;
        _tutorialObjects = g.managerBuyerNyashuk.arrNyashuk;
        _currentAction = TutorialAction.NYASHIK;
        g.cont.moveCenterToPos((_tutorialObjects[0] as BuyerNyashuk).posX, (_tutorialObjects[0] as BuyerNyashuk).posY, false, 1);
        if (!_cat) {
            _cat = new TutorialCat(subStep16_2);
            _cat.setPosition(new Point((_tutorialObjects[0] as BuyerNyashuk).posX - 1, (_tutorialObjects[0] as BuyerNyashuk).posY + 1));
            _cat.addToMap();
        } else g.managerCats.goCatToPoint(_cat, new Point((_tutorialObjects[0] as BuyerNyashuk).posX - 2, (_tutorialObjects[0] as BuyerNyashuk).posY + 1), subStep16_2);
    }

    private function subStep16_2():void {
        _subStep = 2;
        _cat.flipIt(false);
        _cat.idleAnimation();
        _cat.showBubble(texts[g.user.tutorialStep][_subStep]);
        (_tutorialObjects[0] as BuyerNyashuk).addArrow();
        (_tutorialObjects[1] as BuyerNyashuk).addArrow();
        _tutorialCallback = subStep16_3;
    }

    private function subStep16_3():void {
        _subStep = 4;
        (_tutorialObjects[0] as BuyerNyashuk).removeArrow();
        (_tutorialObjects[1] as BuyerNyashuk).removeArrow();
        _cat.hideBubble();
        _cat.flipIt(false);
        _tutorialCallback = subStep16_4;
    }

    private function subStep16_4():void {
        _subStep = 4;
        _tutorialObjects = [];
        g.user.tutorialStep = 17;
        updateTutorialStep();
        initScenes();
    }

    private function initScene_17():void {
        _subStep = 0;
        if (!cutScene) cutScene = new CutScene();
        if (!texts) texts = (new TextsTutorial()).objText;
        addBlack();
        cutScene.showIt(texts[g.user.tutorialStep][_subStep], String(g.managerLanguage.allTexts[532]), subStep17_1);
    }
    
    private function subStep17_1():void {
        removeBlack();
        cutScene.hideIt(deleteCutScene);
        finishTutorial();
    }


    override public function onResize():void {
        Cc.info('tuts: onResize with _subStep: ' + _subStep);
        if (black) {
            removeBlack();
            addBlack();
        }
        if (cutScene) cutScene.onResize();
    }

}
}
