/**
 * Created by user on 2/20/17.
 */
package resourceItem.newDrop {
import flash.geom.Point;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import utils.MCScaler;

public class DropPartyResource extends DropObjectInterface {

    public function DropPartyResource() {
        super();
    }

    public function fillIt(p:Point):void {
        if (g.allData.atlas['partyAtlas']) _image = new Image(g.allData.atlas['partyAtlas'].getTexture('9_may_icon'));
        onCreateImage();
        setStartPoint(p);
        g.managerParty.updateUserParty();
    }

    override public function flyIt(p:Point = null, needJoggle:Boolean = false):void {
        var d:DropPartyResource = this;
        var obj:Object = g.partyPanel.getPoint();
        p = new Point(obj.x, obj.y);
        var f:Function = _flyCallback;
        _flyCallback = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            g.partyPanel.animationBuy();
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            if (f!=null) f.apply(null, [d]);
        };
        super.flyIt(p);
    }
}
}
