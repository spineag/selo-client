/**
 * Created by user on 7/24/15.
 */
package windows.dailyBonusWindow {


import manager.ManagerDailyBonus;
import manager.ManagerFilters;
import manager.Vars;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.utils.Color;

import utils.CTextField;

import utils.MCScaler;

public class WODailyBonusItem {
    private var g:Vars = Vars.getInstance();
    private var _source:Sprite;
    private var _parent:Sprite;
    private var im:Image;
    private var _txt:CTextField;

    public function WODailyBonusItem(obj:Object, index:int, p:Sprite) {
        _parent = p;

        switch (obj.type) {
            case ManagerDailyBonus.RESOURCE:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(obj.id).imageShop));
                break;
            case ManagerDailyBonus.PLANT:
                im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(obj.id).imageShop + '_icon'));
                break;
            case ManagerDailyBonus.SOFT_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
                break;
            case ManagerDailyBonus.HARD_MONEY:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
                break;
            case ManagerDailyBonus.DECOR:
                im = new Image(g.allData.atlas['decorAtlas'].getTexture(g.allData.getBuildingById(obj.id).image));
                break;
            case ManagerDailyBonus.INSTRUMENT:
                im = new Image(g.allData.atlas['instrumentAtlas'].getTexture(g.allData.getResourceById(obj.id).imageShop));
                break;
            case ManagerDailyBonus.GREEN_VOU:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('green_coupone'));
                break;
            case ManagerDailyBonus.BLUE_VOU:
                im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('blue_coupone'));
                break;
            case ManagerDailyBonus.YELLOW_VOU:
                im = new Image(g.allData.atlas['instrumentAtlas'].getTexture('yellow_coupone'));
                break;
            case ManagerDailyBonus.PURP_VOU:
                im = new Image(g.allData.atlas['instrumentAtlas'].getTexture('red_coupone'));
                break;
        }
        MCScaler.scale(im, 95, 95);
        im.x = -im.width/2;
        im.y = -im.height/2;
//        im.filter = ManagerFilters.SHADOW;
        _source = new Sprite();
        _source.addChild(im);

        switch (index) {
            case 0:
                _source.x = 0;
                _source.y = -182;
                break;
            case 1:
                _source.x = 110;
                _source.y = -148;
                break;
            case 2:
                _source.x = 180;
                _source.y = -60;
                break;
            case 3:
                _source.x = 170;
                _source.y = 55;
                break;
            case 4:
                _source.x = 110;
                _source.y = 155;
                break;
            case 5:
                _source.x = 0;
                _source.y = 190;
                break;
            case 6:
                _source.x = -120;
                _source.y = 155;
                break;
            case 7:
                _source.x = -175;
                _source.y = 60;
                break;
            case 8:
                _source.x = -180;
                _source.y = -60;
                break;
            case 9:
                _source.x = -110;
                _source.y = -148;
                break;
            case 10:
                _source.x = -180;
                _source.y = -60;
                break;
            case 11:
                _source.x = -110;
                _source.y = -148;
                break;
        }

        _source.rotation = (Math.PI/5)*index;
        _parent.addChild(_source);
//        if (obj.type == ManagerDailyBonus.HARD_MONEY || obj.type == ManagerDailyBonus.SOFT_MONEY) {
//            _txt = new CTextField(60, 40, '+'+String(obj.count));
//            _txt.setFormat(CTextField.BOLD24, 20, Color.WHITE, ManagerFilters.BROWN_COLOR);
//            _txt.x = -20;
//            _txt.y = -5;
//            _source.addChild(_txt);
//        }
    }

    public function deleteIt():void {
        im.filter = null;
        if (_txt) {
            _source.removeChild(_txt);
            _txt.deleteIt();
            _txt = null;
        }
        _parent.removeChild(_source);
        _source.dispose();
        _parent = null;
        _source = null;
    }
}
}
