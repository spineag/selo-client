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

    override public function flyIt(p:Point = null, needJoggle:Boolean = false):void {
        var d:DropItemObject = this;
        p = g.craftPanel.pointXY();
        if (_resourceItem.buildType == BuildType.PLANT) g.craftPanel.showIt(BuildType.PLACE_AMBAR);
            else g.craftPanel.showIt(BuildType.PLACE_SKLAD);
        g.userInventory.addResource(_resourceItem.resourceID, 1);
        g.updateAmbarIndicator();
        var f:Function = _flyCallback;
        _flyCallback = function():void {
            g.craftPanel.afterFly(_resourceItem);
            if (f!=null) f.apply(null, [d]);
        };
       super.flyIt(p);
        
    }
}
}
