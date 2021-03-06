/**
 * Created by user on 6/11/15.
 */
package build.wild {
import build.WorldObject;
import build.lockedLand.LockedLand;
import com.greensock.TweenMax;
import com.junkbyte.console.Cc;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;
import mouse.ToolsModifier;
import quest.ManagerQuest;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import tutorial.TutsAction;
import windows.WindowsManager;

public class Wild extends WorldObject{
    private var _isOnHover:Boolean;
    private var _curLockedLand:LockedLand;
    private var _delete:Boolean;
    private var _countTimer:int;

    public function Wild(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('Wild:: no data');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Wild');
            return;
        }
        createBuildWild();
        _source.releaseContDrag = true;
        _isOnHover = false;
        _delete = false;
    }

    private function createBuildWild():void {
        var im:Image;
        if (_build) {
            if (_source.contains(_build)) _source.removeChild(_build);
            while (_build.numChildren) _build.removeChildAt(0);
        }
        im = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image));
        im.x = _dataBuild.innerX;
        im.y = _dataBuild.innerY;

        if (!im) {
            Cc.error('Wild:: no such image: ' + _dataBuild.image + ' for ' + _dataBuild.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject:: no such image');
            return;
        }
        _build.addChild(im);
        _rect = _build.getBounds(_build);
        _source.addChild(_build);
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
            _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.image);
            _source.registerHitArea(_hitArea);
        }
    }

    public function setLockedLand(l:LockedLand):void { _curLockedLand = l; }
    public function removeLockedLand():void { _curLockedLand = null; }
    public function get isAtLockedLand():Boolean {
        if (_curLockedLand) return true;
            else return false;
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts && !g.tuts.isTutsBuilding(this)) return;
        if (_curLockedLand && !g.isActiveMapEditor) return;
        if (_delete) return;
        if(_isOnHover) return;
        _source.filter = ManagerFilters.BUILD_STROKE;
        _isOnHover = true;
    }

    override public function onOut():void {
        super.onOut();
        if (g.tuts.isTuts && !g.tuts.isTutsBuilding(this)) return;
        if (_delete) return;
        _isOnHover = false;
//            if (!_isOnHover) g.wildHint.hideIt();
        if (_source) {
            if (_source.filter) _source.filter.dispose();
            _source.filter = null;
        }
    }

    private function onClick():void {
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts) {
            if (g.tuts.action != TutsAction.REMOVE_WILD) return;
            if (!g.tuts.isTutsBuilding(this)) return;
        }
        if (_delete) return;
        if (g.selectedBuild) {
            if (g.selectedBuild == this && g.isActiveMapEditor) {
                g.toolsModifier.onTouchEnded();
                onOut();
            }
            return;
        }
        if (_curLockedLand && !g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.isActiveMapEditor) {
                if (_curLockedLand) {
                    _curLockedLand.activateOnMapEditor(this);
                    _curLockedLand = null;
                }
                onOut();
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            if (g.isActiveMapEditor) {
                if (_curLockedLand) {
                    _curLockedLand.activateOnMapEditor(this);
                    _curLockedLand = null;
                }
                onOut();
                g.server.ME_removeWild(_dbBuildingId, null);
                g.townArea.deleteBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            if (g.isActiveMapEditor) {
                releaseFlip();
                g.server.ME_flipWild(_dbBuildingId, int(_dataBuild.isFlip), null);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (g.isAway) return;
            if (_source.wasGameContMoved) {
                onOut();
                return;
            }
            if (g.timerHint.isShow) {  g.timerHint.managerHide(callbackClose); return;
            } else if (g.wildHint.isShow){ g.wildHint.managerHide(callbackClose); return;
            } else if (g.treeHint.isShow) {  g.treeHint.managerHide(callbackClose); return;  }
//            if (_isOnHover)  {
                onOut();
                g.wildHint.onDelete = wildDelete;
                var newX:int;
                var newY:int;
                if(_dataBuild.id == 30) { // старое бревно1
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 12) * g.currentGameScale;
                }else if( _dataBuild.id == 31){ //  старое бревно2
                    if (dataBuild.isFlip) {
                        newX = g.cont.gameContX + (_source.x - _source.width/4) * g.currentGameScale;
                        newY = g.cont.gameContY + (_source.y - _source.height / 12) * g.currentGameScale;
                    } else {
                        newX = g.cont.gameContX + (_source.x + _source.width / 3) * g.currentGameScale;
                        newY = g.cont.gameContY + (_source.y - _source.height / 12) * g.currentGameScale;
                    }
                }else if( _dataBuild.id == 32){ //ель
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 1.9) * g.currentGameScale;
                }else if( _dataBuild.id == 33){ //ёлочка
                    newX = g.cont.gameContX + (_source.x + _source.width/12) * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 2) * g.currentGameScale;
                }else if( _dataBuild.id == 34){ // большой дуб
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 1.5) * g.currentGameScale;
                }else if( _dataBuild.id == 35){ // дубок
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 1.5) * g.currentGameScale;
                }else if( _dataBuild.id == 56){ // пень
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 3) * g.currentGameScale;
                }else if( _dataBuild.id == 57){ // болотце
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 13) * g.currentGameScale;
                }else if( _dataBuild.id == 58){ // тополь
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 1.3) * g.currentGameScale;
                }else if( _dataBuild.id == 59){ // большой камень
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 8) * g.currentGameScale;
                }else if( _dataBuild.id == 60){ // булыжник
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 8) * g.currentGameScale;
                }else if( _dataBuild.id == 61){ // маленький камень
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 8) * g.currentGameScale;
                }else if( _dataBuild.id == 62){ // маленький камень
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 8) * g.currentGameScale;
                }else if( _dataBuild.id == 326){ //королевский пень
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 13) * g.currentGameScale;
                }else if( _dataBuild.id == 327){ //дерево желтое
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 1.8) * g.currentGameScale;
                }else if( _dataBuild.id == 328){ //корень большой
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 1.5) * g.currentGameScale;
                }else if( _dataBuild.id == 329){ //дерево большой
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 1.4) * g.currentGameScale;
                }else if( _dataBuild.id == 330){ //дерево большой
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 1.5) * g.currentGameScale;
                }else if( _dataBuild.id == 331){ //дерево большой
                    newX = g.cont.gameContX + (_source.x + _source.width/12) * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 1.6) * g.currentGameScale;
                }else if( _dataBuild.id == 332){ //дерево большой
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 1.5) * g.currentGameScale;
                }else if( _dataBuild.id == 333){ //дерево большой
                    newX = g.cont.gameContX + _source.x * g.currentGameScale;
                    newY = g.cont.gameContY + (_source.y - _source.height / 2) * g.currentGameScale;
                }
                g.wildHint.showIt(_source.height,newX, newY, _dataBuild.removeByResourceId,_dataBuild.name,onOut);
            if (g.tuts.isTuts && g.tuts.action == TutsAction.REMOVE_WILD) {
                g.wildHint.addArrow();
                g.tuts.checkTutsCallback();
            }
//            }
        } else {
            Cc.error('Wild:: unknown g.toolsModifier.modifierType')
        }
    }

    private function callbackClose():void {
        onOut();
        g.wildHint.onDelete = wildDelete;
        var newX:int;
        var newY:int;
        if(_dataBuild.id == 30) { // старое бревно1
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 12) * g.currentGameScale;
        }else if( _dataBuild.id == 31){ //  старое бревно2
            if (dataBuild.isFlip) {
                newX = g.cont.gameContX + (_source.x - _source.width/4) * g.currentGameScale;
                newY = g.cont.gameContY + (_source.y - _source.height / 12) * g.currentGameScale;
            } else {
                newX = g.cont.gameContX + (_source.x + _source.width / 3) * g.currentGameScale;
                newY = g.cont.gameContY + (_source.y - _source.height / 12) * g.currentGameScale;
            }
        }else if( _dataBuild.id == 32){ //ель
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 1.9) * g.currentGameScale;
        }else if( _dataBuild.id == 33){ //ёлочка
            newX = g.cont.gameContX + (_source.x + _source.width/12) * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 2) * g.currentGameScale;
        }else if( _dataBuild.id == 34){ // большой дуб
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 1.5) * g.currentGameScale;
        }else if( _dataBuild.id == 35){ // дубок
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 1.5) * g.currentGameScale;
        }else if( _dataBuild.id == 56){ // пень
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 3) * g.currentGameScale;
        }else if( _dataBuild.id == 57){ // болотце
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 13) * g.currentGameScale;
        }else if( _dataBuild.id == 58){ // тополь
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 1.3) * g.currentGameScale;
        }else if( _dataBuild.id == 59){ // большой камень
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 8) * g.currentGameScale;
        }else if( _dataBuild.id == 60){ // булыжник
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 8) * g.currentGameScale;
        }else if( _dataBuild.id == 61){ // маленький камень
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 8) * g.currentGameScale;
        }else if( _dataBuild.id == 62){ // маленький камень
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 8) * g.currentGameScale;
        }else if( _dataBuild.id == 326){ //королевский пень
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 13) * g.currentGameScale;
        }else if( _dataBuild.id == 327){ //королевский пень
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 1.8) * g.currentGameScale;
        }else if( _dataBuild.id == 328){ //корень большой
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 1.5) * g.currentGameScale;
        }else if( _dataBuild.id == 329){ //дерево большой
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 1.4) * g.currentGameScale;
        }else if( _dataBuild.id == 330){ //дерево большой
            newX = g.cont.gameContX + _source.x * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 1.5) * g.currentGameScale;
        }else if( _dataBuild.id == 331){ //дерево большой
            newX = g.cont.gameContX + (_source.x + _source.width/12) * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 1.6) * g.currentGameScale;
        }else if( _dataBuild.id == 332){ //дерево большой
            newX = g.cont.gameContX + _source.x  * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 2) * g.currentGameScale;
        }else if( _dataBuild.id == 333){ //дерево большой
            newX = g.cont.gameContX + _source.x  * g.currentGameScale;
            newY = g.cont.gameContY + (_source.y - _source.height / 2) * g.currentGameScale;
        }
        g.wildHint.showIt(_source.height,newX, newY, _dataBuild.removeByResourceId,_dataBuild.name,onOut);
    }

    private function wildDelete():void {
        _source.filter = null;
        for (var i:int=0; i< g.user.userDataCity.objects.length; i++) {
            if (int(g.user.userDataCity.objects[i].dbId) == _dbBuildingId) {
                g.user.userDataCity.objects.splice(i, 1);
                break;
            }
        }
        new RemoveWildAnimation(_source, onEndAnimation, onEndAnimationTotal, _dataBuild.removeByResourceId);
        _delete = true;
        g.wildHint.managerHide();
        g.managerQuest.onActionForTaskType(ManagerQuest.REMOVE_WILD, {id:(_dataBuild.id)});
    }

    private function onEndAnimation():void {
        TweenMax.to(_build, 1, {alpha: 0, delay: .3});
    }

    private function onEndAnimationTotal():void {
        var start:Point = new Point(int(_source.x), int(_source.y));
        start = _source.parent.localToGlobal(start);
        var d:DropObject = new DropObject();
        d.addDropXP(_dataBuild.xpForBuild, start);
        d.releaseIt();
        g.server.deleteUserWild(_dbBuildingId, null);
        g.townArea.deleteBuild(this);
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

}
}
