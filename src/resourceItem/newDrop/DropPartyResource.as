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
        if (g.allData.atlas['partyAtlas']) _image = new Image(g.allData.atlas['partyAtlas'].getTexture('usa_badge'));
        onCreateImage();
        _source.x = p.x;
        _source.y = p.y;
//        if (g.managerParty.userParty.countResource < g.managerParty.countToGift[4]) {
//            if (g.managerParty.userParty.countResource + 1 <= g.managerParty.countToGift[4]) {
                g.managerParty.userParty.countResource = g.managerParty.userParty.countResource + 1;
                var st:String = g.managerParty.userParty.tookGift[0] + '&' + g.managerParty.userParty.tookGift[1] + '&' + g.managerParty.userParty.tookGift[2] + '&'
                        + g.managerParty.userParty.tookGift[3] + '&' + g.managerParty.userParty.tookGift[4];
                g.server.updateUserParty(st, g.managerParty.userParty.countResource, 0, null);
//            }
//        }
    }

    override public function flyIt(p:Point = null):void {
        var obj:Object = g.partyPanel.getPoint();
        p = new Point(obj.x, obj.y);
        var f:Function = _flyCallback;
        _flyCallback = function():void {
            g.cont.animationsResourceCont.removeChild(_source);
            g.partyPanel.animationBuy();
            while (_source.numChildren) {
                _source.removeChildAt(0);
            }
            if (f!=null) f.call();
        };
        super.flyIt(p);
    }
}
}
