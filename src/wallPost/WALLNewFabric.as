/**
 * Created by user on 5/31/16.
 */
package wallPost {
import flash.display.Bitmap;

import loaders.PBitmap;

import manager.ManagerLanguage;

import manager.Vars;
import social.SocialNetworkSwitch;
import starling.core.Starling;
import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import utils.DrawToBitmap;

public class WALLNewFabric {
    protected var g:Vars = Vars.getInstance();
    private var _data:Object;
    private var stUrl:String;

    public function WALLNewFabric(callback:Function, params:Object):void {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_OK_ID) {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/ok/wall_OK_fabric.png';
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[470]), null, stUrl);
        } else if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            if (g.user.language == ManagerLanguage.RUSSIAN) {
                stUrl = g.dataPath.getGraphicsPath() + 'wall/fb/new/fb_5.jpg';
            } else {
                stUrl = g.dataPath.getGraphicsPath() + 'wall/fb/new/fb_5_eng.jpg';
            }
            g.socialNetwork.wallPostBitmap(String(g.user.userSocialId), String(g.managerLanguage.allTexts[470]), null, stUrl);
        } else {
            _data = params;
            stUrl = g.dataPath.getGraphicsPath() + 'wall/wall_new_fabric.jpg';
            g.load.loadImage(stUrl, onLoad);
        }
    }

    private function onLoad(bitmap:Bitmap):void { // only for VK
        var source:Sprite = new Sprite();
        bitmap = g.pBitmaps[stUrl].create() as Bitmap;
        source.addChild(new Image(Texture.fromBitmap(bitmap)));
        if (_data.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_data.image + '_icon');
            if (!texture) {
                texture = g.allData.atlas['iconAtlas'].getTexture(_data.url + '_icon');
            }
        }
        var im:Image = new Image(texture);
        im.alignPivot();
        im.x = 220;
        im.y = 295;
        source.addChild(im);
        var bitMap:Bitmap = DrawToBitmap.drawToBitmap(Starling.current, source);
        g.socialNetwork.wallPostBitmap(String(g.user.userSocialId),String(g.managerLanguage.allTexts[470]),bitMap,'interfaceAtlas');
        (g.pBitmaps[stUrl] as PBitmap).deleteIt();
        delete g.pBitmaps[stUrl];
        g.load.removeByUrl(stUrl);
        _data = null;
    }
}
}

