/**
 * Created by user on 2/2/17.
 */
package windows.partyWindow {
import data.BuildType;
import data.DataMoney;
import flash.geom.Point;
import manager.ManagerFilters;
import manager.Vars;
import resourceItem.newDrop.DropObject;
import starling.display.Image;
import starling.display.Quad;
import starling.utils.Align;
import starling.utils.Color;
import utils.CButton;
import utils.CSprite;
import utils.CTextField;
import utils.MCScaler;

import windows.WOComponents.BackgroundQuestDone;

public class WOPartyWindowItem {
    public var source:CSprite;
    private var _bg:BackgroundQuestDone;
    private var _sprItem:CSprite;
    private var _btn:CButton;
    private var _txtBtn:CTextField;
    private var _txtCountResource:CTextField;
    private var _txtCountToGift:CTextField;
    private var _txtCountUser:CTextField;
    private var g:Vars = Vars.getInstance();
    private var _data:Object;
    private var _imCheck:Image;
    private var _bgWhite:Image;
    private var _txtDescription:CTextField;

    public function WOPartyWindowItem(id:int, type:int, countResource:int, countToGift:int, number:int) {
        source = new CSprite();
        _sprItem = new CSprite();
        _btn = new CButton();
        _data = {};
        _data.idResource = id;
        _data.typeResource = type;
        _data.countResource = countResource;
        _data.countToGift = countToGift;
        _data.number = number;
        _bg = new BackgroundQuestDone(700, 110);
        source.addChild(_bg);
        _txtCountResource = new CTextField(119,100,' ');
        _txtCountResource.setFormat(CTextField.BOLD18, 18, Color.WHITE, ManagerFilters.BLUE_COLOR);
        _txtCountResource.alignH = Align.RIGHT;
        _txtCountResource.x = 570;
        _txtCountResource.y = -35;
        _bgWhite = new Image(g.allData.atlas['partyAtlas'].getTexture('ne_window_white_cell'));
        _bgWhite.x = 5;
        _bgWhite.y = 5;
        source.addChild(_bgWhite);
        var im:Image;
        if (g.allData.getResourceById(g.managerParty.idItemEvent[0]).buildType == BuildType.PLANT) {
            im = new Image(g.allData.atlas['resourceAtlas'].getTexture(g.allData.getResourceById(g.managerParty.idItemEvent[0]).imageShop + '_icon'));
        } else {
            im = new Image(g.allData.atlas[g.allData.getResourceById(g.managerParty.idItemEvent[0]).url].getTexture(g.allData.getResourceById(g.managerParty.idItemEvent[0]).imageShop));
        }
        im.x = 5;
        im.y = 5;
        _sprItem.addChild(im);
        im = new Image(g.allData.atlas['partyAtlas'].getTexture('ne_window_white_cell'));
        im.x = 595;
        im.y = 5;
        _sprItem.addChild(im);
        if (id == 1 && type  == 1) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('coins'));
            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
        } else if (id == 2 && type == 2) {
            im = new Image(g.allData.atlas['interfaceAtlas'].getTexture('rubins'));
            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
        }  else if (type == BuildType.RESOURCE || type == BuildType.INSTRUMENT || type == BuildType.PLANT) {
            im = new Image(g.allData.atlas[g.allData.getResourceById(id).url].getTexture(g.allData.getResourceById(id).imageShop));
            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
            _sprItem.hoverCallback = function():void { g.hint.showIt(String(g.allData.getResourceById(id).name)); };
            _sprItem.outCallback = function():void { g.hint.hideIt(); };
        } else if (type == BuildType.DECOR_ANIMATION) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).url + '_icon'));
            _sprItem.addChild(im);
            _sprItem.hoverCallback = function():void { g.hint.showIt(String(g.allData.getBuildingById(id).name)); };
            _sprItem.outCallback = function():void { g.hint.hideIt(); };
        } else if (type == BuildType.DECOR || type == BuildType.DECOR_TAIL) {
            im = new Image(g.allData.atlas['iconAtlas'].getTexture(g.allData.getBuildingById(id).image +'_icon'));
            _sprItem.addChild(im);
            _txtCountResource.text = String(countResource);
            _sprItem.hoverCallback = function():void { g.hint.showIt(String(g.allData.getBuildingById(id).name)); };
            _sprItem.outCallback = function():void { g.hint.hideIt(); };

        }
        im.x = 645;
        im.y = 45;
        im.alignPivot();
        MCScaler.scale(im, 80, 80);
        source.addChild(_sprItem);
        _btn = new CButton();
        _btn.addButtonTexture(100, CButton.HEIGHT_32, CButton.GREEN, true);
        _btn.addTextField(100, 31, 0, 0, String(g.managerLanguage.allTexts[358]));
        _btn.setTextFormat(CTextField.BOLD24, 24, Color.WHITE, ManagerFilters.GREEN_COLOR);
        source.addChild(_btn);
        _btn.x = 645;
        _btn.y = 90;
        _btn.clickCallback = onClick;
        if (!Boolean(g.managerParty.userParty[0].tookGift[_data.number - 1]) && g.managerParty.userParty[0].countResource >= _data.countToGift)  {
            _btn.setEnabled = true;
        } else if (Boolean(g.managerParty.userParty[0].tookGift[_data.number - 1])) {
            _btn.setEnabled = false;
//            _btn.visible = false;
            _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
            _imCheck.x = 598;
            _imCheck.y = 5;
            source.addChild(_imCheck);
        } else _btn.setEnabled = false;

        source.addChild(_btn);
        source.addChild(_txtCountResource);
        _txtCountUser = new CTextField(119,100,String(g.managerParty.userParty[0].countResource));
        if (int(g.managerParty.userParty[0].countResource) < countToGift) _txtCountUser.setFormat(CTextField.BOLD30, 30,0xcf342f,Color.WHITE);
        else _txtCountUser.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR,Color.WHITE);
        _txtCountUser.alignH = Align.LEFT;
        _txtCountUser.x = 320;
        _txtCountUser.y = 35;
        source.addChild(_txtCountUser);

        _txtCountToGift = new CTextField(119,100,'/' + String(countToGift));
        _txtCountToGift.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txtCountToGift.alignH = Align.LEFT;
        _txtCountToGift.x = _txtCountUser.x + _txtCountUser.textBounds.width-1;
        _txtCountToGift.y = 35;
        source.addChild(_txtCountToGift);

        var myPattern:RegExp = /count/;
        var str:String =  String(g.managerLanguage.allTexts[g.managerParty.textIdItem]);
        _txtDescription = new CTextField(400,100,String(g.managerLanguage.allTexts[g.managerParty.textIdItem]));
        _txtDescription.text = String(str.replace(myPattern, String(countToGift)));
        _txtDescription.setFormat(CTextField.BOLD24, 24, ManagerFilters.BLUE_LIGHT_NEW, Color.WHITE);
        _txtDescription.alignH = Align.CENTER;
        _txtDescription.x = 150;
        _txtDescription.y = -25;
        source.addChild(_txtDescription);
    }

    public function reload():void {
        source.removeChild(_imCheck);
        source.removeChild(_btn);
        source.removeChild(_txtCountResource);
        source.removeChild(_txtCountToGift);
        source.removeChild(_txtCountUser);
        if (!Boolean(g.managerParty.userParty[0].tookGift[_data.number - 1]) && g.managerParty.userParty[0].countResource >= _data.countToGift)  {
            _btn.setEnabled = true;
        } else if (Boolean(g.managerParty.userParty[0].tookGift[_data.number - 1])) {
            _btn.setEnabled = false;
            _imCheck = new Image(g.allData.atlas['interfaceAtlas'].getTexture('done_icon'));
            _imCheck.x = 598;
            _imCheck.y = 5;
            source.addChild(_imCheck);
        } else _btn.setEnabled = false;
        source.addChild(_btn);
        source.addChild(_txtCountResource);
        _txtCountUser = new CTextField(119,100,String(g.managerParty.userParty[0].countResource));
        if (int(g.managerParty.userParty[0].countResource) < _data.countToGift) _txtCountUser.setFormat(CTextField.BOLD30, 30,0xcf342f,Color.WHITE);
        else _txtCountUser.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR,Color.WHITE);
        _txtCountUser.alignH = Align.LEFT;
        _txtCountUser.x = 325;
        _txtCountUser.y = 35;
        source.addChild(_txtCountUser);

        _txtCountToGift = new CTextField(119,100,'/' + String(_data.countToGift));
        _txtCountToGift.setFormat(CTextField.BOLD30, 30, ManagerFilters.BLUE_COLOR, Color.WHITE);
        _txtCountToGift.alignH = Align.LEFT;
        _txtCountToGift.x = _txtCountUser.x + _txtCountUser.textBounds.width-1;
        _txtCountToGift.y = 35;
        source.addChild(_txtCountToGift);
    }

    private function onClick():void {
        _btn.setEnabled = false;
        g.managerParty.userParty[0].tookGift[_data.number - 1] = 1;
//        var st:String = g.managerParty.userParty.tookGift[0] + '&' + g.managerParty.userParty.tookGift[1] + '&' + g.managerParty.userParty.tookGift[2] + '&'
//                + g.managerParty.userParty.tookGift[3] + '&' + g.managerParty.userParty.tookGift[4];
//        g.server.updateUserParty(st,g.managerParty.userParty.countResource,0, g.managerParty.id, g.managerParty.userParty[0].idParty, null);
        g.managerParty.updateUserParty();
        var p:Point = new Point(g.managerResize.stageWidth/2, g.managerResize.stageHeight/2);
        var d:DropObject = new DropObject();
        if (_data.typeResource == BuildType.DECOR_ANIMATION || _data.typeResource == BuildType.DECOR) {
            d.addDropDecor(g.allData.getBuildingById(_data.idResource), p, _data.countResource, true);
        } else {
            if (_data.idResource == 1 && _data.typeResource == 1)
                d.addDropMoney(DataMoney.SOFT_CURRENCY, _data.countResource, p);
            else if (_data.idResource == 2 && _data.typeResource == 2) 
                d.addDropMoney(DataMoney.HARD_CURRENCY, _data.countResource, p);
            else d.addDropItemNewByResourceId(_data.idResource, p, _data.countResource);
        }
        d.releaseIt(null, false);
    }

    public function deleteIt():void {
        if (_txtBtn) {
            if (_btn) _btn.removeChild(_txtBtn);
            _txtBtn.deleteIt();
            _txtBtn = null;
        }
        if (_btn) {
            source.removeChild(_btn);
            _btn.deleteIt();
            _btn = null;
        }
        if (_txtCountResource) {
            if (source) source.removeChild(_txtCountResource);
            _txtCountResource.deleteIt();
            _txtCountResource = null;
        }
        if (_txtCountToGift) {
            if (source) source.removeChild(_txtCountToGift);
            _txtCountToGift.deleteIt();
            _txtCountToGift = null;
        }
        if(_txtCountUser) {
            if (source) source.removeChild(_txtCountUser);
            _txtCountUser.deleteIt();
            _txtCountUser = null;
        }
        if(_bg) {
            _bg = null;
        }
        if (_data) {
            _data = null;
        }
    }
}
}
