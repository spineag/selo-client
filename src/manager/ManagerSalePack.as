/**
 * Created by user on 2/15/17.
 */
package manager {
import flash.display.Bitmap;

import loaders.PBitmap;

import starling.textures.Texture;

import starling.textures.TextureAtlas;

import utils.TimeUtils;
import utils.Utils;

import windows.WindowsManager;

public class ManagerSalePack {
    public static const WO_RUBIES:int = 1;
    public static const WO_INSTRUMENTS:int = 2;
    public static const WO_VAUCHERS:int = 3;

    public var dataSale:Array;
    public var arrUserSale:Array;
    public var userSale:Object;
    private var count:int = 0;
    private var _countSeconds:int = 0;
    private var _bolCanSalePack:Boolean;
    private var _howMustShow:Array;
    public var obRubies:Object;

    private var g:Vars = Vars.getInstance();

    public function ManagerSalePack() {
        dataSale = [];
        arrUserSale = [];
        userSale = {};
        obRubies = {};
        obRubies.buy1 = false;
        obRubies.buy2 = false;
        obRubies.buy3 = false;
        obRubies.buy4 = false;
        obRubies.buy5 = false;
        obRubies.buy6 = false;
        obRubies.buy7 = false;
        obRubies.buy8 = false;
        obRubies.buy9 = false;
        obRubies.buy10 = false;

        obRubies.showIts1 = false;
        obRubies.showIts2 = false;
        obRubies.showIts3 = false;
        obRubies.showIts4 = false;
        obRubies.showIts5 = false;
        obRubies.showIts6 = false;
        obRubies.showIts7 = false;
        obRubies.showIts8 = false;
        obRubies.showIts9 = false;
        obRubies.showIts10 = false;

        _bolCanSalePack = false;
        g.server.getDataSalePack(onGetDataSalePack);
    }

    private function onGetDataSalePack():void {g.server.getUserSalePack(startSalePack);}

    private function startSalePack():void {
        if (arrUserSale && arrUserSale.length > 0) {
            for (var i:int = 0; i < arrUserSale.length; i++) {
                for (var k:int = 0; k < dataSale.length; k++) {
                    if (arrUserSale[i].saleId == dataSale[k].id && (TimeUtils.currentSeconds - int(arrUserSale[i].timeStart)) < dataSale[k].timeEvent && !arrUserSale[i].buy) {
                        atlasLoad();
                        thisUser(dataSale[k].id, false);
//                        userSale = arrUserSale[i];
                        g.userTimer.saleToEnd(dataSale[k].timeEvent - (TimeUtils.currentSeconds - int(arrUserSale[i].timeStart)));
                        g.createSaleUi();
                        g.user.salePack = true;
                        return;
                    }
                }
            }
        }
        checkNeedShowSalePack();
    }

    public function checkNeedShowSalePack():void {
        if (g.userTimer.starterTimerToEnd > 0 || g.user.salePack || g.user.timeStarterPack == 0|| int((TimeUtils.currentSeconds - g.user.timeStarterPack)) < 259200) return;
        if (arrUserSale.length <= 0) {
            thisUser(1);
        } else if (arrUserSale.length > 0) {
            if (int(TimeUtils.currentSeconds - int(arrUserSale[arrUserSale.length-1].timeStart)) < 172800) return;
            if (obRubies.buy1) {
                balanceStructure();
            } else {
                if (!obRubies.buy5 && !obRubies.showIts5) thisUser(5);
                else if (!obRubies.buy5 && obRubies.showIts5) return;
                else if (obRubies.buy5 && obRubies.showIts5) balanceStructure();
            }
        }
    }

    private function balanceStructure():void {
        if (!obRubies.buy2 && !obRubies.showIts2) thisUser(2);
        else if (!obRubies.buy2 && obRubies.showIts2) {
            //6 pack
            if (!obRubies.buy6 && !obRubies.showIts6) thisUser(6);
            else if (!obRubies.buy6 && obRubies.showIts6) {
                if (obRubies.buy5 && obRubies.showIts5) thisUser(3);
                else if (!obRubies.buy5 && !obRubies.showIts5) thisUser(5);
            } else if (obRubies.buy6 && obRubies.showIts6) {
                if (!obRubies.buy7 && obRubies.showIts7) thisUser(4);
                else if (!obRubies.buy7 && !obRubies.showIts7) thisUser(3);
            }
            //6end
        } else if (obRubies.buy2 && obRubies.showIts2) {
            if (!obRubies.buy3 && !obRubies.showIts3) thisUser(3);
            else if (!obRubies.buy3 && obRubies.showIts3) {
                //7 pack
                if (!obRubies.buy7 && !obRubies.showIts7) thisUser(7);
                else if (obRubies.buy7 && obRubies.showIts7) thisUser(4);
                else if (!obRubies.buy7 && obRubies.showIts7) thisUser(6);
                //7end
            } else if (obRubies.buy3 && obRubies.showIts3) {
                if (!obRubies.buy4 && !obRubies.showIts4) thisUser(4);
                else if (!obRubies.buy4 && obRubies.showIts4) {
                    //8 pack
                    if (!obRubies.buy8 && !obRubies.showIts8) thisUser(8);
                    else if (!obRubies.buy8 && obRubies.showIts8 && !obRubies.buy9 && !obRubies.showIts9) thisUser(9);
                    else if (!obRubies.buy8 && obRubies.showIts8 && !obRubies.buy9 && obRubies.showIts9 && !obRubies.buy10 && !obRubies.showIts10) thisUser(10);
                    //8end
                } else if (obRubies.buy4 && obRubies.showIts4) {
                    //супер Приз
                }
            }
        }
    }

//    private function checkNeedInstrumentRubies():void {
//        var k:Number = Math.random();
//        if (0.2 > Math.random()) {
//            if (k < 0.1) thisUser(16);
//            else if (k < 0.2) thisUser(15);
//            else if (k < 0.4) thisUser(14);
//            else if (k < 0.6) thisUser(13);
//            else if (k < 0.8) thisUser(12);
//            else thisUser(11);
//        } else {
//            if (k < 0.1) thisUser(17);
//            else if (k < 0.2) thisUser(18);
//            else if (k < 0.4) thisUser(19);
//            else if (k < 0.6) thisUser(20);
//            else if (k < 0.8) thisUser(21);
//            else thisUser(22);
//        }
//    }

    private function checkNeedVauchers():void {
        var k:Number = Math.random();
        if (0.2 > Math.random()) {
            if (k < 0.1) thisUser(16);
            else if (k < 0.2) thisUser(15);
            else if (k < 0.4) thisUser(14);
            else if (k < 0.6) thisUser(13);
            else if (k < 0.8) thisUser(12);
            else thisUser(11);
        } else {
            if (k < 0.1) thisUser(17);
            else if (k < 0.2) thisUser(18);
            else if (k < 0.4) thisUser(19);
            else if (k < 0.6) thisUser(20);
            else if (k < 0.8) thisUser(21);
            else thisUser(22);
        }
    }

    public function thisUser(id:int, needStart:Boolean = true):void {
        _bolCanSalePack = true;
        userSale.id = 0;
        userSale.saleId = id;
        userSale.buy = false;
        for (var i:int = 0; i < dataSale.length; i++) {
            if (userSale.saleId == dataSale[i].id) {
                userSale.objectId = dataSale[i].objectId;
                userSale.objectType = dataSale[i].objectType;
                userSale.objectCount = dataSale[i].objectCount;
                userSale.oldCost = dataSale[i].oldCost;
                userSale.newCost = dataSale[i].newCost;
                userSale.typeSale = dataSale[i].typeSale;
                userSale.isTester = dataSale[i].isTester;
                userSale.timeEvent = dataSale[i].timeEvent;
                userSale.profit = dataSale[i].profit;
                userSale.name = dataSale[i].name;
                userSale.description = dataSale.description;
                break;
            }
        }
        if (needStart) startIt();
    }

    private function onLoad(smth:*=null):void {
        count++;
        if (count >=2) createAtlases();
    }

    public function checkForSalePackInstrument(idResource:int):void {
        var b:Boolean = false;
        if (arrUserSale.length > 0) {
            for (var i:int = 0; i < arrUserSale.length; i++) {
                if ((arrUserSale[i].saleId == 29 || arrUserSale[i].saleId == 30) && ( int((TimeUtils.currentSeconds - int(arrUserSale[i].timeStart))) < 172800 )) {
                    b = true;
                    break;
                }
            }
        }
        if (!b && !userSale.id) {
            if (idResource == 125 || idResource == 47) thisUser(29,true);
            else if (idResource == 5 || idResource == 1) thisUser(30,true);
            else if (idResource == 124 && Math.random() <= 0.5) thisUser(29,true);
            else thisUser(30,true);
        }
    }

    public function checkForSalePackVaucher():void {
        var b:Boolean = false;
        var count33:int = 0;
        var count31:int = 0;
        var count32:int = 0;
        if (arrUserSale.length > 0) {
            for (var i:int = 0; i < arrUserSale.length; i++) {
                if ((arrUserSale[i].saleId == 33 || arrUserSale[i].saleId == 31 || arrUserSale[i].saleId == 32) && ( int((TimeUtils.currentSeconds - int(arrUserSale[i].timeStart))) < 172800 )) {
                    b = true;
                    break;
                }
                if (arrUserSale[i].saleId == 33) count33 ++;
                else if (arrUserSale[i].saleId == 31) count31 ++;
                else if (arrUserSale[i].saleId == 32) count32 ++;
            }
        }
        if (!b && !userSale.id) {
           if (count33 > count31 && count31 <= count32) thisUser(31,true);
            else if (count33 > count32 && count32 <= count31)  thisUser(32,true);
            else thisUser(33,true);
        }
    }

    public function atlasLoad():void {
        if (!g.allData.atlas['saleAtlas']) {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'saleAtlas.png' + g.getVersion('saleAtlas'), onLoad);
            g.load.loadXML(g.dataPath.getGraphicsPath() + 'saleAtlas.xml' + g.getVersion('saleAtlas'), onLoad);
        }
    }

    private function createAtlases():void {
        g.allData.atlas['saleAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'saleAtlas.png' + g.getVersion('saleAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'saleAtlas.xml' + g.getVersion('saleAtlas')]);
        (g.pBitmaps[g.dataPath.getGraphicsPath() + 'saleAtlas.png' + g.getVersion('saleAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'saleAtlas.png' + g.getVersion('saleAtlas')];
        delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'saleAtlas.xml' + g.getVersion('saleAtlas')];
        g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'saleAtlas.png' + g.getVersion('saleAtlas'));
        g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'saleAtlas.xml' + g.getVersion('saleAtlas'));
    }

    public function onUserAction():void {
        if (g.user.salePack) return;
        if (_bolCanSalePack) {
            _countSeconds = 0;
        }
    }

    private function startIt():void {
    if (_bolCanSalePack) {
        _countSeconds = 0;
        g.gameDispatcher.addToTimer(onTimer);
    }
}

    private function onTimer():void {
        _countSeconds++;
        if (!_bolCanSalePack || g.user.salePack) {
            g.gameDispatcher.removeFromTimer(onTimer);
        }
        if (_countSeconds >= 15) {
            _countSeconds = 0;
            g.gameDispatcher.removeFromTimer(onTimer);
            g.userTimer.saleToEnd(userSale.timeEvent);
            atlasLoad();
            g.createSaleUi();
            var f1:Function = function():void {
                if (userSale.typeSale == 1) g.windowsManager.openWindow(WindowsManager.WO_SALE_PACK_RUBIES, null, false);
                else if (userSale.typeSale == 2) g.windowsManager.openWindow(WindowsManager.WO_SALE_PACK_INSTRUMENTS, null, false);
                else if (userSale.typeSale == 3) g.windowsManager.openWindow(WindowsManager.WO_SALE_PACK_VAUCHERS, null, false);
                else if (userSale.typeSale == 4) g.windowsManager.openWindow(WindowsManager.WO_THREE_ONE, null, false);
                g.server.addUserSalePack(userSale.saleId,null);
            };
            Utils.createDelay(5,f1);
        }
    }
}
}
