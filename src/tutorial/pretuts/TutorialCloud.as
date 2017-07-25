/**
 * Created by user on 6/15/16.
 */
package tutorial.pretuts {
import com.greensock.TweenMax;
import flash.display.Bitmap;

import loaders.PBitmap;

import manager.ManagerFilters;
import manager.Vars;

import social.SocialNetworkSwitch;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CTextField;

public class TutorialCloud {
    private var _source:Sprite;
    private var _bg:Image;
    private var _txt:CTextField;
    private var _btnTxt:CTextField;
    private var _txtPage:CTextField;
    private var _txtSp:Sprite;
    private var _callback:Function;
    private var _btn:CButton;
    private var _isClickable:Boolean;
    private var g:Vars = Vars.getInstance();
    private var _leftIm:Image;
    private var _rightIm:Image;

    public function TutorialCloud(f:Function) {
        _callback = f;
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'x1/cloud.jpg', onLoad);
    }

    private function onLoad(p:Bitmap):void {
        _isClickable = false;
        _bg = new Image(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'x1/cloud.jpg'].create() as Bitmap));
        (g.pBitmaps[g.dataPath.getGraphicsPath() + 'x1/cloud.jpg'] as PBitmap).deleteIt();
        delete g.pBitmaps[g.dataPath.getGraphicsPath() + 'x1/cloud.jpg'];
        g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'x1/cloud.jpg');
        _source = new Sprite();
        _source.addChild(_bg);
        _txtSp = new Sprite();
        _txt = new CTextField(680, 340, '');
        _txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR);
        _txtSp.addChild(_txt);
        _txtSp.x = 177;
        _txtSp.y = 128;
        _source.addChild(_txtSp);
        _txtSp.touchable = false;
        g.cont.popupCont.addChild(_source);
        _btn = new CButton();
        _btn.addButtonTexture(120, 40, CButton.BLUE, true);
        _btn.x = 500;
        _btn.y = 520;
        _btnTxt = new CTextField(120, 40, String(g.managerLanguage.allTexts[532]));
        _btnTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _btn.addChild(_btnTxt);
        _btn.clickCallback = onClick;
        _source.addChild(_btn);
        _txtPage = new CTextField(100, 30, '');
        _txtPage.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR);
        _txtPage.x = 450;
        _txtPage.y = 460;
        _source.addChild(_txtPage);
        applyCallback();
        onResize();
        addIms();
    }

    public function onResize():void {
        _source.x = g.managerResize.stageWidth/2 - 500;
    }

    private function addIms():void {
        if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
            if (g.pBitmaps['uho1']) {
                (g.pBitmaps['uho1'] as PBitmap).deleteIt();
                delete g.pBitmaps['uho1'];
                g.load.removeByUrl('uho1');
            }
            if (g.pBitmaps['uho2']) {
                (g.pBitmaps['uho2'] as PBitmap).deleteIt();
                delete g.pBitmaps['uho2'];
                g.load.removeByUrl('uho2');
            }
            return;
        }
        if (!_leftIm) {
            _leftIm = new Image(Texture.fromBitmap(g.pBitmaps['uho1'].create() as Bitmap));
            _leftIm.x = -_leftIm.width + 2;
            _source.addChild(_leftIm);
            _leftIm.touchable = false;
        }
        if (!_rightIm) {
            _rightIm = new Image(Texture.fromBitmap(g.pBitmaps['uho2'].create() as Bitmap));
            _rightIm.x = 1000;
            _source.addChild(_rightIm);
            _rightIm.touchable = false;
        }
    }

    private function applyCallback():void {
        if (_callback != null) {
            _callback.apply();
        }
    }

    public function showText(t:String, f:Function, page:int):void {
        _callback = f;
        _txt.text = t;
        _txtSp.alpha = 0;
        _txtPage.text = String(page) + '/4';
        TweenMax.to(_txtSp, .3, {alpha:1, onComplete: anim1});
    }

    private function anim1():void {
        _isClickable = true;
    }

    private function onClick():void {
        if (!_isClickable) return;
        TweenMax.to(_txtSp, .3, {alpha:0, onComplete: anim2});
    }

    private function anim2():void {
        _txt.text = '';
        _txtPage.text = '';
        _isClickable = false;
        applyCallback();
    }

    public function deleteIt():void {
        g.cont.popupCont.removeChild(_source);
        if (_btnTxt) {
            _btnTxt.deleteIt();
            _btnTxt = null;
        }
        if (_txtPage) {
            _txtPage.deleteIt();
            _txtPage = null;
        }
        if (_txt) {
            _txt.deleteIt();
            _txt = null;
        }
        _source.removeChild(_btn);
        _btn.deleteIt();
        _source.dispose();
    }
}
}
