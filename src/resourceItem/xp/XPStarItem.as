/**
 * Created by user on 10/5/17.
 */
package resourceItem.xp {
import com.greensock.TweenMax;
import com.greensock.easing.Linear;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;
import utils.CTextField;

public class XPStarItem {

    public var source:Sprite;
    private var _image:Image;
    private var _xp:int;
    private var _txtStar:CTextField;
    private var _callback:Function;

    private var g:Vars = Vars.getInstance();

    public function XPStarItem(x:int, y:int, xp:int, callback:Function) {
        _xp = xp;
        _callback = callback;
        source = new Sprite();
        source.touchable = false;
        _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("xp_icon"));
        _image.alignPivot();
        source.addChild(_image);
        source.x = x;
        source.y = y;
        if (xp > 1) {
            _txtStar = new CTextField(50,30, '+' + String(xp));
            _txtStar.setFormat(CTextField.BOLD18, 18, Color.WHITE, 0xff7a3f);
            _txtStar.alignH = Align.LEFT;
            _txtStar.x = 3;
//            _txtStar.y = -14;
            source.addChild(_txtStar);
        }
        startFly();
    }

    private function startFly():void {
        var endX:int;
        var endY:int;
        var plusX:int;
        var plusY:int;
        if (Math.random() > .5) {
            endX = source.x + 30;
            plusX = source.x + 40;
        } else {
            endX = source.x - 30;
            plusX = source.x - 40
        }

        if (Math.random() <= .2) {
            endY = source.y - 90;
            plusY = endY + 115;
        } else if (Math.random() <= .4) {
            endY = source.y - 105;
            plusY = endY + 110;
        } else if (Math.random() <= .6) {
            endY = source.y - 120;
            plusY = endY + 115;
        } else if (Math.random() <= .8) {
            endY = source.y - 130;
            plusY = endY + 120;
        } else {
            endY = source.y - 115;
            plusY = endY + 120;
        }
        new TweenMax(source, .9, {bezier:[{x: source.x, y: source.y}, {x:endX, y:endY}, {x:plusX, y:plusY}], ease:Linear.easeOut, onComplete: flyItStar, delay:.3});
    }

    private function flyItStar():void {
        var endX:int = g.managerResize.stageWidth - 168;
        var endY:int = 35;

        var f1:Function = function():void {
            while (source.numChildren) {
                source.removeChildAt(0);
            }
            source = null;
            g.xpPanel.visualAddXP(_xp);
            if (_callback != null) {
                _callback.apply();
            }
            deleteIt();
        };
        g.xpPanel.serverAddXP(_xp);
        var tempX:int;
        source.x < endX ? tempX = source.x + 70 : tempX = source.x - 70;
        var tempY:int = source.y + 30 + int(Math.random()*20);
        var dist:int = int(Math.sqrt((source.x - tempX)*(source.x - tempX) + (source.y - tempY)*(source.y - tempY)));
        dist += int(Math.sqrt((tempX - endX)*(tempX - endX) + (tempY - endY)*(tempY - endY)));
        var t:Number = dist/1000 * 2;
        if (t > 2) t -= .6;
        if (t > 3) t -= 1;
        new TweenMax(source, t, {bezier:[{x:tempX, y:tempY}, {x:endX, y:endY}], ease:Linear.easeOut ,onComplete: f1, delay:.3});
    }

    private function deleteIt():void {
        if (!source) return;
        if (_txtStar) {
            source.removeChild(_txtStar);
            _txtStar.deleteIt();
            _txtStar = null;
        }
        source.dispose();
    }

}
}
