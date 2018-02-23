/**
 * Created by user on 5/31/16.
 */
package windows.wallPost {
import com.junkbyte.console.Cc;

import data.DataMoney;
import flash.display.Bitmap;
import flash.display.StageDisplayState;
import flash.geom.Rectangle;

import loaders.PBitmap;

import manager.ManagerFilters;
import manager.ManagerWallPost;

import social.SocialNetworkSwitch;

import starling.core.Starling;
import starling.display.Image;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;
import utils.MCScaler;

import windows.WindowMain;
import windows.WindowsManager;

public class PostOpenFabric  extends WindowMain {
    private var _btn:CButton;
    private var _image:Image;
    private var _data:Object;
    private var _txt1:CTextField;
    private var _txt2:CTextField;
    private var stUrl:String;
    
    public function PostOpenFabric() {
        super();
        _windowType = WindowsManager.POST_OPEN_FABRIC;
        _woHeight = 510;
        _woWidth = 510;
    }

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
        _data = params[0];
        if (g.socialNetworkID == SocialNetworkSwitch.SN_FB_ID) {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/fb/wall_5_eng.png';
        } else {
            stUrl = g.dataPath.getGraphicsPath() + 'wall/wall_new_fabric.png';
        }
        g.load.loadImage(stUrl, onLoad);
    }

    private function onLoad(bitmap:Bitmap):void {
        if (g.pBitmaps) {
            bitmap = g.pBitmaps[stUrl].create() as Bitmap;
            try {
                photoFromTexture(Texture.fromBitmap(bitmap));
            } catch (e:Error) {
                Cc.error('PostOpenFabrica:: ' + e.message);
                hideIt();
            }
        } else {
            Cc.error('PostDoneFabrica no stUrl: ' + stUrl);
            super.hideIt();
        }
    }

    private function photoFromTexture(tex:Texture):void {
        _image = new Image(tex);
        _image.pivotX = _image.width/2;
        _image.pivotY = _image.height/2;
        _source.addChild(_image);
        _btn = new CButton();
        _btn.addButtonTexture(200, CButton.HEIGHT_41, CButton.GREEN, true);
        _btn.addTextField(200, 40, -3, -5, String(g.managerLanguage.allTexts[291]));
        _btn.setTextFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _source.addChild(_btn);
        _btn.clickCallback = onClick;
        _btn.y = 240;
        _source.addChild(_btn);
        createExitButton(hideIt);
    }

    private function onClick():void {
        if (Starling.current.nativeStage.displayState != StageDisplayState.NORMAL) {
            Starling.current.nativeStage.displayState = StageDisplayState.NORMAL;
        }
        g.managerWallPost.postWallpost(ManagerWallPost.NEW_FABRIC,null,200,DataMoney.SOFT_CURRENCY,_data);
        _btn.clickCallback = null;
        hideIt();
    }

    override public function hideIt():void {
        g.managerCats.jumpCatsFunny();
        super.hideIt();
    }

    override protected function deleteIt():void {
        if (_txt1) {
            _btn.removeChild(_txt1);
            _txt1.deleteIt();
            _txt1 = null;
        }
        if (_txt2) {
            _btn.removeChild(_txt2);
            _txt2.deleteIt();
            _txt2 = null;
        }
        _btn = null;
        _source = null;
        _data = null;
        if (g.pBitmaps[stUrl] as PBitmap) {
            (g.pBitmaps[stUrl] as PBitmap).deleteIt();
            delete g.pBitmaps[stUrl];
            g.load.removeByUrl(stUrl);
        }
    }
}

}
