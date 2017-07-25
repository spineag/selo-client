/**
 * Created by user on 7/21/15.
 */
package hint {

import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import starling.animation.Tween;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

public class FlyMessage {
    private var _source:Sprite;
    private var _txtMessage:CTextField;
    private var g:Vars = Vars.getInstance();

    public function FlyMessage(p:Point, text:String) {
        _source = new Sprite();
        _txtMessage = new CTextField(300,40,text);
        _txtMessage.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BROWN_COLOR);
        _txtMessage.x = -150;
        _source.x = p.x;
        _source.y = p.y;
        _source.addChild(_txtMessage);
        g.cont.hintCont.addChild(_source);
        var tween:Tween = new Tween(_source, 2);
        tween.moveTo(_source.x,_source.y - 40);
        tween.onComplete = function ():void {
            g.starling.juggler.remove(tween);
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            _source=null;
        };
        g.starling.juggler.add(tween);

    }
}
}
