/**
 * Created by andy on 5/12/16.
 */
package preloader.miniPreloader {
import starling.display.Sprite;

public class SimpleDotedPreloader {
    private var _source:Sprite;
    private var _arrDots:Array;

    public function SimpleDotedPreloader() {
        _source = new Sprite();
        _source.touchable = false;
        _arrDots = [];
        var dot:Particle;
        for (var i:int=0; i<8; i++) {
            dot = new Particle(i, _source);
            _arrDots.push(dot);
        }
    }

    public function get source():Sprite {
        return _source;
    }

    public function deleteIt():void {
        for (var i:int=0; i<_arrDots.length; i++) {
            _arrDots[i].deleteIt();
        }
        _arrDots.length = 0;
        _source.dispose();
        _source = null;
    }
}
}

import com.greensock.TweenMax;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;

internal class Particle {
    private var _source:Sprite;
    private var _parent:Sprite;
    private var g:Vars = Vars.getInstance();

    public function Particle(i:int, p:Sprite) {
        _parent = p;
        _source = new Sprite();
        switch (i) {
            case 0:
                _source.x = 0;
                _source.y = -20;
                break;
            case 1:
                _source.x = 14;
                _source.y = -15;
                break;
            case 2:
                _source.x = 20;
                _source.y = 0;
                break;
            case 3:
                _source.x = 14;
                _source.y = 15;
                break;
            case 4:
                _source.x = 0;
                _source.y = 20;
                break;
            case 5:
                _source.x = -14;
                _source.y = 15;
                break;
            case 6:
                _source.x = -20;
                _source.y = 0;
                break;
            case 7:
                _source.x = -14;
                _source.y = -15;
                break;
        }
        var im:Image = new Image(g.allData.atlas['interfaceAtlas'].getTexture('white'));
        im.x = -im.width/2;
        im.y = -im.height/2;
        _source.addChild(im);
        _parent.addChild(_source);
        animateIt(i*.125);
    }

    private function animateIt(d:Number=0):void {
        _source.scaleX = _source.scaleY = .2;
        TweenMax.to(_source, 1, {scaleX:1.2, scaleY:1.5, onComplete:animateIt, delay:d});
    }

    public function deleteIt():void {
        TweenMax.killTweensOf(_source);
        _parent.removeChild(_source);
        _parent = null;
        _source.dispose();
        _source = null;
    }
}
