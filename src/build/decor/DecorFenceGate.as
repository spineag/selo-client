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
import starling.display.Image;
import windows.WindowsManager;

public class DecorFenceGate extends WorldObject {   // vorota
    private var _part:DecorFenceGate;
    private var _isMainPart:Boolean;
    private var _shopViewImage:Image;
    private var _isHover:Boolean;
    private var _lenta:Image;

    public function DecorFenceGate(_data:Object, mainPart:DecorFenceGate = null) {
        super(_data);
        _isHover = false;
        var im:Image;
        if (!mainPart) {
            _isMainPart = true;
            im = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_1'));
            im.x = _dataBuild.innerX[0];
            im.y = _dataBuild.innerY[0];
        } else {
            _isMainPart = false;
            _part = mainPart;
            im = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_2'));
            im.x = _dataBuild.innerX[1];
            im.y = _dataBuild.innerY[1];
        }

        if (!im) {
            Cc.error('DecorFenceGate:: no such image: ' + _dataBuild.image + ' for ' + _dataBuild.id);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'AreaObject:: no such image');
            return;
        }
        _build.addChild(im);
        _rect = _build.getBounds(_build);
        _source.addChild(_build);
        onCreateBuild();
    }

    public function createSecondPart():void {
        if (_part) return;
        _part = new DecorFenceGate(_dataBuild, this);
        var p:Point = new Point();
        if (_dataBuild.isFlip) {
            p.x = posX + 1;
            p.y = posY;
            if (g.isAway) {
                g.townArea.pasteAwayBuild(_part, p.x, p.y);
            } else {
                p = g.matrixGrid.getXYFromIndex(p);
                g.townArea.pasteBuild(_part, p.x, p.y);
            }
            _part.source.scaleX = -_defaultScale;
        } else {
            p.x = posX;
            p.y = posY + 1;
            if (g.isAway) {
                g.townArea.pasteAwayBuild(_part, p.x, p.y);
            } else {
                p = g.matrixGrid.getXYFromIndex(p);
                g.townArea.pasteBuild(_part, p.x, p.y);
            }
        }
    }

    public function deleteSecondPart():void {
        if (g.isAway) {
            g.townArea.deleteAwayBuild(_part);
        } else {
            g.townArea.deleteBuild(_part);
        }
        _part = null;
    }

    public function showFullView():void {
        if (_isMainPart && !_shopViewImage) {
            _shopViewImage = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_2'));
            _shopViewImage.x = _dataBuild.innerX[2];
            _shopViewImage.y = _dataBuild.innerY[2];
            _build.addChild(_shopViewImage);
        }
    }

    public function removeFullView():void {
        if (_isMainPart && _shopViewImage) {
            if (_build.contains(_shopViewImage)) _build.removeChild(_shopViewImage);
            _shopViewImage.dispose();
            _shopViewImage = null;
        }
    }

    public function get isMain():Boolean { return _isMainPart; }

    public function addSmallTopLenta():void {
        if (_isMainPart) {
            _lenta = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_5'));
            _lenta.x = _dataBuild.innerX[3];
            _lenta.y = _dataBuild.innerY[3];
            _build.addChildAt(_lenta, 0);
        }
    }

    public function removeSmallTopLenta():void {
        if (_isMainPart && _lenta) {
            if (_build.contains(_lenta)) _build.removeChild(_lenta);
            _lenta.dispose();
            _lenta = null;
        }
    }

    public function addSmallBottomLenta():void {
        if (_isMainPart) {
            if (_part) _part.addSmallBottomLenta();
        } else {
            _lenta = new Image(g.allData.atlas[_dataBuild.url].getTexture(_dataBuild.image + '_5'));
            _lenta.x = _dataBuild.innerX[4];
            _lenta.y = _dataBuild.innerY[4];
            _build.addChild(_lenta);
        }
    }

    public function removeSmallBottomLenta():void {
        if (_isMainPart) {
            if (_part) _part.removeSmallBottomLenta();
        } else {
            if (_lenta) {
                if (_build.contains(_lenta)) _build.removeChild(_lenta);
                _lenta.dispose();
                _lenta = null;
            }
        }
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.endClickCallback = onClick;
            _source.hoverCallback = onHover;
            _source.outCallback = onOut;
            _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.image + '_1', ManagerHitArea.TYPE_FROM_ATLAS); // remake for hitArea !!
            _source.registerHitArea(_hitArea);
        }
    }

    public function onClick():void {
        if (!_isMainPart) {
            if (_part) _part.onClick();
            return;
        }
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                deleteSecondPart();
                showFullView();
                g.townArea.moveBuild(this);
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
//            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            g.directServer.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (!g.selectedBuild) {
                g.directServer.addToInventory(_dbBuildingId, null);
                g.userInventory.addToDecorInventory(_dataBuild.id, _dbBuildingId);
                deleteSecondPart();
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
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE || g.toolsModifier.modifierType == ToolsModifier.FLIP || g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            if (_isHover) return;
            _isHover = true;
            if (_part) _part.onHover();
            _source.filter = ManagerFilters.BUILD_STROKE;
        }
    }

    override public function onOut():void {
        if (!_isHover) return;
        _isHover = false;
        if (_part) _part.onOut();
        if (_source) {
            if (_source.filter) _source.filter.dispose();
            _source.filter = null;
        }
    }

    override public function releaseFlip():void {
        if (_isMainPart && _part) {
            deleteSecondPart();
        }
        removeSmallBottomLenta();
        removeSmallTopLenta();
        if (_flip) g.townArea.unFillMatrixWithFence(posX, posY, _sizeY, _sizeX);
            else g.townArea.unFillMatrixWithFence(posX, posY, _sizeX, _sizeY);
        super.releaseFlip();
        createSecondPart();
        if (_flip) g.townArea.fillMatrixWithFence(posX, posY, _sizeY, _sizeX, this);
            else g.townArea.fillMatrixWithFence(posX, posY, _sizeX, _sizeY, this);
        g.townArea.addFenceLenta(this);
    }

}
}
