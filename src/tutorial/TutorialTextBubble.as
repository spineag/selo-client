/**
 * Created by andy on 3/3/16.
 */
package tutorial {
import flash.geom.Point;

import manager.ManagerFilters;
import manager.Vars;

import particle.tuts.DustLikeRectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CSprite;

import utils.CTextField;
import utils.MCScaler;
import utils.SimpleArrow;

public class TutorialTextBubble {
    public static var SMALL:int = 1;
    public static var MIDDLE:int = 2;
    public static var BIG:int = 3;
    public static var SMALL_ORDER:int = 4;

    private var _source:Sprite;
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();
    private var _isFlip:Boolean;
    private var _needShowShop:Boolean;
    private var _type:int;
    private var _im:Image;
    private var _txt:CTextField;
    private var _imageBtn:CSprite;
    private var _innerImage:Image;
    private var _dustRectangle:DustLikeRectangle;
    private var _arrow:SimpleArrow;

    public function TutorialTextBubble(p:Sprite) {
        _parent = p;
        _isFlip = false;
        _source = new Sprite();
        _parent.addChild(_source);
    }

    public function setXY(_x:int, _y:int):void {
        _source.x = _x;
        _source.y = _y;
    }

    public function showBubble(st:String, isFlip:Boolean, type:int, needShowShop:Boolean = false, callback:Function=null, startClick:Function=null):void {
        _isFlip = isFlip;
        _type = type;
        _needShowShop = needShowShop;
        createBubble(st);
        if (_needShowShop) addImageButton(callback,startClick);
    }

    private function createBubble(st:String):void {
        switch (_type) {
            case BIG:
                _txt = new CTextField(278, 180, st);
                _txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
                _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_1'));
                if (_isFlip) {
                    _im.x = -12;
                    _im.y = -210;
                    _txt.x = 62;
                    _txt.y = -178;
                } else {
                    _im.scaleX = -1;
                    _im.x = 12;
                    _im.y = -210;
                    _txt.x = -334;
                    _txt.y = -178;
                }
                    if (_needShowShop) _txt.y = -220;
                break;
            case MIDDLE:
                _txt = new CTextField(278, 180, st);
                _txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
                _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_2'));
                _txt.height = 134;
                if (_isFlip) {
                    _im.x = -12;
                    _im.y = -169;
                    _txt.x = 67;
                    _txt.y = -135;
                } else {
                    _im.scaleX = -1;
                    _im.x = 12;
                    _im.y = -169;
                    _txt.x = -343;
                    _txt.y = -135;
                }
                break;
            case SMALL:
                _txt = new CTextField(278, 180, st);
                _txt.setFormat(CTextField.BOLD24, 22, ManagerFilters.BLUE_COLOR);
                _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_3'));
                _txt.height = 90;
                if (_isFlip) {
//                    _im.x = -15;
                    _im.y = -111;
                    _txt.x = 45;
                    _txt.y = -85;
                } else {
                    _im.scaleX = -1;
                    _im.x = -3;
                    _im.y = -111;
                    _txt.x = -335;
                    _txt.y = -85;
                }
                break;
            case SMALL_ORDER:
                _txt = new CTextField(210   , 180, st);
                _txt.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
                _im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('baloon_4'));
                _txt.height = 90;
                if (_isFlip) {
                    _im.x = -15;
                    _im.y = -116;
                    _txt.x = 20;
                    _txt.y = -100;
                } else {
                    _im.scaleX = -1;
                    _im.x = 15;
                    _im.y = -116;
                    _txt.x = -335;
                    _txt.y = -85;
                }
                break;
        }
        _source.addChild(_im);
        _source.addChild(_txt);
    }

    private function addImageButton(callback:Function, startClick:Function):void {
        _imageBtn = new CSprite();
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('shop_icon'));
        MCScaler.scale(im, im.height - 15, im.width - 15);
        im.alignPivot();
        _imageBtn.addChild(im);
        if(_innerImage) _innerImage.alignPivot();
        if(_innerImage)  _imageBtn.addChild(_innerImage);
        _imageBtn.startClickCallback = startClick;
        _imageBtn.endClickCallback = callback;
        _imageBtn.x = -190;
        _imageBtn.y = -30;
        _source.addChild(_imageBtn);
        addParticles();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_RIGHT, _source);
        _arrow.scaleIt(.5);
        _arrow.animateAtPosition(_imageBtn.x + _imageBtn.width / 2 + 20, _imageBtn.y);
    }

    private function addParticles():void {
        var p:Point = new Point();
         if (_imageBtn) {
            p.x = _imageBtn.x - _imageBtn.width/2 - 5;
            p.y = _imageBtn.y - _imageBtn.height/2 - 5;
            p = _source.localToGlobal(p);
            _dustRectangle = new DustLikeRectangle(_source, _imageBtn.width + 10, _imageBtn.height + 10, _imageBtn.x - _imageBtn.width/2 - 5, _imageBtn.y - _imageBtn.height/2 - 5);
        }
    }

    public function clearIt():void {
        _source.removeChild(_txt);
        if (_txt) _txt.dispose();
        _txt = null;
        _source.removeChild(_im);
        if (_im) _im.dispose();
        _im = null;
        if (_imageBtn) _imageBtn.dispose();
        _imageBtn = null;
        deleteArrow();
        if (_dustRectangle)_dustRectangle.deleteIt();
    }

    private function deleteArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function deleteIt():void {
        if (_parent && _parent.contains(_source)) _parent.removeChild(_source);
        if (_source) _source.dispose();
        if (_txt) {
            _txt.deleteIt();
            _txt = null;
        }
        _source = null;
        _parent = null;
    }

}
}
