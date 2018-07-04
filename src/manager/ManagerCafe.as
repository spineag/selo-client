/**
 * Created by user on 4/12/17.
 */
package manager {
import user.NeighborBot;

import utils.TimeUtils;

public class ManagerCafe {
    public var arrRating:Array;
    public var playerRatingPosition:int;
    public var playerCount:int;
    public var arrRatingFriend:Array;
    public var objRatingUser:Object;
    private var g:Vars = Vars.getInstance();

    public function ManagerCafe() {
        objRatingUser = {};
        arrRating = [];
        arrRatingFriend = [];
        playerRatingPosition = 0;
        addTimerOnStart();
    }

    public function getFriendArrayUsers():Array {
        var arr:Array = [];
        for (var i:int = 0; i < g.user.arrFriends.length; i++) {
            if(g.user.arrFriends is NeighborBot) continue;
            arr.push(g.user.arrFriends[i].userId);
        }
        arr.push(g.user.userId);
        return arr;
    }

    public function addTimerOnStart():void {
        if (g.user.cafeEnergyTime) {
            if (g.user.cafeEnergyCount < 10) {
                var time:int = TimeUtils.currentSeconds - g.user.cafeEnergyTime;
                var countNeed:int = 10 - g.user.cafeEnergyCount;
                if (countNeed * 3600 <= time) addCafeEnergy(countNeed);
                else {
                    var add:int = 0;
                    for (var i:int = 1; i <= countNeed; i++) {
                        if (i * 3600 > time) {
                            g.userTimer.cafeEnergyTimer(i * 3600 - time);
                            break;
                        }
                        else add++;
                    }
                    addCafeEnergy(add);
                }
            }
        }
    }

    public function addCafeEnergy(count:int):void {
        g.user.cafeEnergyCount = g.user.cafeEnergyCount + count;
        g.server.updateCafeEnergyCount(null);
    }

    public function startNewTimer():void {
        if (g.user.cafeEnergyCount < 10) {
            g.server.updateCafeEnergyTime(null);
            g.userTimer.cafeEnergyTimer(3600)
        }
    }
}
}
