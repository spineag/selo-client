/**
 * Created by user on 2/15/17.
 */
package manager {
import flash.display.Bitmap;

import loaders.PBitmap;

import starling.textures.Texture;

import starling.textures.TextureAtlas;

import utils.TimeUtils;

import windows.WindowsManager;

public class ManagerSalePack {
    public static const WO_RUBIES:int = 1;
    public static const WO_INSTRUMENTS:int = 2;
    public static const WO_VAUCHERS:int = 3;

    public var dataSale:Array;
    public var arrUserSale:Array;
//    public var userSale
    private var g:Vars = Vars.getInstance();
    private var count:int = 0;
    private var _countSeconds:int = 0;
    private var _bolCanSalePack:Boolean;

    public function ManagerSalePack() {
        dataSale = [];
        arrUserSale = [];
        _bolCanSalePack = false;
        g.server.getDataSalePack(null);
        g.server.getUserSalePack(startSalePack);
    }

    private function startSalePack():void {
        if (arrUserSale && arrUserSale.length > 0) {
            for (var i:int = 0; i < arrUserSale.length; i++) {
                for (var k:int = 0; k < dataSale.length; k++) {
                    if (arrUserSale[i].saleId == dataSale[k].id && (TimeUtils.currentSeconds - int(arrUserSale[i].timeStart)) < dataSale[k].timeEvent && !arrUserSale[i].buy) {
                        atlasLoad();
                        g.createSaleUi();
                        g.user.salePack = true;
                    }
                }
            }
        }
        checkNeedShowSalePack();
    }

    public function checkNeedShowSalePack():void {
        if (g.user.level < 7 || g.userTimer.starterTimerToEnd > 0 || g.user.starterPack == 0 || g.user.salePack || int((TimeUtils.currentSeconds - g.user.timeStarterPack)) < 691200) return;
        if (arrUserSale.length < 0) {
            _bolCanSalePack = true;
            startIt();
        }
    }


    public function sartAfterSaleTimer():void {
        if (g.userTimer.saleTimerToStart <= 0 && g.user.level >= 6) {
            atlasLoad();
            g.userTimer.saleToEnd(g.managerSalePack.dataSale.timeToEnd - TimeUtils.currentSeconds);
            g.createSaleUi();
        }
    }

    private function onLoad(smth:*=null):void {
        count++;
        if (count >=2) createAtlases();
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
        if (_countSeconds >= 10) {
            atlasLoad();
            g.createSaleUi();
        }
    }
}
}
