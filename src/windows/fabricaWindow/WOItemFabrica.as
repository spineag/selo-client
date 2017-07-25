/**
 * Created by user on 6/9/15.
 */
package windows.fabricaWindow {
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;

import data.StructureDataRecipe;

import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;

import media.SoundConst;

import quest.ManagerQuest;

import starling.display.Image;
import utils.SimpleArrow;
import tutorial.TutorialAction;
import utils.CSprite;
import utils.MCScaler;
import windows.WindowsManager;

public class WOItemFabrica {
    public var source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _dataRecipe:Object;
    private var _clickCallback:Function;
    private var _arrow:SimpleArrow;
    private var _defaultY:int;
    private var _maxAlpha:Number;
    private var _isOnHover:Boolean;
    private var g:Vars = Vars.getInstance();

    public function WOItemFabrica() {
        source = new CSprite();
        source.nameIt = 'woItemFabrica';
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_k'));
        source.addChild(_bg);
        source.pivotX = source.width/2;
        source.pivotY = source.height;
        source.endClickCallback = onClick;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _isOnHover = false;
        source.isTouchable = false;
        source.visible = false;
    }

    public function setCoordinates(_x:int, _y:int):void {
        _defaultY = _y;
        source.x = _x;
        source.y = _y;
    }

    public function fillData(ob:Object, f:Function):void {
        _dataRecipe = ob;
        if (!_dataRecipe || !g.allData.getResourceById(_dataRecipe.idResource)) {
            Cc.error('WOItemFabrica:: empty _dataRecipe or g.dataResource.objectResources[_dataRecipe.idResource] == null');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woItemFabrica');
            return;
        }
        _clickCallback = f;
        if (_dataRecipe.blockByLevel == g.user.level + 1) {
            _maxAlpha = .5;
        } else if (_dataRecipe.blockByLevel <= g.user.level) {
            _maxAlpha = 1;
        } else {
            _maxAlpha = 0;
            Cc.error("Warning woItemFabrica filldata:: _dataRecipe.blockByLevel > g.user.level + 1");
        }
        fillIcon(g.allData.getResourceById(_dataRecipe.idResource).imageShop);
        if (g.managerTutorial && g.managerTutorial.currentAction == TutorialAction.RAW_RECIPE && g.managerTutorial.isTutorialResource(_dataRecipe.id)) {
            addArrow();
        }
        if (g.managerQuest && g.managerQuest.activeTask && (g.managerQuest.activeTask.typeAction == ManagerQuest.RAW_PRODUCT || g.managerQuest.activeTask.typeAction == ManagerQuest.CRAFT_PRODUCT )
                && g.managerQuest.activeTask.resourceId == _dataRecipe.idResource) addArrow(3);
    }

    public function get dataRecipe ():Object {
        return _dataRecipe;
    }

    private function fillIcon(s:String):void {
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(s));
        if (!_icon) {
            Cc.error('WOItemFabrica fillIcon:: no such image: ' + s);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woItemFabrica');
            return;
        }
        MCScaler.scale(_icon, 80, 80);
        _icon.x = _bg.width/2 - _icon.width/2;
        _icon.y = _bg.height/2 - _icon.height/2;
        source.addChild(_icon);
        if (g.user.fabricItemNotification.length > 0) {
            var arr:Array = g.user.fabricItemNotification;
            var im:Image;
            for (var i:int = 0; i < arr.length; i++){
                if (arr[i].id == _dataRecipe.idResource) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
                    im.x = _icon.width - im.width/2 + 3;
                    im.y = _icon.y -14;
                    source.addChild(im);
                    g.user.fabricItemNotification.splice(i);
                }
            }
        }
    }

    public function showAnimateIt(delay:Number):void {
        source.y = _defaultY - 35;
        source.scaleX = source.scaleY = .9;
        source.alpha = 0;
        if (_maxAlpha > 0) {
            source.isTouchable = true;
            source.visible = true;
        } else {
            source.isTouchable = false;
            source.visible = false;
        }
        TweenMax.to(source, .3, {scaleX:1, scaleY:1, alpha:_maxAlpha, y: _defaultY, delay:delay});
    }

    public function showChangeAnimate(d:Number, ob:Object, f:Function):void {
        if (_dataRecipe) {
            TweenMax.to(source, .3, {scaleX:.9, scaleY:.9, alpha:0, y: _defaultY - 35, onComplete: onChangeAnimationComplete, delay: d, onCompleteParams: [0, ob, f]});
        } else {
            onChangeAnimationComplete(.3 + d, ob, f);
        }
    }

    private function onChangeAnimationComplete(d:Number, ob:Object, f:Function):void {
        if (_dataRecipe) {
            unfillIt();
            _dataRecipe = null;
            source.alpha = 0;
        }
        if (ob) {
            fillData(ob, f);
            if (_maxAlpha > 0) {
                source.isTouchable = true;
                source.visible = true;
            } else {
                source.isTouchable = false;
                source.visible = false;
            }
            TweenMax.to(source, .3, {scaleX:1, scaleY:1, alpha:_maxAlpha, y: _defaultY, delay:d});
        } else {
            source.isTouchable = false;
            source.visible = false;
        }
    }

    public function unfillIt():void {
        removeArrow();
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _dataRecipe = null;
        _clickCallback = null;
        source.alpha = .5;
    }

    private function onClick():void {
        if (g.managerTutorial.isTutorial && g.managerTutorial.currentAction != TutorialAction.RAW_RECIPE) return;
        if (!_dataRecipe) return;
        if (_dataRecipe.blockByLevel > g.user.level) return;

        g.soundManager.playSound(SoundConst.ON_BUTTON_CLICK);
        source.filter = null;
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_dataRecipe]);
        }
        g.resourceHint.hideIt();
        g.fabricHint.hideIt();
        if (g.managerTutorial && g.managerTutorial.currentAction == TutorialAction.RAW_RECIPE && g.managerTutorial.isTutorialResource(_dataRecipe.id)) {
            removeArrow();
            g.managerTutorial.currentActionNone();
//            g.managerTutorial.checkTutorialCallback();
        }
    }

    private function onHover():void {
        if (!_dataRecipe) return;
        if (_isOnHover) return;
        _isOnHover = true;
        g.soundManager.playSound(SoundConst.ON_BUTTON_HOVER);
        source.filter = ManagerFilters.YELLOW_STROKE;
//        if (g.managerTutorial.isTutorial) return;
        var point:Point = new Point(0, 0);
        var pointGlobal:Point = source.localToGlobal(point);
        if (_dataRecipe.blockByLevel > g.user.level) g.resourceHint.showIt(_dataRecipe.id,source.x,source.y,source,false,true);
            else g.fabricHint.showIt(_dataRecipe,pointGlobal.x, pointGlobal.y);
    }

    private function onOut():void {
        source.filter = null;
        if (!_dataRecipe) return;
        g.fabricHint.hideIt();
        g.resourceHint.hideIt();
        _isOnHover = false;
    }

    private function removeArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function addArrowIfPossibleToRaw():void {
        if (!_dataRecipe) return;
        removeArrow();
        if (_dataRecipe.blockByLevel > g.user.level) return;
        for (var l:int = 0; l < _dataRecipe.ingridientsId.length; l++) {
            if (g.userInventory.getCountResourceById(int(_dataRecipe.ingridientsId[l])) < int(_dataRecipe.ingridientsCount[l])) {
                break;
            }
        }
        addArrow(3);
    }

    private function addArrow(t:Number=0):void {
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, source);
        _arrow.animateAtPosition(source.width/2, 0);
        _arrow.scaleIt(.5);
        if (t>0) _arrow.activateTimer(t, removeArrow);
    }

    public function deleteIt():void {
        g.resourceHint.hideIt();
        g.fabricHint.hideIt();
        removeArrow();
        source.deleteIt();
        source = null;
    }
}
}
