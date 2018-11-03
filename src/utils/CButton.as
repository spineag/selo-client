/**
 * Created by user on 5/21/15.
 */
package utils {
import com.greensock.TweenMax;
import flash.geom.Point;
import flash.ui.Mouse;
import manager.ManagerFilters;
import manager.Vars;
import manager.hitArea.ManagerHitArea;
import manager.hitArea.OwnHitArea;
import media.SoundConst;
import mouse.OwnMouse;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.filters.ColorMatrixFilter;
import starling.utils.Color;

import windows.WOComponents.WOSimpleButtonTexture;

public class CButton extends Sprite {
    public static const GREEN:int = 1;
    public static const ORANGE:int = 2;
    public static const RED:int = 3;
    public static const YELLOW:int = 4;
    public static const BLUE:int = 5;

    public static const HEIGHT_55:int = 55;
    public static const HEIGHT_41:int = 41;
    public static const HEIGHT_32:int = 32;

    private var _clickCallback:Function;
    private var _hoverCallback:Function;
    private var _outCallback:Function;
    private var _startClickCallback:Function;
    private var _onMovedCallback:Function;
    private var _scale:Number;
    private var _bg:Sprite;
    private var _hitArea:OwnHitArea;
    private var _hitAreaState:int;
    private var _isHover:Boolean;
    private var _isHoverAnimation:Boolean;
    private var _hoverImage:Image;
    private var _colorBGFilter:ColorMatrixFilter;
    private var _txt:CTextField;
    private var _sensBlocks:Array;
    private var g:Vars = Vars.getInstance();

    public function CButton() {
        super();
        _isHoverAnimation = false;
        _scale = 1;
        _bg = new Sprite();
        _isHover = false;
        _sensBlocks = [];
        this.addChild(_bg);
        this.addEventListener(TouchEvent.TOUCH, onTouch);
    }

    public function addButtonTexture(w:int, h:int, type:int, setP:Boolean = false):void {
        var t:Sprite = new WOSimpleButtonTexture(w, h, type);
        _bg.addChild(t);
        if (setP) setPivots();
    }

    public function addSensBlock(sb:SensibleBlock, x:int, y:int):void {
        _sensBlocks.push(sb);
        sb.x = x;
        sb.y = y;
        this.addChild(sb);
    }

    public function addTextField(w:int, h:int, x:int = 0, y:int = 0, t:String=''):void {
        _txt = new CTextField(w, h, t);
        _txt.x = x;
        _txt.y = y;
        this.addChild(_txt);
    }

    public function setTextFormat(font:String, size:int, color:int, stroke:int):void { if (_txt) _txt.setFormat(font,size,color,stroke); }
    public function get txt():CTextField { return _txt; }
    public function set text(st:String):void { if (_txt) _txt.text = st; }
    public function set startClickCallback(f:Function):void { _startClickCallback = f; }
    public function set clickCallback(f:Function):void { _clickCallback = f; }
    public function set hoverCallback(f:Function):void { _hoverCallback = f; }
    public function set outCallback(f:Function):void { _outCallback = f; }
    public function set onMovedCallback(f:Function):void { _onMovedCallback = f; }
    public function createHitArea(name:String):void { _hitArea = g.managerHitArea.getHitArea(this, name); }
    public function setPivots():void {  this.alignPivot(); }
    public function addDisplayObject(d:DisplayObject):void { _bg.addChild(d); }

    private function onTouch(te:TouchEvent):void {
        te.stopPropagation();
        te.stopImmediatePropagation();
        if (_hitArea) {
            var localPos:Point = te.data[0].getLocation(this);
            if (_hitArea.isTouchablePoint(localPos.x, localPos.y)) _hitAreaState = 2; // state -> mouse is under visible point
                else _hitAreaState = 3; // state -> mouse is not under visible point
        } else {
            _hitAreaState = 1; //state -> don't have hitArea
        }

        if (te.getTouch(this, TouchPhase.MOVED)) {
            if (_onMovedCallback != null) {
                _onMovedCallback.apply(null, [te.touches[0].globalX, te.touches[0].globalY]);
            }
        } else if (te.getTouch(this, TouchPhase.BEGAN)) {
            if (_hitAreaState != 3) {
                te.stopImmediatePropagation();
                te.stopPropagation();
                onBeganClick_Filter();
                if (_startClickCallback != null) _startClickCallback.apply();
                Mouse.cursor = OwnMouse.CLICK_CURSOR;
            }
        } else if (te.getTouch(this, TouchPhase.ENDED)) {
            if (_hitAreaState != 3) {
                if (_clickCallback != null) {
                    te.stopImmediatePropagation();
                    te.stopPropagation();
                    onEndClick_Filter();
                    _clickCallback.apply();
                }
            }
        } else if (te.getTouch(this, TouchPhase.HOVER)) {
            if (_hitAreaState != 3) {
                te.stopImmediatePropagation();
                te.stopPropagation();
                Mouse.cursor = OwnMouse.HOVER_CURSOR;
                if (!_isHover && _hoverCallback != null) _hoverCallback.apply();
                onHover_Filter();
            } else {
                Mouse.cursor = OwnMouse.USUAL_CURSOR;
                onOut_Filter();
                if (!_isHover && _outCallback != null)  _outCallback.apply();
            }
        } else {
            if (_hitAreaState != 2) {
                Mouse.cursor = OwnMouse.USUAL_CURSOR;
                onOut_Filter();
                if (_outCallback != null) _outCallback.apply();
            }
        }
    }

    public function set colorBGFilter(c:ColorMatrixFilter):void {
        if (c) {
            _colorBGFilter = c;
            if (_bg.filter) _bg.filter = null;
            _bg.filter = c;
        } else {
            if (_colorBGFilter) {
                if (_bg.filter && _bg.filter == _colorBGFilter) _bg.filter = null;
                _colorBGFilter.dispose();
                _colorBGFilter = null;
            }
        }
    }

    public function set isTouchable(value:Boolean):void {
        this.touchable = value;
        if (value) {
            if(!this.hasEventListener(TouchEvent.TOUCH))
                this.addEventListener(TouchEvent.TOUCH, onTouch);
        } else {
            if(this.hasEventListener(TouchEvent.TOUCH))
                this.removeEventListener(TouchEvent.TOUCH, onTouch);
        }
    }

    public function set setEnabled(v:Boolean):void {
        this.isTouchable = v;
        setEnableFilter = v;
    }
    
    public function set setEnableFilter(v:Boolean):void {
        if (v) {
            if (this.filter) this.filter.dispose();
            this.filter = null;
            if (_colorBGFilter) _bg.filter = _colorBGFilter;
        } else {
            if (_bg.filter) _bg.filter = null;
            this.filter = ManagerFilters.getButtonDisableFilter();
        }
    }

    public function deleteIt():void {
        finishHoverAnimation();
        filter = null;
        if (_sensBlocks.length) {
            for (var i:int=0; i<_sensBlocks.length; i++) {
                this.removeChild(_sensBlocks[i]);
                (_sensBlocks[i] as SensibleBlock).deleteIt();
            }
            _sensBlocks.length = 0;
        }
        _hitArea = null;
        _bg.filter = null;
        if (this.hasEventListener(TouchEvent.TOUCH)) this.removeEventListener(TouchEvent.TOUCH, onTouch);
        _bg.dispose();
        _bg = null;
        dispose();
        _clickCallback = null;
        _hoverCallback = null;
        _outCallback = null;
        _onMovedCallback = null;
        _startClickCallback = null;
    }

    private function onBeganClick_Filter():void {
        if (_bg.filter) _bg.filter = null;
        _bg.filter = ManagerFilters.getButtonClickFilter();
        this.scaleX = this.scaleY = _scale*.95;
    }

    private function onEndClick_Filter():void {
        g.soundManager.playSound(SoundConst.ON_BUTTON_CLICK);
        if (_bg.filter) _bg.filter.dispose();
        _bg.filter = null;
        if (_colorBGFilter)  _bg.filter = _colorBGFilter;
        this.scaleX = this.scaleY = _scale;
    }

    private function onHover_Filter():void {
        if (_isHover) return;
        _isHover = true;
        if (_hoverImage) _hoverImage.visible = false;
        if (_bg.filter) _bg.filter = null;
        _bg.filter = ManagerFilters.getButtonHoverFilter();
        g.soundManager.playSound(SoundConst.ON_BUTTON_HOVER);
    }

    private function onOut_Filter():void {
        _isHover = false;
        this.scaleX = this.scaleY = _scale;
        if (_bg.filter) _bg.filter.dispose();
        _bg.filter = null;
        if (_colorBGFilter) _bg.filter = _colorBGFilter;
        if (_hoverImage) _hoverImage.visible = true;
    }

    public function releaseHoverAnimation():void {
        _isHoverAnimation = true;
        var fOut:Function = function():void {
            TweenMax.to(_hoverImage, .5, {alpha:0, onComplete:releaseHoverAnimation});
        };
        if (!_hoverImage) {
            _hoverImage = new Image(DrawToBitmap.getTextureFromStarlingDisplayObject(_bg));
            if (!_hoverImage) {
                _isHoverAnimation = false;
                return;
            }
            _hoverImage.filter = ManagerFilters.getHardButtonHoverFilter();
        }
        _hoverImage.scale = .995;
        if (!contains(_hoverImage)) addChildAt(_hoverImage, 1);
        TweenMax.killTweensOf(_hoverImage);
        _hoverImage.alpha = 0;
        TweenMax.to(_hoverImage, .5, {alpha:1, onComplete:fOut});
    }

    public function finishHoverAnimation():void {
        _isHoverAnimation = false;
        if (_hoverImage) {
            TweenMax.killTweensOf(_hoverImage);
            if (_hoverImage.filter) _hoverImage.filter.dispose();
            _hoverImage.filter = null;
            if (contains(_hoverImage)) removeChild(_hoverImage);
            _hoverImage.dispose();
            _hoverImage = null;
        }
    }

}
}
