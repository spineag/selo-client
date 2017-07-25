/**
 * Created by andy on 9/9/16.
 */
package quest {
import build.WorldObject;
import build.fabrica.Fabrica;
import build.farm.Animal;
import build.farm.Farm;
import build.lockedLand.LockedLand;
import build.ridge.Ridge;
import build.tree.Tree;

import com.junkbyte.console.Cc;
import data.BuildType;
import data.DataMoney;
import data.StructureDataBuilding;

import dragonBones.animation.WorldClock;

import flash.geom.Point;
import hint.FlyMessage;
import manager.ManagerWallPost;
import manager.Vars;

import mouse.ToolsModifier;

import social.SocialNetworkSwitch;

import tutorial.helpers.HelperReason;

import utils.Link;
import windows.WindowsManager;
import windows.shop.WOShop;

public class ManagerQuest {
    public static const ICON_PATH:String = 'https://505.ninja/content/quest_icon/';

    public static const ADD_TO_GROUP:int = 1;      // +vstyputu v grypy
    public static const ADD_LEFT_MENU:int = 2;     // +dodatu v live menu na VK
    public static const POST:int = 3;              // +zapostutu na stiny
    public static const CRAFT_PLANT:int = 4;       // +zibratu rosluny
    public static const BUILD_BUILDING:int = 5;    // +pobydyvatu zdanie
    public static const RAW_PRODUCT:int = 6;       // +zavantajutu na fabriky
    public static const INVITE_FRIENDS:int = 7;    // +zaprosutu dryziv
    public static const KILL_LOHMATIC:int = 8;     // +zlovutu lohmatuciv
    public static const CRAFT_PRODUCT:int = 9;     // +zibratu resurs fabriki abo fermu
    public static const RAW_PLANT:int = 10;        // +posadutu rosluny
    public static const RELEASE_ORDER:int = 11;    // +zakaz lavku
    public static const BUY_ANIMAL:int = 12;       // +kyputu tvar'
    public static const FEED_ANIMAL:int = 13;      // +pogodyvatu tvar'
    public static const REMOVE_WILD:int = 14;      // +remove wild
    public static const OPEN_TERRITORY:int = 15;   // +open territory
    public static const BUY_CAT:int = 16;          // +buy cat
    public static const NIASH_BUYER:int = 17;      // +vukonatu zamovlennia niawuka-pokyptsia
    public static const KILL_MOUSE:int = 18;       // +zlovutu muwei
    public static const BUY_PAPER:int = 19;        // +kyputu v gazeti
    public static const SET_IN_PAPER:int = 20;     // +vustavutu v gazety
    public static const OPEN_BUILD:int = 21;     // vidkrutu pobydovanyi bydivliy   -> fabrica
    public static const CRAFT_TREE:int = 22;     // zibratu z derev


    private var g:Vars = Vars.getInstance();
    private var _questUI:QuestMainIconUI;
    private var _userQuests:Array;
    private var _currentOpenedQuestInWO:QuestStructure;
    private var _activeTask:QuestTaskStructure;

    public function ManagerQuest() {
        if (!g.useQuests) return;
        _userQuests = [];
        g.load.loadAtlas('questAtlas', 'questAtlas', addUI);
    }

    public function get userQuests():Array { return _userQuests; }
    public function hideQuestsIcons(v:Boolean):void { if (_questUI) _questUI.hideIt(v); }
    public function showArrowsForAllVisibleIconQuests(t:int):void { if (_questUI) _questUI.showArrowsForAllVisibleIconQuests(t); }
    public function checkQuestContPosition():void { if (_questUI) _questUI.checkContPosition(); }
    private function onGetUserQuestAward():void { g.directServer.getUserNewQuests(onGetNewQuests); }
    public function get activeTask():QuestTaskStructure { return _activeTask; }
    public function clearActiveTask():void { _activeTask = null; }
    public function showAnimateOnTaskUpgrade(t:QuestTaskStructure):void { if (_questUI) _questUI.showAnimateOnTaskUpgrade(t); }

    public function addUI():void {
        if (g.user.level >= 4 && g.useQuests) {
            _questUI = new QuestMainIconUI();
            if (g.managerCutScenes.isCutScene) hideQuestsIcons(true);
            g.directServer.getUserQuests(onGetUserQuests);
        }
    }

    private function onGetUserQuests(d:Object):void {
        addQuests(d, false);
        var isDone:Boolean = false;
        checkForEmptyQuests();
        if (_questUI) _questUI.updateIcons();
        for (var i:int=0; i<_userQuests.length; i++) {
            (_userQuests[i] as QuestStructure).checkQuestForDone();
            if ((_userQuests[i] as QuestStructure).isDone) {
                g.directServer.completeUserQuest((_userQuests[i] as QuestStructure).id, (_userQuests[i] as QuestStructure).idDB, null);
                if (!isDone) {
                    g.toolsModifier.modifierType = ToolsModifier.NONE;
                    g.windowsManager.closeAllWindows();
                }
                isDone = true;
                g.windowsManager.openWindow(WindowsManager.WO_QUEST_AWARD, onGetAward, (_userQuests[i] as QuestStructure));
            }
        }
        if (!isDone) getNewQuests();
    }

    public function getNewQuests():void {
        if (g.user.level < 4) return;
        if (g.useQuests) g.directServer.getUserNewQuests(onGetNewQuests);
    }

    private function onGetNewQuests(d:Object):void {
        addQuests(d, true);
        checkForEmptyQuests();
        if (_questUI) _questUI.updateIcons();
    }
    
    private function getUserQuestById(id:int):QuestStructure {
        for (var i:int=0; i<_userQuests.length; i++) {
            if ((_userQuests[i] as QuestStructure).questId == id) return _userQuests[i];
        }
        return null;
    }

    private function addQuests(d:Object, isNew:Boolean):void {
        if (d.quests.length) {
            var q:QuestStructure;
            var i:int;
            for (i=0; i<d.quests.length; i++) {
                if (int(d.quests[i].quest_data.only_testers) == 1 && !g.user.isTester) continue;
//                trace(d.quests[i].quest_data.only_testers);
                q = getUserQuestById(int(d.quests[i].id));
                if (q) {
                    Cc.info('QuestStructure addQuest:: already has quest with id: ' + d.quests[i].id);
                    continue;
                }
                q = new QuestStructure();
                q.fillIt(d.quests[i]);
                q.isNew = isNew;
                _userQuests.push(q);
            }
            for (i=0; i<d.tasks.length; i++) {
                q = getUserQuestById(int(d.tasks[i].quest_id));
                if (q) {
                    q.addTask(d.tasks[i]);
                } else {
                    Cc.error('ManagerQuests addQuest task:: no quest with id: ' + int(d.tasks[i].quest_id));
                }
            }
            if (d.awards) {
                for (i = 0; i < d.awards.length; i++) {
                    q = getUserQuestById(int(d.awards[i].quest_id));
                    if (q) {
                        q.addAward(d.awards[i]);
                    } else {
                        Cc.error('ManagerQuests addQuest award:: no quest with id: ' + int(d.tasks[i].quest_id));
                    }
                }
            } else {
                Cc.error('ManagerQuests addQuest award:: no awards');
            }
        }
    }

    private function checkForEmptyQuests():void {
        for (var i:int=0; i<_userQuests.length; i++) {
            if (_userQuests[i] && !(_userQuests[i] as QuestStructure).tasks.length) {
                Cc.error('ManagerQuest:: no tasks for questID: ' + (_userQuests[i] as QuestStructure).id);
                _userQuests.removeAt(i);
                i--;
            }
        }
    }

    public function showWOForQuest(d:QuestStructure):void {
        _currentOpenedQuestInWO = d;
        g.windowsManager.openWindow(WindowsManager.WO_QUEST, null, d);
    }

    public function onHideWO():void {
        _currentOpenedQuestInWO = null;
        g.gameDispatcher.removeFromTimer(checkWithTimer);
    }

    public function checkOnClickAtWoQuestItem(t:QuestTaskStructure):void {
        var arrT:Array;
        var arr:Array;
        var i:int;
        var j:int;
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2 - 50);
        _activeTask = t;
        switch (t.typeAction) {
            case ADD_LEFT_MENU:
                if (g.isDebug) {
                    onActionForTaskType(ADD_LEFT_MENU);
                    return;
                }
                if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) g.socialNetwork.checkLeftMenu();
                break;
            case ADD_TO_GROUP:
                if (g.isDebug) {
                    onActionForTaskType(ADD_TO_GROUP);
                    return;
                } else {
                    Link.openURL(g.socialNetwork.urlForAnySocialGroup + t.adds);
                    _timer = 3;
                    g.gameDispatcher.addToTimer(checkWithTimer);
                }
                break;
            case POST:
                if (g.isDebug) {
                    onActionForTaskType(POST);
                    return;
                } else g.managerWallPost.postWallpost(ManagerWallPost.POST_FOR_QUEST, null, 0, DataMoney.SOFT_CURRENCY);
                break;
            case CRAFT_PLANT:
                g.windowsManager.closeAllWindows();
                arrT = g.townArea.getCityObjectsByType(BuildType.RIDGE);
                arr = [];
                for (i=0; i<arrT.length; i++) {
                    if ((arrT[i] as Ridge).isFreeRidge) continue;
                    if (t.resourceId == 0 || (arrT[i] as Ridge).plant.dataPlant.id == t.resourceId) {
                        arr.push(arrT[i]);
                    }
                }
                if (arr.length) {
                    for (i = 0; i < arr.length; i++) {
                        (arr[i] as Ridge).showArrow(3);
                    }
                    g.cont.moveCenterToPos((arr[0] as Ridge).posX, (arr[0] as Ridge).posY);
                    return;
                }
                for (i=0; i<arrT.length; i++) {
                    if ((arrT[i] as Ridge).isFreeRidge) {
                        arr.push(arrT[i]);
                    }
                }
                if (arr.length) {
                    for (i=0; i<arr.length; i++) {
                        (arr[i] as Ridge).showArrow(3);
                    }
                    g.cont.moveCenterToPos((arr[0] as Ridge).posX, (arr[0] as Ridge).posY);
                } else {
                    new FlyMessage(p,String(g.managerLanguage.allTexts[596]));
                }
                break;
            case RAW_PLANT:
                g.windowsManager.closeAllWindows();
                arrT = g.townArea.getCityObjectsByType(BuildType.RIDGE);
                arr = [];
                for (i=0; i<arrT.length; i++) {
                    if ((arrT[i] as Ridge).isFreeRidge) {
                        arr.push(arrT[i]);
                    }
                }
                if (arr.length) {
                    for (i=0; i<arr.length; i++) {
                        (arr[i] as Ridge).showArrow(3);
                    }
                    g.cont.moveCenterToPos((arr[0] as Ridge).posX, (arr[0] as Ridge).posY);
                } else {
                    new FlyMessage(p,String(g.managerLanguage.allTexts[597]));
                }
                break;
            case BUILD_BUILDING:
                g.windowsManager.closeAllWindows();
                    if (g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.FABRICA) g.bottomPanel.addArrow('shop', 3, _activeTask.resourceId, HelperReason.REASON_BUY_FABRICA);
                    else if (g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.DECOR || g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.DECOR_ANIMATION
                            || g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.DECOR_TAIL || g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.DECOR_FENCE_GATE
                            || g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.DECOR_FENCE_ARKA || g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.DECOR_FULL_FENСE
                            || g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.DECOR_POST_FENCE || g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.DECOR_POST_FENCE_ARKA) 
                        g.bottomPanel.addArrow('shop', 3, _activeTask.resourceId, HelperReason.REASON_BUY_DECOR);
                    else if (g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.FARM) g.bottomPanel.addArrow('shop', 3, _activeTask.resourceId, HelperReason.REASON_BUY_FARM);
                    else if (g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.ANIMAL) g.bottomPanel.addArrow('shop', 3, _activeTask.resourceId, HelperReason.REASON_BUY_ANIMAL);
                    else if (g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.CAT) g.bottomPanel.addArrow('shop', 3, _activeTask.resourceId, HelperReason.REASON_BUY_HERO);
                    else if (g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.RIDGE) g.bottomPanel.addArrow('shop', 3, _activeTask.resourceId, HelperReason.REASON_BUY_RIDGE);
                    else if (g.allData.getBuildingById(_activeTask.resourceId).buildType == BuildType.TREE) g.bottomPanel.addArrow('shop', 3, _activeTask.resourceId, HelperReason.REASON_BUY_TREE);
                    else g.bottomPanel.addArrow('shop', 3, _activeTask.resourceId, HelperReason.REASON_BUY_FABRICA);
                break;
            case RAW_PRODUCT:
                g.windowsManager.closeAllWindows();
                i = g.allData.getFabricaIdForResourceIdFromRecipe(t.resourceId);
                arrT = g.townArea.getCityObjectsById(i);
                if (arrT.length) {
                    (arrT[0] as WorldObject).showArrow(3);
                    g.cont.moveCenterToPos((arrT[0] as WorldObject).posX - 1, (arrT[0] as WorldObject).posY - 1);
                } else {
                    new FlyMessage(p,String(g.managerLanguage.allTexts[598]));
                }
                break;
            case INVITE_FRIENDS:
                g.windowsManager.closeAllWindows();
                if (g.isDebug) {
                    onActionForTaskType(INVITE_FRIENDS);
                    return;
                }
                g.socialNetwork.showInviteWindow();
                break;
            case KILL_LOHMATIC:
                g.windowsManager.closeAllWindows();
                g.managerLohmatic.addArrowForLohmatics();
                break;
            case CRAFT_PRODUCT:
                g.windowsManager.closeAllWindows();
                i = g.allData.getFabricaIdForResourceIdFromRecipe(t.resourceId);
                if (i==0) i = g.allData.getFarmIdForResourceId(t.resourceId);
                if (i > 0) {
                    arrT = g.townArea.getCityObjectsById(i);
                    if (arrT.length) {
                        for (i=0; i<arrT.length; i++) {
                            (arrT[i] as WorldObject).showArrow(3);
                        }
                        g.cont.moveCenterToPos((arrT[0] as WorldObject).posX, (arrT[0] as WorldObject).posY);
                    } else {
                        new FlyMessage(p,String(g.managerLanguage.allTexts[598]));
                    }
                } else {
                    Cc.error('ManagerQuest checkOnClickAtWoQuestItem CRAFT_PRODUCT:: unknowm resource id: ' + t.resourceId);
                }
                break;
            case RELEASE_ORDER:
                g.windowsManager.closeAllWindows();
                arrT = g.townArea.getCityObjectsByType(BuildType.ORDER);
                if (arrT.length) {
                    (arrT[0] as WorldObject).showArrow(3);
                    g.cont.moveCenterToPos((arrT[0] as WorldObject).posX - 3, (arrT[0] as WorldObject).posY - 3);
                } else {
                    Cc.error('ManagerQuest checkOnClickAtWoQuestItem RELEASE_ORDER:: no Order building (');
                }
                break;
            case BUY_ANIMAL:
                g.windowsManager.closeAllWindows();
                g.bottomPanel.addArrow('shop', 3, _activeTask.resourceId, HelperReason.REASON_BUY_ANIMAL);
                break;
            case FEED_ANIMAL:
                g.windowsManager.closeAllWindows();
                i = g.allData.getFarmIdForAnimal(t.resourceId);
                if (i > 0) {
                    arrT = g.townArea.getCityObjectsById(i);
                    if (arrT.length) {
                        for (i=0; i<arrT.length; i++) {
                            arr = (arrT[i] as Farm).arrAnimals;
                            for (j=0; j<arr.length; j++) {
                                (arr[j] as Animal).addArrow(3);
                            }
                        }
                        g.cont.moveCenterToPos((arrT[0] as WorldObject).posX, (arrT[0] as WorldObject).posY);
                    } else {
                        new FlyMessage(p,String(g.managerLanguage.allTexts[598]));
                    }
                } else {
                    Cc.error('ManagerQuest checkOnClickAtWoQuestItem FEED_ANIMAL:: no farm for aminalId: ' + t.resourceId);
                }
                break;
            case BUY_CAT:
                g.windowsManager.closeAllWindows();
                g.bottomPanel.addArrow('shop', 3,2,HelperReason.REASON_BUY_HERO);
                break;
            case OPEN_TERRITORY:
                g.windowsManager.closeAllWindows();
                arrT = g.townArea.getCityObjectsByType(BuildType.LOCKED_LAND);
                arr = [];
                for (i=0; i<arrT.length; i++) {
                    if ((arrT[i] as LockedLand).dataLockedLand.blockByLevel <= g.user.level) arr.push(arrT[i]);
                }
                if (arr.length) {
                    for (i=0; i<arr.length; i++) {
                        (arr[i] as WorldObject).showArrow(3);
                    }
                    g.cont.moveCenterToPos((arr[0] as WorldObject).posX, (arr[0] as WorldObject).posY);
                } else {
                    new FlyMessage(p,String(g.managerLanguage.allTexts[599]));
                }
                break;
            case BUY_PAPER:
                g.windowsManager.closeAllWindows();
                arrT = g.townArea.getCityObjectsByType(BuildType.PAPER);
                if (arrT.length) {
                    (arrT[0] as WorldObject).showArrow(3);
                    g.cont.moveCenterToXY((arrT[0] as WorldObject).source.x, (arrT[0] as WorldObject).source.y - 50);
                } else {
                    Cc.error('ManagerQuest checkOnClickAtWoQuestItem BUY_PAPER:: no Paper building (');
                }
                break;
            case SET_IN_PAPER:
                g.windowsManager.closeAllWindows();
                arrT = g.townArea.getCityObjectsByType(BuildType.MARKET);
                if (arrT.length) {
                    (arrT[0] as WorldObject).showArrow(3);
                    g.cont.moveCenterToXY((arrT[0] as WorldObject).source.x, (arrT[0] as WorldObject).source.y - 50);
                } else {
                    Cc.error('ManagerQuest checkOnClickAtWoQuestItem SET_IN_PAPER:: no Market building (');
                }
                break;
            case REMOVE_WILD:
                g.windowsManager.closeAllWindows();
                arrT = g.townArea.getCityObjectsByType(BuildType.WILD);
                if (arrT.length) {
                    var c:int = 0;
                    for (i=0; i<arrT.length; i++) {
                        if (arrT[i].dataBuild.id == t.resourceId) {
                            (arrT[i] as WorldObject).showArrow(3);
                            c = i;
                        }
                    }
                    g.cont.moveCenterToPos((arrT[c] as WorldObject).posX, (arrT[c] as WorldObject).posY);
                } else {
                    new FlyMessage(p,String(g.managerLanguage.allTexts[600]));
                }
                break;
            case KILL_MOUSE:
                g.windowsManager.closeAllWindows();
                new FlyMessage(p,String(g.managerLanguage.allTexts[601]));
                break;
            case NIASH_BUYER:
                g.windowsManager.closeAllWindows();
                if (g.managerBuyerNyashuk.isAnyNiash()) {
                    g.cont.moveCenterToPos(28, -5);
                    g.managerBuyerNyashuk.addArrows(3);
                } else new FlyMessage(p,String(g.managerLanguage.allTexts[600]));
                break;
            case OPEN_BUILD:
                g.windowsManager.closeAllWindows();
                if (g.allData.getBuildingById(_activeTask.resourceId).buildType != BuildType.FABRICA) { Cc.error('ManagerQuest:: OPEN_BUILD is only for Fabrica');  return; }
                arrT = g.townArea.getCityObjectsById(_activeTask.resourceId);
                if (arrT[0] && ((arrT[0] as Fabrica).stateBuild == WorldObject.STATE_BUILD || (arrT[0] as Fabrica).stateBuild == WorldObject.STATE_WAIT_ACTIVATE)) {
                    (arrT[0] as Fabrica).showArrow(3);
                    g.cont.moveCenterToPos((arrT[0] as WorldObject).posX, (arrT[0] as WorldObject).posY);
                } else {
                    g.bottomPanel.addArrow('shop', 3, _activeTask.resourceId, HelperReason.REASON_BUY_FABRICA); 
                }
                break;
            case CRAFT_TREE:
                var treeData:StructureDataBuilding = g.allData.getTreeByCraftResourceId(_activeTask.resourceId);
                arrT = g.townArea.getCityObjectsById(treeData.id);
                if (arrT.length) {
                    for (i = 0; i < arrT.length; i++) {
                        (arrT[i] as Tree).showArrow(3);
                    }
                    g.cont.moveCenterToPos((arrT[0] as WorldObject).posX, (arrT[0] as WorldObject).posY);
                } else {
                    new FlyMessage(p,String(g.managerLanguage.allTexts[600]));
                }
                break;
                        
        }
    }

    public function checkQuestForDone(q:QuestStructure):Boolean {
        q.checkQuestForDone();
        if (q.isDone) {
            g.directServer.completeUserQuest(q.id, q.idDB, null);
            g.windowsManager.closeAllWindows();
            g.windowsManager.openWindow(WindowsManager.WO_QUEST_AWARD, onGetAward, q);
            if (_questUI) _questUI.updateIcons();
        }
        return q.isDone;
    }

    private function onGetAward(q:QuestStructure):void {
        for (var i:int=0; i<_userQuests.length; i++) {
            if ((_userQuests[i] as QuestStructure).questId == q.questId) {
                _userQuests.removeAt(i);
                break;
            }
        }
        g.directServer.getUserQuestAward(q.id, q.idDB, onGetUserQuestAward);
    }

    public function onActionForTaskType(type:int, adds:Object=null):void {
        if (!g.useQuests) return;
        var tArr:Array;
        var tasks:Array;
        var i:int;
        if (type == ADD_LEFT_MENU) {
            if (g.socialNetworkID == SocialNetworkSwitch.SN_VK_ID) {
                if (_activeTask && _activeTask.typeAction == ADD_LEFT_MENU) {
                    _activeTask.upgradeCount();
                    g.directServer.updateUserQuestTask(_activeTask, onUpdateQuestTask);
                    _activeTask = null;
                }
            }
        } else if (type == ADD_TO_GROUP) {
            if (_activeTask && _activeTask.typeAction == ADD_TO_GROUP) {
                _activeTask.upgradeCount();
                g.gameDispatcher.removeFromTimer(checkWithTimer);
                g.directServer.updateUserQuestTask(_activeTask, onUpdateQuestTask);
                _activeTask = null;
            }
        } else if (type == POST) {
            if (_activeTask && _activeTask.typeAction == POST) {
                _activeTask.upgradeCount();
                g.directServer.updateUserQuestTask(_activeTask, onUpdateQuestTask);
                _activeTask = null;
            }
        } else if (type == RAW_PLANT || type == CRAFT_PLANT || type == BUILD_BUILDING || type == CRAFT_PRODUCT || type == RAW_PRODUCT
                || type == BUY_ANIMAL || type == FEED_ANIMAL || type == REMOVE_WILD || type == OPEN_BUILD || type == CRAFT_TREE) {
            tArr = getTasksByTypeFromCurrentQuests(type);
            tasks = [];
            for (i=0; i<tArr.length; i++) {
                if ((tArr[i] as QuestTaskStructure).resourceId == adds.id || (tArr[i] as QuestTaskStructure).resourceId == 0) {
                    tasks.push(tArr[i]);
                }
            }
            if (tasks.length) {
                for (i=0; i<tasks.length; i++) {
                    if (!(tasks[i] as QuestTaskStructure).isDone) {
                        (tasks[i] as QuestTaskStructure).upgradeCount();
                        g.directServer.updateUserQuestTask(tasks[i], onUpdateQuestTask);
                    }
                }
            }
        } else if (type == KILL_LOHMATIC || type == KILL_MOUSE || type == INVITE_FRIENDS || type == BUY_CAT || type == RELEASE_ORDER
                || type == NIASH_BUYER || type == OPEN_TERRITORY || SET_IN_PAPER || BUY_PAPER) {
            tArr = getTasksByTypeFromCurrentQuests(type);
            if (tArr.length) {
                for (i=0; i<tArr.length; i++) {
                    if (!(tArr[i] as QuestTaskStructure).isDone) {
                        (tArr[i] as QuestTaskStructure).upgradeCount();
                        g.directServer.updateUserQuestTask(tArr[i], onUpdateQuestTask);
                    }
                }
            }
        }
    }

    private function onUpdateQuestTask(task:QuestTaskStructure):void {
        if (task.isDone && !task.isSavedOnServerAfterFinish) {
            task.onSaveOnServerAfterFinish();
            checkQuestForDone( getUserQuestById( task.questId));
        }
    }
    
    private function getTasksByTypeFromCurrentQuests(type:int):Array {
        var ar:Array = [];
        var arT:Array;
        for (var i:int=0; i<_userQuests.length; i++) {
            arT = (_userQuests[i] as QuestStructure).getTasksByType(type);
            if (arT.length) ar = ar.concat(arT);
        }
        return ar;
    }

    public function checkInGroup():void {
        if (_activeTask) g.socialNetwork.checkIsInSocialGroup(_activeTask.adds);
        else g.gameDispatcher.removeFromTimer(checkWithTimer);
    }

    private var _timer:int;
    private function checkWithTimer():void {
        _timer--;
        if (_timer <= 0) {
            checkInGroup();
            _timer = 3;
        }
    }
    
}
}
