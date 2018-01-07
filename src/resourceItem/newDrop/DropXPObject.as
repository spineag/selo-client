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

    public function fillIt(count:int, p:Point):void {
        _count = count;
        _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("xp_icon"));
        onCreateImage();
        setStartPoint(p);
    }

    override public function flyIt(p:Point = null, needJoggle:Boolean = false):void {
        var d:DropXPObject = this;
        p = new Point(g.managerResize.stageWidth - 168, 35);
        g.xpPanel.serverAddXP(_count);
        var f:Function = _flyCallback;
        _flyCallback = function():void {
            g.xpPanel.visualAddXP(_count);
            if (f!=null) f.apply(null, [d]);
        };
        super.flyIt(p);
    }
}
}
