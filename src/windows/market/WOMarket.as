/**
 * Created by user on 7/23/15.
 */
package windows.market {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import com.junkbyte.console.Cc;
import flash.display.Bitmap;
import manager.ManagerFilters;
import media.SoundConst;
import social.SocialNetwork;
import social.SocialNetworkEvent;
import starling.animation.Tween;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import tutorial.managerCutScenes.ManagerCutScenes;

import user.NeighborBot;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.TimeUtils;
import utils.Utils;
import windows.WOComponents.WindowBackgroundNew;
import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.WindowBackground;
import windows.WindowMain;
import windows.WindowsManager;

public class WOMarket  extends WindowMain {
    private var _woBG:WindowBackgroundNew;
    private var _shopSprite:Sprite;
    private var _contRect:Sprite;
    private var _contItem:Sprite;
    private var _contItemCell:Sprite;
    private var _btnRefresh:CSprite;
    private var _leftBtn:CSprite;
    private var _rightBtn:CSprite;
    private var _contPaper:Sprite;
    private var _arrItems:Array;
    private var _arrItemsTemp:Array;
    private var _arrItemsFriend:Array;
    private var _arrFriends:Array;
    private var _txtName:CTextField;
    private var _txtTimerPaper:CTextField;
    private var _curUser:Someone;
    private var _item:MarketFriendItem;
    private var _item2:MarketFriendItem;
    private var _item3:MarketFriendItem;
    private var _ma:MarketAllFriend;
    private var _shiftFriend:int = 0;
    private var _shiftFriendVisit:int = 0;
    private var _shift:int;
    private var _countPage:int;
    private var _countAllPage:int;
    private var _panelBool:Boolean;
    private var _booleanPaper:Boolean;
    private var _callback:Function;
    private var _timer:int;
    private var _txtPaper:CTextField;
    private var _txtToPaper:CTextField;
    private var _sprLeftFr:CSprite;
    private var _sprRightFr:CSprite;
    private var _visitBtn:CButton;
    private var _ava:Image;
    private var _ramkaIm:Image;
    private var _imBabbleCutScene:Image;
    private var _txtBabbleCutScene:CTextField;

    public function WOMarket() {
        super();
        SOUND_OPEN = SoundConst.OPEN_MARKET_WINDOW;
        _windowType = WindowsManager.WO_MARKET;
//        _cont = new Sprite();
        _contItem = new CSprite();
        _arrItemsFriend = [];
        _arrItems = [];
        _shopSprite = new Sprite();
        _woWidth = 925;
        _woHeight = 615;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,110);
        _source.addChild(_woBG);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;
        _source.addChild(_contItem);
        _contItem.filter = ManagerFilters.SHADOW;
        var c:BackgroundYellowOut = new BackgroundYellowOut(800, 480);
        c.x = -c.width/2+5;
        c.y = -_woHeight/2 + 108;
        _source.addChild(c);
        _countPage = 1;
        _contRect = new Sprite();
        _contRect.mask = new Quad(720, 460);
        _contRect.mask.x = -360;
        _contRect.mask.y = -190;

        _source.addChild(_contRect);
        _contItemCell = new Sprite();
        _contRect.addChild(_contItemCell);

        _btnRefresh = new CSprite();
        var ref:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('refresh_icon'));
        _btnRefresh.addChild(ref);
        _btnRefresh.x = -320;
        _btnRefresh.y = 155;
        _btnRefresh.hoverCallback =  function():void { };
        _callbackClickBG = hideIt;
        _panelBool = false;

        _leftBtn = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        _leftBtn.addChild(im);
        _leftBtn.x = -455;
        _leftBtn.y = -25;
        _source.addChild(_leftBtn);
        _leftBtn.endClickCallback = onLeft;
        _leftBtn.hoverCallback = function():void { if (_leftBtn.filter == null)_leftBtn.filter = ManagerFilters.BUILDING_HOVER_FILTER; };
        _leftBtn.outCallback = function():void { if (_leftBtn.filter == ManagerFilters.BUILDING_HOVER_FILTER)_leftBtn.filter = null; };

        _rightBtn = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('button_yel_left'));
        im.scaleX = -1;
        im.x = im.width;
        _rightBtn.addChild(im);
        _rightBtn.x = 405;
        _rightBtn.y = -25;
        _source.addChild(_rightBtn);
        _rightBtn.endClickCallback = onRight;
        _rightBtn.hoverCallback = function():void { if (_rightBtn.filter == null) _rightBtn.filter = ManagerFilters.BUILDING_HOVER_FILTER; };
        _rightBtn.outCallback = function():void { if (_rightBtn.filter == ManagerFilters.BUILDING_HOVER_FILTER) _rightBtn.filter = null; };

        _contPaper = new Sprite();
        _source.addChild(_contPaper);
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('plawka7'));
        im.x = 58;
        im.y = 164;
        _contPaper.addChild(im);

        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('newspaper_icon_small'));
        MCScaler.scale(im,im.height/2+5, im.width/2+5);
        im.x = 12;
        im.y = 156;
        _contPaper.addChild(im);
        _visitBtn = new CButton();
        _visitBtn.addButtonTexture(160, CButton.HEIGHT_41, CButton.GREEN, true);
        _visitBtn.addTextField(160, 53, 0,-10, String(g.managerLanguage.allTexts[386]));
        _visitBtn.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _visitBtn.y = _woHeight/2;
        _source.addChild(_visitBtn);
        _visitBtn.visible = false;
        _visitBtn.clickCallback = visitPerson;

        _txtToPaper = new CTextField(200,30,String(g.managerLanguage.allTexts[401]));
        _txtToPaper.setFormat(CTextField.BOLD18, 14, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtToPaper.x = 12;
        _txtToPaper.y = 135;
        _contPaper.addChild(_txtToPaper);

        _txtTimerPaper = new CTextField(80,30,'');
        _txtTimerPaper.setFormat(CTextField.BOLD18, 16, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtTimerPaper.x = 46;
        _txtTimerPaper.y = 165;
        _contPaper.addChild(_txtTimerPaper);
        _contPaper.visible = false;
        _sprLeftFr = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_friend_bg'));
        im.scaleX = -1;
        _sprLeftFr.addChild(im);
        _sprRightFr = new CSprite();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_friend_bg'));
        _sprRightFr.addChild(im);
        _sprRightFr.endClickCallback = function():void { onChooseFriendOnPanel(_arrFriends[_shiftFriend], _shiftFriend); };
        _source.addChild(_sprLeftFr);
        _sprRightFr.x = _woWidth/2 - 64;
        _sprRightFr.y = 120;
        _sprLeftFr.x = -_woWidth/2 + 64;
        _sprLeftFr.y = 120;
        _sprLeftFr.endClickCallback = function():void {
            onChooseFriendOnPanel(_arrFriends[_shiftFriend], _shiftFriend);
        };
        _source.addChild(_sprRightFr)
    }

    private function fillFriends(e:SocialNetworkEvent=null):void {
        _arrFriends = g.user.arrFriends.slice();
        for (var i:int = 0; i <_arrFriends.length; i++) {
            if (_arrFriends[i].level < 5 || _arrFriends[i].level == 0) {
                _arrFriends.splice(i,1);
                i--;
            }
        }
        _arrFriends.unshift(g.user.neighbor);
        _arrFriends.unshift(g.user);
        _txtName = new CTextField(300, 80, '');
        _txtName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txtName.alignH = Align.LEFT;
        _txtName.y = -295;
        _txtName.x = -120;
        _ma = new MarketAllFriend(_arrFriends, this, btnFriend);
        _source.addChild(_ma.source);
    }

    override public function showItParams(f:Function, params:Array):void {
        if (!g.userValidates.checkInfo('level', g.user.level)) return;
        _arrFriends = [];
        fillFriends();
        _countPage = 1;
        _callback = f;
        if (params[0]) {
            _curUser = params[0];
            for (var i:int=0; i < _arrFriends.length; i++) {
                if (_arrFriends[i].userSocialId == _curUser.userSocialId) {
                    _shiftFriend = i;
                }
            }
            if(_shiftFriend == 0)  {
                if (_curUser.userSocialId == g.user.userSocialId) createMarketTabBtns();
                else {
                    createAva();
                    if ((g.visitedUser && _curUser != g.visitedUser) || !g.visitedUser) _visitBtn.visible = true;
                    createMarketTabBtns(true);
                }
            } else {
                if (_curUser == g.user) {
                    _visitBtn.visible = false;
                    deleteAva();
                    _txtName.x = -120;
                } else {
                    if (_curUser != g.visitedUser) _visitBtn.visible = true;
                    _txtName.x = -110;
                    createAva();
                    _shiftFriendVisit = _shiftFriend;
                }
                createMarketTabBtns();
            }
            choosePerson(_curUser);
        }

        if (g.managerCutScenes.isCutScene && g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_GO_TO_NEIGHBOR)) babbleMiniScene();
        _timer = 15;
        g.gameDispatcher.addToTimer(refreshMarketTemp);
        onWoShowCallback = onShow;
        super.showIt();
    }

    private function onShow():void {
        if (_curUser is NeighborBot) Utils.createDelay(.5, g.miniScenes.atNeighborBuyInstrument);
    }

    private function onClickExit(e:Event=null):void {
        if (g.tuts.isTuts) return;
        if (g.managerCutScenes.isCutScene) {
            if (g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_GO_TO_NEIGHBOR)) g.managerCutScenes.checkCutSceneCallback();
            else return;
        }
        _timer = 15;
        g.gameDispatcher.removeFromTimer(refreshMarketTemp);
        super.hideIt();
    }

    public function get curUser():Someone {
        return _curUser;
    }

    private function clearItems():void {
        while (_contItemCell.numChildren) {
            _contItemCell.removeChildAt(0);
        }
        for (var i:int=0; i<_arrItems.length; i++) {
            _arrItems[i].deleteIt();
        }
        _arrItems.length = 0;
    }

    private function addItems():void {
        var item:MarketItem;

        if (_curUser.marketCell <= 0) {
            _curUser.marketCell = 6;
            if (_curUser == g.user) g.server.updateUserMarketCell(0, null);
        }

        var marketCellCount:int = _curUser.marketCell;
        if (g.user == _curUser) {
            marketCellCount += 1;
            if (marketCellCount > 40) marketCellCount = 40;
        }

        for (var i:int=0; i < marketCellCount; i++) {
            if (i+1 > _curUser.marketCell) item = new MarketItem(i, true, this);
                else item = new MarketItem(i, false, this);
            if (i+1 <= 8) {
                item.source.x = 180*(_arrItems.length%4) - 358;
                _countAllPage = 1;
            } else if (i+1 <= 16) {
                item.source.x = 180*(_arrItems.length%4)+362;
                _countAllPage = 2;
            } else if (i+1 <= 24) {
                item.source.x = 180*(_arrItems.length%4)+1082;
                _countAllPage = 3;
            } else if (i+1 <= 32) {
                item.source.x = 180*(_arrItems.length%4)+1802;
                _countAllPage = 4;
            } else if (i+1 <= 40) {
                item.source.x = 180*(_arrItems.length%4)+2522;
                _countAllPage = 5;
            }

            if (i+1 <= 4) {
                item.source.y = -155;
            }  else if (i+1 <= 8) {
                item.source.y = 75;
            } else if (i+1 <= 12) {
                item.source.y = -155;
            } else if (i+1 <= 16) {
                item.source.y = 75;
            } else if (i+1 <= 20) {
                item.source.y = -155;
            } else if (i+1 <= 24) {
                item.source.y = 75;
            } else if (i+1 <= 28) {
                item.source.y = -155;
            } else if (i+1 <= 32) {
                item.source.y = 75;
            } else if (i+1 <= 36) {
                item.source.y = -155;
            } else if (i+1 <= 40) {
                item.source.y = 75;
            }
            _contItemCell.addChild(item.source);
            _arrItems.push(item);
        }
        checkArrow();
    }

    public function addItemsRefresh():void {
        if (_arrItems.length == 40) return;
        var item:MarketItem;
        item = new MarketItem(_arrItems.length, true, this);

        if (_arrItems.length  <= 7) {
            item.source.x = 180*(_arrItems.length%4) - 358;
            _countAllPage = 1;
        } else  if (_arrItems.length  <= 15) {
            item.source.x = 180*(_arrItems.length%4)+362;
            _countAllPage = 2;
        } else if (_arrItems.length  <= 23) {
            item.source.x = 180*(_arrItems.length%4)+1082;
            _countAllPage = 3;
        } else if (_arrItems.length  <= 31) {
            item.source.x = 180*(_arrItems.length%4)+1802;
            _countAllPage = 4;
        } else if (_arrItems.length <= 39) {
            item.source.x = 180*(_arrItems.length%4)+2522;
            _countAllPage = 5;
        }

        if (_arrItems.length  <= 3) {
            item.source.y = -155;
        }  else if (_arrItems.length  <= 7) {
            item.source.y = 75;
        } else if (_arrItems.length  <= 11) {
            item.source.y = -155;
        } else if (_arrItems.length  <= 15) {
            item.source.y = 75;
        } else if (_arrItems.length  <= 19) {
            item.source.y = -155;
        } else if (_arrItems.length  <= 23) {
            item.source.y = 75;
        } else if (_arrItems.length  <= 27) {
            item.source.y = -155;
        } else if (_arrItems.length  <= 31) {
            item.source.y = 75;
        } else if (_arrItems.length  <= 35) {
            item.source.y = -155;
        } else if (_arrItems.length  <= 39) {
            item.source.y = 75;
        }
        _contItemCell.addChild(item.source);
        _arrItems.push(item);
        checkArrow();
    }

    private function fillItems():void {
        var i:int;
        if (_curUser is NeighborBot) {
            for (i = 0; i < _arrItems.length; i++) {
                _arrItems[i].friendAdd();
                if (_curUser.marketItems[i]) {
                    if (_curUser == g.user.neighbor && _curUser.marketItems[i].resourceId == -1) continue;
                    (_arrItems[i] as MarketItem).fillFromServer(_curUser.marketItems[i], _curUser);
                }
            }
        } else {
            for (i = 0; i < _arrItems.length; i++) {
                if (_curUser == g.user) _arrItems[i].friendAdd(true);
                else _arrItems[i].friendAdd(false);
            }
            for (i = 0; i < _curUser.marketItems.length; i++) {
                if (_curUser.marketItems[i].numberCell == _arrItems.length) {
                    (_arrItems[_curUser.marketItems[i].numberCell-1] as MarketItem).fillFromServer(_curUser.marketItems[i], _curUser);
                } else {
                    (_arrItems[_curUser.marketItems[i].numberCell] as MarketItem).fillFromServer(_curUser.marketItems[i], _curUser);
                }
            }
            if (_shiftFriend != 0) goToItemFromPaper();
        }
    }

    private function goToItemFromPaper():void {
        for (var i:int = 0; i < _curUser.marketItems.length; i++) {
            if (_curUser.marketItems[i].resourceId == _curUser.idVisitItemFromPaper && _curUser.marketItems[i].inPapper) {
                if (_curUser.marketItems[i].numberCell <= 8) {
                    _countPage = 1;
                    _shift = 0;
                } else if (_curUser.marketItems[i].numberCell+1 <= 16) {
                    _countPage = 2;
                    _shift = 4;
                } else if (_curUser.marketItems[i].numberCell+1 <= 24) {
                    _countPage = 3;
                    _shift = 8;
                } else if (_curUser.marketItems[i].numberCell+1 <= 32) {
                    _countPage = 4;
                    _shift = 12;
                } else if (_curUser.marketItems[i].numberCell+1 <= 40) {
                    _shift = 16;
                    _countPage = 5;
                }
                break;
            }
        }
        new TweenMax(_contItemCell, .5, {x: -_shift * 180});
        checkArrow();
    }

    private function makeRefresh():void {
        if (g.managerCutScenes.isCutScene || g.tuts.isTuts) return;
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].unFillIt();
        }
        g.server.getUserMarketItem(_curUser.userSocialId, fillItems);
    }

    public function refreshItemWhenYouBuy ():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            _arrItems[i].unFillIt();
        }
        fillItems();
    }

    public function refreshMarket():void {
        for (var i:int=0; i< _arrItems.length; i++) {
            if(!_arrItems[i].number) {
                break;
            }
            _arrItems[i].unFillIt();
        }
        g.server.getUserMarketItem(_curUser.userSocialId, fillItems);
        createMarketTabBtns();
        _countPage = 1;
        checkArrow();
    }

    private function onClickPaper():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.user.hardCurrency < 1) {
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        g.windowsManager.cashWindow = this;
        super.hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_BUY_FOR_HARD, callbacKPapperBtn, 'market');
    }

    private function callbacKPapperBtn():void {
        g.userInventory.addMoney(1,-1);
        g.userTimer.papperTimerAtMarket = 0;
        g.server.skipUserInPaper(null);
        g.gameDispatcher.removeFromTimer(onTimer);
        _txtTimerPaper.text = '';
        _booleanPaper = true;
        _contPaper.visible = false;
        for (var i:int = 0; i < _curUser.marketItems.length; i++) {
            _arrItems[_curUser.marketItems[i].numberCell].visiblePapperTimer();
        }
    }

    public function get booleanPaper():Boolean {
        return _booleanPaper;
    }

    public function startPapperTimer():void {
        g.userTimer.startUserMarketTimer(300);
        _booleanPaper = false;
        for (var i:int = 0; i < _curUser.marketItems.length; i++) {
            _arrItems[_curUser.marketItems[i].numberCell].visiblePapperTimer();
        }
    }

    private function checkPapperTimer():void {
        if (g.userTimer.papperTimerAtMarket > 0) {
            _txtTimerPaper.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.papperTimerAtMarket);
            g.userTimer.startUserMarketTimer(g.userTimer.papperTimerAtMarket);
            g.gameDispatcher.addToTimer(onTimer);
            _booleanPaper = false;
            _contPaper.visible = true;
        } else {
            _booleanPaper = true;
            _contPaper.visible = false;
            _txtTimerPaper.text = '';
            g.gameDispatcher.removeFromTimer(onTimer);
        }
    }

    private function onTimer():void {
        if (g.userTimer.papperTimerAtMarket > 0) {
            if (_txtTimerPaper) _txtTimerPaper.text = TimeUtils.convertSecondsToStringClassic(g.userTimer.papperTimerAtMarket);
        } else {
                _booleanPaper = true;
                _contPaper.visible = false;
                if (_txtTimerPaper) _txtTimerPaper.text = '';
                g.gameDispatcher.removeFromTimer(onTimer);
                for (var i:int = 0; i < _curUser.marketItems.length; i++) {
                    if (_arrItems.length == 0 || _curUser != g.user) break;
                    else _arrItems[_curUser.marketItems[i].numberCell].visiblePapperTimer();
                }
            }
    }

    public function addAdditionalUser(ob:Object):void {
        _curUser = g.user.getSomeoneBySocialId(ob.userSocialId);
    }

    public function createMarketTabBtns(paper:Boolean = false):void {
        if (_arrFriends == null) {
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'Обнови сиды и сикреты');
            return;
        }
        if (_curUser.userSocialId == g.user.userSocialId) {
            _txtName.text = String(g.managerLanguage.allTexts[1280]);
        } else {
            if (paper) {
                if (_curUser.name == null ) _txtName.text = String(g.managerLanguage.allTexts[1280]);
                else {
                    _txtName.text = _curUser.name;
                }
            } else {
                if (_arrFriends[_shiftFriend].name == null ) _txtName.text = String(g.managerLanguage.allTexts[1280]);
                else {
                    _txtName.text = _arrFriends[_shiftFriend].name;
                }
            }
        }
        _source.addChild(_txtName);

        if (_arrFriends.length <= 2) {
            _item = new MarketFriendItem(_arrFriends[_shiftFriend], this, _shiftFriend);
            if (g.isAway) {
                if (_arrFriends[_shiftFriend].userSocialId == g.visitedUser.userSocialId) {
                    _visitBtn.visible = false;
                    deleteAva();
                    _txtName.x = -120;
                }
            }
            _item.source.x = 10;
            _item.source.y = 25;
            _sprRightFr.addChild(_item.source);
            if (_shiftFriend == 1) {
                _shiftFriend = -1;
            }
            if (_arrFriends[_shiftFriend + 1] == null && paper)  _item2 = new MarketFriendItem(g.user, this, _shiftFriend + 1);
            else _item2 = new MarketFriendItem(_arrFriends[_shiftFriend + 1], this, _shiftFriend + 1);
            _item2.source.x = -120;
            _item2.source.y = 25;
            _sprLeftFr.addChild(_item2.source);
            return;
        }
        if (paper) {
            _item = new MarketFriendItem(g.user, this, 0);
            if (_shiftFriend + 2 >= _arrFriends.length) {
                _shiftFriend = -1;
            }
            _shiftFriend = 1;
            _item.source.x = 10;
            _item.source.y = 25;
            _sprRightFr.addChild(_item.source);
        } else {
            if (_shiftFriend == 0) _shiftFriend++;
            else if (_shiftFriend + 1 >= _arrFriends.length) _shiftFriend = 0;
            else if (_shiftFriend != 0) _shiftFriend++;

            _item = new MarketFriendItem(_arrFriends[_shiftFriend], this, _shiftFriend);
            _item.source.x = 10;
            _item.source.y = 25;
            _sprRightFr.addChild(_item.source);
            if (_shiftFriend + 1 >= _arrFriends.length) _shiftFriend = 0;
            else _shiftFriend ++;
        }
        _item2 = new MarketFriendItem(_arrFriends[_shiftFriend], this, _shiftFriend);
        _item2.source.x = -120;
        _item2.source.y = 25;
        _sprLeftFr.addChild(_item2.source);
    }

    public function choosePerson(_person:Someone):void {
        if (!_person) {
            Cc.error('WOMarket choosePerson:: no _person');
            return;
        }
        clearItems();
        _shift = 0;
        if (_contItemCell) {
            new TweenMax(_contItemCell, .5, {x: -_shift * 180, ease: Linear.easeNone});
        }
        _countPage = 1;
        _curUser = _person;
        _timer = 15;
        g.gameDispatcher.addToTimer(refreshMarketTemp);
        if (_curUser.marketCell < 0 || _curUser != g.user) {
            if (_curUser is NeighborBot) {
                g.server.getUserNeighborMarket(onChoosePerson);
            } else {
                if (_curUser.marketItems && _curUser.marketItems.length) {
                    onChoosePerson();
                } else g.server.getUserMarketItem(_curUser.userSocialId, onChoosePerson);
            }
        } else {
            onChoosePerson();
        }
    }

    private function onChoosePerson():void {
        if (_curUser == g.user) {
            if (g.userTimer.papperTimerAtMarket > 0) _contPaper.visible = true;
            else _contPaper.visible = false;

            if (_ramkaIm) {
                _ramkaIm.dispose();
                _ramkaIm = null;
                _source.removeChild(_ramkaIm);
            }
            if (_ava) {
                _ava.dispose();
                _ava = null;
                _source.removeChild(_ava);
            }
        } else _contPaper.visible = false;
        addItems();
        fillItems();
    }

    public function onChooseFriendOnPanel(p:Someone, shift:int):void {
        choosePerson(p);
        _shiftFriend = shift;
        if (p == g.user) {
            _visitBtn.visible = false;
            deleteAva();
            _txtName.x = -120;
        } else {
            _visitBtn.visible = true;
            createAva();
            _shiftFriendVisit = _shiftFriend;
        }
        deleteFriends();
        createMarketTabBtns();
        closePanelFriend();
    }

    public function set shiftFriend(a:int):void  {
        _shiftFriend = a;
    }

    public function deleteFriends():void {
        if (_item) {
            _source.removeChild(_item.source);
            _item.deleteIt();
            _item = null;
        }
        if (_item2) {
            _source.removeChild(_item2.source);
            _item2.deleteIt();
            _item2 = null;
        }
        if (_item3) {
            _source.removeChild(_item3.source);
            _item3.deleteIt();
            _item3 = null;
        }
        _source.removeChild(_txtName);
    }

    private function btnFriend (hideCallback:Boolean = false):void {
        if (g.tuts.isTuts) return;
        if (g.managerCutScenes.isCutScene) return;
        if (hideCallback) {
            _ma.hideIt();
            _panelBool = false;
            return;
        }
        if (!_panelBool){
            _ma.showIt();
            _panelBool = true;
        } else if (_panelBool) {
            _ma.hideIt();
            _panelBool = false;
        }
    }

    public function closePanelFriend():void {
        if (_ma) _ma.hideIt();
        _panelBool = false;
    }

    public function callbackState():void {
        if (_callback != null) {
            _callback.apply(null);
            _callback = null;
        }
    }

    private function onLeft():void {
        if (g.managerCutScenes.isCutScene) return;
        if (_shift <=0 ) return;
        var tween:Tween = new Tween(_leftBtn, 0.2);
        tween.scaleTo(.6);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(1);
        g.starling.juggler.add(tween);
        if (_shift > 0) {
            _shift -= 4;
            if (_shift<0) _shift = 0;
            new TweenMax(_contItemCell, .5, {x:-_shift*180, ease:Linear.easeNone ,onComplete: function():void {}});
            _countPage--;

        }
        checkArrow();
    }

    private function onRight():void {
        if (g.managerCutScenes.isCutScene) return;
        if ((_shift+4)*2 >= _arrItems.length) return;
        var tween:Tween = new Tween(_rightBtn, 0.2);
        tween.scaleTo(.6);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
        };
        tween.scaleTo(1);
        g.starling.juggler.add(tween);
        var l:int = _arrItems.length;
        _shift += 4;
        if (_shift + 4 <= l - 1) {
            new TweenMax(_contItemCell, .5, {x:-_shift*180, ease:Linear.easeNone ,onComplete: function():void {}});
            _countPage++;
        }
        checkArrow();
    }

    public function checkArrow():void {
        if (_shift == 0) {
            if (_leftBtn) _leftBtn.visible = false;
        } else {
            if (_leftBtn) _leftBtn.visible = true;
        }
        if ((_shift+4)*2 >= _arrItems.length) {
            if (_rightBtn) _rightBtn.visible = false;
        } else {
            if (_rightBtn) _rightBtn.visible = true;
        }
    }

    public function getItemProperties(a:int):Object {
        if (_arrItems && _arrItems.length) {
            return (_arrItems[a-1] as MarketItem).getItemProperties();
        } else {
            return {};
        }
    }
    
    public function getTimerProperties():Object {
        var ob:Object = {};
        ob.x = _txtTimerPaper.x;
        ob.y = _txtTimerPaper.y;
        ob.width = 80;
        ob.height = 30;
        return ob;
    } 

    public function onItemClickAndOpenWOChoose(item:MarketItem):void {
        g.windowsManager.cashWindow = this;
        super.hideIt();
        g.windowsManager.openWindow(WindowsManager.WO_MARKET_CHOOSE, callbackFromMarketChoose, item, this);
    }

    private function callbackFromMarketChoose(item:MarketItem, a:int, level:int = 1, count:int = 0, cost:int = 0, inPapper:Boolean = false):void {
        if (a>0) {
            item.onChoose(a, level, count, cost, inPapper);
        }
    }

    private function refreshMarketTemp():void {
        if (_curUser is NeighborBot) {
            _timer = 15;
            g.gameDispatcher.removeFromTimer(refreshMarketTemp);
            return;
        }
        _timer--;
        if (_timer <= 0) {
            _arrItemsTemp = _curUser.marketItems;
            g.server.getUserMarketItem(_curUser.userSocialId, onRefreshTemp);
            g.gameDispatcher.removeFromTimer(refreshMarketTemp);
        }
    }

    private function onRefreshTemp():void {
        var b:Boolean = false;
        var i:int;
        if (_curUser is NeighborBot) {
            g.gameDispatcher.removeFromTimer(refreshMarketTemp);
            return;
        }
        if (_arrItems.length == 0 || !_arrItems) {
            return;
        }
        if (!_curUser.marketItems) return; // нужно чтобы не выполнялся этот ретурн
        if (_arrItemsTemp.length != _curUser.marketItems.length) {
            for (i=0; i< _arrItems.length; i++) {
                _arrItems[i].unFillIt();
            }
            fillItems();
        } else {
            for (i= 0; i < _curUser.marketItems.length; i++) {
                if (_arrItemsTemp[i].buyerId != _curUser.marketItems[i].buyerId || _arrItemsTemp[i].id != _curUser.marketItems[i].id) {
                   b = true;
                    break;
                }
            }
            if (b) {
                for (i = 0; i < _arrItems.length; i++) {
                    _arrItems[i].unFillIt();
                }
                fillItems();
            }
        }
        _timer = 15;
        g.gameDispatcher.addToTimer(refreshMarketTemp);
    }

    override protected function deleteIt():void {
        if (isCashed) return;
        var i:int;
        if (_txtName) {
            _source.removeChild(_txtName);
            _txtName.deleteIt();
            _txtName = null;
        }
        if (_txtPaper) {
            _txtPaper.deleteIt();
            _txtPaper = null;
        }
        if (_txtTimerPaper) {
            _contPaper.removeChild(_txtTimerPaper);
            _txtTimerPaper.deleteIt();
            _txtTimerPaper = null;
        }
        if (_txtToPaper) {
            _contPaper.removeChild(_txtToPaper);
            _txtToPaper.deleteIt();
            _txtToPaper = null;
        }

        deleteFriends();
        if (_arrItems) {
            for (i=0; i< _arrItems.length; i++) {
                _contItemCell.removeChild(_arrItems[i].source);
                _arrItems[i].deleteIt();
            }
            _arrItems.length = 0;
        }
        if (_ma) {
            _source.removeChild(_ma.source);
            _ma.deleteIt();
            _ma = null;
        }
        _source.removeChild(_leftBtn);
        _leftBtn.deleteIt();
        _leftBtn = null;
        _source.removeChild(_rightBtn);
        _rightBtn.deleteIt();
        _rightBtn = null;
        callbackState();
        super.deleteIt();
    }

    private function createAva():void {
            if (_curUser is NeighborBot) {
                photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
            } else {
                if (_curUser.photo) {
                    g.load.loadImage(_curUser.photo, onLoadPhoto);
                } else {
                    g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                    g.socialNetwork.getTempUsersInfoById([_curUser.userSocialId]);
                }
            }
    }

    private function deleteAva():void {
        if (_ava) {
            _source.removeChild(_ava);
            _ava = null;
            _source.removeChild(_ramkaIm);
            _ramkaIm = null;
        }
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        if (!_curUser.name) _curUser = g.user.getSomeoneBySocialId(_curUser.userSocialId);
        _txtName.text = _curUser.name;
        if (_curUser.photo =='' || _curUser.photo == 'unknown') {
            onLoadPhoto(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
//            _arrFriends[_shiftFriend].photo =  SocialNetwork.getDefaultAvatar();
        } else {
            g.load.loadImage(_curUser.photo, onLoadPhoto);
        }
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            bitmap = g.pBitmaps[_curUser.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('MarketFriendItem:: no photo for userId: ' + _curUser.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        deleteAva();
        _ava = new Image(tex);
        MCScaler.scale(_ava, 85, 85);
        _ava.x = -158;
        _ava.y = -295;
        if (_source) _source.addChild(_ava);
        _ramkaIm = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_friend_panel'));
        _ramkaIm.y = -300;
        _ramkaIm.x = -170;
        _source.addChild(_ramkaIm);
        _txtName.x = _ramkaIm.x + _ramkaIm.width;
    }

    private function visitPerson():void {
        if (g.partyPanel) g.partyPanel.visiblePartyPanel(false);
        g.windowsManager.uncasheWindow();
        onClickExit();
        g.townArea.goAway(_curUser);
    }

    private function babbleMiniScene():void {
        _imBabbleCutScene = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_3'));
        MCScaler.scale(_imBabbleCutScene,_imBabbleCutScene.height,_imBabbleCutScene.width-40);
        _imBabbleCutScene.scaleX = -1;
        _imBabbleCutScene.x = -150;
        _imBabbleCutScene.y = -310;
        _source.addChild(_imBabbleCutScene);

        _txtBabbleCutScene = new CTextField(300,100,String(g.managerLanguage.allTexts[1308]));
        _txtBabbleCutScene.setFormat(CTextField.BOLD24, 24,ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txtBabbleCutScene.x = -487;
        _txtBabbleCutScene.y = -305;
        _source.addChild(_txtBabbleCutScene);
    }
}
}