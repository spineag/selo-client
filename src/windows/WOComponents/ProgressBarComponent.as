/**
 * Created by user on 11/24/15.
 */
package windows.WOComponents {
import flash.geom.Rectangle;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

public class ProgressBarComponent extends Sprite {
    private var _left:Sprite;
    private var _center:Sprite;
    private var _right:Sprite;
    private var _maxWidth:int;
    private var _imCenter:Image;

    public function ProgressBarComponent(lt:Texture, ct:Texture, rt:Texture, w:int) {
        _maxWidth = w;
        _left = new Sprite();
        _center = new Sprite();
        _right = new Sprite();
        var im:Image = new Image(lt);
        im.x = -7;
        _left.addChild(im);
        im = new Image(rt);
        _right.addChild(im);
        _imCenter = new Image(ct);
        _center.addChild(_imCenter);
        _imCenter.tileGrid = new Rectangle();
        _center.x = 9;
        addChild(_left);
        addChild(_center);
        addChild(_right);
    }

    public function set progress(percent:Number):void {
        _left.visible = true;
        _center.visible = true;
        _right.visible = true;
        if (percent > 1) percent = 1;
        if (percent < 0) percent = 0;
        var w:Number = percent*_maxWidth;
        _imCenter.width = w;
        _imCenter.tileGrid = _imCenter.tileGrid;
        _right.x = w + 9;
        if (w == 0) {
            _left.visible = false;
            _center.visible = false;
            _right.visible = false;
        }
    }

    public function deleteIt():void {
        dispose();
        _left = null;
        _center = null;
        _right = null;
    }
}
}
