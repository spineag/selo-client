/**
 * Created by user on 3/24/16.
 */
package windows {
import com.junkbyte.console.Cc;
import manager.Vars;

import mouse.ToolsModifier;

import windows.achievementWindow.WOAchievement;
import windows.ambar.WOAmbars;
import windows.ambarFilled.WOAmbarFilled;
import windows.announcement.WOAnnouncement;
import windows.anotherGameError.WOAnotherGame;
import windows.buyCoupone.WOBuyCoupone;
import windows.buyCurrency.WOBuyCurrency;
import windows.buyForHardCurrency.WOBuyForHardCurrency;
import windows.buyPlant.WOBuyPlant;
import windows.buyerNyashuk.WOBuyerNyashuk;
import windows.cave.WOBuyCave;
import windows.cave.WOCave;
import windows.chestWindow.WOChest;
import windows.chestYellowWindow.WOChestYellow;
import windows.dailyBonusWindow.WODailyBonus;
import windows.dailyGiftWindow.WODailyGift;
import windows.fabricaWindow.WOFabricDeleteItem;
import windows.inviteFriendsViralInfo.WOInviteFriendsViralInfo;
import windows.missYou.WOMissYou;
import windows.partyWindow.WOPartyHelp;
import windows.partyWindow.WOPartyWindow;
import windows.fabricaWindow.WOFabrica;
import windows.gameError.WOGameError;
import windows.inviteFriends.WOInviteFriends;
import windows.lastResource.WOLastResource;
import windows.levelUp.WOLevelUp;
import windows.lockedLand.WOLockedLand;
import windows.market.WOMarket;
import windows.market.WOMarketChoose;
import windows.market.WOMarketDeleteItem;
import windows.noFreeCats.WONoFreeCats;
import windows.noFreeCats.WOWaitFreeCats;
import windows.noPlaces.WONoPlaces;
import windows.noResources.WONoResources;
import windows.orderWindow.WOOrder;
import windows.paperWindow.WOPapper;
import windows.partyWindow.WOPartyWindowClose;
import windows.quest.WOQuest;
import windows.questAward.WOQuestFinishAward;
import windows.questList.WOQuestList;
import windows.reloadPage.WOReloadGame;
import windows.salePack.WOSalePack;
import windows.serverCrack.WOServerCrack;
import windows.serverError.WOServerError;
import windows.serverNoWork.WOSeverNoWork;
import windows.shop.WOShop;
import windows.starterPackWindow.WOStarterPack;
import windows.tipsWindow.WOTips;
import windows.train.WOTrain;
import windows.train.WOTrainOrder;
import windows.train.WOTrainSend;
import windows.wallPost.PostDoneOrder;
import windows.wallPost.PostDoneTrain;
import windows.wallPost.PostOpenCave;
import windows.wallPost.PostOpenFabric;
import windows.wallPost.PostOpenLand;
import windows.wallPost.PostOpenTrain;

public class WindowsManager {
    public static const WO_AMBAR:String = 'ambar_and_sklad';
    public static const WO_AMBAR_FILLED:String = 'ambar_filled';
    public static const WO_BUY_COUPONE:String = 'buy_coupone'; 
    public static const WO_BUY_CURRENCY:String = 'buy_currency';
    public static const WO_BUY_FOR_HARD:String = 'buy_for_hard_currency';
    public static const WO_BUY_PLANT:String = 'buy_plant';
    public static const WO_CAVE:String = 'cave';
    public static const WO_BUY_CAVE:String = 'buy_cave';
    public static const WO_DAILY_BONUS:String = 'daily_bonus';
    public static const WO_FABRICA:String = 'fabrica_recipe';
    public static const WO_GAME_ERROR:String = 'game_error';
    public static const WO_LAST_RESOURCE:String = 'last_resource';
    public static const WO_LEVEL_UP:String = 'level_up';
    public static const WO_LOCKED_LAND:String = 'locked_land';
    public static const WO_MARKET:String = 'market';
    public static const WO_MARKET_CHOOSE:String = 'market_choose';
    public static const WO_MARKET_DELETE_ITEM:String = 'market_delete_item';
    public static const WO_NO_FREE_CATS:String = 'no_free_cats';
    public static const WO_WAIT_FREE_CATS:String = 'wait_free_cats';
    public static const WO_NO_PLACES:String = 'no_places';
    public static const WO_NO_RESOURCES:String = 'no_resources';
    public static const WO_ORDERS:String = 'orders';
    public static const WO_PAPPER:String = 'papper';
    public static const WO_RELOAD_GAME:String = 'reload_game';
    public static const WO_SERVER_ERROR:String = 'server_error';
    public static const WO_SERVER_CRACK:String = 'server_crack';
    public static const WO_ANOTHER_GAME_ERROR:String = 'another_game';
    public static const WO_SHOP:String = 'shop';
    public static const WO_TRAIN:String = 'train';
    public static const WO_TRAIN_ORDER:String = 'train_order';
    public static const WO_TRAIN_SEND:String = 'train_send';
    public static const WO_CHEST:String = 'chest';
    public static const WO_INVITE_FRIENDS:String = 'invite_friends';
    public static const WO_INVITE_FRIENDS_VIRAL_INFO:String = 'invite_friends_viral_info';
    public static const POST_OPEN_LAND:String = 'post_open_land';
    public static const POST_OPEN_CAVE:String = 'post_open_cave';
    public static const POST_OPEN_TRAIN:String = 'post_open_train';
    public static const POST_OPEN_FABRIC:String = 'post_open_fabric';
    public static const POST_DONE_TRAIN:String = 'post_done_train';
    public static const POST_DONE_ORDER:String = 'post_done_order';
    public static const WO_SERVER_NO_WORK:String = 'server_no_work';
    public static const WO_DAILY_GIFT:String = 'daily_gift';
    public static const WO_BUYER_NYASHUK:String = 'buyer_nyashuk';
    public static const WO_TIPS:String = 'tips';
    public static const WO_QUEST:String = 'quest';
    public static const WO_QUEST_LIST:String = 'quest_list';
    public static const WO_QUEST_AWARD:String = 'quest_award';
    public static const WO_CHEST_YELLOW:String = 'chest_yellow';
    public static const WO_STARTER_PACK:String = 'starter_pack';
    public static const WO_PARTY:String = 'party';
    public static const WO_PARTY_HELP:String = 'party_help';
    public static const WO_PARTY_CLOSE:String = 'party_close';
    public static const WO_FABRIC_DELETE_ITEM:String = 'fabric_delete_item';
    public static const WO_SALE_PACK:String = 'sale_pack';
    public static const WO_ACHIEVEMENT:String = 'achievement';
    public static const WO_MISS_YOU:String = 'miss_you';
    public static const WO_ANNOUNCEMENT:String = 'announcement';

    private var _currentWindow:WindowMain;
    private var _cashWindow:WindowMain;
    private var _secondCashWindow:WindowMain;
    private var _nextWindow:Object;
    protected var g:Vars = Vars.getInstance();

    public function WindowsManager() {}

    public function get currentWindow():WindowMain { return _currentWindow;}

    public function openWindow(type:String, callback:Function=null, ...params):void {
        if (g.toolsModifier.modifierType != ToolsModifier.NONE) {
            g.bottomPanel.cancelBoolean(false);
            g.toolsModifier.modifierType = ToolsModifier.NONE;
            g.toolsModifier.cancelMove();
            g.buyHint.hideIt();
        }

        if (_currentWindow) {
            if (_currentWindow.windowType == WO_GAME_ERROR || _currentWindow.windowType == WO_RELOAD_GAME || _currentWindow.windowType == WO_SERVER_ERROR
                    || _currentWindow.windowType == WO_ANOTHER_GAME_ERROR || _currentWindow.windowType == WO_SERVER_CRACK) return;
            if (type == WO_GAME_ERROR || type == WO_RELOAD_GAME || type == WO_SERVER_ERROR || type == WO_ANOTHER_GAME_ERROR || type == WO_SERVER_CRACK) {
                closeAllWindows();
            } else {
                Cc.info("is open another window:: _currentWindow type: " + _currentWindow.windowType);
                _nextWindow = {};
                _nextWindow.type = type;
                _nextWindow.callback = callback;
                _nextWindow.paramsArray = params;
                return;
            }
        }
        var wo:WindowMain;
        switch (type) {
            case WO_GAME_ERROR:
                wo = new WOGameError();
                break;
            case WO_NO_FREE_CATS:
                wo = new WONoFreeCats();
                break;
            case WO_WAIT_FREE_CATS:
                wo = new WOWaitFreeCats();
                break;
            case WO_BUY_COUPONE:
                wo = new WOBuyCoupone();
                break;
            case WO_AMBAR_FILLED:
                wo = new WOAmbarFilled();
                break;
            case WO_RELOAD_GAME:
                wo = new WOReloadGame();
                break;
            case WO_SERVER_ERROR:
                wo = new WOServerError();
                break;
            case WO_SERVER_NO_WORK:
                wo = new WOSeverNoWork();
                break;
            case WO_BUY_CURRENCY:
                wo = new WOBuyCurrency();
                break;
            case WO_BUY_CAVE:
                wo = new WOBuyCave();
                break;
            case WO_BUY_FOR_HARD:
                wo = new WOBuyForHardCurrency();
                break;
            case WO_DAILY_BONUS:
                wo = new WODailyBonus();
                break;
            case WO_LAST_RESOURCE:
                wo = new WOLastResource();
                break;
            case WO_LEVEL_UP:
                wo = new WOLevelUp();
                break;
            case WO_LOCKED_LAND:
                wo = new WOLockedLand();
                break;
            case WO_NO_PLACES:
                wo = new WONoPlaces();
                break;
            case WO_NO_RESOURCES:
                wo = new WONoResources();
                break;
            case WO_AMBAR:
                wo = new WOAmbars();
                break;
            case WO_BUY_PLANT:
                wo = new WOBuyPlant();
                break;
            case WO_CAVE:
                wo = new WOCave();
                break;
            case WO_FABRICA:
                wo = new WOFabrica();
                break;
            case WO_MARKET:
                wo = new WOMarket();
                break;
            case WO_MARKET_CHOOSE:
                wo = new WOMarketChoose();
                break;
            case WO_MARKET_DELETE_ITEM:
                wo = new WOMarketDeleteItem();
                break;
            case WO_PAPPER:
                wo = new WOPapper();
                break;
            case WO_ORDERS:
                wo = new WOOrder();
                break;
            case WO_TRAIN:
                wo = new WOTrain();
                break;
            case WO_TRAIN_ORDER:
                wo = new WOTrainOrder();
                break;
            case WO_TRAIN_SEND:
                wo = new WOTrainSend();
                break;
            case WO_SHOP:
                wo = new WOShop();
                break;
            case WO_CHEST:
                wo = new WOChest();
                break;
            case WO_INVITE_FRIENDS:
                wo = new WOInviteFriends();
                break; 
            case WO_INVITE_FRIENDS_VIRAL_INFO:
                wo = new WOInviteFriendsViralInfo();
                break;
            case POST_OPEN_LAND:
                wo = new PostOpenLand();
                break;
            case POST_OPEN_TRAIN:
                wo = new PostOpenTrain();
                break;
            case POST_OPEN_CAVE:
                wo = new PostOpenCave();
                break;
            case POST_OPEN_FABRIC:
                wo = new PostOpenFabric();
                break;
            case POST_DONE_ORDER:
                wo = new PostDoneOrder();
                break;
            case POST_DONE_TRAIN:
                wo = new PostDoneTrain();
                break;
            case WO_ANOTHER_GAME_ERROR:
                wo = new WOAnotherGame();
                break;
            case WO_SERVER_CRACK:
                wo = new WOServerCrack();
                break;
            case WO_TIPS:
                wo = new WOTips();
                break;
            case WO_QUEST:
                wo = new WOQuest();
                break;
            case WO_QUEST_LIST:
                wo = new WOQuestList();
                break;
            case WO_QUEST_AWARD:
                wo = new WOQuestFinishAward();
                break;
            case WO_DAILY_GIFT:
                wo = new WODailyGift();
                break;
            case WO_BUYER_NYASHUK:
                wo = new WOBuyerNyashuk();
                break;
            case WO_CHEST_YELLOW:
                wo = new WOChestYellow();
                break;
            case WO_STARTER_PACK:
                wo = new WOStarterPack();
                break;
            case WO_PARTY:
                wo = new WOPartyWindow();
                break;
            case WO_PARTY_HELP:
                wo = new WOPartyHelp();
                break;
            case WO_PARTY_CLOSE:
                wo = new WOPartyWindowClose();
                break;
            case WO_FABRIC_DELETE_ITEM:
                wo = new WOFabricDeleteItem();
                break;
            case WO_SALE_PACK:
                wo = new WOSalePack();
                break;
            case WO_ACHIEVEMENT:
                wo = new WOAchievement();
                break;
            case WO_MISS_YOU:
                wo = new WOMissYou();
                break;
            case WO_ANNOUNCEMENT:
                wo = new WOAnnouncement();
                break;
            default:
                Cc.error('WindowsManager:: unknown window type: ' + type);
                break;
        }
        Cc.info('try open wo: ' + type);
        wo.showItParams(callback, params);
        _currentWindow = wo;
        if (g.managerHelpers) g.managerHelpers.stopIt();
    }

    public function hideWindow(type:String):void {
        if (_currentWindow && _currentWindow.windowType == type) {
            _currentWindow.isCashed = false;
            _currentWindow.hideIt();
        }
    }

    public function onHideWindow(hiddenWindow:WindowMain):void {
        if (hiddenWindow.windowType != WO_QUEST && g.managerQuest) g.managerQuest.clearActiveTask();
        if (g.managerHelpers) g.managerHelpers.checkIt();
        _currentWindow = null;
        if (_nextWindow) {
            openWindow.apply(null, [_nextWindow.type, _nextWindow.callback].concat(_nextWindow.paramsArray));
            _nextWindow = null;
            return;
        }
        if (_secondCashWindow && _secondCashWindow != hiddenWindow) {
            releaseSecondCashWindow();
            return;
        }
        if (!_currentWindow && !_secondCashWindow && _cashWindow && _cashWindow != hiddenWindow) {
            releaseCashWindow();
        }
    }

    public function uncasheWindow():void {
        if (_cashWindow) {
            _cashWindow.isCashed = false;
            _cashWindow.hideIt();
            _cashWindow = null;
        }
    }

    public function uncasheSecondWindow():void {
        if (_secondCashWindow) {
            _secondCashWindow.isCashed = false;
            _secondCashWindow.hideIt();
            _secondCashWindow = null;
        }
    }

    public function set cashWindow(wo:WindowMain):void {
        if (_cashWindow) uncasheWindow();
        _cashWindow = wo;
        wo.isCashed = true;
    }

    public function set secondCashWindow(wo:WindowMain):void {
        if (_secondCashWindow) {
            _secondCashWindow.isCashed = false;
            _secondCashWindow = null;
        }
        _secondCashWindow = wo;
        if (wo) wo.isCashed = true;
    }

    public function releaseCashWindow():void {
        if (_cashWindow) {
            _cashWindow.releaseFromCash();
            _currentWindow = _cashWindow;
            _currentWindow.isCashed = false;
            _cashWindow = null;
        }
    }

    public function releaseSecondCashWindow():void {
        if (_secondCashWindow) {
            _secondCashWindow.releaseFromCash();
            _currentWindow = _secondCashWindow;
            _currentWindow.isCashed = false;
            _secondCashWindow = null;
        }
    }

    public function onResize():void {
        if (_currentWindow) _currentWindow.onResize();
        if (_cashWindow) _cashWindow.onResize();
    }

    public function closeAllWindows():void {
        uncasheWindow();
        uncasheSecondWindow();
        _nextWindow = null;
        if (_currentWindow) _currentWindow.hideItQuick();
    }


}
}
