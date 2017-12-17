/**
 * Created by user on 7/22/15.
 */
package build.orders {
import build.WorldObject;
import com.junkbyte.console.Cc;

import dragonBones.Bone;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;

import media.SoundConst;
import mouse.ToolsModifier;

import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;

import tutorial.helpers.HelperReason;
import tutorial.miniScenes.ManagerMiniScenes;

import windows.WindowsManager;

public class Order extends WorldObject{
    private var _isOnHover:Boolean;
//    private var _smallHero:SmallHeroAnimation;
    private var _boomOpen:Image;
    private var _topOpen:Image;
    private var _hintCheck:Bone;


    public function Order (data:Object) {
        super (data);
        _isOnHover = false;
        if (!data) {
            Cc.error('no data for Order');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Order');
            return;
        }
        createAnimatedBuild(onCreateBuild);
        _source.releaseContDrag = true;
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndStopByFrame('idle');
        _source.hoverCallback = onHover;
        if (!g.isAway) _source.endClickCallback = onClick;
        _source.outCallback = onOut;
        _hitArea = g.managerHitArea.getHitArea(_source, 'order_area', ManagerHitArea.TYPE_LOADED);
        _source.registerHitArea(_hitArea);
        if (!_hintCheck) _hintCheck = _armature.getBone('top');
        var b:Bone;
        b = _armature.getBone('top');
        if (b != null) b.visible = false;
        if (g.user.isOpenOrder) _stateBuild = STATE_ACTIVE;
        else _stateBuild = STATE_UNACTIVE;

        if (_stateBuild == STATE_UNACTIVE) {
            _armature.animation.gotoAndPlayByFrame('close');
        } else {
            _stateBuild = STATE_ACTIVE;
            _armature.addEventListener(EventObject.COMPLETE, makeAnimation);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, makeAnimation);
            makeAnimation();
        }
    }
    
    public function animateSmallHero(v:Boolean):void {
        if (!_hintCheck)  _hintCheck = _armature.getBone('top');
        if (!v) {
            var b:Bone;
            b = _armature.getBone('top');
            if (b != null) b.visible = false;
        } else {
            _hintCheck.visible = true;
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.isAway) {
            g.hint.showIt(_dataBuild.name);
            return;
        }
        if (g.tuts.isTuts && !g.tuts.isTutsBuilding(this)) return;
        if (!_isOnHover) {
            _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            if (_stateBuild == STATE_ACTIVE) {
                var fEndOver:Function = function (e:Event = null):void {
                    _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                    _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                    _armature.addEventListener(EventObject.COMPLETE, makeAnimation);
                    _armature.addEventListener(EventObject.LOOP_COMPLETE, makeAnimation);
                    makeAnimation();
                };
                _armature.removeEventListener(EventObject.COMPLETE, makeAnimation);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, makeAnimation);
                _armature.addEventListener(EventObject.COMPLETE, fEndOver);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('over');
            }
            g.hint.showIt(_dataBuild.name);
        }
        _isOnHover = true;
    }

    override public function onOut():void {
        super.onOut();
        if (g.isAway){
            g.hint.hideIt();
            return;
        }
        g.hint.hideIt();
        if (g.tuts.isTuts && !g.tuts.isTutsBuilding(this)) return;
        if (_source.filter) _source.filter.dispose();
        _source.filter = null;
        _isOnHover = false;
    }

    private function onClick():void {
        var p:Point;
        var myPattern:RegExp = /count/;
        var str:String =  String(g.managerLanguage.allTexts[342]);
        if (_stateBuild == STATE_UNACTIVE) {
            if (g.user.level < int(_dataBuild.blockByLevel)) {
                g.soundManager.playSound(SoundConst.EMPTY_CLICK);
                p = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,String(String(str.replace(myPattern, String(_dataBuild.blockByLevel)))));
            } else {
                _stateBuild = STATE_ACTIVE;
                if (_topOpen) _topOpen.visible = true;
                if (_boomOpen) _boomOpen.visible = true;
                _armature.addEventListener(EventObject.COMPLETE, onOpenOrder);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, onOpenOrder);
                _armature.animation.gotoAndPlayByFrame('top_l');
                hideArrow();
                g.server.openUserOrder(null);
                g.user.isOpenOrder = true;
            }
            return;
        }
        if (g.tuts.isTuts) {
            if (g.tuts.isTutsBuilding(this)) {
                g.tuts.checkTutsCallback();
            } else return;
        }
        if (g.managerCutScenes.isCutScene) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                if (g.isActiveMapEditor)
                    g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) return;
            if (g.user.level < _dataBuild.blockByLevel) {
                g.soundManager.playSound(SoundConst.EMPTY_CLICK);
                p = new Point(_source.x, _source.y - 100);
                p = _source.parent.localToGlobal(p);
                new FlyMessage(p,String(str.replace(myPattern, String(_dataBuild.blockByLevel))));
                return;
            }
            if (g.miniScenes.isMiniScene && g.miniScenes.isReason(ManagerMiniScenes.OPEN_ORDER) && g.user.level == _dataBuild.blockByLevel) return;
            onOut();
            if (g.managerHelpers && g.managerHelpers.isActiveHelper && g.managerHelpers.activeReason.reason == HelperReason.REASON_ORDER) {
                g.lateAction.releaseOnTimer(.7, showBtnCellArrow);
            }
            hideArrow();
            g.windowsManager.openWindow(WindowsManager.WO_ORDERS, null);
            if (g.miniScenes.isMiniScene && g.miniScenes.isMiniSceneBuilding(this)) g.miniScenes.checkMiniSceneCallback();
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType');
        }
    }

    private function onOpenOrder(e:Event=null):void {
        if (_topOpen) _topOpen.visible = false;
        if (_boomOpen) _boomOpen.visible = false;
        if (g.miniScenes.isMiniScene && g.user.level == _dataBuild.blockByLevel) {
            g.miniScenes.checkMiniSceneCallback();
        } else {
            g.managerOrder.checkOrders();
        }
        _armature.removeEventListener(EventObject.COMPLETE, onOpenOrder);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, onOpenOrder);
        _armature.addEventListener(EventObject.COMPLETE, makeAnimation);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, makeAnimation);
        makeAnimation();
    }
    
    private function showBtnCellArrow():void {
//        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_ORDERS) {
//            (g.windowsManager.currentWindow as WOOrderNew).showBtnSellArrow();
//        }
    }

    override public function clearIt():void {
        onOut();
        _topOpen = null;
        _boomOpen = null;
        _source.touchable = false;
        _armature.removeEventListener(EventObject.COMPLETE, makeAnimation);
        _armature.removeEventListener(EventObject.LOOP_COMPLETE, makeAnimation);
        WorldClock.clock.remove(_armature);
//        _armature.dispose();
        super.clearIt();
    }

    private function makeAnimation(e:Event=null):void {
        var k:Number = Math.random();
        if (k < .9) _armature.animation.gotoAndPlayByFrame('idle');
        else if (k < .95) _armature.animation.gotoAndPlayByFrame('idle1');
        else _armature.animation.gotoAndPlayByFrame('idle2');
    }
}
}
