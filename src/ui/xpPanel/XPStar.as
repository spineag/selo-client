/**
 * Created by user on 6/24/15.
 */
package ui.xpPanel {

import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import utils.CTextField;
import utils.Utils;

public class XPStar {

    private var _source:Sprite;
    private var _countXp:int;
    private var _countInXP:int;
    private var g:Vars = Vars.getInstance();

    public function XPStar(_x:int, _y:int,xp:int) {
        _source = new Sprite();
        _source.touchable = false;
        _countXp = xp;
        _countInXP = 0;
        var item:XPStarItem;
        var i:int;
        if (xp > 5) {
            for (i = 0; i < 5; i++ ) {
                var f1:Function = function ():void {
                    if (i == 4) item = new XPStarItem(_x,_y,xp-4,endFly);
                    else item = new XPStarItem(_x,_y,1,endFly);
                    _source.addChild(item.source);
                };
                Utils.createDelay(Math.random(),f1);
            }
        } else if (xp <= 5) {
            for (i = 0; i < xp; i++ ) {
                var f2:Function = function ():void {
                    item = new XPStarItem(_x,_y,1,endFly);
                    _source.addChild(item.source);
                };
               Utils.createDelay(Math.random(),f2);
            }
        }
        g.cont.animationsResourceCont.addChild(_source);
    }

    private function endFly():void {
        _countInXP++;
        if (_countXp > 5 && _countInXP == 5) {
            _countInXP = 0;
            g.cont.animationsResourceCont.removeChild(_source);
        } else if (_countXp <= 5 && _countInXP == _countXp){
            _countInXP = 0;
            g.cont.animationsResourceCont.removeChild(_source);
        }
    }
}
}
