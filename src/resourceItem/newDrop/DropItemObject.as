/**
 * Created by andy on 12/1/17.
 */
package resourceItem.newDrop {
import data.BuildType;
import flash.geom.Point;
import resourceItem.ResourceItem;
import starling.display.Image;

public class DropItemObject extends DropObjectInterface{
    private var _resourceItem:ResourceItem;

    public function DropItemObject() {
        super();
    }

    public function fillIt(item:ResourceItem, pos:Point):void {
        _resourceItem = item;
        if (_resourceItem.buildType == BuildType.PLANT) _image = new Image(g.allData.atlas['resourceAtlas'].getTexture(_resourceItem.imageShop + '_icon'));
            else  _image = new Image(g.allData.atlas[_resourceItem.url].getTexture(_resourceItem.imageShop));
        onCreateImage();
        _source.x = pos.x;
        _source.y = pos.y;
    }

    override public function flyIt(p:Point = null):void {
        p = g.craftPanel.pointXY();
        g.craftPanel.showIt(BuildType.PLACE_SKLAD);
        g.userInventory.addResource(_resourceItem.resourceID, 1);
        g.updateAmbarIndicator();
       super.flyIt(p);
    }
}
}
