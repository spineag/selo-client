/**
 * Created by user on 6/24/15.
 */
package windows.market {
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import data.StructureDataResource;
import data.StructureMarketItem;
import flash.display.Bitmap;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.ManagerPartyNew;
import manager.Vars;
import quest.ManagerQuest;
import resourceItem.CraftItem;
import resourceItem.newDrop.DropObject;
import resourceItem.ResourceItem;
import social.SocialNetworkEvent;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;
import tutorial.TutsAction;
import tutorial.miniScenes.ManagerMiniScenes;
import user.NeighborBot;
import user.Someone;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.SensibleBlock;
import utils.TimeUtils;
import windows.WindowsManager;

public class MarketItem {
    public var source:CSprite;
    public var buyCont:Sprite;
    private var _costTxt:CTextField;
    private var _countTxt:CTextField;
    private var _txtPlawka:CTextField;
    private var _btnAdditem:CButton;
    private var _bg:Image;
    private var quad:Quad;
    private var isFill:int;   //0 - пустая, 1 - заполненная, 2 - купленная  , 3 - недоступна по лвлу
    private var _callback:Function;
    private var _dataResource:Object;
    private var _dataItem:StructureMarketItem;
    private var _countResource:int;
    private var _countMoney:int;
    private var _plawkaBuy:Image;
    private var _coin:Image;
    private var _plawkaCoins:Sprite;
    private var _isUser:Boolean;
    private var _imageCont:Sprite;
    private var _person:Someone;
    private var _personBuyer:Someone;
    private var _personBuyerTempItem:StructureMarketItem;
    public var number:int;
    private var _woWidth:int;
    private var _woHeight:int;
    private var _onHover:Boolean;
    private var _closeCell:Boolean;
    private var _ava:Image;
    private var _avaDefault:Image;
    private var _countBuyCell:int;
    private var _inPapper:Boolean;
    private var _delete:CButton;
    private var _btnBuyCont:CButton;
    private var _wo:WOMarket;
    private var _btnGoAwaySaleItem:CButton;
    private var _txtBuyCell:CTextField;
    private var _photoUrl:String;
    private var _ramkAva:Image;
    private var g:Vars = Vars.getInstance();

    public function MarketItem(numberCell:int, close:Boolean, wo:WOMarket) {
        _wo = wo;
        var im:Image;
        _closeCell = close;
        number = numberCell;
        source = new CSprite();
        _onHover = false;
        _woWidth = 110;
        _woHeight = 133;
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_blue_cell_big'));
        source.addChild(_bg);
        quad = new Quad(_woWidth, _woHeight,Color.WHITE);
        quad.alpha = 0;
        source.addChild(quad);
        isFill = 0;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _btnAdditem = new CButton();
        _btnAdditem.addButtonTexture(115, CButton.HEIGHT_55, CButton.YELLOW, true);
        _btnAdditem.addTextField(115, 40, 0, 0, String(g.managerLanguage.allTexts[388]));
        _btnAdditem.setTextFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        source.addChild(_btnAdditem);
        _btnAdditem.visible = true;
        _btnAdditem.y = 85;
        _btnAdditem.x = 83;
        _btnAdditem.clickCallback = onClickAddItem;
        _imageCont = new Sprite();
        source.addChild(_imageCont);
        _costTxt = new CTextField(122, 30, '');
        _costTxt.setFormat(CTextField.BOLD24, 24,ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _costTxt.cacheIt = false;
        _costTxt.y = 148;
        _costTxt.pivotX = _costTxt.width/2;
        _costTxt.x = _bg.width/2 - 15;
        _countTxt = new CTextField(122, 30, ' ');
        _countTxt.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _countTxt.cacheIt = false;
        _countTxt.alignH = Align.RIGHT;
        _countTxt.x = 23;
        _countTxt.y = 100;
        source.addChild(_countTxt);
        _plawkaCoins = new Sprite();
        source.addChild(_plawkaCoins);
        _plawkaBuy = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_blue_cell_big_white'));
        _plawkaBuy.x = 5;
        _plawkaBuy.y = 125;
        _plawkaCoins.addChild(_plawkaBuy);
        _coin = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_small'));
        _coin.y = 148;
        _coin.x = _bg.width/2 + 15;
        _plawkaCoins.addChild(_coin);
        _plawkaCoins.addChild(_costTxt);
        _txtPlawka = new CTextField(120,60, String(g.managerLanguage.allTexts[389]));
        _txtPlawka.setFormat(CTextField.BOLD24, 18, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtPlawka.cacheIt = false;
        _txtPlawka.x = 25;
        _txtPlawka.y = 125;
        _txtPlawka.visible = false;
        _plawkaCoins.addChild(_txtPlawka);
        _plawkaCoins.visible = false;
        _delete = new CButton();
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('trash'));
        _delete.addDisplayObject(im);
        _delete.setPivots();
        _delete.x = 25;
        _delete.y = 110;
        source.addChild(_delete);
        _delete.clickCallback = onClickDelete;
        _delete.hoverCallback = function ():void {
            if (g.marketHint.isShowed) g.marketHint.hideIt();
            g.hint.showIt(String(g.managerLanguage.allTexts[391]),'market_delete');
        };
        _delete.outCallback = function ():void {
            g.hint.hideIt();
        };
        _delete.visible = false;
        _ramkAva = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_friend_panel'));
        source.addChild(_ramkAva);
        _ramkAva.y = -_ramkAva.height/2 + 15;
        _ramkAva.x = _ramkAva.width/4;
        _ramkAva.visible = false;
        if (_closeCell) {
            buyCont = new Sprite();
            if (numberCell == 5) _countBuyCell = 5;
            else _countBuyCell = (numberCell - 5) * 2 + 5;
            source.addChild(buyCont);
            _txtBuyCell = new CTextField(122,30,String(String(_countBuyCell)));
            _txtBuyCell.setFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
            _txtBuyCell.cacheIt = false;
            _txtBuyCell.x = 15;
            _txtBuyCell.y = 3;
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins_small'));
            _btnBuyCont = new CButton();
            _btnBuyCont.addButtonTexture(100, CButton.HEIGHT_41, CButton.GREEN, true);
            _btnBuyCont.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.HARD_GREEN_COLOR);
            var sens:SensibleBlock = new SensibleBlock();
            sens.textAndImage(_txtBuyCell,im,100);
            _btnBuyCont.addSensBlock(sens,0,18);
            _btnBuyCont.y = 160;
            _btnBuyCont.x = 85;
            _btnBuyCont.clickCallback = onClickBuy;
            buyCont.addChild(_btnBuyCont);
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('fs_add_button'));
            im.x = 48;
            im.y = 50;
            buyCont.addChild(im);
            _btnAdditem.visible = false;
        } else {
            source.endClickCallback = onClickAddItem;
        }
    }

    private function fillIt(data:Object, count:int,cost:int):void {
        if (_imageCont) unFillIt();
        var im:Image;
        _dataResource = data;
        if (_dataResource) {
            if (_dataResource.buildType == BuildType.PLANT) {
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(_dataResource.imageShop + '_icon'));
            } else {
                im = new Image(g.allData.atlas[_dataResource.url].getTexture(_dataResource.imageShop));
            }
            if (!im) {
                Cc.error('MarketItem fillIt:: no such image: ' + _dataResource.imageShop);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketItem');
                return;
            }
            im.pivotX = im.width/2;
            im.pivotY = im.height/2;
            im.x = _bg.width/2;
            im.y = _bg.height/2-8;
            _imageCont.addChild(im);
        } else {
            Cc.error('MarketItem fillIt:: empty _data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'marketItem');
            return;
        }
        _btnAdditem.visible = false;
        _countResource = count;
        _countMoney = cost;
        _countTxt.text = String(_countResource);
        _countTxt.visible = true;

        _plawkaCoins.visible = true;
        _costTxt.text = String(cost);
        if (_isUser) {
            visiblePapperTimer();
        }
    }

    public function onChoose(id:int, level:int, count:int, cost:int, inPapper:Boolean):void { // callback from WOMarketChoose
        if (isFill == 1) return;
        isFill = 1;
        g.server.addUserMarketItem(id, level, count, inPapper, cost, number, onAddToServer);
        g.user.countStand +=1;
        g.server.updateUserCountStand(null);
    }

    private function onAddToServer(ob:Object, id:int, count:int):void {
        _dataItem = new StructureMarketItem(ob);
        _dataItem.isNextDay = false;
        g.user.marketItems.push(_dataItem);
        fillIt(g.allData.getResourceById(_dataItem.resourceId), _dataItem.resourceCount, _dataItem.cost);
        g.userInventory.addResource(id, -count);
        if(_dataItem.inPapper) {
            g.server.updateMarketPapper(number, true, null);
            _inPapper = true;
        }
        _btnAdditem.visible = false;
        g.managerQuest.onActionForTaskType(ManagerQuest.SET_IN_PAPER);
    }

    public function clearImageCont():void {
        if (!_imageCont) return;
        while (_imageCont.numChildren) {
            _imageCont.removeChildAt(0);
        }
    }

    private function onClickBuy():void {
        if (_countBuyCell > g.user.hardCurrency) {
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
            g.windowsManager.openWindow(WindowsManager.WO_BUY_CURRENCY, null, true);
            return;
        }
        _btnBuyCont.clickCallback = null;
        g.userInventory.addMoney(1,-_countBuyCell);
        var f1:Function = function ():void {
            g.user.marketCell++;
            _btnAdditem.visible = true;
            source.endClickCallback = onClickAddItem;
            _wo.addItemsRefresh();
            _closeCell = false;
            _isUser = true;
            while (buyCont.numChildren) {
                buyCont.removeChildAt(0);
            }
        };
        g.server.updateUserMarketCell(1,f1);
    }

    private function onPaper():void {
        if (_inPapper) return;
        _inPapper = true;
        _dataItem.inPapper = true;
        g.managerAchievement.addAll(11,1);
        g.hint.hideIt();
        _dataItem.timeInPapper = TimeUtils.currentSeconds;
        g.server.updateMarketPapper(number,true,null);
    }

    public function visiblePapperTimer():void {
        if (isFill == 0 || isFill == 2) return;
//        if (_inPapper) {
//            if ((int(new Date().getTime() / 1000) - _dataFromServer.timeInPapper) * (-1) <= 10800) {
//                if (_papperBtn) {
//                    _papperBtn.visible = true;
//                    _papperBtn.alpha = .8;
//                }
//                if (_imCheck) _imCheck.visible = true;
//            } else {
//                if (_papperBtn) {
//                    _papperBtn.visible = false;
//                    _papperBtn.alpha = 1;
//                }
//                _imCheck.visible = false;
//                g.server.updateMarketPapper(number, false, null);
//            }
//        } else {
//            _papperBtn.visible = true;
////            if (_papperBtn) _papperBtn.visible = _wo.booleanPaper;
//        }
    }

    private function onClickDelete():void {
        if (g.tuts.isTuts || g.managerCutScenes.isCutScene) return;

        var f1:Function = function():void {
            for (var i:int = 0; i < g.user.marketItems.length; i++) {
                if (g.user.marketItems[i].numberCell == number) {
                    if (g.user.marketItems[i].buyerId > 0) {
                        _wo.refreshItemWhenYouBuy();
                        return;
                    }
                    else break;
                }
            }
            g.windowsManager.cashWindow = _wo;
            _wo.hideIt();
            g.marketHint.hideIt();
            g.windowsManager.openWindow(WindowsManager.WO_MARKET_DELETE_ITEM, deleteCallback, _dataResource, _countResource, _dataItem.cost);
        };
        g.server.getUserMarketItem(g.user.userSocialId, f1);
    }

    private function deleteCallback():void {
        _inPapper = false;
        g.userInventory.addMoney(1,-1);
        g.userInventory.addResource(_dataResource.id, _countResource);
        g.gameDispatcher.removeFromTimer(onEnterFrame);
        g.server.deleteUserMarketItem(_dataItem.id, null);
        for (var i:int = 0; i < g.user.marketItems.length; i++) {
            if (g.user.marketItems[i].id == _dataItem.id) {
                g.user.marketItems.splice(i, 1);
                break;
            }
        }
        isFill = 0;
        unFillIt();
    }

    private function onClickAddItem():void {
//        if (g.managerCutScenes.isCutScene) return;
        if ((!_person || !_person.userSocialId)&& !_isUser) return;
        if (_closeCell) return;
        if (g.tuts.isTuts) {
            if (!_dataResource || !g.tuts.isTutsResource(_dataResource.id)) return;
        }
        _onHover = false;
        var i:int;
        if (isFill == 1) {//заполненная
            if (_isUser) {
                if (g.tuts.isTuts) return;
            } else {
                var p:Point;
                if (g.user.softCurrencyCount < _dataItem.cost) {
                    p = new Point(source.x, source.y);
                    p = source.parent.localToGlobal(p);
                    new FlyMessage(p, String(g.managerLanguage.allTexts[393]));
                    return;
                }
                var d:Object = g.allData.getResourceById(_dataItem.resourceId);
                if (d.placeBuild == BuildType.PLACE_AMBAR) {
                    if (g.userInventory.currentCountInAmbar + _dataItem.resourceCount > g.user.ambarMaxCount) {
                        p = new Point(source.x, source.y);
                        p = source.parent.localToGlobal(p);
                        g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
//                        new FlyMessage(p,String(g.managerLanguage.allTexts[394]));
                        g.marketHint.hideIt();
                        g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, true);
                        return;
                    }
                } else if (d.placeBuild == BuildType.PLACE_SKLAD) {
                    if (g.userInventory.currentCountInSklad + _dataItem.resourceCount > g.user.skladMaxCount) {
                        p = new Point(source.x, source.y);
                        p = source.parent.localToGlobal(p);
//                        new FlyMessage(p, String(g.managerLanguage.allTexts[395]));
                        g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
                        g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, false);
                        return;
                    }
                }
                if (g.tuts.isTuts) {
                    if (g.tuts.action == TutsAction.VISIT_NEIGHBOR)
                        g.tuts.checkTutsCallback();
                }
                if (g.miniScenes.isMiniScene && g.miniScenes.isReason(ManagerMiniScenes.BUY_INSTRUMENT)) g.miniScenes.checkMiniSceneCallback();

                isFill = 2;
                g.server.getUserMarketItem(_person.userSocialId, checkItemWhenYouBuy);
                g.managerQuest.onActionForTaskType(ManagerQuest.BUY_PAPER);
            }
        } else if (isFill == 0) { // пустая
            if (g.tuts.isTuts) return;
            if (_isUser) {
                _wo.onItemClickAndOpenWOChoose(this);
                _onHover = false;
                _bg.filter = null;
            }
        } else if (isFill == 3){ // недоступна по лвлу

        } else {
            if (g.tuts.isTuts) return;
            if (_isUser) { // купленная
                if (!_dataItem.isNextDay)  {
                    p = new Point(source.x + 80, source.y + 50);
                    p = source.parent.localToGlobal(p);
                    new FlyMessage(p, String(g.managerLanguage.allTexts[1736]));
                    return;
                }
                g.server.deleteUserMarketItem(_dataItem.id, null);
                for (i=0; i<g.user.marketItems.length; i++) {
                    if (g.user.marketItems[i].id == _dataItem.id) {
                        g.user.marketItems.splice(i, 1);
                        break;
                    }
                }
                g.managerAchievement.addAll(2,_countMoney);
                if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_COLLECT_TOKEN_WIN_GIFT && g.allData.atlas['partyAtlas']) {
                    var dr:DropObject = new DropObject();
                    p = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
                    g.managerParty.addUserPartyCount(1);
                    dr.addDropPartyResource(p);
                    dr.releaseIt(null, false);
                }

                if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_MARKET) {
                    g.managerParty.addUserPartyCount(1);
                }

                animCoin();
                isFill = 0;
                unFillIt();
            }
        }
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.marketHint.hideIt();
    }

    private function checkItemWhenYouBuy():void {
        var b:Boolean = true;
        var bDelete:Boolean = true;
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.marketHint.hideIt();
        if (!_person) {
            Cc.error('MarketItem checkItemWhenYouBuy:: no _person');
            return;
        }
        for (var i:int = 0; i < _person.marketItems.length; i++) {
            if (number == _person.marketItems[i].numberCell && _person.marketItems[i].buyerId > 0) {
                b = false;
                break;
            }
        }
        if (b) {
            for (i = 0; i < _person.marketItems.length; i++) {
                if (number == _person.marketItems[i].numberCell) {
                    bDelete = true;
                    break;
                } else bDelete = false;
            }
        }
        if (_person.marketItems.length == 0) bDelete = false;
        if (_person is NeighborBot) bDelete = true;
        var p:Point;
        if (!bDelete) {
            p = new Point(source.x, source.y);
            p = source.parent.localToGlobal(p);
            new FlyMessage(p, String(g.managerLanguage.allTexts[396]));
            _wo.refreshItemWhenYouBuy();
            return;
        }
        if (!b) {
            p = new Point(source.x, source.y);
            p = source.parent.localToGlobal(p);
            new FlyMessage(p, String(g.managerLanguage.allTexts[397]));
            _wo.refreshItemWhenYouBuy();
        } else {
            g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataItem.cost);
            g.userAnalytics.buyPaper++;
            g.server.updateUserAnalytics(null);
            var d:StructureDataResource = g.allData.getResourceById(_dataItem.resourceId);
            showFlyResource(d, _dataItem.resourceCount);
            g.managerAchievement.addAll(24,_dataItem.cost);
            _plawkaCoins.removeChild(_coin);
            _costTxt.text = String(g.managerLanguage.allTexts[389]);
            _costTxt.x = 82;
            _costTxt.y = 146;
            g.load.loadImage(g.user.photo, onLoadPhoto);
            _ramkAva.visible = true;
            source.filter = ManagerFilters.getButtonDisableFilter();
            if (_person == g.user.neighbor) {
                g.server.buyFromNeighborMarket(_dataItem.id, null);
                _dataItem.resourceId = -1;
            } else {
                _dataItem.userSocialId = _person.userSocialId;
                g.server.buyFromMarket(_dataItem, null);
                _dataItem.buyerId = g.user.userId;
                _dataItem.inPapper = false;
                _dataItem.buyerSocialId = g.user.userSocialId;
                g.managerPaper.onBuyAtMarket(_dataItem);
            }
            isFill = 2;
        }
    }

    public function set callbackFill(f:Function):void {
        _callback = f;
    }

    private function animCoin():void {
        var p:Point = new Point(_imageCont.width/2,_imageCont.height/2);
        p = _imageCont.localToGlobal(p);
        var d:DropObject = new DropObject();
        d.addDropMoney(DataMoney.SOFT_CURRENCY, _countMoney, p);
        d.releaseIt();
        _countMoney = 0;
        _countResource = 0;
        _inPapper = false;
        _ramkAva.visible = false;
    }

    public function unFillIt():void {
        if (_closeCell) return;
        clearImageCont();
        _countMoney = 0;
        _countResource = 0;
        source.filter = null;
        if (_ramkAva) _ramkAva.visible = false;
        if (_costTxt) _costTxt.text = '';
        if(_countTxt) {
            _countTxt.text = '';
            _countTxt.visible = false;
        }
        if (isFill == 0) _btnAdditem.visible = true;
        else _btnAdditem.visible = false;
        if (_dataResource) _dataResource = null;
        if (_personBuyerTempItem) _personBuyerTempItem = null;
        if (_btnGoAwaySaleItem) {
            source.removeChild(_btnGoAwaySaleItem);
            _btnGoAwaySaleItem.deleteIt();
            _btnGoAwaySaleItem = null;
        }
        if (_plawkaBuy) _plawkaBuy.visible = true;
        if (_plawkaCoins) _plawkaCoins.visible = false;
        if (_txtPlawka) _txtPlawka.visible = false;
        if (_delete) _delete.visible = false;
        g.gameDispatcher.removeEnterFrame(onEnterFrame);
        g.marketHint.hideIt();
    }

    public function fillFromServer(obj:StructureMarketItem, p:Someone):void {
        if (_closeCell) return;
        _person = p;
        _dataItem = obj;
        if (_dataItem.buyerId != 0) {
            isFill = 2;
            _inPapper = _dataItem.inPapper;
            if (_person.userSocialId == g.user.userSocialId) { //saled user item
                try {
                    if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_MARKET) {
                        _dataItem.cost *= g.managerParty.coefficient;
                    }
                    showSaleImage(g.allData.getResourceById(_dataItem.resourceId), _dataItem.cost);
                } catch (e:Error) {
                    Cc.error('at showSaleImage');
                }
                _btnAdditem.visible = false;
            } else { // sale away item
                fillIt(g.allData.getResourceById(_dataItem.resourceId), _dataItem.resourceCount, _dataItem.cost);
                _costTxt.text = String(g.managerLanguage.allTexts[389]);
                _costTxt.x = 82;
                _costTxt.y = 146;
                _avaDefault = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                if (_avaDefault) {
                    MCScaler.scale(_avaDefault, 85, 85);
                    _avaDefault.pivotX = _avaDefault.width / 2;
                    _avaDefault.pivotY = _avaDefault.height / 2;
                    _avaDefault.x = _bg.width / 2 - 9;
                    _avaDefault.y = 5;
                    _imageCont.addChild(_avaDefault);
                    _ramkAva.visible = true;
                } else {
                    Cc.error('MarketItem:: no default_avatar_big');
                }

                for (var i:int = 0; i < _person.marketItems.length; i++) {
                    if (number == _person.marketItems[i].numberCell) {
                        _personBuyerTempItem = _person.marketItems[i];
                        if (_personBuyerTempItem) {
                            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                            g.socialNetwork.getTempUsersInfoById([_personBuyerTempItem.buyerSocialId]);
                        }
                        break;
                    }
                }
                _coin.visible = false;
                source.filter = ManagerFilters.getButtonDisableFilter();
            }
        } else { //have Item
            isFill = 1;
            if (_person is NeighborBot) {
                if (g.allData.getResourceById(_dataItem.resourceId).buildType == BuildType.INSTRUMENT) {
                    _dataItem.resourceCount = 1;
                    _dataItem.cost *= 3;
                }
            }

            _inPapper = _dataItem.inPapper;
            fillIt(g.allData.getResourceById(_dataItem.resourceId), _dataItem.resourceCount, _dataItem.cost);
            if (g.allData.getResourceById(_dataItem.resourceId).blockByLevel > g.user.level) { //have item but your level so small
                if (_plawkaBuy) {
                    _plawkaCoins.removeChild(_plawkaBuy);
                    _plawkaBuy.dispose();
                    _plawkaBuy = null;
                }
                _plawkaBuy = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_cell_big_white_2'));
                _plawkaBuy.x = 7;
                _plawkaBuy.y = 125;
                _plawkaCoins.addChildAt(_plawkaBuy,0);
                _coin.visible = false;

                _plawkaCoins.visible = true;
                _txtPlawka.text = String(String(g.managerLanguage.allTexts[398]) + " " + g.allData.getResourceById(_dataItem.resourceId).blockByLevel);
                _txtPlawka.visible = true;
                _costTxt.visible = false;
                isFill = 3;
            }
        }
    }

    public function set isUser(value:Boolean):void {
        _isUser = value;
    }

    private function showFlyResource(dat:StructureDataResource, count:int):void {
//        var resource:ResourceItem = new ResourceItem();
//        resource.fillIt(d);
        var d:DropObject = new DropObject();
        var p:Point = new Point(0, 0);
        p = _imageCont.localToGlobal(p);
        d.addDropItemNewByResourceId(_dataItem.resourceId, p, count);
        d.releaseIt(null, false);
//        var item:CraftItem = new CraftItem(0,0,resource,source,count);
//        item.releaseIt(null,false);
    }

    private function showSaleImage(data:Object, cost:int):void {
        var i:int;
        if (_imageCont) unFillIt();
        var im:Image;
        _dataResource = data;
        im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins_market'));
        MCScaler.scale(im,im.height-10,im.width-10);
        im.x = 33;
        im.y = 55;
        if (!_dataItem.isNextDay) im.filter = ManagerFilters.DISABLE_FILTER;
        _imageCont.addChild(im);
        if (_btnAdditem) _btnAdditem.visible = false;
        _countMoney = cost;
        if (_plawkaCoins) _plawkaCoins.visible = true;
        if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_MORE_COINS_MARKET) _costTxt.setFormat(CTextField.BOLD24, 24, 0xcf342f, Color.WHITE);
        if (_costTxt) _costTxt.text = String(cost);
        if (_dataItem.buyerSocialId == '1') {
            _personBuyer = g.user.neighbor;
            _personBuyerTempItem = null;
        } else {
            for (i = 0; i < g.user.arrFriends.length; i++) {
                if (_dataItem.buyerSocialId == g.user.arrFriends[i].userSocialId) {
                    _personBuyer = g.user.arrFriends[i];
                    break;
                }
            }
            if (!_personBuyer) {
                for (i = 0; i < g.user.marketItems.length; i++) {
                    if (_dataItem.buyerSocialId == g.user.marketItems[i].buyerSocialId) {
                        _personBuyerTempItem = g.user.marketItems[i];
                        break;
                    }
                }
            }
        }
        if (_personBuyer && _personBuyer is NeighborBot && !_personBuyerTempItem) {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('neighbor'));
            _ramkAva.visible = true;
        } else {
            if (!_imageCont) {
                Cc.error('MarketItem:: showScaleImage:: no _imageCont');
                return;
            }
            if (!_personBuyer) {
                _avaDefault = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                if (_avaDefault) {
                    MCScaler.scale(_avaDefault, 85, 85);
                    _avaDefault.pivotX = _avaDefault.width / 2;
                    _avaDefault.pivotY = _avaDefault.height / 2;
                    _avaDefault.x = _bg.width / 2 - 9;
                    _avaDefault.y = 5;
                    _imageCont.addChild(_avaDefault);
                    _ramkAva.visible = true;
                } else {
                    Cc.error('MarketItem:: no default_avatar_big');
                }
                if (_personBuyerTempItem && _personBuyerTempItem.buyerSocialId) {
                    g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                    g.socialNetwork.getTempUsersInfoById([_personBuyerTempItem.buyerSocialId]);
                }
                else Cc.error('MarkertItem:: No _personBuyerTemp || _personBuyerTemp.buyerSocialId');
            } else {
                if (_personBuyer.photo) {
                    _avaDefault = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
                    if (_avaDefault) {
                        MCScaler.scale(_avaDefault, 85, 85);
                        _avaDefault.pivotX = _avaDefault.width / 2;
                        _avaDefault.pivotY = _avaDefault.height / 2;
                        _avaDefault.x = _bg.width / 2 - 9;
                        _avaDefault.y = 5;
                        _imageCont.addChild(_avaDefault);
                        _ramkAva.visible = true;
                    } else {
                        Cc.error('MarketItem:: no default_avatar_big');
                    }
                    if (_personBuyer && _personBuyer.photo) g.load.loadImage(_personBuyer.photo, onLoadPhoto);
                    else Cc.error('MarkertItem:: No _personBuyer || _personBuyer.buyerSocialId');
                } else {
                    var t:Texture = g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big');
                    if (t) {
                        _avaDefault = new Image(t);
                        if (_avaDefault) {
                            MCScaler.scale(_avaDefault, 85, 85);
                            _avaDefault.pivotX = _avaDefault.width / 2;
                            _avaDefault.pivotY = _avaDefault.height / 2;
                            _avaDefault.x = _bg.width / 2 - 9;
                            _avaDefault.y = 5;
                            _imageCont.addChild(_avaDefault);
                            _ramkAva.visible = true;
                        } else {
                            Cc.error('MarketItem:: no default_avatar_big');
                        }
                    } else {
                        Cc.error('MarketItem:: no default_avatar_big texture');
                    }
                    if (_personBuyer && _personBuyer.userSocialId) {
                        g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                        g.socialNetwork.getTempUsersInfoById([_personBuyer.userSocialId]);
                    }
                    else Cc.error('MarkertItem:: No _personBuyer || _personBuyer.buyerSocialId');
                }
            }
        }

        _btnGoAwaySaleItem = new CButton();
        _btnGoAwaySaleItem.addButtonTexture(80, CButton.HEIGHT_32, CButton.GREEN, true);
        _btnGoAwaySaleItem.addTextField(80, 30, 0, 0, String(g.managerLanguage.allTexts[386]));
        _btnGoAwaySaleItem.setTextFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.GREEN_COLOR);
        source.addChild(_btnGoAwaySaleItem);

        Cc.info('showScaleImage 19');
        _btnGoAwaySaleItem.x = 82;
        _btnGoAwaySaleItem.y = -15;
        source.addChild(_btnGoAwaySaleItem);
        _btnGoAwaySaleItem.visible = false;
        var f1:Function = function ():void {
            if (_personBuyer) {
                if (g.visitedUser && g.visitedUser == _personBuyer) return;
                g.townArea.goAway(_personBuyer);
            }
            else {
                var person:Someone;
                person = g.user.getSomeoneBySocialId(_personBuyerTempItem.buyerSocialId);
                person.level = 15;
                if (g.visitedUser && g.visitedUser == person) return;
                g.townArea.goAway(person);
            }
            g.windowsManager.hideWindow(WindowsManager.WO_MARKET);
        };
        _btnGoAwaySaleItem.clickCallback = f1;
    }

    private function onHover():void {
        if (_onHover) return;
        _onHover = true;

        if (isFill == 0 &&_isUser) {
            _bg.filter = ManagerFilters.BUILD_STROKE;
        } else if (isFill == 1 && !_isUser) {
            count = 1;
            g.gameDispatcher.addToTimer(onEnterFrame);
        }
        if (isFill == 1 && _isUser)_delete.visible = true;
        if (_isUser && isFill == 2) {
           if (_btnGoAwaySaleItem) _btnGoAwaySaleItem.visible = true;
        }
    }

    private function onOut():void {
        _onHover = false;
        if (isFill == 0 && _isUser) {
            _bg.filter = null;
        } else if (isFill == 1) {
            _delete.visible = false;
            g.gameDispatcher.removeFromTimer(onEnterFrame);
        }

        if (_isUser && isFill == 2) {
            _btnGoAwaySaleItem.visible = false;
        }
        g.marketHint.hideIt();
    }

    private var count:int;
    private function onEnterFrame():void {
        count--;
        if (count >= 0) {
            g.gameDispatcher.removeFromTimer(onEnterFrame);
            if (!g.resourceHint.isShowed && _onHover)
                if (_dataResource && source) g.marketHint.showIt(_dataResource.id,source.x,source.y-85,source);  ///// ???????
        }
    }

    public function friendAdd(user:Boolean = false):void {
        if(_closeCell) return;
        if (!user)_btnAdditem.visible = false;
        else {
            if (isFill == 1 ||  isFill == 2 ) {
                _btnAdditem.visible = false;
            } else _btnAdditem.visible = true;
        }
        _isUser = user;
    }

    private function onGettingUserInfo(e:SocialNetworkEvent):void {
        if (!_personBuyer) {
            if (_personBuyerTempItem) _photoUrl = g.user.getSomeoneBySocialId(_personBuyerTempItem.buyerSocialId).photo;
            if ( _personBuyerTempItem && _photoUrl) {
                g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                g.load.loadImage(_photoUrl, onLoadPhoto);
            }
        }  else {
            if (!_personBuyer.name) _personBuyer = g.user.getSomeoneBySocialId(_personBuyer.userSocialId);
            if (_personBuyer.photo) {
                g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
                g.load.loadImage(_personBuyer.photo, onLoadPhoto);
            }
        }
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            if (!_personBuyer)  bitmap = g.pBitmaps[_photoUrl].create() as Bitmap;
            else bitmap = g.pBitmaps[_personBuyer.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('FriendItem:: no photo for userId: ' + _personBuyerTempItem.buyerSocialId + 'or ' + _personBuyer.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        if (_avaDefault) {
            if (source && source.contains(_avaDefault)) source.removeChild(_avaDefault);
            _avaDefault.dispose();
            _avaDefault = null;
        }
        if (tex) {
            _ava = new Image(tex);
            MCScaler.scale(_ava, 85, 85);
            if (_bg) _ava.x = _bg.width/2 - _ava.width/2;
            if (_bg) _ava.y = - 25;
            _imageCont.addChild(_ava);
        } else {
            Cc.error('MarketItem photoFromTexture:: no texture(')
        }
    }

    public function getItemProperties():Object {
        var ob:Object = {};
        ob.x = 0;
        ob.y = 0;
        var p:Point = new Point(ob.x, ob.y);
        p = source.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = _woWidth;
        ob.height = _woHeight;
        return ob;
    }

    public function deleteIt():void {
        if (buyCont && _btnBuyCont) {
            buyCont.removeChild(_btnBuyCont);
            _btnBuyCont.deleteIt();
            _btnBuyCont = null;
            buyCont = null;
        }
        source.removeChild(_bg);
        _bg = null;
        _callback = null;
        _dataResource = null;
        _dataItem = null;
        _person = null;
        _personBuyer = null;
        _personBuyerTempItem = null;
        _ava = null;
        if (_delete) {
            source.removeChild(_delete);
            _delete.deleteIt();
            _delete = null;
        }
        if (_btnGoAwaySaleItem) {
            source.removeChild(_btnGoAwaySaleItem);
            _btnGoAwaySaleItem.deleteIt();
            _btnGoAwaySaleItem = null;
        }
        if (_costTxt) {
            _plawkaCoins.removeChild(_costTxt);
            _costTxt.deleteIt();
            _costTxt = null;
        }
        if (_countTxt) {
            source.removeChild(_countTxt);
            _countTxt.deleteIt();
            _countTxt = null;
        }
        if (_txtPlawka) {
            _plawkaCoins.removeChild(_txtPlawka);
            _txtPlawka.deleteIt();
            _txtPlawka = null;
        }
        _wo = null;
        source.dispose();
        source = null;
    }

    public function getBoundsProperties(s:String):Object {
        var obj:Object;
        var p:Point = new Point();
        switch (s) {
            case 'papperIcon':
                obj = {};
//                p.x = _papperBtn.x - _papperBtn.width/2;
//                p.y = _papperBtn.y - _papperBtn.height/2;
//                p = source.localToGlobal(p);
//                obj.x = p.x;
//                obj.y = p.y;
//                obj.width = _papperBtn.width;
//                obj.height = _papperBtn.height;
                break;
        }
        return obj;
    }

    public function get woMarket():WOMarket {
        return _wo;
    }
}
}
