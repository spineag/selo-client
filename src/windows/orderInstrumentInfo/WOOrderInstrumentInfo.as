/**
 * Created by andy on 11/22/18.
 */
package windows.orderInstrumentInfo {
import data.StructureDataResource;
import manager.ManagerFilters;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.utils.Color;
import utils.CTextField;
import utils.MCScaler;
import windows.WOComponents.BackgroundYellowOut;
import windows.WOComponents.WindowBackgroundNew;
import windows.WindowMain;
import windows.WindowsManager;

public class WOOrderInstrumentInfo  extends WindowMain {
    private var _woBG:WindowBackgroundNew;
    private var _cont:Sprite;
    private var _txt1:CTextField;
    private var _txt2:CTextField;

    public function WOOrderInstrumentInfo() {   
        super();
        _windowType = WindowsManager.WO_ORDER_INSTRUMENT_INFO;
        _woHeight = 350;
        _woWidth = 530;
        _woBG = new WindowBackgroundNew(_woWidth, _woHeight, 83);
        _source.addChild(_woBG);
        var c:BackgroundYellowOut = new BackgroundYellowOut(492, 248);
        c.x = -_woWidth/2 + 19;
        c.y = -_woHeight/2 + 84;
        _source.addChild(c);
        createExitButton(hideIt);
        _callbackClickBG = hideIt;
        _cont = new Sprite();
        _source.addChild(_cont);

        _txt1 = new CTextField(_woWidth,84,String(g.managerLanguage.allTexts[1738]));
        _txt1.setFormat(CTextField.BOLD72, 40, ManagerFilters.WINDOW_COLOR_YELLOW, ManagerFilters.BLUE_COLOR);
        _txt1.x = -_woWidth/2;
        _txt1.y = -_woHeight/2;
        _source.addChild(_txt1);

        _txt2 = new CTextField(490,90,String(g.managerLanguage.allTexts[1739]));
        _txt2.setFormat(CTextField.BOLD24, 24, ManagerFilters.LIGHT_BLUE_COLOR, ManagerFilters.LIGHT_YELLOW_COLOR);
        _txt2.x = -245;
        _txt2.y = -_woHeight/2 + 89;
        _source.addChild(_txt2);
    }

    override public function showItParams(callback:Function, params:Array):void {
        var ar:Array = [1,5,6,125,124,47];
        var im:Image;
        var d:StructureDataResource;
        var q:Quad = new Quad(454, 112, Color.WHITE);
        _cont.addChild(q);
        for (var i:int=0;i<6;i++){
            d = g.allData.getResourceById(ar[i]);
            im = new Image(g.allData.atlas[d.url].getTexture(d.imageShop));
            MCScaler.scale(im, 70, 70);
            im.alignPivot();
            im.x = 17 + 35 + 70*i;
            im.y = 53;
            _cont.addChild(im);
        }
        _cont.x = -227;
        _cont.y = 15;
        super.showIt();
    }

    override protected function deleteIt():void {
        if (_txt1) {
            _source.removeChild(_txt1);
            _txt1.deleteIt();
            _txt1 = null;
        }
        if (_txt2) {
            _source.removeChild(_txt2);
            _txt2.deleteIt();
            _txt2 = null;
        }
        if (_woBG) {
            _source.removeChild(_woBG);
            _woBG.deleteIt();
            _woBG = null;
        }
        super.deleteIt();
    }
    

}
}
