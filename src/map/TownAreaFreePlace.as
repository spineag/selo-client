/**
 * Created by user on 7/1/16.
 */
package map {
import flash.geom.Point;

public class TownAreaFreePlace {
    private var _arr:Array;    // contains free cells
    private var _arrAway:Array;
    private var _length:int; // = g.matrixGrid.matrixSize

    public function TownAreaFreePlace(l:int) {
        _arr = [];
        _length = l;
        fillArr();
    }
    
    public function get arrAway():Array {
        if (_arrAway) {
            return _arrAway;
        } else return [];
    }

    private function fillArr():void {
        var j:int;
        for (var i:int=0; i<_length; i++) { //x
            for(j=0; j<_length; j++) {      //y
                _arr.push(String(i) + '&' + String(j));
            }
        }
    }

    public function fillCell(x:int, y:int):void {
        var s:String = String(x) + '&' + String(y);
        if (_arr.indexOf(s) > -1) _arr.splice(_arr.indexOf(s), 1);
    }

    public function freeCell(x:int, y:int):void {
        var s:String = String(x) + '&' + String(y);
        if (_arr.indexOf(s) == -1) _arr.push(s);
    }

    public function getFreeCell(x:int = -1, y:int = -1):Point {
        var p:Point = new Point();
        if (!_arr.length) {
            return p;
        }
        var s:String;
        var arr:Array;
        if (x == -1) {
            s = _arr[int(_arr.length*Math.random())];
            arr = s.split('&');
            p.x = int(arr[0]);
            p.y = int(arr[1]);
            return p;
        } else {
            p.x = -1;
            p.y = -1;
            function randomize ( a : *, b : * ) : int {
                return ( Math.random() > .5 ) ? 1 : -1;
            }
            _arr.sort(randomize);
            for (var i:int = 0; i < _arr.length; i++) {
                arr = [];
                s = _arr[i];
                arr = s.split('&');
                if ((p.x == -1 && arr[0] - x > 10 && p.x == -1 && arr[0] - x < (10 + Math.random() * 26)) || (arr[0] - x < - 10 && arr[0] - x > -1* (10 + Math.random() * 26))) {
                    p.x = int(arr[0]);
                }
                if ((p.y == -1 && arr[1] - y > 10 && p.y == -1 && arr[1] - y < (10 + Math.random() * 15)) || (arr[1] - y < - 10 && arr[1] - y > -1* (10 + Math.random() * 15)))  {
                    p.y = int(arr[1]);
                }
                if (p.y != -1 && p.x != -1) break;
            }
            if (p.y != -1 && p.x != -1) {
                s = _arr[int(_arr.length*Math.random())];
                arr = s.split('&');
                p.x = int(arr[0]);
                p.y = int(arr[1]);
            }

            return p;
        }
    }

    public function fillAway():void {
        var j:int;
        _arrAway = [];
        for (var i:int=0; i<_length; i++) { //x
            for(j=0; j<_length; j++) {      //y
                _arrAway.push(String(i) + '&' + String(j));
            }
        }
    }

    public function deleteAway():void {
        if (_arrAway) _arrAway.length = 0;
    }

    public function fillAwayCell(x:int, y:int):void {
        var s:String = String(x) + '&' + String(y);
        if (_arrAway.indexOf(s) > -1) _arrAway.splice(_arrAway.indexOf(s), 1);
    }

    public function freeAwayCell(x:int, y:int):void {
        var s:String = String(x) + '&' + String(y);
        if (_arrAway.indexOf(s) == -1) _arrAway.push(s);
    }

    public function getAwayFreeCell():Point {
        var p:Point = new Point();
        if (!_arrAway.length) {
            return p;
        }
        var s:String = _arrAway[int(_arrAway.length*Math.random())];
        var arr:Array = s.split('&');
        p.x = int(arr[0]);
        p.y = int(arr[1]);
        return p;
    }

}
}
