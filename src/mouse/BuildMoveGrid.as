/**
 * Created by yusjanja on 11.08.2015.
 */
package mouse {
import flash.geom.Point;

import manager.Vars;

import starling.display.Sprite;

public class BuildMoveGrid {
    private var _parent:Sprite;
    private var W:int;
    private var H:int;
    private var _source:Sprite;
    private var _matrix:Array;
    private var _townMatrix:Array;
    private var _isFree:Boolean = true;

    private var g:Vars = Vars.getInstance();

    public function BuildMoveGrid(p:Sprite, w:int, h:int) {
        _parent = p;
        W = w;
        H = h;
        _source = new Sprite();
        _parent.addChildAt(_source, 0);
        _townMatrix = g.townArea.townMatrix;
        fillMatrix();
    }

    private function fillMatrix():void {
        var p:Point;
        var tile:BuildMoveGridTile;
        _matrix = [];
        for (var i:int = 0; i < W; i++) {
            _matrix.push([]);
            for (var j:int = 0; j < H; j++) {
                tile = new BuildMoveGridTile(i, j);
                _matrix[i][j] = tile;
                tile.setType(BuildMoveGridTile.TYPE_IN);
                p = g.matrixGrid.getXYFromIndex(new Point(i, j));
                tile.source.x = p.x;
                tile.source.y = p.y;
                _source.addChild(tile.source);
            }
        }
    }

    public function clearIt():void {
        _parent.removeChild(_source);
        while (_source.numChildren) _source.removeChildAt(0);
        for (var i:int = 0; i < W ; i++) {
            for (var j:int = 0; j < H; j++) {
                _matrix[i][j].clearIt();
            }
        }
        _matrix = [];
        _parent = null;
        _townMatrix = null;
    }

    public function get isFree():Boolean { return _isFree;  }

    public function checkIt(gX:int, gY:int):void {
        _isFree = true;
        for (var i:int = 0; i < W; i++) {
            for (var j:int = 0; j < H; j++) {
                if (checkFreeGrid(gX + i, gY + j)) {
                    _matrix[i][j].setFree(true);
                } else {
                    _matrix[i][j].setFree(false);
                    if (_matrix[i][j].type == BuildMoveGridTile.TYPE_IN)
                        _isFree = false;
                }
            }
        }
    }

    private function checkFreeGrid(posY:int, posX:int):Boolean {
        if (!_townMatrix[posX] || !_townMatrix[posX][posY]) return false;
        var obj:Object = _townMatrix[posX][posY];
        if (!obj) return false;
        if (g.tuts.isTuts)
            return obj.isTutorialBuilding;
        if (!obj.inGame) return false;
        if (obj.isFull) return false;
        if (obj.isBlocked) return false;

        return true;
    }

}
}
