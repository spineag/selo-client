/**
 * Created by user on 2/2/18.
 */
package tutorial.pretuts {
import flash.display.Bitmap;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.textures.Texture;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

public class TutorialComix {

    private var _source:CSprite;
    private var _im1:Image;
    private var _im2:Image;
    private var _im3:Image;
    private var _im4:Image;
    private var _im5:Image;
    private var _txtBabble:CTextField;
    private var _txtNext:CTextField;
    private var g:Vars = Vars.getInstance();
    private var _stLoad:String;
    private var _stMustLoad:String;
    private var _countImage:int;
    private var _countTimer:int;
    private var _callback:Function;

    public function TutorialComix(callback:Function) {
        _source = new CSprite();
        g.cont.popupCont.addChild(_source);
        _callback = callback;
        _countImage = 1;
        _txtBabble = new CTextField(200, 200, 'Они крепко подружились еще в раннем детстве');
        _txtBabble.setFormat(CTextField.BOLD72, 72, Color.BLACK);
        _txtBabble.visible = false;
        _txtBabble.x = 40;
        _txtBabble.y = -40;
        _source.addChild(_txtBabble);

        _txtNext = new CTextField(200, 200, 'Нажми для Продолжения!');
        _txtNext.setFormat(CTextField.BOLD72, 72, Color.BLACK, Color.WHITE);
//        _txtNext.x = 40;
//        _txtNext.y = -40;
        _txtNext.visible = false;
        _source.addChild(_txtNext);

        _stMustLoad = 'comix/comics_1.jpg';
        _stLoad = 'comix/comics_1.jpg';
        loadImage();
    }

    private function loadImage():void {
        switch (_stMustLoad) {
            case 'comix/comics_1.jpg':
                _stLoad = 'comix/comics_1.jpg';
                g.load.loadImage(g.dataPath.getGraphicsPath() + _stLoad, onLoad);
                _stMustLoad = 'comix/comics_2.jpg';
                    return;
            case 'comix/comics_2.jpg':
                g.startPreloader.hideIt();
                g.startPreloader = null;
                showImage();
                _stLoad = 'comix/comics_2.jpg';
                g.load.loadImage(g.dataPath.getGraphicsPath() + _stLoad, onLoad);
                _stMustLoad = 'comix/comics_3.jpg';
                return;
            case 'comix/comics_3.jpg':
                _stLoad = 'comix/comics_3.jpg';
                g.load.loadImage(g.dataPath.getGraphicsPath() + _stLoad, onLoad);
                _stMustLoad = 'comix/comics_4.jpg';
                return;
            case 'comix/comics_4.jpg':
                _stLoad = 'comix/comics_4.jpg';
                g.load.loadImage(g.dataPath.getGraphicsPath() + _stLoad, onLoad);
                _stMustLoad = 'comix/comics_5.jpg';
                return;
            case 'comix/comics_5.jpg':
                _stLoad = 'comix/comics_5.jpg';
                g.load.loadImage(g.dataPath.getGraphicsPath() + _stLoad, onLoad);
                _stMustLoad = '0';
                return;
        }
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + _stLoad].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        switch (_stLoad) {
            case 'comix/comics_1.jpg':
                _im1 = new Image(tex);
                _im1.visible = false;
                    MCScaler.scale(_im1,_im1.height/2, _im1.width/2);
                _source.addChildAt(_im1,0);
                break;
            case 'comix/comics_2.jpg':
                _im2 = new Image(tex);
                _im2.visible = false;
                _source.addChildAt(_im2,0);
                break;
            case 'comix/comics_3.jpg':
                _im3 = new Image(tex);
                _im3.visible = false;
                _source.addChildAt(_im3,0);
                break;
            case 'comix/comics_4.jpg':
                _im4 = new Image(tex);
                _im4.visible = false;
                _source.addChildAt(_im4,0);
                break;
            case 'comix/comics_5.jpg':
                _im5 = new Image(tex);
                _im5.visible = false;
                _source.addChildAt(_im5,0);
                break;
        }
        loadImage();
    }

    private function showImage():void {
        switch (_countImage) {
            case 1:
                _im1.visible = true;
                break;
            case 2:
                _im1.visible = false;
                _im2.visible = true;
                break;
            case 3:
                _im1.visible = false;
                _im2.visible = false;
                _im3.visible = true;
                break;
            case 4:
                _im1.visible = false;
                _im2.visible = false;
                _im3.visible = false;
                _im4.visible = true;
                break;
            case 5:
                _im1.visible = false;
                _im2.visible = false;
                _im3.visible = false;
                _im4.visible = false;
                _im5.visible = true;
                break;
        }

        _countTimer = 0;
        g.gameDispatcher.addToTimer(timerToText);
    }

    private function timerToText():void {
        _countTimer ++;
        if (_countTimer >= 7) {
            g.gameDispatcher.removeFromTimer(timerToText);
            _countTimer = 0;
            _txtNext.visible = true;
            _source.endClickCallback = onClick;
        }
    }

    private function onClick():void {
        _countImage ++;
        if (_countImage > 5) {
            g.cont.popupCont.removeChild(_source);
            if (_callback != null) {
                _callback.apply(null);
                _callback = null;
            }
        } else {
            _source.endClickCallback = null;
            showImage();
        }
    }
}
}
