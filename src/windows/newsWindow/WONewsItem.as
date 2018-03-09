/**
 * Created by user on 2/20/18.
 */
package windows.newsWindow {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;
import starling.utils.Align;
import starling.utils.Color;

import utils.CSprite;
import utils.CTextField;

public class WONewsItem {
    public var source:CSprite;
    private var _imItem:Image;
    private var _imNew:Image;
    private var _txtName:CTextField;
    private var _txtPrev:CTextField;
    private var _txtMain:CTextField;
    private var _txtPs:CTextField;
    private var _time:CTextField;
    private var g:Vars = Vars.getInstance();

    public function WONewsItem(name:int, imItem:String, txtPrev:int, txtMain:int, txtPs:int, time:String, notification:Boolean) {
        source = new CSprite();
        _imItem = new Image(g.allData.atlas['newsAtlas'].getTexture(imItem));
        _imItem.x = 7;
        _imItem.y = 60;
        source.addChild(_imItem);
        if (notification) {
            _imNew= new Image(g.allData.atlas['interfaceAtlas'].getTexture('new_m'));
            _imNew.x = 465;
            source.addChild(_imNew);
        }
        _txtName = new CTextField(500, 60, g.managerLanguage.allTexts[name]);
        _txtName.setFormat(CTextField.BOLD72, 36, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
//        _txtName.x = -150;
//        _txtName.y = -10;
        source.addChild(_txtName);

        _txtPrev = new CTextField(500, 60, g.managerLanguage.allTexts[txtPrev]);
        _txtPrev.setFormat(CTextField.BOLD30, 26, Color.WHITE, ManagerFilters.BLUE_COLOR);
//        _txtName.x = -150;
        _txtPrev.y = 205;
        source.addChild(_txtPrev);

        _txtMain = new CTextField(480, 90, g.managerLanguage.allTexts[txtMain]);
        _txtMain.setFormat(CTextField.BOLD30, 26, ManagerFilters.BLUE_COLOR, Color.WHITE );
        _txtMain.x = 10;
        _txtMain.y = 260;
        _txtMain.alignH = Align.LEFT;
        source.addChild(_txtMain);

        _txtPs = new CTextField(200, 70, g.managerLanguage.allTexts[txtPs]);
        _txtPs.setFormat(CTextField.BOLD30, 26, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtPs.x = 10;
        _txtPs.y = 370;
        _txtPs.alignH = Align.LEFT;
        source.addChild(_txtPs);

        _time = new CTextField(200, 60, String([time]));
        _time.setFormat(CTextField.BOLD24, 20, ManagerFilters.BLUE_COLOR);
        _time.x = 285;
        _time.y = 398;
        _time.alignH = Align.RIGHT;
        source.addChild(_time);

    }
}
}
