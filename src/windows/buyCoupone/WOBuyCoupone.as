/**
 * Created by user on 7/15/15.
 */
package windows.buyCoupone {
import data.DataMoney;
import manager.ManagerFilters;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

import windows.WOComponents.WindowBackground;
import windows.WOComponents.WindowBackgroundNew;
import windows.WOComponents.YellowBackgroundOut;
import windows.WindowMain;

public class WOBuyCoupone extends WindowMain{
    private var _Green:WOBuyCouponeItem;
    private var _Blue:WOBuyCouponeItem;
    private var _Red:WOBuyCouponeItem;
    private var _Yellow:WOBuyCouponeItem;
    private var _woBG:WindowBackgroundNew;
    private var _bigYellowBG:YellowBackgroundOut;
    private var _txt:CTextField;
    private var _txtHave:CTextField;

    public function WOBuyCoupone() {
        _woWidth = 820;
        _woHeight = 520;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,125);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _bigYellowBG = new YellowBackgroundOut(624, 160);
        _bigYellowBG.x = -_bigYellowBG.width/2;
        _bigYellowBG.y = -25;
        _source.addChild(_bigYellowBG);
        _txt = new CTextField(800,120,String(g.managerLanguage.allTexts[455]));
        _txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
//        _txt = new CTextField(400,100,String(g.managerLanguage.allTexts[455]));
//        _txt.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -400;
        _txt.y = -150;
        _source.addChild(_txt);
        _txtHave = new CTextField(800,120,String(g.managerLanguage.allTexts[1149]));
        _txtHave.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
//        _txt = new CTextField(400,100,String(g.managerLanguage.allTexts[455]));
//        _txt.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtHave.x = -400;
        _txtHave.y = -65;
        _source.addChild(_txtHave);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _Green = new WOBuyCouponeItem("green_coupone", g.user.greenCouponCount,15,DataMoney.GREEN_COUPONE);
        _Green.source.x = -225;
        _Green.source.y = 90;
        _source.addChild(_Green.source);
        _Blue = new WOBuyCouponeItem("blue_coupone", g.user.blueCouponCount,30,DataMoney.BLUE_COUPONE);
        _Blue.source.x = -115;
        _Blue.source.y = 90;
        _source.addChild(_Blue.source);
        _Yellow = new WOBuyCouponeItem("yellow_coupone", g.user.yellowCouponCount,45,DataMoney.YELLOW_COUPONE);
        _Yellow.source.x = -5;
        _Yellow.source.y = 90;
        _source.addChild(_Yellow.source);
        _Red = new WOBuyCouponeItem("red_coupone", g.user.redCouponCount,60,DataMoney.RED_COUPONE);
        _Red.source.x = 105;
        _Red.source.y = 90;
        _source.addChild(_Red.source);
        super.showIt();
    }

    override protected function deleteIt():void {
        _source.removeChild(_woBG);
        _woBG.deleteIt();
        _woBG = null;
        _txt.deleteIt();
        _txt = null;
        _source.removeChild(_Green.source);
        _source.removeChild(_Red.source);
        _source.removeChild(_Blue.source);
        _source.removeChild(_Yellow.source);
        _Green.deleteIt();
        _Blue.deleteIt();
        _Yellow.deleteIt();
        _Red.deleteIt();
        _Green = null;
        _Blue = null;
        _Yellow = null;
        _Red = null;
        super.deleteIt();
    }
}
}
