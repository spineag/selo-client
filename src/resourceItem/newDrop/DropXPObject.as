/**
 * Created by andy on 12/1/17.
 */
package resourceItem.newDrop {
import flash.geom.Point;
import starling.display.Image;

public class DropXPObject extends DropObjectInterface{
    private var _count:int;

    public function DropXPObject() {
        super();
    }

    public function fillIt(count:int, pos:Point):void {
        _count = count;
        _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("xp_icon"));
        onCreateImage();
        _source.x = pos.x;
        _source.y = pos.y;
    }

    override public function flyIt(p:Point = null):void {
        p = new Point(g.managerResize.stageWidth - 168, 35);
        g.xpPanel.serverAddXP(_count);
        var f:Function = _flyCallback;
        _flyCallback = function():void {
            g.xpPanel.visualAddXP(_count);
            if (f!=null) f.call();
        };
        super.flyIt(p);
    }
}
}
