/**
 * Created by user on 4/20/16.
 */
package user {
import order.OrderCat;
import order.OrderItemStructure;
import manager.Vars;

import ui.stock.StockPanel;

import utils.TimeUtils;
import utils.Utils;

import windows.WindowsManager;

public class UserTimer {
    public var papperTimerAtMarket:int;
    public var timerAtPapper:int;
    public var timerAtNyashukRed:int;
    public var timerAtNyashukBlue:int;
    public var _arrOrderItem:Array;
    private var _orderManagerItem:OrderItemStructure;
    private var g:Vars = Vars.getInstance();
    public var partyToEndTimer:int;
    public var partyToStartTimer:int;
    public var saleTimerToEnd:int;
    public var saleTimerToStart:int;
    public var stockTimerToEnd:int;
    public var stockTimerToStart:int;
    public var starterTimerToEnd:int;
    public var starterTimerToStart:int;
    public var miniPartyToEndTimer:int;
    public var miniPartyToStartTimer:int;
    public var cafeTimer:int;

    public function UserTimer() {
        _arrOrderItem = [];
    }

    public function startUserMarketTimer(time:int):void {
        papperTimerAtMarket = time;
        g.gameDispatcher.addToTimer(onMarketTimer);
    }

    private function onMarketTimer():void {
        papperTimerAtMarket--;
        if (papperTimerAtMarket <= 0) {
            papperTimerAtMarket = 0;
            g.gameDispatcher.removeFromTimer(onMarketTimer);
        }
    }

    public function startUserPapperTimer(time:int):void {
        timerAtPapper = time;
        g.gameDispatcher.addToTimer(onPapperTimer);
    }

    private function onPapperTimer():void {
        timerAtPapper--;
        if (timerAtPapper <= 0) {
            timerAtPapper = 0;
            g.gameDispatcher.removeFromTimer(onPapperTimer);
        }
    }

    public function setOrder(manager:OrderItemStructure):void {
        _arrOrderItem.push(manager);
    }

    public function buyerNyashukRed(time:int):void {
        timerAtNyashukRed = time;
        g.gameDispatcher.addToTimer(nyashukTimerRed);
    }

    private function nyashukTimerRed():void {
        timerAtNyashukRed--;
        if (timerAtNyashukRed <= 0 && !g.isAway) {
            timerAtNyashukRed = 0;
            g.managerBuyerNyashuk.timeToNewNyashuk();
            g.gameDispatcher.removeFromTimer(nyashukTimerRed);
        }
    }

     public function buyerNyashukBlue(time:int):void {
        timerAtNyashukBlue = time;
        g.gameDispatcher.addToTimer(nyashukTimerBlue);
    }

    private function nyashukTimerBlue():void {
        timerAtNyashukBlue--;

        if (timerAtNyashukBlue <= 0 && !g.isAway) {
            timerAtNyashukBlue = 0;
            g.managerBuyerNyashuk.timeToNewNyashuk();
            g.gameDispatcher.removeFromTimer(nyashukTimerBlue);
        }
    }

    public function partyToEnd(time:int):void {
        partyToEndTimer = time;
        g.gameDispatcher.addToTimer(partyTimerToEnd);
    }

    private function partyTimerToEnd():void {
        partyToEndTimer--;
        if (partyToEndTimer <= 0) {
            partyToEndTimer = 0;
            g.managerParty.eventOn = false;
            g.managerParty.findDataParty(true);
            g.gameDispatcher.removeFromTimer(partyTimerToEnd);
        }
    }

    public function partyToStart(time:int):void {
        partyToStartTimer = time;
        g.gameDispatcher.addToTimer(partyTimerToStart);
    }

    private function partyTimerToStart():void {
        partyToStartTimer--;
        if (partyToStartTimer <= 0) {
            g.gameDispatcher.removeFromTimer(partyTimerToStart);
            g.managerParty.checkAndCreateIvent(true);
            partyToStartTimer = 0;
        }
    }

    public function miniPartyToEnd(time:int):void {
        miniPartyToEndTimer = time;
        g.gameDispatcher.addToTimer(miniPartyTimerToEnd);
    }

    private function miniPartyTimerToEnd():void {
        miniPartyToEndTimer--;
        if (miniPartyToEndTimer <= 0) {
            miniPartyToEndTimer = 0;
            g.gameDispatcher.removeFromTimer(miniPartyTimerToEnd);
        }
    }

    public function miniPartyToStart(time:int):void {
        miniPartyToStartTimer = time;
        g.gameDispatcher.addToTimer(miniPartyTimerToStart);
    }

    private function miniPartyTimerToStart():void {
        miniPartyToStartTimer--;
        if (miniPartyToStartTimer <= 0) {
            miniPartyToStartTimer = 0;
            g.managerMiniParty.checkAndCreateIvent();
            g.gameDispatcher.removeFromTimer(miniPartyTimerToStart);
        }
    }

    public function saleToEnd(time:int):void {
        saleTimerToEnd = time;
        g.gameDispatcher.addToTimer(saleTimerToEndF);
    }

    private function saleTimerToEndF():void {
        saleTimerToEnd--;
        if (saleTimerToEnd <= 0) {
            saleTimerToEnd = 0;
            g.gameDispatcher.removeFromTimer(saleTimerToEndF);
        }
    }

    public function starterToEnd(time:int, first:Boolean = false):void {
        starterTimerToEnd = time;
        if (starterTimerToEnd == 0) return;
        if (first) {
            g.gameDispatcher.addToTimer(starterTimerToEndF);
        } else {
            starterTimerToEnd = TimeUtils.currentSeconds - time;
            if (starterTimerToEnd >= 259200) {
                starterTimerToEnd = 0;
                return;
            }
            else starterTimerToEnd = 259200 - (TimeUtils.currentSeconds - time);
            g.gameDispatcher.addToTimer(starterTimerToEndF);
        }
    }

    private function starterTimerToEndF():void {
        starterTimerToEnd--;
        if (starterTimerToEnd <= 0) {
            starterTimerToEnd = 0;
            g.gameDispatcher.removeFromTimer(starterTimerToEndF);
        }
    }

    public function saleToStart(time:int):void {
        saleTimerToStart = time;
        g.gameDispatcher.addToTimer(saleTimerToStartF);
    }

    private function saleTimerToStartF():void {
        saleTimerToStart--;
        if (saleTimerToStart <= 0) {
            saleTimerToStart = 0;
//            g.managerSalePack.sartAfterSaleTimer();
            g.gameDispatcher.removeFromTimer(saleTimerToStartF);
        }
    }

    public function stockToStart(time:int, timeToEnd:int):void {
        stockTimerToStart = time;
        stockTimerToEnd = timeToEnd;
        g.gameDispatcher.addToTimer(stockTimerToStartF);
    }

    private function stockTimerToStartF():void {
        stockTimerToStart--;
        if (stockTimerToStart <= 0) {
            stockTimerToStart = 0;
            g.stockPanel = new StockPanel();
            stockToEnd(stockTimerToEnd);
            g.gameDispatcher.removeFromTimer(stockTimerToStartF);
        }
    }

    public function stockToEnd(time:int):void {
        stockTimerToEnd = time;
        g.gameDispatcher.addToTimer(stockTimerToEndF);
    }

    private function stockTimerToEndF():void {
        stockTimerToEnd--;
        if (stockTimerToEnd <= 0) {
            stockTimerToEnd = 0;
            g.gameDispatcher.removeFromTimer(stockTimerToEndF);
        }
    }

    public function cafeEnergyTimer(time:int):void {
        cafeTimer = time;
        g.gameDispatcher.addToTimer(cafeEnergyTimerEnd);
    }

    private function cafeEnergyTimerEnd():void {
        cafeTimer--;
        if (cafeTimer <= 0) {
            cafeTimer = 0;
            g.managerCafe.addCafeEnergy(1);
            g.managerCafe.startNewTimer();
            g.gameDispatcher.removeFromTimer(cafeEnergyTimerEnd);
        }
    }

    public function newCatOrder(position:int):void {
            var arr:Array = g.managerOrder.arrOrders.slice();
            for (var i:int = 0; i < arr.length; i++) {
                if (arr[i].startTime - TimeUtils.currentSeconds <= 16 && arr[i].delOb && position ==  arr[i].placeNumber) {
//                    g.managerOrder.checkCatId();
                    arr[i].delOb = false;
                    g.managerOrder.checkForFullOrder();
                    break;
                }
            }
        }
//    }
}
}
