/**
 * Created by user on 7/2/18.
 */
package windows.buyEnergy {
import data.DataMoney;

import manager.ManagerFilters;

import starling.display.Sprite;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;

import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.buyCoupone.WOBuyCouponeItem;

public class WOBuyEnergy extends WindowMain {
    private var _Green:WOBuyEnergyItem;
    private var _Blue:WOBuyEnergyItem;
    private var _Red:WOBuyEnergyItem;
    private var _Yellow:WOBuyEnergyItem;
    private var _woBG:WindowBackgroundNew;
    private var _bigYellowBG:BackgroundYellowOut;
    private var _txt:CTextField;
    private var _txtHave:CTextField;
    private var _txtWindowName:CTextField;

    public function WOBuyEnergy() {
        _woWidth = 700;
        _woHeight = 510;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight,115);
        _source.addChild(_woBG);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
//        _bigYellowBG = new BackgroundYellowOut(624, 160);
//        _bigYellowBG.x = -_bigYellowBG.width/2;
//        _bigYellowBG.y = -35;
//        _source.addChild(_bigYellowBG);

        _txtWindowName = new CTextField(300, 50, g.managerLanguage.allTexts[1154]);
        _txtWindowName.setFormat(CTextField.BOLD72, 70, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtWindowName.x = -150;
        _txtWindowName.y = -_woHeight/2 + 35;
        _source.addChild(_txtWindowName);
        _txt = new CTextField(800,120,String(g.managerLanguage.allTexts[455]));
        _txt.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW);
//        _txt = new CTextField(400,100,String(g.managerLanguage.allTexts[455]));
//        _txt.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txt.x = -400;
        _txt.y = -160;
        _source.addChild(_txt);
        _txtHave = new CTextField(800,120,String(g.managerLanguage.allTexts[1149]));
//        _txtHave.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
////        _txt = new CTextField(400,100,String(g.managerLanguage.allTexts[455]));
////        _txt.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BLUE_COLOR);
//        _txtHave.x = -400;
//        _txtHave.y = -75;
//        _source.addChild(_txtHave);
    }

    override public function showItParams(callback:Function, params:Array):void {
        _Green = new WOBuyEnergyItem(g.user.greenCouponCount,15,DataMoney.GREEN_COUPONE);
        _Green.source.x = -225;
        _Green.source.y = 80;
        _source.addChild(_Green.source);
        _Blue = new WOBuyEnergyItem(g.user.blueCouponCount,30,DataMoney.BLUE_COUPONE);
        _Blue.source.x = -115;
        _Blue.source.y = 80;
        _source.addChild(_Blue.source);
        _Red = new WOBuyEnergyItem( g.user.redCouponCount, 45,DataMoney.RED_COUPONE);
        _Red.source.x = 105;
        _Red.source.y = 80;
        _source.addChild(_Red.source);
        _Yellow = new WOBuyEnergyItem(g.user.yellowCouponCount,60,DataMoney.YELLOW_COUPONE);
        _Yellow.source.x = -5;
        _Yellow.source.y = 80;
        _source.addChild(_Yellow.source);
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