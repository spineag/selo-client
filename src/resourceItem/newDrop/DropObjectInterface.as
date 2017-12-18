/**
 * Created by andy on 12/1/17.
 */
package resourceItem.newDrop {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import flash.geom.Point;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import utils.AnimationsStock;
import utils.MCScaler;

public class DropObjectInterface {
    protected var g:Vars = Vars.getInstance();
    protected var _source:Sprite;
    protected var _data:Object;
    protected var _image:Image;
    protected var _flyCallback:Function;

    public function DropObjectInterface() {
        _source = new Sprite();
        _source.touchable = false;
    }

    protected function onCreateImage():void {
        if (_image) {
            _image.alignPivot();
            MCScaler.scale(_image, 100*g.scaleFactor, 100*g.scaleFactor);
            _source.addChild(_image);
        }
    }

    public function get source():Sprite { return _source; }
    public function set callback(f:Function):void { _flyCallback = f; }
    
    public function flyIt(p:Point=null):void {
        var d:DropObjectInterface = this;
        AnimationsStock.joggleItBaby(_image, 90, .3, 1);
        var f1:Function = function():void {
            if (_flyCallback!=null) _flyCallback.apply(null, [d]);
        };
        AnimationsStock.tweenBezier(_source, p.x, p.y, f1, _source.scale, .3);
    }
    
    public function startJump(d:int, callback:Function):void {  // d==0 or d==1
        _flyCallback = callback;
        var nX:int = _source.x -50+d*100 - 30 + int(Math.random()*60);
        var nY:int = _source.y + 30 - 10 + int(Math.random()*20);
        var tX:int = int((_source.x + nX)/2);
        var tY:int = _source.y - 90 + int(Math.random()*20);
        new TweenMax(_source, .8, {bezier:[{x:tX, y:tY}, {x:nX, y:nY}], ease:Linear.easeOut, onComplete: flyIt});
    }

    public function deleteIt():void {
        
    }
}
}
