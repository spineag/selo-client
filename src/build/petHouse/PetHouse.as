/**
 * Created by andy on 10/21/17.
 */
package build.petHouse {
import additional.pets.ManagerPets;
import additional.pets.PetMain;
import build.WorldObject;
import com.junkbyte.console.Cc;
import data.BuildType;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;
import mouse.ToolsModifier;
import quest.ManagerQuest;
import resourceItem.CraftItem;
import resourceItem.RawItem;
import resourceItem.ResourceItem;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import utils.TimeUtils;
import windows.WindowsManager;
import windows.shop_new.WOShopNew;

public class PetHouse extends WorldObject {
    private var _isOnHover:Boolean;
    private var _arrPets:Array;
    private var _arrCraftedItems:Array;
    private var _miska1:Miska;
    private var _miska2:Miska;
    private var _miska3:Miska;
    private var _petsCont:Sprite;

    public function PetHouse(data:Object) {
        super(data);
        _arrCraftedItems = [];
        _arrPets = [];
        _craftSprite = new Sprite();
        if (g.isAway) g.cont.craftAwayCont.addChild(_craftSprite);
            else g.cont.craftCont.addChild(_craftSprite);
        createAnimatedBuild(onCreateBuild);
        _source.releaseContDrag = true;
        if (!g.isAway) _source.endClickCallback = onClick;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
        _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.image, ManagerHitArea.TYPE_CREATE);
        _source.registerHitArea(_hitArea);
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        stopAnimation();
        if (_source) {
            _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.url, ManagerHitArea.TYPE_CREATE);
            _source.registerHitArea(_hitArea);
        }
        if (_arrCraftedItems.length) _craftSprite.visible = true;
        _craftSprite.x = _source.x;
        _craftSprite.y = -50*g.scaleFactor + _source.y;

        _miska1 = new Miska(_armature, 1);
        if (_dataBuild.maxAnimalsCount == 2) {
            _miska2 = new Miska(_armature, 3);
            _miska2.number = 2;
        } else if (_dataBuild.maxAnimalsCount == 3) {
            _miska2 = new Miska(_armature, 2);
            _miska3 = new Miska(_armature, 3);
        }
        _petsCont = new Sprite();
        _source.addChild(_petsCont);
        _petsCont.touchable = false;
    }

    public function get arrCraftedItems():Array { return _arrCraftedItems; }
    public function get isAnyCrafted():Boolean { return _arrCraftedItems.length > 0; }
    public function get arrPets():Array { return _arrPets; }
    public function get hasFreePlace():Boolean { return Boolean(_arrPets.length < _dataBuild.maxAnimalsCount); }
    public function get innerPetX1():int { return -40 * g.scaleFactor; }
    public function get innerPetY1():int { return 22 * g.scaleFactor; }
    public function get innerPetX2():int { return -42 * g.scaleFactor; }
    public function get innerPetY2():int { return 66 * g.scaleFactor; }
    public function get innerPetX3():int { return 44 * g.scaleFactor; }
    public function get innerPetY3():int { return 66 * g.scaleFactor; }

    private function getFreeMiska():Miska {
        if (_miska1 && !_miska1.pet) return _miska1;
        if (_miska2 && !_miska2.pet) return _miska2;
        if (_miska3 && !_miska3.pet) return _miska3;
        return null;
    }

    public function getMiskaForPet(pet:PetMain):Miska {
        if (pet == _miska1.pet) return _miska1;
        if (_miska2 && pet == _miska2.pet) return _miska2;
        if (_miska3 && pet == _miska3.pet) return _miska3;
        return null;
    }
    
    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts) return;
        if (g.isActiveMapEditor) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                _craftSprite.visible = false;
                g.townArea.moveBuild(this);
                g.timerHint.hideIt();
            }
            return;
        }
        if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            onOut();
            g.townArea.deleteBuild(this);
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            g.server.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_source.wasGameContMoved) {
                onOut();
                return;
            }
            var p:PetMain;
            if (_arrCraftedItems.length) {
                if (g.userInventory.currentCountInSklad + _arrCraftedItems[0].count > g.user.skladMaxCount) {
                    g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, false);
                } else {
                    g.managerQuest.onActionForTaskType(ManagerQuest.CRAFT_PRODUCT, {id:(_arrCraftedItems[0] as CraftItem).resourceId});
                    (_arrCraftedItems.pop() as CraftItem).releaseIt();
                    p = getCraftedPet();
                    if (p) g.managerPets.onCraftHouse(p);
                }
            } else {
                p = getPetWithOutEat();
                if (!p) p = getPetWithOutNewEat();
                if (p) {
                    if (g.userInventory.getCountResourceById(p.petData.eatId) <= 0)
                        g.windowsManager.openWindow(WindowsManager.WO_NO_RESOURCES, onClickForRawPet, 'raw_pet', {pet: p});
                    else {
                        g.petHint.showIt(_source.height,g.cont.gameContX + _source.x * g.currentGameScale, g.cont.gameContY + (_source.y - _source.height/3) * g.currentGameScale, 
                                p.petData.eatId, _dataBuild.name, onClickForRawPet, p);
                    }
                } else {
                    g.user.shiftShop = 0;
                    g.user.decorShop = false;
                    g.user.shopTab = WOShopNew.ANIMAL;
                    g.windowsManager.openWindow(WindowsManager.WO_SHOP_NEW, null, WOShopNew.ANIMAL);
                }
            }
        }
    }

    private function onClickForRawPet(p:PetMain):void {
        if (p.state == ManagerPets.STATE_HUNGRY_WALK) {
            p.state = ManagerPets.STATE_RAW_WALK;
            p.hasNewEat = false;
            p.analyzeTimeEat(TimeUtils.currentSeconds);
        } else if (p.state == ManagerPets.STATE_RAW_WALK) p.hasNewEat = true;
        getMiskaForPet(p).showEat(true);
        g.managerPets.onRawPet(p, this);
                    // animation of uploading resources to petHouse
        var point:Point = new Point();
        point = _source.localToGlobal(point);
        var obj:Object;
        var texture:Texture;
        obj = g.allData.getResourceById(p.petData.eatId);
        if (obj.buildType == BuildType.PLANT)  texture = g.allData.atlas['resourceAtlas'].getTexture(obj.imageShop + '_icon');
            else texture = g.allData.atlas[obj.url].getTexture(obj.imageShop);
        new RawItem(point, texture, 1, 0);
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        if (_isOnHover) return;
        super.onHover();
        if (g.isAway) { g.hint.showIt(_dataBuild.name); return; }
        if (g.tuts.isTuts && !g.tuts.isTutsBuilding(this)) return;
        if (g.isActiveMapEditor) return;
        if (!_isOnHover) _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        _isOnHover = true;
        g.hint.showIt(_dataBuild.name);
        var fEndOver:Function = function(e:Event=null):void {
            _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
            _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            stopAnimation();
        };
        _armature.addEventListener(EventObject.COMPLETE, fEndOver);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
        _armature.animation.gotoAndPlayByFrame('over');
    }

    override public function onOut():void {
        if (!_isOnHover) return;
        super.onOut();
        if (g.isAway) { g.hint.hideIt();  return;  }
        if (_source.filter) _source.filter.dispose();
        _source.filter = null;
        _isOnHover = false;
        g.hint.hideIt();
        stopAnimation();
    }

    public function addPet(pet:PetMain):void {
        if (_arrPets.indexOf(pet) > -1) {
            Cc.error('double add pet for pet: ' + pet.petData.id);
            return;
        }
        _arrPets.push(pet);
        var miska:Miska = getFreeMiska();
        if (miska) {
            miska.pet = pet;
            pet.positionAtHouse = miska.number;
        } else Cc.error('no free Miska for pet: ' + pet.petData.id);
    }
    
    public function removePet(p:PetMain):void {
        if (_arrPets.indexOf(p) > -1) _arrPets.removeAt(_arrPets.indexOf(p));
        var miska:Miska = getMiskaForPet(p);
        if (miska) {
            miska.pet = null;
            p.positionAtHouse = 0;
        }
    }

    public function onPetCraftReady(pet:PetMain):void {
        var rItem:ResourceItem = new ResourceItem();
        rItem.fillIt(g.allData.getResourceById(pet.petData.craftId));
        _craftSprite.visible = true;
        var craftItem:CraftItem = new CraftItem(0, 0, rItem, _craftSprite, 1, useCraftedResource, true);
        _arrCraftedItems.push(craftItem);
        craftItem.addParticle();
        craftItem.animIt();
    }

    private function useCraftedResource(item:ResourceItem, craftItem:CraftItem):void {
        _arrCraftedItems.splice(_arrCraftedItems.indexOf(item), 1);
        var p:PetMain = getCraftedPet();
        if (p) g.managerPets.onCraftHouse(p);
    }

    public function getCraftedPet():PetMain {
        for (var i:int=0; i<_arrPets.length; i++) {
            if ((_arrPets[i] as PetMain).state == ManagerPets.STATE_SLEEP) return _arrPets[i];
        }
        return null;
    }

    public function getPetWithOutEat():PetMain {
        for (var i:int=0; i<_arrPets.length; i++) {
            if ((_arrPets[i] as PetMain).state == ManagerPets.STATE_HUNGRY_WALK) return _arrPets[i];
        }
        return null;
    }

    public function getPetWithOutNewEat():PetMain {
        for (var i:int=0; i<_arrPets.length; i++) {
            if (!(_arrPets[i] as PetMain).hasNewEat) return _arrPets[i];
        }
        return null;
    }

    override public function clearIt():void {
        onOut();
        if (_armature) WorldClock.clock.remove(_armature);
        if (_miska1) _miska1.deleteIt();
        if (_miska2) _miska2.deleteIt();
        if (_miska3) _miska3.deleteIt();
        _miska1 = _miska2 = _miska3 = null;
        _arrPets.length = 0;
        _arrCraftedItems.length = 0;
        _source.touchable = false;
        _arrPets.length = 0;
        super.clearIt();
    }

    private function stopAnimation():void {if (_armature) _armature.animation.gotoAndStopByFrame('idle'); }

    public function showPetAnimateEat(p:PetMain, f:Function):void {
        if (_petsCont) {
            getMiskaForPet(p).showEat(true);
            switch (p.positionAtHouse) {
                case 1: p.source.x = p.innerPosX1; p.source.y = p.innerPosY1; p.animation.flipIt(false); break;
                case 2: if (_dataBuild.maxAnimalsCount == 2) { p.source.x = p.innerPosX2; p.source.y = p.innerPosY2; p.animation.flipIt(true); }
                        else if (_dataBuild.maxAnimalsCount == 3) { p.source.x = p.innerPosX3; p.source.y = p.innerPosY3; p.animation.flipIt(false); }
                    break;
                case 3: p.source.x = p.innerPosX3; p.source.y = p.innerPosY3; p.animation.flipIt(false); break;
            }
            _petsCont.addChild(p.source);

            var fEnd:Function = function():void {
                if (p.hasNewEat) getMiskaForPet(p).showEat(true);
                    else getMiskaForPet(p).showEat(false);
                _petsCont.removeChild(p.source);
                if (f != null) f.apply(null, [p]);
            };
            p.animation.eatAnimation(fEnd);
        } else {
            Cc.error('no _petsCont for petHouse id: ' + _dataBuild.id);
            if (f!=null) f.apply(null, [p]);
        }
    }
}
}

import additional.pets.PetMain;
import dragonBones.Armature;
import dragonBones.Slot;
import starling.display.DisplayObject;

internal class Miska {
    private var _miska:DisplayObject;
    private var _eat:DisplayObject;
    private var _number:int;
    private var _pet:PetMain;
    private var _isEat:Boolean;
    private var _arma:Armature;

    public function Miska(arma:Armature, n:int) {
        _isEat = false;
        _arma = arma;
        _number = n;
        _pet = null;
        var b:Slot = _arma.getSlot('plate_' + String(n) + '_free');
        if (b && b.displayList.length) {
            _miska = b.displayList[0] as DisplayObject;
            if (_miska) _miska.visible = false;
        }
        b = _arma.getSlot('plate_' + String(n) + '_eat');
        if (b && b.displayList.length) {
            _eat = b.displayList[0] as DisplayObject;
            if (_eat) _eat.visible = false;
        }
    }

    public function set number(n:int):void { _number = n; }
    public function get number():int { return _number; }
    public function get pet():PetMain { return _pet; } // === isFree
    public function get isEat():Boolean { return _isEat; }
    public function get isCreate():Boolean { return _miska != null; }

    public function set pet(p:PetMain):void {
        _pet = p;
        if (_miska) _miska.visible = true;
    }

    public function showEat(v:Boolean = true):void { 
        _isEat = v;
        if (_eat) _eat.visible = v;
    }

    public function deleteIt():void {
        _miska.dispose();
        _eat.dispose();
        _arma = null;
    }
}
