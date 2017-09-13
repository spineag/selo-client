/**
 * Created by andy on 9/6/17.
 */
package windows.shop_new {
import build.WorldObject;
import build.decor.DecorFenceArka;
import build.decor.DecorFenceGate;
import build.decor.DecorPostFenceArka;
import build.fabrica.Fabrica;
import build.farm.Farm;
import build.tree.Tree;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import data.StructureDataAnimal;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;
import org.osmf.layout.HorizontalAlign;
import quest.ManagerQuest;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import tutorial.TutsAction;
import tutorial.managerCutScenes.ManagerCutScenes;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;
import utils.SimpleArrow;
import utils.Utils;
import windows.WOComponents.WOSimpleButtonTexture;
import windows.WindowsManager;
import windows.shop_new.decorRadioButton.DecorRadioButton;

public class ShopNewListItem {
    private var g:Vars = Vars.getInstance();
    private var _source:CSprite;
    private var _bg:Image;
    private var _btn:CButton;
    private var _additionalCoupones:Sprite;
    private var _txtName:CTextField;
    private var _txtCount:CTextField;
    private var _txtInfo:CTextField; // available, locked, is max
    private var _data:Object;
    private var _pageNumber:int;
    private var _numberOnPage:int;
    private var _radioButton:DecorRadioButton;
    private var _im:Image;
    private var _costCount:int;
    private var _isFromInventory:Boolean;
    private var _hand:CSprite;
    private var _arrow:SimpleArrow;
    private var _wo:WOShopNew;
    private var _isThisItemBlocked:Boolean;
    private var _blackPlawka:Image;

    public function ShopNewListItem(obj:Object, pg:int, np:int, w:WOShopNew) { // 160x216
        _wo = w;
        _data = obj;
        _pageNumber = pg;
        _numberOnPage = np;
        _source = new CSprite();
        _source.endClickCallback = onClick;
        _isThisItemBlocked = false;

        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_blue_cell'));
        _bg.x = -6;
        _bg.y = -7;
        _source.addChild(_bg);
        _blackPlawka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_at_limit'));
        _blackPlawka.x = 1;
        _blackPlawka.y = 179;
        _source.addChild(_blackPlawka);
        _blackPlawka.visible = false;

        _txtName = new CTextField(160, 50, '');
        _txtName.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _source.addChild(_txtName);
        _txtCount = new CTextField(54, 24, '');
        _txtCount.setFormat(CTextField.BOLD18, 16, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txtCount.alignH = HorizontalAlign.RIGHT;
        _txtCount.x = 94;
        _txtCount.y = 155;
        _source.addChild(_txtCount);
        _txtInfo = new CTextField(150, 32, '');
        _txtInfo.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.GRAY_HARD_COLOR);
        _txtInfo.x = 5;
        _txtInfo.y = 180;
        _source.addChild(_txtInfo);

        setInfo();

        _data.buildType = int(_data.buildType);
        if (_data.group && _data.blockByLevel[0] <= g.user.level && (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_ANIMATION)) {
            var arr:Array = g.allData.getGroup(_data.group);
            if (arr.length > 1) {
                _radioButton = new DecorRadioButton(_source, onClickRadioButton);
                for (var i:int=0; i<arr.length; i++) {
                    _radioButton.addItem(Utils.objectFromStructureBuildToObject(arr[i]));
                }
                _radioButton.calculatePositions();
            }
        }
    }
    
    public function get itemBounds():Object {
        var ob:Object = {};
        var p:Point = new Point();
        p = _source.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = 160;
        ob.height = 216;
        return ob;
    }

    public function get source():CSprite { return _source; }
    public function get id():int { return _data.id; }
    public function get pageNumber():int { return _pageNumber; }
    public function get numberOnPage():int { return _numberOnPage; }

    private function setInfo():void {
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture) {
                if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_POST_FENCE || _data.buildType == BuildType.DECOR_FENCE_ARKA
                        || _data.buildType == BuildType.DECOR_FENCE_GATE || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.TREE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA)
                    texture = g.allData.atlas[_data.url].getTexture(_data.image);
                else texture = g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon');
            }
            if (!texture) Cc.error('ShopItem:: no such texture: ' + _data.url + ' for _data.id ' + _data.id);
            else {
                _im = new Image(texture);
                _im.alignPivot();
                _im.x = 82;
                _im.touchable = false;
                _source.addChild(_im);
            }
        } else {
            Cc.error('ShopItem:: no image in _data for _data.id: ' + _data.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'shopItem');
        }
        _costCount = _data.cost;
        if ((_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_ANIMATION || _data.buildType == BuildType.DECOR_FULL_FENСE
                || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_FENCE_ARKA || _data.buildType == BuildType.DECOR_FENCE_GATE
                || _data.buildType == BuildType.DECOR_POST_FENCE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA)
                && g.userInventory.decorInventory[_data.id]) {
            _isFromInventory = true;
            _costCount = 0;
            if (g.user.isTester) _txtName.text = String(_data.id) +':'+ String(_data.name);
                else _txtName.text = String(_data.name);
            createButton();
        } else {
            _isFromInventory = false;
        }
        checkState();
    }

    private function checkState():void {
        var arr:Array;
        var i:int;
        var maxCount:int;
        var curCount:int;
        var maxCountAtCurrentLevel:int = 0;
        _txtName.text = '';
        _txtCount.text = '';
        _txtInfo.text = '';
        var myPattern:RegExp = /count/;
        var str:String =  String(g.managerLanguage.allTexts[342]);

        if (!_data) return;
        if (_data.buildType == BuildType.FABRICA ) {
            if (_im) {
                MCScaler.scale(_im, 130, 130);
                _im.y = 115;
            }
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                _txtInfo.text = String(str.replace(myPattern, String(_data.blockByLevel[0])));
                if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                _bg.filter = ManagerFilters.getButtonDisableFilter();
                _isThisItemBlocked = true;
            } else {
                arr = g.townArea.getCityObjectsById(_data.id);
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                        _costCount = _data.cost[i];
                    } else break;
                }
                if (arr.length == _data.blockByLevel.length) {
                    _txtInfo.text = g.managerLanguage.allTexts[340];
                    if (_im)_im.filter = ManagerFilters.getButtonDisableFilter();
                    _bg.filter = ManagerFilters.getButtonDisableFilter();
                    _blackPlawka.visible = true;
                    _txtCount.text = String(maxCountAtCurrentLevel) + '/' + String(maxCountAtCurrentLevel);
                    _isThisItemBlocked = true;
                } else if (arr.length >= maxCountAtCurrentLevel) {
                    _txtInfo.text = String(str.replace(myPattern, String(_data.blockByLevel[maxCountAtCurrentLevel])));
                    _txtCount.text = String(arr.length) + '/' + String(_data.blockByLevel.length);
                    if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                    _bg.filter = ManagerFilters.getButtonDisableFilter();
                    _blackPlawka.visible = true;
                    _isThisItemBlocked = true;
                } else {
                    _txtCount.text = String(arr.length) + '/' + String(maxCountAtCurrentLevel);
                    checkNotification(maxCountAtCurrentLevel);
                    createButton();
                }
            }
        } else if (_data.buildType == BuildType.FARM) {
            if (_im) {
                MCScaler.scale(_im, 135, 135);
                _im.y = 113;
            }
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                _txtInfo.text = String(str.replace(myPattern, String(_data.blockByLevel[0])));
                if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                _bg.filter = ManagerFilters.getButtonDisableFilter();
                _blackPlawka.visible = true;
                _isThisItemBlocked = true;
            } else {
                arr = g.townArea.getCityObjectsById(_data.id);
                for (i = 0; _data.blockByLevel.length; i++) {
                    if (_data.blockByLevel[i] <= g.user.level) {
                        maxCountAtCurrentLevel++;
                    } else break;
                }
                if (arr.length >= maxCountAtCurrentLevel) {
                    _isThisItemBlocked = true;
                    if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                    _bg.filter = ManagerFilters.getButtonDisableFilter();
                    _blackPlawka.visible = true;
                    if (g.user.level < _data.blockByLevel[arr.length]) _txtInfo.text = String(str.replace(myPattern, String(_data.blockByLevel[arr.length])));
                    else _txtCount.text = String(maxCountAtCurrentLevel) + '/' + String(maxCountAtCurrentLevel);
                } else {
                    _txtCount.text = String(arr.length) + '/' + String(maxCountAtCurrentLevel);
                    createButton();
                    checkNotification(maxCountAtCurrentLevel);
                }
            }
        } else if (_data.buildType == BuildType.DECOR_ANIMATION || _data.buildType == BuildType.DECOR ||  _data.buildType == BuildType.DECOR_FULL_FENСE
                || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE || _data.buildType == BuildType.DECOR_FENCE_ARKA
                || _data.buildType == BuildType.DECOR_FENCE_GATE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA) {
            if (_im) {
                MCScaler.scale(_im, 125, 125);
                _im.y = 113;
            }
            var decorMax:int = 0;
            if (_data.blockByLevel) {
                if ( _data.buildType == BuildType.DECOR_ANIMATION) createHand();
                if (_data.buildType == BuildType.DECOR_TAIL) arr = g.townArea.getCityTailObjectsById(_data.id);
                    else arr = g.townArea.getCityObjectsById(_data.id);
                if (_data.color != null) decorMax =  g.townArea.getMaxCountDecorColorObjectsByGroup(_data.group);

                if (_data.blockByLevel[0] > g.user.level) {
                    _txtInfo.text =  String(str.replace(myPattern, String(_data.blockByLevel[0])));
                    if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                    _bg.filter = ManagerFilters.getButtonDisableFilter();
                    _blackPlawka.visible = true;
                    _isThisItemBlocked = true;
                    if (_hand) _hand.filter = ManagerFilters.getButtonDisableFilter();
                } else {
                    if (_isFromInventory) {
                        _txtInfo.text = String(g.managerLanguage.allTexts[344]) + ' ' + String(g.userInventory.decorInventory[_data.id].count); 'in inventory'
                        if (decorMax >= arr.length) _costCount = (decorMax * _data.deltaCost) + int(_data.cost);
                        else _costCount = (arr.length * _data.deltaCost) + int(_data.cost);
                        createButton();
                    } else {
                        checkNotification(maxCountAtCurrentLevel);
                        if (_data.currency[0] == DataMoney.HARD_CURRENCY)  _costCount = _data.cost;
                            else if (_data.currency[0] == DataMoney.SOFT_CURRENCY) {
                                if (decorMax >= arr.length) _costCount = (decorMax * _data.deltaCost) + int(_data.cost);
                                    else _costCount = (arr.length * _data.deltaCost) + int(_data.cost);
                        }
                        createButton();
                    }
                }
            }
        } else if (_data.buildType == BuildType.ANIMAL) {
            if (_im) {
                MCScaler.scale(_im, 135, 135);
                _im.y = 115;
            }
            var dataFarm:Object = Utils.objectFromStructureBuildToObject(g.allData.getBuildingById(_data.buildId));
            if (dataFarm && dataFarm.blockByLevel) {
                if (g.user.level < dataFarm.blockByLevel[0]) {
                    _txtInfo.text = String(str.replace(myPattern, String(dataFarm.blockByLevel[0])));
                    if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                    _bg.filter = ManagerFilters.getButtonDisableFilter();
                    _blackPlawka.visible = true;
                    _isThisItemBlocked = true;
                } else {
                    arr = g.townArea.getCityObjectsById(dataFarm.id);
                    maxCount = arr.length * dataFarm.maxAnimalsCount;
                    curCount = 0;
                    for (i=0; i<arr.length; i++) {
                        curCount += (arr[i] as Farm).arrAnimals.length;
                    }

                    if (maxCount == curCount) {
                        if (g.user.level >= dataFarm.blockByLevel[arr.length-1]) {
                            if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                            _bg.filter = ManagerFilters.getButtonDisableFilter();
                            _blackPlawka.visible = true;
                            _txtCount.text = String(maxCount) + '/' + String(maxCount);
                            _costCount = 0;
                            _isThisItemBlocked = true;
                        } else {
                            _txtInfo.text = String(g.managerLanguage.allTexts[345]) + ' ' + String(dataFarm.name);
                            if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                            _bg.filter = ManagerFilters.getButtonDisableFilter();
                            _blackPlawka.visible = true;
                            if (g.user.isTester) _txtName.text = String(_data.id) +':'+ String(_data.name);
                                else _txtName.text = String(_data.name);
                            _isThisItemBlocked = true;
                        }
                    } else {
                        _txtCount.text = String(curCount) + '/' + String(maxCount);
                        if (curCount == 0) _costCount = _data.costNew[0];
                            else _costCount = _data.costNew[curCount];
                        createButton();
                    }
                }
            }
        } else if (_data.buildType == BuildType.TREE) {
            if (_im) {
                MCScaler.scale(_im, 130, 130);
                _im.y = 115;
            }
            if (_data.blockByLevel && g.user.level < _data.blockByLevel[0]) {
                _txtInfo.text = String(str.replace(myPattern, String(_data.blockByLevel[0])));
                if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                _bg.filter = ManagerFilters.getButtonDisableFilter();
                _blackPlawka.visible = true;
                _isThisItemBlocked = true;
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
                    if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                    _bg.filter = ManagerFilters.getButtonDisableFilter();
                    _txtCount.text = String(maxCount) + '/' + String(maxCount);
                    _blackPlawka.visible = true;
                    _isThisItemBlocked = true;
                } else {
                    _txtCount.text = String(curCount) + '/' + String(maxCount);
                    createButton();
                    checkNotification(maxCountAtCurrentLevel);
                }
            }
        } else if (_data.buildType == BuildType.RIDGE) {
            if (_im) {
                MCScaler.scale(_im, 135, 135);
                _im.y = 115;
            }
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
                    _txtInfo.text = g.managerLanguage.allTexts[340];
                    if (_im) _im.filter = ManagerFilters.getButtonDisableFilter();
                    _bg.filter = ManagerFilters.getButtonDisableFilter();
                    _blackPlawka.visible = true;
                    _txtCount.text = String(maxCount) + '/' + String(maxCount);
                    _isThisItemBlocked = true;
                } else {
                    _txtCount.text = String(curCount) + '/' + String(maxCount);
                    createButton();
                    checkNotification(maxCountAtCurrentLevel);
                }
            }
        }
        if (_data.visibleTester) { _costCount = 0; createButton(); }
        if (g.user.isTester) _txtName.text = String(_data.id) +':'+ String(_data.name);
            else _txtName.text = String(_data.name);
    }

    private function checkNotification(maxCountAtCurrentLevel:int):void {
        if (g.user.allNotification > 0 && g.user.fabricaNotification > 0 && g.user.level == _data.blockByLevel[maxCountAtCurrentLevel-1]) {
            var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
            im.x = 102;
            _source.addChild(im);
            if(!g.tuts.isTuts && !g.managerCutScenes.isCutScene) addArrow(3);
        }
    }

    private function createHand():void {
        _hand = new CSprite();
        _hand.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[339])); };
        _hand.outCallback = function():void { g.hint.hideIt(); };
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('animated_decor'));
        im.alignPivot();
        _hand.addChild(im);
        _hand.x = 137;
        _hand.y = 71;
        _source.addChild(_hand);
    }

    private function createButton():void {
        if (_btn) {
            _source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        _btn = new CButton();
        if (_isFromInventory) {
            _btn.addButtonTexture(152, 35, CButton.ORANGE, true);
            _btn.x = -10;
            _btn.y = 195;
            _btn.addTextField(152, 33, 0, 0, String(g.managerLanguage.allTexts[344]) + ': ' + String(g.userInventory.decorInventory[_data.id].count));
            _btn.setTextFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.ORANGE_COLOR);
        } else {
            var im:Image;
            var t:CTextField;
            var sens:SensibleBlock;
            if (!_data.currency || _data.currency[0] == DataMoney.SOFT_CURRENCY) {
                _btn.addButtonTexture(152, 35, CButton.GREEN, true);
                _btn.y = 195;
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_medium'));
                im.alignPivot();
                MCScaler.scale(im, 25, 25);
                t = new CTextField(90, 33, String(_costCount));
                t.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.GREEN_COLOR);
                sens = new SensibleBlock();
                sens.textAndImage(t,im,152);
                _btn.addSensBlock(sens,0,18);
            } else if (_data.currency[0] == DataMoney.HARD_CURRENCY) {
                _btn.addButtonTexture(152, 35, CButton.GREEN, true);
                _btn.y = 195;
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_medium'));
                im.alignPivot();
                MCScaler.scale(im, 25, 25);
                t = new CTextField(90, 33, String(_costCount));
                t.setFormat(CTextField.BOLD24, 22, Color.WHITE, ManagerFilters.GREEN_COLOR);
                sens = new SensibleBlock();
                sens.textAndImage(t,im,152);
                _btn.addSensBlock(sens,0,18);
            } else {
                _btn.addButtonTexture(152, 35, CButton.GREEN, true);
                _btn.y = 195;
                if (_data.currency.length == 1) {
                    sens = createSensBlockForCoupone(_data.currency[0], _data.cost[0], 152);
                    _btn.addSensBlock(sens,0,18);
                } else if (_data.currency.length == 2) {
                    sens = createSensBlockForCoupone(_data.currency[0], _data.cost[0], 76);
                    _btn.addSensBlock(sens,0,18);
                    sens = createSensBlockForCoupone(_data.currency[1], _data.cost[1], 76);
                    _btn.addSensBlock(sens,76,18);
                } else {
                    sens = createSensBlockForCoupone(_data.currency[0], _data.cost[0], 70);
                    _btn.addSensBlock(sens,5,18);
                    sens = createSensBlockForCoupone(_data.currency[1], _data.cost[1], 70);
                    _btn.addSensBlock(sens,70,18);
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_more'));
                    im.x = 132;
                    im.y = 5;
                    _btn.addChild(im);
                    _additionalCoupones = new Sprite();
                    _additionalCoupones.addChild(new WOSimpleButtonTexture(152, 53, CButton.GREEN));
                    sens = createSensBlockForCoupone(_data.currency[0], _data.cost[0], 76);
                    sens.x = 5;
                    sens.y = 20;
                    _additionalCoupones.addChild(sens);
                    sens = createSensBlockForCoupone(_data.currency[1], _data.cost[1], 76);
                    sens.x = 74;
                    sens.y = 20;
                    _additionalCoupones.addChild(sens);
                    sens = createSensBlockForCoupone(_data.currency[2], _data.cost[2], 76);
                    sens.x = 5;
                    sens.y = 48;
                    _additionalCoupones.addChild(sens);
                    if (_data.currency.length == 4) {
                        sens = createSensBlockForCoupone(_data.currency[3], _data.cost[3], 76);
                        sens.y = 48;
                        sens.x = 74;
                        _additionalCoupones.addChild(sens);
                    }
                    _btn.addChild(_additionalCoupones);
                    _additionalCoupones.touchable = false;
                    _additionalCoupones.visible = false;
                    _btn.hoverCallback = function():void { _additionalCoupones.visible = true; };
                    _btn.outCallback = function():void { _additionalCoupones.visible = false; };
                }
            }
        }
        _btn.x = 80;
        _source.addChild(_btn);
        _btn.clickCallback = onClick;
    }

    private function createSensBlockForCoupone(type:int, cost:int, width:int):SensibleBlock {
        var im:Image;
        switch (type) {
            case DataMoney.BLUE_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone')); break;
            case DataMoney.RED_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_coupone')); break;
            case DataMoney.YELLOW_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('yellow_coupone')); break;
            case DataMoney.GREEN_COUPONE: im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone')); break;
        }
        im.alignPivot();
        MCScaler.scale(im, 25, 25);
        var t:CTextField = new CTextField(90, 33, String(cost));
        t.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.GREEN_COLOR);
        var sens:SensibleBlock = new SensibleBlock();
        sens.textAndImage(t, im, width, 20);
        return sens;
    }

    private function onClickRadioButton(activeItemData:Object):void {
        _data = activeItemData;
        if (_btn) {
            if (_additionalCoupones) {
                _btn.removeChild(_additionalCoupones);
                _additionalCoupones.dispose();
                _additionalCoupones = null;
            }
            _source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        if (_im) {
            _source.removeChild(_im);
            _im.dispose();
            _im = null;
        }
        if (_hand) {
            _source.removeChild(_hand);
            _hand.dispose();
            _hand = null;
        }
        setInfo();
    }

    public function addArrow(t:int = 0):void {
        deleteArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_BOTTOM, source);
        _arrow.scaleIt(.5);
        if (_btn) _arrow.animateAtPosition(_btn.x, _btn.y, true, .5);
        if (t>0) _arrow.activateTimer(t, deleteArrow);
    }

    public function deleteArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    private function onClick():void {
        if (_data.buildType == BuildType.ANIMAL && g.tuts.isTuts) {
            if (g.tuts.action != TutsAction.BUY_ANIMAL) return;
            if (!g.tuts.isTutsResource(_data.id)) return;
        }
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        var i:int;
        if (_isThisItemBlocked) return;
        if (g.managerMiniScenes.isMiniScene) g.managerMiniScenes.deleteArrowAndDust();
        var ob:Object;
        if ((_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_ANIMATION || _data.buildType == BuildType.DECOR_FULL_FENСE
                || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE || _data.buildType == BuildType.DECOR_FENCE_GATE
                || _data.buildType == BuildType.DECOR_FENCE_ARKA || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA) && !_isFromInventory) {
            if (g.tuts.isTuts) return;
            if (g.managerCutScenes.isCutScene) {
                if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_BUY_DECOR) && g.managerCutScenes.isCutSceneResource(_data.id)) {
                    g.managerCutScenes.checkCutSceneCallback();
                } else return;
            }
            if (_data.currency.length == 1) {
                if (_data.currency == DataMoney.SOFT_CURRENCY) {
                    if (g.user.softCurrencyCount < _costCount) {
                        ob = {};
                        ob.currency = DataMoney.SOFT_CURRENCY;
                        ob.count = _costCount - g.user.softCurrencyCount;
                        ob.cost = _costCount;
                        ob.data = _data;
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, noResourceCallback, 'money', ob);
                        return;
                    }
                } else if (_data.currency == DataMoney.HARD_CURRENCY) {
                    if (g.user.hardCurrency < _costCount) {
                        _wo.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
                        return;
                    }
                } else if (_data.currency == DataMoney.BLUE_COUPONE && g.user.blueCouponCount < _costCount) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                    return;
                } else if (_data.currency == DataMoney.RED_COUPONE && g.user.redCouponCount < _costCount) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                    return;
                } else if (_data.currency == DataMoney.GREEN_COUPONE && g.user.greenCouponCount < _costCount) {
                    _wo.hideIt();
                    g.windowsManager.openWindow(WindowsManager.WO_BUY_COUPONE);
                    return;
                } else if (_data.currency == DataMoney.YELLOW_COUPONE && g.user.yellowCouponCount < _costCount) {
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
            if (g.user.softCurrencyCount < _costCount){
                ob = {};
                ob.currency = DataMoney.SOFT_CURRENCY;
                ob.count = _costCount - g.user.softCurrencyCount;
                ob.cost = _costCount;
                ob.data = _data;
                _wo.hideIt();
                g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, noResourceCallback, 'money', ob);
                return;
            }
        }
        if (_data.buildType == BuildType.DECOR || _data.buildType == BuildType.DECOR_FULL_FENСE || _data.buildType == BuildType.DECOR_TAIL || _data.buildType == BuildType.DECOR_POST_FENCE
                || _data.buildType == BuildType.DECOR_FENCE_ARKA || _data.buildType == BuildType.DECOR_FENCE_GATE || _data.buildType == BuildType.DECOR_POST_FENCE_ARKA) {
            if (_data.currency == DataMoney.SOFT_CURRENCY) {
                g.buyHint.showIt(_costCount);
            }
        }
        var build:WorldObject;
        if (_data.buildType == BuildType.RIDGE) {
            if (g.tuts.isTuts && g.tuts.action != TutsAction.NEW_RIDGE) return;
            build = g.townArea.createNewBuild(_data);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.ADD_NEW_RIDGE;
            if (g.tuts.isTuts && g.tuts.action == TutsAction.NEW_RIDGE) {
                g.tuts.checkTutsCallback();
            }
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP_NEW);
            (build as WorldObject).countShopCost = _costCount;
            g.townArea.startMoveAfterShop(build);
        } else if (_data.buildType == BuildType.DECOR_TAIL) {
            if (g.tuts.isTuts) return;
            build = g.townArea.createNewBuild(_data);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP_NEW);
            if (_isFromInventory) {
                g.townArea.startMoveAfterShop(build, true);
                g.buyHint.hideIt();
            } else {
                (build as WorldObject).countShopCost = _costCount;
                g.townArea.startMoveAfterShop(build);
            }
        } else if (_data.buildType != BuildType.ANIMAL) {
            if (g.tuts.isTuts && g.tuts.action != TutsAction.BUY_FABRICA && g.tuts.action != TutsAction.BUY_FARM) return;
            build = g.townArea.createNewBuild(_data);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            if(_data.buildType == BuildType.FARM) {
                var an:StructureDataAnimal = g.allData.getAnimalByFarmId(_data.id);
                if (an) g.user.animalIdArrow = an.id;
            }
            if (build is Tree) (build as Tree).showShopView();
            if (build is Fabrica) (build as Fabrica).showShopView();
            if (build is DecorFenceGate) (build as DecorFenceGate).showFullView();
            if (build is DecorFenceArka) (build as DecorFenceArka).showFullView();
            if (build is DecorPostFenceArka) (build as DecorPostFenceArka).showFullView();
            if (g.tuts.isTuts) {
                if ((g.tuts.action == TutsAction.BUY_FABRICA || g.tuts.action == TutsAction.BUY_FARM) && g.tuts.isTutsResource(_data.id))
                    g.tuts.checkTutsCallback();
            }
            if (_isFromInventory) {
                g.townArea.startMoveAfterShop(build, true);
                g.buyHint.hideIt();
            } else {
                (build as WorldObject).countShopCost = _costCount;
                g.townArea.startMoveAfterShop(build);
            }
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP_NEW);
        } else { // animal
            if (g.tuts.isTuts) {
                if (g.tuts.action != TutsAction.BUY_ANIMAL) return;
                if (!g.tuts.isTutsResource(_data.id)) return;
            }
            //додаємо на відповідну ферму
            var dataFarm:Object = Utils.objectFromStructureBuildToObject(g.allData.getBuildingById(_data.buildId));
            var curCount:int = 0;
            var arr:Array = g.townArea.cityObjects;
            var arrPat:Array = g.townArea.getCityObjectsById(dataFarm.id);
            for (i=0; i<arrPat.length; i++) {
                curCount += (arrPat[i] as Farm).arrAnimals.length;
            }
            if (curCount == 0) g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(_data.costNew[0]));
            else g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(_data.costNew[curCount]));
            g.managerQuest.onActionForTaskType(ManagerQuest.BUY_ANIMAL, {id:(_data.id)});
            for (i = 0; i < arr.length; i++) {
                if (arr[i] is Farm  &&  arr[i].dataBuild.id == _data.buildId  &&  !arr[i].isFull) {
                    if (g.tuts.isTuts) {
                        (arr[i] as Farm).addAnimal();
                        g.bottomPanel.cancelBoolean(false);
                        g.tuts.checkTutsCallback();
                    } else {
                        (arr[i] as Farm).addAnimal();
                        checkState();
                        g.bottomPanel.cancelBoolean(false);
                    }
                    break;
                }
            }
        }
    }

    private function noResourceCallback(objectCallback:Object = null,countCost:int = 0):void {
        if(!objectCallback) return;
        var build:WorldObject;
        if (objectCallback.buildType == BuildType.RIDGE) {
            if (g.tuts.isTuts && g.tuts.action != TutsAction.NEW_RIDGE) return;
            build = g.townArea.createNewBuild(objectCallback);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.ADD_NEW_RIDGE;
            if (g.tuts.isTuts && g.tuts.action == TutsAction.NEW_RIDGE) g.tuts.checkTutsCallback();
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP_NEW);
            (build as WorldObject).countShopCost = countCost;
            g.townArea.startMoveAfterShop(build);
        } else if (objectCallback.buildType == BuildType.DECOR_TAIL) {
            if (g.tuts.isTuts) return;
            build = g.townArea.createNewBuild(objectCallback);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP_NEW);
            (build as WorldObject).countShopCost = countCost;
            g.townArea.startMoveAfterShop(build);
        } else if (objectCallback.buildType != BuildType.ANIMAL) {
            if (g.tuts.isTuts && g.tuts.action != TutsAction.BUY_FABRICA && g.tuts.action != TutsAction.BUY_FARM) return;
            build = g.townArea.createNewBuild(objectCallback);
            g.selectedBuild = build;
            g.bottomPanel.cancelBoolean(true);
            g.toolsModifier.modifierType = ToolsModifier.MOVE;
            if (build is Tree) (build as Tree).showShopView();
            if (build is Fabrica) (build as Fabrica).showShopView();
            if (g.tuts.isTuts) {
                if ((g.tuts.action == TutsAction.BUY_FABRICA || g.tuts.action == TutsAction.BUY_FARM) && g.tuts.isTutsResource(objectCallback.id))
                    g.tuts.checkTutsCallback();
            }
            (build as WorldObject).countShopCost = countCost;
            g.townArea.startMoveAfterShop(build);
            g.windowsManager.hideWindow(WindowsManager.WO_SHOP_NEW);
        } else {
            if (g.tuts.isTuts) {
                if (g.tuts.action != TutsAction.BUY_ANIMAL) return;
                if (!g.tuts.isTutsResource(objectCallback.id)) return;
            }
            //додаємо на відповідну ферму
            var dataFarm:Object = g.allData.getBuildingById(objectCallback.buildId);
            var curCount:int = 0;
            var arr:Array = g.townArea.cityObjects;
            var arrPat:Array = g.townArea.getCityObjectsById(dataFarm.id);
            for (var i:int = 0; i < arrPat.length; i++) {
                curCount += (arrPat[i] as Farm).arrAnimals.length;
            }
            if (curCount == 0) g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(objectCallback.costNew[0]));
            else g.userInventory.addMoney(DataMoney.SOFT_CURRENCY,-int(objectCallback.costNew[curCount]));
            for (i = 0; i < arr.length; i++) {
                if (arr[i] is Farm && arr[i].dataBuild.id == objectCallback.buildId && !arr[i].isFull) {
                    (arr[i] as Farm).addAnimal();
                    g.bottomPanel.cancelBoolean(false);
                    break;
                }
            }
            if (g.tuts.isTuts && g.tuts.action == TutsAction.BUY_ANIMAL && g.tuts.isTutsResource(objectCallback.id)) g.tuts.checkTutsCallback();
        }
    }

    public function deleteIt():void {
        if (!_source) return;
        _wo = null;
        deleteArrow();
        if (_btn) {
            _source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        _source.removeChild(_txtCount);
        _source.removeChild(_txtName);
        _source.removeChild(_txtInfo);
        _txtCount.deleteIt();
        _txtName.deleteIt();
        _txtInfo.deleteIt();
        if (_radioButton) _radioButton.deleteIt()
        _source.dispose();
        _source = null;
    }
}
}
