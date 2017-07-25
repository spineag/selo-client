/**
 * Created by user on 3/8/17.
 */
package manager {

public class ManagerLanguage {
    public static const RUSSIAN:int = 1;
    public static const ENGLISH:int = 2;
    public var allTexts:Object;
    private var g:Vars = Vars.getInstance();
    private var _callback:Function;

    public function ManagerLanguage(f:Function) {
        allTexts = {};
        _callback = f;
        g.directServer.getAllTexts(callbackLoad);
    }

    private function callbackLoad():void {
        if (_callback != null) {
            _callback.apply();
        }
    }

    public function changeLanguage(v:int):void {
        if (g.user.language == v) return;
        if (g.user.language == RUSSIAN) g.user.language = ENGLISH;
            else g.user.language = RUSSIAN;
        g.directServer.changeLanguage(g.socialNetwork.reloadGame);
    }
}
}
