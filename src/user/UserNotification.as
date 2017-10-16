/**
 * Created by andy on 10/13/17.
 */
package user {
import data.BuildType;
import data.StructureDataAnimal;
import data.StructureDataBuilding;
import manager.Vars;
import utils.Utils;

public class UserNotification {
    private var _decor:Array; // not send to server, only in client
    private var _plant:Array;
    private var _fabrica:Array;
    private var _farm:Array;
    private var _animal:Array;
    private var _tree:Array;
    private var _isNewRidge:Boolean = false;
    private var _isNewDecor:Boolean = false;  // only for saving on server
    private var g:Vars = Vars.getInstance();

    public function UserNotification() {
        _decor = [];
        _plant = [];
        _fabrica = [];
        _farm = [];
        _animal = [];
        _tree = [];
    }

    public function isNewFabricId(id:int):Boolean { return Boolean(_fabrica.indexOf(id) > -1);  }
    public function isNewFarmId(id:int):Boolean { return Boolean(_farm.indexOf(id) > -1);  }
    public function isNewAnimalId(id:int):Boolean { return Boolean(_animal.indexOf(id) > -1);  }
    public function isNewDecorId(id:int):Boolean { return Boolean(_decor.indexOf(id) > -1);  }
    public function isNewTreeId(id:int):Boolean { return Boolean(_tree.indexOf(id) > -1);  }
    public function isNewPlantId(id:int):Boolean { return Boolean(_plant.indexOf(id) > -1);  }
    public function get isNewRidge():Boolean { return _isNewRidge;  }
    public function countNewFabric():int { return _fabrica.length;  }
    public function countNewFarm():int { return _farm.length;  }
    public function countNewTree():int { return _tree.length;  }
    public function countNewDecor():int { return _decor.length;  }
    public function countNewAnimal():int { return _animal.length;  }

    public function checkOnNewLevel():void {
        var arR:Array = g.allData.building;
        var level:int = g.user.level;
        var arAddedGroupIds:Array = [];
        _decor = [];
        _plant = [];
        _fabrica = [];
        _farm = [];
        _animal = [];
        _tree = [];
        for (var i:int = 0; i < arR.length; i++) {
            if ((arR[i] as StructureDataBuilding).isNewAtLevel(level)) {
                if ((arR[i] as StructureDataBuilding).buildType  == BuildType.TREE) _tree.push((arR[i] as StructureDataBuilding).id);
                else if ((arR[i] as StructureDataBuilding).buildType  == BuildType.FARM) _farm.push((arR[i] as StructureDataBuilding).id);
                else if ((arR[i] as StructureDataBuilding).buildType  == BuildType.FABRICA) _fabrica.push((arR[i] as StructureDataBuilding).id);
                else if (arR[i].buildType  == BuildType.DECOR || arR[i].buildType  == BuildType.DECOR_ANIMATION || arR[i].buildType  == BuildType.DECOR_FENCE_ARKA
                        || arR[i].buildType  == BuildType.DECOR_FENCE_GATE || arR[i].buildType  == BuildType.DECOR_FULL_FENСE || arR[i].buildType  == BuildType.DECOR_POST_FENCE
                        || arR[i].buildType  == BuildType.DECOR_POST_FENCE_ARKA || arR[i].buildType  == BuildType.DECOR_TAIL) {
                    if (arAddedGroupIds.indexOf((arR[i] as StructureDataBuilding).group) == -1) { // need check decor group before add
                        arAddedGroupIds.push((arR[i] as StructureDataBuilding).group);
                        _decor.push((arR[i] as StructureDataBuilding).id);
                    }
                }
            }
        }
        arR = g.allData.animal;
        for (i=0; i<arR.length; i++) {
            if (_farm.indexOf((arR[i] as StructureDataAnimal).buildId) > -1) _animal.push((arR[i] as StructureDataAnimal).id);
        }
        arR = g.allData.resource;
        for (i = 0; i < arR.length; i++) {
            if (arR[i].buildType == BuildType.PLANT && arR[i].blockByLevel == level) {
                _plant.push(arR[i]);
            }
        }
        if (g.dataLevel.objectLevels[g.user.level].ridgeCount > 0) _isNewRidge = true;

        updateNotification();
    }

    public function onGetFromServer(st:String):void {
        var ar:Array = st.split('|');
        if (ar[0] != '') {
            _plant = ar[0].split('&');
            _plant = Utils.intArray(_plant);
        }
        if (ar[1] != '') {
            _fabrica = ar[1].split('&');
            _fabrica = Utils.intArray(_fabrica);
        }
        if (ar[2] != '') {
            _farm = ar[2].split('&');
            _farm = Utils.intArray(_farm);
        }
        if (ar[3] != '') {
            _animal = ar[3].split('&');
            _animal = Utils.intArray(_animal);
        }
        if (ar[4] != '') {
            _tree = ar[4].split('&');
            _tree = Utils.intArray(_tree);
        }
        _isNewRidge = Boolean(ar[5] == '1');
        _isNewDecor = Boolean(ar[6] == '1');
    }

    public function onGameLoad():void {
        if (_isNewDecor) {
            var arAddedGroupIds:Array = [];
            var arR:Array = g.allData.building;
            for (var i:int=0; i<arR.length; i++) {
                if ((arR[i] as StructureDataBuilding).isNewAtLevel(g.user.level) && (arR[i].buildType == BuildType.DECOR || arR[i].buildType == BuildType.DECOR_ANIMATION
                        || arR[i].buildType == BuildType.DECOR_FENCE_GATE || arR[i].buildType == BuildType.DECOR_FULL_FENСE || arR[i].buildType == BuildType.DECOR_POST_FENCE
                        || arR[i].buildType == BuildType.DECOR_FENCE_ARKA|| arR[i].buildType == BuildType.DECOR_POST_FENCE_ARKA || arR[i].buildType == BuildType.DECOR_TAIL)) {
                    if (arAddedGroupIds.indexOf((arR[i] as StructureDataBuilding).group) == -1) { // need check decor group before add
                        arAddedGroupIds.push((arR[i] as StructureDataBuilding).group);
                        _decor.push((arR[i] as StructureDataBuilding).id);
                    }
                }
            }
        }
        if (g.bottomPanel) g.bottomPanel.updateNotification();
    }

    public function onReleaseNewPlant(id:int):void {
        if (_plant.indexOf(id) > -1) {
            _plant.removeAt(_plant.indexOf(id));
            updateNotification();
        }
    }

    public function onReleaseNewFabrica(id:int):void {
        if (_fabrica.indexOf(id) > -1) {
            _fabrica.removeAt(_fabrica.indexOf(id));
            updateNotification();
        }
    }

    public function onReleaseNewTree(id:int):void {
        if (_tree.indexOf(id) > -1) {
            _tree.removeAt(_tree.indexOf(id));
            updateNotification();
        }
    }

    public function onReleaseNewFarm(id:int):void {
        if (_farm.indexOf(id) > -1) {
            _farm.removeAt(_farm.indexOf(id));
            updateNotification();
        }
    }

    public function onReleaseNewAnimal(id:int):void {
        if (_animal.indexOf(id) > -1) {
            _animal.removeAt(_animal.indexOf(id));
            updateNotification();
        }
    }

    public function onReleaseRidge():void {
        _isNewRidge = false;
        updateNotification();
    }

    public function onReleaseDecor():void {
        _isNewDecor = false;
        _decor.length = 0;
        updateNotification();
    }

    public function updateNotification():void {
        if (_decor.length) _isNewDecor = true;
        g.bottomPanel.updateNotification();
        var ar:Array = [];
        ar.push(_plant.join('&'));
        ar.push(_fabrica.join('&'));
        ar.push(_farm.join('&'));
        ar.push(_animal.join('&'));
        ar.push(_tree.join('&'));
        ar.push(int(_isNewRidge));
        ar.push(int(_isNewDecor));
        g.directServer.updateUserNotification(ar.join('|'), null);
    }

    public function get allNotificationsCount():int {
        var n:int = _fabrica.length + _farm.length + _animal.length + _tree.length + _decor.length;
        if (_isNewRidge) n++;
        return n;
    }

}
}
