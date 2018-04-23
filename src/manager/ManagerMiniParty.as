/**
 * Created by user on 4/4/18.
 */
package manager {
import flash.display.Bitmap;
import loaders.PBitmap;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

import ui.miniParty.MiniPartyPanel;

import utils.TimeUtils;

public class ManagerMiniParty {

    public static const MINI_EVENT_FORTUNE:int = 1;

    private var g:Vars = Vars.getInstance();
    public var arrAllMiniParty:Array;
    private var _dataMiniParty:Object;
    public var miniEventOn:Boolean;
    private var count:int;

    public function ManagerMiniParty() {
        arrAllMiniParty = [];
        miniEventOn = false;
        count = 0;
    }

    public function findDataParty():void {
        _dataMiniParty = {};
        for (var i:int = 0; i < arrAllMiniParty.length; i++) {
            if (((arrAllMiniParty[i].timeToStart - TimeUtils.currentSeconds < 0 && arrAllMiniParty[i].timeToEnd - TimeUtils.currentSeconds > 0) && !arrAllMiniParty[i].tester) || (arrAllMiniParty[i].tester && g.user.isTester)) {
                _dataMiniParty = arrAllMiniParty[i];
                checkAndCreateIvent();
                return;
            }
        }
        var time:int = 0;
        var objTemp:Object;
        for (i = 0; i < arrAllMiniParty.length; i++) {
            if ((arrAllMiniParty[i].timeToStart - TimeUtils.currentSeconds > 0 && arrAllMiniParty[i].timeToEnd - TimeUtils.currentSeconds > 0) && !arrAllMiniParty[i].tester) {
                time = arrAllMiniParty[i].timeToStart - TimeUtils.currentSeconds;
                objTemp = arrAllMiniParty[i];
                for (var j:int = 0; j < arrAllMiniParty.length; j++) {
                    if ((arrAllMiniParty[j].timeToStart - TimeUtils.currentSeconds > 0 && arrAllMiniParty[j].timeToEnd - TimeUtils.currentSeconds > 0) && !arrAllMiniParty[j].tester && time > arrAllMiniParty[j].timeToStart - TimeUtils.currentSeconds) {
                        time = arrAllMiniParty[j].timeToStart - TimeUtils.currentSeconds;
                        objTemp = arrAllMiniParty[j];
                    }
                }
                _dataMiniParty = objTemp;
                checkAndCreateIvent();
                return;
            }
        }
    }

    public function checkAndCreateIvent():void {
        if (((_dataMiniParty.timeToStart - TimeUtils.currentSeconds < 0 && _dataMiniParty.timeToEnd - TimeUtils.currentSeconds > 0) && !_dataMiniParty.tester && _dataMiniParty.levelToStart <= g.user.level && !miniEventOn)
                || (_dataMiniParty.tester && g.user.isTester)) {
            miniEventOn = true;
            if (_dataMiniParty.tester && g.user.isTester) g.userTimer.miniPartyToEnd(300);
            else g.userTimer.miniPartyToEnd(_dataMiniParty.timeToEnd - TimeUtils.currentSeconds);
            atlasLoad();
        } else if (((_dataMiniParty.timeToStart - TimeUtils.currentSeconds > 0 && _dataMiniParty.timeToEnd - TimeUtils.currentSeconds > 0) && !_dataMiniParty.tester && _dataMiniParty.levelToStart <= g.user.level && !miniEventOn)
                || (_dataMiniParty.tester && g.user.isTester)) {
            g.userTimer.miniPartyToStart(_dataMiniParty.timeToStart - TimeUtils.currentSeconds);
        }
    }

    public function atlasLoad():void {
        if (!g.allData.atlas['miniPartyAtlas']) {
            g.load.loadImage(g.dataPath.getGraphicsPath() + 'miniPartyAtlas.png' + g.getVersion('miniPartyAtlas'), onLoad);
            g.load.loadXML(g.dataPath.getGraphicsPath() + 'miniPartyAtlas.xml' + g.getVersion('miniPartyAtlas'), onLoad);
        } else createAtlases();
    }

    private function onLoad(smth:*=null):void {
        count++;
        if (count >=2) createAtlases();
    }

    private function createAtlases():void {
        if (!g.allData.atlas['miniPartyAtlas']) {
            if (g.pBitmaps[g.dataPath.getGraphicsPath() + 'miniPartyAtlas.png' + g.getVersion('miniPartyAtlas')] && g.pXMLs[g.dataPath.getGraphicsPath() + 'miniPartyAtlas.xml' + g.getVersion('miniPartyAtlas')]) {
                g.allData.atlas['miniPartyAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'miniPartyAtlas.png' + g.getVersion('miniPartyAtlas')].create() as Bitmap), g.pXMLs[g.dataPath.getGraphicsPath() + 'miniPartyAtlas.xml' + g.getVersion('miniPartyAtlas')]);
                (g.pBitmaps[g.dataPath.getGraphicsPath() + 'miniPartyAtlas.png' + g.getVersion('miniPartyAtlas')] as PBitmap).deleteIt();

                delete  g.pBitmaps[g.dataPath.getGraphicsPath() + 'miniPartyAtlas.png' + g.getVersion('miniPartyAtlas')];
                delete  g.pXMLs[g.dataPath.getGraphicsPath() + 'miniPartyAtlas.xml' + g.getVersion('miniPartyAtlas')];
                g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'miniPartyAtlas.png' + g.getVersion('miniPartyAtlas'));
                g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'miniPartyAtlas.xml' + g.getVersion('miniPartyAtlas'));
            }
        }
        g.miniPartyPanel = new MiniPartyPanel();
    }

    public function get  timeToStart():int {return _dataMiniParty.timeToStart;}
    public function get  timeToEnd():int {return _dataMiniParty.timeToEnd;}
    public function get  levelToStart():int {return _dataMiniParty.levelToStart;}
    public function get  idItemEvent():Array {return _dataMiniParty.idItemEvent;}
    public function get  typeParty():int {return _dataMiniParty.typeMiniParty;}
    public function get  idGift():Array {return _dataMiniParty.idGift;}
    public function get  countGift():Array {return _dataMiniParty.countGift;}
    public function get  typeGift():Array {return _dataMiniParty.typeGift;}
    public function get  id():int {return _dataMiniParty.id;}
    public function get  iconUI():String {return _dataMiniParty.iconUI;}
    public function get  nameMain():int {return _dataMiniParty.nameMain;}
    public function get  descriptionMain():int {return _dataMiniParty.descriptionMain;}
}
}
