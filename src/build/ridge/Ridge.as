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

import flash.display.Bitmap;
import flash.geom.Point;
import hint.MouseHint;
import manager.ManagerFilters;
import manager.ManagerPartyNew;
import manager.ManagerPartyNew;
import manager.hitArea.ManagerHitArea;
import media.SoundConst;
import mouse.ToolsModifier;
import quest.ManagerQuest;
import resourceItem.newDrop.DropObject;
import resourceItem.newDrop.DropPartyResource;
import resourceItem.RawItem;
import resourceItem.ResourceItem;

import social.SocialNetworkEvent;

import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.textures.Texture;
import starling.utils.Color;
import tutorial.TutsAction;

import user.Friend;
import user.Someone;

import utils.CSprite;
import utils.MCScaler;

import windows.WOComponents.HintBackground;
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
    private var _srcParty:Sprite;
    private var _person:Someone;

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
        if (!g.isAway || g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_SKIP_PLANT_FRIEND) {
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

    public function fillPlant(d:StructureDataResource, isFromServer:Boolean = false, timeWork:int = 0, friend_id:String = ''):void {
        if (_stateRidge != EMPTY) {
            if (!g.managerParty || g.managerParty.eventOn && g.managerParty.typeParty != ManagerPartyNew.EVENT_SKIP_PLANT_FRIEND) {
                Cc.error('Try to plant already planted ridge data.name: ' + d.name);
                return;
            } else {
                _plant.clearIt();
                clearSrcParty();
            }
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
                if (_plant) _plant.idFromServer = s;
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
        if (int(friend_id) > 0) createSrcParty(friend_id);
    }

    private function createSrcParty(friend_id:String):void {
        _person = new Someone();
        _person = g.user.getSomeoneBySocialId(friend_id);
        _srcParty = new Sprite();
        _source.addChild(_srcParty);
        var _bgParty:HintBackground = new HintBackground(100, 100, HintBackground.SMALL_TRIANGLE, HintBackground.BOTTOM_CENTER);
        _srcParty.addChild(_bgParty);
        if (!_person.name) {
            g.socialNetwork.addEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
            g.socialNetwork.getTempUsersInfoById([_person.userSocialId]);
        } else onGettingUserInfo();
    }

    private function onGettingUserInfo(e:SocialNetworkEvent=null):void {
        if (!_person.name) {
            _person = g.user.getSomeoneBySocialId(_person.userSocialId);
            if (!_person.name) return;
        }
        g.socialNetwork.removeEventListener(SocialNetworkEvent.GET_TEMP_USERS_BY_IDS, onGettingUserInfo);
        if (_person.photo =='' || _person.photo == 'unknown') {
            photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        } else g.load.loadImage(_person.photo, onLoadPhoto);
    }

    private function onLoadPhoto(bitmap:Bitmap):void {
        if (!bitmap) {
            bitmap = g.pBitmaps[_person.photo].create() as Bitmap;
        }
        if (!bitmap) {
            Cc.error('MarketFriendItem:: no photo for userId: ' + _person.userSocialId);
            return;
        }
        photoFromTexture(Texture.fromBitmap(bitmap));
//        photoFromTexture(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar'));
    }

    private function photoFromTexture(tex:Texture):void {
        var ava:Image = new Image(tex);
        MCScaler.scale(ava, 60, 60);
        ava.x = -ava.width/2;
        ava.y = -105;
        _srcParty.addChild(ava);
        ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame'));
        ava.x = -ava.width/2;
        ava.y = -110;
        _srcParty.addChild(ava);
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

            var p:Point = new Point(0, 0);
            p = _source.localToGlobal(p);
            var d:DropObject = new DropObject();
            d.addDropItemNew(_resourceItem, p);
            d.addDropItemNew(_resourceItem, p);
            d.addDropXP(_resourceItem.craftXP, p);
            d.tempAmbarCount = 2;
            if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_THREE_GIFT_MORE_PLANT) {
                for (i = 0; i < g.managerParty.idItemEvent.length; i++) {
                    if (g.managerParty.idItemEvent[i] == _resourceItem.resourceID) {
                        for (var j:int = 0; j < g.managerParty.coefficient; j++) {
                            d.addDropItemNew(_resourceItem, p);
                            g.managerParty.addUserPartyCount(1);
                        }
                        break;
                    }
                }
            }

            if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_COLLECT_RESOURCE_WIN_GIFT) {
                for (i = 0; i < g.managerParty.idItemEvent.length; i++) {
                    if (g.managerParty.idItemEvent[i] == _resourceItem.resourceID) {
                        g.managerParty.addUserPartyCount(2);
                        break;
                    }
                }
            }

            if (g.managerDropResources.checkDrop()) g.managerDropResources.createDrop(p.x, p.y, d);
            if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_COLLECT_TOKEN_WIN_GIFT && g.allData.atlas['partyAtlas'] && Math.random() <= .1) {
                d.addDropPartyResource(p);
                g.managerParty.addUserPartyCount(1);
            }
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
        if (g.isActiveMapEditor) return;
        if (g.isAway) {
            if ((g.managerParty.eventOn && g.managerParty.typeParty != ManagerPartyNew.EVENT_SKIP_PLANT_FRIEND) || !g.managerParty.eventOn) return;
        }
        if ((_stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) && g.isAway && g.partyPanel.gCountHelpParty < 10 && g.visitedUser is Friend) {
            super.onHover();
            _isOnHover = true;
            g.mouseHint.showMouseHint(MouseHint.LEYKA);
        } else if (!g.isAway) {
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
    }

    public function clearSrcParty():void {
        if (_srcParty) {
            _source.removeChild(_srcParty);
            _srcParty.dispose();
            _srcParty = null;
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
        if (g.managerSalePack) g.managerSalePack.onUserAction();
        if (g.managerStarterPack) g.managerStarterPack.onUserAction();
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
        } else if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {  g.toolsModifier.modifierType = ToolsModifier.NONE;
        } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            releaseFlip();
            g.server.userBuildingFlip(_dbBuildingId, int(_flip), null);
        } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED) {
            if (g.toolsModifier.plantId <= 0 || _stateRidge == GROW1 || _stateRidge == GROW2 || _stateRidge == GROW3) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                return;
            }
            if (_stateRidge == GROWED) {
                g.toolsModifier.modifierType = ToolsModifier.CRAFT_PLANT;
                return;
            }
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
            if (!g.tuts.isTuts) g.toolsModifier.modifierType = ToolsModifier.CRAFT_PLANT;
            clearSrcParty();
            craftThePlant();
            g.timerHint.hideIt(true);
        }
    }

    public function onEndClick():void {
        if (g.managerHelpers) g.managerHelpers.onUserAction();
        if (g.managerSalePack) g.managerSalePack.onUserAction();
        if (g.managerStarterPack) g.managerStarterPack.onUserAction();
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts) {
            if (g.tuts.action == TutsAction.PLANT_RIDGE && g.tuts.isTutsBuilding(this) && _tutorialCallback != null) {
                g.tuts.checkTutsCallback();
            } else if (g.tuts.action == TutsAction.PLANT_RIDGE_2 && g.tuts.isTutsBuilding(this) && _tutorialCallback != null) {

            } else if (g.tuts.action == TutsAction.NEW_RIDGE) {
//                if (g.selectedBuild != this) return;
            } else if (!g.tuts.isTutsBuilding(this) || _tutorialCallback == null) return;
        }
        if (g.isAway) {
            if ((g.managerParty.eventOn && g.managerParty.typeParty != ManagerPartyNew.EVENT_SKIP_PLANT_FRIEND) || !g.managerParty.eventOn || _stateRidge == EMPTY) return;
        }
        if (g.isActiveMapEditor) return;
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
                if (g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_SKIP_PLANT_FRIEND && g.isAway && g.visitedUser is Friend) {
                    for (var i:int = 0; i < g.managerParty.userParty[0].friendId.length; i++) {
                        if (g.managerParty.userParty[0].friendId[i] == g.visitedUser.userId) {
                            if (g.managerParty.userParty[0].friendCount[i] >= 10) return;
                            break;
                        }
                    }
                    g.partyHint.showIt(50, g.cont.gameContX + _source.x * g.currentGameScale, g.cont.gameContY + (_source.y + _source.height / 2 - _plantSprite.height) /*_source.height/10) */ * g.currentGameScale, _dataPlant.buildTime, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name, callbackSkip, onOut, true);
                } else {
                    if (g.isAway) return;
                    if (!lastBuyResource) {
                        if (g.timerHint.isShow) g.timerHint.managerHide(onClickCallbackWhenWork);
                        else g.timerHint.showIt(50, g.cont.gameContX + _source.x * g.currentGameScale, g.cont.gameContY + (_source.y + _source.height / 2 - _plantSprite.height) /*_source.height/10) */ * g.currentGameScale, _dataPlant.buildTime, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name, callbackSkip, onOut, true);
                    }
                    lastBuyResource = false;
                }
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
        g.timerHint.showIt(50, g.cont.gameContX + _source.x * g.currentGameScale, g.cont.gameContY + (_source.y +_source.height/2 -  _plantSprite.height) /*_source.height/10) */* g.currentGameScale,_dataPlant.buildTime, _plant.getTimeToGrowed(), _dataPlant.priceSkipHard, _dataPlant.name,callbackSkip,onOut, true);
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
        if (_stateRidge == EMPTY) _hitArea = g.managerHitArea.getHitArea(_source, 'ridgeBuild');
        else _hitArea = g.managerHitArea.getHitArea(_source, 'ridgeBuild_' + String(_dataPlant.id) + '_' + String(_stateRidge));
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

    public function callbackSkip():void {
        _source.filter = null;
        _isOnHover = false;
        _plant.checkStateRidge(false);
        if (g.isAway && g.managerParty.eventOn && g.managerParty.typeParty == ManagerPartyNew.EVENT_SKIP_PLANT_FRIEND) {
            g.server.skipTimeOnRidgeParty(g.visitedUser.userId, _plant._timeToEndState, _dbBuildingId, g.user.userSocialId, null);
            if (g.managerParty.userParty[0].friendId.length == 0) {
                g.managerParty.userParty[0].friendId.push(g.visitedUser.userId);
                g.managerParty.userParty[0].friendCount.push(1);
            } else {
                var b:Boolean = false;
                for (var i:int = 0; i < g.managerParty.userParty[0].friendId.length; i++) {
                    if (g.managerParty.userParty[0].friendId[i] == g.visitedUser.userId) {
                        g.managerParty.userParty[0].friendCount[i] += 1;
                        b = true;
                        break;
                    }
                }
                if (!b) {
                    g.managerParty.userParty[0].friendId.push(g.visitedUser.userId);
                    g.managerParty.userParty[0].friendCount.push(1);
                }
            }
            g.managerParty.addUserPartyCount(1);
            _plant.renderSkip();
            g.partyPanel.sCountHelpParty = 1;
            var p:Point = new Point(0, 0);
            p = _source.localToGlobal(p);
            var d:DropObject = new DropObject();
            d.addDropXP(_dataPlant.craftXP, p);
            d.releaseIt();
        }
        else {
            g.server.skipTimeOnRidge(_plant._timeToEndState, _dbBuildingId, null);
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {
                id: AnalyticManager.SKIP_TIMER_PLANT_ID,
                info: _plant.dataPlant.id
            });
            _plant.renderSkip();
        }
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
