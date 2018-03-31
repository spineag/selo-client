/**
 * Created by user on 4/26/16.
 */
package manager.hitArea {
import starling.display.Sprite;

public class ManagerHitArea {
    public static const TYPE_SIMPLE:int = 1;
    private var _areas:Object;

    public function ManagerHitArea() {
        _areas = {};
    }

    public function getHitArea(sp:starling.display.Sprite, name:String, type:int = 0):OwnHitArea {
        if (_areas[name]) {
            return _areas[name];
        } else {
            var area:OwnHitArea = new OwnHitArea();
            if (type == TYPE_SIMPLE)     area.createSimple(sp, name);
            else if (name == 'bt_close') area.createCircle(sp, name);
            else                         area.createFromStarlingSprite(sp, name);
            _areas[name] = area;
            return area;
        }
    }
}
}
