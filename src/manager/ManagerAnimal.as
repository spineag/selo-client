/**
 * Created by andy on 8/6/15.
 */
package manager {
import build.farm.Animal;
import build.farm.Farm;
import com.junkbyte.console.Cc;
import flash.geom.Point;
import heroes.HeroCat;
import media.SoundConst;

import mouse.ToolsModifier;

import windows.WindowsManager;

public class ManagerAnimal {
    private var _arrFarm:Array;  // все фермы юзера, которые стоят на поляне и построенны
    private var _tempPoint:Point;
    private var _arrAnimals:Array;
    public var activeFeedAnimalId:int = 0;

    private var g:Vars = Vars.getInstance();

    public function ManagerAnimal() {
        _tempPoint = new Point();
        var arr:Array = g.townArea.cityObjects;
        _arrFarm = [];
        for (var i:int = 0; i < arr.length; i++) {
            if (arr[i] is Farm) {
                _arrFarm.push(arr[i]);
            }
        }
    }

    public function onAddNewFarm(fa:Farm):void {
        if (g.isAway) return;
        if (_arrFarm.indexOf(fa) < 0) {
            _arrFarm.push(fa);
        }
    }

    public function addAnimal(ob:Object):void {
        var i:int;
        var curFarm:Farm;
        for (i = 0; i < _arrFarm.length; i++) {
            if (_arrFarm[i].dbBuildingId == int(ob.user_db_building_id)) {
                curFarm = _arrFarm[i];
                break;
            }
        }
        if (!curFarm) {
            Cc.error('no such Farm with dbId: ' + ob.user_db_building_id);
            return;
        }
        curFarm.addAnimal(true, ob);
    }

    public function onGoAwayCats(v:Boolean):void {
        if (_arrAnimals) {
            for (var i:int = 0; i < _arrAnimals.length; i++) {
                (_arrAnimals[i] as Animal).onGoAway(v);
            }
        }
    }

    public function onFarmStartMove(farmDbId:int):void {
        onGoAwayCats(true);
    }

    public function onFarmFinishMove(fa:Farm):void {
        onGoAwayCats(false);
    }

    public function getAllAnimals():Array {
        var arr:Array = [];
        for (var i:int=0; i<_arrFarm.length; i++) {
            arr = arr.concat((_arrFarm[i] as Farm).arrAnimals);
        }
        return arr;
    }

    public function getAllAnimalsById(id:int):Array {
        var arr:Array = [];
        var ans:Array;
        for (var i:int=0; i<_arrFarm.length; i++) {
            ans = (_arrFarm[i] as Farm).arrAnimals;
            if (ans[0] && (ans[0] as Animal).animalData.id == id) {
                arr = arr.concat(ans);
            }
        }
        return arr;
    }

    public function getAllHungryAnimalsForTipsWithPossibleForRaw():Array {
        var arr:Array = [];
        var ob:Object;
        for (var i:int=0; i<_arrFarm.length; i++) {
            if (!(_arrFarm[i] as Farm).isAnyCrafted) {
                ob = (_arrFarm[i] as Farm).dataAnimal;
                if (ob.id == 6 && g.userInventory.getCountResourceById(ob.idResourceRaw) > 1) {
                    arr = arr.concat((_arrFarm[i] as Farm).arrHungryAnimals);
                } else if (g.userInventory.getCountResourceById(ob.idResourceRaw) > 0) {
                    arr = arr.concat((_arrFarm[i] as Farm).arrHungryAnimals);
                }
            } 
        }
        return arr;
    }

    public function onStartFeedAnimal(isStart:Boolean):void {
        if (g.tuts.isTuts) return;
        if (!activeFeedAnimalId && isStart) {
            Cc.error('startFeedAnimal:: activeFeedAnimalId == 0');
            return;
        }
        g.cont.contentCont.releaseContDrag = !isStart;
        g.cont.tailCont.releaseContDrag = !isStart;
        g.cont.deleteDragPoint();
        if (isStart) {
            _arrAnimals = getAllAnimalsById(activeFeedAnimalId);
            g.gameDispatcher.addEnterFrame(checkForFeeding);
        } else {
            activeFeedAnimalId = 0;
            _arrAnimals.length = 0;
            g.gameDispatcher.removeEnterFrame(checkForFeeding);
        }
    }

    public function checkPositionAnimals():void {
        return;
        for (var i:int = 0; i < _arrFarm.length; i++) {
            for (var j:int = 0; j < _arrFarm[i].arrAnimals.length; j++) {
                if (j + 1 < _arrFarm[i].arrAnimals.length) {
                    for (var k:int = j+1; k < _arrFarm[i].arrAnimals.length; k++) {
                            if (((_arrFarm[i].arrAnimals[j].source.x - _arrFarm[i].arrAnimals[k].source.x) <= _arrFarm[i].arrAnimals[k].source.width && (_arrFarm[i].arrAnimals[j].source.x - _arrFarm[i].arrAnimals[k].source.x) >= - _arrFarm[i].arrAnimals[k].source.width) &&
                                    ((_arrFarm[i].arrAnimals[j].source.y - _arrFarm[i].arrAnimals[k].source.y) <= _arrFarm[i].arrAnimals[k].source.height  && (_arrFarm[i].arrAnimals[j].source.y - _arrFarm[i].arrAnimals[k].source.y) >= - _arrFarm[i].arrAnimals[k].source.height)) {
                            }
                    }
                }
            }
        }
    }

    private function checkForFeeding():void {
        _tempPoint.x = g.ownMouse.mouseX;
        _tempPoint.y = g.ownMouse.mouseY;
        for (var i:int=0; i<_arrAnimals.length; i++) {
            if ((_arrAnimals[i] as Animal).state == Animal.HUNGRY) {  // используем ИФ, ибо тварь могли только что покормить уже, но она ведь есть все еще в масиве
                if (isMouseUnderAnimal(_arrAnimals[i] as Animal)) {
                    (_arrAnimals[i] as Animal).feedAnimal();
                    break;
                }
            } else {
                _arrAnimals.splice(i, 1);
                i--;
            }
        }
        if (!_arrAnimals.length) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        }
    }

    private var pTemp:Point = new Point();
    private var rectTemp:flash.geom.Rectangle;
    public function isMouseUnderAnimal(an:Animal):Boolean {
        rectTemp = an.rect;
        pTemp.x = 0;
        pTemp.y = 0;
        pTemp = an.source.localToGlobal(pTemp);
        if (_tempPoint.x > pTemp.x+rectTemp.x && _tempPoint.x < pTemp.x+rectTemp.x+rectTemp.width &&
                _tempPoint.y > pTemp.y+rectTemp.y && _tempPoint.y < pTemp.y+rectTemp.y+rectTemp.height) {
            return true;
        } else return false;
    }

}
}
