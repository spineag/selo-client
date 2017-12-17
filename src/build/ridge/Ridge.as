/**
 * Created by user on 6/2/15.
 */
package build.ridge {
import analytic.AnalyticManager;

import build.WorldObject;
import com.junkbyte.console.Cc;

import data.BuildType;

import data.StructureDataResource;
import dragonBones.Slot;
import flash.geom.Point;
import hint.MouseHint;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;
import media.SoundConst;
import mouse.ToolsModifier;
import quest.ManagerQuest;
import resourceItem.newDrop.DropObject;
import resourceItem.newDrop.DropPartyResource;
import resourceItem.RawItem;
import resourceItem.ResourceItem;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import tutorial.TutsAction;
import utils.CSprite;
import windows.WindowsManager;

public class Ridge extends WorldObject{
    public static const EMPTY:int = 1;
    public static const GROW1:int = 2;
    public static const GROW2:int = 3;
    public static const GROW3:int = 4;
    public static const GROWED:int = 5;

    private var _dataPlant:StructureDataResource;
    private var _resourceItem:ResourceItem;
    private var _plant:PlantOnRidge;
    private var _plantSprite:Sprite;
    private var _stateRidge:int;
    private var _isOnHover:Boolean;
    public var lastBuyResource:Boolean;

    public function Ridge(_data:Object) {
        super(_data);
        if (!_data) {
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            Cc.error('no data for Ridge');
            return;
        }
        _plantSprite = new Sprite();
        _stateRidge = EMPTY;
        _isOnHover = false;
        _dataBuild.url = 'plant'; // temp
        _dataBuild.image = 'ridge'; // temp
        createAnimatedBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        if (!g.isAway) {
            _source.hoverCallback = onHover;
            _source.endClickCallback = onEndClick;
            _source.startClickCallback = onStartClick;
            _source.outCallback = onOut;
            updateRidgeHitArea();
            _source.nameIt = 'ridge';
        }
        _source.releaseContDrag = true;
        _armature.animation.stop();
        var sl:Slot = _armature.getSlot('craft');
        if (sl) {
            sl.displayList = null;
        } else {
            Cc.error('Ridge onCreateBuild: no slot CRAFT at ridge');
        }
        _source.addChild(_plantSprite);
    }

    public function stopDragMapDuringPlanting(isPlantingNow:Boolean):void { _source.releaseContDrag = !isPlantingNow; }
    override public function isContDrag():Boolean { return _source.isContDrag; }
    public function addChildPlant(s:Sprite):void { _plantSprite.addChild(s); }

    public function plantThePlant():void {
        g.soundManager.playSound(SoundConst.CRAFT_RAW_PLANT);
        fillPlant(g.allData.getResourceById(g.toolsModifier.plantId));
        g.managerPlantRidge.checkFreeRidges();
    }

    public function fillPlant(d:StructureDataResource, isFromServer:Boolean = false, timeWork:int = 0):void {
        if (_stateRidge != EMPTY) {
            Cc.error('Try to plant already planted ridge data.name: ' + d.name);
            return;
        }
        if (!d) {
            Cc.error('no data for fillPlant at Ridge');
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            return;
        }
        _stateRidge = GROW1;
        _dataPlant = d;
        _plant = new PlantOnRidge(this, _dataPlant);
        if (timeWork < _dataPlant.buildTime) {
            _plant.checkTimeGrowing(timeWork);
            if (!g.isAway) {
                _plant.activateRender();
                g.managerCats.onStartRidge(this);
            }
            _plant.checkStateRidge(false);
        } else {
            _stateRidge = GROWED;
            _plant.checkStateRidge();
        }
        if (!isFromServer) {
            g.userInventory.addResource(_dataPlant.id, -1);
            g.toolsModifier.updateCountTxt();
            var f1:Function = function (s:String):void {
                _plant.idFromServer = s;
            };
            g.server.rawPlantOnRidge(_dataPlant.id, _dbBuildingId, f1);
            var p:Point = new Point(_source.x, _source.y);
            p = _source.parent.localToGlobal(p);
            new RawItem(p, g.allData.atlas['resourceAtlas'].getTexture(_dataPlant.imageShop + '_icon'), 1, 0);
            var ob:Object;
            ob = {};
            ob.dbId = dbBuildingId;
            ob.plantId = _dataPlant.id;
            ob.state = _stateRidge;
            g.user.userDataCity.plants.push(ob);
            g.managerQuest.onActionForTaskType(ManagerQuest.RAW_PLANT, {id: _dataPlant.id});
        }
        updateRidgeHitArea();
    }

    public function craftThePlant():void {
        hideArrow();
        if (_stateRidge != GROWED) return;
        if (g.userInventory.currentCountInAmbar + 2 > g.user.ambarMaxCount){
            _source.filter = null;
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            if (!g.windowsManager.currentWindow){
                g.mouseHint.hideIt();
                g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, true);
            }
        } else {
            _stateRidge = EMPTY;
            var arr:Array = g.user.userDataCity.plants;
            for (var i:int = 0; i < arr.length; i++) {
                if (int(arr[i].dbId) == dbBuildingId) {
                    g.user.userDataCity.plants.splice(i,1);
                    break;
                }
            }

            g.soundManager.playSound(SoundConst.CRAFT_RAW_PLANT);
            _plant.onCraftPlant();
            _plant.checkStateRidge();
            _resourceItem = new ResourceItem();
            _resourceItem.fillIt(_dataPlant);
            g.managerQuest.onActionForTaskType(ManagerQuest.CRAFT_PLANT, {id:_dataPlant.id});
            var f1:Function = function():void {
                
            };

            var p:Point = new Point(0, 0);
            p = _source.localToGlobal(p);
            var d:DropObject = new DropObject();
            d.addDropItemNew(_resourceItem, p);
            d.addDropItemNew(_resourceItem, p);
            d.addDropXP(_resourceItem.craftXP, p);
            d.addDropXP(_resourceItem.craftXP, p);
            if (g.managerDropResources.checkDrop()) g.managerDropResources.createDrop(p.x, p.y, d);
            if (g.managerParty.eventOn && g.managerParty.typeParty == 5 && g.allData.atlas['partyAtlas'] && g.managerParty.levelToStart <= g.user.level && Math.random() <= .1)
                d.addDropPartyResource(p);
            d.releaseIt();

            onOut();
            g.managerAchievement.addResource(_resourceItem.resourceID);
            g.managerPlantRidge.onCraft(_plant.idFromServer);
            _plant = null;
        }
        if (g.tuts.isTuts && g.tuts.action == TutsAction.CRAFT_RIDGE) {
            if (_tutorialCallback != null) {
                _tutorialCallback.apply(null, [this]);
            }
        }
        g.managerPlantRidge.checkGrowedRidges();
    }

    override public function onHover():void {
        if(_isOnHover) return;
        if (g.selectedBuild) return;
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts) {
            if (_tutorialCallback == null) return;
            if ((g.tuts.action == TutsAction.NEW_RIDGE || g.tuts.action == TutsAction.PLANT_RIDGE) && g.tuts.isTutsBuilding(this)) {
                // nothing
            } else if (!g.tuts.isTutsBuilding(this) || _tutorialCallback == null) return;
        }
        if (g.isActiveMapEditor || g.isAway) return;
        super.onHover();
        _isOnHover = true;
        if (_stateRidge == GROWED) _plant.hoverGrowed();
        _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        if (_stateRidge == EMPTY && g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) {
        } else {
            if (g.toolsModifier.modifierType != ToolsModifier.NONE) return;
            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                    g.mouseHint.showMouseHint(MouseHint.CLOCK);
            } else if (_stateRidge == GROWED) {
                g.mouseHint.showMouseHint(MouseHint.SERP);
            }
        }
    }

    override public function onOut():void {
        if (!_isOnHover) return;
        g.timerHint.hideIt(true);
        if (g.toolsModifier.modifierType != ToolsModifier.CRAFT_PLANT) g.mouseHint.hideIt();
        if (_source) {
            super.onOut();
            _isOnHover = false;
            if (_source.filter) _source.filter.dispose();
            _source.filter = null;
        }
    }

    private function onStartClick():void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts && (!g.tuts.isTutsBuilding(this) || _tutorialCallback == null)) return;
        if (g.isActiveMapEditor || g.isAway) return;
        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            if (!g.tuts.isTuts) onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            } else {
                if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3 || _stateRidge == GROWED) {
                    g.toolsModifier.ridgeId = _dataPlant.id;
                }
                g.townArea.moveBuild(this);
            }
            return;
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {  g.toolsModifier.modifierType = ToolsModifier.NONE; return;
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            g.server.userBuildingFlip(_dbBuildingId, int(_flip), null);
            return;
        }
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED) {
            if (g.toolsModifier.plantId <= 0 || _stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                return;
            }
            if (_stateRidge == GROWED) { g.toolsModifier.modifierType = ToolsModifier.CRAFT_PLANT; return; }
            var arr:Array = g.user.userDataCity.plants;
            for (var i:int = 0; i < arr.length; i++) {
                if (int(arr[i].dbId) == dbBuildingId) {
                    Cc.error('this ridge have plant in data');
                    return;
                }
            }
            lastBuyResource = true;
            _source.filter = null;
            plantThePlant();
            if (g.tuts.isTuts && (g.tuts.action == TutsAction.PLANT_RIDGE || g.tuts.action == TutsAction.PLANT_RIDGE_2)) {
                if (_tutorialCallback != null) {
                    _tutorialCallback.apply(null, [this]);
                }
            } else {
                g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED_ACTIVE;
            }
        } else if (_stateRidge == GROWED) {
            if (g.tuts.isTuts && g.tuts.action != TutsAction.CRAFT_RIDGE) return;
            craftThePlant();
            g.timerHint.hideIt(true);
            if (!g.tuts.isTuts) g.toolsModifier.modifierType = ToolsModifier.CRAFT_PLANT;
        }
    }

    public function onEndClick():void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts) {
            if (g.tuts.action == TutsAction.PLANT_RIDGE && g.tuts.isTutsBuilding(this) && _tutorialCallback != null) {
                g.tuts.checkTutsCallback();
            } else if (g.tuts.action == TutsAction.PLANT_RIDGE_2 && g.tuts.isTutsBuilding(this) && _tutorialCallback != null) {

            } else if (g.tuts.action == TutsAction.NEW_RIDGE) {
//                if (g.selectedBuild != this) return;
            } else if (!g.tuts.isTutsBuilding(this) || _tutorialCallback == null) return;
        }
        if (g.isActiveMapEditor || g.isAway) return;
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) { g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED; return;
        } else if (g.toolsModifier.modifierType == ToolsModifier.CRAFT_PLANT) { g.toolsModifier.modifierType = ToolsModifier.NONE; return;
        } else if (g.toolsModifier.modifierType == ToolsModifier.ADD_NEW_RIDGE) {
            onOut();
            if (g.selectedBuild) {
                if (g.selectedBuild == this) {
                    g.toolsModifier.onTouchEnded();
                } else return;
            }
        } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {  g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) { // ничего не делаем вообще
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) { g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
            if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                if (g.tuts.isTuts) return;
                onOut();
                if (!lastBuyResource) {
                    if (g.timerHint.isShow) g.timerHint.managerHide(onClickCallbackWhenWork);
                     else g.timerHint.showIt(50, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y +_source.height/2 -  _plantSprite.height) /*_source.height/10) */* g.currentGameScale,_dataPlant.buildTime, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name,callbackSkip,onOut, true);
                }
                lastBuyResource = false;
            }
            if (_stateRidge == EMPTY) {
                onOut();
                if (g.tuts.isTuts && _tutorialCallback != null)  hideArrow();
                g.cont.moveCenterToXY(_source.x, _source.y - 80);
                _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
                g.windowsManager.openWindow(WindowsManager.WO_BUY_PLANT, onBuy, this);
            }
        }
    }

    private function onClickCallbackWhenWork():void {
        g.timerHint.showIt(50, g.cont.gameCont.x + _source.x * g.currentGameScale, g.cont.gameCont.y + (_source.y +_source.height/2 -  _plantSprite.height) /*_source.height/10) */* g.currentGameScale,_dataPlant.buildTime, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name,callbackSkip,onOut, true);
    }

    public function checkBuildRect(isEmpty:Boolean):void {
        if (isEmpty) _rect = _build.getBounds(_build);
        else _rect = _plantSprite.getBounds(_plantSprite);
    }

    private function onBuy():void {
        g.toolsModifier.plantId = _dataPlant.id;
        g.toolsModifier.modifierType = ToolsModifier.PLANT_SEED;
        g.managerPlantRidge.checkFreeRidges();
        if (_source.filter) _source.filter = null;
        if (g.tuts.isTuts && (g.tuts.action == TutsAction.PLANT_RIDGE || g.tuts.action == TutsAction.PLANT_RIDGE_2)) {
            if (_tutorialCallback != null) _tutorialCallback.apply(null, [this]);
        }
    }

    public function updateRidgeHitArea():void {
        if (_stateRidge == EMPTY) _hitArea = g.managerHitArea.getHitArea(_source, 'ridgeBuild', ManagerHitArea.TYPE_RIDGE);
        else _hitArea = g.managerHitArea.getHitArea(_source, 'ridgeBuild_' + String(_dataPlant.id) + '_' + String(_stateRidge), ManagerHitArea.TYPE_RIDGE, 2, 2);
        _source.registerHitArea(_hitArea);
    }

    public function get stateRidge():int { return _stateRidge; }
    public function get plant():PlantOnRidge { return _plant; }
    public function get isFreeRidge():Boolean { return _stateRidge == EMPTY; }

    public function set stateRidge(a:int):void {
        _stateRidge = a;
        if (_stateRidge == GROWED) {
            if (g.managerTips) g.managerTips.calculateAvailableTips();
            g.managerCats.onFinishRidge(this);
        }
        updateRidgeHitArea();
    }

    override public function clearIt():void {
        while (_plantSprite.numChildren) _plantSprite.removeChildAt(0);
        if (_plant) _plant.clearIt();
        _plant = null;
        onOut();
        _source.touchable = false;
        super.clearIt();
    }

    private function callbackSkip():void {
        _source.filter = null;
        _isOnHover = false;
        _plant.checkStateRidge(false);
        g.server.skipTimeOnRidge(_plant._timeToEndState, _dbBuildingId, null);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_PLANT_ID, info: _plant.dataPlant.id});
        _plant.renderSkip();
    }

    public function lockIt(v:Boolean):void {
        if (v) {
            if (_stateRidge != EMPTY) {
                _source.isTouchable = false;
            }
        } else {
            _source.isTouchable = true;
        }
    }

    public function checkAfterMove():void {
//        if (_plant)
//            g.managerPlantRidge.onRidgeFinishMove(_dataPlant.id, this);
    }

    override public function showArrow(t:Number=0):void {
        super.showArrow(t);
        if (_arrow) _arrow.scaleIt(.7);
    }

    public function forceGrowPlant():void {
        if (_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
            _plant.renderSkip();
        }
    }
}
}
