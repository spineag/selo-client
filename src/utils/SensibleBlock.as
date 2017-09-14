/**
 * Created by andy on 9/9/17.
 */
package utils {
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;

public class SensibleBlock extends Sprite {
    private var _text:CTextField;
    private var _tempSprite:Sprite;
    public function SensibleBlock() {
        super();
    }

    public function textAndImage(t:CTextField, im:Image, width:int, delta:int=25):void {
        _text = t;
        var wT:int = t.textBounds.width;
        _tempSprite = new Sprite();
        t.alignH = Align.RIGHT;
        t.x = wT - t.width;
        t.y = -t.height/2 - 2;
        _tempSprite.addChild(t);
        im.x = t.x + t.width + delta;
        im.y = -2;
        _tempSprite.addChild(im);
        _tempSprite.x = width/2 - (wT + delta + im.width)/2 + 5;
        this.addChild(_tempSprite);
        this.touchable = false;
    }

    public function deleteIt():void {
        if (_text) {
            _tempSprite.removeChild(_text);
            _text.deleteIt();
        }
        dispose();
    }
}
}
