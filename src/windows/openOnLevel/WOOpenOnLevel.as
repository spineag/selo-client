/**
 * Created by user on 2/21/18.
 */
package windows.openOnLevel {
import windows.WindowMain;
import windows.WindowsManager;

public class WOOpenOnLevel extends WindowMain{
    public function WOOpenOnLevel() {
        super ();
        _woWidth = 655;
        _woHeight = 452;
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _windowType = WindowsManager.WO_OPEN_ON_LEVEL;
    }

    override public function showItParams(callback:Function, params:Array):void {
        switch (params[0]) {
            case 'market':
                break;
            case 'paper':
                break;
            case 'dailyBonus':
                break;
            case 'cave':
                break;
            case 'train':
                break;
        }
        super.showIt();
    }
}
}
