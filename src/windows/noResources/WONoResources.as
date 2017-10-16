/**
 * Created by user on 6/29/15.
 */
package windows.noResources {
import additional.buyerNyashuk.BuyerNyashuk;

import analytic.AnalyticManager;

import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import manager.ManagerFilters;

import media.SoundConst;

import quest.ManagerQuest;

import resourceItem.DropItem;

import resourceItem.xp.XPStar;

import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;

import windows.*;
import starling.display.Image;
import starling.text.TextField;
import starling.utils.Color;
import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;

public class WONoResources extends WindowMain {
    private var _btnBuy:CButton;
    private var _woBG:WindowBackgroundNew;
    private var _txtHardCost:CTextField;
    private var _arrItems:Array;
    private var _countOfResources:int;
    private var _countCost:int;
    private var _callbackBuy:Function;
    private var _paramData:Object;
    private var _txtNoResource:CTextField;
    private var _text:CTextField;
    private var _nyashuk:BuyerNyashuk;
    private var _sensi:SensibleBlock;
    private var _imRubin:Image;

    public function WONoResources() {
        super();
        _windowType = WindowsManager.WO_NO_RESOURCES;
        _woWidth = 680;
        _woHeight = 455;
        _arrItems = [];
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,115);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        SOUND_OPEN = SoundConst.WO_AHTUNG;

        _txtNoResource = new CTextField(800, 50, String(g.managerLanguage.allTexts[373]));
        _txtNoResource.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txtNoResource.x = -410;
        _txtNoResource.y = -185;
        _source.addChild(_txtNoResource);
        _text = new CTextField(620, 220, String(g.managerLanguage.allTexts[374]));
        _text.setFormat(CTextField.BOLD30, 28, ManagerFilters.BLUE_LIGHT_NEW);
        _text.x = -(_text.textBounds.width/2 + 10);
        _text.y = -175;
        _source.addChild(_text);

        _btnBuy = new CButton();
        _btnBuy.addButtonTexture(265, CButton.HEIGHT_55, CButton.GREEN, true);
        _btnBuy.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _btnBuy.x = 0;
        _btnBuy.y = 170;
        _source.addChild(_btnBuy);
        _imRubin = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
        _imRubin.alignPivot();
//        MCScaler.scale(_imRubin, 25, 25);
        _txtHardCost = new CTextField(265, 80, String(''));
        _txtHardCost.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
    }

    override public function showItParams(callback:Function, params:Array):void {
        var item:WONoResourcesItem;
        _paramData = params[1];
        if (params[2]) _nyashuk = params[2];
        _callbackBuy = callback;
        _text.text = String(g.managerLanguage.allTexts[374]);
        _text.x = -(_text.textBounds.width/2 + 10);
        switch (params[0]) {
            case 'animal':
                _countOfResources = 1;
                _countCost = g.allData.getResourceById(_paramData.idResourceRaw).priceHard * _countOfResources;
                _txtHardCost.text = String(g.managerLanguage.allTexts[331]) + ' ' + String(_countCost);
                if (_sensi) {
                    _sensi.deleteIt();
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                } else {
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                }
                item = new WONoResourcesItem();
                item.fillWithResource(_paramData.idResourceRaw, _countOfResources);
                item.source.x =  - item.source.width/2;
                item.source.y = 8;
                _source.addChild(item.source);
                _arrItems.push(item);
                _btnBuy.clickCallback = onClickAnimal;
                break;
            case 'menu':
                _countOfResources = _paramData.count;
                createList(_paramData.data);
                _btnBuy.clickCallback = onClickResource;
                break;
            case 'trainHelp':
                _countOfResources = _paramData.count;
                _countCost = g.allData.getResourceById(_paramData.id).priceHard * _countOfResources;
                _txtHardCost.text = String(g.managerLanguage.allTexts[331]) + ' ' + String(_countCost);
                if (_sensi) {
                    _sensi.deleteIt();
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                } else {
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                }
                item = new WONoResourcesItem();
                item.fillWithResource(_paramData.id, _countOfResources);
                item.source.x =  - item.source.width/2;
                item.source.y = 8;
                _source.addChild(item.source);
                _arrItems.push(item);
                _btnBuy.clickCallback = onClickTrainHelp;
                break;
            case 'money':
                _countOfResources = _paramData.count;
                _countCost = Math.ceil(_countOfResources / g.HARD_IN_SOFT);
                _text.text = String(g.managerLanguage.allTexts[374]);
//                _text.x = -(_text.textBounds.width/2 + (_woWidth - _text.textBounds.width) /2);
                _text.x = -(_text.textBounds.width/2 + 10);
                if (_paramData.currency == DataMoney.HARD_CURRENCY) {
                    Cc.error('hard currency can"t be in woNoResourceWindow');
                    g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woNoResource');
                    return;
                }
                _txtHardCost.text = String(g.managerLanguage.allTexts[331]) + ' ' + String(_countCost);
                if (_sensi) {
                    _sensi.deleteIt();
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                } else {
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                }
                item = new WONoResourcesItem();
                item.fillWithMoney(_countOfResources);
                item.source.x = - item.source.width/2;
                item.source.y = 8;
                _source.addChild(item.source);
                _arrItems.push(item);
                _btnBuy.clickCallback = onClickMoney;
                break;
            case 'nyashuk':
                _countOfResources = _paramData.count;
                item = new WONoResourcesItem();
                item.fillWithResource(_paramData.data.id, _paramData.count);
                item.source.x =  - item.source.width/2;
                item.source.y = 8;
                _source.addChild(item.source);
                _arrItems.push(item);
                _countCost = _paramData.count * int(_paramData.data.priceHard);
                _txtHardCost.text = String(g.managerLanguage.allTexts[331]) + ' ' + String(_countCost);
                if (_sensi) {
                    _sensi.deleteIt();
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                } else {
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                }
                _btnBuy.clickCallback = onClickNyashuk;
                break;
            case 'order':
                var countR:int;
                _countCost = 0;
                for (var i:int=0; i<_paramData.resourceIds.length; i++) {
                    countR = _paramData.resourceCounts[i] - g.userInventory.getCountResourceById(_paramData.resourceIds[i]);
                    if (countR > 0) {
                        item = new WONoResourcesItem();
                        item.fillWithResource(_paramData.resourceIds[i], countR);
                        _countCost += g.allData.getResourceById(_paramData.resourceIds[i]).priceHard * countR;
                        _source.addChild(item.source);
                        item.source.y = 8;
                        _arrItems.push(item);
                    }
                }
                switch (_arrItems.length) {
                    case 1:
                        _arrItems[0].source.x = - (item.source.width/4);
                        break;
                    case 2:
                        _arrItems[0].source.x = -200 + 102;
                        _arrItems[1].source.x = -200 + 232;
                        break;
                    case 3:
                        _arrItems[0].source.x = -200 + 47;
                        _arrItems[1].source.x = -200 + 167;
                        _arrItems[2].source.x = -200 + 287;
                        break;
                    case 4:
                        _arrItems[0].source.x = -211;
                        _arrItems[1].source.x = -200 + 104;
                        _arrItems[2].source.x = -200 + 219;
                        _arrItems[3].source.x = -200 + 334;
                        break;
                    case 5:
                        _arrItems[0].source.x = -275;
                        _arrItems[1].source.x = -200 + 40;
                        _arrItems[2].source.x = -200 + 155;
                        _arrItems[3].source.x = -200 + 270;
                        _arrItems[4].source.x = -200 + 385;
                        break;
                }
                _txtHardCost.text = String(g.managerLanguage.allTexts[331]) + ' ' + String(_countCost);
                if (_sensi) {
                    _sensi.deleteIt();
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                } else {
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                }
                _btnBuy.clickCallback = onClickOrder;
                break;
            case 'papper':
                _countOfResources = _paramData.count;
                item = new WONoResourcesItem();
                item.fillWithResource(_paramData.data.id, _paramData.count);
                item.source.x =  - item.source.width/2;
                item.source.y = 8;
                _source.addChild(item.source);
                _arrItems.push(item);
                _countCost = _paramData.count * int(_paramData.data.priceHard);
                _txtHardCost.text = String(g.managerLanguage.allTexts[331]) + ' ' + String(_countCost);
                if (_sensi) {
                    _sensi.deleteIt();
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                } else {
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                }
                _btnBuy.clickCallback = onClickPapper;
                break;
            case 'train':
                _countOfResources = _paramData.count;
                item = new WONoResourcesItem();
                item.fillWithResource(_paramData.data.id, _paramData.count);
                item.source.x =  - item.source.width/2;
                item.source.y = 8;
                _source.addChild(item.source);
                _arrItems.push(item);
                _countCost = _paramData.count * int(_paramData.data.priceHard);
                _txtHardCost.text = String(g.managerLanguage.allTexts[331]) + ' ' + String(_countCost);
                if (_sensi) {
                    _sensi.deleteIt();
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                } else {
                    _sensi = new SensibleBlock();
                    _sensi.textAndImage(_txtHardCost,_imRubin,265);
                    _btnBuy.addSensBlock(_sensi,0,25);
                }
                _btnBuy.clickCallback = onClickTrain;
        }
        super.showIt();
    }

    private function createList(_data:Object):void {
        var im:WONoResourcesItem;
        var i:int;

        if (!_data) {
            Cc.error('WONoResource createList:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woNoResource');
            return;
        }
        if (_data.buildType && _data.buildType == BuildType.INSTRUMENT) {
            im = new WONoResourcesItem();
            im.fillWithResource(_data.id, 1);
            im.source.x =  - im.source.width/2;
            im.source.y = 8;
            _source.addChild(im.source);
            _arrItems.push(im);
            _countCost = int(_data.priceHard)*_countOfResources;
            _txtHardCost.text = String(g.managerLanguage.allTexts[331]) + ' ' + String(_countCost);
            if (_sensi) {
                _sensi.deleteIt();
                _sensi = new SensibleBlock();
                _sensi.textAndImage(_txtHardCost,_imRubin,265);
                _btnBuy.addSensBlock(_sensi,0,25);
            } else {
                _sensi = new SensibleBlock();
                _sensi.textAndImage(_txtHardCost,_imRubin,265);
                _btnBuy.addSensBlock(_sensi,0,25);
            }
        } else if (_data.buildType && _data.buildType == BuildType.PLANT) {
            im = new WONoResourcesItem();
            im.fillWithResource(_data.id, _countOfResources);
            im.source.x =  - im.source.width/2;
            im.source.y = 8;
            _source.addChild(im.source);
            _arrItems.push(im);
            _countCost = int(_data.priceHard) * _countOfResources;
            _txtHardCost.text = String(g.managerLanguage.allTexts[331]) + ' ' + String(_countCost);
            if (_sensi) {
                _sensi.deleteIt();
                _sensi = new SensibleBlock();
                _sensi.textAndImage(_txtHardCost,_imRubin,265);
                _btnBuy.addSensBlock(_sensi,0,25);
            } else {
                _sensi = new SensibleBlock();
                _sensi.textAndImage(_txtHardCost,_imRubin,265);
                _btnBuy.addSensBlock(_sensi,0,25);
            }
        } else if (_data.ingridientsId && _data.ingridientsId) {
            var countR:int;
            _countCost = 0;
            for (i = 0; i < _data.ingridientsId.length; i++) {
                countR = g.userInventory.getCountResourceById(_data.ingridientsId[i]);
                if (countR < _data.ingridientsCount[i]) {
                    im = new WONoResourcesItem();
                    im.fillWithResource(_data.ingridientsId[i], _data.ingridientsCount[i] - countR);
                    _countCost += g.allData.getResourceById(_data.ingridientsId[i]).priceHard * (_data.ingridientsCount[i] - countR);
                    im.source.y = 8;
                    _source.addChild(im.source);
                    _arrItems.push(im);
                }
            }
            _txtHardCost.text = String(g.managerLanguage.allTexts[331]) + ' ' + String(_countCost);
            if (_sensi) {
                _sensi.deleteIt();
                _sensi = new SensibleBlock();
                _sensi.textAndImage(_txtHardCost,_imRubin,265);
                _btnBuy.addSensBlock(_sensi,0,25);
            } else {
                _sensi = new SensibleBlock();
                _sensi.textAndImage(_txtHardCost,_imRubin,265);
                _btnBuy.addSensBlock(_sensi,0,25);
            }
            switch (_arrItems.length) {
                case 1:
                    _arrItems[0].source.x = - (im.source.width/4);
                    break;
                case 2:
                    _arrItems[0].source.x = -200 + 102;
                    _arrItems[1].source.x = -200 + 232;
                    break;
                case 3:
                    _arrItems[0].source.x = -200 + 47;
                    _arrItems[1].source.x = -200 + 167;
                    _arrItems[2].source.x = -200 + 287;
                    break;
                case 4:
                    _arrItems[0].source.x = -211;
                    _arrItems[1].source.x = -200 + 104;
                    _arrItems[2].source.x = -200 + 219;
                    _arrItems[3].source.x = -200 + 334;
                    break;
                case 5:
                    _arrItems[0].source.x = -200 + 27;
                    _arrItems[1].source.x = -200 + 97;
                    _arrItems[2].source.x = -200 + 167;
                    _arrItems[3].source.x = -200 + 237;
                    _arrItems[4].source.x = -200 + 307;
                    break;
            }
        }
    }

    private function onClickMoney():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, _countOfResources);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_SOFT_FOR_HARD, {id: DataMoney.SOFT_CURRENCY, info: _countOfResources});
        super.hideIt();
        _btnBuy.clickCallback = null;
        if (_callbackBuy != null) {
            _callbackBuy.apply(null,[_paramData.data,_paramData.cost]);
            _callbackBuy = null;
        }
    }

    private function onClickNyashuk():void {
        var ob:Object = {};
        ob.id = DataMoney.SOFT_CURRENCY;
        ob.count = _countOfResources;
        new DropItem(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2,ob);
        _paramData.dataNyashuk.visible = false;
        new XPStar(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2., 5);
        g.userInventory.addResource(_paramData.data.id,-_countCost );
        g.directServer.updateUserPapperBuy(_paramData.dataNyashuk.buyerId,0,0,0,0,0,0);
        if (_paramData.dataNyashuk.buyerId == 1) g.userTimer.buyerNyashukBlue(1200);
        else  g.userTimer.buyerNyashukRed(1200);
        g.managerBuyerNyashuk.onReleaseOrder(_nyashuk,false);
        g.managerQuest.onActionForTaskType(ManagerQuest.NIASH_BUYER);
        super.hideIt();
    }

    private function onClickAnimal():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(_countOfResources, -_countCost);
        } else {
            _callbackBuy = null;
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        _btnBuy.clickCallback = null;
        g.userInventory.addResource(_paramData.idResourceRaw, _countOfResources, callbackServe);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.idResourceRaw, info: _countOfResources});
        super.hideIt();
    }

    private function onClickResource():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        _btnBuy.clickCallback = null;
        if (_paramData.data.buildType == BuildType.INSTRUMENT) {
            g.userInventory.addResource(_paramData.data.id, _countOfResources, callbackServe);
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.data.id, info: _countOfResources});
            super.hideIt();
        } else if (_paramData.data.buildType == BuildType.PLANT) {
            g.userInventory.addResource(_paramData.data.id, _countOfResources, callbackServe5);
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.data.id, info: _countOfResources});
            super.hideIt();
        } else if (_paramData.data.ingridientsId) {
            var countRes:int = 0;
            _countCost = 0;
            for (var i:int = 0; i < _paramData.data.ingridientsId.length; i++) {
                countRes = g.userInventory.getCountResourceById(_paramData.data.ingridientsId[i]);
                if (countRes < _paramData.data.ingridientsCount[i]) {
                    g.userInventory.addResource(_paramData.data.ingridientsId[i], _paramData.data.ingridientsCount[i] - countRes, null);
                    g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.data.ingridientsId[i], info: _paramData.data.ingridientsCount[i] - countRes});
                }
            }
            super.hideIt();
            callbackServe3();
        }
    }

    private function onClickOrder():void {
        var number:int = 0;
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        _btnBuy.clickCallback = null;
        _countCost = 0;
        for (var i:int=0; i<_paramData.resourceIds.length; i++) {
            number = g.userInventory.getCountResourceById(_paramData.resourceIds[i]);
            if (number < _paramData.resourceCounts[i]) {
                g.userInventory.addResource(_paramData.resourceIds[i], _paramData.resourceCounts[i] - number, callbackForOrder);
                g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.resourceIds[i], info: _paramData.resourceCounts[i] - number});
            } else callbackForOrder();
        }
        super.hideIt();
    }

    private function onClickTrainHelp():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        _btnBuy.clickCallback = null;
        _countCost = 0;
        g.userInventory.addResource(_paramData.id, _countOfResources, callbackServe2);
        super.hideIt();
    }


    private function onClickPapper():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        _btnBuy.clickCallback = null;
        g.userInventory.addResource(_paramData.data.id, _countOfResources, callbackServe2);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.data.id, info: _countOfResources});
        super.hideIt();
    }

    private function onClickTrain():void {
        if (_countCost <= g.user.hardCurrency) {
            g.userInventory.addMoney(DataMoney.HARD_CURRENCY, -_countCost);
        } else {
            _callbackBuy = null;
            g.windowsManager.uncasheWindow();
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        _btnBuy.clickCallback = null;
        g.userInventory.addResource(_paramData.data.id, _countOfResources, callbackServe2);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.BUY_RESOURCE_FOR_HARD, {id: _paramData.data.id, info: _countOfResources});
        super.hideIt();
    }

    private function callbackServe(b:Boolean = false):void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null);
            _callbackBuy = null;
        }
    }

    private function callbackServe2(b:Boolean = false):void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null,[true]);
            _callbackBuy = null;
        }
    }

    private function callbackServe3():void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null, [_paramData.data, true]);
            _callbackBuy = null;
        }
        super.hideIt();
    }

    private function callbackServe4():void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null, [true, _paramData]);
            _callbackBuy = null;
        }
    }
    private function callbackForOrder(b:Boolean = false):void {
        _countCost +=1;
        if (_countCost < _paramData.resourceIds.length) return;
        else callbackServe4();
    }

    private function callbackServe5(b:Boolean = false):void {
        if (_callbackBuy != null) {
            _callbackBuy.apply(null, [_paramData.data, _paramData.ridge,_paramData.callback]);
            _callbackBuy = null;
        }
    }

    override protected function deleteIt():void {
        g.marketHint.hideIt();
        if (_txtNoResource) {
            _source.removeChild(_txtNoResource);
            _txtNoResource.deleteIt();
            _txtNoResource = null;
        }
        if (_text) {
            _source.removeChild(_text);
            _text.deleteIt();
            _text = null;
        }
        if (_txtHardCost) {
            _btnBuy.removeChild(_txtHardCost);
            _txtHardCost.deleteIt();
            _txtHardCost = null;
        }
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
        super.deleteIt();
    }

    private function onClickExit():void {
        g.windowsManager.uncasheWindow();
        _callbackBuy = null;
        super.hideIt();
    }
}
}