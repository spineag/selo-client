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
    public static const TYPE_EVENT:int = 1;
    public static const TYPE_RATING:int = 2;
    public static const TYPE_LAST:int = 3;



    public static const EVENT_FIND_CHEST_ON_ANOTHER_MAP:int = 4; //Ищи сундуки с разными призами у соседей
    public static const EVENT_SKIP_PLANT_FRIEND:int = 5; // Помогай Ускорять Растения Друзьям
    public static const EVENT_WHEEL_OF_FORTUNE_FOR_TOKEN:int = 6; // Выигрывай призы крутя барабаны за жетон
    public static const EVENT_MORE_XP_ORDER:int = 7; // Больше XP с Лавки Заказов
    public static const EVENT_MORE_COINS_ORDER:int = 8; // Больше Монет с Лавки ЗАказов
    public static const EVENT_MORE_COINS_MARKET:int = 9; // Больше монет с Рынка
    public static const EVENT_MORE_COINS_VAGONETKA:int = 10; // Больше Монет с Вагонетки
    public static const EVENT_COLLECT_RESOURCE_WIN_GIFT:int = 11; //Классическое собирай ресурс обменюй на призы
    public static const EVENT_COLLECT_TOKEN_WIN_GIFT:int = 12; //Классическое собирай жетоны обменюй на призы

    private var g:Vars = Vars.getInstance();
    private var count:int = 0;
    public var allArrParty:Array;
    public var dataPartyNowUse:Object;
    public var dataPartyDontUse:Object;
    public var userParty:Object;
    public var eventOn:Boolean;
    public var arrBestPlayers:Array;
    public var playerPosition:int;

    public function ManagerPartyNew() {
        arrBestPlayers = [];
        allArrParty = [];
        eventOn = false;
    }

    public function findDataParty():void {
        for (var i:int = 0; i < allArrParty.length; i++) {
            if (((allArrParty[i].timeToStart - TimeUtils.currentSeconds < 0 && allArrParty[i].timeToEnd - TimeUtils.currentSeconds > 0) && !allArrParty[i].tester) || (allArrParty[i].tester && g.user.isTester)) {
                dataPartyNowUse = allArrParty[i];
                checkAndCreateIvent();
                return;
            }
        }
        var time:int = 0;
        var objTemp:Object;
        for (i = 0; i < allArrParty.length; i++) {
            if ((allArrParty[i].timeToStart - TimeUtils.currentSeconds > 0 && allArrParty[i].timeToEnd - TimeUtils.currentSeconds > 0) && !allArrParty[i].tester) {
                time = allArrParty[i].timeToStart - TimeUtils.currentSeconds;
                objTemp = allArrParty[i];
                for (var j:int = 0; j < allArrParty.length; i++) {
                    if ((allArrParty[j].timeToStart - TimeUtils.currentSeconds > 0 && allArrParty[j].timeToEnd - TimeUtils.currentSeconds > 0) && !allArrParty[j].tester && time > allArrParty[j].timeToStart - TimeUtils.currentSeconds) {
                        time = allArrParty[j].timeToStart - TimeUtils.currentSeconds;
                        objTemp = allArrParty[j];
                    }
                }
                dataPartyNowUse = objTemp;
                checkAndCreateIvent();
                return;
            }
        }
    }

    public function checkAndCreateIvent():void {
        if (!dataPartyNowUse) return;
        if (((dataPartyNowUse.timeToStart - TimeUtils.currentSeconds < 0 && dataPartyNowUse.timeToEnd - TimeUtils.currentSeconds > 0) && !dataPartyNowUse.tester && dataPartyNowUse.levelToStart <= g.user.level && !eventOn)
                || (dataPartyNowUse.tester && g.user.isTester)) {
            eventOn = true;
            if (dataPartyNowUse.tester && g.user.isTester) g.userTimer.partyToEnd(300);
            else g.userTimer.partyToEnd(dataPartyNowUse.timeToEnd - TimeUtils.currentSeconds);
            var f:Function = function ():void {
                atlasLoad();
            };
            g.server.getUserParty(f);
//            if (EVENT_COLLECT_TOKEN_WIN_GIFT == dataPartyNowUse.typeParty || EVENT_COLLECT_RESOURCE_WIN_GIFT == dataPartyNowUse.typeParty) g.server.getRatingParty(null);
        } else if (((dataPartyNowUse.timeToStart - TimeUtils.currentSeconds > 0 && dataPartyNowUse.timeToEnd - TimeUtils.currentSeconds > 0) && !dataPartyNowUse.tester && dataPartyNowUse.levelToStart <= g.user.level && !eventOn)
                || (dataPartyNowUse.tester && g.user.isTester)) {
            g.userTimer.partyToStart(dataPartyNowUse.timeToStart - TimeUtils.currentSeconds);
        }
    }

    private function dropPartyResourceWhenEnd():void {
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        for (var i:int = 0; i < g.managerParty.userParty.tookGift.length; i++) {
            if (!g.managerParty.userParty.tookGift[i] && g.managerParty.userParty.countResource >= g.managerParty.dataPartyNowUse.countToGift[i] ) {
                var d:DropObject = new DropObject();
                if (g.managerParty.dataPartyNowUse.typeGift[i] == BuildType.DECOR_ANIMATION || g.managerParty.dataPartyNowUse.typeGift[i] == BuildType.DECOR)
                    d.addDropDecor(g.allData.getBuildingById(g.managerParty.dataPartyNowUse.idGift[i]), p, g.managerParty.dataPartyNowUse.countGift[i]);
                else {
                    if (g.managerParty.dataPartyNowUse.idGift[i] == 1 && g.managerParty.dataPartyNowUse.typeGift[i] == 1)
                        d.addDropMoney(DataMoney.SOFT_CURRENCY, g.managerParty.dataPartyNowUse.countGift[i], p);
                    else if (g.managerParty.dataPartyNowUse.idGift[i] == 2 && g.managerParty.dataPartyNowUse.typeGift[i] == 2)
                        d.addDropMoney(DataMoney.HARD_CURRENCY, g.managerParty.dataPartyNowUse.countGift[i], p);
                    else  d.addDropItemNewByResourceId(g.managerParty.dataPartyNowUse.idGift[i], p, g.managerParty.dataPartyNowUse.countGift[i]);
                }
                d.releaseIt(null, false);
            }
        }
    }

    public function endParty():void {
        var d:DropObject = new DropObject();
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        for (var i:int = 0; i < userParty.tookGift.length; i++) {
            if (!userParty.tookGift[i] && userParty.countResource >= countToGift[i] ) {
                if (typeGift[i] == BuildType.DECOR_ANIMATION || typeGift[i] == BuildType.DECOR)
                    d.addDropDecor(g.allData.getBuildingById(idGift[i]), p, countGift[i]);
                else {
                    if (idGift[i] == 1 && typeGift[i] == 1) d.addDropMoney(DataMoney.SOFT_CURRENCY, countGift[i], p);
                    else if (idGift[i] == 2 && typeGift[i] == 2) d.addDropMoney(DataMoney.HARD_CURRENCY, countGift[i], p);
                    else d.addDropItemNewByResourceId(g.managerParty.dataPartyNowUse.idGift[i], p, countGift[i]);
                }
            }
        }
        if (playerPosition <= 5) d.addDropDecor(g.allData.getBuildingById(dataPartyNowUse.idDecorBest), p);
        if (playerPosition == 1) d.addDropDecor(g.allData.getBuildingById(273), p);
        d.releaseIt(null, false);
    }

    public function endPartyWindow():void {
        if (g.managerCutScenes && g.managerCutScenes.isCutScene) return;
        if (!g.allData.atlas['partyAtlas']) atlasLoad();
        else if ((g.userTimer.partyToEndTimer <= 0 && !eventOn) && (dataPartyNowUse.typeParty == 3 || dataPartyNowUse.typeParty == 4)) {
            if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
            if (g.managerParty.userParty.countResource >= dataPartyNowUse.countToGift[0]) {
                g.windowsManager.openWindow(WindowsManager.WO_PARTY, null, TYPE_LAST);
                endParty();
                g.server.updateUserParty('1&1&1&1&1', userParty.countResource, 1, null);
            }
        } else if (userParty && !userParty.showWindow && g.managerParty.userParty.countResource >= dataPartyNowUse.countToGift[0] && (dataPartyNowUse.typeParty == 1 || dataPartyNowUse.typeParty == 2)) {
            if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
            if (g.managerParty.userParty.countResource >= dataPartyNowUse.countToGift[0]) {
                g.windowsManager.openWindow(WindowsManager.WO_PARTY, null, TYPE_LAST);
                endParty();
                g.server.updateUserParty('1&1&1&1&1', userParty.countResource, 1, null);
            }
        }
    }



    public function atlasLoad():void {
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas'), onLoad);
        g.load.loadXML(g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas'), onLoad);
    }

    private function onLoad(smth:*=null):void {
        count++;
        if (count >=2) createAtlases();
    }

    private function createAtlases():void {
        if (g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')] && g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')]) {
            g.allData.atlas['partyAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')]);
            (g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')] as PBitmap).deleteIt();
            if (g.userTimer.partyToEndTimer > 0) {
                g.partyPanel = new PartyPanel();
                if (g.managerInviteFriend) g.managerInviteFriend.updateTimerPanelPosition();
            }
            if (!g.windowsManager.currentWindow && g.userTimer.partyToEndTimer > 0) {
                if (!g.managerCutScenes.isCutScene) g.windowsManager.openWindow(WindowsManager.WO_PARTY, null);
            } else if ((g.userTimer.partyToEndTimer <= 0 && !eventOn) && (dataPartyNowUse.typeParty == 3 || dataPartyNowUse.typeParty == 4)) {
                if (g.managerCutScenes && g.managerCutScenes.isCutScene) return;
                if (g.windowsManager.currentWindow) g.windowsManager.closeAllWindows();
                if (g.managerParty.userParty.countResource >= dataPartyNowUse.countToGift[0]) {
                    g.windowsManager.openWindow(WindowsManager.WO_PARTY, null, TYPE_LAST);
                    endParty();
                    g.server.updateUserParty('1&1&1&1&1', userParty.countResource, 1, null);
                }
            }

            delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas')];
            delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas')];
            g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'partyAtlas.png' + g.getVersion('partyAtlas'));
            g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'partyAtlas.xml' + g.getVersion('partyAtlas'));
        }
    }

    public function get  timeToStart():int {return dataPartyNowUse.timeToStart;}
    public function get  timeToEnd():int {return dataPartyNowUse.timeToEnd;}
    public function get  levelToStart():int {return dataPartyNowUse.levelToStart;}
    public function get  idResource():int {return dataPartyNowUse.idResource;}
    public function get  typeBuilding():int {return dataPartyNowUse.typeBuilding;}
    public function get  coefficient():int {return dataPartyNowUse.coefficient;}
    public function get  typeParty():int {return dataPartyNowUse.typeParty;}
    public function get  name():String {return dataPartyNowUse.name;}
    public function get  description():String {return dataPartyNowUse.description;}
    public function get  idGift():Array {return dataPartyNowUse.idGift;}
    public function get  countGift():Array {return dataPartyNowUse.countGift;}
    public function get  countToGift():Array {return dataPartyNowUse.countToGift;}
    public function get  typeGift():Array {return dataPartyNowUse.typeGift;}
    public function get  idDecorBest():int {return dataPartyNowUse.idDecorBest;}
    public function get  filterOn():int {return dataPartyNowUse.filterOn;}
}
}
