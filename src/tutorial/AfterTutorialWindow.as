/**
 * Created by user on 8/10/16.
 */
package tutorial {
import flash.display.Bitmap;
import flash.geom.Point;

import loaders.PBitmap;

import manager.ManagerFilters;

import manager.Vars;

import starling.core.Starling;

import starling.display.Image;

import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CButton;
import utils.CTextField;

public class AfterTutorialWindow {
    protected var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _btn:CButton;
    private var _callback:Function;
    private var _needShow:Boolean;
    private var _image:Image;
    private var _btnTex:CTextField;

    public function AfterTutorialWindow() {
        _source = new Sprite();
        _btn = new CButton();
        _btn.addButtonTexture(172, 45, CButton.BLUE, true);
        g.load.loadImage(g.dataPath.getGraphicsPath() + 'qui/after_tutorial_window.png',onLoad);
        _needShow = false;
    }

    private function onLoad(bitmap:Bitmap):void {
        _image = new Image(Texture.fromBitmap(g.pBitmaps[g.dataPath.getGraphicsPath() + 'qui/after_tutorial_window.png'].create() as Bitmap));
        _image.x = -_image.width/2;
        _image.y = -_image.height/2;
        if (_needShow) addIt();
    }

    public function showIt(f:Function):void {
        _needShow = true;
        _callback = f;
        if (_image)  {
            addIt();
        }
    }

    private function addIt():void {
        _source.x = g.managerResize.stageWidth / 2;
        _source.y = g.managerResize.stageHeight / 2;
        _source.addChild(_image);
        _btn.y = _image.height/2 - _btn.height/2;
        _btn.clickCallback = onClick;
        g.cont.popupCont.addChild(_source);
        _source.addChild(_btn);
        _btnTex= new CTextField(110,100,String(g.managerLanguage.allTexts[532]));
        _btnTex.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _btnTex.y = -28;
        _btnTex.x = 30;
        _btn.addChild(_btnTex);
    }

    public function hideIt():void {
        (g.pBitmaps[g.dataPath.getGraphicsPath() + 'qui/after_tutorial_window.png'] as PBitmap).deleteIt();
        delete g.pBitmaps[g.dataPath.getGraphicsPath() + 'qui/after_tutorial_window.png'];
        g.load.removeByUrl(g.dataPath.getGraphicsPath() + 'qui/after_tutorial_window.png');
        g.cont.popupCont.removeChild(_source);
        _btnTex.deleteIt();
        _btnTex = null;
        _image = null;
        _btn = null;
        _source = null;
        _callback = null;
    }

    private function onClick():void {
        if (_callback != null) {
            _callback.apply();
            _callback = null;
        }
        hideIt();
    }

    public function  btnNext():Object {
        var ob:Object = {};
        ob.x = _btn.x - _btn.width/2;
        ob.y = _btn.y - 28;
        var p:Point = new Point(ob.x, ob.y);
        p = _source.localToGlobal(p);
        ob.x = p.x;
        ob.y = p.y;
        ob.width = _btn.width;
        ob.height = _btn.height/2;
        return ob;
    }

    public function onResize():void {
        _source.x = g.managerResize.stageWidth / 2;
        _source.y = g.managerResize.stageHeight / 2;
    }
}
}
