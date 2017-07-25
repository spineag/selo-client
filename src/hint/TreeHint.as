/**
 * Created by user on 7/20/15.
 */
package hint {
import build.WorldObject;
import build.WorldObject;

import com.greensock.TweenMax;

import com.greensock.easing.Linear;

import com.junkbyte.console.Cc;

import flash.geom.Point;

import manager.ManagerFilters;

import manager.Vars;

import starling.animation.Tween;

import starling.core.Starling;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import ui.xpPanel.XPStar;

import utils.CButton;

import utils.CSprite;
import utils.CTextField;

import utils.MCScaler;

import windows.WOComponents.HintBackground;
import windows.WindowsManager;

public class TreeHint {
    private var _source:CSprite;
    private var _contDelete:CButton;
    private var _contWatering:CButton;
    private var _isOnHover:Boolean;
    private var _isShowed:Boolean;
    private var _imageCircle:Image;
    private var _imageBgItem:Image;
    private var _imageBgItemHelp:Image;
    private var _imageItem:Image;
    private var _imageHelp:Image;
    private var _txtCount:CTextField;
    private var _txtName:CTextField;
    private var _worldObject:WorldObject;
    private var _data:Object;
    private var _deleteCallback:Function;
    private var _wateringCallback:Function;
    private var _quad:Quad;
    private var _bg:HintBackground;
    private var _onOutCallback:Function;
    private var _closeTime:Number;
    private var g:Vars = Vars.getInstance();

    public function TreeHint() {
        _source = new CSprite();
        _source.nameIt = 'treeHint';
        _contDelete = new CButton();
        _contWatering = new CButton();
        _isShowed = false;
        _isOnHover = false;
        _bg = new HintBackground(176, 104, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
        _source.addChild(_bg);

        _imageHelp = new Image(g.allData.atlas['interfaceAtlas'].getTexture("watering_can"));
        _imageHelp.width = _imageHelp.height = 40;
        _imageHelp.x = -60;
        _imageHelp.y = -90;
        _imageBgItem = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_blue_d'));
        _imageBgItem.y = -100;
        _imageBgItemHelp = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_blue_d'));
        _imageBgItemHelp.x = -75;
        _imageBgItemHelp.y = -100;
        _imageCircle = new Image(g.allData.atlas['interfaceAtlas'].getTexture("cursor_number_circle"));
        _imageCircle.x = 45;
        _imageCircle.y = -110;

        _txtCount = new CTextField(50,50,"");
        _txtCount.setFormat(CTextField.BOLD18, 16, Color.WHITE);
        _txtCount.x = 38;
        _txtCount.y = -119;
        _txtName = new CTextField(200,50,"");
        _txtName.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtName.x = -100;
        _txtName.y = -140;

        _contDelete.addDisplayObject(_imageBgItem);
        _contWatering.addDisplayObject(_imageBgItemHelp);
        _contWatering.addChild(_imageHelp);
        _source.addChild(_contWatering);
        _source.addChild(_contDelete);
        _source.addChild(_imageCircle);
        _source.addChild(_txtName);

        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _contDelete.clickCallback = onClickDelete;
        _contDelete.hoverCallback = onHoverDelete;
        _contDelete.outCallback = onOutDelete;
        _contWatering.clickCallback = onClickWatering;
        _contWatering.hoverCallback = onHoverWatering;
        _contWatering.outCallback = onOutWatering;
    }

    public function showIt(height:int,data:Object, x:int, y:int, name:String, worldobject:WorldObject, out:Function):void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (!data || !worldobject) {
            Cc.error('TreeHint show it:: empty data or worldObject');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'treeHint');
            return;
        }
        if (!g.allData.getResourceById(data.removeByResourceId)) {
            Cc.error('TreeHint show it:: g.dataResource.objectResources[data.removeByResourceId] = null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'treeHint');
            return;
        }
        if (_isShowed) return;
        _isShowed = true;
        _onOutCallback = out;
        _quad = new Quad(int(_bg.width), int(_bg.height + height/2 * g.currentGameScale), Color.WHITE);
        _quad.alpha = 0;
        _quad.x = -int(_bg.width/2);
        _quad.y = -_bg.height;
        _source.addChildAt(_quad,0);

        if ( data.removeByResourceId == 124) {
            _txtName.text = String(g.managerLanguage.allTexts[614]);
        } else {
            _txtName.text = String(g.managerLanguage.allTexts[615]);
        }
        _worldObject = worldobject;
        _data = data;
        _source.x = x;
        _source.y = y;
        _source.scaleX = _source.scaleY = 0;
        var tween:Tween = new Tween(_source, 0.1);
        tween.scaleTo(1);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);

        };
        g.starling.juggler.add(tween);
        if (_imageItem) {
            _contDelete.removeChild(_imageItem);
            _imageItem = null;
        }
        _imageItem = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(data.removeByResourceId).imageShop));
        if (!_imageItem) {
            Cc.error('TreeHint showIt:: no such image: ' + g.allData.getResourceById(data.removeByResourceId).imageShop);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'treeHint');
            return;
        }
        MCScaler.scale(_imageItem,55,55);
        _imageItem.y = -95;
        _imageItem.x = 5;
        _txtCount.text = String(g.userInventory.getCountResourceById(data.removeByResourceId));
        _contDelete.addChild(_imageItem);
        _source.addChild(_txtCount);
        g.cont.hintCont.addChild(_source);

        if (_source.y < _source.height + 50 || _source.x < _source.width/2 + 50 || _source.x > g.managerResize.stageWidth -_source.width/2 - 50) {
            var dY:int = 0;
            if (_source.y < _source.height + 50)
                dY = _source.height + 50 - _source.y;
            var dX:int = 0;
            if (_source.x < _source.width/2 + 50) {
                dX = _source.width/2 + 50 - _source.x;
            } else if (_source.x > g.managerResize.stageWidth -_source.width/2 - 50) {
                dX = g.managerResize.stageWidth -_source.width/2 - 50 - _source.x;
            }
            g.cont.deltaMoveGameCont(dX, dY, .5);
            new TweenMax(_source, .5, {x:int(_source.x + dX), y:int(_source.y + dY), ease:Linear.easeOut});
        }
    }

    public function hideIt():void {
        if (_isOnHover) return;
        _isShowed = false;
        _closeTime = 1.5;
        g.gameDispatcher.addToTimer(closeTimer);
    }

    public function managerHide(callback:Function = null):void {
//        if (_isShowed) {
            var tween:Tween = new Tween(_source, 0.1);
            tween.scaleTo(0);
            tween.onComplete = function ():void {
                g.starling.juggler.remove(tween);
                _source.removeChild(_quad);
                _isShowed = false;
                if (g.cont.hintCont.contains(_source)) {
                    g.cont.hintCont.removeChild(_source);
                    _contDelete.removeChild(_imageItem);
                    _imageItem = null;
                }
                if (callback != null) {
                    callback.apply();
                    callback = null;
                }
            };
            g.starling.juggler.add(tween);
            g.gameDispatcher.removeFromTimer(closeTimer);
//        }
    }

    private function closeTimer():void {
        _closeTime--;
        if (_closeTime <= 0) {
            if (!_isOnHover) {
                var tween:Tween = new Tween(_source, 0.1);
                tween.scaleTo(0);
                tween.onComplete = function ():void {
                    g.starling.juggler.remove(tween);
                    _source.removeChild(_quad);
                    if (g.cont.hintCont.contains(_source)) {
                        g.cont.hintCont.removeChild(_source);
                        _contDelete.removeChild(_imageItem);
                        _imageItem = null;
                    }
                };
                g.starling.juggler.add(tween);
            }
            g.gameDispatcher.removeFromTimer(closeTimer);
        }
    }

    private function onHover():void {
        _isOnHover = true;
    }

    public function get isShow():Boolean {
        return _isShowed;
    }

    private function onOut():void {
        _isOnHover = false;
        hideIt();
    }

    private function onClickDelete():void {
        managerHide();
        if (g.userInventory.getCountResourceById(_data.removeByResourceId) <= 0){
            var ob:Object = {};
            ob.data = g.allData.getResourceById(_data.removeByResourceId);
            ob.count = 1;
            g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClickDelete, 'menu', ob);
        } else {
            new XPStar(_source.x,_source.y,8);
            g.userInventory.addResource(_data.removeByResourceId, -1);
            if (_deleteCallback != null) {
                _deleteCallback.apply();
                _deleteCallback = null;
            }
            _wateringCallback = null;
        }

    }

    private function onClickWatering():void {
        managerHide();
        if (_wateringCallback != null) {
            _wateringCallback.apply();
            _wateringCallback = null;
        }
        _deleteCallback = null;
    }

    public function set onDelete(f:Function):void {
        _deleteCallback = f;
    }

    public function set onWatering(f:Function):void {
        _wateringCallback = f;
    }

    private function onHoverDelete():void {
        g.hint.showIt(String(g.managerLanguage.allTexts[616]));
    }

    private function onOutDelete():void {
        g.hint.hideIt();
    }

    private function onHoverWatering():void {
        g.hint.showIt(String(g.managerLanguage.allTexts[617]));
    }
    private function onOutWatering():void {
        g.hint.hideIt();
    }
}
}
