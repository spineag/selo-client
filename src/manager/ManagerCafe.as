/**
 * Created by user on 4/12/17.
 */
package manager {
import user.NeighborBot;

public class ManagerCafe {
    public var arrRating:Array;
    public var playerRatingPosition:int;
    public var arrRatingFriend:Array;
    public var objRatingUser:Object;
    private var g:Vars = Vars.getInstance();

//    public
    public function ManagerCafe() {
        objRatingUser = {};
        arrRating = [];
        arrRatingFriend = [];
        playerRatingPosition = 0;
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

}
}
