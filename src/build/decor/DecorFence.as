/**
 * Created by user on 6/8/15.
 */
package build.decor {
import build.WorldObject;
import com.junkbyte.console.Cc;

import flash.geom.Point;

import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;
import mouse.ToolsModifier;

import resourceItem.SimpleFlyDecor;

public class DecorFence extends WorldObject {   // tsili 4astunu zabory
    public function DecorFence(_data:Object) {
        super(_data);
        createAtlasBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _source.hoverCallback = onHover;
            _source.outCallback = onOut;
            _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.image);
            _source.registerHitArea(_hitArea);
        }
    }

    private function onClick():void {
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
                releaseFlip();
                g.server.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (!g.selectedBuild) {
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
            // ничего не делаем
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.PLANT_TREES;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            // ничего не делаем
        } else {
            Cc.error('TestBuild:: unknown g.toolsModifier.modifierType')
        }
    }

    override public function clearIt():void {
        _source.touchable = false;
        super.clearIt();
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        _source.filter = ManagerFilters.BUILD_STROKE;
    }

    override public function onOut():void {
        super.onOut();
        if (g.isActiveMapEditor) return;
        if (_source.filter) _source.filter.dispose();
        _source.filter = null;
    }

    public function makeFlipAtMoving():void {
        _flip = !_flip;
        makeFlipBuilding();
    }
}
}
