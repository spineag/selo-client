/**
 * Created by andy on 12/3/17.
 */
package resourceItem.newDrop {
import com.junkbyte.console.Cc;

import data.BuildType;
import data.StructureDataBuilding;

import flash.geom.Point;

import starling.display.Image;
import starling.textures.Texture;
import windows.WindowsManager;

public class DropDecorNew extends DropObjectInterface {
    private var _dataDecor:StructureDataBuilding;
    private var _needAddServer:Boolean;

    public function DropDecorNew() {
        super();
    }

    public function fillIt(data:StructureDataBuilding, p:Point, needAddServer:Boolean = false):void {
        _dataDecor = data;
        _needAddServer = needAddServer;
        if (_dataDecor.image) {
            var texture:Texture = g.allData.atlas['iconAtlas'].getTexture(_dataDecor.image + '_icon');
            if (!texture && g.allData.atlas[_dataDecor.url]) texture = g.allData.atlas[_dataDecor.url].getTexture(_dataDecor.image);
            if (!texture) texture = g.allData.atlas['iconAtlas'].getTexture(_dataDecor.url + '_icon');
            if (!texture) {
                Cc.error('SimpleFlyDecor:: no such texture: ' + _data.url + ' for _dataDecor.id ' + _dataDecor.id);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'dropDecor');
                return;
            }
            _image = new Image(texture);
            onCreateImage();
            setStartPoint(p);
        } else Cc.error('SimpleFlyDecor:: no image for decor with id: ' + _dataDecor.id);
    }

    override public function flyIt(p:Point = null, needJoggle:Boolean = false):void {
        var d:DropDecorNew = this;
        g.toolsPanel.repositoryBox.moveToItemWithID(_dataDecor.id);
        var obj:Object = g.bottomPanel.getShopButtonProperties();
        p = new Point(obj.x, obj.y);
        var f:Function = _flyCallback;
        _flyCallback = function():void {
            var f2:Function = function(dbId:int):void {
                g.userInventory.addToDecorInventory(_dataDecor.id, dbId, false);
                g.updateRepository();
            };
            if (_needAddServer) { 
                g.lastActiveDecorID = _dataDecor.id;
                g.server.buyAndAddToInventory(_dataDecor.id,  f2);
            }
            if (f!=null) f.apply(null, [d]);
        };
        super.flyIt(p);
    }
}
}
