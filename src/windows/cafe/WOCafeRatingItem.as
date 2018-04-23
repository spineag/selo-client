/**
 * Created by user on 4/18/18.
 */
package windows.cafe {
import manager.ManagerFilters;
import manager.Vars;

import starling.display.Image;
import starling.display.Sprite;
import starling.utils.Align;
import starling.utils.Color;

import utils.CButton;

import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.BackgroundQuest;
import windows.WOComponents.BackgroundQuestDone;

import windows.WOComponents.BackgroundYellowOut;

public class WOCafeRatingItem {
    public var source:Sprite;
    private var _ava:Image;
    private var _ramka:Image;
    private var _txtName:CTextField;
    private var _txtCount:CTextField;
    private var _txtNumber:CTextField;
    private var _goAway:CButton;
    private var g:Vars = Vars.getInstance();

    public function WOCafeRatingItem(number:int, userId:int, count:int) {
        source = new Sprite();
        if (number%2 == 0) {
            var bgD:BackgroundQuestDone = new BackgroundQuestDone(600, 100);
            source.addChild(bgD);
        } else {
            var bg:BackgroundQuest = new BackgroundQuest(600, 100);
            source.addChild(bg);
        }
        _txtName = new CTextField(500, 70, 'Александр Мальярников');
        _txtName.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtName.alignH = Align.LEFT;
        source.addChild(_txtName);
        _txtName.x = 100;
        _txtName.y = -10;
        _txtCount = new CTextField(500, 70, count +' Блюд');
        _txtCount.setFormat(CTextField.BOLD30, 30, Color.WHITE, ManagerFilters.WINDOW_STROKE_BLUE_COLOR);
        _txtCount.alignH = Align.LEFT;
        source.addChild(_txtCount);
        _txtCount.x = 100;
        _txtCount.y = 35;
        _txtNumber = new CTextField(500, 70, String(int(number)));
        _txtNumber.setFormat(CTextField.BOLD30, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtNumber.alignH = Align.CENTER;
        source.addChild(_txtNumber);
        _txtNumber.x = -201;
        _txtNumber.y = -22;
        _goAway = new CButton();
        _goAway.addButtonTexture(100, CButton.HEIGHT_55, CButton.GREEN, true);
        _goAway.addTextField(100, 49, 0, 0, String(g.managerLanguage.allTexts[358]));
        _goAway.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
        _goAway.x = 540;
        _goAway.y = 50;
        source.addChild(_goAway);
        _ava = new Image(g.allData.atlas['interfaceAtlas'].getTexture('default_avatar_big'));
        MCScaler.scale(_ava, 60, 60);
        _ava.x = 20;
        _ava.y = 28;
        source.addChild(_ava);
        if (userId == g.user.userId) _ramka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame_blue'));
        else _ramka = new Image(g.allData.atlas['interfaceAtlas'].getTexture('friend_frame'));
        _ramka.x = 10;
        _ramka.y = 22;
        source.addChild(_ramka);
    }
}
}
