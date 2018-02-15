/**
 * Created by user on 5/26/16.
 */
package manager {
import data.DataMoney;
import flash.geom.Point;
import resourceItem.newDrop.DropObject;
import starling.textures.TextureAtlas;
import ui.inviteFriendPanel.InvitePanelTimer;
import utils.TimeUtils;
import windows.WindowsManager;

public class ManagerInviteFriendViral {
    private var g:Vars = Vars.getInstance();
    private var _timerOpenWO:int;
    private var _levelData:int;
    private var _countFriendsData:int;
    private var _countRubiesData:int;
    private var _timeCancelData:int;
    private var _timeCompleteData:int;
    private var _invitePanelTimer:InvitePanelTimer;
    private var _timerEnd:int;

    public function ManagerInviteFriendViral(d:Object) {
        return;
        _levelData = int(d.user_level);
        _countFriendsData = int(d.count_friends);
        _countRubiesData = int(d.count_rubies);
        _timeCancelData = int(d.cancel_time);
        _timeCompleteData = int(d.complete_time);
        _timerEnd = 5 * 60;
        if (g.user.level >= _levelData) checkIt();
    }

    public function get timerEnd():int { return _timerEnd; }
    public function getCountFriends():int { return _countFriendsData; }
    public function getCountRubies():int { return _countRubiesData; }
    public function onUpdateLevel():void { if (g.user.level == _levelData) checkIt(); }
    public function openWO():void {  g.windowsManager.openWindow(WindowsManager.WO_INVITE_FRIENDS_VIRAL_INFO, onCloseWO); }
    public function updateTimerPanelPosition():void { if (_invitePanelTimer) _invitePanelTimer.updatePosition(); }

    private function checkIt():void {
        if (g.user.nextTimeInvite == 0 || g.user.nextTimeInvite < TimeUtils.currentSeconds) {
            g.load.loadAtlas('inviteAtlas', 'inviteAtlas', startTimer);
        }
    }
    
    private function startTimer():void {
        _timerOpenWO = 30 + int(Math.random()* 60);
        g.gameDispatcher.addToTimer(onTimer);
        if (!_invitePanelTimer) _invitePanelTimer = new InvitePanelTimer();
        updateTimerPanelPosition();
    }

    private function onTimer():void {
        if (_timerOpenWO > 0) {
            _timerOpenWO--;
            if (_timerOpenWO <= 0) {
                openWO();
            }
        }
        _timerEnd--;
        if (_timerEnd < 0) {
            g.gameDispatcher.removeFromTimer(onTimer);
            g.server.updateUserViralInvite(TimeUtils.currentSeconds + _timeCancelData, null);
            onFinishIt();
        }
    }

    private function onCloseWO(ar:Array):void {
        var countInvited:int = ar.length;
        if (countInvited > _countFriendsData) countInvited = _countFriendsData;
        if (countInvited > 0) {
            var d:DropObject = new DropObject();
            d.addDropMoney(DataMoney.HARD_CURRENCY, _countRubiesData * countInvited, new Point(g.managerResize.stageWidth/2 + 30, g.managerResize.stageHeight/2 + 30));
            d.releaseIt(null, false);
            g.server.updateUserViralInvite(TimeUtils.currentSeconds + _timeCompleteData, null);
            onFinishIt();
        }
    }

    private function onFinishIt():void {
        if (g.windowsManager.currentWindow && g.windowsManager.currentWindow.windowType == WindowsManager.WO_INVITE_FRIENDS_VIRAL_INFO) {
            g.windowsManager.currentWindow.hideIt();
        }
        if (_invitePanelTimer) {
            _invitePanelTimer.deleteIt();
            _invitePanelTimer = null;
        }
        if (g.allData.atlas['inviteAtlas']) {
            (g.allData.atlas['inviteAtlas'] as TextureAtlas).dispose();
            delete  g.allData.atlas['inviteAtlas'];
        }
    }
}
}
