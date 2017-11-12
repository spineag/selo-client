/**
 * Created by andy on 9/19/17.
 */
package windows.orderWindow {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;

import flash.geom.Point;

import manager.ManagerFilters;

import media.SoundConst;

import order.ManagerOrder;
import order.OrderItemStructure;

import quest.ManagerQuest;

import resourceItem.DropItem;
import resourceItem.DropPartyResource;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;

import tutorial.TutsAction;

import resourceItem.xp.XPStar;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;
import utils.TimeUtils;
import utils.Utils;

import windows.WOComponents.BackgroundWhiteIn;
import windows.WOComponents.WindowBackgroundNew;
import windows.WOComponents.BackgroundYellowOut;
import windows.WindowMain;
import windows.WindowsManager;

public class WOOrderNew extends WindowMain {
    private var _txtWindowName:CTextField;
    private var _bigYellowBG:BackgroundYellowOut;
    private var _arrOrders:Array;
    private var _arrItems:Array;
    private var _arrResourceItems:Array;
    private var _bgWhiteIn:BackgroundWhiteIn;
    private var _rightBlock:Sprite;
    private var _btnDel:CButton;
    private var _btnSell:CButton;
    private var _txtNagrada:CTextField;
    private var _sensCoin:SensibleBlock;
    private var _sensXP:SensibleBlock;
    private var _waitForAnswer:Boolean;
    private var _activeOrderItem:WOOrderItem;
    private var _clickItem:Boolean;
    private var _btnSkipDelete:CButton;
    private var _rightBlockTimer:Sprite;
    private var _txtTimer:CTextField;
    private var _txtZakazState:CTextField;
    private var _txtBtnSkip:CTextField;
    private var _txtBtnSkipCost:CTextField;
    private var _txtInfo:CTextField;

    public function WOOrderNew() {
        _windowType = WindowsManager.WO_ORDERS;
        _woWidth = 780;
        _woHeight = 680;

        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 114);
        _source.addChild(_woBGNew);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        _bigYellowBG = new BackgroundYellowOut(738, 524);
        _bigYellowBG.x = -369;
        _bigYellowBG.y = -_woHeight / 2 + 129;
        _source.addChild(_bigYellowBG);

        _txtWindowName = new CTextField(300, 70, g.managerLanguage.allTexts[362]);
        _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtWindowName.x = -150;
        _txtWindowName.y = -_woHeight / 2 + 25;
        _txtWindowName.letterSpacing = 20;
        _source.addChild(_txtWindowName);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('order_small_bg'));
        im.x = -_woWidth / 2 + 412;
        im.y = -_woHeight / 2 + 131;
        im.touchable = false;
        _source.addChild(im);

        createItems();
        createRightBlock();
        createRightBlockTimer();
    }

    override public function showItParams(callback:Function, params:Array):void {
        _arrOrders = g.managerOrder.arrOrders.slice();
        if (!_arrOrders.length) {
            Cc.error('WOOrder:: no any order');
            return;
        }
        fillList();
        var num:int;
        var delay:int;
        for (var i:int = 0; i < _arrOrders.length; i++) {
            delay = 0;
            num = 0;
            for (var k:int = 0; k<_arrOrders[i].resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(_arrOrders[i].resourceIds[k]) >= _arrOrders[i].resourceCounts[k]) num++;
            }
            if (num == _arrOrders[i].resourceIds.length) break;
            else delay++;
        }
        if (delay > 0) i = 0;
        onItemClick(_arrItems[i]);
        _waitForAnswer = false;
        super.showIt();
    }

    private function onClickExit(e:Event=null):void {
        if (g.tuts.isTuts) return;
        g.miniScenes.onHideOrder();
        super.hideIt();
    }

    private function createItems():void {
        var item:WOOrderItem;
        _arrItems = [];
        for (var i:int = 0; i < 9; i++) {
            item = new WOOrderItem(this);
            item.source.x = -_woWidth / 2 + 101 + (i % 3) * 120;
            item.source.y = -_woHeight / 2 + 225 + int(i / 3) * 155;
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    private function createRightBlock():void {
        var item:WOOrderResourceItem;
        _rightBlock = new Sprite();
        _source.addChild(_rightBlock);
        _bgWhiteIn = new BackgroundWhiteIn(338, 234);
        _bgWhiteIn.x = -_woWidth / 2 + 410;
        _bgWhiteIn.y = -_woHeight / 2 + 366;
        _rightBlock.addChild(_bgWhiteIn);

        _arrResourceItems = [];
        for (var i:int = 0; i < 6; i++) {
            item = new WOOrderResourceItem();
            item.source.x = -_woWidth / 2 + 465 + (i % 3) * 108;
            item.source.y = -_woHeight / 2 + 410 + int(i / 3) * 90;
            _rightBlock.addChild(item.source);
            _arrResourceItems.push(item);
        }

        _txtNagrada = new CTextField(150, 50, String(g.managerLanguage.allTexts[363]));
        _txtNagrada.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtNagrada.alignH = Align.LEFT;
        _txtNagrada.x = -_woWidth / 2 + 430;
        _txtNagrada.y = -_woHeight / 2 + 544;
        _rightBlock.addChild(_txtNagrada);

        var t:CTextField = new CTextField(60, 30, '8888');
        t.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        MCScaler.scale(im, 30, 30);
        _sensCoin = new SensibleBlock();
        _sensCoin.imageAndText(im, t, 95, 5);
        _sensCoin.x = -_woWidth / 2 + 540;
        _sensCoin.y = -_woWidth / 2 + 607;
        _rightBlock.addChild(_sensCoin);
        t = new CTextField(60, 30, '8888');
        t.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('xp_icon'));
        MCScaler.scale(im, 40, 40);
        im.y = -3;
        _sensXP = new SensibleBlock();
        _sensXP.imageAndText(im, t, 95, 5);
        _sensXP.x = -_woWidth / 2 + 633;
        _sensXP.y = -_woWidth / 2 + 607;
        _rightBlock.addChild(_sensXP);

        _btnSell = new CButton();
        _btnSell.addButtonTexture(144, CButton.HEIGHT_41, CButton.GREEN, true);
        _btnSell.x = -_woWidth / 2 + 609;
        _btnSell.y = -_woHeight / 2 + 628;
        _btnSell.addTextField(144, 35, 0, 0, g.managerLanguage.allTexts[366]);
        _btnSell.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btnSell.clickCallback = sellOrder;
        _rightBlock.addChild(_btnSell);

        _btnDel = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('trash'));
        im.alignPivot();
        _btnDel.addDisplayObject(im);
        _btnDel.x = -_woWidth / 2 + 500;
        _btnDel.y = -_woHeight / 2 + 628;
        _btnDel.clickCallback = deleteOrder;
        _rightBlock.addChild(_btnDel);
    }

    private function createRightBlockTimer():void {
        _rightBlockTimer = new Sprite();
        _source.addChild(_rightBlockTimer);
        _rightBlockTimer.visible = false;

        _txtZakazState = new CTextField(338, 30, String(g.managerLanguage.allTexts[369]));
        _txtZakazState.setFormat(CTextField.BOLD30, 30, ManagerFilters.WINDOW_STROKE_BLUE_COLOR, Color.WHITE);
        _txtZakazState.x = -_woWidth / 2 + 410;
        _txtZakazState.y = -_woHeight / 2 + 380;
        _rightBlockTimer.addChild(_txtZakazState);

        _txtInfo = new CTextField(338, 30, String(g.managerLanguage.allTexts[371]));
        _txtInfo.setFormat(CTextField.BOLD24, 24, ManagerFilters.WINDOW_STROKE_BLUE_COLOR, Color.WHITE);
        _txtInfo.x = -_woWidth / 2 + 410;
        _txtInfo.y = -_woHeight / 2 + 415;
        _rightBlockTimer.addChild(_txtInfo);

        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('clock'));
        im.x = -_woWidth/2 + 495;
        im.y = -_woHeight/2 + 465;
        _rightBlockTimer.addChild(im);

        _txtTimer = new CTextField(120, 100, "00:00:00");
        _txtTimer.setFormat(CTextField.BOLD30, 30, ManagerFilters.WINDOW_STROKE_BLUE_COLOR, Color.WHITE);
        _txtTimer.alignH = Align.LEFT;
        _txtTimer.x = -_woWidth / 2 + 555;
        _txtTimer.y = -_woHeight / 2 + 440;
        _rightBlockTimer.addChild(_txtTimer);

        _btnSkipDelete = new CButton();
        _btnSkipDelete.addButtonTexture(200, CButton.HEIGHT_55, CButton.GREEN, true);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
        MCScaler.scale(im, 30, 30);
        im.x = 165;
        im.y = 10;
        _btnSkipDelete.addDisplayObject(im);
        _txtBtnSkip = new CTextField(150, 50, String(g.managerLanguage.allTexts[367]));
        _txtBtnSkip.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtBtnSkip.x = 5;
        _btnSkipDelete.addChild(_txtBtnSkip);
        _txtBtnSkipCost = new CTextField(40, 50, String(ManagerOrder.COST_SKIP_WAIT));
        _txtBtnSkipCost.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _txtBtnSkipCost.alignH = Align.RIGHT;
        _txtBtnSkipCost.x = 120;
        _btnSkipDelete.addChild(_txtBtnSkipCost);
        _btnSkipDelete.x = -_woWidth / 2 + 580;
        _btnSkipDelete.y = -_woHeight / 2 + 564;
        _rightBlockTimer.addChild(_btnSkipDelete);
        _btnSkipDelete.clickCallback = skipDelete;
    }

    private function fillList():void {
        var maxCount:int = g.managerOrder.maxCountOrders;
        var or:OrderItemStructure;
        for (var i:int = 0; i < _arrOrders.length; i++) {
            if (i >= maxCount) return;
            or = _arrOrders[i];
            if (or.placeNumber > -1) (_arrItems[i] as WOOrderItem).fillIt(or, or.placeNumber, onItemClick);
                else Cc.error('WOOrder fillList:: order.placeNumber == -1');
        }
    }

    private function onItemClick(item:WOOrderItem, recheck:int = -1):void {
        if (_waitForAnswer) return;
        if (_activeOrderItem) _activeOrderItem.activateIt(false);
        if (recheck > -1 && _activeOrderItem != item) return;
        clearResourceItems();
        _clickItem = true;
        _activeOrderItem = item;
        fillResourceItems(_activeOrderItem.getOrder());
        _activeOrderItem.activateIt(true);

        if (_activeOrderItem.leftSeconds > 0) {
            _rightBlock.visible = false;
            _rightBlockTimer.visible = true;
            _btnSkipDelete.visible = true;
            if (_activeOrderItem.leftSeconds <= 5) _btnSkipDelete.visible = false;
            g.gameDispatcher.addToTimer(onTimer);
            setTimerText = _activeOrderItem.leftSeconds;
        } else {
            _rightBlock.visible = true;
            _rightBlockTimer.visible = false;
            g.gameDispatcher.removeFromTimer(onTimer);
        }

        if (_arrOrders && _arrOrders[item.position -1].delOb == true) _txtZakazState.text = String(g.managerLanguage.allTexts[369]);
        else _txtZakazState.text = String(g.managerLanguage.allTexts[368]);
    }

    private function fillResourceItems(or:OrderItemStructure):void {
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level)
            _sensXP.updateText(String(or.xp * g.managerParty.coefficient));
            else _sensXP.updateText(String(or.xp));
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level)
            _sensCoin.updateText(String(or.coins * g.managerParty.coefficient));
            else _sensCoin.updateText(String(or.coins));
        for (var i:int = 0; i < or.resourceIds.length; i++) {
            (_arrResourceItems[i] as WOOrderResourceItem).fillIt(or.resourceIds[i], or.resourceCounts[i]);
        }
    }

    private function clearResourceItems():void {
        for (var i:int=0; i<_arrResourceItems.length; i++) {
            _arrResourceItems[i].clearIt();
        }
        _sensXP.updateText('');
        _sensCoin.updateText('');
    }

    private function skipDelete():void {
        if (g.tuts.isTuts || g.managerCutScenes.isCutScene) return;
        var n:int = ManagerOrder.COST_SKIP_WAIT;
        if (g.user.hardCurrency < n) {
            isCashed = false;
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        _activeOrderItem.onSkipTimer();
        g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -n);
        _btnSkipDelete.visible = false;
    }


    private function onTimer():void {
        if (_activeOrderItem.leftSeconds > 0) {
            setTimerText = _activeOrderItem.leftSeconds;
        } else {
            _rightBlock.visible = true;
            _rightBlockTimer.visible = false;
            g.gameDispatcher.removeFromTimer(onTimer);
            setTimerText = 0;
        }
    }

    public function timerSkip(or:OrderItemStructure):void {
        var pl:int = or.placeNumber;
        for (var i:int = 0; i<_arrOrders.length; i++) {
            if (_arrOrders[i].placeNumber == pl &&  _arrOrders[i].delOb) {
                _arrOrders[i].delOb = false;
                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(null,_arrOrders[i].catOb);
                break;
            }
        }
    }

    private function set setTimerText(c:int):void { _txtTimer.text = TimeUtils.convertSecondsForOrders(c); }

    private function sellOrder(b:Boolean = false, or:OrderItemStructure = null):void {
        if (_waitForAnswer) return;
        if (g.tuts.isTuts && g.tuts.action != TutsAction.ORDER) return;
        if (!or) or = _activeOrderItem.getOrder();
        var i:int;
        if (!b) {
            for (i = 0; i < or.resourceIds.length; i++) {
                if (!(_arrResourceItems[i] as WOOrderResourceItem).isChecked()) {
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, sellOrder, 'order', or);
                    return;
                }
            }
            for (i = 0; i < _activeOrderItem.getOrder().resourceIds.length; i++) {
                if (or.resourceCounts[i] == g.userInventory.getCountResourceById(or.resourceIds[i])
                        && g.allData.getResourceById(or.resourceIds[i]).buildType == BuildType.PLANT && !g.userInventory.checkLastResource(or.resourceIds[i])) {
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, sellOrder, or, 'order');
                    return;
                }
            }
        } else {
            if (!_isShowed) super.showIt();
            for (i=0; i< _arrItems.length; i++) {
                if (_arrItems[i].getOrder().dbId == or.dbId) {
                    onItemClick(_arrItems[i]);
                    break;
                }
            }
        }
        for (i=0; i<_activeOrderItem.getOrder().resourceIds.length; i++) {
            g.userInventory.addResource(or.resourceIds[i], -or.resourceCounts[i]);
        }
        var prise:Object = {};
        var p1:Point = new Point(134, 147);
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level) {
            if (b) _clickItem = true;
            p1 = _source.localToGlobal(p1);
            new XPStar(p1.x, p1.y, or.xp * g.managerParty.coefficient);
        } else {
            if (b) _clickItem = true; 
            p1 = _source.localToGlobal(p1);
            new XPStar(p1.x, p1.y, or.xp);
        }
        var p2:Point = new Point(186, 147);
        prise.id = DataMoney.SOFT_CURRENCY;
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.ORDER && g.managerParty.levelToStart <= g.user.level) 
            prise.count = or.coins * g.managerParty.coefficient;
            else prise.count = or.coins;
        if (b) _clickItem = true;
            p2 = _source.localToGlobal(p2);
            new DropItem(p2.x, p2.y, prise);
        if (g.managerParty.eventOn && (g.managerParty.typeParty == 3 || g.managerParty.typeParty == 5) && g.managerParty.typeBuilding == BuildType.ORDER && g.allData.atlas['partyAtlas'] && g.managerParty.levelToStart <= g.user.level) 
                new DropPartyResource(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
            else if (g.managerParty.eventOn && g.managerParty.typeParty == 5 && g.allData.atlas['partyAtlas'] && g.managerParty.levelToStart <= g.user.level) 
                new DropPartyResource(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);

        _waitForAnswer = true;
        _txtZakazState.text = String(g.managerLanguage.allTexts[368]);
        var tOrderItem:WOOrderItem = _activeOrderItem;
        var f:Function = function (ord:OrderItemStructure):void { afterSell(ord, tOrderItem); };
        _arrOrders[_activeOrderItem.position] = null;
        g.managerOrder.sellOrder(or, f);
        g.managerOrder.cancelAnimateSmallHero();
        g.soundManager.playSound(SoundConst.ORDER_DONE);
        if (g.tuts.isTuts && g.tuts.action == TutsAction.ORDER) g.tuts.checkTutsCallback();
            else g.miniScenes.onBuyOrder();
        g.managerQuest.onActionForTaskType(ManagerQuest.RELEASE_ORDER);
    }

import order.OrderItemStructure;

import windows.orderWindow.WOOrderItem;

private function afterSell(or:OrderItemStructure, orderItem:WOOrderItem):void {
        _waitForAnswer = false;
        if (_isShowed) {
            or.startTime = TimeUtils.currentSeconds + 6;
            orderItem.fillIt(or, or.placeNumber, onItemClick);
            _arrOrders[or.placeNumber] = or;
            if (_activeOrderItem == orderItem) {
                onItemClick(_activeOrderItem);
                _clickItem = false;
            }
        }
        updateItemsCheck();
    }

    private function updateItemsCheck():void {
        for (var i:int = 0; i < _arrItems.length; i++) {
            if (_arrItems[i]) (_arrItems[i] as WOOrderItem).updateCheck();
        }
    }

    private function deleteOrder():void {
        if (g.tuts.isTuts || g.managerCutScenes.isCutScene) return;
        if (_activeOrderItem) {
            g.hint.hideIt();
            _rightBlock.visible = false;
            _txtZakazState.text = String(g.managerLanguage.allTexts[369]);
            _rightBlockTimer.visible = true;
            setTimerText = g.managerOrder.delayBeforeNextOrder;
            _waitForAnswer = true;
            _arrOrders[_activeOrderItem.position] = null;
            var tOrderItem:WOOrderItem = _activeOrderItem;
            var f:Function = function (or:OrderItemStructure):void { afterDeleteOrder(or, tOrderItem); };
            g.managerOrder.deleteOrder(_activeOrderItem.getOrder(), f);
        }
    }

    private function afterDeleteOrder(or:OrderItemStructure, orderItem:WOOrderItem):void {
        if (_isShowed) {
            var d:int = g.managerOrder.delayBeforeNextOrder;
            or.startTime += d;
            _waitForAnswer = false;
            setTimerText = d;
            var b:Boolean = true;
            for (var k:int=0; k<or.resourceIds.length; k++) {
                if (g.userInventory.getCountResourceById(or.resourceIds[k]) < or.resourceCounts[k]) {
                    b = false;
                    break;
                }
            }
            orderItem.fillIt(or, or.placeNumber, onItemClick);
            _arrOrders[or.placeNumber] = or;
            if (_activeOrderItem == orderItem) onItemClick(_activeOrderItem);
            g.managerOrder.checkForFullOrder();
            g.gameDispatcher.addToTimer(onTimer);
        }
    }

    override protected function deleteIt():void {
        if (!_source) return;
        _activeOrderItem = null;
        g.gameDispatcher.removeFromTimer(onTimer);
        _source.removeChild(_txtWindowName);
        _txtWindowName.deleteIt();
        _arrOrders.length = 0;
        for (var i:int=0; i<_arrResourceItems.length; i++) {
            _rightBlock.removeChild(_arrResourceItems[i].source);
            (_arrResourceItems[i] as WOOrderResourceItem).deleteIt();
        }
        _arrResourceItems.length = 0;
        for (i=0; i<_arrItems.length; i++) {
            _source.removeChild(_arrItems[i].source);
            (_arrItems[i] as WOOrderItem).deleteIt();
        }
        _arrItems.length = 0;
        _source.removeChild(_bigYellowBG);
        _bigYellowBG.deleteIt();
        _rightBlock.removeChild(_bgWhiteIn);
        _bgWhiteIn.deleteIt();
        _rightBlock.removeChild(_txtNagrada);
        _txtNagrada.deleteIt();
        _rightBlock.removeChild(_sensCoin);
        _sensCoin.deleteIt();
        _rightBlock.removeChild(_sensXP);
        _sensXP.deleteIt();
        _rightBlock.removeChild(_btnDel);
        _btnDel.deleteIt();
        _rightBlock.removeChild(_btnSell);
        _btnSell.deleteIt();
        _source.removeChild(_rightBlock);
        _rightBlock.dispose();
        _rightBlockTimer.removeChild(_txtInfo);
        _txtInfo.deleteIt();
        _rightBlockTimer.removeChild(_txtTimer);
        _txtTimer.deleteIt();
        _rightBlockTimer.removeChild(_txtZakazState);
        _txtZakazState.deleteIt();
        _rightBlockTimer.removeChild(_btnSkipDelete);
        _btnSkipDelete.removeChild(_txtBtnSkip);
        _txtBtnSkip.deleteIt();
        _btnSkipDelete.removeChild(_txtBtnSkipCost);
        _txtBtnSkipCost.deleteIt();
        _btnSkipDelete.deleteIt();
        _source.removeChild(_rightBlockTimer);
        _rightBlockTimer.dispose();
        super.deleteIt();
    }
}
}

