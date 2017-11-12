/**
 * Created by andy on 10/20/17.
 */
package additional.pets {
import build.petHouse.PetHouse;
import com.junkbyte.console.Cc;

import data.BuildType;
import data.StructureDataPet;

import flash.geom.Point;

import heroes.BasicCat;

import heroes.HeroCat;

import manager.AStar.AStar;

import manager.Vars;
import manager.ownError.ErrorConst;

import mouse.ToolsModifier;

import windows.WindowsManager;

public class ManagerPets {
    public const PET_DOG:int = 1;
    public const PET_DOG_SMALL:int = 2;
    public const PET_CAT:int = 3;
    public const PET_CAT_SMALL:int = 4;
    public const PET_RABBIT:int = 5;
    public const PET_DEER:int = 6;

    public static const STATE_RAW_WALK:int = 1; // walking anythere after raw
    public static const STATE_HUNGRY_WALK:int = 2; // is hungry and walking anywhere
    public static const STATE_WAIT_CRAFT_STOP_RUN:int = 3;  // sit near house

    private var g:Vars = Vars.getInstance();
    private var _arrPets:Array;
    private var _rawPets:Array;
    
    public function ManagerPets() {
        _arrPets = [];
        _rawPets = [];
        g.directServer.getDataPet(onGetData);
    }

    private function onGetData():void { g.directServer.getUserPet(onGetUserPets); }

    private function onGetUserPets(d:Object):void {
        var pet:PetMain;
        var petData:StructureDataPet;
        var pHouse:PetHouse;
        for (var i:int = 0; i < d.message.length; i++) {
            petData = g.allData.getPetById(int(d.message[i].id));
            pHouse = getPetHouseByDbId(petData.houseId, int(d.message[i].house_db_id));
            pet = getNewPetFromData(petData);
            if (pHouse) {
                pet.dbId = int(d.message[i].id);
                pet.hasNewEat = Boolean(int(d.message[i].has_new_eat) == 1);
                pHouse.addPet(pet);
                pet.petHouse = pHouse;
                pet.analyzeTimeEat(int(d.message[i].time_eat));
                _arrPets.push(pet);
                var p:Point = new Point(pHouse.posX, pHouse.posY);
                p = getDirectPointForHouse(p, pHouse.getMiskaForPet(pet).number);
                pet.posX = p.x;
                pet.posY = p.y;
                g.townArea.addPet(pet);
                chooseRandomAct(pet);
            } else Cc.error('no pet house: ' + d.message[i].house_db_id);
        }
    }

    private function getPetHouseByDbId(id:int, dbId:int):PetHouse {
        var ar:Array  = g.townArea.getCityObjectsById(id);
        for (var i:int=0; i<ar.length; i++) {
            if ((ar[i] as PetHouse).dbBuildingId == dbId) return ar[i];
        }
        return null;
    }

    private function getRandomPointForHouse(p:Point):Point {
        var n:int = int(Math.random()*4);
        switch (n) {
            case 0: break;
            case 1: p.x += 2; break;
            case 2: p.y += 2; break;
            case 3: p.x += 2; p.y += 2; break;
        }
        return p;
    }

    private function getDirectPointForHouse(p:Point, pos:int):Point {
        switch (pos) {
            case 1: p.x += 2; break;
            case 2: p.y += 2; break;
            case 3: p.x += 2; p.y += 2; break;
        }
        return p;
    }

    public function onBuyNewPet(petId:int):void {
        var dPet:StructureDataPet = g.allData.getPetById(petId);
        var arr:Array = g.townArea.getCityObjectsById(dPet.houseId);
        var pHouse:PetHouse;
        for (var i:int=0; i<arr.length; i++) {
            if ((arr[i] as PetHouse).hasFreePlace) {
                pHouse = arr[i];
                break;
            }
        }
        if (!pHouse) {
            Cc.error('ManagerPets onBuyNewPet:: No house for pet with id: ' + petId);
            return;
        }
        var pet:PetMain = getNewPetFromData(dPet);
        pet.state = STATE_HUNGRY_WALK;
        _arrPets.push(pet);
        pHouse.addPet(pet);
        var p:Point = new Point(pHouse.posX, pHouse.posY);
        p = getRandomPointForHouse(p);
        pet.posX = p.x;
        pet.posY = p.y;
        pet.petHouse = pHouse;
        pet.analyzeTimeEat(0);
        g.townArea.addPet(pet);
        g.directServer.addNewPet(pet, pHouse.dbBuildingId, null);
        chooseRandomAct(pet);
    }

    private function getNewPetFromData(dPet:StructureDataPet):PetMain {
        var pet:PetMain;
        switch (dPet.petType) {
            case PET_DOG:       pet = new DogPet(dPet);         break;
            case PET_DOG_SMALL: pet = new SmallDogPet(dPet);    break;
            case PET_CAT:       pet = new CatPet(dPet);         break;
            case PET_CAT_SMALL: pet = new SmallCatPet(dPet);    break;
            case PET_RABBIT:    pet = new RabbitPet(dPet);      break;
            case PET_DEER:      pet = new DeerPet(dPet);        break;
        }
        return pet;
    }

    public function addPetToTimer(pet:PetMain):void {
        if (_rawPets.length == 0) g.gameDispatcher.addToTimer(onTimer);
        _rawPets.push(pet);
    }

    private function onTimer():void {
        for (var i:int=0; i<_rawPets.length; i++) {
            (_rawPets[i] as PetMain).updateTimeLeft();
        }
    }

    public function onPetCraftReady(pet:PetMain):void {
        if (_rawPets.indexOf(pet) > -1) _rawPets.removeAt(_rawPets.indexOf(pet));
        if (!_rawPets.length) g.gameDispatcher.removeFromTimer(onTimer);
        pet.stopAnimation();
        if (pet.petHouse) pet.petHouse.onPetCraftReady(pet);
        var point:Point = new Point(pet.petHouse.posX, pet.petHouse.posY);
        point = getDirectPointForHouse(point, pet.petHouse.getMiskaForPet(pet).number);
        goPetToPoint(pet, point, onPetCraftReadyAtHouse, pet);
//        if (pet.hasNewEat) pet.petHouse.getMiskaForPet(pet).showEat(true);  ???
//        else pet.petHouse.getMiskaForPet(pet).showEat(false);
    }

    private function onPetCraftReadyAtHouse(pet:PetMain):void {
        chooseRandomAct(pet);
    }

    public function onCraftHouse(pet:PetMain):void {
        pet.onGetCraft();
        g.directServer.craftUserPet(pet, null);
        chooseRandomAct(pet);
    }

    public function onRawPet(p:PetMain, pHouse:PetHouse):void {
        g.directServer.rawUserPet(p, null);
        if (!p.hasNewEat) {
            var f1:Function = function (p:PetMain):void {
                if (p.hasNewEat) pHouse.getMiskaForPet(p).showEat(true);
                    else pHouse.getMiskaForPet(p).showEat(false);
                chooseRandomAct(p);
            };
            var point:Point = new Point(pHouse.posX, pHouse.posY);
            point = getDirectPointForHouse(point, pHouse.getMiskaForPet(p).number);
            p.stopAnimation();
            goPetToPoint(p, point, f1);
        }
    }

    public function chooseRandomAct(pet:PetMain):void {
        if (!pet.armature) return;
        if (pet.state == STATE_HUNGRY_WALK || pet.state == STATE_RAW_WALK) {
            if (Math.random() > .3) {
                var p:Point = g.townArea.getRandomFreeCell();
                goPetToPoint(pet, p, chooseRandomAct);
            } else pet.playPlayAnimation(chooseRandomAct);
        } else pet.playPlayAnimation(chooseRandomAct);
    }

    public function goPetToPoint(pet:PetMain, p:Point, callback:Function = null, ...callbackParams):void {
        var f2:Function = function ():void {
            pet.flipIt(false);
            pet.showFront(true);
//            pet.walkAnimation();
            var fT:Function = pet.walkCallback;
            var arrT:Array = pet.walkCallbackParams;
            pet.walkCallback = null;
            pet.walkCallbackParams = [];
            if (fT != null) fT.apply(null, [pet].concat(arrT));
        };

        var f1:Function = function (arr:Array):void {
            try {
                pet.showFront(true);
                pet.walkAnimation();
                pet.goWithPath(arr, f2);
            } catch (e:Error) {
                Cc.error('ManagerCats goCatToPoint f1 error: ' + e.errorID + ' - ' + e.message);
                Cc.stackch('error', 'ManagerCats goCatToPoint f1', 10);
                g.errorManager.onGetError(ErrorConst.ManagerCats1, true);
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerCats goCat1');
            }
        };

        try {
            if (!pet) {
                Cc.error('ManagerPets goPetToPoint error: pet == null');
                g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerPet goPetToPoint pet == null');
                return;
            }
            pet.stopAnimation();
            if (pet.posX == p.x && pet.posY == p.y) {
                pet.flipIt(false);
                pet.showFront(true);
                if (callback != null) callback.apply(null, [pet].concat(callbackParams));
                return;
            }
            pet.walkCallback = callback;
            pet.walkCallbackParams = callbackParams;
            var a:AStar = new AStar();
            a.getPath(pet.posX, pet.posY, p.x, p.y, f1);
        } catch (e:Error) {
            Cc.error('ManagerPets goPetToPoint error: ' + e.errorID + ' - ' + e.message);
            Cc.stackch('error', 'ManagerPet goPetToPoint', 10);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'ManagerPets goPetToPoint');
        }
    }
}
}
