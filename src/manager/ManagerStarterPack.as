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
        _bolCanSalePack = true;
        _countSeconds = 0;
        if (g.user.level >= 7 && g.user.starterPack == 0 && g.userTimer.starterTimerToEnd == 0 && g.user.timeStarterPack == 0) startIt();
    }

    public function onUserAction():void {
        if (g.user.salePack) return;
        if (_bolCanSalePack) {
            _countSeconds = 0;
        }
    }

    private function startIt():void {
        if (_bolCanSalePack) {
            _countSeconds = 0;
            g.gameDispatcher.addToTimer(onTimer);
        }
    }

    private function onTimer():void {
        _countSeconds++;
        if (_countSeconds >= 30 && g.user.level >= 7 && g.user.starterPack == 0 && g.userTimer.starterTimerToEnd == 0 && g.user.timeStarterPack == 0) {
            _countSeconds = 0;
            _bolCanSalePack = true;
            g.afterServerStarterPack(true);
            g.userTimer.starterToEnd(604800, true);
            g.server.updateTimeStarterPack(1);
            g.windowsManager.openWindow(WindowsManager.WO_STARTER_PACK, null);
        }
    }
}
}
