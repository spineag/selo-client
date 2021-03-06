package build.train {
import analytic.AnalyticManager;
import build.WorldObject;
import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import dragonBones.Armature;
import dragonBones.animation.WorldClock;
import dragonBones.events.EventObject;
import dragonBones.starling.StarlingArmatureDisplay;
import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerFilters;
import manager.hitArea.ManagerHitArea;
import media.SoundConst;
import mouse.ToolsModifier;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.events.Event;
import tutorial.managerCutScenes.ManagerCutScenes;
import utils.CSprite;
import utils.Utils;

import windows.WindowsManager;

public class Train extends WorldObject{
    public static var STATE_WAIT_BACK:int = 5;   // поезд в данный момент где-то ездит с продуктамы
    public static var STATE_READY:int = 6;  //  поезд ожидает загрузки продуктов

    private var list:Array;
    private var _counter:int;
    private var _dataPack:Object;
    private var _train_db_id:String; // id для поезда юзера в табличке user_train
    private var TIME_READY:int = 16*60*60; // время, которое ожидает поезд для загрузки продуктов
    private var TIME_WAIT:int = 5*60*60;  // время, на которое уезжает поезд
    private var _isOnHover:Boolean;
    private var _armatureOpenBoom:Armature;
    private var _arriveAnim:ArrivedAnimation;
    private var _bolAnimation:Boolean;
    private var _fullTrain:Boolean;
    private var _sprHelp:CSprite;

    public function Train(_data:Object) {
        super(_data);
        useIsometricOnly = false;
        _isOnHover = false;
        list = [];
        _counter = 0;
        if (!_data) {
            Cc.error('no data for Train');
            g.windowsManager.openWindow(WindowsManager.WO_GAME_ERROR, null, 'no data for Train');
            return;
        }
        _buildingBuildSprite = new Sprite();
        _source.addChild(_buildingBuildSprite);
        _stateBuild = STATE_DEFAULT_UNKNOWN;
       checkTrainState();
        _source.releaseContDrag = true;
    }

    public function fillItDefault():void { createAnimatedBuild(onCreateBuild); }
    private function onResetPack():void { g.server.getTrainPack(g.user.userSocialId, fillList); }
    private function onNewStateWait():void { g.server.releaseUserTrainPack(_train_db_id, onResetPack); }
    private function afterWork():void { makeIdleAnimation(); }
    private function onOpenTrain(value:Boolean):void { g.server.addUserTrain(onAddUserTrain); }
    private function onUpdate():void { g.server.getTrainPack(g.user.userSocialId, fillList); }
    private function startRenderTrainWork():void { g.gameDispatcher.addToTimer(render); }
    public function set setTrainFull(b:Boolean):void { _fullTrain = b; }

    public function fillFromServer(ob:Object):void {
        if (!g.isAway) {
            _train_db_id = String(ob.id);
            if (int(ob.state)) _stateBuild = int(ob.state);
            if (_stateBuild == STATE_ACTIVE) _stateBuild = STATE_READY;
            if (_stateBuild == STATE_WAIT_BACK) {
                if (int(ob.time_work) > TIME_WAIT) {
                    _stateBuild = STATE_READY;
                    g.server.updateUserTrainState(_stateBuild, _train_db_id, null);
                    _counter = TIME_READY;
                } else {
                    _counter = TIME_WAIT - int(ob.time_work);
                }
                g.server.getTrainPack(g.user.userSocialId, fillList);
            } else if (_stateBuild == STATE_READY) {
                if (int(ob.time_work) > TIME_READY) {
                    _stateBuild = STATE_WAIT_BACK;
                    g.server.updateUserTrainState(_stateBuild, _train_db_id, onNewStateWait);
                    _counter = TIME_WAIT;
                } else {
                    _counter = TIME_READY - int(ob.time_work);
                }
                g.server.getTrainPack(g.user.userSocialId, fillList);
            }
        }
        createAnimatedBuild(onCreateBuild);
    }

    private function arriveTrain():void {
        if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, makeIdleAnimation);
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, makeIdleAnimation);
        _armature.animation.gotoAndPlayByFrame('work');
        _arriveAnim.makeArriveKorzina(afterWork);
        _bolAnimation = true;
    }

    private function leaveTrain():void {
        if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, makeIdleAnimation);
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, makeIdleAnimation);
        _armature.animation.gotoAndPlayByFrame('work');
        _arriveAnim.makeAwayKorzina(afterWork);
        _bolAnimation = true;
    }

    private function makeIdleAnimation(e:Event=null):void {
        _bolAnimation = false;
        if (!_armature) return;
        if (_armature.hasEventListener(EventObject.COMPLETE)) _armature.removeEventListener(EventObject.COMPLETE, makeIdleAnimation);
        if (_armature.hasEventListener(EventObject.LOOP_COMPLETE)) _armature.removeEventListener(EventObject.LOOP_COMPLETE, makeIdleAnimation);
        _armature.addEventListener(EventObject.COMPLETE, makeIdleAnimation);
        _armature.addEventListener(EventObject.LOOP_COMPLETE, makeIdleAnimation);
        var n:Number = Math.random();
        if (n < .55) {
            _armature.animation.gotoAndPlayByFrame('idle_1');
        } else if (n < .7) {
            _armature.animation.gotoAndPlayByFrame('idle_2');
        } else if (n < .85) {
            _armature.animation.gotoAndPlayByFrame('idle_3');
        } else {
            _armature.animation.gotoAndPlayByFrame('idle_4');
        }
    }

    private function checkTrainState():void {
        if (g.isAway) {
            if (g.visitedUser) {
                var ar:Array = g.visitedUser.userDataCity.objects;
                for (var i:int=0; i<ar.length; i++) {
                    if (_dataBuild.id == ar[i].buildId) {
                        _stateBuild = int(ar[i].state);
                        break;
                    }
                }
            }
        } else {
            if (g.user.userBuildingData[_dataBuild.id]) {
                if (g.user.userBuildingData[_dataBuild.id].isOpen) {        // уже построенно и открыто
                    _stateBuild = STATE_ACTIVE;
                    if (_arriveAnim) _arriveAnim.visible = true;
                } else {
                    _leftBuildTime = Number(g.user.userBuildingData[_dataBuild.id].timeBuildBuilding);  // сколько времени уже строится
                    _leftBuildTime = _dataBuild.buildTime[0] - _leftBuildTime;                                 // сколько времени еще до конца стройки
                    if (_leftBuildTime <= 0) {  // уже построенно, но не открыто
                        _stateBuild = STATE_WAIT_ACTIVATE;
                        _build.visible = false;
                        addDoneBuilding();
                    } else {  // еще строится
                        _stateBuild = STATE_BUILD;
                        addFoundationBuilding();
                        _build.visible = false;
                        g.gameDispatcher.addToTimer(renderBuildTrainProgress);
                    }
                }
            } else {
                _stateBuild = STATE_UNACTIVE;
                if (_arriveAnim) _arriveAnim.visible = true;
            }
        }
        if (g.isAway) createAnimatedBuild(onCreateBuild);
    }

    private function onCreateBuild():void {
        WorldClock.clock.add(_armature);
        _hitArea = g.managerHitArea.getHitArea(_source, 'aerial_tram');
        _source.registerHitArea(_hitArea);
        if (!_arriveAnim) _arriveAnim = new ArrivedAnimation(_source);
        if (g.isAway) {
            _arriveAnim.visible = true;
            if (_stateBuild == STATE_UNACTIVE) {
                createBrokenTrain();
            } else if (_stateBuild == STATE_READY) {
                onArrivedKorzina();
            } else makeIdleAnimation();
        } else {
            if (_stateBuild == STATE_UNACTIVE) {
                createBrokenTrain();
                _arriveAnim.visible = true;
            } else if (_stateBuild == STATE_READY) {
                _arriveAnim.visible = true;
                onArrivedKorzina();
                startRenderTrainWork();
            } else if (_stateBuild == STATE_WAIT_BACK) {
                _arriveAnim.visible = true;
                makeIdleAnimation();
                startRenderTrainWork();
            } else if (_stateBuild == STATE_BUILD || _stateBuild == STATE_WAIT_ACTIVATE) {
                _arriveAnim.visible = false;
            } else if (_stateBuild == STATE_ACTIVE) {
                makeIdleAnimation();
            } else makeIdleAnimation();
        }
        _source.hoverCallback = onHover;
        _source.endClickCallback = onClick;
        _source.outCallback = onOut;

        if (g.isAway && _stateBuild == STATE_READY) {
            var f1:Function = function (ob:Object, t:Train):void {
                fillList(ob);
            };
            g.server.getTrainPack(g.visitedUser.userSocialId, f1, this);
        }
    }

    private function createBrokenTrain():void {
        _build.visible = true;
        _arriveAnim.visible = false;
        if (_armature) _armature.animation.gotoAndStopByFrame('close');
    }

    protected function renderBuildTrainProgress():void {
        _leftBuildTime--;
        if (_leftBuildTime <= 0) {
            g.gameDispatcher.removeFromTimer(renderBuildTrainProgress);
            clearBuildingBuildSprite();
            addDoneBuilding();
            _stateBuild = STATE_WAIT_ACTIVATE;
        }
    }

    override public function onHover():void {
        if (g.selectedBuild) return;
        super.onHover();
        if (_isOnHover) return;
        _build.filter = ManagerFilters.BUILDING_HOVER_FILTER;
        if (_stateBuild == STATE_UNACTIVE) {
            var fEndOver:Function = function(e:Event=null):void {
                _armature.removeEventListener(EventObject.COMPLETE, fEndOver);
                _armature.removeEventListener(EventObject.LOOP_COMPLETE, fEndOver);
                _armature.animation.gotoAndStopByFrame('close');
            };
            _armature.addEventListener(EventObject.COMPLETE, fEndOver);
            _armature.addEventListener(EventObject.LOOP_COMPLETE, fEndOver);
            _armature.animation.gotoAndPlayByFrame('over');
        } else if (_stateBuild == STATE_BUILD) {
            _buildingBuildSprite.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            buildingBuildFoundationOver();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            _buildingBuildSprite.filter = ManagerFilters.BUILDING_HOVER_FILTER;
            buildingBuildDoneOver();
        }
        g.hint.showIt(_dataBuild.name);
        _isOnHover = true;
    }

    private function onClick():void {
        if (_bolAnimation) return;
        if (g.isAway) {
            if (_stateBuild == STATE_READY) {
                onOut();
                if (list.length) {
                    if (_stateBuild == Train.STATE_READY) {
                        g.windowsManager.openWindow(WindowsManager.WO_TRAIN, null, list, this as Train, _stateBuild, _counter);
                    } else {
                        g.windowsManager.openWindow(WindowsManager.WO_TRAIN_WAIT_BACK, null, list, this as Train, _counter);
                    }
                } else {
                    var f1:Function = function(ob:Object, t:Train):void {
                        fillList(ob);
                        if (_stateBuild == Train.STATE_READY) {
                            g.windowsManager.openWindow(WindowsManager.WO_TRAIN, null, list, t, _stateBuild, _counter);
                        } else {
                            g.windowsManager.openWindow(WindowsManager.WO_TRAIN_WAIT_BACK, backTrain, list, t, _counter);
                        }
                    };
                    g.server.getTrainPack(g.visitedUser.userSocialId, f1,this);
                }
            }
            return;
        }

        if (g.toolsModifier.modifierType == ToolsModifier.MOVE) {
            onOut();
            if (g.selectedBuild) {  if (g.selectedBuild == this)  g.toolsModifier.onTouchEnded();
            } else {  if (g.isActiveMapEditor) g.townArea.moveBuild(this);
            }
            return;
        } 
        if (_stateBuild == STATE_BUILD) {
            g.hideAllHints();
            g.timerHint.showIt(90,g.cont.gameContX + _source.x * g.currentGameScale,  g.cont.gameContY + (_source.y - _source.height/9) * g.currentGameScale,_dataBuild.buildTime, _leftBuildTime, _dataBuild.priceSkipHard, _dataBuild.name,callbackSkip,onOut);
            g.hint.hideIt();
        } else if (_stateBuild == STATE_ACTIVE || _stateBuild == STATE_READY || _stateBuild == STATE_WAIT_BACK) {
            if (g.toolsModifier.modifierType == ToolsModifier.DELETE) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.FLIP) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.INVENTORY) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.GRID_DEACTIVATED) {
            } else if (g.toolsModifier.modifierType == ToolsModifier.PLANT_SEED || g.toolsModifier.modifierType == ToolsModifier.PLANT_TREES) {
                g.toolsModifier.modifierType = ToolsModifier.NONE;
            } else if (g.toolsModifier.modifierType == ToolsModifier.NONE) {
                if (list.length) {
                        onOut();
                    if (_stateBuild == Train.STATE_READY) {
                        g.windowsManager.openWindow(WindowsManager.WO_TRAIN, null, list, this, _stateBuild, _counter);
                        if (g.managerCutScenes.isCutScene && g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_OPEN_TRAIN)) g.managerCutScenes.checkCutSceneCallback();
                    } else {
                        g.windowsManager.openWindow(WindowsManager.WO_TRAIN_WAIT_BACK, backTrain, list, this, _counter);
                    }
                } else {
                    onOut();
                    var f2:Function = function(ob:Object,t:Train):void {
                        fillList(ob);
                        if (_stateBuild == Train.STATE_READY) {
                            g.windowsManager.openWindow(WindowsManager.WO_TRAIN, null, list, t, _stateBuild, _counter);
                            if (g.managerCutScenes.isCutScene && g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_OPEN_TRAIN)) g.managerCutScenes.checkCutSceneCallback();
                        } else {
                            g.windowsManager.openWindow(WindowsManager.WO_TRAIN_WAIT_BACK, backTrain, list, t, _counter);
                        }
                    };
                    g.server.getTrainPack(g.user.userSocialId, f2,this);
                 }
            }
        } else if (_stateBuild == STATE_UNACTIVE) {
            if (_source.wasGameContMoved) {
                onOut();
                return;
            }
            if (g.user.level < _dataBuild.blockByLevel[0]) {
                g.windowsManager.openWindow(WindowsManager.WO_OPEN_ON_LEVEL,null,'train');
                return;
            }
            onOut();
            if (!_source.wasGameContMoved) g.windowsManager.openWindow(WindowsManager.WO_BUY_CAVE, onBuy, _dataBuild, String(g.managerLanguage.allTexts[621]), 'train');
            g.hint.hideIt();
            if (g.managerCutScenes.isCutScene && g.managerCutScenes.isType(ManagerCutScenes.ID_ACTION_TRAIN_AVAILABLE)) g.managerCutScenes.checkCutSceneCallback();
        } else if (_stateBuild == STATE_WAIT_ACTIVATE) {
            if (_source.wasGameContMoved) {
                onOut();
                return;
            }
            if (_dataBuild.xpForBuild) {
                var start:Point = new Point(int(_source.x), int(_source.y));
                start = _source.parent.localToGlobal(start);
                var d:DropObject = new DropObject();
                d.addDropXP(_dataBuild.xpForBuild, start);
                d.releaseIt();
            }
            _stateBuild = STATE_READY;
            _counter = TIME_READY;
            clearBuildingBuildSprite();
            g.server.openBuildedBuilding(this, onOpenTrain);
            startRenderTrainWork();
            onOut();
            onJustOpenedTrain();
            showBoom();
            g.soundManager.playSound(SoundConst.OPEN_BUILD);
        }
    }

    private function onJustOpenedTrain():void {
        _build.visible = true;
        _arriveAnim.visible = true;
        _arriveAnim.makeArriveKorzina(onArrivedKorzina);
        WorldClock.clock.add(_armature);
        _armature.animation.gotoAndPlayByFrame('work');
        _bolAnimation = true;
    }

    private function onAddUserTrain(s_id:String):void {
        _train_db_id = s_id;
        g.server.updateUserTrainState(_stateBuild, _train_db_id, onUpdate);
    }

    private function onBuy():void {
        if (_arriveAnim) _arriveAnim.visible = false;
        _build.visible = false;
        g.hint.hideIt();
        g.userInventory.addMoney(DataMoney.SOFT_CURRENCY, -_dataBuild.cost);
        _stateBuild = STATE_BUILD;
        _dbBuildingId = 0;
        g.server.startBuildBuilding(this, null);
        addFoundationBuilding();
        g.server.updateUserTrainState(_stateBuild, _train_db_id, null);
        _leftBuildTime = _dataBuild.buildTime[0];
        g.gameDispatcher.addToTimer(renderBuildTrainProgress);
    }

    override public function onOut():void {
        super.onOut();
        if (_buildingBuildSprite.filter) _buildingBuildSprite.filter.dispose();
        _buildingBuildSprite.filter = null;
        if (_source.filter) _source.filter.dispose();
        _build.filter = null;
        g.hint.hideIt();
        _isOnHover = false;
    }

    public function get allXPCount():int {
        if (_dataPack) return int(_dataPack.count_xp);
        else return 0;
    }

    public function get allCoinsCount():int {
        if (_dataPack) return int(_dataPack.count_money);
        return 0;
    }

    private function fillList(ob:Object,t:Train = null):void {
        _dataPack = ob;
        list = [];
        for (var i:int=0; i<_dataPack.items.length; i++) {
            list.push(new TrainCell(_dataPack.items[i]));
        }
        var b:Boolean = false;
        for (i = 0; i < list.length; i++) {
            if (list[i].needHelp) {
                b = true;
                break;
            }
        }
        if (b) {
            _sprHelp = new CSprite();
            _source.addChild(_sprHelp);
            showBubleHelp();
            _sprHelp.y = -305;
            _sprHelp.x = -40;
        }
        if (g.isAway &&  _stateBuild == STATE_READY) {
            _counter = TIME_READY - int(ob.time_work);
            if (_counter < 0) {
                _stateBuild = STATE_WAIT_BACK;
                _arriveAnim.visible = true;
                if (_stateBuild == STATE_UNACTIVE) createBrokenTrain();
                else if (_stateBuild == STATE_READY) onArrivedKorzina();
                else leaveTrain();
            }
        }
    }

    public function needHelp(b:Boolean, n:int):void {
        list[n].needHelp = b;
        if (!_sprHelp) {
            _sprHelp = new CSprite();
            _source.addChild(_sprHelp);
            showBubleHelp();
            _sprHelp.y = -305;
            _sprHelp.x = -40;
        }
    }

    public function fullTrain(full:Boolean, showWindow:Boolean = false):void {
        if (!full && !showWindow) {
            g.windowsManager.openWindow(WindowsManager.WO_TRAIN_SEND, fullTrain);
            return;
        }
        g.server.releaseUserTrainPack(_train_db_id, onReleasePack);
        showBubleHelp(false);
        if (!full){
            onOut();
            return;
        }
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        var d:DropObject = new DropObject();
        d.addDropMoney(DataMoney.SOFT_CURRENCY, _dataPack.count_money, p);
        d.addDropMoney(DataMoney.randomVaucher, 1, p);
        d.addDropXP(int(_dataPack.count_xp), p);
        d.releaseIt();
        
        g.managerAchievement.addAll(10,1);
        if (g.user.wallTrainItem) {
            g.windowsManager.openWindow(WindowsManager.POST_DONE_TRAIN);
            g.server.updateWallTrainItem(null);
            g.user.wallTrainItem = false;
        }
        onOut();
    }

    private function onReleasePack():void {
        _stateBuild = STATE_WAIT_BACK;
        g.server.updateUserTrainState(_stateBuild, _train_db_id, null);
        _counter = TIME_WAIT;
        leaveTrain();
        g.server.updateUserTrainState(_stateBuild, _train_db_id, onNewStateWait);
        _fullTrain = false;
    }

    private function render():void {
        _counter--;
        if (_counter <= 0) {
            if (_stateBuild == STATE_READY) {
                if (_fullTrain){
                    fullTrain(false);
                    g.windowsManager.hideWindow(WindowsManager.WO_TRAIN);
                } else {
                    _stateBuild = STATE_WAIT_BACK;
                    animationYouCanOpen();
                    g.server.updateUserTrainState(_stateBuild, _train_db_id, null);
                    _counter = TIME_WAIT;
                    leaveTrain();
                    showBubleHelp();
                    g.server.updateUserTrainState(_stateBuild, _train_db_id, onNewStateWait);
                    g.windowsManager.hideWindow(WindowsManager.WO_TRAIN);

                }
            } else if (_stateBuild == STATE_WAIT_BACK) {
                _stateBuild = STATE_READY;
                g.server.updateUserTrainState(_stateBuild, _train_db_id, null);
                _counter = TIME_READY;
                arriveTrain();
                g.windowsManager.hideWindow(WindowsManager.WO_TRAIN_WAIT_BACK);
            } else {
                Cc.error('renderTrainWork:: wrong _stateBuild: ' + _stateBuild);
            }
        }
    }

    override public function clearIt():void {
        onOut();
        if (_arriveAnim) _arriveAnim.deleteIt();
        if (_source) _source.touchable = false;
        g.timerHint.hideIt();
        g.gameDispatcher.removeFromTimer(render);
        g.gameDispatcher.removeFromTimer(renderBuildTrainProgress);
        _dataPack = null;
        if (list) list.length = 0;
        if (_armature) {
            WorldClock.clock.remove(_armature);
            _armature.dispose();
            _armature = null;
        }
        super.clearIt();
    }

    private function callbackSkip():void {
        _stateBuild = STATE_WAIT_ACTIVATE;
        animationYouCanOpen();
        g.server.skipTimeOnTrainBuild(_leftBuildTime, _dataBuild.id,null);
        _leftBuildTime = 0;
        g.analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.SKIP_TIMER, {id: AnalyticManager.SKIP_TIMER_BUILDING_BUILD_ID, info: _dataBuild.id});
        renderBuildProgress();
    }

    private function onArrivedKorzina():void {
        _arriveAnim.showKorzina();
        makeIdleAnimation();
        g.managerCutScenes.checkCutScene(ManagerCutScenes.REASON_OPEN_TRAIN);
        _bolAnimation = false;
    }

    private function backTrain():void {
        _counter = 0;
        list.length = 0;
        _stateBuild = STATE_WAIT_BACK;
        g.server.getTrainPack(g.user.userSocialId, fillList);
        render();
    }

    private function showBoom():void {
        _armatureOpenBoom = g.allData.factory['explode'].buildArmature("expl");
        if (_armatureOpenBoom) {
            _source.addChild(_armatureOpenBoom.display as StarlingArmatureDisplay);
            WorldClock.clock.add(_armatureOpenBoom);
            _armatureOpenBoom.addEventListener(EventObject.COMPLETE, onBoom);
            _armatureOpenBoom.addEventListener(EventObject.LOOP_COMPLETE, onBoom);
            _armatureOpenBoom.animation.gotoAndPlayByFrame("start");
        }
    }

    private function onBoom(e:Event=null):void {
        if (_armatureOpenBoom.hasEventListener(EventObject.COMPLETE)) _armatureOpenBoom.removeEventListener(EventObject.COMPLETE, onBoom);
        if (_armatureOpenBoom.hasEventListener(EventObject.LOOP_COMPLETE)) _armatureOpenBoom.removeEventListener(EventObject.LOOP_COMPLETE, onBoom);
        WorldClock.clock.remove(_armatureOpenBoom);
        _source.removeChild(_armatureOpenBoom.display as Sprite);
        _armatureOpenBoom = null;
        g.windowsManager.openWindow(WindowsManager.POST_OPEN_TRAIN);
    }

    public function showBubleHelp(b:Boolean = true):void {
        if (b) {
            if (STATE_READY == _stateBuild) {
                var im:Image;
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('hint_arrow'));
                _sprHelp.addChild(im);
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('exclamation_point'));
                _sprHelp.addChild(im);
                im.x = 21;
                im.y = 20;
                _sprHelp.endClickCallback = onClick;
            } else {
                if (_sprHelp) {
                    while (_sprHelp.numChildren) {
                        _sprHelp.removeChildAt(0);
                    }
                }
            }
        } else {
            if (_sprHelp) {
                while (_sprHelp.numChildren) {
                    _sprHelp.removeChildAt(0);
                }
                _sprHelp = null;
            }
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
