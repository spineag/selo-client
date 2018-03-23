/**
 * Created by andy on 3/3/16.
 */
package tutorial {
import com.greensock.TweenMax;

import flash.display.Bitmap;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;

import particle.tuts.DustLikeRectangle;
import particle.tuts.DustRectangle;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.Texture;
import starling.utils.Color;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;
import utils.SimpleArrow;

public class CutSceneTextBubble {
    public static var SMALL:int = 1;
    public static var MIDDLE:int = 2;
    public static var BIG:int = 3;

    private var _source:Sprite;
    private var _parent:Sprite;
    private var _btn:CButton;
    private var _btnTxt:CTextField;
    private var _txtBubble:CTextField;
    private var _btnExit:CButton;
    private var _type:int;
    private var _innerImage:Image;
    private var _dustRectangle:DustLikeRectangle;
    private var _startClickCallback:Function;
    private var g:Vars = Vars.getInstance();
    private var _btnUrl:String;
    private var _imageBtn:CSprite;
    private var _arrow:SimpleArrow;
    private var _st:String;
    private var _isBigShop:Boolean;
    private var _stPNG:String;

    public function CutSceneTextBubble(p:Sprite, type:int, stURL:String = '', btnUrl:String = '') {
        _type = type;
        _parent = p;
        _source = new Sprite();
        _source.y = -140;
        _source.x = 55;
        _parent.addChild(_source);
        _btnUrl = btnUrl;

//        if (stURL != '') {
//            _innerImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture(stURL));
//        } else if (btnUrl != '') {
//            _innerImage = new Image(g.allData.atlas['interfaceAtlas'].getTexture(btnUrl));
//        }
    }

    private function onLoad(bitmap:Bitmap):void {
        var st:String = g.dataPath.getGraphicsPath();
        bitmap = g.pBitmaps[st + _stPNG].create() as Bitmap;
        photoFromTexture(Texture.fromBitmap(bitmap));
    }

    private function photoFromTexture(tex:Texture):void {
        _innerImage = new Image(tex);
        createBubble(_st);
        if (_source) {
            _source.scaleX = _source.scaleY = .3;
            TweenMax.to(_source, .2, {scaleX: 1, scaleY: 1, onComplete: onCompleteShow});
        }
    }

    public function showBubble(st:String, btnSt:String, callback:Function, callbackNo:Function=null, startClick:Function=null):void {
        if (_btnUrl != '') {
            addImageButton(callback, startClick);
        } else {
            if (callback != null) addButton(btnSt, callback, startClick);
            if (callbackNo != null) addNoButton(callbackNo);
        }
        _st = st;
        if (g.managerResize.stageWidth < 1040 || g.managerResize.stageHeight < 700) _isBigShop = false;
        else _isBigShop = true;
//        _isBigShop = false ;///AHTUNG
        if (_isBigShop) _stPNG = 'qui/grey_cat_tutorial_babble.png';
        else _stPNG = 'qui/babble_cat_window.png';
        g.load.loadImage(g.dataPath.getGraphicsPath() + _stPNG, onLoad);

    }
    
    private function onCompleteShow():void {
        addParticles();
    }

    public function onResize():void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
            addParticles();
        }
    }

    public function set startClick(f:Function):void {
        if (_btn) _btn.startClickCallback = f;
        if (_imageBtn) _imageBtn.startClickCallback = f;
    }

    private function addImageButton(callback:Function, startClick:Function):void {
        _imageBtn = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_icon'));
        if (!_isBigShop) MCScaler.scale(im, im.height - 15, im.width - 15);
        im.alignPivot();
        _imageBtn.addChild(im);
        if(_innerImage) _innerImage.alignPivot();
        if(_innerImage)  _imageBtn.addChild(_innerImage);
        _imageBtn.startClickCallback = startClick;
        _imageBtn.endClickCallback = callback;
    }

    private function addButton(btnSt:String, callback:Function, startClick:Function):void {
        _btn = new CButton();
        _btn.addButtonTexture(200, 30, CButton.GREEN, true);
        _btn.clickCallback = callback;
        _btn.startClickCallback = startClick;
        _btnTxt = new CTextField(200, 30, btnSt);
        _btnTxt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _btn.addChild(_btnTxt);
        _btn.releaseHoverAnimation();
    }

    private function addNoButton(callback:Function):void {
        _btnExit = new CButton();
        _btnExit.addDisplayObject(new Image(g.allData.atlas['interfaceAtlas'].getTexture('bt_close')));
        _btnExit.setPivots();
        _btnExit.createHitArea('bt_close');
        _btnExit.clickCallback = callback;
    }

    private function createBubble(st:String):void {
        if (_isBigShop) {
            _txtBubble = new CTextField(430, 200, st);
            _txtBubble.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
            switch (_type) {
                case BIG:
                    _txtBubble.x = 135;
                    _txtBubble.y = -130;
                    if (_imageBtn) {
                        _imageBtn.x = 350;
                        _imageBtn.y = 105;
                    }
                    break;
                case MIDDLE:
                    _txtBubble.width = 300;
                    _txtBubble.x = 195;
                    _txtBubble.y = -130;
                    break;
                case SMALL:
                    _txtBubble.height = 80;
                    _txtBubble.x = 62;
                    _txtBubble.y = -94;
                    if (_imageBtn) {
                        _imageBtn.x = 350;
                        _imageBtn.y = 105;
                    }
                    break;
            }
            _source.addChild(_innerImage);
            _innerImage.x = -15;
            _innerImage.y = -_innerImage.height / 2;

            _txtBubble.autoScale = true;
            if (_btn) {
                _btn.x = 350;
                _btn.y = 108;
                _source.addChild(_btn);
            }
            _source.addChild(_txtBubble);
            if (_imageBtn) _source.addChild(_imageBtn);
            if (_btnExit) {
                _btnExit.x = _innerImage.x + _innerImage.width - 20;
                _btnExit.y = _innerImage.y + 35;
                _source.addChild(_btnExit);
            }
            if (_imageBtn && _btnUrl != '') {
                _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, _source);
                _arrow.scaleIt(.5);
                _arrow.animateAtPosition(_imageBtn.x + _imageBtn.width / 2 + 20, _imageBtn.y);
            }
        } else {
            _txtBubble = new CTextField(370, 200, st);
            _txtBubble.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
            switch (_type) {
                case BIG:
                    _txtBubble.x = 40;
                    if (_imageBtn) {
                        _imageBtn.scaleX = _imageBtn.scaleY = .8;
                        _imageBtn.x = 230;
                        _imageBtn.y = 67;
                        _txtBubble.y = -134;
                    } else {
                        _txtBubble.y = -114;

                    }
                    break;
                case MIDDLE:
                    _txtBubble.width = 300;
                    _txtBubble.x = 73;
                    _txtBubble.y = -130;
                    break;
                case SMALL:
                    _txtBubble.height = 80;
                    _txtBubble.x = 62;
                    _txtBubble.y = -94;
                    if (_imageBtn) {
                        _imageBtn.x = 230;
                        _imageBtn.y = 80;
                    }
                    break;
            }

            if (_innerImage) {
                if (_source) _source.addChild(_innerImage);
                _innerImage.x = -15;
                _innerImage.y = -_innerImage.height / 2;
            }
            if (_txtBubble) _txtBubble.autoScale = true;
            if (_btn) {
                _btn.x = 230;
                _btn.y = 80;
                if (_source) _source.addChild(_btn);
            }
            if (_source) _source.addChild(_txtBubble);
            if (_imageBtn) _source.addChild(_imageBtn);
            if (_btnExit) {
                _btnExit.x = _innerImage.x + _innerImage.width - 20;
                _btnExit.y = _innerImage.y + 35;
                if (_source) _source.addChild(_btnExit);
            }
            if (_imageBtn && _btnUrl != '') {
                _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, _source);
                _arrow.scaleIt(.5);
                _arrow.animateAtPosition(_imageBtn.x + _imageBtn.width / 2 + 20, _imageBtn.y);
            }
        }
    }

    public function hideBubble(f:Function, f2:Function):void {
        if (_dustRectangle) {
            _dustRectangle.deleteIt();
            _dustRectangle = null;
        }
        deleteArrow();
        TweenMax.to(_source, .2, {scaleX: .1, scaleY: .1, onComplete: directHide, onCompleteParams: [f, f2]});
    }

    private function directHide(f:Function = null, f2:Function = null):void {
        deleteIt();
        if (f != null) {
            f.apply();
        }
        if (f2 != null) {
            f2.apply();
        }
    }

    private function addParticles():void {
        var p:Point = new Point();
        if (_btn) {
            p.x = _btn.x - _btn.width/2 - 5;
            p.y = _btn.y - _btn.height/2 - 5;
            p = _source.localToGlobal(p);
            _dustRectangle = new DustLikeRectangle(g.cont.popupCont, _btn.width + 10, _btn.height + 10, p.x, p.y);
        } else if (_imageBtn) {
            p.x = _imageBtn.x - _imageBtn.width/2 - 5;
            p.y = _imageBtn.y - _imageBtn.height/2 - 5;
            p = _source.localToGlobal(p);
            _dustRectangle = new DustLikeRectangle(g.cont.popupCont, _imageBtn.width + 10, _imageBtn.height + 10, p.x, p.y);
        }
    }

    private function deleteIt():void {
        if (_parent.contains(_source)) _parent.removeChild(_source);
        if (_btn) {
            if (_source.contains(_btn)) _source.removeChild(_btn);
            _btn.dispose();
            _btn = null;
        }
        if (_imageBtn) {
            if (_source.contains(_imageBtn)) _source.removeChild(_imageBtn);
            _imageBtn.dispose();
            _imageBtn = null;
        }
        if (_txtBubble) {
            _txtBubble.deleteIt();
            _txtBubble = null;
        }
        _source.dispose();
        _source = null;
        _parent = null;
        if (_innerImage) {
            _innerImage.dispose();
            _innerImage = null;
        }
    }

    private function deleteArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }
}
}
