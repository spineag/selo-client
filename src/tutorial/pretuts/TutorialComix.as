/**
 * Created by user on 2/2/18.
 */
package tutorial.pretuts {
import manager.ManagerLanguage;

import starling.animation.Tween;
import starling.display.Quad;

import flash.display.Bitmap;

import manager.ManagerFilters;

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.Utils;

public class TutorialComix {

    private var _source:CSprite;
    private var _srcNextTxt:Sprite;
    private var _srcImage:Sprite;
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
        var quad:Quad = new Quad(int(g.managerResize.stageWidth), int(g.managerResize.stageHeight), 0xfffef2);
        _source.addChild(quad);
        _callback = callback;
        _countImage = 1;
        _srcImage = new Sprite();
        _srcImage.alpha = 0;
        _source.addChild(_srcImage);
        _txtBabble = new CTextField(1000, 200, 'Они крепко подружились еще в раннем детстве');
        _txtBabble.setFormat(CTextField.BOLD72, 60, Color.BLACK, Color.WHITE);
        _txtBabble.visible = false;
        _txtBabble.pivotX = _txtBabble.width/2;
//        _txtBabble.x = int(g.managerResize.stageWidth)/2;
//        _txtBabble.y = 25;

        _srcNextTxt = new Sprite();
        _txtNext = new CTextField(1000, 640, String(g.managerLanguage.allTexts[1276]));
        _txtNext.setFormat(CTextField.BOLD72, 40, Color.BLACK, Color.WHITE);
//        _srcNextTxt.x = 610;
//        _srcNextTxt.y = 570;
        _srcNextTxt.visible = false;
        _srcNextTxt.addChild(_txtNext);
        _srcNextTxt.pivotX = _srcNextTxt.width/2;
        _srcImage.addChild(_srcNextTxt);

        _stMustLoad = 'comix/comics_1_small.jpg';
        loadImage();
    }

    private function loadImage():void {
        switch (_stMustLoad) {
            case 'comix/comics_1_small.jpg':
                if (g.user.language == ManagerLanguage.ENGLISH) _stLoad = 'comix/comics_1_small_eng.jpg';
                else _stLoad = 'comix/comics_1_small_rus.jpg';
                g.load.loadImage(g.dataPath.getGraphicsPath() + _stLoad, onLoad);
                _stMustLoad = 'comix/comics_2_small.jpg';
                    return;
            case 'comix/comics_2_small.jpg':
                g.startPreloader.hideIt();
                g.startPreloader = null;
                showImage();
                _stLoad = 'comix/comics_2_small.jpg';
                g.load.loadImage(g.dataPath.getGraphicsPath() + _stLoad, onLoad);
                _stMustLoad = 'comix/comics_3_small.jpg';
                return;
            case 'comix/comics_3_small.jpg':
                _stLoad = 'comix/comics_3_small.jpg';
                g.load.loadImage(g.dataPath.getGraphicsPath() + _stLoad, onLoad);
                _stMustLoad = 'comix/comics_4_small.jpg';
                return;
            case 'comix/comics_4_small.jpg':
                _stLoad = 'comix/comics_4_small.jpg';
                g.load.loadImage(g.dataPath.getGraphicsPath() + _stLoad, onLoad);
                _stMustLoad = 'comix/comics_5_small.jpg';
                return;
            case 'comix/comics_5_small.jpg':
                _stLoad = 'comix/comics_5_small.jpg';
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
            case 'comix/comics_1_small_rus.jpg':
                _im1 = new Image(tex);
                _im1.x = int(g.managerResize.stageWidth)/2 - _im1.width/2;
                _im1.y = int(g.managerResize.stageHeight)/2 - _im1.height/2;
                break;
            case 'comix/comics_1_small_eng.jpg':
                _im1 = new Image(tex);
                _im1.x = int(g.managerResize.stageWidth)/2 - _im1.width/2;
                _im1.y = int(g.managerResize.stageHeight)/2 - _im1.height/2;
                break;
            case 'comix/comics_2_small.jpg':
                _im2 = new Image(tex);
                _im2.x = int(g.managerResize.stageWidth)/2 - _im2.width/2;
                _im2.y = int(g.managerResize.stageHeight)/2 - _im2.height/2;
                break;
            case 'comix/comics_3_small.jpg':
                _im3 = new Image(tex);
                _im3.x = int(g.managerResize.stageWidth)/2 - _im3.width/2;
                _im3.y = int(g.managerResize.stageHeight)/2 - _im3.height/2;
                break;
            case 'comix/comics_4_small.jpg':
                _im4 = new Image(tex);
                _im4.x = int(g.managerResize.stageWidth)/2 - _im4.width/2;
                _im4.y = int(g.managerResize.stageHeight)/2 - _im4.height/2;
                break;
            case 'comix/comics_5_small.jpg':
                _im5 = new Image(tex);
                _im5.x = int(g.managerResize.stageWidth)/2 - _im5.width/2;
                _im5.y = int(g.managerResize.stageHeight)/2 - _im5.height/2;
                break;
        }
        loadImage();
    }

    private function showImage():void {

        switch (_countImage) {
            case 1:
                _srcImage.addChildAt(_im1,0);
                _srcImage.addChild(_txtBabble);
                _txtBabble.text = String(g.managerLanguage.allTexts[1271]);
                break;
            case 2:
                _srcImage.removeChild(_im1);
                _srcImage.alpha = 0;
                _srcImage.addChildAt(_im2,0);
                _txtBabble.text = String(g.managerLanguage.allTexts[1272]);
                _txtBabble.changeSize = 40;
//                _txtBabble.x = _im2.x +_im2.width/2;
//                _txtBabble.y = 30;
                _txtBabble.width = 700;
                break;
            case 3:
                _srcImage.removeChild(_im2);
                _srcImage.alpha = 0;
                _srcImage.addChildAt(_im3,0);
                _txtBabble.text = String(g.managerLanguage.allTexts[1273]);
                _txtBabble.changeSize = 40;
//                _txtBabble.x = _im3.x +_im3.width/2;
//                _txtBabble.y = 35;
                _txtBabble.width = 700;
                break;
            case 4:
                _srcImage.removeChild(_im3);
                _srcImage.alpha = 0;
                _srcImage.addChildAt(_im4,0);
                _txtBabble.text = String(g.managerLanguage.allTexts[1274]);
                _txtBabble.changeSize = 40;
//                _txtBabble.x = _im4.x +_im4.width/2;
//                _txtBabble.y = 35;
                _txtBabble.width = 700;
                break;
            case 5:
                _srcImage.removeChild(_im4);
                _srcImage.alpha = 0;
                _srcImage.addChildAt(_im5,0);
                _txtBabble.text = String(g.managerLanguage.allTexts[1275]);
                _txtBabble.changeSize = 40;
                _txtBabble.width = 750;
//                _txtBabble.x = _im5.x +_im5.width/2;
//                _txtBabble.y = 38;
//                _txtBabble.width = 300;
                break;
        }
        _txtBabble.pivotX = _txtBabble.width/2;
        _txtBabble.alignV = Align.TOP;
//        _txtBabble.alignH = Align.BOTTOM;
        _txtBabble.x = _im1.x +_im1.width/2;
        _txtBabble.y = _im1.y + 15;
        var tween:Tween;
        tween = new Tween(_srcImage, 0.6);
        tween.fadeTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
//            _txtBabble.x = int(g.managerResize.stageWidth)/2;
            _txtBabble.visible = true;
            _countTimer = 0;
            g.gameDispatcher.addToTimer(timerToText);
        };
        g.starling.juggler.add(tween);
    }

    private function timerToText():void {
        _countTimer ++;
        if (_countTimer >= 3) {
            g.gameDispatcher.removeFromTimer(timerToText);
            _countTimer = 0;
            _srcNextTxt.x = _im1.x +_im1.width/2;
            _srcNextTxt.y = int(g.managerResize.stageHeight)/2 - _txtNext.textBounds.height;
            _srcNextTxt.visible = true;
            animationNextTxt();
            _source.endClickCallback = onClick;
        }
    }

    private function animationNextTxt():void {
        var f1:Function = function ():void {
            tween = new Tween(_srcNextTxt, 0.5);
            tween.scaleWidth(.95);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
                animationNextTxt();
            };
            g.starling.juggler.add(tween);
        };
        var tween:Tween;
        tween = new Tween(_srcNextTxt, 0.5);
        tween.scaleWidth(1.15);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            f1();
        };
        g.starling.juggler.add(tween);
    }

    private function onClick():void {
        var f1:Function = function ():void {
            _countImage ++;
            if (_countImage > 5) {
                _srcNextTxt.visible = false;
                g.cont.popupCont.removeChild(_source);
                if (_callback != null) {
                    _callback.apply(null);
                    _callback = null;
                }
            } else {
                _srcNextTxt.visible = false;
                _source.endClickCallback = null;
                showImage();
            }
        };
        _txtBabble.visible = false;
        var tween:Tween;
        tween = new Tween(_srcImage, 0.6);
        tween.fadeTo(0);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            f1();
        };
        g.starling.juggler.add(tween);
    }
}
}
