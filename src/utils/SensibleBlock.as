/**
 * Created by andy on 9/9/17.
 */
package utils {
import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;

public class SensibleBlock extends Sprite {
    private const TextAndImage:int=1;
    private const ImageAndText:int=2;
    private var _type:int;

    private var _width:int;
    private var _delta:int;
    private var _txt:CTextField;
    private var _im:Image;
    private var _tempSprite:Sprite;

    public function SensibleBlock() {
        super();
    }

    public function textAndImage(t:CTextField, im:Image, w:int, delta:int=25):void {
        _type = TextAndImage;
        _txt = t;
        _im = im;
        _delta = delta;
        _width = w;
        var wT:int = t.textBounds.width;
        _tempSprite = new Sprite();
        t.alignH = Align.RIGHT;
        t.x = wT - t.width;
        t.y = -t.height/2 - 2;
        _tempSprite.addChild(t);
        if (im) {
            _im.alignPivot();
            _im.x = t.x + t.width + delta;
            _im.y = -2;
            _tempSprite.addChild(_im);
            _tempSprite.x = w / 2 - (wT + delta + _im.width) / 2 + 5;
        } else
            _tempSprite.x = w / 2 - (wT + delta) / 2 + 5;
        this.addChild(_tempSprite);
        this.touchable = false;
    }

    public function imageAndText(im:Image, t:CTextField, w:int, delta:int=25):void {
        _type = ImageAndText;
        _txt = t;
        _im = im;
        _delta = delta;
        _width = w;
        var wT:int = t.textBounds.width;
        _tempSprite = new Sprite();
        t.alignH = Align.LEFT;
        _tempSprite.addChild(im);
        _txt.x = im.width + delta;
        _tempSprite.addChild(_txt);
        _tempSprite.x = w/2 - (wT + delta + im.width)/2 + 5;
        this.addChild(_tempSprite);
        this.touchable = false;
    }

    public function updateText(st:String):void {
        _txt.text = st;
        var wT:int = _txt.textBounds.width;
        if (_type == TextAndImage) {
            _txt.x = wT - _txt.width;
            _im.x = _txt.x + _txt.width + _delta;
            _tempSprite.x = _width/2 - (wT + _delta + _im.width)/2 + 5;
        } else if (_type == ImageAndText) {
            _tempSprite.x = _width/2 - (wT + _delta + _im.width)/2 + 5;
        }
    }

    public function deleteIt():void {
        if (_txt) {
            _tempSprite.removeChild(_txt);
            _txt.deleteIt();
        }
        dispose();
    }
}
}
