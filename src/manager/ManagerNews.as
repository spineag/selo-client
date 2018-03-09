/**
 * Created by user on 2/20/18.
 */
package manager {
import flash.display.Bitmap;

import loaders.PBitmap;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class ManagerNews {
    private var _arrNews:Array;
    private var g:Vars = Vars.getInstance();
    private var count:int;
    private var _st:String;

    public function ManagerNews() {
        _arrNews = [];
        g.server.getDataNews(null);
        _st = g.dataPath.getGraphicsPath();
        count=0;
        g.load.loadImage(_st + 'newsAtlas.png' + g.getVersion('newsAtlas'), onLoad);
        g.load.loadXML(_st + 'newsAtlas.xml' + g.getVersion('newsAtlas'), onLoad);
    }

    private function onLoad(smth:*=null):void {
        count++;
        if (count >= 2) createAtlases();
    }

    private function createAtlases():void {
        g.allData.atlas['newsAtlas'] = new TextureAtlas(Texture.fromBitmap(g.pBitmaps[_st + 'newsAtlas.png' + g.getVersion('newsAtlas')].create() as Bitmap), g.pXMLs[_st + 'newsAtlas.xml' + g.getVersion('newsAtlas')]);
        (g.pBitmaps[_st + 'newsAtlas.png' + g.getVersion('newsAtlas')] as PBitmap).deleteIt();
        delete  g.pBitmaps[_st + 'newsAtlas.png' + g.getVersion('newsAtlas')];
        delete  g.pXMLs[_st + 'newsAtlas.xml' + g.getVersion('newsAtlas')];
        g.load.removeByUrl(_st + 'newsAtlas.png' + g.getVersion('newsAtlas'));
        g.load.removeByUrl(_st + 'newsAtlas.xml' + g.getVersion('newsAtlas'));
    }

    public function addArr(ob:Object):void {
        var b:Boolean = true;
        var data:Object = {};
        data.id = ob.id;
        data.name = int(ob.name);
        data.textPrev = int(ob.text_prev);
        data.textMain = int(ob.text_main);
        data.textPs = int(ob.text_ps);
        data.image = String(ob.image);
        data.time = String(ob.time);
        data.tester = Boolean(int(ob.tester));
        if (g.user.newsNew) {
            for (var i:int = 0; i < g.user.newsNew.length; i++) {
                if (g.user.newsNew[i] == data.id) b = false;
            }
        }
        data.notification = b;
        if (data.tester && (g.user.isTester || g.user.isMegaTester)) _arrNews.push(data);
        if (!data.tester) _arrNews.push(data);
    }

    public function get arrNews():Array { return _arrNews; }

    public function addArrNewsNew(id:int):void {
        g.user.newsNew.push(id);
        var st:String = '';
        var stAnd:String = '';
        for (var i:int = 0; i < _arrNews.length; i++) {
            if (_arrNews[i].id == id) {
                _arrNews[i].notification = false;
                break;
            }
        }
        if (g.user.newsNew.length > 1) {
            for (i = 0; i < g.user.newsNew.length; i++) {
                if (i != g.user.newsNew.length -1) stAnd = '&';
                else stAnd = '';
                st += g.user.newsNew[i] + stAnd;
            }
            g.server.updateUserNewsNew(st, null);
        } else g.server.updateUserNewsNew(String(g.user.newsNew[0]), null);
        if (!g.tuts.isTuts) checkNotificationBottomInterface();
    }

    public function checkNotificationBottomInterface():void {
        if (g.user.newsNew.length >= 1) g.bottomPanel.needNotificationNews(_arrNews.length - g.user.newsNew.length);
        else g.bottomPanel.needNotificationNews(_arrNews.length);
    }
}
}
