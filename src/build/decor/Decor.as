/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.WorldObject;
import build.lockedLand.LockedLand;
import com.junkbyte.console.Cc;

import flash.geom.Point;

import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;
import mouse.ToolsModifier;

import resourceItem.SimpleFlyDecor;

import utils.Utils;

public class Decor extends WorldObject{
    private var _isHover:Boolean;
    private var _curLockedLand:LockedLand;

    public function Decor(_data:Object) {
        super(_data);
        createAtlasBuild(onCreateBuild);
        _source.releaseContDrag = true;
        _isHover = false;
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onClick;
            _source.outCallback = onOut;
            _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.image);
            _source.registerHitArea(_hitArea);
        }
    }

    public function setLockedLand(l:LockedLand):void {
        _curLockedLand = l;
    }

    public function get isAtLockedLand():Boolean {
        if (_curLockedLand) return true;
        else return false;
    }

    public function removeLockedLand():void {
        _curLockedLand = null;
        g.server.deleteUserWild(_dbBuildingId, null);
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        if (_isHover) return;
        _isHover = true;
        super.onHover();
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY)
            _source.filter = ManagerFilters.BUILD_STROKE;
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.isActiveMapEditor) {
                if (_curLockedLand) {
                    _curLockedLand.activateOnMapEditor(null, this);
                    _curLockedLand = null;
                }
                onOut();
                g.townArea.moveBuild(this);
            } else if (!_curLockedLand) {
                onOut();
                if (g.selectedBuild) {
                    if (g.selectedBuild == this) {
                        g.toolsModifier.onTouchEnded();
                    } else return;
                } else {
                    g.townArea.moveBuild(this);
                }
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            if (g.isActiveMapEditor) {
                if (_curLockedLand) {
                    _curLockedLand.activateOnMapEditor(null,this);
                    _curLockedLand = null;
                }
                onOut();
                g.server.ME_removeWild(_dbBuildingId, null);
                g.townArea.deleteBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            onOut();
            releaseFlip();
            g.server.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (g.managerCutScenes.isCutScene && !g.managerCutScenes.isCutSceneResource(_dataBuild.id)) return;
            onOut();
            if (!g.selectedBuild) {
                if (g.managerCutScenes && g.managerCutScenes.isCutSceneBuilding(this)) {
                    g.managerCutScenes.checkCutSceneCallback();
                }
                g.server.addToInventory(_dbBuildingId, null);
                g.userInventory.addToDecorInventory(_dataBuild.id, _dbBuildingId);
                var p:Point = new Point(0, 0);
                p = _source.localToGlobal(p);
                new SimpleFlyDecor(p.x, p.y, g.allData.getBuildingById(_dataBuild.id), 70, 70,1, 1, true);
                g.townArea.deleteBuild(this);
            } else {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                }
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }

    }

    override public function onOut():void {
        super.onOut();
        _isHover = false;
        if(_source) {
            if (_source.filter) _source.filter.dispose();
            _source.filter = null;
        }
    }

    override public function clearIt():void {
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

}
}
