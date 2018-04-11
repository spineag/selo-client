/**
 * Created by andy on 12/1/17.
 */
package resourceItem.newDrop {
import flash.geom.Point;
import starling.display.Image;

public class DropXPObject extends DropObjectInterface{
    private var _count:int;
    private var needSend:Boolean;
    private var GLOBAL_COUNT:int; // for save to server if need

    public function DropXPObject() {
        needSend = false;
        GLOBAL_COUNT = 0;
        super();
    }
    
    public function needSaveToServer(gCount:int):void {
        needSend = true;
        GLOBAL_COUNT = gCount;
    }

    public function fillIt(count:int, p:Point):void {
        _count = count;
        _image = new Image(g.allData.atlas['interfaceAtlas'].getTexture("xp_icon"));
        onCreateImage();
        setStartPoint(p);
    }

    override public function flyIt(p:Point = null, needJoggle:Boolean = false):void {
        var d:DropXPObject = this;
        var cnt:int = _count;
        p = new Point(g.managerResize.stageWidth - 168, 35);
        if (needSend) {
            needSend = false;
            g.xpPanel.serverAddXP(GLOBAL_COUNT);
        }
        var f:Function = _flyCallback;
        _flyCallback = function():void {
            g.xpPanel.visualAddXP(cnt);
            if (f!=null) f.apply(null, [d]);
        };
        super.flyIt(p);
    }
}
}
