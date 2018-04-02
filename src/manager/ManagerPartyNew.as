/**
 * Created by user on 2/2/17.
 */
package manager {
import data.BuildType;
import data.DataMoney;
import flash.display.Bitmap;
import flash.geom.Point;
import loaders.PBitmap;
import resourceItem.newDrop.DropObject;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import ui.party.PartyPanel;

import utils.TimeUtils;

import windows.WindowsManager;

public class ManagerPartyNew {
    public static const EVENT_FIND_CHEST_ON_ANOTHER_MAP:int = 1; //Ищи сундуки с разными призами у соседей
    public static const EVENT_SKIP_PLANT_FRIEND:int = 2; // Помогай Ускорять Растения Друзьям
    public static const EVENT_WHEEL_OF_FORTUNE_FOR_TOKEN:int = 3; // Выигрывай призы крутя барабаны за жетон
    public static const EVENT_MORE_XP_ORDER:int = 4; // Больше XP с Лавки Заказов
    public static const EVENT_MORE_COINS_ORDER:int = 5; // Больше Монет с Лавки ЗАказов
    public static const EVENT_MORE_COINS_MARKET:int = 6; // Больше монет с Рынка
    public static const EVENT_MORE_COINS_VAGONETKA:int = 7; // Больше Монет с Вагонетки
    public static const EVENT_COLLECT_RESOURCE_WIN_GIFT:int = 8; //Классическое собирай ресурс обменюй на призы
    public static const EVENT_COLLECT_TOKEN_WIN_GIFT:int = 9; //Классическое собирай жетоны обменюй на призы
    public static const EVENT_THREE_GIFT_MORE_PLANT:int = 10; //3 растения дает больше растения

    private var g:Vars = Vars.getInstance();
    private var count:int = 0;
    public var allArrParty:Array;
    public var dataPartyNowUse:Object;
    public var dataPartyDontUse:Object;
    public var userParty:Array;
    public var eventOn:Boolean;
    public var arrBestPlayers:Array;
    public var playerPosition:int;
    private var _arrImage:Array;
    private var _loadImage:String;
    private var _showEndWindow:Boolean;
    private var _needShowEndThisEvent:Object;
    private var _loadAll:Boolean;
    private var _ratingForEnd:int;

    public function ManagerPartyNew() {
        arrBestPlayers = [];
        allArrParty = [];
        userParty = [];
        _arrImage = [];
        _needShowEndThisEvent = {};
        eventOn = false;
        _showEndWindow = false;
        _loadAll = false;
        _ratingForEnd = 0;
    }

    public function findDataParty(showWindowEnd:Boolean = false):void {
        dataPartyNowUse = {};
        var needCreateDataPartyNow:Boolean = false;
        for (var i:int = 0; i < allArrParty.length; i++) {
            if (((allArrParty[i].timeToStart - TimeUtils.currentSeconds < 0 && allArrParty[i].timeToEnd - TimeUtils.currentSeconds > 0) && !allArrParty[i].tester) || (allArrParty[i].tester && g.user.isTester)) {
                dataPartyNowUse = allArrParty[i];
                checkAndCreateIvent(showWindowEnd);
                needCreateDataPartyNow = true;
                break;
            }
        }
        if (needCreateDataPartyNow) return;
        var time:int = 0;
        var objTemp:Object;
        for (i = 0; i < allArrParty.length; i++) {
            if ((allArrParty[i].timeToStart - TimeUtils.currentSeconds > 0 && allArrParty[i].timeToEnd - TimeUtils.currentSeconds > 0) && !allArrParty[i].tester) {
                time = allArrParty[i].timeToStart - TimeUtils.currentSeconds;
                objTemp = allArrParty[i];
                for (var j:int = 0; j < allArrParty.length; j++) {
                    if ((allArrParty[j].timeToStart - TimeUtils.currentSeconds > 0 && allArrParty[j].timeToEnd - TimeUtils.currentSeconds > 0) && !allArrParty[j].tester && time > allArrParty[j].timeToStart - TimeUtils.currentSeconds) {
                        time = allArrParty[j].timeToStart - TimeUtils.currentSeconds;
                        objTemp = allArrParty[j];
                    }
                }
                dataPartyNowUse = objTemp;
                checkAndCreateIvent(showWindowEnd);
                needCreateDataPartyNow = true;
                break;
            }
        }
        if (!needCreateDataPartyNow) {
            checkNeedShowEndWindow(showWindowEnd);
            _loadAll = true;
        }
    }

    private function checkNeedShowEndWindow(showWindowEnd:Boolean = false):void {
        if (userParty && userParty.length > 0 && userParty[0].idParty != -1) {
            var i:int = 0;
            if (allArrParty) {
                for (i = 0; i < userParty.length; i++) {
                    if (!userParty[i].showWindow && (!dataPartyNowUse || (dataPartyNowUse && dataPartyNowUse.id != userParty[i].idParty))) {
                        for (var j:int = 0; j < allArrParty.length; j++) {
                            if (userParty[i].idParty == allArrParty[j].id) {
                                if (TimeUtils.currentSeconds - allArrParty[j].timeToEnd < 604800) {
                                    _showEndWindow = true;
                                    _needShowEndThisEvent = allArrParty[j];
                                }
                                break;
                            }
                        }
                    }
                    if (_showEndWindow) break;
                }
            }
        }
        if (_showEndWindow && showWindowEnd && !g.managerCutScenes.isCutScene && !g.tuts.isTuts) g.windowsManager.openWindow(WindowsManager.WO_PARTY_CLOSE, null);
        if (!_showEndWindow && !showWindowEnd) deleteAllOldUserParty();
    }

    private function deleteAllOldUserParty():void {
        var i:int;
        if (allArrParty && allArrParty.length > 0) {
            if (userParty && userParty.length > 0) {
                for (i = 0; i < userParty.length; i++) {
                    if (userParty[i] && userParty[i].idParty != -1) {
                        for (var j:int = 0; j < allArrParty.length; j++) {
                            if (allArrParty[j].id == userParty[i].idParty &&  TimeUtils.currentSeconds - allArrParty[j].timeToEnd >= 604800) {
                                g.server.deleteUserParty(userParty[i].idParty,null);
                                userParty.splice(i,1);
                                i--;
                                break;
                            }
                        }
                    }
                }
            }
        } else if (userParty && userParty.length > 0) {
            for (i = 0; i < userParty.length; i++) {
                if (userParty[i] && userParty[i].idParty != -1) {
                    g.server.deleteUserParty(userParty[i].idParty,null);
                    userParty.splice(i,1);
                    i--;
                }
            }
        }
    }

    public function get showEndWindow():Boolean { return _showEndWindow; }
    public function get loadAll():Boolean { return _loadAll; }
    public function get obEndEvent():Object { return _needShowEndThisEvent; }
    public function set setratingForEnd(ratingForEnd:int):void { _ratingForEnd = ratingForEnd; }
    public function get getratingForEnd():int { return _ratingForEnd; }

    public function checkAndCreateIvent(showWindowEnd:Boolean = false):void {
        checkNeedShowEndWindow(showWindowEnd);
        if (!dataPartyNowUse) return;
        if (((dataPartyNowUse.timeToStart - TimeUtils.currentSeconds < 0 && dataPartyNowUse.timeToEnd - TimeUtils.currentSeconds > 0) && !dataPartyNowUse.tester && dataPartyNowUse.levelToStart <= g.user.level && !eventOn)
                || (dataPartyNowUse.tester && g.user.isTester)) {
            eventOn = true;
            if (dataPartyNowUse.tester && g.user.isTester) g.userTimer.partyToEnd(300);
            else g.userTimer.partyToEnd(dataPartyNowUse.timeToEnd - TimeUtils.currentSeconds);
            atlasLoad();
            var f:Function = function ():void {
                g.server.getRatingParty(dataPartyNowUse.id);
            };
            if (userParty && userParty.length > 0 && userParty[0].idParty == -1) {
                updateUserParty(false, f);
                userParty[0].idParty = int(dataPartyNowUse.id);
            } else createUserParty(f);
        } else if (((dataPartyNowUse.timeToStart - TimeUtils.currentSeconds > 0 && dataPartyNowUse.timeToEnd - TimeUtils.currentSeconds > 0) && !dataPartyNowUse.tester && dataPartyNowUse.levelToStart <= g.user.level && !eventOn)
                || (dataPartyNowUse.tester && g.user.isTester)) {
            _loadAll = true;
            g.userTimer.partyToStart(dataPartyNowUse.timeToStart - TimeUtils.currentSeconds);
        }
    }

    public function updateUserParty(showEnd:Boolean = false, callBack:Function = null):void {
        var st:String = userParty[0].tookGift[0] + '&' + userParty[0].tookGift[1] + '&' + userParty[0].tookGift[2] + '&'
                + userParty[0].tookGift[3] + '&' + userParty[0].tookGift[4];
        g.server.updateUserParty(st, userParty[0].countResource, int(showEnd), g.managerParty.id, userParty[0].idParty, callBack);
    }

    public function addUserPartyCount(count:int):void {
        userParty[0].countResource += count;
        updateUserParty();
    }

    private function createUserParty(callback:Function):void {
        var obj:Object = {};
        var arr:Array = new Array(5);
        if (userParty && userParty.length > 0) {
            for (var i:int = 0; i <  userParty.length; i ++) {
                if (userParty[i].idParty == dataPartyNowUse.id) {
                    if (callback != null) {
                        callback.apply();
                    }
                    return;
                }
            }
            obj.countResource = int(0);
            obj.idParty = int(dataPartyNowUse.id);
            obj.showWindow = Boolean(false);
            obj.tookGift = arr;
            userParty.push(obj);
            g.server.addUserParty(dataPartyNowUse.id,0,callback);
        } else {
            obj.countResource = int(0);
            obj.idParty = int(dataPartyNowUse.id);
            obj.showWindow = Boolean(false);
            obj.tookGift = arr;
            userParty.push(obj);
            g.server.addUserParty(dataPartyNowUse.id,0,callback);
        }
        g.managerParty.userParty.sortOn("idParty", Array.DESCENDING | Array.NUMERIC);
    }

    public function addEndForShowWindow():void {
        _showEndWindow = false;
        for (var i:int = 0; i < userParty.length; i ++) {
            if (userParty[i].idParty == _needShowEndThisEvent.id) {
                g.server.updateUserParty('0&0&0&0&0',userParty[i].countResource, int(true),userParty[i].idParty,userParty[i].idParty,null);
                userParty[i].showWindow = true;
                break;
            }
        }
        _needShowEndThisEvent = null;

    }

    private function onLoadImage(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + _loadImage].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    public function get arrImage():Array{
        return _arrImage;
    }

    private function photoFromTexture(tex:Texture):void {
        _arrImage.push(tex);
        if (_loadImage == 'event/' + dataPartyNowUse.imRating + '.png') {
            g.partyPanel = new PartyPanel();
            if (g.managerInviteFriend) g.managerInviteFriend.updateTimerPanelPosition();
            _loadAll = true;
        }
        if (_loadImage == 'event/' + dataPartyNowUse.imMain + '.png') {
            _loadImage = 'event/' + dataPartyNowUse.imRating + '.png';
            g.load.loadImage(g.dataPath.getGraphicsPath() + _loadImage, onLoadImage);
        }
    }

    public function atlasLoad():void {
        if (!g.allData.atlas['partyAtlas']) {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas'), onLoad);
            g.load.loadXML(g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas'), onLoad);
        } else createAtlases();
    }

    private function onLoad(smth:*=null):void {
        count++;
        if (count >=2) createAtlases();
    }

    private function createAtlases():void {
        if (!g.allData.atlas['partyAtlas']) {
            if (g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')] && g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')]) {
                g.allData.atlas['partyAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')]);
                (g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')] as PBitmap).deleteIt();

                delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')];
                delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')];
                g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas'));
                g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas'));
            }
        }
        _arrImage = [];
        if (typeParty == EVENT_MORE_XP_ORDER || typeParty == EVENT_MORE_COINS_ORDER
                || typeParty == EVENT_MORE_COINS_MARKET || typeParty == EVENT_MORE_COINS_VAGONETKA
                || typeParty == EVENT_SKIP_PLANT_FRIEND) {
            _loadImage = 'event/' + dataPartyNowUse.imMain + '.png';
            g.load.loadImage(g.dataPath.getGraphicsPath() + _loadImage, onLoadImage);
        } else {
            _loadImage = 'event/' + dataPartyNowUse.imRating + '.png';
            g.load.loadImage(g.dataPath.getGraphicsPath() + _loadImage, onLoadImage);
        }
    }

    public function get  timeToStart():int {return dataPartyNowUse.timeToStart;}
    public function get  timeToEnd():int {return dataPartyNowUse.timeToEnd;}
    public function get  levelToStart():int {return dataPartyNowUse.levelToStart;}
    public function get  idItemEvent():Array {return dataPartyNowUse.idItemEvent;}
    public function get  coefficient():int {return dataPartyNowUse.coefficient;}
    public function get  typeParty():int {return dataPartyNowUse.typeParty;}
    public function get  idGift():Array {return dataPartyNowUse.idGift;}
    public function get  countGift():Array {return dataPartyNowUse.countGift;}
    public function get  countToGift():Array {return dataPartyNowUse.countToGift;}
    public function get  typeGift():Array {return dataPartyNowUse.typeGift;}
    public function get  idDecorBest():int {return dataPartyNowUse.idDecorBest;}
    public function get  typeDecorBest():int {return dataPartyNowUse.typeDecorBest;}
    public function get  countDecorBest():int {return dataPartyNowUse.countDecorBest;}
    public function get  filterOn():int {return dataPartyNowUse.filterOn;}
    public function get  id():int {return dataPartyNowUse.id;}
    public function get  imIcon():String {return dataPartyNowUse.imIcon;}

    public function get  nameMain():int {return dataPartyNowUse.nameMain;}
    public function get  prevMain():int {return dataPartyNowUse.prevMain;}
    public function get  descriptionMain():int {return dataPartyNowUse.descriptionMain;}
    public function get  textIdItem():int {return dataPartyNowUse.textIdItem;}
    public function get  nameRating():int {return dataPartyNowUse.nameRating;}
    public function get  prevRating():int {return dataPartyNowUse.prevRating;}
    public function get  descriptionRating():int {return dataPartyNowUse.descriptionRating;}
    public function get  giftRating():int {return dataPartyNowUse.giftRating;}
}
}
