/**
 * Created by user on 6/24/15.
 */
package windows.shop {
import build.WorldObject;
import build.decor.DecorFenceArka;
import build.decor.DecorFenceGate;
import build.decor.DecorPostFenceArka;
import build.fabrica.Fabrica;
import build.farm.Farm;
import build.tree.Tree;
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import data.StructureDataAnimal;

import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;

import quest.ManagerQuest;

import resourceItem.UseMoneyMessage;
import com.greensock.easing.Quad;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CTextField;
import utils.SimpleArrow;
import tutorial.TutorialAction;
import tutorial.managerCutScenes.ManagerCutScenes;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import utils.Utils;
import utils.Utils;

import windows.WOComponents.CartonBackgroundIn;
import windows.WindowsManager;
import windows.shop.decorRadioButton.DecorRadioButton;

public class ShopItem {
    public var source:CSprite;
    private var _hand:CSprite;
    private var _im:Image;
    private var _imCont:Sprite;
    private var _nameTxt:CTextField;
    private var _countTxt:CTextField;
    private var _countBoxTxt:CTextField;
    private var _txtBtnYellow:CTextField;
    private var _txtLimit:CTextField;
    private var _data:Object;
    private var _lockedSprite:Sprite;
    private var _countCost:int;
    private var _state:int;
    private const STATE_FROM_INVENTORY:int = 1;
    private const STATE_BUY:int = 2;
    private var _btnBuyGreen:CButton;
    private var _btnBuyBlue:CButton;
    private var _btnBuyCoupone:CButton;
    private var _btnActivationYellow:CButton;
    private var _btnActivationPink:CButton;
    private var _txtBtnBuyBlue:CTextField;
    private var _txtBtnBuyGreen:CTextField;
    private var _txtAvailable:CTextField;
    private var _txtAvailablePink:CTextField;
    private var _shopLimitSprite:Sprite;
    private var _wo:WOShop;
    private var _bg:CartonBackgroundIn;
    private var _positionInList:int;
    private var _arrow:SimpleArrow;
    private var g:Vars = Vars.getInstance();
    private var _arrImages:Array; // use only for delete filters from images
    private var _radioButton:DecorRadioButton;

    public function ShopItem(data:Object, wo:WOShop, pos:int) {
        _arrImages = [];
        _positionInList = pos;
        _wo = wo;
        _data = data;
        source = new CSprite();
        if (!_data) {
            Cc.error('ShopItem:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'shopItem');
            return;
        }
        _bg = new CartonBackgroundIn(145, 221);
        source.addChild(_bg);

        _nameTxt = new CTextField(145, 60, '');
        _nameTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _nameTxt.y  = -10;
        _nameTxt.cacheIt = false;
        source.addChild(_nameTxt);

        _countTxt = new CTextField(145, 60, '');
        _countTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _countTxt.cacheIt = false;
        _countTxt.y = 120;
        source.addChild(_countTxt);
        _countTxt.visible = false;

        _countBoxTxt = new CTextField(120, 30, '');
        _countBoxTxt.setFormat(CTextField.BOLD18, 12, Color.YELLOW, ManagerFilters.BROWN_COLOR);
        _countBoxTxt.cacheIt = false;
        _countBoxTxt.y = 118;
        _countBoxTxt.x = 15;
        source.addChild(_countBoxTxt);
        _countBoxTxt.visible = false;

        _txtAvailable = new CTextField(145, 80, '');
        _txtAvailable.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtAvailable.cacheIt = false;
        _txtAvailable.y = 145;
        source.addChild(_txtAvailable);
        _txtAvailable.visible = false;
        _hand = new CSprite();
        _hand.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[339])); };
        _hand.outCallback = function():void { g.hint.hideIt(); };
        source.addChild(_hand);
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('animated_decor'));
        im.x = 100;
        im.y = 60;
        _hand.addChild(im);
        _hand.visible = false;
        source.endClickCallback = onClick;
        setInfo();

        _data.buildType = int(_data.buildType);
        if (_data.group && _data.blockByLevel[0] <= g.user.level && (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_ANIMATION)) {
            var arr:Array = g.allData.getGroup(_data.group);
            if (arr.length > 1) {
                _radioButton = new DecorRadioButton(source, onClickRadioButton);
                for (var i:int=0; i<arr.length; i++) {
                    _radioButton.addItem(Utils.objectFromStructureBuildToObject(arr[i]));
                }
                _radioButton.calculatePositions();
            }
        }
    }

    private function onClickRadioButton(activeItemData:Object):void {
        source.removeChild(_imCont);
        _imCont.removeChild(_im);
        _imCont.dispose();
        _im.dispose();
        _imCont = null;
        _im = null;
        if (_btnBuyGreen) {
            source.removeChild(_btnBuyGreen);
            _btnBuyGreen.deleteIt();
            _btnBuyGreen = null;
        }
        if (_btnBuyBlue) {
            source.removeChild(_btnBuyBlue);
            _btnBuyBlue.deleteIt();
            _btnBuyBlue = null;
        }
        if (_btnBuyCoupone) {
            source.removeChild(_btnBuyCoupone);
            _btnBuyCoupone.deleteIt();
            _btnBuyCoupone = null;
        }
        if (_btnActivationYellow) {
            source.removeChild(_btnActivationYellow);
            _btnActivationYellow.deleteIt();
            _btnActivationYellow = null;
        }
        if (_btnActivationPink) {
            source.removeChild(_btnActivationPink);
            _btnActivationPink.deleteIt();
            _btnActivationPink = null;
        }
        if (_countBoxTxt) {
            _countBoxTxt.text = ' ';
        }
        _data = activeItemData;
        setInfo();
    }

    public function get position():int {
        return _positionInList;
    }

    private function createLockedSprite():void {
        if (_lockedSprite) return;
        _lockedSprite = new Sprite();
        _lockedSprite.touchable = false;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_lock'));
        _lockedSprite.addChild(im);
        _lockedSprite.x = 1;
        _lockedSprite.y = 75;
        source.addChild(_lockedSprite);
    }

    private function createShopLimitSprite():void {
        if (_shopLimitSprite) return;
        _shopLimitSprite = new Sprite();
        _shopLimitSprite.touchable = false;
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_window_limit'));
        im.x = -7;
        _shopLimitSprite.addChild(im);
        _txtLimit = new CTextField(145, 26, String(g.managerLanguage.allTexts[340]));
        _txtLimit.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtLimit.cacheIt = false;
        _txtLimit.y = 33;
        _shopLimitSprite.addChild(_txtLimit);
        _shopLimitSprite.y = 150;
        source.addChild(_shopLimitSprite);
    }

    private function createButtons(type:String):void {
        var im:Image;
        switch (type) {
            case 'blue':
                if (_btnBuyBlue) return;
                _btnBuyBlue = new CButton();
                _btnBuyBlue.addButtonTexture(126, 40, CButton.BLUE, true);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_medium'));
                MCScaler.scale(im, 35, 35);
                im.x = 85;
                im.y = 4;
                _btnBuyBlue.addChild(im);
                im.filter = ManagerFilters.SHADOW_TINY;
                _arrImages.push(im);
                _txtBtnBuyBlue = new CTextField(85, 40, '');
                _txtBtnBuyBlue.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                _txtBtnBuyBlue.cacheIt = false;    
                _btnBuyBlue.addChild(_txtBtnBuyBlue);
                _btnBuyBlue.x = 74;
                _btnBuyBlue.y = 190;
                _btnBuyBlue.clickCallback = onClick;
                source.addChild(_btnBuyBlue);
                break;
            case 'green':
                if (_btnBuyGreen) return;
                _btnBuyGreen = new CButton();
                _btnBuyGreen.addButtonTexture(126, 40, CButton.GREEN, true);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_medium'));
                MCScaler.scale(im, 35, 35);
                im.x = 85;
                im.y = 4;
                _btnBuyGreen.addChild(im);
                im.filter = ManagerFilters.SHADOW_TINY;
                _arrImages.push(im);    
                _txtBtnBuyGreen = new CTextField(85, 40, '');
                _txtBtnBuyGreen.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR); 
                _txtBtnBuyGreen.cacheIt = false;    
                _btnBuyGreen.addChild(_txtBtnBuyGreen);
                _btnBuyGreen.x = 74;
                _btnBuyGreen.y = 190;
                _btnBuyGreen.clickCallback = onClick;
                source.addChild(_btnBuyGreen);
                break;
            case 'yellow':
                if (_btnActivationYellow) return;
                _btnActivationYellow = new CButton();
                _btnActivationYellow.addButtonTexture(126, 40, CButton.YELLOW, true);
                _txtBtnYellow = new CTextField(125, 40, String(g.managerLanguage.allTexts[341]));
                _txtBtnYellow.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.YELLOW_COLOR);
                _txtBtnYellow.cacheIt = false;    
                _btnActivationYellow.addChild(_txtBtnYellow);
                _btnActivationYellow.x = 74;
                _btnActivationYellow.y = 190;
                _btnActivationYellow.clickCallback = onClick;
                source.addChild(_btnActivationYellow);
                break;
            case 'pink':
                if (_btnActivationPink) return;
                _btnActivationPink = new CButton();
                _btnActivationPink.addButtonTexture(126, 40, CButton.PINK, true);
                _txtAvailablePink = new CTextField(125, 40, String(g.managerLanguage.allTexts[341]));
                _txtAvailablePink.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.YELLOW_COLOR);
                _txtAvailablePink.cacheIt = false;
                _btnActivationPink.addChild(_txtAvailablePink);
                _btnActivationPink.x = 74;
                _btnActivationPink.y = 190;
                _btnActivationPink.clickCallback = onClick;
                source.addChild(_btnActivationPink);
                break;
        }
    }

    private function createCouponeButtons():void {
        var txt:CTextField;
        var im:Image;
        var i:int;
        _btnBuyCoupone = new CButton();
        if (_data.currency.length == 3){
            _btnBuyCoupone.addButtonTexture(136, 40, CButton.GREEN, true);
        } else {
            _btnBuyCoupone.addButtonTexture(126, 40, CButton.GREEN, true);
        }
        for (i = 0; i <_data.currency.length; i++) {
            txt = new CTextField(85, 40, String(_data.cost[i]));
            txt.cacheIt = false;
            txt.setFormat(CTextField.BOLD18, 18, Color.WHITE);
            switch (_data.currency[i]) {
                case DataMoney.BLUE_COUPONE:
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone'));
                    MCScaler.scale(im, 30, 30);
                    im.filter = ManagerFilters.SHADOW_TINY;
                    _arrImages.push(im);    
                    _btnBuyCoupone.addChild(im);
                    _btnBuyCoupone.addChild(txt);
                    break;
                case DataMoney.GREEN_COUPONE:
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone'));
                    MCScaler.scale(im, 30, 30);
                    im.filter = ManagerFilters.SHADOW_TINY;
                    _arrImages.push(im);    
                    _btnBuyCoupone.addChild(im);
                    _btnBuyCoupone.addChild(txt);
                    break;
                case DataMoney.RED_COUPONE:
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone'));
                    MCScaler.scale(im, 30, 30);
                    im.filter = ManagerFilters.SHADOW_TINY;
                    _arrImages.push(im);    
                    _btnBuyCoupone.addChild(im);
                    _btnBuyCoupone.addChild(txt);
                    break;
                case DataMoney.YELLOW_COUPONE:
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone'));
                    MCScaler.scale(im, 30, 30);
                    im.filter = ManagerFilters.SHADOW_TINY;
                    _arrImages.push(im);    
                    _btnBuyCoupone.addChild(im);
                    _btnBuyCoupone.addChild(txt);
                    break;
            }
            im.y = 4;
            im.x = (50 * i) + 35;
            txt.x = (50 * i) - 20;
        }

        if (_data.currency.length == 1) {
            im.x = 85;
            im.y = 4;
            txt.x = 0;
            _countCost = _data.cost;
        }
        _btnBuyCoupone.x = 74;
        _btnBuyCoupone.y = 190;
        source.addChild(_btnBuyCoupone);
        _btnBuyCoupone.clickCallback = onClick;
    }

    private function setInfo():void {
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture) {
                if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_POST_FENCE || _data.buildType == BuildType.DECOR_FENCE_ARKA
                        || _data.buildType == BuildType.DECOR_FENCE_GATE || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.TREE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA)
                    texture = g.allData.atlas[_data.url].getTexture(_data.image);
                else texture = g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon');
            }
            if (!texture) {
                Cc.error('ShopItem:: no such texture: ' + _data.url + ' for _data.id ' + _data.id);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'shopItem');
                return;
            }
            _im = new Image(texture);
            MCScaler.scale(_im, 120, 120);
            _imCont = new Sprite();
            _im.x = - _im.width / 2;
            _im.y = - _im.height / 2;
            _imCont.addChild(_im);
            _imCont.x = 72;
            _imCont.y = 90;
            source.addChildAt(_imCont, 1);
        } else {
            Cc.error('ShopItem:: no image in _data for _data.id: ' + _data.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'shopItem');
        }
        if (_data.buildType == BuildType.CAT) {
            if (g.catPanel.catBuing) {
                if (g.managerCats.curCountCats+1 < g.managerCats.maxCountCats) {
                    _countCost = g.dataCats[g.managerCats.curCountCats+1].cost;
                    _data.cost = _countCost;
                }
            } else {
                if (g.managerCats.curCountCats < g.managerCats.maxCountCats) {
                    _countCost = g.dataCats[g.managerCats.curCountCats].cost;
                    _data.cost = _countCost;
                }
            }
        } else {
            _countCost = _data.cost;
        }
        if ((_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_ANIMATION || _data.buildType == BuildType.DECOR_FULL_FENСE
                || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_FENCE_ARKA || _data.buildType == BuildType.DECOR_FENCE_GATE
                || _data.buildType == BuildType.DECOR_POST_FENCE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA)
                && g.userInventory.decorInventory[_data.id]) {
            _state = STATE_FROM_INVENTORY;
            _countCost = 0;
            if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
            else _nameTxt.text = String(_data.name);
           createButtons('yellow');
        } else {
            _state = STATE_BUY;
        }
        checkState();
    }

    private function checkState():void {
        var arr:Array;
        var i:int;
        var maxCount:int;
        var curCount:int;
        var im:Image;
        var maxCountAtCurrentLevel:int = 0;
        _nameTxt.text = '';
        _countTxt.text = '';
        _countBoxTxt.text = '';
        var myPattern:RegExp = /count/;
        var str:String =  String(g.managerLanguage.allTexts[342]);

        if (!_data) return;
        if (_data.buildType == BuildType.FABRICA ) {
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                _txtAvailable.visible = true;
                _txtAvailable.text = String(str.replace(myPattern, String(_data.blockByLevel[0])));
                _im.filter = ManagerFilters.getButtonDisableFilter();
                if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                else _nameTxt.text = String(_data.name);
            } else {
                arr = g.townArea.getCityObjectsById(_data.id);
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                        _countCost = _data.cost[i];
                    } else break;
                }
                if (arr.length == _data.blockByLevel.length) {
                    createShopLimitSprite();
                    _im.filter = ManagerFilters.getButtonDisableFilter();
                    if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                    else _nameTxt.text = String(_data.name);
                    _countTxt.visible = true;
                    _countTxt.text = String(maxCountAtCurrentLevel) + '/' + String(maxCountAtCurrentLevel);
                } else if (arr.length >= maxCountAtCurrentLevel) {
                    if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                    else _nameTxt.text = String(_data.name);
                    _txtAvailable.visible = true;
                    _txtAvailable.text = String(str.replace(myPattern, String(_data.blockByLevel[maxCountAtCurrentLevel])));
                    _countTxt.visible = true;
                    _countTxt.text = String(arr.length) + '/' + String(_data.blockByLevel.length);
                    _im.filter = ManagerFilters.getButtonDisableFilter();
                } else {
                    if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                    else _nameTxt.text = String(_data.name);
                    _countTxt.visible = true;
                    _countTxt.text = String(arr.length) + '/' + String(maxCountAtCurrentLevel);
                    if (g.user.allNotification > 0 && g.user.fabricaNotification > 0 && g.user.level == _data.blockByLevel[maxCountAtCurrentLevel-1]) {
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
                        im.x = 102;
                        source.addChild(im);
                        if(!g.managerTutorial.isTutorial && !g.managerCutScenes.isCutScene) addArrow(3);
                    }
                    createButtons('blue');
                    _txtBtnBuyBlue.text = String(_countCost);
                }
            }
        } else if (_data.buildType == BuildType.FARM) {
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                _txtAvailable.visible = true;
                _txtAvailable.text = String(str.replace(myPattern, String(_data.blockByLevel[0])));
                _im.filter = ManagerFilters.getButtonDisableFilter();
                if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                else _nameTxt.text = String(_data.name);
            } else {
                arr = g.townArea.getCityObjectsById(_data.id);
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                if (arr.length >= maxCountAtCurrentLevel) {
                    if (g.user.level < _data.blockByLevel[arr.length]) {
                        _txtAvailable.visible = true;
                        _txtAvailable.text = String(str.replace(myPattern, String(_data.blockByLevel[arr.length])));
                        _im.filter = ManagerFilters.getButtonDisableFilter();
                        if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                        else _nameTxt.text = String(_data.name);
                    } else {
                        createShopLimitSprite();
                        _im.filter = ManagerFilters.getButtonDisableFilter();
                        if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                        else _nameTxt.text = String(_data.name);
                        _countTxt.visible = true;
                        _countTxt.text = String(maxCountAtCurrentLevel) + '/' + String(maxCountAtCurrentLevel);
                    }
                } else {
                    if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                    else _nameTxt.text = String(_data.name);
                    _countTxt.visible = true;
                    _countTxt.text = String(arr.length) + '/' + String(maxCountAtCurrentLevel);
                    createButtons('blue');
                    if (g.user.allNotification > 0 && g.user.villageNotification > 0 && g.user.level == _data.blockByLevel[maxCountAtCurrentLevel-1]) {
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
                        im.x = 102;
                        source.addChild(im);
                        if(!g.managerTutorial.isTutorial && !g.managerCutScenes.isCutScene) addArrow(3);

                    }
                    _txtBtnBuyBlue.text = String(_countCost);
                }
            }
        } else if (_data.buildType == BuildType.DECOR_ANIMATION || _data.buildType == BuildType.DECOR ||  _data.buildType == BuildType.DECOR_FULL_FENСE
                || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE || _data.buildType == BuildType.DECOR_FENCE_ARKA
                || _data.buildType == BuildType.DECOR_FENCE_GATE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA) {
            var decorMax:int = 0;
            if (_data.blockByLevel) {
                if ( _data.buildType == BuildType.DECOR_ANIMATION) {
                    _hand.visible = true;
                }
                if (_data.buildType == BuildType.DECOR_TAIL) {
                    arr = g.townArea.getCityTailObjectsById(_data.id);
                } else {
                    arr = g.townArea.getCityObjectsById(_data.id);
                }
                if (_data.color != null) {
                    decorMax =  g.townArea.getMaxCountDecorColorObjectsByGroup(_data.group);
                }

                if (_data.blockByLevel[0] > g.user.level) {
                    _txtAvailable.visible = true;
                    _txtAvailable.text =  String(str.replace(myPattern, String(_data.blockByLevel[0])));
                    _im.filter = ManagerFilters.getButtonDisableFilter();
                    if (_data.buildType == BuildType.DECOR_ANIMATION) {
                        _hand.filter = ManagerFilters.getButtonDisableFilter();
                    }
                    if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                    else _nameTxt.text = String(_data.name);
                } else {
                    if (_state == STATE_FROM_INVENTORY) {
                        _countCost = 0;
                        if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                        else _nameTxt.text = String(_data.name);
                        _countBoxTxt.visible = true;
                        _countBoxTxt.text = String(g.managerLanguage.allTexts[344]) + ' ' + String(g.userInventory.decorInventory[_data.id].count);
                        if (decorMax >= arr.length) _countCost = (decorMax * _data.deltaCost) + int(_data.cost);
                        else  _countCost = (arr.length * _data.deltaCost) + int(_data.cost);
                        createButtons('yellow');
                    } else {
                        if (g.user.allNotification > 0 && g.user.decorNotification > 0 && g.user.level == _data.blockByLevel[0]) {
                            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
                            im.x = 102;
                            source.addChild(im);
                            if(!g.managerTutorial.isTutorial && !g.managerCutScenes.isCutScene) addArrow(3);

                        }
                        if (decorMax >= arr.length) _countCost = (decorMax * _data.deltaCost) + int(_data.cost);
                        else  _countCost = (arr.length * _data.deltaCost) + int(_data.cost);
                        if(_data.currency[0] == DataMoney.SOFT_CURRENCY) {
                            createButtons('blue');
                            _txtBtnBuyBlue.text = String(_countCost);
                        } else if(_data.currency[0] == DataMoney.HARD_CURRENCY) {
                            _countCost = _data.cost;
                            createButtons('green');
                            _txtBtnBuyGreen.text = String(_countCost);
                        } else {
                            createCouponeButtons();
                        }
                        if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                        else _nameTxt.text = String(_data.name);
                    }
                }
            }
        } else if (_data.buildType == BuildType.ANIMAL) {
            var dataFarm:Object = Utils.objectFromStructureBuildToObject(g.allData.getBuildingById(_data.buildId));
            if (dataFarm && dataFarm.blockByLevel) {
                if (g.user.level < dataFarm.blockByLevel[0]) {
//                    createLockedSprite();
                    _txtAvailable.visible = true;
                    _txtAvailable.text = String(str.replace(myPattern, String(dataFarm.blockByLevel[0])));
                    _im.filter = ManagerFilters.getButtonDisableFilter();
                    if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                    else _nameTxt.text = String(_data.name);
                } else {
                    arr = g.townArea.getCityObjectsById(dataFarm.id);
                    maxCount = arr.length * dataFarm.maxAnimalsCount;
                    curCount = 0;
                    for (i=0; i<arr.length; i++) {
                        curCount += (arr[i] as Farm).arrAnimals.length;
                    }

                    if (maxCount == curCount) {
                        if (_btnBuyBlue) {
                            source.removeChild(_btnBuyBlue);
                            _btnBuyBlue.deleteIt();
                            _btnBuyBlue = null;
                        }
                        if (g.user.level >= dataFarm.blockByLevel[arr.length-1]) {
                            createShopLimitSprite();
                            _im.filter = ManagerFilters.getButtonDisableFilter();
                            if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                            else _nameTxt.text = String(_data.name);
                            _countTxt.visible = true;
                            _countTxt.text = String(maxCount) + '/' + String(maxCount);
                            _countCost = 0;
                        } else {
                            _txtAvailable.visible = true;
                            _txtAvailable.text = String(g.managerLanguage.allTexts[345]) + ' ' + String(dataFarm.name);
                            _im.filter = ManagerFilters.getButtonDisableFilter();
                            if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                            else _nameTxt.text = String(_data.name);
                        }
                    } else {
                        createButtons('blue');
                        if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                        else _nameTxt.text = String(_data.name);
                        _countTxt.visible = true;
                        _countTxt.text = String(curCount) + '/' + String(maxCount);
                        if (curCount == 0) _txtBtnBuyBlue.text = _data.costNew[0];
                        else _txtBtnBuyBlue.text = _data.costNew[curCount];
                        _countCost = int(_txtBtnBuyBlue.text);
//                        if (curCount < dataFarm.maxAnimalsCount) {
//                            _txtBtnBuyBlue.text = _data.cost;
//                        } else if (curCount < 2*dataFarm.maxAnimalsCount) {
//                            _txtBtnBuyBlue.text = _data.cost2;
//                        } else {
//                            _txtBtnBuyBlue.text = _data.cost3;
//                        }
                    }
                }
            }
        } else if (_data.buildType == BuildType.TREE) {
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
//                createLockedSprite();
                _txtAvailable.visible = true;
                _txtAvailable.text = String(str.replace(myPattern, String(_data.blockByLevel[0])));
                _im.filter = ManagerFilters.getButtonDisableFilter();
            } else {
                arr = g.townArea.getCityTreeById(_data.id, true);
                curCount = arr.length;
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                maxCount = maxCountAtCurrentLevel * _data.countUnblock;
                if (curCount >= maxCount) {
                    createShopLimitSprite();
                    _im.filter = ManagerFilters.getButtonDisableFilter();
                    if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                    else _nameTxt.text = String(_data.name);
                    _countTxt.visible = true;
                    _countTxt.text = String(maxCount) + '/' + String(maxCount);
                } else {
                    if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                    else _nameTxt.text = String(_data.name);
                    _countTxt.visible = true;
                    _countTxt.text = String(curCount) + '/' + String(maxCount);
                    createButtons('blue');
                    if (g.user.allNotification > 0 && g.user.plantNotification > 0 && g.user.level == _data.blockByLevel[maxCountAtCurrentLevel-1]) {
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
                        im.x = 102;
                        source.addChild(im);
                        if (!g.managerTutorial.isTutorial && !g.managerCutScenes.isCutScene) addArrow(3);
                    }
                    _txtBtnBuyBlue.text = String(_countCost);
                }
            }
        } else if (_data.buildType == BuildType.RIDGE) {
            if (_data.blockByLevel) {
                arr = g.townArea.getCityObjectsById(_data.id);
                curCount = arr.length;
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                maxCount = maxCountAtCurrentLevel * _data.countUnblock;
                if (curCount >= maxCount) {
                    createShopLimitSprite();
                    _im.filter = ManagerFilters.getButtonDisableFilter();
                    if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                    else _nameTxt.text = String(_data.name);
                    _countTxt.visible = true;
                    _countTxt.text = String(maxCount) + '/' + String(maxCount);
                } else {
                    if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                    else _nameTxt.text = String(_data.name);
                    _countTxt.visible = true;
                    _countTxt.text = String(curCount) + '/' + String(maxCount);
                    createButtons('blue');
                    if (g.user.allNotification > 0 && g.user.villageNotification > 0 && g.user.level == _data.blockByLevel[maxCountAtCurrentLevel-1]) {
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
                        im.x = 102;
                        source.addChild(im);
                        if (!g.managerTutorial.isTutorial && !g.managerCutScenes.isCutScene) addArrow(3);
                    }
                    _txtBtnBuyBlue.text = String(_countCost);
                }
            }
        } else if (_data.buildType == BuildType.CAT) {
            if (g.catPanel.catBuing) curCount = g.managerCats.curCountCats +1 ;
            else curCount = g.managerCats.curCountCats;
            maxCount = g.managerCats.maxCountCats;
            if (curCount >= maxCount) {
                createShopLimitSprite();
                _im.filter = ManagerFilters.getButtonDisableFilter();
                if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                else _nameTxt.text = String(_data.name);
                _countTxt.visible = true;
                _countTxt.text = String(maxCount) + '/' + String(maxCount);
            } else {
                if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                else _nameTxt.text = String(_data.name);
                _countTxt.visible = true;
                _countTxt.text = String(curCount) + '/' + String(maxCount);
                var b:Boolean;
                for (i = 0; i <g.dataCats.length; i++) {
                    if (g.dataCats[i].blockByLevel[0] == g.user.level) {
                        b = true;
                        break;
                    } else b = false;
                }
                createButtons('blue');
                _txtBtnBuyBlue.text = String(_countCost);
                if (g.user.allNotification > 0 && g.user.villageNotification > 0 && b) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
                    im.x = 102;
                    source.addChild(im);
                    if(!g.managerTutorial.isTutorial && !g.managerCutScenes.isCutScene) addArrow(3);
                }
            }
        }
        if (_data.visibleTester) {
            if (_btnBuyGreen) {
                source.removeChild(_btnBuyGreen);
                _btnBuyGreen.deleteIt();
                _btnBuyGreen = null;
            }
            if (_btnBuyBlue) {
                source.removeChild(_btnBuyBlue);
                _btnBuyBlue.deleteIt();
                _btnBuyBlue = null;
            }
            if (_btnBuyCoupone) {
                source.removeChild(_btnBuyCoupone);
                _btnBuyCoupone.deleteIt();
                _btnBuyCoupone = null;
            }
            if (_btnActivationYellow) {
                source.removeChild(_btnActivationYellow);
                _btnActivationYellow.deleteIt();
                _btnActivationYellow = null;
            }
            createButtons('pink');
            _countCost = 0;
        }
        if (_nameTxt.text == '') {
            if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
            else _nameTxt.text = String(_data.name);
        }
    }

    private function onClick():void {
        if (_data.buildType == BuildType.ANIMAL && g.managerTutorial.isTutorial) {
            if (g.managerTutorial.currentAction != TutorialAction.BUY_ANIMAL) return;
            if (!g.managerTutorial.isTutorialResource(_data.id)) return;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _wo.onClickItemClose();
        var i:int;
        if (_shopLimitSprite) return;
        if (_txtAvailable.visible) {
            if (_data.blockByLevel) {
                for (i = 0; i < _data.blockByLevel.length; i++) {
                    if (g.user.level < _data.blockByLevel[i]) {
                        var p:Point = new Point(source.x, source.y);
                        p = source.parent.localToGlobal(p);
                        new FlyMessage(p, String(g.managerLanguage.allTexts[346 ]) + " " + String(_data.blockByLevel[i]) + " " + String(g.managerLanguage.allTexts[343]));
                        return;
                    }
                }
            } else return;
        }
        if (_data.buildType == BuildType.CAT) {
            if (g.catPanel.catBuing) _countCost = g.dataCats[g.managerCats.curCountCats+1].cost;
            else _countCost = g.dataCats[g.managerCats.curCountCats].cost;
            _data.cost = _countCost;
        }
        if (g.managerMiniScenes.isMiniScene) g.managerMiniScenes.deleteArrowAndDust();
        var ob:Object;
        if ((_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_ANIMATION || _data.buildType == BuildType.DECOR_FULL_FENСE
                || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE || _data.buildType == BuildType.DECOR_FENCE_GATE
                || _data.buildType == BuildType.DECOR_FENCE_ARKA || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA) && _state != STATE_FROM_INVENTORY) {
            if (g.managerTutorial.isTutorial) return;
            if (g.managerCutScenes.isCutScene) {
                if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_BUY_DECOR) && g.managerCutScenes.isCutSceneResource(_data.id)) {
                    g.managerCutScenes.checkCutSceneCallback();
                } else return;
            }
            if (_data.currency.length == 1) {
                if (_data.currency == DataMoney.SOFT_CURRENCY) {
                    if (g.user.softCurrencyCount < _countCost) {
                        ob = {};
                        ob.currency = DataMoney.SOFT_CURRENCY;
                        ob.count = _countCost - g.user.softCurrencyCount;
                        ob.cost = _countCost;
                        ob.data = _data;
//                        g.windowsManager.cashWindow = _wo;
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, noResourceCallback, 'money', ob);
                        return;
                    }
                } else if (_data.currency == DataMoney.HARD_CURRENCY) {
                    if (g.user.hardCurrency < _countCost) {
//                        g.windowsManager.cashWindow = _wo;
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
                        return;
                    }
                } else if (_data.currency == DataMoney.BLUE_COUPONE && g.user.blueCouponCount < _countCost) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                    return;
                } else if (_data.currency == DataMoney.RED_COUPONE && g.user.redCouponCount < _countCost) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                    return;
                } else if (_data.currency == DataMoney.GREEN_COUPONE && g.user.greenCouponCount < _countCost) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                        return;
                } else if (_data.currency == DataMoney.YELLOW_COUPONE && g.user.yellowCouponCount < _countCost) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                    return;
                }
            } else {
                for (i = 0; i < _data.currency.length; i++) {
                    if (_data.currency[i] == DataMoney.BLUE_COUPONE && g.user.blueCouponCount < _data.cost[i]) {
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                        return;
                    } else if (_data.currency[i] == DataMoney.RED_COUPONE && g.user.redCouponCount < _data.cost[i]) {
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                        return;
                    } else if (_data.currency[i] == DataMoney.GREEN_COUPONE && g.user.greenCouponCount < _data.cost[i]) {
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                        return;
                    } else if (_data.currency[i] == DataMoney.YELLOW_COUPONE && g.user.yellowCouponCount < _data.cost[i]) {
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                        return;
                    }
                }
            }
        } else {
            if (g.user.softCurrencyCount < _countCost){
                ob = {};
                ob.currency = DataMoney.SOFT_CURRENCY;
                ob.count = _countCost - g.user.softCurrencyCount;
                ob.cost = _countCost;
                ob.data = _data;
//                g.windowsManager.cashWindow = _wo;
                _wo.hideIt();
                g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, noResourceCallback, 'money', ob);
                return;
            }
        }
        if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE
            || _data.buildType == BuildType.DECOR_FENCE_ARKA || _data.buildType == BuildType.DECOR_FENCE_GATE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA) {
            if (_data.currency == DataMoney.SOFT_CURRENCY) {
                g.buyHint.showIt(_countCost);
            }
        }
        var build:WorldObject;
        if (_data.buildType == BuildType.RIDGE) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.NEW_RIDGE) return;
            build = g.townArea.createNewBuild(_data);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.ADD_NEW_RIDGE;
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE) {
                g.managerTutorial.checkTutorialCallback();
            }
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP);
            (build as WorldObject).countShopCost = _countCost;
            g.townArea.startMoveAfterShop(build);
        } else if (_data.buildType == BuildType.DECOR_TAIL) {
            if (g.managerTutorial.isTutorial) return;
            build = g.townArea.createNewBuild(_data);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP);
            if (_state == STATE_FROM_INVENTORY) {
                g.townArea.startMoveAfterShop(build, true);
                g.buyHint.hideIt();
            } else {
                (build as WorldObject).countShopCost = _countCost;
                g.townArea.startMoveAfterShop(build);
//                g.toolsModifier.startMoveTail(build, _countCost, true);
            }
        } else if (_data.buildType == BuildType.CAT) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.BUY_CAT) return;
            updateItem();
            g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -int(_data.cost));
//            showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(_data.cost));
            g.catPanel.catBuing = true;
            g.managerCats.onBuyCatFromShop();

            if (g.managerTips) g.managerTips.calculateAvailableTips();
        } else if (_data.buildType != BuildType.ANIMAL) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.BUY_FABRICA && g.managerTutorial.currentAction != TutorialAction.BUY_FARM) return;
            build = g.townArea.createNewBuild(_data);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            if(_data.buildType == BuildType.FARM) {
                _wo.setAnimalClick = true;
                var an:StructureDataAnimal = g.allData.getAnimalByFarmId(_data.id);
                if (an) g.user.animalIdArrow = an.id;
            }
            if (build is Tree) (build as Tree).showShopView();
            if (build is Fabrica) (build as Fabrica).showShopView();
            if (build is DecorFenceGate) (build as DecorFenceGate).showFullView();
            if (build is DecorFenceArka) (build as DecorFenceArka).showFullView();
            if (build is DecorPostFenceArka) (build as DecorPostFenceArka).showFullView();
            if (g.managerTutorial.isTutorial) {
                if (g.managerTutorial.currentAction == TutorialAction.BUY_FABRICA && g.managerTutorial.isTutorialResource(_data.id)) {
                    g.managerTutorial.checkTutorialCallback();
                } else if (g.managerTutorial.currentAction == TutorialAction.BUY_FARM && g.managerTutorial.isTutorialResource(_data.id)) {
                    g.managerTutorial.checkTutorialCallback();
                }
            }
            if (_state == STATE_FROM_INVENTORY) {
                g.townArea.startMoveAfterShop(build, true);
                g.buyHint.hideIt();
            } else {
                (build as WorldObject).countShopCost = _countCost;
                g.townArea.startMoveAfterShop(build);
//                g.toolsModifier.startMove(build, _countCost, true);
            }
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP);
        } else {
            if (g.managerTutorial.isTutorial) {
                if (g.managerTutorial.currentAction != TutorialAction.BUY_ANIMAL) return;
                if (!g.managerTutorial.isTutorialResource(_data.id)) return;
            }
            //додаємо на відповідну ферму
            var dataFarm:Object = Utils.objectFromStructureBuildToObject(g.allData.getBuildingById(_data.buildId));
            var curCount:int = 0;
            var arr:Array = g.townArea.cityObjects;
            var arrPat:Array = g.townArea.getCityObjectsById(dataFarm.id);
            for (i=0; i<arrPat.length; i++) {
                curCount += (arrPat[i] as Farm).arrAnimals.length;
            }
//            if (curCount < dataFarm.maxAnimalsCount) {
//                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(_data.cost));
//                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(_data.cost));
//            } else if (curCount < 2*dataFarm.maxAnimalsCount) {
//                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(_data.cost2));
//                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(_data.cost2));
//            } else {
//                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(_data.cost3));
//                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(_data.cost3));
//            }
            if (curCount == 0) {
                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(_data.costNew[0]));
                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(_data.costNew[0]));
            } else {
                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(_data.costNew[curCount]));
                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(_data.costNew[curCount]));
            }
            g.managerQuest.onActionForTaskType(ManagerQuest.BUY_ANIMAL, {id:(_data.id)});
            if (g.managerTutorial.isTutorial && g.managerTutorial.useNewTuts) {
                if (g.managerTutorial.currentAction == TutorialAction.BUY_ANIMAL && g.managerTutorial.isTutorialResource(_data.id)) {
                    g.managerTutorial.checkTutorialCallback();
                } else {
                    return;
                }
            }
            for (i = 0; i < arr.length; i++) {
                if (arr[i] is Farm  &&  arr[i].dataBuild.id == _data.buildId  &&  !arr[i].isFull) {
                    if (!g.managerTutorial.isTutorial || (g.managerTutorial.isTutorial && g.managerTutorial.useNewTuts)) {
                        (arr[i] as Farm).addAnimal();
                        g.bottomPanel.cancelBoolean(false);
                    } else {
                        (arr[i] as Farm).addAnimal();
                        checkState();
                        g.bottomPanel.cancelBoolean(false);
                        _wo.updateMoneyCounts();
                    }
                    break;
                }
            }
            if (g.managerTutorial.isTutorial && !g.managerTutorial.useNewTuts) {
                if (g.managerTutorial.currentAction == TutorialAction.BUY_ANIMAL && g.managerTutorial.isTutorialResource(_data.id)) {
                    g.managerTutorial.checkTutorialCallback();
                } else {
                    return;
                }
            }
        }
    }

    private function noResourceCallback(objectCallback:Object = null,countCost:int = 0):void {
        if(!objectCallback) return;
        var build:WorldObject;
        if (objectCallback.buildType == BuildType.RIDGE) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.NEW_RIDGE) return;
            build = g.townArea.createNewBuild(objectCallback);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.ADD_NEW_RIDGE;
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction == TutorialAction.NEW_RIDGE) {
                g.managerTutorial.checkTutorialCallback();
            }
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP);
            (build as WorldObject).countShopCost = countCost;
            g.townArea.startMoveAfterShop(build);
        } else if (objectCallback.buildType == BuildType.DECOR_TAIL) {
            if (g.managerTutorial.isTutorial) return;
            build = g.townArea.createNewBuild(objectCallback);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP);
            if (_state == STATE_FROM_INVENTORY) {
                g.townArea.startMoveAfterShop(build, true);
                g.buyHint.hideIt();
            } else {
                (build as WorldObject).countShopCost = countCost;
                g.townArea.startMoveAfterShop(build);
//                g.toolsModifier.startMoveTail(build, _countCost, true);
            }
        } else if (objectCallback.buildType == BuildType.CAT) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.BUY_CAT) return;
            g.managerCats.onBuyCatFromShop();
            g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -int(objectCallback.cost));
        } else if (objectCallback.buildType != BuildType.ANIMAL) {
            if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.BUY_FABRICA && g.managerTutorial.currentAction != TutorialAction.BUY_FARM) return;
            build = g.townArea.createNewBuild(objectCallback);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            if (objectCallback.buildType == BuildType.FARM) {
//                _wo.setAnimalClick = true;
            }
            if (build is Tree) (build as Tree).showShopView();
            if (build is Fabrica) (build as Fabrica).showShopView();
            if (g.managerTutorial.isTutorial) {
                if (g.managerTutorial.currentAction == TutorialAction.BUY_FABRICA && g.managerTutorial.isTutorialResource(objectCallback.id)) {
                    g.managerTutorial.checkTutorialCallback();
                } else if (g.managerTutorial.currentAction == TutorialAction.BUY_FARM && g.managerTutorial.isTutorialResource(objectCallback.id)) {
                    g.managerTutorial.checkTutorialCallback();
                }
            }
            if (_state == STATE_FROM_INVENTORY) {
                g.townArea.startMoveAfterShop(build, true);
                g.buyHint.hideIt();
            } else {
                (build as WorldObject).countShopCost = countCost;
                g.townArea.startMoveAfterShop(build);
//                g.toolsModifier.startMove(build, _countCost, true);
            }
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP);
        } else {
            if (g.managerTutorial.isTutorial) {
                if (g.managerTutorial.currentAction != TutorialAction.BUY_ANIMAL) return;
                if (!g.managerTutorial.isTutorialResource(objectCallback.id)) return;
            }
            //додаємо на відповідну ферму
            var dataFarm:Object = g.allData.getBuildingById(objectCallback.buildId);
            var curCount:int = 0;
            var arr:Array = g.townArea.cityObjects;
            var arrPat:Array = g.townArea.getCityObjectsById(dataFarm.id);
            for (var i:int = 0; i < arrPat.length; i++) {
                curCount += (arrPat[i] as Farm).arrAnimals.length;
            }
//            if (curCount < dataFarm.maxAnimalsCount) {
//                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(objectCallback.cost));
//                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -int(objectCallback.cost));
//            } else if (curCount < 2 * dataFarm.maxAnimalsCount) {
//                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(objectCallback.cost2));
//                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -int(objectCallback.cost2));
//            } else {
//                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(objectCallback.cost3));
//                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -int(objectCallback.cost3));
//            }
            if (curCount == 0) {
                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(objectCallback.costNew[0]));
                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(objectCallback.costNew[0]));
            } else {
                showSmallAnimations(DataMoney.SOFT_CURRENCY, -int(objectCallback.costNew[curCount]));
                g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(objectCallback.costNew[curCount]));
            }
            for (i = 0; i < arr.length; i++) {
                if (arr[i] is Farm && arr[i].dataBuild.id == objectCallback.buildId && !arr[i].isFull) {
                    (arr[i] as Farm).addAnimal();
//                    checkState();
                    g.bottomPanel.cancelBoolean(false);
//                    _wo.updateMoneyCounts();
                    break;
                }
            }
            if (g.managerTutorial.isTutorial) {
                if (g.managerTutorial.currentAction == TutorialAction.BUY_ANIMAL && g.managerTutorial.isTutorialResource(objectCallback.id)) {
                    g.managerTutorial.checkTutorialCallback();
                } else {
                    return;
                }
            }
        }
    }

    private function updateItem():void {
        var curCount:int;
        var maxCount:int;

        if (_data.buildType == BuildType.CAT) {
            curCount = g.managerCats.curCountCats+1;
            maxCount = g.managerCats.maxCountCats;
            if (curCount == maxCount) {
                createShopLimitSprite();
                _im.filter = ManagerFilters.BUTTON_DISABLE_FILTER;
                _btnBuyBlue.visible = false;
                if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                else _nameTxt.text = String(_data.name);
                _countTxt.text = String(maxCount) + '/' + String(maxCount);
//                _txtBtnBuyBlue.text = String(g.dataCats[g.managerCats.curCountCats].cost);
            } else {
                if (g.user.isTester) _nameTxt.text = String(_data.id) +':'+ String(_data.name);
                else _nameTxt.text = String(_data.name);
                _countTxt.text = String(curCount) + '/' + String(maxCount);
                _txtBtnBuyBlue.text = String(g.dataCats[curCount].cost);
            }
        }
        _wo.updateMoneyCounts();
    }

    private function showSmallAnimations(moneyType:int, count:int):void {
        if (_imCont) {
            _imCont.scaleX = _imCont.scaleY = 1;
            TweenMax.to(_imCont, .3, {scaleX: 1.3, scaleY: 1.3, ease: Quad.easeOut, onComplete: showSmallAnimations2});
            var p:Point = new Point(_imCont.x, _imCont.y + 20);
            p = source.localToGlobal(p);
            new UseMoneyMessage(p, moneyType, count, .3);
        }
    }

    private function showSmallAnimations2():void {
        TweenMax.to(_imCont, .3, {scaleX: 1, scaleY:1, ease:Quad.easeIn});
    }

    public function get id():int {
        return _data.id;
    }

    public function deleteIt():void {
        if (_imCont) {
            TweenMax.killTweensOf(_imCont);
        }
        for (var i:int=0; i<_arrImages.length; i++) {
            if (_arrImages[i] && _arrImages[i] is DisplayObject) (_arrImages[i] as DisplayObject).filter = null;
        }
        deleteArrow();
        _arrImages.length = 0;
        if (_im) _im.filter = null;
        _im = null;
        _imCont = null;
        if (_txtBtnYellow) {
            if (_btnActivationYellow) _btnActivationYellow.removeChild(_txtBtnYellow);
            _txtBtnYellow.deleteIt();
            _txtBtnYellow = null;
        }
        if (_txtLimit) {
            if (_shopLimitSprite) _shopLimitSprite.removeChild(_txtLimit);
            _txtLimit.deleteIt();
            _txtLimit = null;
        }
        if (_txtAvailablePink) {
            if (_btnActivationPink) _btnActivationPink.removeChild(_txtAvailablePink);
            _txtAvailablePink.deleteIt();
            _txtAvailablePink = null;
        }
        if (_nameTxt) {
            source.removeChild(_nameTxt);
            _nameTxt.deleteIt();
            _nameTxt = null;
        }
        if (_countTxt) {
            source.removeChild(_countTxt);
            _countTxt.deleteIt();
            _countTxt = null;
        }
        if (_countBoxTxt) {
            source.removeChild(_countBoxTxt);
            _countBoxTxt.deleteIt();
            _countBoxTxt = null;
        }
        if (_txtAvailable) {
            source.removeChild(_txtAvailable);
            _txtAvailable.deleteIt();
            _txtAvailable = null;
        }
        if (_txtBtnBuyBlue) {
            if (_btnBuyBlue) _btnBuyBlue.removeChild(_txtBtnBuyBlue);
            _txtBtnBuyBlue.deleteIt();
            _txtBtnBuyBlue = null;
        }
        if (_txtBtnBuyGreen) {
            if (_btnBuyGreen) _btnBuyGreen.removeChild(_txtBtnBuyGreen);
            _txtBtnBuyGreen.deleteIt();
            _txtBtnBuyGreen = null;
        }
        _data = null;
        _lockedSprite = null;
        if (_btnBuyGreen) {
            source.removeChild(_btnBuyGreen);
            _btnBuyGreen.deleteIt();
            _btnBuyGreen = null;
        }
        if (_btnBuyBlue) {
            source.removeChild(_btnBuyBlue);
            _btnBuyBlue.deleteIt();
            _btnBuyBlue = null;
        }
        if (_btnBuyCoupone) {
            source.removeChild(_btnBuyCoupone);
            _btnBuyCoupone.deleteIt();
            _btnBuyCoupone = null;
        }
        if (_btnActivationYellow) {
            source.removeChild(_btnActivationYellow);
            _btnActivationYellow.deleteIt();
            _btnActivationYellow = null;
        }
        if (_btnActivationPink) {
            source.removeChild(_btnActivationPink);
            _btnActivationPink.deleteIt();
            _btnActivationPink = null;
        }
        _shopLimitSprite = null;
        _wo = null;
        source.removeChild(_bg);
        _bg.deleteIt();
        _bg = null;
        source.deleteIt();
        source = null;
    }

    public function addArrow(t:int = 0):void {
        deleteArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, source);
        _arrow.scaleIt(.5);
        if (_btnBuyBlue) _arrow.animateAtPosition(_btnBuyBlue.x, _btnBuyBlue.y, true, .5);
        else if (_btnBuyGreen) _arrow.animateAtPosition(_btnBuyGreen.x, _btnBuyGreen.y, true, .5);
        if (t>0) _arrow.activateTimer(t, deleteArrow);
    }
    
    public function deleteArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }
}
}
