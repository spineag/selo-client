/**
 * Created by andy on 9/1/17.
 */
package windows.shop_new {
import windows.WOComponents.WhiteBackgroundIn;
import windows.WOComponents.WindowBackgroundNew;
import windows.WOComponents.YellowBackgroundOut;
import windows.WindowMain;
import windows.WindowsManager;

public class WOShopNew extends WindowMain {
    public static const VILLAGE:int=1;
    public static const ANIMAL:int=2;
    public static const FABRICA:int=3;
    public static const PLANT:int=4;
    public static const DECOR:int=5;
    
    private var _bigYellowBG:YellowBackgroundOut;
    private var t:WhiteBackgroundIn;
    
    public function WOShopNew() {
        super();
        _windowType = WindowsManager.WO_SHOP_NEW;
        _woWidth = 988;
        _woHeight = 676;
        _woBGNew = new WindowBackgroundNew(_woWidth, _woHeight, 154);
        _source.addChild(_woBGNew);
        createExitButton(onClickExit);
        _callbackClickBG = onClickExit;

        _bigYellowBG = new YellowBackgroundOut(868, 486);
        _bigYellowBG.x = -434;
        _bigYellowBG.y = -184;
        _source.addChild(_bigYellowBG);

        t = new WhiteBackgroundIn(300, 200);
        t.x = -400;
        t.y = -170;
        _source.addChild(t);
    }

    private function onClickExit():void {}

    override public function showItParams(callback:Function, params:Array):void {
        super.showIt();
    }
}
}
