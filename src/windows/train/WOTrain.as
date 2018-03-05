/**
 * Created by user on 7/23/15.
 */
package windows.train {
import build.train.Train;
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import manager.ManagerFilters;
import resourceItem.newDrop.DropObject;
import social.SocialNetworkEvent;
import starling.display.Image;
import starling.events.Event;
import starling.utils.Align;
import starling.utils.Color;
import user.Someone;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;
import utils.TimeUtils;
import windows.WOComponents.BackgroundMilkIn;
import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOTrain extends WindowMain {
    public static var CELL_RED:int = 3;
    public static var CELL_GREEN:int = 2;
    public static var CELL_WHITE:int = 1;

    private var _arrItems:Array;
    private var _yellowBG:BackgroundYellowOut;
    private var _milkBG:BackgroundMilkIn;
    private var _txtWindowName:CTextField;
    private var _txt1:CTextField;
    private var _txt2:CTextField;
    private var _txt3:CTextField;
    private var _txt4:CTextField;
    private var _btnSendBasket:CButton;
    private var _btnLoad:CButton;
    private var _btnHelp:CButton;
    private var _txtTimer:CTextField;
    private var _sensXPItem:SensibleBlock;
    private var _sensMoneyItem:SensibleBlock;
    private var _sensXP:SensibleBlock;
    private var _sensMoney:SensibleBlock;
    private var _sensCoupone:SensibleBlock;
    private var _imResource:Image;
    private var _activeItemIndex:int;
    private var _train:Train;
    private var _timer:int;
    private var _isBigCount:Boolean;
    private var _countNotFullItems:int;

    public function WOTrain() {
        super ();
        _windowType = WindowsManager.WO_TRAIN;
        _woWidth = 972;
        _woHeight = 714;
        if (g.managerResize.stageHeight < 750) _isBigWO = false;   else _isBigWO = true;
        if (_isBigWO) _woHeight = 714;   else _woHeight = 550;
        _activeItemIndex = -1;
        if (_isBigWO) _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 109);  else _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 60);
        _source.addChild(_woBGNew);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        if (_isBigWO) _yellowBG = new BackgroundYellowOut(932, 564);  else _yellowBG = new BackgroundYellowOut(932, 464);
        _yellowBG.x = - 468;
        if (_isBigWO) _yellowBG.y = -_woHeight/2 + 128;  else _yellowBG.y = -_woHeight/2 + 68;
        _source.addChild(_yellowBG);
        _milkBG = new BackgroundMilkIn(282, 278);
        _milkBG.x = -_woWidth/2 + 651;
        if (_isBigWO) _milkBG.y = -_woHeight/2 + 223;  else _milkBG.y = -_woHeight/2 + 160;
        _source.addChild(_milkBG);
        if (_isBigWO) {
            _txtWindowName = new CTextField(_woWidth, 70, g.managerLanguage.allTexts[1283]);
            _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
            _txtWindowName.y = -_woHeight / 2 + 20;
            _txtWindowName.alignH = Align.LEFT;
            _txtWindowName.x = -_txtWindowName.textBounds.width/2;
        } else {
            _txtWindowName = new CTextField(300, 50, g.managerLanguage.allTexts[1283]);
            _txtWindowName.setFormat(CTextField.BOLD30, 36, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
            _txtWindowName.y = -_woHeight / 2 + 5;
            _txtWindowName.x = -150;
        }
        _source.addChild(_txtWindowName);

        _arrItems = [];
        createItems();
        if (_isBigWO) {
            _txt1 = new CTextField(400, 50, String(g.managerLanguage.allTexts[296]));
            _txt1.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR, Color.WHITE);
            _txt1.y = -_woHeight / 2 + 156;
        } else {
            _txt1 = new CTextField(400, 50, String(g.managerLanguage.allTexts[296]));
            _txt1.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR, Color.WHITE);
            _txt1.y = -_woHeight / 2 + 85;
        }
        _txt1.alignPivot();
        _txt1.x = -_woWidth / 2 + 335;
        _source.addChild(_txt1);
        _txt2 = new CTextField(220,30,String(g.managerLanguage.allTexts[297]));
        _txt2.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txt2.alignPivot();
        _txt2.x = -_woWidth/2 + 790;
        if (_isBigWO) _txt2.y = -_woHeight/2 + 144;  else _txt2.y = -_woHeight/2 + 85;
        _source.addChild(_txt2);
        _txt3 = new CTextField(280,40,String(g.managerLanguage.allTexts[295]));
        _txt3.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txt3.alignPivot();
        _txt3.x = -_woWidth/2 + 796;
        if (_isBigWO) _txt3.y = -_woHeight/2 + 523;  else _txt3.y = -_woHeight/2 + 458;
        _source.addChild(_txt3);
        _txt4 = new CTextField(280,60,String(g.managerLanguage.allTexts[299]));
        _txt4.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txt4.alignPivot();
        _txt4.x = -_woWidth/2 + 786;
        if (_isBigWO)_txt4.y = -_woHeight/2 + 271;  else _txt4.y = -_woHeight/2 + 200;
        _source.addChild(_txt4);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('clock'));
        im.alignPivot();
        im.x = -_woWidth/2 + 730;
        if (_isBigWO) im.y = -_woHeight/2 + 190;  else im.y = -_woHeight/2 + 130;
        _source.addChild(im);
        _txtTimer = new CTextField(300, 50, '');
        _txtTimer.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txtTimer.alignPivot();
        _txtTimer.x = -_woWidth/2 + 827;
        if (_isBigWO) _txtTimer.y = -_woHeight/2 + 185;  else _txtTimer.y = -_woHeight/2 + 125;
        _source.addChild(_txtTimer);

        _btnSendBasket = new CButton();
        _btnSendBasket.addButtonTexture(150, CButton.HEIGHT_55, CButton.GREEN, true);
        _btnSendBasket.addTextField(92, 50, 6, 0, g.managerLanguage.allTexts[292]);
        _btnSendBasket.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        if (_isBigWO) {
            _btnSendBasket.x = -_woWidth / 2 + 800;
            _btnSendBasket.y = -_woHeight / 2 + 638;
        } else {
            _btnSendBasket.x = -_woWidth / 2 + 330;
            _btnSendBasket.y = -_woHeight / 2 + 490;
        }
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('basket_send'));
        im.alignPivot();
        im.x = 134;
        im.y = 19;
        _btnSendBasket.addDisplayObject(im);
        _btnSendBasket.setEnabled = false;
        _btnSendBasket.clickCallback = sendFullTrain;
        _source.addChild(_btnSendBasket);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rug'));
        im.x = -_woWidth/2 + 676;
        if (_isBigWO) im.y = -_woHeight/2 + 340;  else im.y = -_woHeight/2 + 265;
        _source.addChild(im);
        _btnLoad = new CButton();
        _btnLoad.addButtonTexture(90, CButton.HEIGHT_32, CButton.GREEN, true);
        _btnLoad.x = -_woWidth / 2 + 736;
        if (_isBigWO) _btnLoad.y = -_woHeight / 2 + 405; else _btnLoad.y = -_woHeight/2 + 340;
        _btnLoad.addTextField(90, 30, 0, 0, g.managerLanguage.allTexts[294]);
        _btnLoad.setTextFormat(CTextField.BOLD24, 21, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
        _btnLoad.clickCallback = onResourceLoad;
        _source.addChild(_btnLoad);
        _btnHelp = new CButton();
        _btnHelp.addButtonTexture(228, CButton.HEIGHT_41, CButton.BLUE, true);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('ask_button'));
        im.alignPivot();
        im.x = 5;
        im.y = 20;
        _btnHelp.addDisplayObject(im);
        _btnHelp.addTextField(180, 34, 47, 0, g.managerLanguage.allTexts[301]);
        _btnHelp.setTextFormat(CTextField.BOLD24, 21, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _btnHelp.x = -_woWidth/2 + 803;
        if (_isBigWO) _btnHelp.y = -_woHeight/2 + 463; else _btnHelp.y = -_woHeight/2 + 400;
        _source.addChild(_btnHelp);
        _btnHelp.clickCallback = wantHelpClick;

        _sensMoneyItem = new SensibleBlock();
        var t:CTextField = new CTextField(60, 30, '8888');
        t.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        MCScaler.scale(im, 30, 30);
        _sensMoneyItem.imageAndText(im, t, 110, 10);
        _sensMoneyItem.x = -_woWidth / 2 + 800;
        if (_isBigWO) _sensMoneyItem.y = -_woHeight / 2 + 382;  else _sensMoneyItem.y = -_woHeight/2 + 307;
        _source.addChild(_sensMoneyItem);
        _sensXPItem = new SensibleBlock();
        t = new CTextField(60, 30, '8888');
        t.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small_new'));
        MCScaler.scale(im, 36, 36);
        _sensXPItem.imageAndText(im, t, 110, 7);
        _sensXPItem.x = -_woWidth / 2 + 800;
        if (_isBigWO) _sensXPItem.y = -_woHeight / 2 + 340;  else _sensXPItem.y = -_woHeight/2 + 265;
        _source.addChild(_sensXPItem);

        _sensXP = new SensibleBlock();
        t = new CTextField(60, 30, '8888');
        t.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star_small_new'));
        MCScaler.scale(im, 36, 36);
        _sensXP.imageAndText(im, t, 110, 2);
        _sensXP.x = -_woWidth / 2 + 660;
        if (_isBigWO) _sensXP.y = -_woHeight / 2 + 554; else _sensXP.y = -_woHeight/2 + 485;
        _source.addChild(_sensXP);
        _sensMoney = new SensibleBlock();
        t = new CTextField(60, 30, '8888');
        t.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        MCScaler.scale(im, 30, 30);
        _sensMoney.imageAndText(im, t, 110, 5);
        _sensMoney.x = -_woWidth / 2 + 755;
        if (_isBigWO) _sensMoney.y = -_woHeight / 2 + 554;  else _sensMoney.y = -_woHeight / 2 + 488;
        _source.addChild(_sensMoney);
        _sensCoupone = new SensibleBlock();
        t = new CTextField(60, 30, '1');
        t.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('vaucher'));
        MCScaler.scale(im, 30, 30);
        _sensCoupone.imageAndText(im, t, 110, 2);
        _sensCoupone.x = -_woWidth / 2 + 835;
        if (_isBigWO) _sensCoupone.y = -_woHeight / 2 + 554;  else _sensCoupone.y = -_woHeight / 2 + 488;
        _source.addChild(_sensCoupone);
    }

    private function onClickExit(e:Event=null):void {
        if (g.managerCutScenes.isCutScene) return;
        super.hideIt();
    }

    private function createItems():void {
        var item:WOTrainItem;
        for (var i:int = 0; i < 12; i++) {
            item = new WOTrainItem(int(i/4) + 1, i, _isBigWO);
            if (_isBigWO) {
                item.source.x = -_woWidth / 2 + 110 + i % 4 * 146;
                item.source.y = -_woHeight / 2 + 325 + int(i / 4) * 152;
            } else {
                item.source.x = -_woWidth / 2 + 110 + i % 4 * 146;
                item.source.y = -_woHeight / 2 + 210 + int(i / 4) * 110;
            }
            _source.addChild(item.source);
            _arrItems.push(item);
        }
    }

    override public function showItParams(callback:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        var list:Array = params[0];
        _train = params[1];
        _timer = params[3];
        _isBigCount = list.length > 9;
        for (var i:int = 0; i < list.length; i++) {
            if (!_isBigCount && i%4==3) {
                (_arrItems[i] as WOTrainItem).activateIt(false);
                continue;
            }
            (_arrItems[i] as WOTrainItem).fillIt(list[i], onItemClick);
        }
        checkSocialInfoForArray();
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.TRAIN && g.managerParty.levelToStart <= g.user.level)
            _sensMoney.updateText(String(_train.allCoinsCount * g.managerParty.coefficient));
            else _sensMoney.updateText(String(_train.allCoinsCount));
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.TRAIN && g.managerParty.levelToStart <= g.user.level)
            _sensXP.updateText(String(_train.allXPCount * g.managerParty.coefficient));
            else _sensXP.updateText(String(_train.allXPCount));

        var num:int = 0;
        if (!g.managerCutScenes.isCutScene) {
            for (i = 0; i < list.length; i++) {
                if (!list[i].isFull && g.userInventory.getCountResourceById(list[i].id) >= list[i].count) {
                    num = i;
                    break;
                } else num = 0;
            }
        }
        onItemClick(num);
        checkBtn();
        _txtTimer.text = TimeUtils.convertSecondsForHint(_timer);
        g.gameDispatcher.addToTimer(checkCounter);
        super.showIt();
        if (_isBigWO) _source.y -= 40;
    }

    private function checkCounter():void {
        _timer--;
        _txtTimer.text = TimeUtils.convertSecondsForHint(_timer);
    }

    private function onItemClick(k:int):void {
        _activeItemIndex = k;
        var countWantHelp:int = 0;
        _btnLoad.visible = true;
        for (var i:int = 0; i<_arrItems.length; i++) {
            (_arrItems[i] as WOTrainItem).addFilterOnClick(false);
            if ((_arrItems[i] as WOTrainItem).needHelp) countWantHelp++;
        }
        (_arrItems[_activeItemIndex] as WOTrainItem).addFilterOnClick(true);
        if ((_arrItems[_activeItemIndex] as WOTrainItem).isResourceLoaded) {
            _btnLoad.visible = false;
            _btnHelp.visible = false;
            _txt4.text = String(g.managerLanguage.allTexts[298]);
        } else {
            _txt4.text = String(g.managerLanguage.allTexts[299]);
            _btnLoad.visible = true;
            _btnHelp.visible = true;
        }
        if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.TRAIN && g.managerParty.levelToStart <= g.user.level)
            _sensMoneyItem.updateText(String(_arrItems[_activeItemIndex].countCoins * g.managerParty.coefficient));
            else _sensMoneyItem.updateText(String(_arrItems[_activeItemIndex].countCoins));
        if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.TRAIN && g.managerParty.levelToStart <= g.user.level)
            _sensXPItem.updateText(String(_arrItems[_activeItemIndex].countXP * g.managerParty.coefficient));
            else  _sensXPItem.updateText(String(_arrItems[_activeItemIndex].countXP));
        if (_imResource) {
            _source.removeChild(_imResource);
            _imResource.dispose();
            _imResource = null;
        }
        _imResource = (_arrItems[_activeItemIndex] as WOTrainItem).currentImage();
        MCScaler.scale(_imResource, 80, 80);
        _imResource.alignPivot();
        _imResource.x = 737 - _woWidth/2;
        if (_isBigWO) _imResource.y = 348 - _woHeight/2;  else _imResource.y = 285 - _woHeight/2;
        _source.addChild(_imResource);
        if (g.isAway) {
            if (_arrItems[k].needHelp && int(_arrItems[k].idWhoHelp) <= 0) {
                _btnHelp.visible = true;
                return;
            } else _btnHelp.visible = false;
        }
        if (!_arrItems[k].needHelp) {
            if (!_arrItems[k].isResourceLoaded) {
                _btnHelp.visible = true;
                if (countWantHelp >= 3) {
                    _btnHelp.text = g.managerLanguage.allTexts[301] + ' (3/3)';
                    _btnHelp.setEnabled = false;
                } else {
                    _btnHelp.text = g.managerLanguage.allTexts[301] + ' (' + String(countWantHelp) + '/3)';
                    _btnHelp.setEnabled = true;
                }
                _btnHelp.clickCallback = wantHelpClick;
            } else _btnHelp.visible = false;
        } else {
            _btnHelp.visible = false;
        }

    }

    private function releaseAwayHelp(lastResource:Boolean = false):void {
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        var d:DropObject = new DropObject();
        if (lastResource) {
            _btnHelp.visible = false;
            g.server.updateTrainPackGetHelp(int((_arrItems[_activeItemIndex] as WOTrainItem).trainDbId), String(g.user.userSocialId), null);
            if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.TRAIN && g.managerParty.levelToStart <= g.user.level)
                d.addDropXP((_arrItems[_activeItemIndex] as WOTrainItem).countXP * g.managerParty.coefficient, p);
                else d.addDropXP((_arrItems[_activeItemIndex] as WOTrainItem).countXP, p);
            if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.TRAIN && g.managerParty.levelToStart <= g.user.level)
                d.addDropMoney(DataMoney.SOFT_CURRENCY, (_arrItems[_activeItemIndex] as WOTrainItem).countCoins * g.managerParty.coefficient, p);
                else d.addDropMoney(DataMoney.SOFT_CURRENCY, (_arrItems[_activeItemIndex] as WOTrainItem).countCoins, p);
            g.userInventory.addResource((_arrItems[_activeItemIndex] as WOTrainItem).idFree, - (_arrItems[_activeItemIndex] as WOTrainItem).countFree);
            g.managerAchievement.addAll(19,1);
            (_arrItems[_activeItemIndex] as WOTrainItem).fullItHelp();
            updateItems();
        } else {
            if (g.userInventory.getCountResourceById((_arrItems[_activeItemIndex] as WOTrainItem).idFree) >= (_arrItems[_activeItemIndex] as WOTrainItem).countFree) {
                if (g.userInventory.getCountResourceById((_arrItems[_activeItemIndex] as WOTrainItem).idFree) == (_arrItems[_activeItemIndex] as WOTrainItem).countFree
                        && g.allData.getResourceById((_arrItems[_activeItemIndex] as WOTrainItem).idFree).buildType == BuildType.PLANT &&
                        !g.userInventory.checkLastResource((_arrItems[_activeItemIndex] as WOTrainItem).idFree)) {
                    g.windowsManager.cashWindow = this;
                    super.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, releaseAwayHelp, g.allData.getResourceById((_arrItems[_activeItemIndex] as WOTrainItem).idFree), 'trainHelp');
                    return;
                }
                _btnHelp.visible = false;
                g.server.updateTrainPackGetHelp(int((_arrItems[_activeItemIndex] as WOTrainItem).trainDbId), String(g.user.userSocialId), null);
                if (g.managerParty.eventOn && g.managerParty.typeParty == 2 && g.managerParty.typeBuilding == BuildType.TRAIN && g.managerParty.levelToStart <= g.user.level)
                    d.addDropXP((_arrItems[_activeItemIndex] as WOTrainItem).countXP * g.managerParty.coefficient, p);
                    else d.addDropXP((_arrItems[_activeItemIndex] as WOTrainItem).countXP, p);
                if (g.managerParty.eventOn && g.managerParty.typeParty == 1 && g.managerParty.typeBuilding == BuildType.TRAIN && g.managerParty.levelToStart <= g.user.level)
                    d.addDropMoney(DataMoney.SOFT_CURRENCY, (_arrItems[_activeItemIndex] as WOTrainItem).countCoins * g.managerParty.coefficient, p);
                    else d.addDropMoney(DataMoney.SOFT_CURRENCY, (_arrItems[_activeItemIndex] as WOTrainItem).countCoins, p);
                g.userInventory.addResource((_arrItems[_activeItemIndex] as WOTrainItem).idFree, - (_arrItems[_activeItemIndex] as WOTrainItem).countFree);
                g.managerAchievement.addAll(19,1);
                _arrItems[_activeItemIndex].fullItHelp();
                updateItems();
            }  else if ((_arrItems[_activeItemIndex] as WOTrainItem).countFree > g.userInventory.getCountResourceById((_arrItems[_activeItemIndex] as WOTrainItem).idFree)) {
                g.windowsManager.cashWindow = this;
                super.hideIt();
                var obj:Object = {};
                obj.id = (_arrItems[_activeItemIndex] as WOTrainItem).idFree;
                obj.count = (_arrItems[_activeItemIndex] as WOTrainItem).countFree;
                g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, releaseAwayHelp, 'trainHelp', obj);
                return;
            }
        }
        d.releaseIt();
    }

    private function wantHelpClick():void {
        if (g.isAway) {
            releaseAwayHelp();
        } else {
            _btnHelp.visible = false;
            _train.needHelp(true, _activeItemIndex);
            (_arrItems[_activeItemIndex] as WOTrainItem).onClickHelpMePls(true);
            g.server.updateUserTrainPackNeedHelp(int((_arrItems[_activeItemIndex] as WOTrainItem).trainDbId), null);
        }
    }

    private function onResourceLoad(lastResource:Boolean = false):void {
        if (_activeItemIndex == -1) return;
        if ((_arrItems[_activeItemIndex] as WOTrainItem).countFree > g.userInventory.getCountResourceById((_arrItems[_activeItemIndex] as WOTrainItem).idFree)) {
            if (g.managerCutScenes.isCutScene) return;
            var ob:Object = {};
            ob.data = g.allData.getResourceById((_arrItems[_activeItemIndex] as WOTrainItem).idFree);
            ob.count = (_arrItems[_activeItemIndex] as WOTrainItem).countFree - g.userInventory.getCountResourceById((_arrItems[_activeItemIndex] as WOTrainItem).idFree);
            g.windowsManager.cashWindow = this;
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onResourceLoad, 'train', ob);
            return;
        }
        if (!lastResource && _arrItems[_activeItemIndex].countFree == g.userInventory.getCountResourceById((_arrItems[_activeItemIndex] as WOTrainItem).idFree)
                && g.allData.getResourceById((_arrItems[_activeItemIndex] as WOTrainItem).idFree).buildType == BuildType.PLANT &&
                !g.userInventory.checkLastResource((_arrItems[_activeItemIndex] as WOTrainItem).idFree)) {
            g.windowsManager.cashWindow = this;
            super.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_LAST_RESOURCE, onResourceLoad, {id: (_arrItems[_activeItemIndex] as WOTrainItem).idFree}, 'market');
            return;
        }
        if ((_arrItems[_activeItemIndex] as WOTrainItem).canFull()) (_arrItems[_activeItemIndex] as WOTrainItem).fullIt();
        (_arrItems[_activeItemIndex] as WOTrainItem).onClickHelpMePls(false);
        g.server.updateTrainPackGetHelp(int((_arrItems[_activeItemIndex] as WOTrainItem).trainDbId),'0', null);
        _train.needHelp(false, _activeItemIndex);
        _btnHelp.visible = false;
        var b:Boolean = true;
        for (var i:int = 0; i < _arrItems.length; i ++) {
            if ((_arrItems[i] as WOTrainItem).needHelp) {
                b = false;
                break;
            }
        }
        if (b) _train.showBubleHelp(false);
        updateItems();
        _btnLoad.visible = false;
        checkBtn();
    }

    private function updateItems():void {
        for (var i:int=0; i<_arrItems.length; i++) {
            (_arrItems[i] as WOTrainItem).updateIt();
        }
    }

    private function checkBtn():void {
        if (g.isAway) { _btnSendBasket.setEnabled = false;  return; }
        _countNotFullItems = 0;
        for (var i:int = 0; i < _arrItems.length; i++) {
            if (!_isBigCount && i%4==3) continue;
            if (!(_arrItems[i] as WOTrainItem).isResourceLoaded) _countNotFullItems++;
        }
        if (_countNotFullItems == 0 || !_isBigCount && _countNotFullItems == 9 || _isBigCount && _countNotFullItems == 12) _btnSendBasket.setEnabled = true;
            else _btnSendBasket.setEnabled = false;
        if (_countNotFullItems == 0) (_train as Train).setTrainFull = true;
    }

    private function sendFullTrain(b:Boolean = false):void {
        if (g.managerCutScenes.isCutScene) return;
        if (!_isBigCount && _countNotFullItems == 9 || _isBigCount && _countNotFullItems == 12) (_train as Train).fullTrain(false);
            else if (_countNotFullItems == 0) (_train as Train).fullTrain(true);
        super.hideIt();
    }

    public function getBoundsProperties(type:String):Object {
        var obj:Object = {};
        var p:Point = new Point();
        switch (type) {
            case 'firstItem':
                p.x = -_woWidth/2 + 40;
                p.y = -_woHeight/2 + 207;
                p = _source.localToGlobal(p);
                obj.x = p.x;
                obj.y = p.y;
                obj.width = 138;
                obj.height = 123;
                break;
            case 'loadBtn':
                p.x = -_woWidth/2 + 687;
                p.y = -_woHeight/2 + 386;
                p = _source.localToGlobal(p);
                obj.x = p.x;
                obj.y = p.y;
                obj.width = 92;
                obj.height = 36;
                break;
            case 'priseCont':
                p.x = -_woWidth/2 + 667;
                p.y = -_woHeight/2 + 541;
                p = _source.localToGlobal(p);
                obj.x = p.x;
                obj.y = p.y;
                obj.width = 247;
                obj.height = 48;
                break;
            case 'mainLoadBtn':
                p.x = -_woWidth/2 + 721;
                p.y = -_woHeight/2 + 588;
                p = _source.localToGlobal(p);
                obj.x = p.x;
                obj.y = p.y;
                obj.width = 166;
                obj.height = 82;
                break;
        }
        return obj;
    }

    private function checkSocialInfoForArray():void {
        var userIds:Array = [];
        var p:Someone;

        for (var i:int=0; i < _arrItems.length; i++) {
            if (int(_arrItems[i].idWhoHelp) != 0) {
                p = g.user.getSomeoneBySocialId(_arrItems[i].idWhoHelp);
                if (!p.photo && userIds.indexOf(_arrItems[i].idWhoHelp) == -1) userIds.push(_arrItems[i].idWhoHelp);
                else if (p.photo) userIds.push(_arrItems[i].idWhoHelp);
            }
        }
        if (userIds.length) {
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingInfo);
            g.socialNetwork.getTempUsersInfoById(userIds);
        }
    }

    private function onGettingInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingInfo);
        for (var i:int = 0; i < _arrItems.length; i++) {
            if (int(_arrItems[i].idWhoHelp) != 0)  (_arrItems[i] as WOTrainItem).updateAvatar();
        }
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        g.gameDispatcher.removeFromTimer(checkCounter);
        for (var i:int=0; i<_arrItems.length; i++) {
            _source.removeChild(_arrItems[i].source);
            (_arrItems[i] as WOTrainItem).deleteIt();
        }
        _arrItems.length = 0;
        _train = null;
        _source.removeChild(_sensCoupone);
        _sensCoupone.deleteIt();
        _source.removeChild(_sensMoney);
        _sensMoney.deleteIt();
        _source.removeChild(_sensMoneyItem);
        _sensMoneyItem.deleteIt();
        _source.removeChild(_sensXP);
        _sensXP.deleteIt();
        _source.removeChild(_sensXPItem);
        _sensXPItem.deleteIt();
        _source.removeChild(_txt1);
        _txt1.deleteIt();
        _source.removeChild(_txt2);
        _txt2.deleteIt();
        _source.removeChild(_txt3);
        _txt3.deleteIt();
        _source.removeChild(_txt4);
        _txt4.deleteIt();
        _source.removeChild(_txtTimer);
        _txtTimer.deleteIt();
        _source.removeChild(_txtWindowName);
        _txtWindowName.deleteIt();
        _source.removeChild(_btnLoad);
        _btnLoad.deleteIt();
        _source.removeChild(_btnSendBasket);
        _btnSendBasket.deleteIt();
        _source.removeChild(_btnHelp);
        _btnHelp.deleteIt();
        _source.removeChild(_milkBG);
        _milkBG.deleteIt();
        _source.removeChild(_yellowBG);
        _yellowBG.deleteIt();
        super.deleteIt();
    }

}
}