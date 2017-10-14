/**
 * Created by user on 6/24/15.
 */
package ui.bottomInterface {
import com.greensock.TweenMax;
import com.greensock.easing.Back;
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import mouse.ToolsModifier;
import social.SocialNetworkSwitch;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import tutorial.miniScenes.ManagerMiniScenes;
import utils.CTextField;
import utils.SimpleArrow;
import tutorial.TutsAction;
import tutorial.helpers.HelperReason;
import tutorial.managerCutScenes.ManagerCutScenes;
import user.NeighborBot;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.MCScaler;
import windows.WindowsManager;
import windows.shop_new.DecorShopNewFilter;
import windows.shop_new.WOShopNew;

public class MainBottomPanel {
    private var _source:Sprite;

    private var _friendSpr:Sprite;
    private var _friendBoard:Sprite;
    private var _friendBoardHelpInfo:Image;
    private var _shopBtn:CButton;
    private var _toolsBtn:CButton;
    private var _optionBtn:CSprite;
    private var _cancelBtn:CButton;
    private var _homeBtn:CButton;
    private var _friendBtn:CButton;
    private var _boolTools:Boolean;
    private var _boolFriend:Boolean;
    private var _person:Someone;
    private var _ava:Image;
    private var _tutorialCallback:Function;
    private var _arrow:SimpleArrow;
    private var _imNotification:Image;
    private var _txtNotification:CTextField;
    private var _txtHome:CTextField;
    public var _questBoolean:Boolean;
    public var _questBuilId:int = 0;
    private var _typeHelp:int = 0;
    private var _btnPlusMinus:CButton;
    private var _imArrow:Image;

    private var g:Vars = Vars.getInstance();

    public function MainBottomPanel() {
        _questBoolean = false;
        _source = new Sprite();
        _boolTools = false;
        _boolFriend = false;
        onResize();
        _friendSpr = new Sprite();
        onResizePanelFriend();
        g.cont.interfaceCont.addChild(_friendSpr);
        g.cont.interfaceCont.addChild(_source);
//        var pl:HorizontalPlawka = new HorizontalPlawka(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_l'), g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_c'),
//                g.allData.atlas['interfaceAtlas'].getTexture('main_panel_back_r'), 260);
//        _source.addChild(pl);

        createBtns();
        _imNotification = new Image(g.allData.atlas['interfaceAtlas'].getTexture('red_m_big'));
//        MCScaler.scale(_imNotification,33,33);
        _imNotification.x = -5;
        _imNotification.y = -20;
        _shopBtn.addChild(_imNotification);
        _txtNotification = new CTextField(60,60,'');
        _txtNotification.setFormat(CTextField.BOLD24, 24, Color.WHITE);
        _txtNotification.x = -17;
        _txtNotification.y = -33;
        _shopBtn.addChild(_txtNotification);
        _imNotification.visible = false;
        _txtNotification.visible = false;
        updateNotification();
    }

    private function createBtns():void {
        var im:Image;
        _toolsBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('map_editor_button'));
        _toolsBtn.addDisplayObject(im);
        _toolsBtn.setPivots();
        _imArrow = new Image(g.allData.atlas['interfaceAtlas'].getTexture('arrow_icon'));
        _imArrow.x = 19;
        _imArrow.y = 19;
        _toolsBtn.addDisplayObject(_imArrow);
        _toolsBtn.x = 60 + _toolsBtn.width/2;
        _toolsBtn.y = -15 + _toolsBtn.height/2;
        _source.addChild(_toolsBtn);
        _toolsBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[478])); };
        _toolsBtn.outCallback = function():void { g.hint.hideIt(); };
        _toolsBtn.clickCallback = function():void {onClick('tools')};

        _shopBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_blue'));
        _shopBtn.addDisplayObject(im);
        _shopBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_icon'));
        im.x = 10;
        im.y = 6;
        _shopBtn.addDisplayObject(im);
        _shopBtn.x = 155 + _shopBtn.width/2;
        _shopBtn.y = -25 + _shopBtn.height/2;
        _source.addChild(_shopBtn);
        _shopBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[475])); };
        _shopBtn.outCallback = function():void { g.hint.hideIt(); };
        _shopBtn.clickCallback = function():void {onClick('shop')};

        _friendBtn  = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_blue'));
        _friendBtn.addDisplayObject(im);
        _friendBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_cats_icon'));
        im.x = 10;
        im.y = 6;
        _friendBtn.addDisplayObject(im);
        _friendBtn.x = _friendBtn.width/2 + 6;
        _friendBtn.y = _friendBtn.height/4 + 2;
        _friendSpr.addChild(_friendBtn);
        _friendBtn.hoverCallback = function():void {g.hint.showIt(String(g.managerLanguage.allTexts[485]));};
        _friendBtn.outCallback = function():void { g.hint.hideIt(); };
        _friendBtn.clickCallback = function():void {onClick('friend')};

        _cancelBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('map_editor_button'));
        _cancelBtn.addDisplayObject(im);
        _cancelBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cencel_icon'));
        im.x = 14;
        im.y = 12;
        _cancelBtn.addDisplayObject(im);
        _cancelBtn.x = 60 + _cancelBtn.width/2;
        _cancelBtn.y = -15 + _cancelBtn.height/2;
        _source.addChild(_cancelBtn);
        _cancelBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[477])); };
        _cancelBtn.outCallback = function():void { g.hint.hideIt(); };
        _cancelBtn.clickCallback = function():void {onClick('cancel')};
        _cancelBtn.visible = false;

        _homeBtn = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_blue'));
        _homeBtn.addDisplayObject(im);
        _homeBtn.setPivots();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('home_icon'));
        im.x = 7;
        im.y = 6;
        _homeBtn.addDisplayObject(im);
        _homeBtn.x = 155 + _homeBtn.width/2;
        _homeBtn.y = -25 + _homeBtn.height/2;
        _source.addChild(_homeBtn);
        _homeBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[479])); };
        _homeBtn.outCallback = function():void { g.hint.hideIt(); };
        _homeBtn.clickCallback = function():void {onClick('door')};
        _homeBtn.visible = false;
//        _homeBtn = new CButton();
//        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_home'));
//        im.width = 260;
//        _homeBtn.addDisplayObject(im);
//        _homeBtn.setPivots();
//        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('main_panel_bt_home'));
//        im.x = 60;
//        im.y = 6;
//        _homeBtn.addDisplayObject(im);
//        _txtHome = new CTextField(100, 70, String(g.managerLanguage.allTexts[988]));
//        _txtHome.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.ORANGE_COLOR);
//        _txtHome.x = 105;
//        _homeBtn.addChild(_txtHome);
//        _homeBtn.x = _homeBtn.width/2;
//        _homeBtn.y = 2 + _homeBtn.height/2;
//        _source.addChild(_homeBtn);
//        _homeBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[479])) };
//        _homeBtn.outCallback = function():void { g.hint.hideIt() };
//        _homeBtn.clickCallback = function():void {onClick('door')};
//        _homeBtn.visible = false;

        _optionBtn = new CSprite();
        _optionBtn.nameIt = 'optionBtn';
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('options_button'));
        _optionBtn.addChild(im);
        _optionBtn.x = 203;
        _optionBtn.y = -90;
        _source.addChild(_optionBtn);
        _optionBtn.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[480])); };
        _optionBtn.outCallback = function():void { g.hint.hideIt(); };
        _optionBtn.endClickCallback = function():void {onClick('option')};
    }

    private function onClick(reason:String):void {
        if (_arrow) _arrow.deleteIt();
        switch (reason) {
            case 'shop':
                if (g.tuts.isTuts) {
                    if (g.tuts.action == TutsAction.BUY_ANIMAL || g.tuts.action == TutsAction.BUY_FABRICA
                        || g.tuts.action == TutsAction.NEW_RIDGE) {
                    } else return;
                } else if (g.managerCutScenes.isCutScene) {
                    if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_BUY_DECOR)) {
                    } else return;
                }
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    if (g.managerCutScenes.isCutScene) return;
                    g.toolsModifier.cancelMove();
                    cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                if (g.managerMiniScenes.isMiniScene) deleteArrow();    
                g.toolsPanel.hideRepository();
                var shopTab:int = WOShopNew.VILLAGE;
                if (g.tuts.isTuts) {
                    g.user.decorShiftShop = 0;
                    g.user.decorShop = false;
                    if (g.tuts.action == TutsAction.BUY_ANIMAL) shopTab = WOShopNew.ANIMAL;
                    else if (g.tuts.action == TutsAction.BUY_FABRICA) shopTab = WOShopNew.FABRICA;
                    else if (g.tuts.action == TutsAction.NEW_RIDGE) shopTab = WOShopNew.VILLAGE;
                    else if (g.tuts.action == TutsAction.BUY_CAT) shopTab = WOShopNew.VILLAGE;
                    else if (g.tuts.action == TutsAction.BUY_FARM) shopTab = WOShopNew.VILLAGE;
                } else if (g.managerCutScenes.isCutScene) {
                    shopTab = WOShopNew.DECOR;
                    g.managerCutScenes.checkCutSceneCallback();
                } else if (g.managerMiniScenes.isReason(ManagerMiniScenes.BUY_BUILD)) {
                    shopTab = WOShopNew.FABRICA;
                } else if (g.managerHelpers && g.managerHelpers.isActiveHelper) {
                    g.user.decorShiftShop = 0;
                    g.user.decorShop = false;
                    if (g.managerHelpers.activeReason.reason == HelperReason.REASON_BUY_ANIMAL) shopTab = WOShopNew.ANIMAL;
                    else if (g.managerHelpers.activeReason.reason == HelperReason.REASON_BUY_FABRICA) shopTab = WOShopNew.FABRICA;
                    else if (g.managerHelpers.activeReason.reason == HelperReason.REASON_BUY_FARM) shopTab = WOShopNew.VILLAGE;
                    else if (g.managerHelpers.activeReason.reason == HelperReason.REASON_BUY_HERO) shopTab = WOShopNew.VILLAGE;
                    else if (g.managerHelpers.activeReason.reason == HelperReason.REASON_BUY_RIDGE) shopTab = WOShopNew.VILLAGE;
                }
                if (g.tuts.isTuts) {
                    if (_tutorialCallback != null) {
                        _tutorialCallback.apply(null, [true]);
                    }
                }
                if (_questBoolean) {
                    if (_typeHelp == HelperReason.REASON_BUY_ANIMAL) {
                        shopTab = WOShopNew.ANIMAL;
                        g.user.decorShop = false;
                    } else if (_typeHelp == HelperReason.REASON_BUY_FABRICA) {
                        shopTab = WOShopNew.FABRICA;
                        g.user.decorShop = false;
                    } else if (_typeHelp == HelperReason.REASON_BUY_FARM) {
                        shopTab = WOShopNew.VILLAGE;
                        g.user.decorShop = false;
                    } else if (_typeHelp == HelperReason.REASON_BUY_HERO) {
                        shopTab = WOShopNew.VILLAGE;
                        g.user.decorShop = false;
                    } else if (_typeHelp == HelperReason.REASON_BUY_RIDGE) {
                        shopTab = WOShopNew.VILLAGE;
                        g.user.decorShop = false;
                    } else if (_typeHelp == HelperReason.REASON_BUY_DECOR) shopTab = WOShopNew.DECOR;
                    else if (_typeHelp == HelperReason.REASON_BUY_TREE) {
                        shopTab = WOShopNew.PLANT;
                        g.user.decorShop = false;
                    }
                }
                if (_questBoolean && _typeHelp == HelperReason.REASON_BUY_DECOR) g.user.shopDecorFilter = DecorShopNewFilter.FILTER_ALL;
                g.windowsManager.openWindow(WindowsManager.WO_SHOP_NEW, null, shopTab);
                if (g.managerHelpers && g.managerHelpers.isActiveHelper) {
                    g.managerHelpers.onOpenShop();
                }
                if (_questBoolean) {
                    _questBoolean = false;
                    (g.windowsManager.currentWindow as WOShopNew).deleteAllArrows();
                    if (_typeHelp == HelperReason.REASON_BUY_FABRICA || _typeHelp == HelperReason.REASON_BUY_DECOR) {
                        (g.windowsManager.currentWindow as WOShopNew).openOnResource(_questBuilId);
                        (g.windowsManager.currentWindow as WOShopNew).addItemArrow(_questBuilId);
                    } else if (_typeHelp == HelperReason.REASON_BUY_HERO) {
                        (g.windowsManager.currentWindow as WOShopNew).addArrowAtPos(0);
                    } else if (_typeHelp == HelperReason.REASON_BUY_ANIMAL) {
                        (g.windowsManager.currentWindow as WOShopNew).openOnResource(_questBuilId);
                        (g.windowsManager.currentWindow as WOShopNew).addItemArrow(_questBuilId);
                    } else if (_typeHelp == HelperReason.REASON_BUY_FARM) {
                        (g.windowsManager.currentWindow as WOShopNew).openOnResource(_questBuilId);
                        (g.windowsManager.currentWindow as WOShopNew).addItemArrow(_questBuilId);
                    } else if (_typeHelp == HelperReason.REASON_BUY_RIDGE) {
                        (g.windowsManager.currentWindow as WOShopNew).addArrowAtPos(1);
                    } else if (_typeHelp == HelperReason.REASON_BUY_TREE) {
                        (g.windowsManager.currentWindow as WOShopNew).openOnResource(_questBuilId);
                        (g.windowsManager.currentWindow as WOShopNew).addItemArrow(_questBuilId);
                    }
                }
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'cancel':
                if (g.managerCutScenes.isCutScene) return;
                if (g.tuts.isTuts) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.toolsModifier.cancelMove();
                    g.buyHint.hideIt();
                } else {
                    cancelBoolean(false);
                }
                if (g.toolsPanel.isShowed) {
                    if (g.toolsPanel.repositoryBoxVisible) {
                        _toolsBtn.visible = false;
                        _cancelBtn.visible = true;
                        g.toolsPanel.hideRepository();
                    } else {
                        _toolsBtn.visible = true;
                        _cancelBtn.visible = false;
                        g.friendPanel.showIt();
                        g.toolsPanel.hideIt();
                    }
                }
                break;
            case 'friend':
                if (_boolFriend == true) {
                    _boolFriend = false;
                    g.friendPanel.showIt();
                } else {
                    _boolFriend = true;
                    g.friendPanel.hideIt();
                }
                break;
            case 'tools':
                if (g.managerMiniScenes.isMiniScene && g.managerMiniScenes.isReason(ManagerMiniScenes.GO_NEIGHBOR)) g.managerMiniScenes.finishLetGoToNeighbor();
                g.managerHelpers.onUserAction();
                if (g.managerCutScenes.isCutScene)  {
                    if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_TO_INVENTORY_DECOR)) {
                        if (g.toolsModifier.modifierType != ToolsModifier.NONE) return;
                    } else if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_FROM_INVENTORY_DECOR)) {

                    } else return;
                }
                if (g.tuts.isTuts) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                if (_boolTools == false) {
                    _boolTools = true;
                    g.toolsPanel.showIt();
                    _imArrow.scaleX = -1;
                    _imArrow.x = 77;
                } else {
                    _boolTools = false;
                    g.toolsPanel.hideIt();
                    _imArrow.scaleX = 1;
                    _imArrow.x = 19;
                }
//                g.toolsPanel.hideRepository();
                break;
            case 'option':
                g.managerHelpers.onUserAction();
                if (g.managerCutScenes.isCutScene) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                if (g.optionPanel.isShowed) {
                     g.optionPanel.hideIt();
                 } else {
                     g.optionPanel.showIt();
                 }
                g.toolsPanel.hideRepository();
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'order':
                if (g.managerCutScenes.isCutScene) return;
                if (g.tuts.isTuts) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    cancelBoolean(false);
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                g.windowsManager.openWindow(WindowsManager.WO_ORDERS_NEW, null);
                g.toolsPanel.hideRepository();
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'ambar':
                if (g.managerCutScenes.isCutScene) return;
                if (g.tuts.isTuts) return;
                if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
                    g.toolsModifier.cancelMove();
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                }
                g.windowsManager.openWindow(WindowsManager.WO_AMBAR, null);
                g.toolsPanel.hideRepository();
                if (g.buyHint.showThis) g.buyHint.hideIt();
                break;
            case 'door':
                if (g.managerCutScenes.isCutScene) return;
                if (g.tuts.isTuts) {
                    if (g.tuts.action == TutsAction.GO_HOME) {
                        g.tuts.checkTutsCallback();
                    } else return;
                }
                deleteArrow();   
                if (g.isAway) g.townArea.backHome();
                if (g.partyPanel) g.partyPanel.visiblePartyPanel(true);
                break;
        }
    }

    public function showToolsForCutScene():void { onClick('tools'); }
    public function onResizePanelFriend():void {
        if (_friendSpr) {
//            _friendSpr.x = g.managerResize.stageWidth/2;
            _friendSpr.y = g.managerResize.stageHeight - 83;
        }
    }

    public function onResize():void {
        if (!_source) return;
        _source.x = g.managerResize.stageWidth - 271;
        _source.y = g.managerResize.stageHeight - 83;
    }

    public function cancelBoolean(b:Boolean):void {
        _cancelBtn.visible = b;
//        _toolsBtn.visible = !b;
    }

    public function doorBoolean(b:Boolean,person:Someone = null):void {
        _person = person;
        _homeBtn.visible = b;
        _shopBtn.visible = !b;
//        _ambarBtn.visible = !b;
//        _orderBtn.visible = !b;
        _toolsBtn.visible = !b;
        _cancelBtn.visible = false;
        removeHelpIcon();
        if (_friendBoard) {
            if (b) {
                while (_friendBoard.numChildren) {
                    _friendBoard.removeChildAt(0);
                }
                friendBoard();
            } else {
                while (_friendBoard.numChildren) {
                    _friendBoard.removeChildAt(0);
                }
            }
        }
    }

    public function onFullOrder(v:Boolean):void {
//        if (v) {
//            _checkSprite.visible = true;
//            animateCheckSprite1();
//        } else {
//            _checkSprite.visible = false;
//            TweenMax.killTweensOf(_checkSprite);
//        }
    }

    private function friendBoard():void {
        var im:Image;
        var txt:CTextField;
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 71, 71);
        _ava.x = 9;
        _ava.y = 8;
        _friendBoard.addChild(_ava);
        if (_person is NeighborBot) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
        } else {
            if (_person.photo) {
                g.load.loadImage(_person.photo, onLoadPhoto);
            }
    }
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_board'));
        _friendBoard.addChild(im);
        txt = new CTextField(150,40,'');
        txt.needCheckForASCIIChars = true;
        txt.setFormat(CTextField.BOLD18, 18, ManagerFilters.BROWN_COLOR);
        txt.text = _person.name;
        txt.x = 90;
        txt.y = 20;
        _friendBoard.addChild(txt);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('star'));
        im.x = 60;
        im.y = 50;
        MCScaler.scale(im,45,45);
        _friendBoard.addChild(im);
        txt = new CTextField(50,50,String(_person.level));
        txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        if (_person is NeighborBot) txt.text = '60';
        txt.x = 55;
        txt.y = 49;
        _friendBoard.addChild(txt);
        if (_person != g.user.neighbor) {
            var i:int;
            var b:Boolean = false;
                for (i = 0; i < g.friendPanel.arrNeighborFriends.length; i++) {
                    if (_person.userId == g.friendPanel.arrNeighborFriends[i].userId) {
                        b = true;
                        break;
                    }
                }
            if (g.friendPanel.arrNeighborFriends.length != 5 && !b) {
                for (i= 0; i < g.user.arrFriends.length; i++) {
                    if (_person.userSocialId == g.user.arrFriends[i].userSocialId) return;
                }
                _btnPlusMinus = new CButton();
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
                MCScaler.scale(im, 27, 27);
                _btnPlusMinus.addDisplayObject(im);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
                MCScaler.scale(im, 16, 16);
                im.x = 6;
                im.y = 6;
                _btnPlusMinus.addDisplayObject(im);
                _btnPlusMinus.clickCallback = onClickAddNeighbor;
                _btnPlusMinus.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[1076])) };
                _btnPlusMinus.outCallback = function():void { g.hint.hideIt() };
                _friendBoard.addChild(_btnPlusMinus);
                _btnPlusMinus.y = 60;
                _btnPlusMinus.x = -10;
            } else if (g.friendPanel.arrNeighborFriends.length == 5 || b) {
                for (i= 0; i < g.friendPanel.arrNeighborFriends.length; i++) {
                    if (g.friendPanel.arrNeighborFriends[i].userId == _person.userId) {
                        _btnPlusMinus = new CButton();
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
                        MCScaler.scale(im, 27, 27);
                        _btnPlusMinus.addDisplayObject(im);
                        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('minus'));
                        MCScaler.scale(im, 16, 16);
                        im.x = 6;
                        im.y = 10;
                        _btnPlusMinus.addDisplayObject(im);
                        _btnPlusMinus.clickCallback = onClickDeleteNeighbor;
                        _btnPlusMinus.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[1077])) };
                        _btnPlusMinus.outCallback = function():void { g.hint.hideIt() };
                        _friendBoard.addChild(_btnPlusMinus);
                        _btnPlusMinus.y = 60;
                        _btnPlusMinus.x = -10;
                        break;
                    }
                }
            }
        }
    }

    private function onClickAddNeighbor ():void {
        g.friendPanel.addNeighborFriend(_person);
        if (_btnPlusMinus) {
            _friendBoard.removeChild(_btnPlusMinus);
            _btnPlusMinus.deleteIt();
            _btnPlusMinus = null;
        }
        _btnPlusMinus = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 27, 27);
        _btnPlusMinus.addDisplayObject(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('minus'));
        MCScaler.scale(im, 16, 16);
        im.x = 6;
        im.y = 10;
        _btnPlusMinus.addDisplayObject(im);
        _btnPlusMinus.clickCallback = onClickDeleteNeighbor;
        _btnPlusMinus.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[1077])) };
        _btnPlusMinus.outCallback = function():void { g.hint.hideIt() };
        _friendBoard.addChild(_btnPlusMinus);
        _btnPlusMinus.y = 60;
        _btnPlusMinus.x = -10;
    }
//    g.user.isTester

    private function onClickDeleteNeighbor ():void {
        g.friendPanel.deleteNeighborFriend(_person);
        if (_btnPlusMinus) {
            _friendBoard.removeChild(_btnPlusMinus);
            _btnPlusMinus.deleteIt();
            _btnPlusMinus = null;
        }
        _btnPlusMinus = new CButton();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plus_button'));
        MCScaler.scale(im, 27, 27);
        _btnPlusMinus.addDisplayObject(im);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('cross'));
        MCScaler.scale(im, 16, 16);
        im.x = 6;
        im.y = 6;
        _btnPlusMinus.addDisplayObject(im);
        _btnPlusMinus.clickCallback = onClickAddNeighbor;
        _btnPlusMinus.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[1076])) };
        _btnPlusMinus.outCallback = function():void { g.hint.hideIt() };
        _friendBoard.addChild(_btnPlusMinus);
        _btnPlusMinus.y = 60;
        _btnPlusMinus.x = -10;
    }

    public function addHelpIcon():void {
        // _person === g.visitedUser
        var sp:CSprite = new CSprite();
        if (_person && _person.needHelpCount > 0) {
            _friendBoardHelpInfo = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
            _friendBoardHelpInfo.x = 65;
            _friendBoardHelpInfo.y = 5;
            sp.addChild(_friendBoardHelpInfo);
            sp.hoverCallback = function():void { g.hint.showIt(String(g.managerLanguage.allTexts[481])); };
            sp.outCallback = function():void { g.hint.hideIt(); };
            _friendBoard.addChild(sp);
        }
    }

    public function removeHelpIcon():void {
        if (_friendBoardHelpInfo) {
            if (_friendBoard.contains(_friendBoardHelpInfo)) _friendBoard.removeChild(_friendBoardHelpInfo);
            _friendBoardHelpInfo.dispose();
            _friendBoardHelpInfo = null;
        }
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            bitmap = g.pBitmaps[_person.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('FriendItem:: no photo for userId: ' + _person.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        if (!tex) return;
        _ava = new Image(tex);
        MCScaler.scale(_ava,71,71);
        _ava.x = 9;
        _ava.y = 8;
        _friendBoard.addChild(_ava);
    }

    public function getShopButtonProperties():Object {
        var obj:Object = {};
        obj.x = _shopBtn.x - _shopBtn.width/2;
        obj.y = _shopBtn.y - _shopBtn.height/2;
        var p:Point = new Point(obj.x, obj.y);
        p = _source.localToGlobal(p);
        obj.x = p.x;
        obj.y = p.y;
        obj.width = _shopBtn.width;
        obj.height = _shopBtn.height;
        return obj;
    }
    
    public function activateShopButtonHoverAnimation(v:Boolean):void {
        if (v) _shopBtn.releaseHoverAnimation();
            else _shopBtn.finishHoverAnimation();
    }

    public function set tutorialCallback(f:Function):void {
        _tutorialCallback = f;
    }

    public function getBtnProperties(type:String):Object {
        var ob:Object = {};
        var p:Point = new Point();
        switch (type) {
            case 'home':
                p.x = 0;
                p.y = 0;
                p = _homeBtn.localToGlobal(p);
                ob.x = p.x;
                ob.y = p.y;
                ob.width = _homeBtn.width;
                ob.height = _homeBtn.height;
                return ob;
                break;
        }

        return ob;
    }

    public function addArrow(btnName:String, t:Number = 0, resourceId:int = 0, typeId:int = 0):void {
        deleteArrow();
        switch (btnName) {
            case 'shop':
                _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
                _arrow.animateAtPosition(_shopBtn.x, _shopBtn.y - _shopBtn.height/2 - 10);
                if (resourceId >= 1) {
                    _questBoolean = true;
                    _questBuilId = resourceId;
                    _typeHelp = typeId;
                }

                break;
            case 'home':
                _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, _source);
                _arrow.animateAtPosition(_homeBtn.x, _homeBtn.y - _homeBtn.height/2 - 10);
                break;
        }
        if (g.tuts.isTuts) {
            if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) _arrow.scaleIt(1.2);
                else _arrow.scaleIt(1.4);
        } else _arrow.scaleIt(.7);
        if (t) _arrow.activateTimer(t, deleteArrow);
    }

    public function deleteArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
        _questBoolean = false;
    }

    public function hideMainPanel():void { // for tutorial
        _source.x = g.managerResize.stageWidth - 271;
        _source.y = g.managerResize.stageHeight + 83;
        _source.visible = false;
    }

    public function animateShowingMainPanel():void { // for tutorial
        _source.visible = true;
        new TweenMax(_source, 1, {y:g.managerResize.stageHeight - 83, ease:Back.easeOut});
    }

    public function updateNotification():void {
        var c:int = g.user.notif.allNotificationsCount;
        if (c>0) {
            _imNotification.visible = true;
            _txtNotification.visible = true;
            _txtNotification.text = String(c);
        } else {
            _imNotification.visible = false;
            _txtNotification.visible = false;
        }
    }

}
}
