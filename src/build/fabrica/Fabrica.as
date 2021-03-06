/**
 * Created by user on 6/9/15.
 */
package build.fabrica {
import analytic.AnalyticManager;
import build.WorldObject;
import data.BuildType;
import dragonBones.Armature;
import dragonBones.Bone;
import dragonBones.Slot;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;
import flash.geom.Point;
import heroes.BasicCat;
import heroes.HeroCat;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;
import media.SoundConst;
import quest.ManagerQuest;
import resourceItem.CraftItem;
import com.junkbyte.console.Cc;
import resourceItem.RawItem;
import resourceItem.ResourceItem;
import mouse.ToolsModifier;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import starling.textures.Texture;
import tutorial.TutsAction;
import tutorial.helpers.HelperReason;

import user.NeighborBot;

import utils.Utils;

import windows.WindowsManager;

public class Fabrica extends WorldObject {
    private var _arrRecipes:Array;  // массив всех рецептов, которые можно изготовить на этой фабрике
    private var _arrList:Array; // массив заказанных для изготовления ресурсов
    private var _isOnHover:Boolean;
    private var _count:int;
    private var _arrCrafted:Array;
    private var _armatureOpen:Armature;
    private var _countAnimation:int;
    private var _callOnRandomWork:Function;
    private var _isShopView:Boolean;

    public function Fabrica(_data:Object) {
        super(_data);
        if (!_data) {
            Cc.error('no data for Fabrica');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Fabrica');
            return;
        }
        if (!_dataBuild.countCell) _dataBuild.countCell = g.allData.getBuildingById(_dataBuild.id).startCountCell;
        _isShopView = false;
        _arrRecipes = [];
        _arrList = [];
        _arrCrafted = [];
        _craftSprite = new Sprite();
        if (g.isAway) g.cont.craftAwayCont.addChild(_craftSprite);
        else g.cont.craftCont.addChild(_craftSprite);
        _buildingBuildSprite = new Sprite();
        _source.addChild(_buildingBuildSprite);
        checkBuildState();
        _source.releaseContDrag = true;
        if (!g.isAway) _source.endClickCallback = onClick;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;

        updateRecipes();
    }

    override public function afterPasteBuild():void {
        if (_arrCrafted.length) _craftSprite.visible = true;
        _craftSprite.x = _source.x;
        _craftSprite.y = 100*g.scaleFactor + _source.y;
        super.afterPasteBuild();
    }

    private function checkBuildState():void {
        if (g.isAway) {
            _stateBuild = STATE_ACTIVE;
            createAnimatedBuild(onCreateBuild);
        } else {
            if (g.user.userBuildingData[_dataBuild.id]) {
                if (g.user.userBuildingData[_dataBuild.id].isOpen) {
                    _stateBuild = STATE_ACTIVE;
                    createAnimatedBuild(onCreateBuild);                                                     // уже построенно и открыто
                } else {
                    _leftBuildTime = int(g.user.userBuildingData[_dataBuild.id].timeBuildBuilding); // сколько времени уже строится
                    var arr:Array = g.townArea.getCityObjectsById(_dataBuild.id);
                    _leftBuildTime = int(_dataBuild.buildTime[arr.length]) - _leftBuildTime;        // сколько времени еще до конца стройки
                    if (_leftBuildTime <= 0) {  // уже построенно, но не открыто
                        _stateBuild = STATE_WAIT_ACTIVATE;
                        animationYouCanOpen();
                        addDoneBuilding();
                    } else {  // еще строится
                        _stateBuild = STATE_BUILD;
                        addFoundationBuilding();
                        g.gameDispatcher.addToTimer(renderBuildProgress);
                    }
                }
            } else {
                _stateBuild = STATE_ACTIVE;
                createAnimatedBuild(onCreateBuild);
            }
        }
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        if (!_isShopView) {
            if (_arrList.length) workAloneAnimation();  else stopAnimation();
            if (_source) {
                _hitArea = g.managerHitArea.getHitArea(_source, _dataBuild.url);
                _source.registerHitArea(_hitArea);
            }
        }
        if (g.isAway && g.visitedUser is NeighborBot && Math.random() > .2) workAloneAnimation();
    }

    public function showShopView():void {
        _isShopView = true;
        _buildingBuildSprite.visible = false;
        createAnimatedBuild(onCreateBuild);
    }

    public function removeShopView():void {
        _isShopView = false;
        if (_build) {
            if (_source.contains(_build)) _source.removeChild(_build);
            while (_build.numChildren) _build.removeChildAt(0);
        }
        _buildingBuildSprite.visible = true;
        addFoundationBuilding();
        if (g.isAway) _source.endClickCallback = null;
        if (!g.isAway) _source.endClickCallback = onClick;
        _source.hoverCallback = onHover;
        _source.outCallback = onOut;
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (g.isAway) { g.hint.showIt(_dataBuild.name); return; }
        if (g.isActiveMapEditor) return;
        _count = 20;
        if (_stateBuild == STATE_ACTIVE) {
            if (_arrList.length > 0) g.hint.showIt(_dataBuild.name,'fabric',0,_arrList[0].leftTime);
                else g.hint.showIt(_dataBuild.name);
            if (!_isOnHover && !_arrList.length && _armature) {
                var fEndOver:Function = function(e:Event=null):void {
                    _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                    _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                    _armature.animation.gotoAndStopByFrame('idle');
                };
                _armature.addEventListener(EventObject.COMPLETE, fEndOver);
                _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndPlayByFrame('over');
            }
        } else if (_stateBuild == STATE_BUILD) {  if (!_isOnHover) buildingBuildFoundationOver();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) { if (!_isOnHover) buildingBuildDoneOver();  }
        if (!_isOnHover) _source.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        _isOnHover = true;
    }

    override public function onOut():void {
        super.onOut();
        if (g.isAway) { g.hint.hideIt();  return;  }
        if (_source.filter) _source.filter.dispose();
        _source.filter = null;
//        if (g.tuts.isTuts) {
//            if (g.tuts.action == TutsAction.FABRICA_SKIP_FOUNDATION) return;
//            if (!g.tuts.isTutsBuilding(this)) return;
//        }
        if (g.isActiveMapEditor) return;
        _isOnHover = false;
        g.hint.hideIt();
    }

    public function openFabricaWindow():void {
        if (g.managerHelpers && g.managerHelpers.isActiveHelper && g.managerHelpers.activeReason.reason == HelperReason.REASON_RAW_FABRICA && g.managerHelpers.activeReason.build == this)
            g.managerHelpers.onOpenFabricaWithDelay();
        hideArrow();
        var p:Point = new Point();
        p = _source.localToGlobal(p);
        g.windowsManager.openWindow(WindowsManager.WO_FABRICA, callbackOnChooseRecipe, _arrRecipes.slice(), _arrList.slice(), this, p);
    }

    private function onClick():void {
        if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED_ACTIVE) g.toolsModifier.modifierType = ToolsModifier.NONE;
        if (g.managerCutScenes.isCutScene) return;
        if (g.tuts.isTuts) {
            if (g.tuts.action == TutsAction.RAW_RECIPE && g.tuts.isTutsBuilding(this)) {
                g.tuts.checkTutsCallback();
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else if (g.tuts.action == TutsAction.FABRICA_SKIP_FOUNDATION && g.tuts.isTutsBuilding(this)) {
                if (_leftBuildTime <= 0) {
                    g.tuts.checkTutsCallback();
                }
            } else if (g.tuts.action == TutsAction.PUT_FABRICA && g.tuts.isTutsResource(_dataBuild.id)) {
            } else if (g.tuts.action == TutsAction.PUT_FABRICA && g.tuts.isTutsBuilding(this)) {
            } else if (g.tuts.action == TutsAction.FABRICA_CRAFT && g.tuts.isTutsBuilding(this)) {
            } else return;
        }
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
        if (_stateBuild == STATE_ACTIVE) {
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
                if (_arrCrafted.length) {
                    if (g.userInventory.currentCountInSklad + _arrCrafted[0].count > g.user.skladMaxCount) {
                        g.windowsManager.openWindow(WindowsManager.WO_AMBAR_FILLED, null, false);
                    } else {
                        g.managerQuest.onActionForTaskType(ManagerQuest.CRAFT_PRODUCT, {id:(_arrCrafted[0] as CraftItem).resourceId});
                        (_arrCrafted[0] as CraftItem).releaseIt();
                    }
                } else {
                    if (!_arrRecipes.length) updateRecipes();
                    if (!g.tuts.isTuts) {
                        if (g.managerResize.stageHeight > 720) g.cont.moveCenterToXY(_source.x, _source.y);
                            else g.cont.moveCenterToXY(_source.x, _source.y + 40);
                    }
                    onOut();
                    openFabricaWindow();
                }
            } else {
                Cc.error('Fabrica:: unknown g.toolsModifier.modifierType and convert to NONE');
                g.toolsModifier.modifierType = ToolsModifier.NONE;
                onClick();
            }
        } else if (_stateBuild == STATE_BUILD) {
            if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
                onOut();
                g.townArea.moveBuild(this);
            } else {
                if (g.tuts.isTuts) {
                    if (g.tuts.action == TutsAction.FABRICA_SKIP_FOUNDATION) {
                        g.timerHint.canHide = false;
                        g.timerHint.addArrow();
//                        g.tuts.checkTutsCallback();
                        hideArrow();
                        g.timerHint.showIt(90, g.cont.gameContX + _source.x * g.currentGameScale, g.cont.gameContY + (_source.y - _source.height/3) * g.currentGameScale,
                                _dataBuild.buildTime, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip, onOut);
                    }
                } else {
                    g.timerHint.needMoveCenter = true;
                    g.timerHint.showIt(90, g.cont.gameContX + _source.x * g.currentGameScale, g.cont.gameContY + (_source.y - _source.height/3) * g.currentGameScale,
                            _dataBuild.buildTime, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip, onOut);
                }
            }
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (g.tuts.isTuts && g.tuts.action != TutsAction.PUT_FABRICA) return;
            _stateBuild = STATE_ACTIVE;
            g.managerAchievement.addAll(12,1);
            g.user.userBuildingData[_dataBuild.id].isOpen = 1;
            g.server.openBuildedBuilding(this, onOpenBuilded);
            clearBuildingBuildSprite();
            onOut();
            createAnimatedBuild(onCreateBuild);
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                var d:DropObject = new DropObject();
                d.addDropXP(_dataBuild.xpForBuild, start);
                d.releaseIt();
            }
            showBoom();
            g.managerFabricaRecipe.onAddNewFabrica(this);
            if (g.tuts.isTuts && g.tuts.action == TutsAction.PUT_FABRICA && g.tuts.isTutsBuilding(this)) {
                g.tuts.checkTutsCallback();
            }
            g.soundManager.playSound(SoundConst.OPEN_BUILD);
            g.managerQuest.onActionForTaskType(ManagerQuest.OPEN_BUILD, {id:_dataBuild.id});
        }
    }

    public function onResize():void {
        if (g.tuts.isTuts) {
            g.timerHint.canHide = true;
            g.timerHint.hideArrow();
            g.timerHint.hideIt(true);
            g.timerHint.canHide = false;
            g.timerHint.addArrow();
            g.tuts.checkTutsCallback();
            g.timerHint.showIt(90, g.cont.gameContX + _source.x * g.currentGameScale, g.cont.gameContY + (_source.y - _source.height/3) * g.currentGameScale,
                    _dataBuild.buildTime, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name, callbackSkip, onOut);
        }
    }

    override public function showForOptimisation(needShow:Boolean):void {
        if (_craftSprite) _craftSprite.visible = needShow;
        super.showForOptimisation(needShow);
    }

    public function get arrRecipes():Array { return _arrRecipes; }
    public function get arrList():Array { return _arrList; }
    public function get arrCrafted():Array { return _arrCrafted; }
    private function onOpenBuilded(value:Boolean):void { }
    public function get isAnyCrafted():Boolean { return _arrCrafted.length > 0; }

    private function updateRecipes():void {
        _arrRecipes.length = 0;
        try {
            var arR:Array = g.allData.recipe;
            var arRA:Array = [];
            for (var i:int = 0; i < arR.length; i++) {
                if (arR[i].buildingId == _dataBuild.id) {
                    arRA.push(arR[i]);
                }
            }
            arRA.sortOn('blockByLevel', Array.NUMERIC);
            for (i = 0; i < arRA.length; i++) {
                if (arRA[i].blockByLevel > g.user.level) {
                    _arrRecipes.push(arRA[i]);
                    break;
                } else {
                    _arrRecipes.push(arRA[i]);
                }
            }
        } catch (e:Error) {
            Cc.error('fabrica recipe error: ' + e.errorID + ' - ' + e.message);
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'fabrica update recipe');
        }
    }

    public function onRecipeFromServer(resItem:ResourceItem, dataRecipe:Object, timeInWork:int, delayTime:int, initRecipeDelayTime:int):void {
        resItem.leftTime -= timeInWork;
        resItem.currentDelayTime = delayTime;
        resItem.initRecipeDelayTime = initRecipeDelayTime;
        resItem.currentRecipeID = dataRecipe.id;
        _arrList.push(resItem);
    }

    public function onLoadFromServer():void {
        if (!_arrList.length) return;
        _arrList.sortOn(['currentDelayTime', 'initRecipeDelayTime'], Array.NUMERIC);
        g.gameDispatcher.addToTimer(render);
        if (_armature) workAloneAnimation();
    }

    public function callbackOnChooseRecipe(resItem:ResourceItem, dataRecipe:Object):void {
        var i:int;
        var delay:int = 0;
        resItem.currentRecipeID = dataRecipe.id;
        if (!_arrList.length) g.gameDispatcher.addToTimer(render);
        else {
            for (i = 0; i < _arrList.length; i++) { // delay before start make this new recipe
                if (i) delay += (_arrList[i] as ResourceItem).buildTime;
                else delay += (_arrList[0] as ResourceItem).leftTime;
            }
        }
        resItem.initRecipeDelayTime = delay;
        _arrList.push(resItem);
        var f1:Function = function(t:String):void {  resItem.idFromServer = t;  };
        for (i = 0; i < dataRecipe.ingridientsId.length; i++) {
            if (dataRecipe.ingridientsId[i] && dataRecipe.ingridientsCount[i]) g.userInventory.addResource(int(dataRecipe.ingridientsId[i]), -int(dataRecipe.ingridientsCount[i]));
        }
        g.server.addFabricaRecipe(dataRecipe.id, _dbBuildingId, delay, f1);
        g.managerQuest.onActionForTaskType(ManagerQuest.RAW_PRODUCT, {id:dataRecipe.idResource});
        g.managerCats.onStartFabrica(this);
        workAloneAnimation();
        // animation of uploading resources to fabrica
        var p:Point = new Point();
        p = _source.localToGlobal(p);
        var obj:Object;
        var texture:Texture;
        for (i = 0; i < dataRecipe.ingridientsId.length; i++) {
            if (dataRecipe.ingridientsId[i]) {
                obj = g.allData.getResourceById(int(dataRecipe.ingridientsId[i]));
                if (obj.buildType == BuildType.PLANT)  texture = g.allData.atlas['resourceAtlas'].getTexture(obj.imageShop + '_icon');
                else texture = g.allData.atlas[obj.url].getTexture(obj.imageShop);
                new RawItem(p, texture, int(dataRecipe.ingridientsCount[i]), i * .1);
            }
        }
    }

    public function onGoAway(v:Boolean):void {
        if (v && _arrList.length) {
            catOnAnimation = false;
            workAloneAnimation();
        }
        else stopAnimation();
    }

    private function render():void {
        if (!_arrList.length) {
            stopAnimation();
            g.gameDispatcher.removeFromTimer(render);
            return;
        }
        (_arrList[0] as ResourceItem).leftTime--;
        if ((_arrList[0] as ResourceItem).leftTime <= 0) {
            craftResource(_arrList.shift());
            if (!_arrList.length) {
                stopAnimation();
                g.gameDispatcher.removeFromTimer(render);
                g.managerCats.onFinishFabrica(this);
            }
        }
    }

    public function craftResource(item:ResourceItem):void {
        var countResources:int = 1;
        var arR:Array = g.allData.recipe;
        for (var i:int = 0; i < arR.length; i++) {
            if (arR[i].buildingId == _dataBuild.id && item.resourceID == arR[i].idResource) {
                countResources = arR[i].numberCreate;
                break;
            }
        }
        _craftSprite.visible = true;
        var craftItem:CraftItem = new CraftItem(0, 0, item, _craftSprite, countResources, useCraftedResource, true);
        _arrCrafted.push(craftItem);
        craftItem.addParticle();
        craftItem.animIt();
        craftItem.checkCount = true;
        if (g.managerTips) g.managerTips.calculateAvailableTips();
    }

    public function addAnimForCraftItem(v:Boolean):void {
        if (_arrCrafted.length) {
            var i:int;
            if (v) {
                for (i=0; i<_arrCrafted.length; i++) {
                    (_arrCrafted[i] as CraftItem).animIt();
                }
            } else {
                for (i=0; i<_arrCrafted.length; i++) {
                    (_arrCrafted[i] as CraftItem).removeAnimIt();
                }
            }
        }
    }
    
    private function useCraftedResource(item:ResourceItem, crItem:CraftItem):void {
        g.managerAchievement.addResource((_arrCrafted[0] as CraftItem).resourceId);
        if ((_arrCrafted[0] as CraftItem).resourceId == 126|| (_arrCrafted[0] as CraftItem).resourceId == 127|| (_arrCrafted[0] as CraftItem).resourceId == 128 || (_arrCrafted[0] as CraftItem).resourceId == 129) g.managerAchievement.addAll(18,1);
        g.managerQuest.onActionForTaskType(ManagerQuest.CRAFT_PRODUCT, {id:(_arrCrafted[0] as CraftItem).resourceId});
        _arrCrafted.splice(_arrCrafted.indexOf(crItem), 1);
        g.managerFabricaRecipe.onCraft(item);
    }

    public function onHeroAnimation(f:Function, cat:HeroCat):void {
        _countAnimation = int (5 + Math.random()* 9);
        _callOnRandomWork = f;
        stopAnimation();

        releaseHeroCatWoman(cat);
        if (!_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, chooseAnimationHero);
        if (!_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, chooseAnimationHero);
        chooseAnimationHero();
    }

    public function chooseAnimationHero():void {
        _countAnimation--;
        if (_countAnimation < 0) {
            if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, chooseAnimationHero);
            if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, chooseAnimationHero);
            if (_callOnRandomWork != null) {
                _callOnRandomWork.apply();
                _callOnRandomWork = null;
            }
            if (_arrList.length) workAloneAnimation();
                else stopAnimation();
        } else _armature.animation.gotoAndPlayByFrame('idle2');
    }

    public function awayImitationOfWork():void {
        workAloneAnimation();
    }

    private function stopAnimation():void {
        if (!_armature) return;
        _armature.animation.gotoAndStopByFrame('idle');
        if ( _armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, workAloneAnimation);
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, workAloneAnimation);
    }

    private function workAloneAnimation(e:Event=null):void {
        try {
            if (!_armature) return;
            if (!_armature.hasEventListener(EventObject.COMPLETE)) _armature.addEventListener(EventObject.COMPLETE, workAloneAnimation);
            if (!_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.addEventListener(EventObject.LOOP_COMPLETE, workAloneAnimation);
            _armature.animation.gotoAndPlayByFrame('idle1');
        } catch(e:Error) {
            workAloneAnimation();
        }
    }

    override public function clearIt():void {
        onOut();
        stopAnimation();
        if (_armature) WorldClock.clock.remove(_armature);
        g.gameDispatcher.removeFromTimer(render);
        _source.touchable = false;
        _arrList.length = 0;
        _arrRecipes.length = 0;
        _arrCrafted.length = 0;
        super.clearIt();
    }

    private function callbackSkip():void { // for building build
        _stateBuild = STATE_WAIT_ACTIVATE;
        animationYouCanOpen();
        g.server.skipTimeOnFabricBuild(_leftBuildTime, _dbBuildingId, null);
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_BUILDING_BUILD_ID, info: _dataBuild.id});
        _leftBuildTime = 0;
        renderBuildProgress();
        onOut();
        if (g.tuts.isTuts && g.tuts.action == TutsAction.FABRICA_SKIP_FOUNDATION) {
            g.timerHint.canHide = true;
            g.timerHint.hideArrow();
            g.timerHint.hideIt();
            g.tuts.checkTutsCallback();
        }
    }

    public function onBuyNewCell():void {
        _dataBuild.countCell++;
        g.server.buyNewCellOnFabrica(_dbBuildingId, _dataBuild.countCell, null);
    }

    public function skipRecipe():void { // for making recipe
        if (_arrList[0]) {
            g.server.skipRecipeOnFabrica(_arrList[0].idFromServer, _arrList[0].leftTime, _dbBuildingId, null);
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_FABRICA_ID, info: _arrList[0].resourceID});
            craftResource(_arrList.shift());
            if (!_arrList.length) {
                g.managerCats.onFinishFabrica(this);
                _countAnimation = 0;
                chooseAnimationHero();
            }
        } else {
            Cc.error('Fabrica skipRecipe:: _arrList[0] == null');
        }
    }

    public function skipSmallRecipe(number:int):void { // for making recipe
        if (_arrList[number]) {
            g.server.deleteRecipeOnFabrica(_arrList[number].idFromServer, _arrList[number].initRecipeDelayTime, _dbBuildingId, null);
            g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_FABRICA_ID, info: _arrList[number].resourceID});
            for (var i:int = 0; i < _arrList.length; i++) {
                if (_arrList[i].currentDelayTime > _arrList[number].currentDelayTime )  _arrList[i].currentDelayTime = _arrList[i].currentDelayTime - _arrList[number].currentDelayTime ;
            }
            _arrList.splice(number, 1);
        } else {
            Cc.error('Fabrica skipSmallRecipe:: _arrList[0] == null');
        }
    }

    public function addArrowToCraftItem(f:Function):void {
        if (_arrCrafted.length) {
            (_arrCrafted[0] as CraftItem).addArrow(f);
        }
    }

    private function showBoom():void {
        _armatureOpen = g.allData.factory['explode'].buildArmature("expl");
        if (!_armatureOpen) return;
        (_armatureOpen.display as Sprite).scaleX = (_armatureOpen.display as StarlingArmatureDisplay).scaleY = 1.5;
        _source.addChild(_armatureOpen.display as Sprite);
        WorldClock.clock.add(_armatureOpen);
        _armatureOpen.addEventListener(EventObject.COMPLETE, onBoom);
        _armatureOpen.addEventListener(EventObject.LOOP_COMPLETE, onBoom);
        _armatureOpen.animation.gotoAndPlayByFrame("start");
    }

    private function onBoom(e:Event=null):void {
        if (_armatureOpen.hasEventListener(EventObject.COMPLETE)) _armatureOpen.removeEventListener(EventObject.COMPLETE, onBoom);
        if (_armatureOpen.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureOpen.removeEventListener(EventObject.LOOP_COMPLETE, onBoom);
        WorldClock.clock.remove(_armatureOpen);
        _source.removeChild(_armatureOpen.display as Sprite);
        _armatureOpen = null;
//        if (!g.tuts.isTuts && g.user.level < 4) {
//            g.windowsManager.openWindow(WindowsManager.POST_OPEN_FABRIC,null,_dataBuild);
//        }
    }

    private function releaseHeroCatWoman(cat:HeroCat):void {
        if (cat.typeMan == BasicCat.MAN) {
            if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 8 || _dataBuild.id == 7 || _dataBuild.id == 133 || _dataBuild.id == 9 || _dataBuild.id == 135 || _dataBuild.id == 6 || _dataBuild.id == 5|| _dataBuild.id == 131) releaseManBackTexture();
                else releaseManFrontTexture();
        } else if (cat.typeMan == BasicCat.WOMAN) {
            if (_dataBuild.id == 1 || _dataBuild.id == 2 || _dataBuild.id == 8 || _dataBuild.id == 7 || _dataBuild.id == 133 || _dataBuild.id == 9 || _dataBuild.id == 135 || _dataBuild.id == 6 || _dataBuild.id == 5|| _dataBuild.id == 131) releaseWomanBackTexture();
                else releaseWomanFrontTexture();
        }
    }

    private function releaseManFrontTexture():void {
        changeTexture("head", "grey_c_m_worker_head_front");
        changeTexture("body", "grey_c_m_worker_body_front");
        changeTexture("handLeft", "grey_c_m_worker_l_hand_front");
        changeTexture("legLeft", "grey_c_m_worker_l_leg_front");
        changeTexture("handRight", "grey_c_m_worker_r_hand_front");
        changeTexture("legRight", "grey_c_m_worker_r_leg_front");
        changeTexture("tail", "grey_c_m_worker_tail_front");
        changeTexture("handRight copy", "grey_c_m_worker_r_hand_front");

        if (_dataBuild.id == 10) changeTexture("handRight2", "grey_c_m_worker_r_hand_front");
        if (_dataBuild.id == 3) {
            var vii1:Bone = _armature.getBone('vii1');
            if (vii1) vii1.visible = false;
            var vii2:Bone = _armature.getBone('vii2');
            if (vii2) vii2.visible = false;
        } else {
            var viyi:Bone = _armature.getBone('viyi');
            if (viyi) viyi.visible = false;
        }
    }

    private function releaseManBackTexture():void {
        changeTexture("head", "grey_c_m_worker_head_back");
        changeTexture("body", "grey_c_m_worker_body_back");
        changeTexture("legLeft", "grey_c_m_worker_l_leg_back");
        changeTexture("handLeft", "grey_c_m_worker_l_hand_back");
        changeTexture("handRight", "grey_c_m_worker_r_hand_back");
        changeTexture("legRight", "grey_c_m_worker_r_leg_back");
        changeTexture("tail", "grey_c_m_worker_tail_front");

        if (_dataBuild.id == 10) changeTexture("handRight2", "grey_c_m_worker_r_hand_back");
    }

    private function releaseWomanFrontTexture():void {
        changeTexture("head", "orange_c_w_worker_head_front");
        changeTexture("body", "orange_c_w_worker_body_front");
        changeTexture("handLeft", "orange_c_w_worker_l_hand_front");
        changeTexture("legLeft", "orange_c_w_worker_l_leg_front");
        changeTexture("handRight", "orange_c_w_worker_r_hand_front");
        changeTexture("legRight", "orange_c_w_worker_r_leg_front");
        changeTexture("tail", "orange_c_w_worker_tail_front");
        changeTexture("handRight copy", "orange_c_w_worker_r_hand_front");

        if (_dataBuild.id == 10) changeTexture("handRight2", "orange_c_w_worker_r_hand_front");
        if (_dataBuild.id == 3) {
            var vii1:Bone = _armature.getBone('vii1');
            if (vii1) vii1.visible = true;
            var vii2:Bone = _armature.getBone('vii2');
            if (vii2) vii2.visible = true;
        } else {
            var viyi:Bone = _armature.getBone('viyi');
            if (viyi) viyi.visible = true;
        }
    }

    private function releaseWomanBackTexture():void {
        changeTexture("head", "orange_c_w_worker_head_back");
        changeTexture("body", "orange_c_w_worker_body_back");
        changeTexture("handLeft", "orange_c_w_worker_l_hand_back");
        changeTexture("legLeft", "orange_c_w_worker_l_leg_back");
        changeTexture("handRight", "orange_c_w_worker_r_hand_back");
        changeTexture("legRight", "orange_c_w_worker_r_leg_back");
        changeTexture("tail", "orange_c_w_worker_tail_front");
    }

    private function changeTexture(oldName:String, newName:String):void {
        var im:Image = new Image(g.allData.atlas['customisationAtlas'].getTexture(newName));
        if (_armature) var b:Slot = _armature.getSlot(oldName);
        if (im && b) {
            b.displayList = null;
            b.display = im;
        } else {
            Cc.error('Fabrica changeTexture:: null Bone for oldName= '+oldName + ' for fabricaId= '+String(_dataBuild.id));
        }
    }

    public function animationYouCanOpen():void {
        if (_stateBuild == STATE_WAIT_ACTIVATE) {
            var f1:Function = function ():void {
                buildingBuildDoneOver();
                animationYouCanOpen();
            };
            Utils.createDelay(5 * Math.random(), f1);
        }
    }

}
}
