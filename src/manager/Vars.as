/**
 * Created by user on 5/13/15.
 */
package manager {
import achievement.ManagerAchievement;
import additional.butterfly.ManagerButterfly;
import additional.buyerNyashuk.ManagerBuyerNyashuk;
import additional.lohmatik.ManagerLohmatik;
import additional.mouse.ManagerMouse;
import additional.pets.ManagerPets;
import analytic.AnalyticManager;
import announcement.ManagerAnnouncement;
import build.TownAreaTouchManager;
import build.farm.FarmGrid;
import data.AllData;
import data.BuildType;
import heroes.ManagerCats;
import heroes.ManagerQuestCats;

import hint.PartyHint;
import hint.PetHint;
import order.DataOrderCat;
import order.ManagerOrder;
import order.ManagerOrderCats;
import hint.BuyHint;
import hint.LevelUpHint;
import hint.MarketHint;
import hint.ResourceHint;
import hint.TreeHint;
import hint.FabricHint;
import hint.Hint;
import hint.MouseHint;
import hint.TimerHint;
import hint.WildHint;
import loaders.DataPath;
import loaders.LoadAnimationManager;
import loaders.LoaderManager;
import loaders.allLoadMb.AllLoadMb;
import manager.hitArea.ManagerHitArea;
import manager.ownError.ErrorConst;
import manager.ownError.OwnErrorManager;
import map.BackgroundArea;
import map.Containers;
import map.MatrixGrid;
import map.TownArea;
import media.SoundManager;
import mouse.OwnMouse;
import mouse.ToolsModifier;
import preloader.StartPreloader;
import quest.ManagerQuest;
import server.DirectServer;
import server.ManagerPendingRequest;
import social.SocialNetwork;
import social.SocialNetworkSwitch;
import starling.core.Starling;
import starling.display.Stage;
import temp.dataTemp.DataLevel;
import temp.deactivatedArea.DeactivatedAreaManager;
import temp.EditorButtonInterface;
import temp.MapEditorInterface;
import tutorial.IManagerTutorial;
import tutorial.helpers.ManagerHelpers;
import tutorial.managerCutScenes.ManagerCutScenes;
import tutorial.miniScenes.ManagerMiniScenes;
import tutorial.tips.ManagerTips;
import tutorial.tutorial.TutorialManager;
import ui.achievementPanel.AchievementPanel;
import ui.bottomInterface.MainBottomPanel;
import ui.couponePanel.CouponePanel;
import ui.craftPanel.CraftPanel;
//import ui.miniParty.MiniPartyPanel;
import ui.party.PartyPanel;
import ui.friendPanel.FriendPanel;
import ui.optionPanel.OptionPanel;
import ui.sale.SalePanel;
import ui.softHardCurrencyPanel.SoftHardCurrency;
import ui.starterPackPanel.StarterPackPanel;
import ui.stock.StockPanel;
import ui.testerPanel.TesterPanelTop;
import ui.toolsPanel.ToolsPanel;
import ui.xpPanel.XPPanel;
import user.Someone;
import user.User;
import user.UserInventory;
import user.UserTimer;
import user.UserValidateResources;
import utils.FarmDispatcher;
import utils.TimeUtils;
import utils.Utils;
import windows.WindowsManager;
import build.WorldObject;
import build.ambar.Ambar;
import com.junkbyte.console.Cc;
import dragonBones.animation.WorldClock;

//148.251.121.199
public class Vars {
    private static var _instance:Vars;
    public const HARD_IN_SOFT_FB:int = 5; // 1 хард стоит 20 софт
    public const HARD_IN_SOFT_OK:int = 5; // 1 хард стоит 20 софт
    public const HARD_IN_SOFT_VK:int = 20; // 1 хард стоит 20 софт

    public var starling:Starling;
    public var mainStage:Stage;
    public var scaleFactor:Number;
    public var currentGameScale:Number = 1;
    public var realGameWidth:int = 7468;
    public var realGameHeight:int = 5000;
    public var realGameTilesWidth:int = 6782;
    public var realGameTilesHeight:int = 3400;
    public var isAway:Boolean = false;
    public var visitedUser:Someone;
    public var isActiveMapEditor:Boolean = false;
    public var socialNetwork:SocialNetwork;
    public var isGameLoaded:Boolean = false;
    public var flashVars:Object;
    public var socialNetworkID:int;
    public var isDebug:Boolean = false;
    public var version:Object;

    public var mapEditor:MapEditorInterface;
    public var editorButtons:EditorButtonInterface;
    public var deactivatedAreaManager:DeactivatedAreaManager;
    public var managerFabricaRecipe:ManagerFabricaRecipe;
    public var managerPlantRidge:ManagerPlantRidge;
    public var managerTree:ManagerTree;
    public var managerAnimal:ManagerAnimal;
    public var managerPaper:ManagerPaper;
    public var managerChest:ManagerChest;
    public var lateAction:ManagerLateAction;
    public var loadMb:AllLoadMb;
    public var load:LoaderManager;
    public var loadAnimation:LoadAnimationManager;
    public var pBitmaps:Object;
    public var pXMLs:Object;
    public var pJSONs:Object;
    public var managerOrder:ManagerOrder;
    public var managerOrderCats:ManagerOrderCats;
    public var managerDailyBonus:ManagerDailyBonus;
    public var managerCutScenes:ManagerCutScenes;
    public var miniScenes:ManagerMiniScenes;
    public var managerWallPost:ManagerWallPost;
    public var managerInviteFriend:ManagerInviteFriendViral;
    public var managerTimerSkip:ManagerTimerSkip;
    public var managerParty:ManagerPartyNew;
    public var managerMiniParty:ManagerMiniParty;
    public var managerSalePack:ManagerSalePack;
    public var managerStarterPack:ManagerStarterPack;
    public var managerLanguage:ManagerLanguage;
    public var managerPets:ManagerPets;
    public var managerNews:ManagerNews;
    public var cont:Containers;
    public var ownMouse:OwnMouse;
    public var toolsModifier:ToolsModifier;

    public var matrixGrid:MatrixGrid;
    public var townArea:TownArea;
    public var townAreaTouchManager:TownAreaTouchManager;
    public var farmGrid:FarmGrid;
    public var background:BackgroundArea;

    public var allData:AllData;
    public var dataLevel:DataLevel;
    public var dataCats:Array;

    public var timerHint:TimerHint;
    public var partyHint:PartyHint;
    public var wildHint:WildHint;
    public var hint:Hint;
    public var buyHint:BuyHint;
    public var mouseHint:MouseHint;
    public var fabricHint:FabricHint;
    public var treeHint:TreeHint;
    public var petHint:PetHint;
    public var resourceHint:ResourceHint;
    public var marketHint:MarketHint;
    public var levelUpHint:LevelUpHint;
    public var xpPanel:XPPanel;
    public var softHardCurrency:SoftHardCurrency;
    public var couponePanel:CouponePanel;
    public var bottomPanel:MainBottomPanel;
    public var craftPanel:CraftPanel;
    public var optionPanel:OptionPanel;
    public var friendPanel:FriendPanel;
    public var toolsPanel:ToolsPanel;
    public var stockPanel:StockPanel;
    public var starterPanel:StarterPackPanel;
    public var partyPanel:PartyPanel;
    //public var miniPartyPanel:MiniPartyPanel;
    public var salePanel:SalePanel;
    public var achievementPanel:AchievementPanel;
    public var testerPanel:TesterPanelTop;

    public var windowsManager:WindowsManager;
    public var managerHitArea:ManagerHitArea;
    public var selectedBuild:WorldObject;
    public var lastActiveDecorID:int = 0;

    public var server:DirectServer;
    public var startPreloader:StartPreloader;
    public var dataPath:DataPath;

    public var errorManager:OwnErrorManager;
    public var analyticManager:AnalyticManager;
    public var managerCats:ManagerCats;
    public var managerQuestCats:ManagerQuestCats;
    public var tuts:IManagerTutorial;
    public var managerButterfly:ManagerButterfly;
    public var managerHelpers:ManagerHelpers;
    public var soundManager:SoundManager;
    public var managerTips:ManagerTips;
    public var gameDispatcher:FarmDispatcher;
    public var user:User;
    public var userInventory:UserInventory;
    public var userValidates:UserValidateResources;
    public var userTimer:UserTimer;
    public var managerDropResources:ManagerDropBonusResource;
    public var managerLohmatic:ManagerLohmatik;
    public var managerBuyerNyashuk:ManagerBuyerNyashuk;
    public var managerMouseHero:ManagerMouse;
    public var managerQuest:ManagerQuest;
    public var managerPendingRequest:ManagerPendingRequest;
    public var managerVisibleObjects:ManagerVisibleObjects;
    public var managerResize:ManagerResize;
    public var managerAchievement:ManagerAchievement;
    public var managerAnnouncement:ManagerAnnouncement;
    public var useQuests:Boolean = true;

    public static function getInstance():Vars {
        if (!_instance) _instance = new Vars(new SingletonEnforcer());
        return _instance;
    }

    public function Vars(se:SingletonEnforcer) {
        if (!se) {
            throw(new Error("use Objects.getInstance() instead!!"));
        }
    }

    public function startUserLoad():void {
        townArea = new TownArea();
        farmGrid = new FarmGrid();
        dataLevel = new DataLevel();
        userValidates = new UserValidateResources();
        soundManager = new SoundManager();
        userTimer = new UserTimer();
        managerDailyBonus = new ManagerDailyBonus();
        managerChest = new ManagerChest();
        managerMouseHero = new ManagerMouse();
        gameDispatcher = new FarmDispatcher(mainStage);
        loadMap();
    }

    private function loadMap():void {           startPreloader.setProgress(76); background = new BackgroundArea(onLoadMap); }
    private function onLoadMap():void {         startPreloader.setProgress(77); (server as DirectServer).getDataOutGameTiles(onGetOutGameTiles); }
    private function onGetOutGameTiles():void { startPreloader.setProgress(78); (server as DirectServer).getDataLevel(onDataLevel); }
    private function onDataLevel():void {       startPreloader.setProgress(79); (server as DirectServer).getUserInfo(loadManagerLanguqage); }
    private function loadManagerLanguqage():void { managerLanguage = new ManagerLanguage(initInterface); }

    public function initInterface():void {
        try {
            (user as User).createNeighbor();
            cont.hideAll(true);
            startPreloader.setProgress(80);
            userInventory = new UserInventory();

            tuts = new TutorialManager();
            managerCutScenes = new ManagerCutScenes();
            managerWallPost = new ManagerWallPost();
            managerTimerSkip = new ManagerTimerSkip();
            managerMouseHero = new ManagerMouse();
            miniScenes = new ManagerMiniScenes();
            managerAchievement = new ManagerAchievement();

            new ManagerFilters();
            new DataOrderCat();
            ownMouse = new OwnMouse();
            toolsModifier = new ToolsModifier();
            toolsModifier.setTownArray();

            managerCats = new ManagerCats();
            managerQuestCats = new ManagerQuestCats();
            managerOrderCats = new ManagerOrderCats();
            townAreaTouchManager = new TownAreaTouchManager();
            achievementPanel = new AchievementPanel();
            initInterface2();

        } catch (e:Error) {
            errorManager.onGetError(ErrorConst.ON_INIT2, true, true);
            Cc.stackch('error', 'initVariables::', 10);
        }
    }

    private function initInterface2():void {
        soundManager.load();
        managerCats.addAllHeroCats();
        managerStarterPack = new ManagerStarterPack();
        managerSalePack = new ManagerSalePack();
        startPreloader.setProgress(81);
//        if (tuts.isTuts) {
//            loadAnimation.load('animations_json/x1/cat_tutorial', 'tutorialCat', onLoadCatTutorial); // no need for loading this
//        } else {
//            if ((user as User).level == 3) {
                onLoadCatTutorial();
//            } else server.getDataResource(onDataResource);
//        }
    }
    
    private function onLoadCatTutorial():void {
        startPreloader.setProgress(82);
        var st:String;
        if (managerResize.stageWidth < 1040 || managerResize.stageHeight < 700) st = 'animations_json/cat_tutorial_small';
        else st = 'animations_json/cat_tutorial';
        loadAnimation.load(st, 'tutorialCatBig', onLoadCatTutorialBig);
    }
    private function onLoadCatTutorialBig():void { startPreloader.setProgress(83); (server as DirectServer).getDataResource(onDataResource); }
    private function onDataResource():void {       startPreloader.setProgress(84); (server as DirectServer).getDataRecipe(onDataRecipe); }
    private function onDataRecipe():void {         startPreloader.setProgress(85); (server as DirectServer).getDataAnimal(onDataAnimal); }
    private function onDataAnimal():void {         startPreloader.setProgress(86); (server as DirectServer).getDataCats(onDataCats); }
    private function onDataCats():void {           startPreloader.setProgress(87); (server as DirectServer).getDataBuyMoney(onDataBuyMoney); }

    private function onDataBuyMoney():void {
        startPreloader.setProgress(88);
        (server as DirectServer).getDataLockedLand(onDataLockedLand);
    }

    private function onDataLockedLand():void {     startPreloader.setProgress(89); (server as DirectServer).getDataBuilding(onDataBuilding); }
    private function onDataBuilding():void {       startPreloader.setProgress(90); (server as DirectServer).getUserResource(onUserResource); }
    private function onUserResource():void {       startPreloader.setProgress(91); (server as DirectServer).getUserBuilding(onUserBuilding); }
    private function onUserBuilding():void {       startPreloader.setProgress(92); (server as DirectServer).getUserFabricaRecipe(onUserFabricaRecipe); }
    private function onUserFabricaRecipe():void {  startPreloader.setProgress(93); (server as DirectServer).getUserPlantRidge(onUserPlantRidge); }
    private function onUserPlantRidge():void {     startPreloader.setProgress(94); (server as DirectServer).getUserTree(onUserTree); }
    private function onUserTree():void {           startPreloader.setProgress(95); (server as DirectServer).getUserAnimal(onUserAnimal); }
    private function onUserAnimal():void {         startPreloader.setProgress(96); (server as DirectServer).getUserTrain(onUserTrain); }
    private function onUserTrain():void {          startPreloader.setProgress(97); (server as DirectServer).getUserWild(onUserWild); }

    private function onUserWild():void {
        startPreloader.setProgress(98);
        managerOrder = new ManagerOrder();
        managerOrder.updateMaxCounts();
        (server as DirectServer).getUserOrder(onUserOrder);
    }

    private function onUserOrder():void {
        managerOrderCats.addCatsOnStartGame();
        startPreloader.setProgress(99);
        (user as User).friendAppUser();
        initVariables2();
    }

    private function initVariables2():void {
//        if (socialNetworkID == SocialNetworkSwitch.SN_OK_ID || ( socialNetworkID == SocialNetworkSwitch.SN_FB_ID && (user as User).isTester) ||
//               ( socialNetworkID == SocialNetworkSwitch.SN_VK_ID && (user as User).isTester)) useQuests = true; // для ТЕСТЕРІВ ОНЛІ ДЛЯ ТЕСТЕРІВ АХТУНГ АХТУНГ АХТУНГ АХТУНГ АХТУНГ АХТНУГ АХТУНГ АХТУНГ
        useQuests = true;
        timerHint = new TimerHint();
        partyHint = new PartyHint();
        wildHint = new WildHint();
        hint = new Hint();
        buyHint = new BuyHint();
        mouseHint = new MouseHint();
        fabricHint = new FabricHint();
        treeHint = new TreeHint();
        petHint = new PetHint();
        resourceHint = new ResourceHint();
        marketHint = new MarketHint();
        levelUpHint = new LevelUpHint();
        xpPanel = new XPPanel();
        couponePanel = new CouponePanel();
        softHardCurrency = new SoftHardCurrency();
        friendPanel = new FriendPanel();
        bottomPanel = new MainBottomPanel();
        craftPanel = new CraftPanel();
        toolsPanel = new ToolsPanel();
        testerPanel =new TesterPanelTop();

//        if ((user as User).level >= 5 && userTimer.saleTimerToEnd <= 0 && softHardCurrency.actionON) {
        (server as DirectServer).getDataStockPack(afterServerStock);
//            stockPanel = new StockPanel();
//        }
        managerQuest = new ManagerQuest();
        managerParty = new ManagerPartyNew();
        managerMiniParty = new ManagerMiniParty();
        optionPanel = new OptionPanel();
        (server as DirectServer).getDataParty(afterLoadAll);
    }

    private function afterLoadAll():void {
        cont.onLoadAll();
        startPreloader.setProgress(100);
        soundManager.managerMusic(true);
        soundManager.checkAnimal();
        if (currentGameScale != 1) cont.makeScaling(currentGameScale, false, true);
        cont.moveCenterToXY(350, realGameTilesHeight / 2 - 700 * scaleFactor, true);

        windowsManager = new WindowsManager();
        managerDropResources = new ManagerDropBonusResource();
        managerPaper = new ManagerPaper();
        managerPaper.getPaperItems();
        managerCats.setAllCatsToRandomPositionsAtStartGame();
        managerDailyBonus.checkDailyBonusStateBuilding();
        lateAction = new ManagerLateAction();
        isGameLoaded = true;

        if ((user as User).isMegaTester) {
            Cc.addSlashCommand("openMapEditor", openMapEditorInterface);
            Cc.addSlashCommand("closeMapEditor", closeMapEditorInterface);
        }

        if ((user as User).isTester) {
            var f1:Function = function ():void {
                (server as DirectServer).deleteUser(f2);
            };
            var f2:Function = function ():void {
                windowsManager.openWindow(WindowsManager.WO_RELOAD_GAME);
            };
            Cc.addSlashCommand("deleteUser", f1);
        }
        softHardCurrency.checkHard();
        softHardCurrency.checkSoft();
        xpPanel.updateProgressBarXP();
        managerOrder.checkOrders();
        gameDispatcher.addEnterFrame(onEnterFrameGlobal);
        updateAmbarIndicator();
        gameDispatcher.addNextFrameFunction(afterLoadAll_2);

        if (socialNetworkID == SocialNetworkSwitch.SN_FB_ID) (server as DirectServer).getDataInviteViral(onViralInvite);
    }

    private function afterLoadAll_2():void {
        townArea.zSort();
        townArea.decorTailSort();
        gameDispatcher.addNextFrameFunction(afterLoadAll_3);
    }

    private function afterLoadAll_3():void {
        townArea.sortAtLockedLands();
        managerOrder.checkForFullOrder();
        if ((user as User).level >= allData.getBuildingById(45).blockByLevel[0]) managerDailyBonus.generateDailyBonusItems();
        townArea.addTownAreaSortCheking();

        managerHelpers = new ManagerHelpers();
        managerPendingRequest = new ManagerPendingRequest();
        managerChest.createChest();
        managerVisibleObjects = new ManagerVisibleObjects();
        managerVisibleObjects.checkInStaticPosition();
        gameDispatcher.addNextFrameFunction(afterLoadAll_4);
        managerPets = new ManagerPets();
        managerNews = new ManagerNews();
    }

    private function afterLoadAll_4():void {
        (user as User).notif.onGameLoad();
        if (tuts.isTuts) {
            if ((user as User).tutorialStep > 1) {
                startPreloader.hideIt();
                startPreloader = null;
            }
            managerOrder.showSmallHeroAtOrder(false);
            tuts.onGameStart();
            tuts.checkDefaults();
        } else {
            startPreloader.hideIt();
            startPreloader = null;
            managerCutScenes.checkAvailableCutScenes();
            miniScenes.checkAvailableMiniScenesOnNewLevel();
            var todayDailyGift:Date;
            var today:Date;
                if ((user as User).salePack) {
                    if (managerSalePack.userSale.typeSale == 1) windowsManager.openWindow(WindowsManager.WO_SALE_PACK_RUBIES, null, true);
                    else if (managerSalePack.userSale.typeSale == 2) windowsManager.openWindow(WindowsManager.WO_SALE_PACK_INSTRUMENTS, null, false);
                    else windowsManager.openWindow(WindowsManager.WO_SALE_PACK_VAUCHERS, null, false);
                } else if (((user as User).level >= 6) && ((user as User).starterPack == 0)  && !managerCutScenes.isCutScene && userTimer.starterTimerToEnd > 0) {
                    afterServerStarterPack(true);
                    windowsManager.openWindow(WindowsManager.WO_STARTER_PACK, null);
               } else {
                   if ((user as User).level >= 5 && (user as User).dayDailyGift == 0  && !managerCutScenes.isCutScene) (server as DirectServer).getDailyGift(null);
                   else {
                       todayDailyGift = new Date((user as User).dayDailyGift * 1000);
                       today = new Date((user as User).day * 1000);
                       if ((user as User).level >= 5 && todayDailyGift.date != today.date) (server as DirectServer).getDailyGift(null);
                   }
               }
            var f:Function = function ():void {
                if (managerParty.loadAll) {
                    gameDispatcher.removeEnterFrame(f);
                    if (managerParty.showEndWindow) windowsManager.openWindow(WindowsManager.WO_PARTY_CLOSE, null);
                    else if (managerParty.eventOn) windowsManager.openWindow(WindowsManager.WO_PARTY, null);
                }
            };
            gameDispatcher.addEnterFrame(f);
//            var f1:Function = function ():void {
//                if (!windowsManager.currentWindow && userTimer.partyToEndTimer <= 0 && managerParty.userParty && !managerParty.userParty.showWindow
//                        && (managerParty.dataPartyNowUse.typeParty == 3 || managerParty.dataPartyNowUse.typeParty == 4 || managerParty.typeParty == 5)  && !managerCutScenes.isCutScene) managerParty.endPartyWindow();
//                };
//                Utils.createDelay(5,f1);
//            if (!windowsManager.currentWindow && userTimer.partyToEndTimer <= 0 && managerParty.userParty && !managerParty.userParty.showWindow
//                        && (managerParty.typeParty == 3 || managerParty.typeParty == 4 || managerParty.typeParty == 5)  && !managerCutScenes.isCutScene) managerParty.endPartyWindow();
//                else if (managerParty.userParty && !managerParty.userParty.showWindow && managerParty.userParty.countResource >= managerParty.countToGift[0] && (managerParty.typeParty == 1 || managerParty.typeParty == 2)) {
//                    managerParty.endPartyWindow();
//                }
//               Utils.createDelay(5,f1);
            }
            if ((user as User).miniScenes[3] == 0) friendPanel.hideIt(true);
            miniScenes.updateMiniScenesLengthOnGameStart();
            managerButterfly = new ManagerButterfly();
            managerButterfly.createBFlyes();
            managerButterfly.startButterflyFly();
            managerLohmatic = new ManagerLohmatik();
            if ((user as User).level >= 3 && !managerCutScenes.isCutScene && !tuts.isTuts) managerBuyerNyashuk = new ManagerBuyerNyashuk();
//            if ((user as User).level >= 7 && socialNetworkID == SocialNetworkSwitch.SN_FB_ID) managerBuyerNyashuk = new ManagerBuyerNyashuk();

            analyticManager = new AnalyticManager();
            analyticManager.sendActivity(AnalyticManager.EVENT, AnalyticManager.ACTION_ON_LOAD_GAME, {id: 1});
        
        if ((user as User).level >= 4) managerAnnouncement = new ManagerAnnouncement();
        if ((user as User).level >= 4) {
            gameDispatcher.addToTimer(managerCats.timerRandomWorkMan);
            gameDispatcher.addToTimer(managerCats.timerRandomWorkWoman);
        }
    }

    private function onEnterFrameGlobal():void {
        try {
            WorldClock.clock.advanceTime(-1);
        } catch (e:Error) {
            errorManager.onGetError(ErrorConst.WORLD_CLOCK, true);
        }
    }

    private function openMapEditorInterface():void {
        if ((user as User).isMegaTester) {
            mapEditor = new MapEditorInterface();
            editorButtons = new EditorButtonInterface();
            deactivatedAreaManager = new DeactivatedAreaManager();
            cont.interfaceContMapEditor.visible = true;
            matrixGrid.drawDebugGrid();
            isActiveMapEditor = true;
            townArea.onOpenMapEditor(true);
        }
    }

    private function closeMapEditorInterface():void {
        deactivatedAreaManager.clearIt();
        isActiveMapEditor = false;
        matrixGrid.deleteDebugGrid();
        mapEditor.deleteIt();
        cont.interfaceContMapEditor.visible = false;
        toolsModifier.modifierType = ToolsModifier.NONE;
        townArea.onOpenMapEditor(false);
    }

    public function hideAllHints():void {
        if (timerHint) timerHint.managerHide();
        if (partyHint) partyHint.managerHide();
        if (wildHint) wildHint.managerHide();
//        if (farmHint) farmHint.hideIt();
        if (mouseHint) mouseHint.hideIt();
        if (fabricHint) fabricHint.hideIt();
        if (treeHint) treeHint.managerHide();
        if (petHint) petHint.managerHide();
        if (resourceHint) resourceHint.hideIt();
        if (hint) (hint as Hint).hideIt();
    }

    public function updateAmbarIndicator():void {
        var a:WorldObject = townArea.getCityObjectsByType(BuildType.AMBAR)[0];
        if (a) (a as Ambar).updateIndicatorProgress();
    }

    public function getVersion(st:String):String {  if (version[st]) return '?v='+version[st];  else return ''; }
    public function createSaleUi():void { salePanel = new SalePanel(); }
    public function updateRepository():void { if (toolsPanel && toolsPanel.repositoryBox) toolsPanel.repositoryBox.updateItems(); }
    private function onViralInvite(data:Object):void {  managerInviteFriend = new ManagerInviteFriendViral(data); }
    private function afterServerStock(b:Boolean = false):void { if (b) stockPanel = new StockPanel(); }
    public function afterServerStarterPack(b:Boolean = false):void { if (b) starterPanel = new StarterPackPanel(); }
}
}

class SingletonEnforcer{}
