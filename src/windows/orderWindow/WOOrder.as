/**
 * Created by andy on 9/19/17.
 */
package windows.orderWindow {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;

import dragonBones.Armature;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;

import flash.geom.Point;
import manager.ManagerFilters;
import manager.ManagerPartyNew;
import manager.ManagerPartyNew;

import media.SoundConst;
import order.ManagerOrder;
import order.OrderCat;

import quest.ManagerQuest;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;
import tutorial.TutsAction;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;
import utils.SimpleArrow;
import utils.TimeUtils;
import utils.Utils;
import windows.WOComponents.BackgroundWhiteIn;
import windows.WOComponents.WindowBackgroundNew;
import windows.WOComponents.BackgroundYellowOut;
import windows.WindowMain;
import windows.WindowsManager;

public class WOOrder extends WindowMain {
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
    private var _armature:Armature;
    private var _srcBaloon:Sprite;
    private var _imBaloon:Image;
    private var _txtBaloon:CTextField;
    private var _arrow:SimpleArrow;
    private var _canArrow:Boolean;

    public function WOOrder() {
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

        _txtWindowName = new CTextField(300, 70, g.managerLanguage.allTexts[1284]);
        _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtWindowName.x = -150;
        _txtWindowName.y = -_woHeight / 2 + 25;
        _txtWindowName.letterSpacing = 20;
        _source.addChild(_txtWindowName);

        createItems();
        createRightBlock();
        createRightBlockTimer();
        createTopCats();
//        _srcBaloon = new Sprite();
//        _source.addChild(_srcBaloon);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _arrOrders = g.managerOrder.arrOrders.slice();
        if (!_arrOrders.length) {
            Cc.error('WOOrder:: no any order');
            return;
        }
        fillList();
        var i:int;
        if (params[0]) {
            for ( i = 0; i < _arrOrders.length; i++) {
                if (_arrOrders[i].catOb.id == params[0].id) {
                    break;
                }
            }
        } else {
            var num:int;
            var delay:int;
            for (i = 0; i < _arrOrders.length; i++) {
                delay = 0;
                num = 0;
                for (var k:int = 0; k<_arrOrders[i].resourceIds.length; k++) {
                    if (g.userInventory.getCountResourceById(_arrOrders[i].resourceIds[k]) >= _arrOrders[i].resourceCounts[k]) num++;
                }
                if (num == _arrOrders[i].resourceIds.length) break;
                else delay++;
            }
            if (delay > 0) i = 0;
        }
        onItemClick(_arrItems[i]);
        _waitForAnswer = false;
        super.showIt();
    }

    private function onClickExit(e:Event=null):void {
        if (g.tuts.isTuts) return;
        g.miniScenes.onHideOrder();
        hideIt();
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
            item.source.y = -_woHeight / 2 + 418 + int(i / 3) * 90;
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
        if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_ORDER) t.setFormat(CTextField.BOLD24, 24, 0xcf342f, Color.WHITE);
        else t.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        MCScaler.scale(im, 30, 30);
        _sensCoin = new SensibleBlock();
        _sensCoin.imageAndText(im, t, 95, 5);
        _sensCoin.x = -_woWidth / 2 + 540;
        _sensCoin.y = -_woWidth / 2 + 607;
        _rightBlock.addChild(_sensCoin);
        t = new CTextField(60, 30, '8888');
        if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_XP_ORDER) t.setFormat(CTextField.BOLD24, 24, 0xcf342f, Color.WHITE);
        else t.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
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
        if (g.managerOrderCats.moveBoolean) _btnSell.setEnabled = false;
        _rightBlock.addChild(_btnSell);

        _btnDel = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('trash'));
        im.alignPivot();
        _btnDel.addDisplayObject(im);
        _btnDel.x = -_woWidth / 2 + 500;
        _btnDel.y = -_woHeight / 2 + 628;
        _btnDel.clickCallback = deleteOrder;
        _rightBlock.addChild(_btnDel);
        _btnDel.hoverCallback = function():void { g.hint.showIt(String((g.managerLanguage.allTexts[1178]))); };
        _btnDel.outCallback = function():void { g.hint.hideIt(); };
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
        if (_arrOrders.length < 9) (_arrItems[i] as WOOrderItem).fillIt(null, _arrOrders[i-1].placeNumber+1, null,true);
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
            stopCatsAnimations();
        } else {
            _rightBlock.visible = true;
            _rightBlockTimer.visible = false;
            g.gameDispatcher.removeFromTimer(onTimer);
            animateCustomerCat();
        }
        var or:OrderItemStructure = _activeOrderItem.getOrder();
        if (g.managerOrderCats.moveBoolean || _activeOrderItem.leftSeconds > 0) {
            if (_srcBaloon) _srcBaloon.visible = false;
            emptyCarCustomer();
        } else {
            if (_txtBaloon) _txtBaloon.text = String(g.managerLanguage.allTexts[or.txtId]);
            if (_srcBaloon) _srcBaloon.visible = true;
        }

        for (var i:int = 0; i <_arrOrders.length; i++) {
            if (_arrOrders[i].placeNumber == item.position && _arrOrders[i].delOb == true) {
                _txtZakazState.text = String(g.managerLanguage.allTexts[369]);
                break;
            } else if (_arrOrders[i].placeNumber == item.position && _arrOrders[i].delOb == false) {
                _txtZakazState.text = String(g.managerLanguage.allTexts[368]);
                break;
            }
        }
        if (g.user.level <= 5) {
            hideArrow();
            _canArrow = true;
            for (i = 0; i < or.resourceIds.length; i++) {
                if (!(_arrResourceItems[i] as WOOrderResourceItem).isChecked()) {
                    _canArrow = false;
                    return;
                }
            }
            var f1:Function = function ():void {
                if (_source && _activeOrderItem.leftSeconds <= 0) addArrow();
            };
            Utils.createDelay(4,f1);
        }
    }

    private function fillResourceItems(or:OrderItemStructure):void {
        if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_XP_ORDER)
            _sensXP.updateText(String(or.xp * g.managerParty.coefficient));
            else _sensXP.updateText(String(or.xp));
        if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_ORDER)
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
            hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -n);
        _btnSkipDelete.visible = false;
        _activeOrderItem.onSkipTimer();
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
//                g.managerOrder.checkCatId();
                _arrOrders[i].delOb = false;
//                _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(null,_arrOrders[i].catOb);
                break;
            }
        }
    }

    private function set setTimerText(c:int):void { _txtTimer.text = TimeUtils.convertSecondsForOrders(c); }

    private function sellOrder(b:Boolean = false, or:OrderItemStructure = null):void {
        if (_waitForAnswer) return;
        if (!_activeOrderItem) return;
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
                    _isShowed = true;
                    break;
                }
            }
        }
        for (i=0; i<_activeOrderItem.getOrder().resourceIds.length; i++) {
            if (or.resourceIds[i] && or.resourceCounts[i]) g.userInventory.addResource(or.resourceIds[i], -or.resourceCounts[i]);
        }

        if (b) _clickItem = true;

        _waitForAnswer = true;
        _txtZakazState.text = String(g.managerLanguage.allTexts[368]);
        var tOrderItem:WOOrderItem = _activeOrderItem;
        var f:Function = function (ord:OrderItemStructure):void { afterSell(ord, tOrderItem); };
        for (i = 0; i< _arrOrders.length; i++) {
            if (_arrOrders[i] && _arrOrders[i].placeNumber == _activeOrderItem.position) {
                _arrOrders[i] = null;
                break;
            }
        }
        g.server.addUserOrderGift(or,0,0,0,null);

        g.managerOrder.sellOrder(or, f);
        g.managerOrder.cancelAnimateSmallHero();
        g.soundManager.playSound(SoundConst.ORDER_COMPLETED);
        if (g.tuts.isTuts && g.tuts.action == TutsAction.ORDER) g.tuts.checkTutsCallback();
            else g.miniScenes.onBuyOrder();
    }

import order.OrderItemStructure;

import windows.orderWindow.WOOrderItem;

private function afterSell(or:OrderItemStructure, orderItem:WOOrderItem):void {
        _waitForAnswer = false;
        or = _activeOrderItem.getOrder();

    _btnDel.visible = false;
    _btnSell.visible = false;
            or.startTime = TimeUtils.currentSeconds + 6;
            orderItem.fillIt(or, or.placeNumber, onItemClick);
            for (var i:int = 0; _arrOrders.length; i++) {
                if (_arrOrders[i] == null) {
                    _arrOrders[i] = or;
                    break;
                }
            }
            if (_activeOrderItem == orderItem) {
                onItemClick(_activeOrderItem);
                _clickItem = false;
            }
        var f:Function = function ():void {
            hideIt();
            g.managerOrderCats.rawOrderMoto(or);
            g.managerQuest.onActionForTaskType(ManagerQuest.RELEASE_ORDER);
            for (i = 0; i < _arrOrders.length; i++) {
                if (!_arrOrders[i].cat && !_arrOrders[i].delOb) {
//                    g.managerOrder.checkCatId();
//                    _arrOrders[i].cat = g.managerOrderCats.getNewCatForOrder(null,_arrOrders[i].catOb);
                    break;
                }
            }
        };
        Utils.createDelay(1,f);
    }

    override  public function hideIt():void {
        if (g.user.level == 5 && g.user.cutScenes[8] != 1) g.managerCutScenes.goToNeighbor();
        super.hideIt();
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
            for (var i:int = 0; _arrOrders.length; i++) {
                if (_arrOrders[i].placeNumber == _activeOrderItem.position) {
                    _arrOrders[i] = null;
                    break;
                }
            }
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
            _txtZakazState.text = String(g.managerLanguage.allTexts[369]);
            for (var i:int = 0; _arrOrders.length; i++) {
                if (_arrOrders[i] == null) {
                    _arrOrders[i] = or;
                    break;
                }
            }

            if (_activeOrderItem == orderItem) onItemClick(_activeOrderItem, -2);
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

    //// ANIMATIONS//////
    private function createTopCats():void {

        _armature = g.allData.factory['order_window'].buildArmature("cat");
        _source.addChild(_armature.display as StarlingArmatureDisplay);
        (_armature.display as StarlingArmatureDisplay).x = 145;
        (_armature.display as StarlingArmatureDisplay).y = 47;
        WorldClock.clock.add(_armature);
        animateCustomerCat();
        if (g.user.level >= 4 && !g.managerOrderCats.moveBoolean) {
            _srcBaloon = new Sprite();
            _source.addChild(_srcBaloon);
            _imBaloon = new Image(g.allData.atlas['interfaceAtlas'].getTexture('orders_cat_babble'));
            _srcBaloon.addChild(_imBaloon);
            _imBaloon.x = 5;
            _imBaloon.y = -20;
            _txtBaloon = new CTextField(200, 200, 'Написать Текст');
            _txtBaloon.setFormat(CTextField.BOLD18, 18, ManagerFilters.LIGHT_BLUE_COLOR);
            _txtBaloon.x = 40;
            _txtBaloon.y = -40;
            _srcBaloon.addChild(_txtBaloon);
            _srcBaloon.scaleX = _srcBaloon.scaleY = 0;
            _srcBaloon.x = (_armature.display as StarlingArmatureDisplay).x + 30;
            _srcBaloon.y = (_armature.display as StarlingArmatureDisplay).y - 200;
            new TweenMax(_srcBaloon, 1, {scaleX: 1, scaleY: 1, y: _srcBaloon + 83, ease: Back.easeOut});
        }
    }

    private function animateCustomerCat(e:Event=null):void {
        if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, animateCustomerCat);
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, animateCustomerCat);

        _armature.addEventListener(EventObject.COMPLETE, animateCustomerCat);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, animateCustomerCat);
        var l:int = int(Math.random()*15);
        if (l > 6) {
            _armature.animation.gotoAndPlayByFrame('idle');
        } else {
            switch (l) {
                case 0:
                    _armature.animation.gotoAndPlayByFrame('idle');
                    break;
                case 1:
                    _armature.animation.gotoAndPlayByFrame('hi');
                    break;
                case 2:
                    _armature.animation.gotoAndPlayByFrame('helllo');
                    break;
                case 3:
                    _armature.animation.gotoAndPlayByFrame('surprise');
                    break;
                case 4:
                    _armature.animation.gotoAndPlayByFrame('happy2');
                    break;
                case 5:
                    _armature.animation.gotoAndPlayByFrame('talk');
                    break;
                case 6:
                    _armature.animation.gotoAndPlayByFrame('talk2');
                    break;
            }
        }
    }

    private function killCatAnimations():void {
        if (!_armature) {
            return;
        }
        stopCatsAnimations();
        WorldClock.clock.remove(_armature);
    }

    private function stopCatsAnimations():void {
        if (!_armature) {
            return;
        }
        _armature.animation.gotoAndStopByFrame('idle');
        if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, animateCustomerCat);
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, animateCustomerCat);
    }

    private function deleteCats():void {
        killCatAnimations();
        if (!_armature) return;
        _source.removeChild(_armature.display as Sprite);
        _armature = null;
    }

    private function emptyCarCustomer():void {
        _armature.animation.gotoAndStopByFrame('empty');
    }

    public function addArrow():void {
        if (_btnSell && !_arrow && _canArrow) {
            if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) {
                _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, _source);
                _arrow.animateAtPosition(_btnSell.x + _btnSell.width/2, _btnSell.y);
                _arrow.scaleIt(.7);
            } else {
                _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, _source);
                _arrow.animateAtPosition(_btnSell.x, _btnSell.y + _btnSell.height/2 - 2);
                _arrow.scaleIt(.7);
            }
        }
    }

    public function hideArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }
}
}

