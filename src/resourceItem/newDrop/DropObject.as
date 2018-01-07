/**
 * Created by andy on 11/28/17.
 */
package resourceItem.newDrop {
import data.StructureDataBuilding;
import flash.geom.Point;
import manager.Vars;
import resourceItem.ResourceItem;

public class DropObject {
    private var g:Vars = Vars.getInstance();
    private var _arrDrops:Array;
    private var _callback:Function;

    public function DropObject() {
        _arrDrops = [];
    }

    public function addDropMoney(type:int, count:int, p:Point):void {
        var d:DropMoneyObject;
        var i:int;
        if (count > 5) {
            var c:int = count%5;
            var cd:int = int(count/5);
            for (i = 0; i < 5; i++) {
                d = new DropMoneyObject();
                if (c>0) {
                    c--;
                    d.fillIt(type, cd + 1, p);
                } else d.fillIt(type, cd, p);
                _arrDrops.push(d);
            }
        } else {
            for (i = 0; i < count; i++ ) {
                d = new DropMoneyObject();
                d.fillIt(type, 1, p);
                _arrDrops.push(d);
            }
        }
    }

    public function addDropXP(count:int, p:Point):void {
        var d:DropXPObject;
        var i:int;
        if (count > 5) {
            var c:int = count%5;
            var cd:int = int(count/5);
            for (i = 0; i < 5; i++) {
                d = new DropXPObject();
                if (c>0) {
                    c--;
                    d.fillIt(cd + 1, p);
                } else d.fillIt(cd, p);
                _arrDrops.push(d);
            }
        } else {
            for (i = 0; i < count; i++ ) {
                d = new DropXPObject();
                d.fillIt(1, p);
                _arrDrops.push(d);
            }
        }
    }

    public function addDropPartyResource(p:Point):void {
        var d:DropPartyResource = new DropPartyResource();
        d.fillIt(p);
        _arrDrops.push(d);
    }

    public function addDropDecor(data:StructureDataBuilding, p:Point, count:int=1, needAddServer:Boolean = false):void {
        var d:DropDecorNew;
        for (var i:int=0; i<count; i++) {
            d = new DropDecorNew();
            d.fillIt(data, p, needAddServer);
            _arrDrops.push(d);
        }
    }

    public function addDropItemNew(item:ResourceItem, p:Point):void {
        var d:DropItemObject = new DropItemObject();
        d.fillIt(item, p);
        _arrDrops.push(d);
    }

    public function addDropItemNewByResourceId(id:int, p:Point, count:int = 1):void {
        var it:ResourceItem;
        for (var i:int=0; i<count; i++) {
            it = new ResourceItem();
            it.fillIt(g.allData.getResourceById(id));
            addDropItemNew(it, p);
        }
    }

    public function releaseIt(f:Function = null, useJump:Boolean = true):void {   
        if (!_arrDrops.length) return;
        _callback = f;
        for (var i:int=0; i<_arrDrops.length; i++) {
            g.cont.addToTopGameContAnimation((_arrDrops[i] as DropObjectInterface).source);
            if (useJump) (_arrDrops[i] as DropObjectInterface).startJump(i%2, onFinish);
            else {
                (_arrDrops[i] as DropObjectInterface).callback = onFinish;
                (_arrDrops[i] as DropObjectInterface).flyIt(null, true);
            }
        }
    }
    
    private function onFinish(d:DropObjectInterface):void {
        //g.cont.removeFromTopGameContAnimation(d.source);
        g.cont.animationsResourceCont.removeChild(d.source);
        d.deleteIt();
        if (_callback!=null) _callback.apply();
    }


}
}
