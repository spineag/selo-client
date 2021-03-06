/**
 * Created by user on 1/29/18.
 */
package manager {
import windows.WindowsManager;

public class ManagerStarterPack {
    private var _countSeconds:int;
    private var _bolCanSalePack:Boolean;
    private var g:Vars = Vars.getInstance();

    public function ManagerStarterPack() {
        if (g.user.starterPack==1) _bolCanSalePack = false;
        else _bolCanSalePack = true;
        _countSeconds = 0;
        checkForStart();
    }

    public function onUserAction():void {
        if (g.user.starterPack==1) return;
        if (_bolCanSalePack) {
            _countSeconds = 0;
        }
    }

    public function checkForStart():void {
        if (g.user.level >= 5 && g.user.starterPack == 0 && g.userTimer.starterTimerToEnd == 0 && g.user.timeStarterPack == 0) startIt();
    }

    private function startIt():void {
        if (_bolCanSalePack) {
            _countSeconds = 0;
            g.gameDispatcher.addToTimer(onTimer);
        }
    }

    private function onTimer():void {
        _countSeconds++;
        if (_countSeconds >= 15 && g.user.level >= 5 && g.user.starterPack == 0 && g.userTimer.starterTimerToEnd == 0 && g.user.timeStarterPack == 0 && !g.isAway && !g.managerCutScenes.isCutScene) {
            openWOStarterPack();
        }
    }

    public function openWOStarterPack():void {
        _countSeconds = 0;
        _bolCanSalePack = true;
        g.afterServerStarterPack(true);
        g.userTimer.starterToEnd(259200, true);
        g.server.updateTimeStarterPack(1);
        if (!g.managerCutScenes.isCutScene && !g.miniScenes.isMiniScene && !g.isAway) {
            g.windowsManager.openWindow(WindowsManager.WO_STARTER_PACK, null);
        }
    }
    
    public function onBuyStarterPack():void {
        _bolCanSalePack = false;
        g.user.starterPack = 1;
        g.server.updateStarterPack(null);
        g.gameDispatcher.removeFromTimer(onTimer);
    }
}
}
