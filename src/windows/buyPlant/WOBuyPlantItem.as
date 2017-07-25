/**
 * Created by user on 6/9/15.
 */
package windows.buyPlant {
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;

import data.StructureDataResource;

import manager.ManagerFilters;
import manager.Vars;

import media.SoundConst;

import quest.ManagerQuest;

import starling.display.Image;
import starling.text.TextField;
import starling.utils.Align;
import starling.utils.Color;

import utils.CTextField;
import utils.SimpleArrow;
import tutorial.TutorialAction;
import utils.CSprite;
import utils.MCScaler;
import windows.WindowsManager;

public class WOBuyPlantItem {
    public var source:CSprite;
    private var _bg:Image;
    private var _icon:Image;
    private var _dataPlant:StructureDataResource;
    private var _clickCallback:Function;
    private var _txtNumber:CTextField;
    private var _countPlants:int;
    private var _arrow:SimpleArrow;
    private var _defaultY:int;
    private var _maxAlpha:Number;
    private var _isOnHover:Boolean;

    private var g:Vars = Vars.getInstance();

    public function WOBuyPlantItem() {
        source = new CSprite();
        source.nameIt = 'woBuyPlantItem';
        _bg = new Image(g.allData.atlas['interfaceAtlas'].getTexture('production_window_k'));
        source.addChild(_bg);
        source.pivotX = source.width/2;
        source.pivotY = source.height;
        source.endClickCallback = onClick;
        source.hoverCallback = onHover;
        source.outCallback = onOut;
        _txtNumber = new CTextField(40,30,'');
        _txtNumber.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtNumber.alignH = Align.RIGHT;
        _txtNumber.x = 52;
        _txtNumber.y = 68;
        source.addChild(_txtNumber);
        _isOnHover = false;
        source.isTouchable = false;
        source.visible = false;
    }

    public function setCoordinates(_x:int, _y:int):void {
        _defaultY = _y;
        source.x = _x;
        source.y = _y;
    }
    
    public function fillData(ob:StructureDataResource, f:Function):void {
//        source.visible = true;
        _dataPlant = ob;
        if (!_dataPlant) {
            Cc.error('WOBuyPlantItem:: empty _dataPlant');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woBuyPlantItem');
            return;
        }
        _clickCallback = f;
        if (_dataPlant.blockByLevel == g.user.level + 1) {
            _maxAlpha = .5;
        } else if (_dataPlant.blockByLevel <= g.user.level) {
            _maxAlpha = 1;
        } else {
            _maxAlpha = 0;
            Cc.error("Warning woBuyPlantItem filldata:: _dataPlant.blockByLevel > g.user.level + 1");
        }
        fillIcon(_dataPlant.imageShop);
        _countPlants = g.userInventory.getCountResourceById(_dataPlant.id);
        if (_countPlants <= 0) _txtNumber.changeTextColor = ManagerFilters.ORANGE_COLOR;
        else _txtNumber.changeTextColor = Color.WHITE;
        if (_maxAlpha == 1) {
            _txtNumber.text = String(_countPlants);
            _txtNumber.visible = true;
        }
        else _txtNumber.visible = false;
        if (g.managerTutorial && g.managerTutorial.currentAction == TutorialAction.PLANT_RIDGE && g.managerTutorial.isTutorialResource(_dataPlant.id)) {
            addArrow();
        }
        if (g.managerQuest && g.managerQuest.activeTask && (g.managerQuest.activeTask.typeAction == ManagerQuest.RAW_PLANT || g.managerQuest.activeTask.typeAction == ManagerQuest.CRAFT_PLANT)
            && g.managerQuest.activeTask.resourceId == _dataPlant.id) addArrow(3);
    }

    private function fillIcon(s:String):void {
        if (_icon) {
            if (source) source.removeChild(_icon);
            _icon.dispose();
            _icon = null;
        }
        _icon = new Image(g.allData.atlas['resourceAtlas'].getTexture(s + '_icon'));
        if (!_icon) {
            Cc.error('WOItemFabrica fillIcon:: no such image: ' + s);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'woBuyPlantItem');
            return;
        }
        MCScaler.scale(_icon, 80, 80);
        _icon.x = _bg.width/2 - _icon.width/2;
        _icon.y = _bg.height/2 - _icon.height/2;
        source.addChildAt(_icon,1);
        if (g.user.fabricItemNotification.length > 0) {
            var arr:Array = g.user.fabricItemNotification;
            var im:Image;
            for (var i:int = 0; i < arr.length; i++){
                if (arr[i].id == _dataPlant.id) {
                    im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
                    im.x = _icon.width - im.width/2 + 3;
                    im.y = _icon.y -14;
                    source.addChild(im);
//                    g.user.fabricItemNotification.splice(i);
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

    public function showChangeAnimate(d:Number, ob:StructureDataResource, f:Function):void {
        if (_dataPlant) {
            TweenMax.to(source, .3, {scaleX:.9, scaleY:.9, alpha:0, y: _defaultY - 35, onComplete: onChangeAnimationComplete, delay: d, onCompleteParams: [0, ob, f]});
        } else {
            onChangeAnimationComplete(.3 + d, ob, f);
        }
    }

    private function onChangeAnimationComplete(d:Number, ob:StructureDataResource, f:Function):void {
        if (_dataPlant) {
            unfillIt();
            _dataPlant = null;
            source.alpha = 0;
        }
        if (ob) {
            fillData(ob, f);
            if (_maxAlpha > 0) {
                _maxAlpha = 1;
                source.scaleX = 0;
                source.scaleY = 0;
                source.y = _defaultY - 35;
                source.alpha = 0;
                source.isTouchable = true;
                source.visible = true;
            } else {
                source.isTouchable = false;
                source.visible = false;
            }
            if (_dataPlant.blockByLevel == g.user.level + 1) {
                _maxAlpha = .5;
            } else if (_dataPlant.blockByLevel <= g.user.level) {
                _maxAlpha = 1;
            } else {
                _maxAlpha = 0;
                Cc.error("Warning woBuyPlantItem filldata:: _dataPlant.blockByLevel > g.user.level + 1");
            }
            TweenMax.to(source, .3, {scaleX:1, scaleY:1, alpha:_maxAlpha, y: _defaultY, delay:d});
        } else {
            source.isTouchable = false;
            source.visible = false;
        }
    }

    private function unfillIt():void {
        removeArrow();
        if (_icon) {
            source.removeChild(_icon);
            _icon = null;
        }
        _countPlants = 0;
        _dataPlant = null;
        _clickCallback = null;
        source.filter = null;
        source.alpha = .5;
        _txtNumber.text = '';
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (!_dataPlant) return;
        if (_dataPlant.blockByLevel > g.user.level) return;
        if (g.managerTutorial.isTutorial && !g.managerTutorial.isTutorialResource(_dataPlant.id)) return;
        g.soundManager.playSound(SoundConst.ON_BUTTON_CLICK);
        source.filter = null;
        g.resourceHint.hideIt();
        g.fabricHint.hideIt();
        if (_clickCallback != null) {
            _clickCallback.apply(null, [_dataPlant]);
        }
        if (g.user.fabricItemNotification.length > 0) {
            var arr:Array = g.user.fabricItemNotification;
            for (var i:int = 0; i < arr.length; i++){
                if (arr[i].id == _dataPlant.id) {
                    g.user.fabricItemNotification.splice(i);
                }
            }
        }
    }

    private function onHover():void {
        if (!_dataPlant) return;
        if (_isOnHover) return;
        g.soundManager.playSound(SoundConst.ON_BUTTON_HOVER);
        source.filter = ManagerFilters.YELLOW_STROKE;
//        if (g.managerTutorial.isTutorial) return;
        _isOnHover = true;
        g.resourceHint.hideIt();
        g.resourceHint.showIt(_dataPlant.id, source.x, 48, source, true);
    }

    private function onOut():void {
        _isOnHover = false;
        source.filter = null;
        g.resourceHint.hideIt();
    }

    private function addArrow(t:Number=0):void {
        removeArrow();
        _arrow = new SimpleArrow(SimpleArrow.POSITION_TOP, source);
        _arrow.animateAtPosition(source.width/2, 0);
        _arrow.scaleIt(.5);
        if (t > 0) _arrow.activateTimer(t, removeArrow);
    }

    private function removeArrow():void {
        if (_arrow) {
            _arrow.deleteIt();
            _arrow = null;
        }
    }

    public function deleteIt():void {
        g.resourceHint.hideIt();
        g.fabricHint.hideIt();
        removeArrow();
        if (_txtNumber) {
            source.removeChild(_txtNumber);
            _txtNumber.deleteIt();
            _txtNumber = null;
        }
        _dataPlant = null;
        _clickCallback = null;
        source.deleteIt();
        source = null;
    }
}
}
